From: Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH V5 10/16] s390: zfcp_fc: use sg helper to operate
 scatterlist
Date: Tue, 25 Jun 2019 12:51:04 +0200
Message-ID: <93d3d89e-a9ae-691f-d1f8-0463f714957d@linux.ibm.com>
References: <20190618013757.22401-1-ming.lei@redhat.com>
 <20190618013757.22401-11-ming.lei@redhat.com>
 <95bfa1fb-d0eb-fc61-ecc0-001ae52a326f@linux.ibm.com>
 <20190625011902.GA23777@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190625011902.GA23777@ming.t460p>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Finn Thain <fthain@telegraphics.com.au>, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, "Juergen E . Fischer" <fischer@norbit.de>, Dan Carpenter <dan.carpenter@oracle.com>, Benjamin Block <bblock@linux.ibm.com>, Brian King <brking@us.ibm.com>, Michael Schmitz <schmitzmic@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hi Ming,

I don't mind doing this change for zfcp. However, I'm having doubts regarding 
the rationale in the commit description. If I understood your patch series 
correctly from its cover letter (would have been nice to copy the SCSI MQ 
detail part of its core statement in (one of) the patches so it would make its 
way into git log), you plan to make a change to scatterlist allocations *in 
SCSI MQ*.

All zfcp changes in this patch set only refer to zfcp-internal remote port 
discovery, i.e. they neither come from SCSI (internally) nor from block(mq).

zfcp_fc.h:
/**
  * struct zfcp_fc_req - Container for FC ELS and CT requests sent from zfcp
  * @ct_els: data required for issuing fsf command
  * @sg_req: scatterlist entry for request data, refers to embedded @u submember
  * @sg_rsp: scatterlist entry for response data, refers to embedded @u submember
  * @u: request and response specific data

  * @u.gpn_ft: GPN_FT specific data
  * @u.gpn_ft.sg_rsp2: GPN_FT response, not embedded here, allocated elsewhere
  * @u.gpn_ft.req: GPN_FT request

  */
struct zfcp_fc_req {
	struct zfcp_fsf_ct_els				ct_els;
	struct scatterlist				sg_req;
	struct scatterlist				sg_rsp;
	union {

		struct {
			struct scatterlist sg_rsp2[ZFCP_FC_GPN_FT_NUM_BUFS - 1];
			struct zfcp_fc_gpn_ft_req	req;
		} gpn_ft;

	} u;
};

So this should be guaranteed to be a linear unchained scatterlist, 
independently of your SCSI (or block) changes.
Note: Only remote port discovery also uses u.gpn_ft.sg_rsp2 instead of just sg_rsp.
  zfcp_fc_scan_ports(work)
   zfcp_fc_alloc_sg_env(buf_num)
    zfcp_fc_sg_setup_table(&fc_req->sg_rsp, buf_num)
(In fact it's somewhat intricate, because it actually uses sg_rsp and seems to 
rely on the fact that the subsequent sg_rsp2[] gives enough contiguous memory 
to hold buf_num linear scatterlist entries starting with field offset sg_rsp.)
The other cases use single element and thus linear unchained scatterlist with 
sg_rsp (and all cases use sg_req):
Finding symbol: sg_init_one
Database directory: /home/maier/docs/zfcp/tuxmaker/linux/drivers/s390/scsi/
-------------------------------------------------------------------------------
*** zfcp_dbf.c:
zfcp_dbf_san_in_els[601]       sg_init_one(&sg, srb->payload.data, length);
// above tracing part is unrelated to all of scsi/block/zfcp-internal-ct/els
*** zfcp_fc.c:
zfcp_fc_ns_gid_pn_request[388] sg_init_one(&fc_req->sg_req, gid_pn_req, 
sizeof(*gid_pn_req));
zfcp_fc_ns_gid_pn_request[389] sg_init_one(&fc_req->sg_rsp, gid_pn_rsp, 
sizeof(*gid_pn_rsp));
zfcp_fc_adisc[546]             sg_init_one(&fc_req->sg_req, &fc_req->u.adisc.req,
zfcp_fc_adisc[548]             sg_init_one(&fc_req->sg_rsp, &fc_req->u.adisc.rsp,
zfcp_fc_alloc_sg_env[668]      sg_init_one(&fc_req->sg_req, &fc_req->u.gpn_ft.req,
zfcp_fc_gspn[841]              sg_init_one(&fc_req->sg_req, gspn_req, 
sizeof(*gspn_req));
zfcp_fc_gspn[842]              sg_init_one(&fc_req->sg_rsp, gspn_rsp, 
sizeof(*gspn_rsp));
zfcp_fc_rspn[889]              sg_init_one(&fc_req->sg_req, rspn_req, 
sizeof(*rspn_req));
zfcp_fc_rspn[890]              sg_init_one(&fc_req->sg_rsp, rspn_rsp, 
sizeof(*rspn_rsp));
-------------------------------------------------------------------------------

I/O requests from SCSI (MQ) coming through queuecommand have already been safe 
for non-linear chained scatterlists in zfcp:

  zfcp_scsi_queuecommand()
   zfcp_fsf_fcp_cmnd()
    zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, scsi_sglist(scsi_cmnd))
	for (; sg; sg = sg_next(sg)) {

I/O requests from the block layer coming through BSG should also have already 
been safe for non-linear chained scatterlists in zfcp:

  zfcp_fc_exec_bsg_job()
   zfcp_fc_exec_els_job()
    zfcp_fsf_send_els()
     zfcp_fsf_setup_ct_els()
      zfcp_fsf_setup_ct_els_sbals(req, sg_req, sg_resp)
	//depending on hardware features, translate sg into HW control blocks
	if (zfcp_adapter_multi_buffer_active())
         	zfcp_qdio_sbals_from_sg() //for req&resp, see above
         	return 0
	/* use single, unchained SBAL if it can hold the request */
	if (zfcp_qdio_sg_one_sbale(sg_req) && zfcp_qdio_sg_one_sbale(sg_resp))
         	zfcp_fsf_setup_ct_els_unchained() //single element for req&resp
         	return 0
	if (!(feat & FSF_FEATURE_ELS_CT_CHAINED_SBALS))
		return -EOPNOTSUPP;
        zfcp_qdio_sbals_from_sg() for req&resp, see above
   OR
   zfcp_fc_exec_ct_job()
    zfcp_fsf_send_ct()
     zfcp_fsf_setup_ct_els() //see above

If I was not mistaken above, the following could be more descriptive parts of a 
patch/commit description, with hopefully less confusion for anyone having to 
look at zfcp git history a few weeks/months/years from now:

"While not required for this SCSI MQ change regarding scatterlist allocation, 
change all other scatterlist iterators in zfcp to the safe sg_next() even if 
not necessary as these changed zfcp-internal scatterlists are linear and 
unchained. This may avoid confusion about a potential need for conversions in 
the future."


On 6/25/19 3:19 AM, Ming Lei wrote:
> On Mon, Jun 24, 2019 at 05:13:24PM +0200, Steffen Maier wrote:
>> On 6/18/19 3:37 AM, Ming Lei wrote:
>>> Use the scatterlist iterators and remove direct indexing of the
>>> scatterlist array.
>>>
>>> This way allows us to pre-allocate one small scatterlist, which can be
>>> chained with one runtime allocated scatterlist if the pre-allocated one
>>> isn't enough for the whole request.

>>> Acked-by: Benjamin Block <bblock@linux.ibm.com>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> ---
>>>    drivers/s390/scsi/zfcp_fc.c | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
>>> index 33eddb02ee30..b018b61bd168 100644
>>> --- a/drivers/s390/scsi/zfcp_fc.c
>>> +++ b/drivers/s390/scsi/zfcp_fc.c
>>> @@ -620,7 +620,7 @@ static void zfcp_fc_sg_free_table(struct scatterlist *sg, int count)
>>>    {
>>>    	int i;
>>> -	for (i = 0; i < count; i++, sg++)
>>> +	for (i = 0; i < count; i++, sg = sg_next(sg))
>>>    		if (sg)
>>>    			free_page((unsigned long) sg_virt(sg));
>>>    		else
>>> @@ -641,7 +641,7 @@ static int zfcp_fc_sg_setup_table(struct scatterlist *sg, int count)
>>>    	int i;
>>>    	sg_init_table(sg, count);
>>> -	for (i = 0; i < count; i++, sg++) {
>>> +	for (i = 0; i < count; i++, sg = sg_next(sg)) {
>>>    		addr = (void *) get_zeroed_page(GFP_KERNEL);
>>>    		if (!addr) {
>>>    			zfcp_fc_sg_free_table(sg, i);
>>>
>>
>> I'm still catching up with emails that came during my vacation, so I'm not
>> fully up-to-date on the current state of this and how to bring in potential
>> fixups on top.
>>
>> I think, we also have two more (not so obvious) places in the corresponding
>> response/completion code path, where we might need to introduce the proper
>> iterator helper:
>>
>> zfcp_fsf.c:
>>
>> static int zfcp_fc_eval_gpn_ft(struct zfcp_fc_req *fc_req,
>> 			       struct zfcp_adapter *adapter, int max_entries)
>> {
>> 	struct scatterlist *sg = &fc_req->sg_rsp;
>> ...
>> 	/* first entry is the header */
>> 	for (x = 1; x < max_entries && !last; x++) {
>> ...
>> 		if (x % (ZFCP_FC_GPN_FT_ENT_PAGE + 1))
>> ...
>> 		else
>> 			acc = sg_virt(++sg);
>>                                        ^^^^
>>
>> zfcp_dbf.c:
>>
>> static u16 zfcp_dbf_san_res_cap_len_if_gpn_ft(char *tag,
>> 					      struct zfcp_fsf_req *fsf,
>> 					      u16 len)
>> {
>> 	struct scatterlist *resp_entry = ct_els->resp;
>> ...
>> 	/* the basic CT_IU preamble is the same size as one entry in the GPN_FT
>> 	 * response, allowing us to skip special handling for it - just skip it
>> 	 */
>> 	for (x = 1; x < max_entries && !last; x++) {
>> 		if (x % (ZFCP_FC_GPN_FT_ENT_PAGE + 1))
>> ...
>> 		else
>> 			acc = sg_virt(++resp_entry);
>>                                        ^^^^^^^^^^^^
>>
>>
>> What do you think?
> 
> Yeah, looks this one is missed, so we need the following patch:
> 
>  From c9c368308fefbf034d670984fe9746a4181fe514 Mon Sep 17 00:00:00 2001
> From: Ming Lei <ming.lei@redhat.com>
> Date: Tue, 25 Jun 2019 09:15:34 +0800
> Subject: [PATCH] s390: scsi: use sg helper to iterate over scatterlist
> 
> Unlike the legacy I/O path, scsi-mq preallocates a large array to hold
> the scatterlist for each request. This static allocation can consume
> substantial amounts of memory on modern controllers which support a
> large number of concurrently outstanding requests.

Very nice, as it disambiguates which scatterlist allocation this patch set is 
about.

> To facilitate a switch to a smaller static allocation combined with a
> dynamic allocation for requests that need it, we need to make sure all
> SCSI drivers handle chained scatterlists correctly.
> 
> Convert remaining drivers that directly dereference the scatterlist
> array to using the iterator functions.
> 
> Cc: Steffen Maier <maier@linux.ibm.com>

> Cc: Benjamin Block <bblock@linux.ibm.com>

> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux-s390@vger.kernel.org

> Cc: Benjamin Block <bblock@linux.ibm.com>

Minor: duplicate Cc ?

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/s390/scsi/zfcp_dbf.c | 2 +-
>   drivers/s390/scsi/zfcp_fc.c  | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
> index dccdb41bed8c..c7129f5234f0 100644
> --- a/drivers/s390/scsi/zfcp_dbf.c
> +++ b/drivers/s390/scsi/zfcp_dbf.c
> @@ -552,7 +552,7 @@ static u16 zfcp_dbf_san_res_cap_len_if_gpn_ft(char *tag,
>   		if (x % (ZFCP_FC_GPN_FT_ENT_PAGE + 1))
>   			acc++;
>   		else
> -			acc = sg_virt(++resp_entry);
> +			acc = sg_virt(resp_entry = sg_next(resp_entry));
>   
>   		last = acc->fp_flags & FC_NS_FID_LAST;
>   	}
> diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
> index b018b61bd168..5048812ce660 100644
> --- a/drivers/s390/scsi/zfcp_fc.c
> +++ b/drivers/s390/scsi/zfcp_fc.c
> @@ -742,7 +742,7 @@ static int zfcp_fc_eval_gpn_ft(struct zfcp_fc_req *fc_req,
>   		if (x % (ZFCP_FC_GPN_FT_ENT_PAGE + 1))
>   			acc++;
>   		else
> -			acc = sg_virt(++sg);
> +			acc = sg_virt(sg = sg_next(sg));
>   
>   		last = acc->fp_flags & FC_NS_FID_LAST;
>   		d_id = ntoh24(acc->fp_fid);
> 

Apart from above rationale discussion, the code change looks good.

-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
