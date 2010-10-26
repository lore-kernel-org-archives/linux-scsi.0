From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] fix id computation in scsi_eh_target_reset()
Date: Tue, 26 Oct 2010 15:10:24 -0500
Message-ID: <1288123824.8283.524.camel@mulgrave.site>
References: <AANLkTin-Tkj3Ab312usO2FWE57m3St2iG2oz881F-Zhw@mail.gmail.com>
	 <4CBBDC19.1090806@cs.wisc.edu>	<1288040021.5487.826.camel@mulgrave.site>
	 <AANLkTinoSSJcKX_V+SZRz3trc6i8ozTidAsYPaM120pv@mail.gmail.com>
	 <4CC7366B.8080203@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab0JZUK2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2010 16:10:28 -0400
In-Reply-To: <4CC7366B.8080203@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hillf Danton <dhillf@gmail.com>, linux-scsi@vger.kernel.org

On Tue, 2010-10-26 at 15:13 -0500, Mike Christie wrote:
> I was not sure if you are in a rush to get this in.

No real rush ... although technically it's an enhancement rather than a
bug fix ...

>  I have been testing 
> it, but am hitting a bug below. This does not seem to be related to your 
> patch. I am hitting it with or without your patch.
> 
> Your patch looks ok, and it seems to work.
> 
> 
> Oct 27 07:51:11 noisymax kernel: ------------[ cut here ]------------
> Oct 27 07:51:11 noisymax kernel: WARNING: at lib/list_debug.c:30 
> __list_add+0x8f/0xa0()
> Oct 27 07:51:11 noisymax kernel: Hardware name: X7DB8
> Oct 27 07:51:11 noisymax kernel: list_add corruption. prev->next should 
> be next (ffff88013e86be50), but was ffff88012b7d2518. 
> (prev=ffff88012b7d2518).
> Oct 27 07:51:11 noisymax kernel: Modules linked in: bnx2i cnic uio 
> autofs4 fcoe libfcoe libfc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 
> iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 
> nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables 
> ipv6 ib_mthca ib_mad ib_core e1000e be2iscsi iscsi_boot_sysfs libiscsi 
> scsi_transport_iscsi bnx2x crc32c libcrc32c mdio be2net 8250_pnp 8250 
> serial_core shpchp button lpfc qla2xxx scsi_transport_fc [last unloaded: 
> mperf]
> Oct 27 07:51:11 noisymax kernel: Pid: 3076, comm: scsi_eh_12 Not tainted 
> 2.6.36+ #2
> Oct 27 07:51:11 noisymax kernel: Call Trace:
> Oct 27 07:51:11 noisymax kernel: [<ffffffff8104103a>] 
> warn_slowpath_common+0x7a/0xb0
> Oct 27 07:51:11 noisymax kernel: [<ffffffff81041111>] 
> warn_slowpath_fmt+0x41/0x50
> Oct 27 07:51:11 noisymax kernel: [<ffffffff812bf180>] ? dev_printk+0x40/0x50
> Oct 27 07:51:11 noisymax kernel: [<ffffffff8122e6df>] __list_add+0x8f/0xa0
> Oct 27 07:51:11 noisymax kernel: [<ffffffff812d2bd6>] 
> scsi_eh_finish_cmd+0x36/0x40
> Oct 27 07:51:11 noisymax kernel: [<ffffffff812d3600>] 
> scsi_eh_ready_devs+0x320/0x860
> Oct 27 07:51:11 noisymax kernel: [<ffffffff812d41c4>] 
> scsi_error_handler+0x4a4/0x640
> Oct 27 07:51:11 noisymax kernel: [<ffffffff812d3d20>] ? 
> scsi_error_handler+0x0/0x640
> Oct 27 07:51:11 noisymax kernel: [<ffffffff81062af6>] kthread+0x96/0xa0
> Oct 27 07:51:11 noisymax kernel: [<ffffffff81003bd4>] 
> kernel_thread_helper+0x4/0x10
> Oct 27 07:51:11 noisymax kernel: [<ffffffff813ed180>] ? 
> restore_args+0x0/0x30
> Oct 27 07:51:11 noisymax kernel: [<ffffffff81062a60>] ? kthread+0x0/0xa0
> Oct 27 07:51:11 noisymax kernel: [<ffffffff81003bd0>] ? 
> kernel_thread_helper+0x0/0x10
> Oct 27 07:51:11 noisymax kernel: ---[ end trace 74b14fae9ff067be ]---

This looks like it could possibly be a removal race error (like the one
there's a fix in scsi-misc for) ... what was going on on the box at the
time?

James


