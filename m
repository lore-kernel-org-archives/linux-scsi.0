From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 2/2  scsi-rc-fixes-2.6] FC Remote Port patch
Date: Wed, 9 Feb 2005 10:32:46 -0800
Message-ID: <20050209183246.GE7116@plap.qlogic.org>
References: <0B1E13B586976742A7599D71A6AC733C12EB47@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch01.qlogic.com ([198.70.193.200]:29815 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261889AbVBISci
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2005 13:32:38 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EB47@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Tue, 08 Feb 2005, James.Smart@Emulex.Com wrote:

>   This patch also moves the dev_loss attribute from the target-level
>   fc_transport device to the remote port device. It also deletes the
>   link_down attribute. The fc_target_block and fc_target_unblock 
>   routines have been replaced by fc_remote_port_block and
>   fc_remote_port_unblock. The fc_host_block/unblock functions have
>   been removed (unused).
> 

still trying to track down the following oops:

	Unable to handle kernel paging request at virtual address 6b6b6be7
	 printing eip:
	c028ef0f
	*pde = 00000000
	Oops: 0000 [#1]
	SMP
	Modules linked in: qla2322 qla2xxx
	CPU:    0
	EIP:    0060:[<c028ef0f>]    Not tainted VLI
	EFLAGS: 00010082   (2.6.11-rport)
	EIP is at scsi_device_get+0x2f/0x70
	eax: 6b6b6b6b   ebx: c156aac4   ecx: d9bd1b90   edx: fffffffa
	esi: c156ac58   edi: c156aac4   ebp: d9bd1b74   esp: dcc3fe08
	ds: 007b   es: 007b   ss: 0068
	Process qla2322_3_dpc (pid: 12662, threadinfo=dcc3e000 task=dfebca40)
	Stack: d9bd1b7c d5318000 c028efda 00000286 d9bd1b74 d7487ccc d5318000
	c029af10
	       c028f07d 00000000 db507c74 d7487ccc 00000023 db507d70 c029afbf
	d68d07fc
	       00000000 d53181fc d5319338 e08633d3 c01020b5 c04221ec 00000282
	0000002c
	Call Trace:
	 [<c028efda>] __scsi_iterate_devices+0x3a/0x70
	 [<c029af10>] fc_device_block+0x0/0x10
	 [<c028f07d>] starget_for_each_device+0x6d/0x80
	 [<c029afbf>] fc_remote_port_block+0x3f/0x70
	 [<e08633d3>] qla2x00_mark_device_lost+0x53/0xe0 [qla2xxx]
	 [<c01020b5>] __down_trylock+0x65/0x80
	 [<c03097ab>] __down_failed_trylock+0x7/0xc
	 [<c011be61>] vprintk+0x141/0x160
	 [<e0867508>] qla2x00_device_resync+0x238/0x2d0 [qla2xxx]
	 [<e08682d0>] qla2x00_mbx_sem_timeout+0x0/0x10 [qla2xxx]
	 [<e08668bc>] qla2x00_configure_fabric+0x7c/0x3e0 [qla2xxx]
	 [<c01f3d54>] vsnprintf+0x394/0x510
	 [<c01176fd>] __wake_up_locked+0x1d/0x20
	 [<c01020b5>] __down_trylock+0x65/0x80
	 [<c03097ab>] __down_failed_trylock+0x7/0xc
	 [<c011be61>] vprintk+0x141/0x160
	 [<e086629a>] qla2x00_configure_loop+0x1aa/0x200 [qla2xxx]
	 [<e086793c>] qla2x00_loop_resync+0x8c/0xd0 [qla2xxx]
	 [<e0864115>] qla2x00_do_dpc+0x3a5/0x470 [qla2xxx]
	 [<c010310a>] work_resched+0x5/0x16
	 [<e0863d70>] qla2x00_do_dpc+0x0/0x470 [qla2xxx]
	 [<c0101345>] kernel_thread_helper+0x5/0x10
	Code: ff ff 53 89 c3 8b 80 a8 02 00 00 83 e8 03 83 f8 01 76 3e 8d b3
	94 01 00 00 89 f0 e8 6c cc fb ff 85 c0 ba fa ff ff ff 74 28 8b 03 <8b>
	40 7c 8b 10 85 d2 74 1b b8 00 e0 ff ff 21 e0 83 3a 02 8b 40

seems like sdev->shost is bogus when fc_remote_port_block() is
called...

On a side note:

	+/*
	+ * fc_rport_terminate - this routine tears down and deallocates a remote port.
	+ * @rport:     The remote port to be terminated
	+ *
	+ * Notes:
	+ *     This routine assumes no locks are held on entry.
	+ */
	+extern int lpfc_ext_debug;
	+static void
	+fc_rport_terminate(struct fc_rport  *rport)
	+{

lpfc_ext_debug -- residuals from some test code?

--
AV
