From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: aic94xx panic on module insertion
Date: Mon, 10 Jul 2006 10:29:50 -0700
Message-ID: <20060710172950.GE30179@us.ibm.com>
References: <1152541373.7275.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:3468 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1422721AbWGJR3s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jul 2006 13:29:48 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k6AHTm4X008580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2006 13:29:48 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k6AHTmra251938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2006 13:29:48 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k6AHTlY1027207
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2006 13:29:47 -0400
Content-Disposition: inline
In-Reply-To: <1152541373.7275.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
> aic94xx: SAS proto IDENTIFY:
> aic94xx: 00: 20 00 00 02
> aic94xx: 04: 00 00 00 00
> aic94xx: 08: 00 00 00 00
> aic94xx: 0c: 50 06 05 b0
> aic94xx: 10: 00 00 11 10
> aic94xx: 14: 07 00 00 00
> aic94xx: 18: 00 00 00 00
> aic94xx: escb_tasklet_complete: phy1: PRIMITIVE_RECVD
> sas: phy0 added to port0, phy_mask:0x1
> aic94xx: phy1: BROADCAST change received:256
> aic94xx: control_phy_tasklet_complete: phy2, lrate:0x9, proto:0xe
> sas: broadcast received: 9
> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000214
>  printing eip:
> f88f14cd
> *pde = 00000000
> Oops: 0000 [#1]
> SMP 
> Modules linked in: aic94xx scsi_transport_sas_domain scsi_transport_sas uhci_hcd usbcore tg3 ext3 jbd mbcache sr_mod cdrom sd_mod aic79xx scsi_transport_spi scsi_mod
> CPU:    1
> EIP:    0060:[<f88f14cd>]    Not tainted VLI
> EFLAGS: 00010297   (2.6.18-rc1 #10) 
> EIP is at sas_discover_event+0x1d/0xa0 [scsi_transport_sas_domain]
> eax: 00000000   ebx: 00000000   ecx: c011de75   edx: 00000000
> esi: 00000001   edi: 00000044   ebp: f7019f18   esp: f7019efc
> ds: 007b   es: 007b   ss: 0068
> Process scsi_wq_2 (pid: 2256, ti=f7018000 task=f7052aa0 task.ti=f7018000)
> Stack: de7c0c04 00000009 f7019f18 c011e02b 00000001 de7c0c04 00000009 f7019f34 
>        f88f0e83 00000000 00000001 de7c0a04 de7c0a08 dff71118 f7019f68 c012ef4c 
>        de7c09d4 dff71160 00000001 dff71158 dff711a0 00000286 f88f0e10 de7c09d4 
> Call Trace:
>  [<f88f0e83>] sas_porte_broadcast_rcvd+0x73/0x80 [scsi_transport_sas_domain]
>  [<c012ef4c>] run_workqueue+0x7c/0x100
>  [<c012f1a5>] worker_thread+0x115/0x150
>  [<c0132a9d>] kthread+0xfd/0x110
>  [<c0100ea5>] kernel_thread_helper+0x5/0x10
> Code: 5e 5f 5d c3 8d 76 00 8d bc 27 00 00 00 00 55 89 e5 83 ec 1c 89 75 f8 8b 75 0c 89 5d f4 8b 5d 08 89 7d fc 83 fe 02 8d 7b 44 77 74 <8b> 83 14 02 00 00 8b 40 6c 89 45 ec 8d 04 76 c1 e0 04 8d 44 03 
> EIP: [<f88f14cd>] sas_discover_event+0x1d/0xa0 [scsi_transport_sas_domain] SS:ESP 0068:f7019efc
>  <5>aic94xx: escb_tasklet_complete: phy2: PRIMITIVE_RECVD
> 
> I think what happens is that the broadcast comes in before the aic94xx
> has allocated a port to the phy (so phy->port is null in
> sas_porte_boradcast_rcvd).
> 

Yes, since we have not formed a port yet on phy1 it would appear that we
could just drop this event if port is null as we are going to do discovery
post port forming the port anyway.


-andmike
--
Michael Anderson
andmike@us.ibm.com
