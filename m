From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] lpfc: fix oops in lpfc_sli4_scmd_to_wqidx_distr() from
 lpfc_send_taskmgmt()
Date: Fri, 22 Jul 2016 10:16:29 +0200
Message-ID: <20160722081629.64m5vbntnmldould@c203.arch.suse.de>
References: <1465341188-32620-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbcGVIQb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2016 04:16:31 -0400
Content-Disposition: inline
In-Reply-To: <1465341188-32620-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, james.smart@broadcom.com, dick.kennedy@broadcom.com

On Tue, Jun 07, 2016 at 08:13:08PM -0300, Mauricio Faria de Oliveira wr=
ote:
> The lpfc_sli4_scmd_to_wqidx_distr() function expects the scsi_cmnd
> 'lpfc_cmd->pCmd' not to be null, and point to the midlayer command.
>=20
> That's not true in the .eh_(device|target|bus)_reset_handler path,
> because lpfc_send_taskmgmt() sends commands not from the midlayer,
> so does not set 'lpfc_cmd->pCmd'.
>=20
> That is true in the .queuecommand path because lpfc_queuecommand()
> stores the scsi_cmnd from midlayer in lpfc_cmd->pCmd; and lpfc_cmd
> is stored by lpfc_scsi_prep_cmnd() in piocbq->context1 -- which is
> passed to lpfc_sli4_scmd_to_wqidx_distr() as lpfc_cmd parameter.
>=20
> This problem can be hit on SCSI EH, and immediately with sg_reset.
> These 2 test-cases demonstrate the problem/fix with next-20160601.
>=20
> Test-case 1) sg_reset
>=20
>     # strace sg_reset --device /dev/sdm
>     <...>
>     open("/dev/sdm", O_RDWR|O_NONBLOCK)     =3D 3
>     ioctl(3, SG_SCSI_RESET, 0x3fffde6d0994 <unfinished ...>
>     +++ killed by SIGSEGV +++
>     Segmentation fault
>=20
>     # dmesg
>     Unable to handle kernel paging request for data at address 0x0000=
0000
>     Faulting instruction address: 0xd00000001c88442c
>     Oops: Kernel access of bad area, sig: 11 [#1]
>     <...>
>     CPU: 104 PID: 16333 Comm: sg_reset Tainted: G        W       4.7.=
0-rc1-next-20160601-00004-g95b89dc #6
>     <...>
>     NIP [d00000001c88442c] lpfc_sli4_scmd_to_wqidx_distr+0xc/0xd0 [lp=
fc]
>     LR [d00000001c826fe8] lpfc_sli_calc_ring.part.27+0x98/0xd0 [lpfc]
>     Call Trace:
>     [c000003c9ec876f0] [c000003c9ec87770] 0xc000003c9ec87770 (unrelia=
ble)
>     [c000003c9ec87720] [d00000001c82e004] lpfc_sli_issue_iocb+0xd4/0x=
260 [lpfc]
>     [c000003c9ec87780] [d00000001c831a3c] lpfc_sli_issue_iocb_wait+0x=
15c/0x5b0 [lpfc]
>     [c000003c9ec87880] [d00000001c87f27c] lpfc_send_taskmgmt+0x24c/0x=
650 [lpfc]
>     [c000003c9ec87950] [d00000001c87fd7c] lpfc_device_reset_handler+0=
x10c/0x200 [lpfc]
>     [c000003c9ec87a10] [c000000000610694] scsi_try_bus_device_reset+0=
x44/0xc0
>     [c000003c9ec87a40] [c0000000006113e8] scsi_ioctl_reset+0x198/0x2c=
0
>     [c000003c9ec87bf0] [c00000000060fe5c] scsi_ioctl+0x13c/0x4b0
>     [c000003c9ec87c80] [c0000000006629b0] sd_ioctl+0xf0/0x120
>     [c000003c9ec87cd0] [c00000000046e4f8] blkdev_ioctl+0x248/0xb70
>     [c000003c9ec87d30] [c0000000002a1f60] block_ioctl+0x70/0x90
>     [c000003c9ec87d50] [c00000000026d334] do_vfs_ioctl+0xc4/0x890
>     [c000003c9ec87de0] [c00000000026db60] SyS_ioctl+0x60/0xc0
>     [c000003c9ec87e30] [c000000000009120] system_call+0x38/0x108
>     Instruction dump:
>     <...>
>=20
>     With fix:
>=20
>     # strace sg_reset --device /dev/sdm
>     <...>
>     open("/dev/sdm", O_RDWR|O_NONBLOCK)     =3D 3
>     ioctl(3, SG_SCSI_RESET, 0x3fffe103c554) =3D 0
>     close(3)                                =3D 0
>     exit_group(0)                           =3D ?
>     +++ exited with 0 +++
>=20
>     # dmesg
>     [  424.658649] lpfc 0006:01:00.4: 4:(0):0713 SCSI layer issued De=
vice Reset (1, 0) return x2002
>=20
> Test-case 2) SCSI EH
>=20
>     Using this debug patch to wire an SCSI EH trigger, for lpfc_scsi_=
cmd_iocb_cmpl():
>     -       cmd->scsi_done(cmd);
>     +       if ((phba->pport ? phba->pport->cfg_log_verbose : phba->c=
fg_log_verbose) =3D=3D 0x32100000)
>     +               printk(KERN_ALERT "lpfc: skip scsi_done()\n");
>     +       else
>     +               cmd->scsi_done(cmd);
>=20
>     # echo 0x32100000 > /sys/class/scsi_host/host11/lpfc_log_verbose
>=20
>     # dd if=3D/dev/sdm of=3D/dev/null iflag=3Ddirect &
>     <...>
>=20
>     After a while:
>=20
>     # dmesg
>     lpfc 0006:01:00.4: 4:(0):3053 lpfc_log_verbose changed from 0 (x0=
) to 839909376 (x32100000)
>     lpfc: skip scsi_done()
>     <...>
>     Unable to handle kernel paging request for data at address 0x0000=
0000
>     Faulting instruction address: 0xd0000000199e448c
>     Oops: Kernel access of bad area, sig: 11 [#1]
>     <...>
>     CPU: 96 PID: 28556 Comm: scsi_eh_11 Tainted: G        W       4.7=
=2E0-rc1-next-20160601-00004-g95b89dc #6
>     <...>
>     NIP [d0000000199e448c] lpfc_sli4_scmd_to_wqidx_distr+0xc/0xd0 [lp=
fc]
>     LR [d000000019986fe8] lpfc_sli_calc_ring.part.27+0x98/0xd0 [lpfc]
>     Call Trace:
>     [c000000ff0d0b890] [c000000ff0d0b900] 0xc000000ff0d0b900 (unrelia=
ble)
>     [c000000ff0d0b8c0] [d00000001998e004] lpfc_sli_issue_iocb+0xd4/0x=
260 [lpfc]
>     [c000000ff0d0b920] [d000000019991a3c] lpfc_sli_issue_iocb_wait+0x=
15c/0x5b0 [lpfc]
>     [c000000ff0d0ba20] [d0000000199df27c] lpfc_send_taskmgmt+0x24c/0x=
650 [lpfc]
>     [c000000ff0d0baf0] [d0000000199dfd7c] lpfc_device_reset_handler+0=
x10c/0x200 [lpfc]
>     [c000000ff0d0bbb0] [c000000000610694] scsi_try_bus_device_reset+0=
x44/0xc0
>     [c000000ff0d0bbe0] [c0000000006126cc] scsi_eh_ready_devs+0x49c/0x=
9c0
>     [c000000ff0d0bcb0] [c000000000614160] scsi_error_handler+0x580/0x=
680
>     [c000000ff0d0bd80] [c0000000000ae848] kthread+0x108/0x130
>     [c000000ff0d0be30] [c0000000000094a8] ret_from_kernel_thread+0x5c=
/0xb4
>     Instruction dump:
>     <...>
>=20
>     With fix:
>=20
>     # dmesg
>     lpfc 0006:01:00.4: 4:(0):3053 lpfc_log_verbose changed from 0 (x0=
) to 839909376 (x32100000)
>     lpfc: skip scsi_done()
>     <...>
>     lpfc 0006:01:00.4: 4:(0):0713 SCSI layer issued Device Reset (0, =
0) return x2002
>     <...>
>     lpfc 0006:01:00.4: 4:(0):0723 SCSI layer issued Target Reset (1, =
0) return x2002
>     <...>
>     lpfc 0006:01:00.4: 4:(0):0714 SCSI layer issued Bus Reset Data: x=
2002
>     <...>
>     lpfc 0006:01:00.4: 4:(0):3172 SCSI layer issued Host Reset Data:
>     <...>
>=20
> Fixes: 8b0dff14164d ("lpfc: Add support for using block multi-queue")
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.co=
m>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
