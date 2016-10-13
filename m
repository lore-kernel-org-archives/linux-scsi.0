From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 02/16] scsi: don't use fc_bsg_job::request and
 fc_bsg_job::reply directly
Date: Thu, 13 Oct 2016 17:15:25 +0200
Message-ID: <2ea07f3f-88eb-b795-fa37-a223bf80e581@linux.vnet.ibm.com>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <b92d12e4f78c4998bc8ad000359c127e673379f3.1476276823.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b92d12e4f78c4998bc8ad000359c127e673379f3.1476276823.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-up>
List-Id: linux-scsi@vger.kernel.org

I'm puzzled.

$ git bisect start fc_bsg master
Bisecting: 8 revisions left to test after this (roughly 3 steps)
[005d51510eee6102636d5dbb06310531c5d46151] scsi: fc: implement kref 
backed reference counting
$ git bisect bad
Bisecting: 3 revisions left to test after this (roughly 2 steps)
[bef6da201de1bb81bb4d9511f9a155862efc251f] scsi: Unify interfaces of 
fc_bsg_jobdone and bsg_job_done
$ git bisect bad
Bisecting: 1 revision left to test after this (roughly 1 step)
[3087864ce3d7282f59021245d8a5f83ef1caef18] scsi: don't use 
fc_bsg_job::request and fc_bsg_job::reply directly
$ git bisect bad
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[81aea44720d22d2e0c4a2613ae8b1c256ef6b0cb] scsi: Get rid of struct 
fc_bsg_buffer
> $ git bisect good
> 3087864ce3d7282f59021245d8a5f83ef1caef18 is the first bad commit
> commit 3087864ce3d7282f59021245d8a5f83ef1caef18
> Author: Johannes Thumshirn <jthumshirn@suse.de>
> Date:   Wed Oct 12 15:06:28 2016 +0200
>
>     scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly
>
>     Don't use fc_bsg_job::request and fc_bsg_job::reply directly, but use
>     helper variables bsg_request and bsg_reply. This will be helpfull  when
>     transitioning to bsg-lib.
>
>     Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>
> :040000 040000 140c4b6829d5cfaec4079716e0795f63f8bc3bd2 0d9fe225615679550be91fbd9f84c09ab1e280fc M	drivers

 From there (on the reverse bisect path) I get the following Oops,
except for the full patch set having another stack trace as in my 
previous mail (dying in zfcp code).

> [   46.942452] Oops: 0004 ilc:2 [#1] [   46.942460] PREEMPT  SMP [   46.942465]
> [   46.942470] Modules linked in: nf_log_ipv6 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit ip6t_REJECT nf_reject_ipv6 xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT nf_reject_ipv4 iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables qeth_l2 ghash_s390 prng ecb aes_s390 des_s390 des_generic sha512_s390 sha256_s390 sha1_s390 sha_common dm_mod qeth ccwgroup zfcp qdio autofs4
> [   46.942547] CPU: 1 PID: 1714 Comm: zfcp_ping Not tainted 4.8.0fcbsg+ #9
> [   46.942550] Hardware name: IBM              2964 N96              702              (z/VM)
> [   46.942556] task: 000000005c988008 task.stack: 000000005d2ec000
> [   46.942560] Krnl PSW : 0704e00180000000 00000000007c91ec[   46.942574]  (fc_bsg_request_handler+0x404/0x4b0)
> [   46.942579]
> [   46.942583]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:000:
> [   46.942598]  RI:0 EA:3
> [   46.942601]
> [   46.942601] Krnl GPRS: 0000000000000000 00000000ffffffcb 0000000000000000 0000000080000001
> [   46.942603]            00000000007c8fe8 0000000064398c68 0000000069f967e8 000000006a3d8008
> [   46.942605]            000000006a5e02c8 00000000698b5490 0000000000000000 0000000000000000
> [   46.942607]            000000006a9ef5f8 0000000000a36840 00000000007c8fe8 000000005d2efa00
> [   46.942619] Krnl Code: 00000000007c91de: e55dc08c0003        clfhsi  140(%r12),3[   46.942622]
> [   46.942622]            00000000007c91e4: a7240004            brc     2,7c91ec
>                          #00000000007c91e8: a7f40001           brc     15,7c91ea[   46.942629]
> [   46.942629]           >00000000007c91ec: 5010b000            st      %r1,0(%r11)
>                           00000000007c91f0: e54cb0040000       mvhi    4(%r11),0[   46.942635]
> [   46.942635]            00000000007c91f6: e54cc08c0004        mvhi    140(%r12),4
>                           00000000007c91fc: b904002c           lgr     %r2,%r12[   46.942643]
> [   46.942643]            00000000007c9200: c0e5ffffe2c0        brasl   %r14,7c5780
> [   46.942646]
> [   46.942647] Call Trace:
> [   46.942650] ([<00000000007c8fe8>] fc_bsg_request_handler+0x200/0x4b0)
> [   46.942656] ([<00000000006b8e0a>] __blk_run_queue+0x52/0x68)
> [   46.942661] ([<00000000006c549a>] blk_execute_rq_nowait+0xf2/0x110)
> [   46.942664] ([<00000000006c557a>] blk_execute_rq+0xa2/0x110)
> [   46.942668] ([<00000000006de0ee>] bsg_ioctl+0x1f6/0x268)
> [   46.942675] ([<000000000036ca20>] do_vfs_ioctl+0x680/0x6d8)
> [   46.942677] ([<000000000036caf4>] SyS_ioctl+0x7c/0xb0)
> [   46.942685] ([<00000000009a541e>] system_call+0xd6/0x270)
> [   46.942687] INFO: lockdep is turned off.
> [   46.942688] Last Breaking-Event-Address:
> [   46.942692]  [<00000000007c91e4>] fc_bsg_request_handler+0x3fc/0x4b0
> [   46.942696]  [   46.942698] Kernel panic - not syncing: Fatal exception: panic_on_oops



On 10/12/2016 03:06 PM, Johannes Thumshirn wrote:
> Don't use fc_bsg_job::request and fc_bsg_job::reply directly, but use
> helper variables bsg_request and bsg_reply. This will be helpfull  when
> transitioning to bsg-lib.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/s390/scsi/zfcp_fc.c      |   9 +-
>  drivers/scsi/bfa/bfad_bsg.c      |  40 +++---
>  drivers/scsi/ibmvscsi/ibmvfc.c   |  22 ++--
>  drivers/scsi/libfc/fc_lport.c    |  23 ++--
>  drivers/scsi/lpfc/lpfc_bsg.c     | 194 +++++++++++++++++-----------
>  drivers/scsi/qla2xxx/qla_bsg.c   | 264 ++++++++++++++++++++++-----------------
>  drivers/scsi/qla2xxx/qla_iocb.c  |   5 +-
>  drivers/scsi/qla2xxx/qla_isr.c   |  46 ++++---
>  drivers/scsi/qla2xxx/qla_mr.c    |  10 +-
>  drivers/scsi/scsi_transport_fc.c |  37 +++---
>  10 files changed, 387 insertions(+), 263 deletions(-)


> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 8ff2067..eafc7555 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3588,9 +3588,10 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
>  {
>  	struct request *req = job->req;
>  	struct request *rsp = req->next_rq;
> +	struct fc_bsg_reply *bsg_reply = job->reply;
>  	int err;
>
> -	err = job->req->errors = job->reply->result;
> +	err = job->req->errors = bsg_reply->result;
>
>  	if (err < 0)
>  		/* we're only returning the result field in the reply */
> @@ -3602,10 +3603,10 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
>  	req->resid_len = 0;
>
>  	if (rsp) {
> -		WARN_ON(job->reply->reply_payload_rcv_len > rsp->resid_len);
> +		WARN_ON(bsg_reply->reply_payload_rcv_len > rsp->resid_len);
>
>  		/* set reply (bidi) residual */
> -		rsp->resid_len -= min(job->reply->reply_payload_rcv_len,
> +		rsp->resid_len -= min(bsg_reply->reply_payload_rcv_len,
>  				      rsp->resid_len);
>  	}
>  	blk_complete_request(req);
> @@ -3701,6 +3702,8 @@ fc_req_to_bsgjob(struct Scsi_Host *shost, struct fc_rport *rport,
>  	struct fc_internal *i = to_fc_internal(shost->transportt);
>  	struct request *rsp = req->next_rq;
>  	struct fc_bsg_job *job;
> +	struct fc_bsg_request *bsg_request;
> +	struct fc_bsg_reply *bsg_reply;
>  	int ret;
>
>  	BUG_ON(req->special);
> @@ -3726,9 +3729,9 @@ fc_req_to_bsgjob(struct Scsi_Host *shost, struct fc_rport *rport,
>  	if (i->f->dd_bsg_size)
>  		job->dd_data = (void *)&job[1];
>  	spin_lock_init(&job->job_lock);
> -	job->request = (struct fc_bsg_request *)req->cmd;
> +	bsg_request = (struct fc_bsg_request *)req->cmd;
>  	job->request_len = req->cmd_len;
> -	job->reply = req->sense;
> +	bsg_reply = req->sense;
>  	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
>  						 * allocated */
>  	if (req->bio) {
> @@ -3779,11 +3782,13 @@ fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
>  			 struct fc_bsg_job *job)
>  {
>  	struct fc_internal *i = to_fc_internal(shost->transportt);
> +	struct fc_bsg_request *bsg_request = job->request;
> +	struct fc_bsg_reply *bsg_reply = job->reply;
>  	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
>  	int ret;
>
>  	/* Validate the host command */
> -	switch (job->request->msgcode) {
> +	switch (bsg_request->msgcode) {
>  	case FC_BSG_HST_ADD_RPORT:
>  		cmdlen += sizeof(struct fc_bsg_host_add_rport);
>  		break;
> @@ -3815,7 +3820,7 @@ fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
>  	case FC_BSG_HST_VENDOR:
>  		cmdlen += sizeof(struct fc_bsg_host_vendor);
>  		if ((shost->hostt->vendor_id == 0L) ||
> -		    (job->request->rqst_data.h_vendor.vendor_id !=
> +		    (bsg_request->rqst_data.h_vendor.vendor_id !=
>  			shost->hostt->vendor_id)) {
>  			ret = -ESRCH;
>  			goto fail_host_msg;
> @@ -3840,8 +3845,8 @@ fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
>  fail_host_msg:
>  	/* return the errno failure code as the only status */
>  	BUG_ON(job->reply_len < sizeof(uint32_t));
> -	job->reply->reply_payload_rcv_len = 0;
> -	job->reply->result = ret;
> +	bsg_reply->reply_payload_rcv_len = 0;
> +	bsg_reply->result = ret;
>  	job->reply_len = sizeof(uint32_t);
>  	fc_bsg_jobdone(job);
>  	return FC_DISPATCH_UNLOCKED;
> @@ -3878,11 +3883,13 @@ fc_bsg_rport_dispatch(struct request_queue *q, struct Scsi_Host *shost,
>  			 struct fc_rport *rport, struct fc_bsg_job *job)
>  {
>  	struct fc_internal *i = to_fc_internal(shost->transportt);
> +	struct fc_bsg_request *bsg_request = job->request;
> +	struct fc_bsg_reply *bsg_reply = job->reply;
>  	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
>  	int ret;
>
>  	/* Validate the rport command */
> -	switch (job->request->msgcode) {
> +	switch (bsg_request->msgcode) {
>  	case FC_BSG_RPT_ELS:
>  		cmdlen += sizeof(struct fc_bsg_rport_els);
>  		goto check_bidi;
> @@ -3915,8 +3922,8 @@ check_bidi:
>  fail_rport_msg:
>  	/* return the errno failure code as the only status */
>  	BUG_ON(job->reply_len < sizeof(uint32_t));
> -	job->reply->reply_payload_rcv_len = 0;
> -	job->reply->result = ret;
> +	bsg_reply->reply_payload_rcv_len = 0;
> +	bsg_reply->result = ret;
>  	job->reply_len = sizeof(uint32_t);
>  	fc_bsg_jobdone(job);
>  	return FC_DISPATCH_UNLOCKED;


> @@ -3937,6 +3944,7 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
>  	struct request *req;
>  	struct fc_bsg_job *job;
>  	enum fc_dispatch_result ret;
> +	struct fc_bsg_reply *bsg_reply;
>
>  	if (!get_device(dev))
>  		return;
> @@ -3973,8 +3981,9 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
>  		/* check if we have the msgcode value at least */
>  		if (job->request_len < sizeof(uint32_t)) {
>  			BUG_ON(job->reply_len < sizeof(uint32_t));
> -			job->reply->reply_payload_rcv_len = 0;
> -			job->reply->result = -ENOMSG;
> +			bsg_reply = job->reply;
> +			bsg_reply->reply_payload_rcv_len = 0;
> +			bsg_reply->result = -ENOMSG;
>  			job->reply_len = sizeof(uint32_t);
>  			fc_bsg_jobdone(job);
>  			spin_lock_irq(q->queue_lock);
>


-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
