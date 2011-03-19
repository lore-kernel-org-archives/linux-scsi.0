From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Sat, 19 Mar 2011 10:32:31 -0400
Message-ID: <1300545151.12679.7.camel@mulgrave.site>
References: <1297366739.18212.182.camel@haakon2.linux-iscsi.org>
	 <4D55A684.9060208@linux.vnet.ibm.com>
	 <1297542446.29128.0.camel@mulgrave.site>
	 <20110307134033K.fujita.tomonori@lab.ntt.co.jp>
	 <1299508803.12730.1.camel@mulgrave.site>
	 <4D83C78D.5040908@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59074 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab1CSOcm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2011 10:32:42 -0400
In-Reply-To: <4D83C78D.5040908@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On Fri, 2011-03-18 at 15:58 -0500, Brian King wrote:
> On 03/07/2011 08:40 AM, James Bottomley wrote:
> > On Mon, 2011-03-07 at 13:41 +0900, FUJITA Tomonori wrote:
> >> On Sat, 12 Feb 2011 14:27:26 -0600
> >> James Bottomley <James.Bottomley@suse.de> wrote:
> >>
> >>>> Disregard my previous comment. It looks like current client should handle reservations
> >>>> just fine without any further changes.
> >>>
> >>> So is that an ack for putting this in scsi-misc ... or did you want to
> >>> do more testing first?
> >>
> >> Ping,
> >>
> >> Brian, James, can we merge this during the next merge window?
> > 
> > I'm still waiting for an ack from Brian.
> 
> Sorry for the delay... I've got this loaded in the lab and have managed to oops
> a couple times. The first one was during shutdown, which I wasn't able to collect
> any data for. The most recent occurred when a client was trying to login for the
> first time:

OK, that's a bit of a show stopper, then.

> Modules linked in: target_core_pscsi target_core_file target_core_iblock ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6table_filter ip6_tables x_tables ipv6 fuse loop dm_mod ibmvscsis libsrp scsi_tgt target_core_mod sg configfs ibmveth ses enclosure ext3 jbd mbcache sd_mod crc_t10dif ipr libata scsi_mod
> NIP: d000000004a01dc4 LR: d000000004a01db4 CTR: c0000000005b36a0
> REGS: c00000033fb139d0 TRAP: 0300   Not tainted  (2.6.38-rc7-0.7-ppc64-00163-gfb62c00-dirty)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 28002022  XER: 00000002
> DAR: 0000000000000000, DSISR: 40000000
> TASK = c00000033fb08d70[89] 'kworker/0:1' THREAD: c00000033fb10000 CPU: 0
> GPR00: 0000000000000000 c00000033fb13c50 d000000004a0bff8 c00000033f84de94 
> GPR04: d000000004a03c74 0000000000000001 0000000000000002 0000000000000001 
> GPR08: fffffffffffffffc 0000000080000000 0000000000000000 0000000000000000 
> GPR12: d000000004a02e58 c00000000f190000 0000000000000200 0000000000000008 
> GPR16: 0000000000000008 c000000004821110 0000000000000000 0000000000000000 
> GPR20: c00000033e9e66d8 c00000033f84ddf8 c00000033f84de00 c00000033f84de94 
> GPR24: 000000033f4e0000 c00000033e9e6680 c00000033f84dd80 c00000033bd60000 
> GPR28: 0000000000000024 c000000000000000 d000000004a0c008 8000000000000000 
> NIP [d000000004a01dc4] .handle_crq+0x7ac/0xa60 [ibmvscsis]
> LR [d000000004a01db4] .handle_crq+0x79c/0xa60 [ibmvscsis]

Can you get a better handle on this location?  It's clearly inside one
of the expanded static functions, but knowing which one would help Tomo
debug it.

James


> Call Trace:
> [c00000033fb13c50] [d000000004a01db4] .handle_crq+0x79c/0xa60 [ibmvscsis] (unreliable)
> [c00000033fb13d60] [c0000000000c0e38] .process_one_work+0x198/0x518
> [c00000033fb13e10] [c0000000000c1694] .worker_thread+0x1f4/0x518
> [c00000033fb13ed0] [c0000000000c9ddc] .kthread+0xb4/0xc0
> [c00000033fb13f90] [c00000000001e864] .kernel_thread+0x54/0x70
> Instruction dump:
> 7be05f60 2f800000 409e016c 7be086e0 2f800000 409e0160 7ee3bb78 480010a9 
> e8410028 7be046a0 e97a0140 780045e4 <7d2b002e> 2f890001 419e000c 3800007f 
> 
> Prior to DLPAR adding a vscsi client adapter to my client LPAR, which caused
> the VIOS crash, I had created a single file backed disk:
> 
> tcm_node --fileio fileio_0/test  /vdisks/test 1000000
>  ConfigFS HBA: fileio_0
> Successfully added TCM/ConfigFS HBA: fileio_0
>  ConfigFS Device Alias: test
> Device Params ['fd_dev_name=/vdisks/test,fd_dev_size=1000000']
> Status: DEACTIVATED  Execute/Left/Max Queue Depth: 0/32/32  SectorSize: 512  MaxSectors: 1024
>         TCM FILEIO ID: 0        File: /vdisks/test  Size: 1000000  Mode: Synchronous
> Set T10 WWN Unit Serial for fileio_0/test to: 092a1bf2-92d9-4bb0-aceb-39ce865c8a80
> Successfully created TCM/ConfigFS storage object: /sys/kernel/config/target/core/fileio_0/test
> 
> -Brian
> 
> 


