From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: QLA Driver Error on boot
Date: Wed, 15 Mar 2006 08:30:32 -0800
Message-ID: <20060315163032.GE1290@andrew-vasquezs-powerbook-g4-15.local>
References: <200603151653.05839.Michael.Stuebiger@rz.ifi.lmu.de> <20060315162234.GD1290@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:4207 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1752128AbWCOQae (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Mar 2006 11:30:34 -0500
Content-Disposition: inline
In-Reply-To: <20060315162234.GD1290@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Stuebiger <Michael.Stuebiger@rz.ifi.lmu.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 15 Mar 2006, Andrew Vasquez wrote:

> On Wed, 15 Mar 2006, Michael Stuebiger wrote:
> 
> > We are using kernel version 2.6.15.6 and we noticed some odd behavior of the qla2xxx driver.
> > Sometimes the machines boot without incident and at other times the following error occurs:
> > 
> > klogd 1.4.1#17, log source = /proc/kmsg started.
> > Inspecting /boot/System.map-2.6.15.6
> > Loaded 38338 symbols from /boot/System.map-2.6.15.6.
> > Symbols match kernel version 2.6.15.
> > No module symbols loaded - kernel modules not enabled.
> > tainted 2.6.15.6 #1
> > [   62.255008] RIP: 0010:[__delay+8/16] <ffffffff80270489>{__delay+8}
> > [   62.255150] RSP: 0000:ffff81007ffdbab0  EFLAGS: 00000283
> > [   62.255344] RAX: 00000000e06fa013 RBX: ffff810001ec0488 RCX: 00000000e06f9f0f
> > [   62.255460] RDX: 000000000000001c RSI: 0000000000000246 RDI: 0000000000004a38
> > [   62.255576] RBP: 00000000fffc3e81 R08: 0000000000000000 R09: 0000000000000000
> > [   62.255692] R10: 0000000000000000 R11: 0000000000000000 R12: ffff81007ffdbb58
> > [   62.255809] R13: 0000000000000000 R14: 0000000000800000 R15: ffffc20000004000
> > [   62.255926] FS:  0000000000000000(0000) GS:ffffffff807d0800(0000) knlGS:0000000000000000
> > [   62.256077] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > [   62.256187] CR2: 0000000000000000 CR3: 0000000000101000 CR4: 00000000000006e0
> > [   62.256303]
> > [   62.256304] Call Trace:<ffffffff80319a89>{qla2x00_mailbox_command+554} <ffffffff80319b60>{qla2x00_mailbox_command+769}
> > [   62.256693]        <ffffffff8031a908>{qla2x00_login_fabric+110} <ffffffff8031a542>{qla2x00_get_port_database+381}
> > [   62.257072]        <ffffffff8031866a>{qla2x00_fabric_login+62} <ffffffff80318300>{qla2x00_find_all_fabric_devs+1126}
> 
> This looks like a soft-lockup backtrace occuring during mbx command
> completion polling.  This issue was addressed post-2.6.15:
> 
> [SCSI] qla2xxx: Use msleep() as delay during ISP polling.
> http://gitlnx/cgi-bin/gitweb.cgi?p=avasquez/qla2xxx-upstream.git;a=commitdiff;h=03ab2eabed74708c0c74163723007e8e72244219;hp=e038a1be22bef90795c5239d1563609b89c3aa18

And a link to a local repository certainly won't help.  Here's the
info from kernel.org:

http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=03ab2eabed74708c0c74163723007e8e72244219

--
AV
