From: Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH V5 10/16] s390: zfcp_fc: use sg helper to operate
 scatterlist
Date: Mon, 24 Jun 2019 17:13:24 +0200
Message-ID: <95bfa1fb-d0eb-fc61-ecc0-001ae52a326f@linux.ibm.com>
References: <20190618013757.22401-1-ming.lei@redhat.com>
 <20190618013757.22401-11-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190618013757.22401-11-ming.lei@redhat.com>
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
To: Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, devel@driverdev.osuosl.org, Hannes Reinecke <hare@suse.com>, Benjamin Block <bblock@linux.ibm.com>, Bart Van Assche <bvanassche@acm.org>, linux-s390@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Brian King <brking@us.ibm.com>, Finn Thain <fthain@telegraphics.com.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Juergen E . Fischer" <fischer@norbit.de>, Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Hi Ming,

On 6/18/19 3:37 AM, Ming Lei wrote:
> Use the scatterlist iterators and remove direct indexing of the
> scatterlist array.
> 
> This way allows us to pre-allocate one small scatterlist, which can be
> chained with one runtime allocated scatterlist if the pre-allocated one
> isn't enough for the whole request.
> 
> Cc: Steffen Maier <maier@linux.ibm.com>
> Cc: Benjamin Block <bblock@linux.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Acked-by: Benjamin Block <bblock@linux.ibm.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/s390/scsi/zfcp_fc.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
> index 33eddb02ee30..b018b61bd168 100644
> --- a/drivers/s390/scsi/zfcp_fc.c
> +++ b/drivers/s390/scsi/zfcp_fc.c
> @@ -620,7 +620,7 @@ static void zfcp_fc_sg_free_table(struct scatterlist *sg, int count)
>   {
>   	int i;
>   
> -	for (i = 0; i < count; i++, sg++)
> +	for (i = 0; i < count; i++, sg = sg_next(sg))
>   		if (sg)
>   			free_page((unsigned long) sg_virt(sg));
>   		else
> @@ -641,7 +641,7 @@ static int zfcp_fc_sg_setup_table(struct scatterlist *sg, int count)
>   	int i;
>   
>   	sg_init_table(sg, count);
> -	for (i = 0; i < count; i++, sg++) {
> +	for (i = 0; i < count; i++, sg = sg_next(sg)) {
>   		addr = (void *) get_zeroed_page(GFP_KERNEL);
>   		if (!addr) {
>   			zfcp_fc_sg_free_table(sg, i);
> 

I'm still catching up with emails that came during my vacation, so I'm not 
fully up-to-date on the current state of this and how to bring in potential 
fixups on top.

I think, we also have two more (not so obvious) places in the corresponding 
response/completion code path, where we might need to introduce the proper 
iterator helper:

zfcp_fsf.c:

static int zfcp_fc_eval_gpn_ft(struct zfcp_fc_req *fc_req,
			       struct zfcp_adapter *adapter, int max_entries)
{
	struct scatterlist *sg = &fc_req->sg_rsp;
...
	/* first entry is the header */
	for (x = 1; x < max_entries && !last; x++) {
...
		if (x % (ZFCP_FC_GPN_FT_ENT_PAGE + 1))
...
		else
			acc = sg_virt(++sg);
                                       ^^^^

zfcp_dbf.c:

static u16 zfcp_dbf_san_res_cap_len_if_gpn_ft(char *tag,
					      struct zfcp_fsf_req *fsf,
					      u16 len)
{
	struct scatterlist *resp_entry = ct_els->resp;
...
	/* the basic CT_IU preamble is the same size as one entry in the GPN_FT
	 * response, allowing us to skip special handling for it - just skip it
	 */
	for (x = 1; x < max_entries && !last; x++) {
		if (x % (ZFCP_FC_GPN_FT_ENT_PAGE + 1))
...
		else
			acc = sg_virt(++resp_entry);
                                       ^^^^^^^^^^^^


What do you think?

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
