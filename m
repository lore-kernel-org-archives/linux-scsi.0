From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 1/1] qla2xxx: Initialize Work element before requesting
 IRQs
Date: Thu, 26 Oct 2017 03:45:41 +0000
Message-ID: <615B16D0-61B5-4794-85CC-F770922ACABC@cavium.com>
References: <20171016182605.22174-1-himanshu.madhani@cavium.com>
 <1508299976.3666.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0055.outbound.protection.outlook.com ([104.47.42.55]:45431
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752039AbdJZDpn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Oct 2017 23:45:43 -0400
In-Reply-To: <1508299976.3666.3.camel@wdc.com>
Content-Language: en-US
Content-ID: <D2980814FC040C4EA9A5C7A8DA88AFFD@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello Bart,=20

> On Oct 17, 2017, at 9:12 PM, Bart Van Assche <bart.vanassche@wdc.com> wro=
te:
>=20
> On Mon, 2017-10-16 at 11:26 -0700, Madhani, Himanshu wrote:
>> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os=
.c
>> index 937209805baf..3bd956d3bc5d 100644
>> --- a/drivers/scsi/qla2xxx/qla_os.c
>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>> @@ -3061,6 +3061,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
>> 	    host->max_cmd_len, host->max_channel, host->max_lun,
>> 	    host->transportt, sht->vendor_id);
>>=20
>> +	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
>> +
>> 	/* Set up the irqs */
>> 	ret =3D qla2x00_request_irqs(ha, rsp);
>> 	if (ret)
>> @@ -3175,8 +3177,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
>> 	    host->can_queue, base_vha->req,
>> 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
>>=20
>> -	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
>> -
>> 	if (ha->mqenable) {
>> 		bool mq =3D false;
>> 		bool startit =3D false;
>=20
> Hello Himanshu,
>=20
> That patch indeed fixes the bug described in the patch description when
> applied on top of kernel v4.13.7. However, with that patch applied I ran
> into another bug. Can you have a look?
>=20
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000190
> IP: qlt_free_session_done+0x172/0x570 [qla2xxx]
> PGD 0=20
> P4D 0=20
> Oops: 0000 [#1] SMP
> CPU: 0 PID: 47 Comm: kworker/0:1 Not tainted 4.13.7+ #1
> Hardware name: Gigabyte Technology Co., Ltd. Z97X-UD5H/Z97X-UD5H, BIOS F1=
0 08/03/2015
> Workqueue: events qlt_free_session_done [qla2xxx]
> task: ffff9c4bcee94300 task.stack: ffffba99c01d4000
> RIP: 0010:qlt_free_session_done+0x172/0x570 [qla2xxx]
> RSP: 0018:ffffba99c01d7dc8 EFLAGS: 00010046
> RAX: 0000000000000000 RBX: ffff9c4bb5c95720 RCX: ffffffffc09174c8
> RDX: 0000000000000001 RSI: ffff9c4bb5c95720 RDI: ffff9c4baf7e5ce4
> RBP: ffffba99c01d7e50 R08: ffffffffc0903620 R09: ffff9c4bc840e400
> R10: ffffba99c01d7db0 R11: 0000000000000000 R12: ffff9c4bc840e400
> R13: 0000000000000000 R14: ffff9c4baf7e5000 R15: ffff9c4bc840e4c0
> FS:  0000000000000000(0000) GS:ffff9c4bdfa00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000190 CR3: 000000040c624000 CR4: 00000000001426f0
> Call Trace:
> ? qlt_unreg_sess+0xfe/0x110 [qla2xxx]
> ? qla24xx_delete_sess_fn+0x69/0x80 [qla2xxx]
> process_one_work+0x1d6/0x3d0
> worker_thread+0x42/0x3e0
> kthread+0x11f/0x140
> ? trace_event_raw_event_workqueue_execute_start+0x90/0x90
> ? kthread_create_on_node+0x40/0x40
> ret_from_fork+0x22/0x30
> Code: 00 00 00 00 41 c7 87 ac 00 00 00 07 00 00 00 83 e0 f9 83 c8 04 41 f=
6 87 71 ff ff ff 02 41 88 87 70 ff ff ff 48 8b 83 40 04 00 00 <8b> 80 90 01=
 00 00 41 89 47 4c 74 22 41 8b 87 68 ff ff ff 25 00=20
> RIP: qlt_free_session_done+0x172/0x570 [qla2xxx] RSP: ffffba99c01d7dc8
> CR2: 0000000000000190
> ---[ end trace 89dee74f51a05258 ]---
>=20
> (gdb) list *(qlt_free_session_done+0x172)
> 0x661c2 is in qlt_free_session_done (drivers/scsi/qla2xxx/qla_target.c:10=
27).
> 1022            }
> 1023
> 1024            sess->disc_state =3D DSC_DELETED;
> 1025            sess->fw_login_state =3D DSC_LS_PORT_UNAVAIL;
> 1026            sess->deleted =3D QLA_SESS_DELETED;
> 1027            sess->login_retry =3D vha->hw->login_retry_count;
> 1028
> 1029            if (sess->login_succ && !IS_SW_RESV_ADDR(sess->d_id)) {
> 1030                    vha->fcport_count--;
> 1031                    sess->login_succ =3D 0;

I will take a look and see if i can reproduce this issue.

Thanks,
- Himanshu
