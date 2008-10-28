From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support via bsg interface - revised
Date: Tue, 28 Oct 2008 07:06:07 -0700
Message-ID: <EE6A1268-D18E-497E-AF5F-FF78F4A837E4@qlogic.com>
References: <32C8BF3A-87D5-4F89-AF4B-7731548CCD4A@qlogic.com>	<20081024125449T.fujita.tomonori@lab.ntt.co.jp>	<49043A7C.8030105@panasas.com> <20081027131110Z.fujita.tomonori@lab.ntt.co.jp> <490579C5.5080102@panasas.com> <C411DA16-2D8D-4B06-91B4-EB2B2B1984E5@qlogic.com> <4906C5DB.1010402@panasas.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-17--65051952
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:34794 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYJ1OGL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2008 10:06:11 -0400
In-Reply-To: <4906C5DB.1010402@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, James.Smart@Emulex.Com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, robert.w.love@intel.com


--Apple-Mail-17--65051952
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit


On Oct 28, 2008, at 12:57 AM, Boaz Harrosh wrote:

> Seokmann Ju wrote:
>> On Oct 27, 2008, at 1:20 AM, Boaz Harrosh wrote:
>>
>>> FUJITA Tomonori wrote:
>>>> On Sun, 26 Oct 2008 11:38:04 +0200
>>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>>
>>>>> FUJITA Tomonori wrote:
>>>>>> CC'ed Jens,
>>>>> I think that all block-queue consumers should call one of
>>>>> blk_end_request(),
>>>> This is kinda what I suggested in the previous mail but as I wrote,
>>>> some of them don't now.
>>>>
>>> I think they should, specially if they're going to use the timer.
>>> The way I see it they must. It's kind of a block layer API thing.
>>> Someone calls blk_execute_xx then eventually someone needs to call
>>> blk_end_request. You could call it from bsg but only temporary until
>>> all are fixed. (because you will need an ugly check to see if  
>>> request
>>> was not already ended)
>> I made following changes but, it seems not helpful for the issue.
>> It, eventually, got failed to call blk_delete_timer() as ~/block/blk-
>> core.c:__end_that_request_first() returns non-zero.
>> Inside of the __end_that_reqeust_first(), it detected 'nbytes' is
>> bigger than 'nr_bytes' in case of bidi (where req->next_rq is not  
>> NULL).
>> I'm not sure whether we need to have chains of function calls
>> initiated by the blk_end_request() or blk_end_bidi_request().
>> Would it create any problems if we directly call  
>> 'blk_delete_timer()'?
>>
>
> Dear Seokmann. You miss understud me. What I'm saying is that you must
> call blk_end_bidi_request at the FC end, just after you have finished
> to consume the request, and before you return it upstream. it can be
> some thing like:
>
> +	blk_end_bidi_request(rq, 0, blk_rq_bytes(rq),
> +	                     rq->next_rq ?  blk_rq_bytes(rq->next_rq) : 0);
>
> In this case __end_that_reqeust_first should never return non-zero.
Hello Boaz,
Thank you for the clarification.
I made the changes accordingly and tested it, but the problem is still
there - same result of getting non-zero returns from
__end_that_request_first().
I guess that, either, I still get confused about the location or, there
is something else going on...

Sorry, I don't have public git-web.
Here is snaptshot of the FC transport layer changes.
The fc_service_done() is the callback that the FC transport layer
provides. And that is the callback called by LLD before returning.

Please let me know for any comments.

--Apple-Mail-17--65051952
Content-Disposition: attachment;
	filename=0001-scsi_transport_fc-FC-pass-through-support.patch
Content-Type: application/octet-stream;
	x-unix-mode=0777;
	name="0001-scsi_transport_fc-FC-pass-through-support.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=20ea2dc821bb75abcec3d0861e8d7ae9c80196f759=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20root=20<root@linux-atl-00.qlogic.com>=0ADate:=20=
Tue,=2028=20Oct=202008=2006:49:51=20-0700=0ASubject:=20[PATCH]=20=
scsi_transport_fc:=20FC=20pass=20through=20support=0A=0ASigned-off-by:=20=
Seokmann=20Ju=20<seokmann.ju@qlogic.com>=0A---=0A=20=
drivers/scsi/scsi_transport_fc.c=20|=20=20220=20=
+++++++++++++++++++++++++++++++++++++-=0A=20=
include/scsi/scsi_transport_fc.h=20|=20=20=2081=20++++++++++++++-=0A=202=20=
files=20changed,=20298=20insertions(+),=203=20deletions(-)=0A=0Adiff=20=
--git=20a/drivers/scsi/scsi_transport_fc.c=20=
b/drivers/scsi/scsi_transport_fc.c=0Aindex=201e71abf..d7eebe6=20100644=0A=
---=20a/drivers/scsi/scsi_transport_fc.c=0A+++=20=
b/drivers/scsi/scsi_transport_fc.c=0A@@=20-43,6=20+43,11=20@@=20static=20=
void=20fc_vport_sched_delete(struct=20work_struct=20*work);=0A=20static=20=
int=20fc_vport_setup(struct=20Scsi_Host=20*shost,=20int=20channel,=0A=20=09=
struct=20device=20*pdev,=20struct=20fc_vport_identifiers=20=20*ids,=0A=20=
=09struct=20fc_vport=20**vport);=0A+static=20enum=20blk_eh_timer_return=20=
fc_service_timeout(struct=20request=20*req);=0A+static=20void=20=
fc_service_done(struct=20fc_service=20*);=0A+static=20int=20=
fc_service_handler(struct=20Scsi_Host=20*,=20struct=20fc_rport=20*,=0A+=20=
=20=20=20struct=20request=20*,=20struct=20request_queue=20*);=0A+static=20=
void=20fc_bsg_remove(struct=20Scsi_Host=20*,=20struct=20fc_rport=20*);=0A=
=20=0A=20/*=0A=20=20*=20Redefine=20so=20that=20we=20can=20have=20same=20=
named=20attributes=20in=20the=0A@@=20-2413,11=20+2418,222=20@@=20=
fc_rport_final_delete(struct=20work_struct=20*work)=0A=20=0A=20=09=
transport_remove_device(dev);=0A=20=09device_del(dev);=0A+=09=
fc_bsg_remove(shost,=20rport);=0A=20=09transport_destroy_device(dev);=0A=20=
=09put_device(&shost->shost_gendev);=09/*=20for=20fc_host->rport=20list=20=
*/=0A=20=09put_device(dev);=09=09=09/*=20for=20self-reference=20*/=0A=20=
}=0A=20=0A+static=20enum=20blk_eh_timer_return=20=
fc_service_timeout(struct=20request=20*req)=0A+{=0A+=09struct=20=
fc_service=20*service=20=3D=20(void=20*)=20req->special;=0A+=09struct=20=
Scsi_Host=20*shost=20=3D=20rport_to_shost(service->rport);=0A+=09struct=20=
fc_internal=20*i=20=3D=20to_fc_internal(shost->transportt);=0A+=09=
unsigned=20long=20flags;=0A+=09int=20res=20=3D=200;=0A+=0A+=09if=20=
(service->rport->port_state=20=3D=3D=20FC_PORTSTATE_BLOCKED)=0A+=09=09=
return=20BLK_EH_RESET_TIMER;=0A+=0A+=09=
spin_lock_irqsave(&service->service_state_lock,=20flags);=0A+=09if=20=
(!(service->service_state_flag=20&=20FC_SERVICE_STATE_DONE))=0A+=09=09=
service->service_state_flag=20|=3D=20FC_SERVICE_STATE_TIMEOUT;=0A+=09=
spin_unlock_irqrestore(&service->service_state_lock,=20flags);=0A+=0A+=09=
if=20(i->f->abort_fc_service)=0A+=09=09res=20=3D=20=
i->f->abort_fc_service(service);=0A+=0A+=09if=20(res)=20{=0A+=09=09=
printk(KERN_ERR=20"ERROR:=20issuing=20FC=20service=20to=20the=20LLD=20"=0A=
+=09=09"failed=20with=20status=20%d\n",=20res);=0A+=09=09=
fc_service_done(service);=0A+=09}=0A+=0A+=09/*=20the=20blk_end_sync_io()=20=
doesn't=20check=20the=20error=20*/=0A+=09return=20BLK_EH_NOT_HANDLED;=0A=
+}=0A+=0A+static=20void=20fc_service_done(struct=20fc_service=20=
*service)=0A+{=0A+=0A+=09if=20(service->service_state_flag=20!=3D=20=
FC_SERVICE_STATE_DONE)=20{=0A+=09=09if=20(service->service_state_flag=20=
=3D=3D=20FC_SERVICE_STATE_TIMEOUT)=0A+=09=09=09printk(KERN_ERR=20"ERROR:=20=
FC=20service=20timed=20out\n");=0A+=09=09else=20if=20=
(service->service_state_flag=20=3D=3D=0A+=09=09=20=20=20=20=
FC_SERVICE_STATE_ABORTED)=0A+=09=09=09printk(KERN_ERR=20"ERROR:=20FC=20=
service=20aborted\n");=0A+=09=09else=0A+=09=09=09printk(KERN_ERR=20=
"ERROR:=20FC=20service=20not=20finished\n");=0A+=09}=0A+=0A+=09if=20=
(service->srv_reply.status=20!=3D=20FC_SERVICE_COMPLETE)=20{=0A+=09=09=
printk(KERN_ERR=20"ERROR:=20FC=20service=20to=20rport=20%p=20failed=20=
with"=0A+=09=09=20=20=20=20"=20status=200x%x\n",=20service->rport,=0A+=09=
=09=20=20=20=20service->srv_reply.status);=0A+=09}=0A+=0A+=09if=20=
(service->srv_reply.residual)=20{=0A+=09=09service->req->data_len=20=3D=20=
0;=0A+=09=09service->req->next_rq->data_len=20=3D=20=
service->srv_reply.residual;=0A+=09}=20else=20{=0A+=09=09=
service->req->data_len=20=3D=200;=0A+=09=09=
service->req->next_rq->data_len=20=3D=200;=0A+=09}=0A+=0A+=09=
blk_end_bidi_request(service->req,=200,=20blk_rq_bytes(service->req),=0A=
+=09=20=20=20=20service->req->next_rq=20?=20=
blk_rq_bytes(service->req->next_rq)=20:=200);=0A+=09=
service->req->end_io(service->req,=200);=0A+=09=
kfree(service->payload_dma);=0A+=09kfree(service->response_dma);=0A+=09=
kfree(service);=0A+}=0A+=0A+static=20int=0A+issue_fc_service(struct=20=
fc_rport=20*rport,=20struct=20request=20*req,=0A+=20=20=20=20struct=20=
request=20*rsp,=20struct=20request_queue=20*q)=0A+{=0A+=09int=20res=20=3D=20=
-ECOMM;=0A+=09struct=20fc_service=20*service;=0A+=09struct=20Scsi_Host=20=
*shost=20=3D=20rport_to_shost(rport);=0A+=09struct=20fc_internal=20*i=20=
=3D=20to_fc_internal(shost->transportt);=0A+=09struct=20=
fc_service_request=20*srv_request=20=3D=20(struct=20fc_service_request=20=
*)=0A+=09=20=20=20=20req->cmd;=0A+=0A+=09service=20=3D=20kzalloc(sizeof=20=
(struct=20fc_service),=20GFP_KERNEL);=0A+=09if=20(!service)=0A+=09=09=
return=20-ENOMEM;=0A+=0A+=09req->special=20=3D=20service;=0A+=09=
service->rport=20=3D=20rport;=0A+=09service->req=20=3D=20req;=0A+=09=
service->q=20=3D=20q;=0A+=09service->srv_request=20=3D=20srv_request;=0A=
+=09service->timeout=20=3D=20req->timeout;=0A+=0A+=09=
service->payload_dma=20=3D=20(struct=20scatterlist=20*)=0A+=09=20=20=20=20=
kzalloc(sizeof=20(struct=20scatterlist)=20*=20req->nr_phys_segments,=0A+=09=
=20=20=20=20GFP_KERNEL);=0A+=09sg_init_table(service->payload_dma,=20=
req->nr_phys_segments);=0A+=09service->payload_sg_cnt=20=3D=0A+=09=20=20=20=
=20blk_rq_map_sg(q,=20req,=20service->payload_dma);=0A+=09=
service->payload=20=3D=20(void=20*)=20bio_data(req->bio);=0A+=09=
service->payload_size=20=3D=20req->data_len;=0A+=0A+=09=
service->response_dma=20=3D=20(struct=20scatterlist=20*)=0A+=09=20=20=20=20=
kzalloc(sizeof=20(struct=20scatterlist)=20*=20rsp->nr_phys_segments,=0A+=09=
=20=20=20=20GFP_KERNEL);=0A+=09sg_init_table(service->response_dma,=20=
rsp->nr_phys_segments);=0A+=09service->response_sg_cnt=20=3D=0A+=09=20=20=
=20=20blk_rq_map_sg(q,=20rsp,=20service->response_dma);=0A+=09=
service->response=20=3D=20bio_data(rsp->bio);=0A+=09=
service->response_size=20=3D=20rsp->data_len;=0A+=0A+=09/*=20sense=20=
area=20of=20the=20request=20structure=20*/=0A+=09service->reply_seq=20=3D=20=
req->sense;=0A+=09service->service_done=20=3D=20fc_service_done;=0A+=09=
service->service_state_flag=20=3D=20FC_SERVICE_STATE_PENDING;=0A+=0A+=09=
if=20(i->f->execute_fc_service)=0A+=09=09res=20=3D=20=
i->f->execute_fc_service(service);=0A+=0A+=09if=20(res)=20{=0A+=09=09=
printk(KERN_ERR=20"ERROR:=20issuing=20FC=20service=20to=20the=20LLD=20"=0A=
+=09=09"failed=20with=20status=20%d\n",=20res);=0A+=09=09=
fc_service_done(service);=0A+=09=09return=20res;=0A+=09}=0A+=0A+=09=
return=200;=0A+}=0A+=0A+static=20int=0A+fc_service_handler(struct=20=
Scsi_Host=20*shost,=20struct=20fc_rport=20*rport,=0A+=09=09=09=20=20=
struct=20request=20*req,=20struct=20request_queue=20*q)=0A+{=0A+=09int=20=
ret;=0A+=09struct=20request=20*rsp=20=3D=20req->next_rq;=0A+=0A+=09if=20=
(!rsp)=20{=0A+=09=09printk(KERN_ERR=20"ERROR:=20space=20for=20a=20FC=20=
service"=0A+=09=09=20=20=20"=20response=20is=20missing\n");=0A+=09=09=
return=20-EINVAL;=0A+=09}=0A+=0A+=09ret=20=3D=20issue_fc_service(rport,=20=
req,=20rsp,=20q);=0A+=0A+=09return=20ret;=0A+}=0A+=0A+static=20void=20=
fc_service_dispatch(struct=20request_queue=20*q)=0A+{=0A+=09struct=20=
request=20*req;=0A+=09struct=20fc_rport=20*rport=20=3D=20q->queuedata;=0A=
+=09struct=20Scsi_Host=20*shost=20=3D=20rport_to_shost(rport);=0A+=0A+=09=
while=20(!blk_queue_plugged(q))=20{=0A+=09=09req=20=3D=20=
elv_next_request(q);=0A+=09=09if=20(!req)=0A+=09=09=09break;=0A+=0A+=09=09=
blkdev_dequeue_request(req);=0A+=09=09spin_unlock_irq(q->queue_lock);=0A=
+=0A+=09=09fc_service_handler(shost,=20rport,=20req,=20q);=0A+=0A+=09=09=
spin_lock_irq(q->queue_lock);=0A+=09}=0A+}=0A+=0A+static=20int=0A=
+fc_bsg_initialize(struct=20Scsi_Host=20*shost,=20struct=20fc_rport=20=
*rport)=0A+{=0A+=09struct=20request_queue=20*q;=0A+=09int=20error;=0A+=09=
struct=20device=20*dev;=0A+=09const=20char=20*name;=0A+=09void=20=
(*release)(struct=20device=20*);=0A+=0A+=09if=20(!rport)=20{=0A+=09=09=
printk(KERN_ERR=20"ERROR:=20rport=20is=20NULL\n");=0A+=09=09return=20=
-ENOMEM;=0A+=09}=0A+=0A+=09q=20=3D=20blk_init_queue(fc_service_dispatch,=20=
NULL);=0A+=09if=20(!q)=0A+=09=09return=20-ENOMEM;=0A+=0A+=09dev=20=3D=20=
&rport->dev;=0A+=09name=20=3D=20dev->bus_id;=0A+=09release=20=3D=20NULL;=0A=
+=0A+=09error=20=3D=20bsg_register_queue(q,=20dev,=20name,=20release);=0A=
+=09if=20(error)=20{=0A+=09=09blk_cleanup_queue(q);=0A+=09=09return=20=
-ENOMEM;=0A+=09}=0A+=0A+=09blk_queue_max_hw_segments(q,=20=
shost->sg_tablesize);=0A+=09blk_queue_max_phys_segments(q,=20=
SCSI_MAX_SG_CHAIN_SEGMENTS);=0A+=09blk_queue_rq_timed_out(q,=20=
fc_service_timeout);=0A+=09blk_queue_rq_timeout(q,=20=
BLK_DEFAULT_SG_TIMEOUT);=0A+=0A+=09rport->q=20=3D=20q;=0A+=09=
q->queuedata=20=3D=20rport;=0A+=09=
queue_flag_set_unlocked(QUEUE_FLAG_BIDI,=20q);=0A+=0A+=09return=200;=0A=
+}=0A+=0A+static=20void=0A+fc_bsg_remove(struct=20Scsi_Host=20*shost,=20=
struct=20fc_rport=20*rport)=0A+{=0A+=09struct=20request_queue=20*q=20=3D=20=
rport->q;=0A+=0A+=09if=20(!q)=0A+=09=09return;=0A+=0A+=09=
bsg_unregister_queue(q);=0A+}=0A=20=0A=20/**=0A=20=20*=20fc_rport_create=20=
-=20allocates=20and=20creates=20a=20remote=20FC=20port.=0A@@=20-2478,8=20=
+2694,8=20@@=20fc_rport_create(struct=20Scsi_Host=20*shost,=20int=20=
channel,=0A=20=09else=0A=20=09=09rport->scsi_target_id=20=3D=20-1;=0A=20=09=
list_add_tail(&rport->peers,=20&fc_host->rports);=0A-=09=
get_device(&shost->shost_gendev);=09/*=20for=20fc_host->rport=20list=20=
*/=0A=20=0A+=09get_device(&shost->shost_gendev);=09/*=20for=20=
fc_host->rport=20list=20*/=0A=20=09=
spin_unlock_irqrestore(shost->host_lock,=20flags);=0A=20=0A=20=09dev=20=3D=
=20&rport->dev;=0A@@=20-2498,6=20+2714,8=20@@=20fc_rport_create(struct=20=
Scsi_Host=20*shost,=20int=20channel,=0A=20=09transport_add_device(dev);=0A=
=20=09transport_configure_device(dev);=0A=20=0A+=09=
fc_bsg_initialize(shost,=20rport);=0A+=0A=20=09if=20(rport->roles=20&=20=
FC_PORT_ROLE_FCP_TARGET)=20{=0A=20=09=09/*=20initiate=20a=20scan=20of=20=
the=20target=20*/=0A=20=09=09rport->flags=20|=3D=20=
FC_RPORT_SCAN_PENDING;=0Adiff=20--git=20=
a/include/scsi/scsi_transport_fc.h=20b/include/scsi/scsi_transport_fc.h=0A=
index=2049d8913..68104f5=20100644=0A---=20=
a/include/scsi/scsi_transport_fc.h=0A+++=20=
b/include/scsi/scsi_transport_fc.h=0A@@=20-33,7=20+33,6=20@@=0A=20=0A=20=
struct=20scsi_transport_template;=0A=20=0A-=0A=20/*=0A=20=20*=20FC=20=
Port=20definitions=20-=20Following=20FC=20HBAAPI=20guidelines=0A=20=20*=0A=
@@=20-352,6=20+351,7=20@@=20struct=20fc_rport=20{=09/*=20aka=20=
fc_starget_attrs=20*/=0A=20=20=09struct=20delayed_work=20fail_io_work;=0A=
=20=20=09struct=20work_struct=20stgt_delete_work;=0A=20=09struct=20=
work_struct=20rport_delete_work;=0A+=09struct=20request_queue=20*q;=0A=20=
}=20__attribute__((aligned(sizeof(unsigned=20long))));=0A=20=0A=20/*=20=
bit=20field=20values=20for=20struct=20fc_rport=20"flags"=20field:=20*/=0A=
@@=20-515,6=20+515,80=20@@=20struct=20fc_host_attrs=20{=0A=20=09struct=20=
workqueue_struct=20*devloss_work_q;=0A=20};=0A=20=0A+#define=20=
FC_STATUS_BUF_SIZE=2096=0A+=0A+enum=20fc_frame_type=20{=0A+=09=
FC_FRAME_TYPE_BS,=0A+=09FC_FRAME_TYPE_ELS,=0A+=09FC_FRAME_TYPE_IEC=20=3D=20=
4,=0A+=09FC_FRAME_TYPE_IP,=0A+=09FC_FRAME_TYPE_FCP=20=3D=208,=0A+=09=
FC_FRAME_TYPE_GPP,=0A+=09FC_FRAME_TYPE_FC_CT=20=3D=200x20,=0A+};=0A+=0A=
+enum=20fc_service_status=20{=0A+=09FC_SERVICE_COMPLETE,=0A+=09=
FC_SERVICE_TIMEOUT,=0A+=09FC_SERVICE_ABORT,=0A+=09=
FC_SERVICE_UNSUPPORTED,=0A+=09FC_SERVICE_ERROR=20=3D=20-1,=0A+};=0A+=0A=
+#define=20FC_SERVICE_STATE_PENDING=20=20=20=20=20=201=0A+#define=20=
FC_SERVICE_STATE_DONE=20=20=20=20=20=20=20=20=202=0A+#define=20=
FC_SERVICE_STATE_ABORTED=20=20=20=20=20=204=0A+#define=20=
FC_SERVICE_STATE_TIMEOUT=20=20=20=20=20=208=0A+=0A+#define=20=
FC_SERVICE_TIMEOUT=2010=0A+=0A+/*=20request=20(CDB)=20structure=20of=20=
the=20sg_io_v4=20*/=0A+struct=20fc_service_request=20{=0A+=09u8=20=20=20=
request_type;=0A+=09u8=20=20=20timeout;=0A+=09u8=20=20=20reserved0;=0A+=09=
u8=20=20=20reserved1;=0A+};=0A+=0A+/*=20response=20=20(request=20sense=20=
data)=20structure=20of=20the=20sg_io_v4=20*/=0A+struct=20=
fc_service_reply=20{=0A+=09enum=20fc_service_status=20status;=0A+=09u16=20=
=20error_code;=0A+=09u16=20=20additional_error_code;=0A+=09u32=20=20=
residual;=0A+};=0A+=0A+struct=20fc_service=20{=0A+=09struct=20fc_rport=20=
=20*rport;=0A+=09struct=20list_head=20list;=0A+=0A+=09spinlock_t=20=20=20=
service_state_lock;=0A+=09unsigned=20=20=20=20=20service_state_flag;=0A+=0A=
+=09struct=20request=20*req;=0A+=09struct=20request_queue=20*q;=0A+=0A+=09=
/*=20Used=20by=20the=20discovery=20code.=20*/=0A+=09struct=20completion=20=
=20completion;=0A+=09int=20=20timeout;=0A+=0A+=09struct=20=
fc_service_request=20*srv_request;=0A+=09void=20=20*payload;=0A+=09=
struct=20scatterlist=20*payload_dma;=0A+=09int=20=20=20payload_sg_cnt;=0A=
+=09int=20=20=20payload_size;=0A+=09void=20=20*response;=0A+=09struct=20=
scatterlist=20*response_dma;=0A+=09int=20=20=20response_sg_cnt;=0A+=09=
int=20=20=20response_size;=0A+=0A+=09struct=20fc_service_reply=20=
srv_reply;=0A+=09void=20=20*reply_seq;=20=20=20/*=20pointer=20to=20sense=20=
area=20of=20request=20*/=0A+=09void=20=20(*service_done)(struct=20=
fc_service=20*);=0A+=0A+=09void=20*lld_pkt;=0A+};=0A+=0A=20#define=20=
shost_to_fc_host(x)=20\=0A=20=09((struct=20fc_host_attrs=20=
*)(x)->shost_data)=0A=20=0A@@=20-613,6=20+687,10=20@@=20struct=20=
fc_function_template=20{=0A=20=09int=20=20=20=20=20(*=20=
tsk_mgmt_response)(struct=20Scsi_Host=20*,=20u64,=20u64,=20int);=0A=20=09=
int=20=20=20=20=20(*=20it_nexus_response)(struct=20Scsi_Host=20*,=20u64,=20=
int);=0A=20=0A+=09/*=20fc=20service=20handler=20*/=0A+=09int=09=
(*execute_fc_service)(struct=20fc_service=20*);=0A+=09int=09=
(*abort_fc_service)(struct=20fc_service=20*);=0A+=0A=20=09/*=20=
allocation=20lengths=20for=20host-specific=20data=20*/=0A=20=09u32=09=20=09=
=09=09dd_fcrport_size;=0A=20=09u32=09=20=09=09=09dd_fcvport_size;=0A@@=20=
-736,7=20+814,6=20@@=20fc_vport_set_state(struct=20fc_vport=20*vport,=20=
enum=20fc_vport_state=20new_state)=0A=20=09vport->vport_state=20=3D=20=
new_state;=0A=20}=0A=20=0A-=0A=20struct=20scsi_transport_template=20=
*fc_attach_transport(=0A=20=09=09=09struct=20fc_function_template=20*);=0A=
=20void=20fc_release_transport(struct=20scsi_transport_template=20*);=0A=
--=20=0A1.6.0.2=0A=0A=

--Apple-Mail-17--65051952
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit



Thank you,
Seokmann
--Apple-Mail-17--65051952--
