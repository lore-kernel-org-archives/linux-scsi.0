From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: stuck in megaraid_sas.c megasas_adp_reset_gen2
Date: Wed, 11 Apr 2012 15:44:27 -0600
Message-ID: <201204111544.27866.thomas@fjellstrom.ca>
References: <201203211716.45418.thomas@fjellstrom.ca> <201204111417.28893.thomas@fjellstrom.ca> <CAHtARFERLPA345Qsp=-_+5BGAdOrLaJ+HLGzqENBFNRXNJMDhg@mail.gmail.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tomasu.net ([64.85.170.232]:47282 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760879Ab2DKVob (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Apr 2012 17:44:31 -0400
In-Reply-To: <CAHtARFERLPA345Qsp=-_+5BGAdOrLaJ+HLGzqENBFNRXNJMDhg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed Apr 11, 2012, adam radford wrote:
> On Wed, Apr 11, 2012 at 1:17 PM, Thomas Fjellstrom <thomas@fjellstrom.ca> 
wrote:
> >> ADP_RESET_GEN2: HostDiag=a0
> >> 
> >> followed by a bunch of:
> >> 
> >> RESET_GEN2: retry=%x, hostdiag=a4
> >> 
> >> Now I'm not sure the hostdiag should be different between the two. if
> >> this aN identifier is similar to the aN identifiers in the MegaCli
> >> tool, then it would mean its trying to reset a device that doesn't
> >> exist? I only have a single M1015 card installed.
> 
> host diag register output a0 or a4 has absolutely nothing to do with
> MegaCli -aN command line argument for specifying adapter number.
> 
> > I just got a second M1015 card in today and gave it a go. Similar issues,
> > different log messages. (hand typed from picture taken of screens)
> > 
> > Lots of:
> > 
> > megasas: Waiting for 1 commands to complete
> 
> Can you try booting with kernel command line argument pcie_aspm=off

No problem.

Things are quite similar. Startup goes like:

<detected a onboard sata ports>
scsi: waiting for bus probes to complete...
Refined TSC...
Switched to clocksource tsc
<pause here>
udevd[...]: timeout: killing '/sbin/modprobe -b ...' (lots of these, so much 
that I hit scroll lock so I can see the kernel messages as they come up)
scsi 0:0:0:0: megasas: RESET cmd=12 retries=0
megasas: [ 0] waiting for 1 commands to complete
(many more waiting messages)
<hung task kworker/u:4>
Call Trace:
  [<ffffffff810641d0>] ? async_synchronize_cookie_domain+0xb2/...c
  [<ffffffff8105f583>] ? add_wait_queue+0x3c/0x3c
  ....
megasas: [55] waiting for 1 commands to complete
....
megasas: [175] waiting for 1 commands to complete
megasas: moving cmd[0]:ffff880234bcb940:0:ffff88002339beec0 the defer queue as 
internal
megaraid_sas: FW detected to be in faultstate, restarting it...
ADP_RESET_GEN2: HostDiag=a0
(10s wait)
megaraid_sas: FW restarted successfully,initializing next stage...
megaraid_sas: HBA recovery state machine,state 2 starting...
(30s wait)
megasas: Waiting for FW to come to ready state
megasas: FW now in ready state
megaraid_sas: command ffff880234bcb940, ffff8802339beec0:0detected to be pending 
while HBA reset
megasas: ffff880234bcb940 scsi cmd [12]detected on the internal queue, issue 
again.
megasas: reset successful
scsi: 0:0:0:0: megasas: RESET cmd=12 retries 0
megaraid_sas: no pending cmds after reset
megasas: reset successful
(20s wait)
(device offlined message here, missed it this time)
(detected all sata devices)

And it stalled there.

> -Adam


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
