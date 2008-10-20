From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support via bsg interface - revised
Date: Mon, 20 Oct 2008 03:59:18 -0700
Message-ID: <D5161DF5-A488-4E02-A4D4-74F5E96CC43A@qlogic.com>
References: <45109B57-BBED-47A8-8183-4F4464D1DBEC@qlogic.com> <20081014112148W.fujita.tomonori@lab.ntt.co.jp> <1FF7A5F2-7B3B-4862-8435-15E3C666D166@qlogic.com> <20081014215239E.fujita.tomonori@lab.ntt.co.jp> <B6F25B51-7CF2-470E-8358-25E3E436593B@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:13880 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYJTK7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Oct 2008 06:59:22 -0400
In-Reply-To: <B6F25B51-7CF2-470E-8358-25E3E436593B@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Smart <James.Smart@Emulex.Com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Robert W Love <robert.w.love@intel.com>


On Oct 14, 2008, at 7:13 AM, Seokmann Ju wrote:

>
> On Oct 14, 2008, at 6:34 AM, FUJITA Tomonori wrote:
>
>> On Tue, 14 Oct 2008 04:44:17 -0700
>> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>>
>>>>> +static int
>>>>> +fc_service_handler(struct Scsi_Host *shost, struct fc_rport  
>>>>> *rport,
>>>>> +			  struct request *req, struct request_queue *q)
>>>>> +{
>>>>> +	int ret;
>>>>> +	struct request *rsp = req->next_rq;
>>>>> +
>>>>> +	if (!rsp) {
>>>>> +		printk(KERN_ERR "ERROR: space for a FC service"
>>>>> +		   " response is missing\n");
>>>>> +		return -EINVAL;
>>>>> +	}
>>>>> +
>>>>> +	if ((req->bio->bi_vcnt > FC_SERVICE_MAX_SG) ||
>>>>> +	    (rsp->bio->bi_vcnt > FC_SERVICE_MAX_SG)) {
>>>>> +		printk(KERN_ERR "ERROR: a FC service"
>>>>> +		    " supports no more than %d SGs\n", FC_SERVICE_MAX_SG);
>>>>> +		return -EINVAL;
>>>>> +	}
>>>>
>>>> This doesn't look correct. bi_vcnt is not related with the number  
>>>> of
>>>> sg. You use scatter-gather for large data transfer. You don't  
>>>> need to
>>>> worry about bi_vcnt.
>>> I see...
>>> Is there is a way to check, then, how many SG entries the service
>>> needs before the blk_rq_map_sg()?
>>
>> As I wrote in the previous mail, via blk_queue_max_hw_segments() and
>> blk_queue_max_phys_segments(), you can tell the block layer the  
>> number
>> of sg segments you can handle.
One more question here...
With addition of a timer into the FC transport layer for fc_service  
handing, the
system seems getting locked up, as below trace shows.
I've been trying to figure out the reasons but not able to do.
It seems like that there is something that I don't know, fundamentally  
about
the timer usage...
Could you please comments on what might be the things causing the  
problem?
---
...
Oct 17 11:53:58 linux-atl-00 kernel: SysRq : Show Regs
Oct 17 11:53:58 linux-atl-00 kernel: CPU 0:
Oct 17 11:53:58 linux-atl-00 kernel: Modules linked in: qla2xxx  
scsi_transport_fc ext3 jbd ipv6 button battery ac loop dm_mod floppy  
e1000 parport_pc lp parport reiserfs piix edd fan thermal processor  
thermal_sys sg sr_mod cdrom ata_piix libata dock sd_mod scsi_mod  
ide_disk ide_core [last unloaded: scsi_transport_fc]
Oct 17 11:53:58 linux-atl-00 kernel: Pid: 4284, comm: a.out Not  
tainted 2.6.27-rc4-smp #9
Oct 17 11:53:58 linux-atl-00 kernel: RIP: 0010:[<ffffffff8023ab34>]   
[<ffffffff8023ab34>] lock_timer_base+0x10/0x4b
Oct 17 11:53:58 linux-atl-00 kernel: RSP: 0018:ffff88012a481c48   
EFLAGS: 00000246
Oct 17 11:53:58 linux-atl-00 kernel: RAX: 0000000000000039 RBX:  
0000000000000000 RCX: ffffffff80507588
Oct 17 11:53:58 linux-atl-00 kernel: RDX: ffffffff80507588 RSI:  
ffff88012a481c80 RDI: ffff88012c4c58f0
Oct 17 11:53:58 linux-atl-00 kernel: RBP: ffff88012ac5e1c0 R08:  
ffffffff80507570 R09: ffff88002803cf10
Oct 17 11:53:58 linux-atl-00 kernel: R10: 0000000000000001 R11:  
0000000000000000 R12: ffff88012c4c58f0
Oct 17 11:53:58 linux-atl-00 kernel: R13: ffff88012c9c6198 R14:  
ffff88012c4c58c0 R15: 0000000100000000
Oct 17 11:53:58 linux-atl-00 kernel: FS:  00007fe1c2a966d0(0000)  
GS:ffffffff80652a00(0000) knlGS:0000000000000000
Oct 17 11:53:58 linux-atl-00 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:  
000000008005003b
Oct 17 11:53:58 linux-atl-00 kernel: CR2: 00007fe1c2812d70 CR3:  
000000012e553000 CR4: 00000000000006e0
Oct 17 11:53:59 linux-atl-00 kernel: DR0: 0000000000000000 DR1:  
0000000000000000 DR2: 0000000000000000
Oct 17 11:53:59 linux-atl-00 kernel: DR3: 0000000000000000 DR6:  
00000000ffff0ff0 DR7: 0000000000000400
Oct 17 11:53:59 linux-atl-00 kernel:
Oct 17 11:53:59 linux-atl-00 kernel: Call Trace:
Oct 17 11:53:59 linux-atl-00 kernel:  [<ffffffff8023ac09>] ?  
__mod_timer+0x2a/0xbf
Oct 17 11:53:59 linux-atl-00 kernel:  [<ffffffffa00cbc36>] ?  
fc_service_dispatch+0x2ad/0x323 [scsi_transport_fc]
Oct 17 11:53:59 linux-atl-00 kernel:  [<ffffffff802fa0f1>] ? elv_insert 
+0xf2/0x220
Oct 17 11:53:59 linux-atl-00 kernel:  [<ffffffff802b0ac4>] ?  
bio_copy_user_iov+0x16f/0x219
Oct 17 11:53:59 linux-atl-00 kernel:  [<ffffffff802fe804>] ?  
blk_execute_rq_nowait+0x5d/0x83
Oct 17 11:53:59 linux-atl-00 kernel:  [<ffffffff802fe8ba>] ?  
blk_execute_rq+0x90/0xba
Oct 17 11:53:59 linux-atl-00 kernel:  [<ffffffff80302edc>] ? bsg_ioctl 
+0x141/0x188
Oct 17 11:53:59 linux-atl-00 kernel:  [<ffffffff80298f85>] ? vfs_ioctl 
+0x21/0x6b
Oct 17 11:53:59 linux-atl-00 kernel:  [<ffffffff8029921e>] ?  
do_vfs_ioctl+0x24f/0x268
Oct 17 11:53:59 linux-atl-00 kernel:  [<ffffffff80299288>] ? sys_ioctl 
+0x51/0x71
Oct 17 11:53:59 linux-atl-00 kernel:  [<ffffffff8020bdfb>] ?  
system_call_fastpath+0x16/0x1b
Oct 17 11:53:59 linux-atl-00 kernel:
...
---

Following is patch containing the changes since last submit.
- modified abort mechanism - it aborts the timed out services  
automatically
- added timeout <-- this is the part that above question refers...
- modified/updated base on comments for previous patch including DMA  
mapping
   handling
---
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/ 
qla_attr.c
index d240da9..a5d531c 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1399,7 +1399,7 @@ qla2x00_execute_fc_service(struct fc_service  
*service)
  		}
  {
  	int i;
-	ushort *tmp = ct_iocb;
+	ushort *tmp = (ushort *) ct_iocb;
  	for (i=0;i<sizeof (struct ct_entry_24xx) / 2; i++)
  		printk("%4x\n", tmp[i]);
  }
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/ 
scsi_transport_fc.c
index dda12e0..3a50675 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2420,23 +2420,42 @@ fc_rport_final_delete(struct work_struct *work)

  static void fc_service_timeout(unsigned long _service)
  {
+	int res = 0;
  	struct fc_service *service = (void *) _service;
+	struct Scsi_Host *shost = rport_to_shost(service->rport);
+	struct fc_internal *i = to_fc_internal(shost->transportt);
  	unsigned long flags;

  	spin_lock_irqsave(&service->service_state_lock, flags);
  	if (!(service->service_state_flag & FC_SERVICE_STATE_DONE))
  		service->service_state_flag |= FC_SERVICE_STATE_TIMEOUT;
  	spin_unlock_irqrestore(&service->service_state_lock, flags);
+
+	if (i->f->abort_fc_service)
+		res = i->f->abort_fc_service(service);
+
+	if (res) {
+		printk(KERN_ERR "ERROR: issuing FC service to the LLD "
+		"failed with status %d\n", res);
+		fc_service_done(service);
+		return;
+	}
  }

  static void fc_service_done(struct fc_service *service)
  {
+	// if (!del_timer_sync(&service->timer)) {
+	if (!del_timer(&service->timer)) {
+		printk(KERN_ERR "ERROR: failed to delete timer\n");
+		return;
+	}
+
  	if (service->service_state_flag != FC_SERVICE_STATE_DONE) {
-		if (service->service_state_flag == FC_SERVICE_STATE_TIMEOUT) {
+		if (service->service_state_flag == FC_SERVICE_STATE_TIMEOUT)
  			printk(KERN_ERR "ERROR: FC service timed out\n");
-			/* expect abort to be issued by the application */
-			return;
-		} else
+		else if (service->service_state_flag == FC_SERVICE_STATE_ABORTED)
+			printk(KERN_ERR "ERROR: FC service aborted\n");
+		else
  			printk(KERN_ERR "ERROR: FC service not finished\n");
  	}

@@ -2455,6 +2474,8 @@ static void fc_service_done(struct fc_service  
*service)
  	}

  	service->req->end_io(service->req, 0);
+	kfree(service->payload_dma);
+	kfree(service->response_dma);
  	kfree(service);
  }

@@ -2478,13 +2499,19 @@ issue_fc_service(struct fc_rport *rport,  
struct request *req,
  	service->q = q;
  	service->srv_request = srv_request;

-	sg_init_table(service->payload_dma, FC_SERVICE_MAX_SG);
+	service->payload_dma = (struct scatterlist *)
+	    kzalloc(sizeof (struct scatterlist) * req->nr_phys_segments,
+	    GFP_KERNEL);
+	sg_init_table(service->payload_dma, req->nr_phys_segments);
  	service->payload_sg_cnt =
  	    blk_rq_map_sg(q, req, service->payload_dma);
  	service->payload = (void *) bio_data(req->bio);
  	service->payload_size = req->data_len;

-	sg_init_table(service->response_dma, FC_SERVICE_MAX_SG);
+	service->response_dma = (struct scatterlist *)
+	    kzalloc(sizeof (struct scatterlist) * rsp->nr_phys_segments,
+	    GFP_KERNEL);
+	sg_init_table(service->response_dma, rsp->nr_phys_segments);
  	service->response_sg_cnt =
  	    blk_rq_map_sg(q, rsp, service->response_dma);
  	service->response = bio_data(rsp->bio);
@@ -2495,10 +2522,20 @@ issue_fc_service(struct fc_rport *rport,  
struct request *req,
  	service->service_done = fc_service_done;
  	service->service_state_flag = FC_SERVICE_STATE_PENDING;

+	service->timer.data = (unsigned long) service;
+	// service->timer.expires = req->timeout * HZ;
+	service->timer.expires = 30 * HZ;
+	service->timer.function = fc_service_timeout;
+
+	printk("ELS/CT: debug: timer prepared... timeout value = %d\n",  
service->timer.expires);
+	add_timer(&service->timer);
+	printk("ELS/CT: debug: timer added...\n");
+
  	if (i->f->execute_fc_service)
  		res = i->f->execute_fc_service(service);

  	if (res) {
+		del_timer(&service->timer);
  		printk(KERN_ERR "ERROR: issuing FC service to the LLD "
  		"failed with status %d\n", res);
  		fc_service_done(service);
@@ -2521,13 +2558,6 @@ fc_service_handler(struct Scsi_Host *shost,  
struct fc_rport *rport,
  		return -EINVAL;
  	}

-	if ((req->bio->bi_vcnt > FC_SERVICE_MAX_SG) ||
-	    (rsp->bio->bi_vcnt > FC_SERVICE_MAX_SG)) {
-		printk(KERN_ERR "ERROR: a FC service"
-		    " supports no more than %d SGs\n", FC_SERVICE_MAX_SG);
-		return -EINVAL;
-	}
-
  	ret = issue_fc_service(rport, req, rsp, q);

  	return ret;
@@ -2562,6 +2592,8 @@ fc_bsg_initialize(struct Scsi_Host *shost,  
struct fc_rport *rport)
  	const char *name;
  	void (*release)(struct device *);

+	printk("ELS/CT: debug: %s LONG_MAX = %lx sizeof long = %ld\n",  
__func__, LONG_MAX, sizeof (long));
+
  	if (!rport) {
  		printk(KERN_ERR "ERROR: rport is NULL\n");
  		return -ENOMEM;
@@ -2581,6 +2613,9 @@ fc_bsg_initialize(struct Scsi_Host *shost,  
struct fc_rport *rport)
  		return -ENOMEM;
  	}

+	blk_queue_max_hw_segments(q, shost->sg_tablesize);
+	blk_queue_max_phys_segments(q, SCSI_MAX_SG_CHAIN_SEGMENTS);
+
  	rport->q = q;
  	q->queuedata = rport;
  	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/ 
scsi_transport_fc.h
index 6c6809a..4b7a8da 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -540,7 +540,6 @@ enum fc_service_status {
  #define FC_SERVICE_STATE_TIMEOUT      8

  #define FC_SERVICE_TIMEOUT 10
-#define FC_SERVICE_MAX_SG             16

  /* request (CDB) structure of the sg_io_v4 */
  struct fc_service_request {
@@ -574,11 +573,11 @@ struct fc_service {

  	struct fc_service_request *srv_request;
  	void  *payload;
-	struct scatterlist payload_dma[FC_SERVICE_MAX_SG];
+	struct scatterlist *payload_dma;
  	int   payload_sg_cnt;
  	int   payload_size;
  	void  *response;
-	struct scatterlist response_dma[FC_SERVICE_MAX_SG];
+	struct scatterlist *response_dma;
  	int   response_sg_cnt;
  	int   response_size;

---
