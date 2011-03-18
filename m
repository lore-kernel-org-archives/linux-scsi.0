From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Fri, 18 Mar 2011 15:09:02 -0700
Message-ID: <1300486142.20672.47.camel@haakon2.linux-iscsi.org>
References: <1297366739.18212.182.camel@haakon2.linux-iscsi.org>
	 <4D55A684.9060208@linux.vnet.ibm.com>
	 <1297542446.29128.0.camel@mulgrave.site>
	 <20110307134033K.fujita.tomonori@lab.ntt.co.jp>
	 <1299508803.12730.1.camel@mulgrave.site>
	 <4D83C78D.5040908@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47600 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab1CRWQM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2011 18:16:12 -0400
In-Reply-To: <4D83C78D.5040908@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

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
> a couple times.

Hi Bryan,

Thank you for your testing.  Unfortuately my p505 is still not enabled
with VIOS firmware, so I can't reproduce these issues directly at the
moment..

> The first one was during shutdown, which I wasn't able to collect
> any data for.

Ok, I will take a moment in the next week to review the active I/O
shutdown code for the demo mode TPG case that tcm ibmvscsis is currently
using.

Note that a active I/O shutdown bug was recently fixed and merged
into .38-FINAL here:

target: Fix t_transport_aborted handling in LUN_RESET + active I/O shutdown
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commitdiff;h=52208ae3fc60cbcb214c10fb8b82304199e2cc3a

reported via here:

https://bugzilla.kernel.org/show_bug.cgi?id=29442

This was originally involving the shutdown of active I/O to explict
NodeACLs and MappedLUNs in:

/sys/kernel/config/target/$FABRIC_MOD/$TARGET_WWN/tpgt_$TPGT/acls/

I am fairly certain this is going to apply to modules like tcm ibmvscsis
that do not use explict NodeACLs or MappedLUNs, but instead use demo
mode TPG access by default for initiator login access.

> The most recent occurred when a client was trying to login for the
> first time:
> 
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

Tomo-san, do you have any input on this particular issue..?

Also sending along any gdb output from this backtrace and full dmesg
context to me offline to grok would be greatly appericated.

FYI, the lio-core-2.6.git/tcm_ibmvscsis branch w/ Tomo-san's latest v3
code has been updated to LIO v4.0.0-rc7 / .38-FINAL code..  Please grab
this code or the .38 bugfix mentioned above for active I/O shutdown case
and retest this case at your earliest convenience.

Best Regards,

--nab

