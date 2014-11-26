From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: [Scst-devel] New qla2x00tgt Driver Question
Date: Wed, 26 Nov 2014 12:10:35 -0600
Message-ID: <201411261810.sAQIAZvK007325@wind.enjellic.com>
References: <marc.smith@mcc.edu>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:53145 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbaKZSaL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2014 13:30:11 -0500
In-Reply-To: Marc Smith <marc.smith@mcc.edu>
       "[Scst-devel] New qla2x00tgt Driver Question" (Nov 19, 11:54am)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc Smith <marc.smith@mcc.edu>, scst-devel <scst-devel@lists.sourceforge.net>
Cc: duane.grigsby@qlogic.com, linux-scsi@vger.kernel.org

On Nov 19, 11:54am, Marc Smith wrote:
} Subject: [Scst-devel] New qla2x00tgt Driver Question

> Hi,

Hi, I hope the day continues to go well for everyone.

It is -15C here with a -26C windchill so Izzy, my golden retriever and
I, are answering e-mails rather then putting up outside Christmas
decorations.

> I've noticed a change in behavior with the new qla2x00tgt
> driver. With the previous version of this driver, sessions to Fibre
> Channel switches were deleted, but now they seem to stay around
> indefinitely (eg, they show up in the list of sessions for a target
> in SCST).

It seems to be a generic problem with the Qlogic target driver
architecture.  There really is only one target driver, but
unfortunately for everyone involved, multiple variants.

I'm including linux-scsi on this since this is as much a problem for
the mainline kernel storage infrastructure as it is for SCST.

I believe I may have mentioned before that the entire storage
community, which is dependent on Qlogic hardware, needs to rally
around a single version of this target architecture... :-)(

> I've also noticed this behavior for remote target interfaces if I zone
> multiple SCST targets together (eg, target interfaces from multiple SCST
> hosts), and I load the "qla2xxx_scst" module first which puts it into
> initiator mode initially, and then load qla2x00t which changes it to target
> mode (qlini_mode=exclusive). On one of the SCST host it sees it initially
> in initiator mode which establishes a session, and on the remote SCST host
> its then switched to target mode as initialization progresses, the dead
> initiator session sticks around in the list of sessions for that target.
> Its never removed even though the SCST target interface is now only in
> "target mode".
> 
> Its really not hurting anything, but was curious if this is expected
> behavior, or is it a new/changed option that needs to be set for the
> qla2xxx_scst module?

I'm not totally convinced that this is harmless behavior given our
work on Qlogic/Cisco fibre-channel task management stability, see my
most recent post today.

> I see another similar post that may or may not be related:
> http://sourceforge.net/p/scst/mailman/message/32823494/
> 
> That user refers to an error message I do not see in my logs, but some of
> the other messages in the log are similar to whats below... probably
> because those messages are common. Figured it was worth mentioning in case
> they are related.
> 
> Linux: 3.14.19 (SCST patches applied)
> SCST: trunk/r5854
> qla2x00t_git: 8.07.00.16.Trunk-SCST.15-k (from qla_version.h)
> 
> I believe this is the relative section of logs for session
> "2f:fc:00:c0:dd:0d:b3:6d" (a QLogic Fibre Channel switch):
> --snip--
> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978104] qla2xxx
> [0000:05:00.0]-500a:9: LOOP UP detected (4 Gbps).
> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978120] [0]:
> q2t_async_event:6406:qla2x00t(9): Loop up occured
> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978171] [0]:
> q2t_async_event:6430:qla2x00t(9): Port update async event 0x8014 occured
> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978188] [0]:
> q24_handle_els:4893:qla2x00t(9): ELS opcode 3 hndl 0x0 ox_id=0x2a69
> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978194] [0]:
> q24_handle_els:4903:ELS PLOGI rcv 0x2ffc00c0dd0db36d portid=fffc04 hndl 0x0
> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978201] [0]:
> q2t_sched_sess_work:1795:Scheduling work (type 5, prm ffff880229c923c0) to
> find session for param ffff8800a2d1c2c0 (size 64, tgt
> ffff88011dea41b8)

I was very interested in seeing your mail Marc, since it confirms
issues we have been tracking and documenting for some time.

What appears to be happening is that the target driver, regardless of
pedigree, is establishing sessions for the Fibre-Channel Name Services
(FCNS) directory servers which are running on each switch.  You can
find the clue in your following debug line from above:

Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978194] [0]: q24_handle_els:4903:ELS PLOGI rcv 0x2ffc00c0dd0db36d portid=fffc04 hndl 0x0
				^^^^^^^^^^^^^

The first two octets, ff:fc, is the 'well-known' address of the FCNS
name server on each switch.  The octet '04', in your case, is the
domain id of the switch on which the nameserver is running.

As I noted in my other e-mail this morning, we are running down issues
with possible task management function (TMF) regressions in a large
storage fabric.  We believe that occurrences of a TMF are linked to
catastrophic VMware/VMFS corruption.

Here is a snippet from our logs when we induce a NEXUS_LOSS_SESS event
in a multi-datacenter/multi-hop Cisco Nexus FCOE fabric:

Sep  3 13:58:31 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f842:9: Unable to find initiator with S_ID ff:fc:bf
			   ^^^^^^^^-> NOTE

Sep  3 13:58:32 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f820:9: Terminating work cmd ffff880818f484d0 <4>qla2xxx [0000:02:00.3]-f810:9: qla_target(0): ABTS: Unknown Exchange Address received

Issueing the following command on one of the core 7010 switches:

show fcns internal info vsan 2020

Yields the following:

Info for vsan 2020
=================
Interop mode: 0
R_A_TOV: 10000; D_S_TOV: 5000
Local Domain: 0x90(144)
Remote Domains: 0xe(14) 0x45(69) 0x71(113) 0xbf(191)

Which demonstrates, as you can see, that the 'bf' in our case is the
identity of one of the switches/domains in the fabric.

I omitted the log entries but we also see similar messages for the
0x71 and 0x45 switches/domains during each event.  The 0xe switch is
in a third data-center we have projected converged traffic to since
these tests were run.  I'm sure we will see the 0xe switch included in
the logs when we resume our testing.

We need to add additional debug code to confirm this but what we think
is happening is that the target driver is establishing sessions for
each of the FCNS servers when the target port establishes its fabric
login.  When an asynchronous event occurs on the fabric, such as a
NEXUS_LOSS_SESS, each of the FCNS servers issues the following
sequence of Extended Link Service (ELS) actions against the target:

	PLOGI	(Port login)
	PRLI	(Process login)
	ADISC	(Device discovery)

Which I am not convinced is well handled by any of the target driver
variants or storage stacks which use this infrastructure.  In our
environment the firmware/card/stack has to handle 3 x
NUMBER_OF_SWITCHES actions on each event.

One of the interesting things we seem to be seeing is that only the
Nexus 55xx ingress switches seem to be establishing these sessions.
We have not documented the storage VDC's on the 7009/7010 core
switches doing this.  The target server from which the log was
generated is directly attached to a 7009 on the backbone of this
fabric.  There is an adjacent 7010 which should, in theory, be doing
this as well, if our analysis on the root cause of this is correct.

As the log above notes we believe that all of this is possibly
implicated in abort sequence processing issues.  We have tracked the
issue with the 'unknown exchange address' back into the IOCB coming
out of the ISP engine on the Qlogic 8362 FCOE cards which is about as
far as we can take this without knowing what is going on inside the
card.

We are also suspicious, as you indicate, that this may having
something to do with the fabric port on the target coming up in
iniatiator and then transitioning to target mode.  Obviously the FCNS
directory servers are involved in tracking the state of the ports.
One of the things we are going to rigidly document is if this FCNS
target session establishment can be avoided by only allowing the
target port login to occur after the interface is broadcasting FCP
target status.

The open question seems to be how to handle the root cause of this
issue which is the fact that the target code is granting sessions to
the FCNS directory servers.  Even if it is harmless it would seem to
be anomalous behavior which, in the storage business, is one of those
'nothing good will come of this' type issues.

> Thanks,
> 
> Marc

I hope everyone in the business is able to enjoy a pleasant holiday
weekend, free from SMART anomalies and link drops.

Did I mention the fact that all of this is way too spooky and complex
to be using three separate variants of the same code.... 

Greg and Izzy

}-- End of excerpt from Marc Smith

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Don't talk unless you can improve the silence."
                                -- George Will
