From: Duane Grigsby <duane.grigsby@qlogic.com>
Subject: Re: [Scst-devel] New qla2x00tgt Driver Question
Date: Sun, 30 Nov 2014 16:00:15 +0000
Message-ID: <2D7BBED629475F4BAA85CF6AB9702F130108802875@AVMB1.qlogic.org>
References: <marc.smith@mcc.edu>
 <201411261810.sAQIAZvK007325@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_2D7BBED629475F4BAA85CF6AB9702F130108802875AVMB1qlogicor_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:47831 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbaK3QAT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2014 11:00:19 -0500
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id sAUFwYvZ020024
	for <linux-scsi@vger.kernel.org>; Sun, 30 Nov 2014 08:00:18 -0800
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1qw5yu5bkb-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 30 Nov 2014 08:00:17 -0800
In-Reply-To: <201411261810.sAQIAZvK007325@wind.enjellic.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "greg@enjellic.com" <greg@enjellic.com>, Marc Smith <marc.smith@mcc.edu>, scst-devel <scst-devel@lists.sourceforge.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--_000_2D7BBED629475F4BAA85CF6AB9702F130108802875AVMB1qlogicor_
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <C1846F1BD09EDF4894B708CB2168F570@qlogic.com>
Content-Transfer-Encoding: quoted-printable



On 11/26/14, 10:10 AM, "Dr. Greg Wettstein" <greg@wind.enjellic.com> wrote:

>On Nov 19, 11:54am, Marc Smith wrote:
>} Subject: [Scst-devel] New qla2x00tgt Driver Question
>
>> Hi,
>
>Hi, I hope the day continues to go well for everyone.
>
>It is -15C here with a -26C windchill so Izzy, my golden retriever and
>I, are answering e-mails rather then putting up outside Christmas
>decorations.
>
>> I've noticed a change in behavior with the new qla2x00tgt
>> driver. With the previous version of this driver, sessions to Fibre
>> Channel switches were deleted, but now they seem to stay around
>> indefinitely (eg, they show up in the list of sessions for a target
>> in SCST).
>
>It seems to be a generic problem with the Qlogic target driver
>architecture.  There really is only one target driver, but
>unfortunately for everyone involved, multiple variants.
>
>I'm including linux-scsi on this since this is as much a problem for
>the mainline kernel storage infrastructure as it is for SCST.
>
>I believe I may have mentioned before that the entire storage
>community, which is dependent on Qlogic hardware, needs to rally
>around a single version of this target architecture... :-)(
Yes, the =B3exclusive=B2 option is really not operating in exclusive target
mode.  The driver transitions to target mode from initiator mode, so
there=B9s a transition period. One way around this is to use the laser
control attribute. We can turn OFF the laser during initializaton and turn
it back ON after target is up and running.  We will look into this change
and see what can be done.


>
>> I've also noticed this behavior for remote target interfaces if I zone
>> multiple SCST targets together (eg, target interfaces from multiple SCST
>> hosts), and I load the "qla2xxx_scst" module first which puts it into
>> initiator mode initially, and then load qla2x00t which changes it to
>>target
>> mode (qlini_mode=3Dexclusive). On one of the SCST host it sees it
>>initially
>> in initiator mode which establishes a session, and on the remote SCST
>>host
>> its then switched to target mode as initialization progresses, the dead
>> initiator session sticks around in the list of sessions for that target.
>> Its never removed even though the SCST target interface is now only in
>> "target mode".
>>=20
>> Its really not hurting anything, but was curious if this is expected
>> behavior, or is it a new/changed option that needs to be set for the
>> qla2xxx_scst module?
>
>I'm not totally convinced that this is harmless behavior given our
>work on Qlogic/Cisco fibre-channel task management stability, see my
>most recent post today.
Interesting, I haven=B9t seen that posting. Did you post it to scst-devel o=
r
linux-scsi?

>
>> I see another similar post that may or may not be related:
>> http://sourceforge.net/p/scst/mailman/message/32823494/
>>=20
>> That user refers to an error message I do not see in my logs, but some
>>of
>> the other messages in the log are similar to whats below... probably
>> because those messages are common. Figured it was worth mentioning in
>>case
>> they are related.
>>=20
>> Linux: 3.14.19 (SCST patches applied)
>> SCST: trunk/r5854
>> qla2x00t_git: 8.07.00.16.Trunk-SCST.15-k (from qla_version.h)
>>=20
>> I believe this is the relative section of logs for session
>> "2f:fc:00:c0:dd:0d:b3:6d" (a QLogic Fibre Channel switch):
>> --snip--
>> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978104] qla2xxx
>> [0000:05:00.0]-500a:9: LOOP UP detected (4 Gbps).
>> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978120] [0]:
>> q2t_async_event:6406:qla2x00t(9): Loop up occured
>> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978171] [0]:
>> q2t_async_event:6430:qla2x00t(9): Port update async event 0x8014 occured
>> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978188] [0]:
>> q24_handle_els:4893:qla2x00t(9): ELS opcode 3 hndl 0x0 ox_id=3D0x2a69
>> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978194] [0]:
>> q24_handle_els:4903:ELS PLOGI rcv 0x2ffc00c0dd0db36d portid=3Dfffc04 hnd=
l
>>0x0
>> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978201] [0]:
>> q2t_sched_sess_work:1795:Scheduling work (type 5, prm ffff880229c923c0)
>>to
>> find session for param ffff8800a2d1c2c0 (size 64, tgt
>> ffff88011dea41b8)
Yes, it may be related. It has to do with receiving a PLOGI from an
initiator with the same port_id, but a different WWPN. Can you send me
your complete driver log?
=20
>
>I was very interested in seeing your mail Marc, since it confirms
>issues we have been tracking and documenting for some time.
>
>What appears to be happening is that the target driver, regardless of
>pedigree, is establishing sessions for the Fibre-Channel Name Services
>(FCNS) directory servers which are running on each switch.  You can
>find the clue in your following debug line from above:
>
>Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978194] [0]:
>q24_handle_els:4903:ELS PLOGI rcv 0x2ffc00c0dd0db36d portid=3Dfffc04 hndl
>0x0
>				^^^^^^^^^^^^^
>
>The first two octets, ff:fc, is the 'well-known' address of the FCNS
>name server on each switch.  The octet '04', in your case, is the
>domain id of the switch on which the nameserver is running.
>
>As I noted in my other e-mail this morning, we are running down issues
>with possible task management function (TMF) regressions in a large
>storage fabric.  We believe that occurrences of a TMF are linked to
>catastrophic VMware/VMFS corruption.
>
>Here is a snippet from our logs when we induce a NEXUS_LOSS_SESS event
>in a multi-datacenter/multi-hop Cisco Nexus FCOE fabric:
>
>Sep  3 13:58:31 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f842:9:
>Unable to find initiator with S_ID ff:fc:bf
>			   ^^^^^^^^-> NOTE
>
>Sep  3 13:58:32 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f820:9:
>Terminating work cmd ffff880818f484d0 <4>qla2xxx [0000:02:00.3]-f810:9:
>qla_target(0): ABTS: Unknown Exchange Address received
>
>Issueing the following command on one of the core 7010 switches:
>
>show fcns internal info vsan 2020
>
>Yields the following:
>
>Info for vsan 2020
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>Interop mode: 0
>R_A_TOV: 10000; D_S_TOV: 5000
>Local Domain: 0x90(144)
>Remote Domains: 0xe(14) 0x45(69) 0x71(113) 0xbf(191)
>
>Which demonstrates, as you can see, that the 'bf' in our case is the
>identity of one of the switches/domains in the fabric.
>
>I omitted the log entries but we also see similar messages for the
>0x71 and 0x45 switches/domains during each event.  The 0xe switch is
>in a third data-center we have projected converged traffic to since
>these tests were run.  I'm sure we will see the 0xe switch included in
>the logs when we resume our testing.
>
>We need to add additional debug code to confirm this but what we think
>is happening is that the target driver is establishing sessions for
>each of the FCNS servers when the target port establishes its fabric
>login.  When an asynchronous event occurs on the fabric, such as a
>NEXUS_LOSS_SESS, each of the FCNS servers issues the following
>sequence of Extended Link Service (ELS) actions against the target:
>
>	PLOGI	(Port login)
>	PRLI	(Process login)
>	ADISC	(Device discovery)
>
>Which I am not convinced is well handled by any of the target driver
>variants or storage stacks which use this infrastructure.  In our
>environment the firmware/card/stack has to handle 3 x
>NUMBER_OF_SWITCHES actions on each event.
>
>One of the interesting things we seem to be seeing is that only the
>Nexus 55xx ingress switches seem to be establishing these sessions.
>We have not documented the storage VDC's on the 7009/7010 core
>switches doing this.  The target server from which the log was
>generated is directly attached to a 7009 on the backbone of this
>fabric.  There is an adjacent 7010 which should, in theory, be doing
>this as well, if our analysis on the root cause of this is correct.
>
>As the log above notes we believe that all of this is possibly
>implicated in abort sequence processing issues.  We have tracked the
>issue with the 'unknown exchange address' back into the IOCB coming
>out of the ISP engine on the Qlogic 8362 FCOE cards which is about as
>far as we can take this without knowing what is going on inside the
>card.
>
>We are also suspicious, as you indicate, that this may having
>something to do with the fabric port on the target coming up in
>iniatiator and then transitioning to target mode.  Obviously the FCNS
>directory servers are involved in tracking the state of the ports.
>One of the things we are going to rigidly document is if this FCNS
>target session establishment can be avoided by only allowing the
>target port login to occur after the interface is broadcasting FCP
>target status.
>
>The open question seems to be how to handle the root cause of this
>issue which is the fact that the target code is granting sessions to
>the FCNS directory servers.  Even if it is harmless it would seem to
>be anomalous behavior which, in the storage business, is one of those
>'nothing good will come of this' type issues.
Hi Greg, Yes, I think there may be a issue there, but let me look at your
logs. =20

>
>> Thanks,
>>=20
>> Marc
>
>I hope everyone in the business is able to enjoy a pleasant holiday
>weekend, free from SMART anomalies and link drops.
>
>Did I mention the fact that all of this is way too spooky and complex
>to be using three separate variants of the same code....
>
>Greg and Izzy
>
>}-- End of excerpt from Marc Smith
>
>As always,
>Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
>4206 N. 19th Ave.           Specializing in information infra-structure
>Fargo, ND  58102            development.
>PH: 701-281-1686
>FAX: 701-281-3949           EMAIL: greg@enjellic.com
>--------------------------------------------------------------------------
>----
>"Don't talk unless you can improve the silence."
>                                -- George Will


--_000_2D7BBED629475F4BAA85CF6AB9702F130108802875AVMB1qlogicor_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AAACAUEAAQAAAHAAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBEAHUAYQBuAGUAIABHAHIAaQBn
AHMAYgB5AAAAUwBNAFQAUAAAAGQAdQBhAG4AZQAuAGcAcgBpAGcAcwBiAHkAQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAHwACXQEAAAAyAAAAZAB1AGEAbgBlAC4AZwByAGkAZwBzAGIAeQBAAHEAbABv
AGcAaQBjAC4AYwBvAG0AAAAAAB8A5V8BAAAAOgAAAHMAaQBwADoAZAB1AGEAbgBlAC4AZwByAGkA
ZwBzAGIAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AGgwBAAAAHAAAAEQAdQBhAG4AZQAg
AEcAcgBpAGcAcwBiAHkAAAAfAB8MAQAAADIAAABkAHUAYQBuAGUALgBnAHIAaQBnAHMAYgB5AEAA
cQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAABw
AAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACARAB1AGEAbgBlACAARwByAGkAZwBzAGIAeQAAAFMA
TQBUAFAAAABkAHUAYQBuAGUALgBnAHIAaQBnAHMAYgB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAA
AB8AAV0BAAAAMgAAAGQAdQBhAG4AZQAuAGcAcgBpAGcAcwBiAHkAQABxAGwAbwBnAGkAYwAuAGMA
bwBtAAAAAAAfAPg/AQAAABwAAABEAHUAYQBuAGUAIABHAHIAaQBnAHMAYgB5AAAAHwAjQAEAAAAy
AAAAZAB1AGEAbgBlAC4AZwByAGkAZwBzAGIAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8A
IkABAAAACgAAAFMATQBUAFAAAAAAAAIB+T8BAAAAcAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAA
gEQAdQBhAG4AZQAgAEcAcgBpAGcAcwBiAHkAAABTAE0AVABQAAAAZAB1AGEAbgBlAC4AZwByAGkA
ZwBzAGIAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAldAQAAADIAAABkAHUAYQBuAGUALgBn
AHIAaQBnAHMAYgB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwAxQAEAAAACAAAAAAAAAAsA
QDoBAAAAHwAwQAEAAAACAAAAAAAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwDx
PwkEAAALAEA6AQAAAAMA/T/kBAAAAgELMAEAAAAQAAAARA+1xku1vkSAjbfkdkGgFAMAFwABAAAA
QAA5AIDRuLq2DNABQAAIMFpnK7u2DNABCwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAFIUAAAEAAAAf
AACAhgMCAAAAAADAAAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAA
AAABAAAADAAAAGUAbgAtAFUAUwAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAAHwA3
AAEAAABgAAAAUgBlADoAIABbAFMAYwBzAHQALQBkAGUAdgBlAGwAXQAgAE4AZQB3ACAAcQBsAGEA
MgB4ADAAMAB0AGcAdAAgAEQAcgBpAHYAZQByACAAUQB1AGUAcwB0AGkAbwBuAAAAHwA9AAEAAAAK
AAAAUgBlADoAIAAAAAAAAwA2AAAAAAAfAEIQAQAAAGAAAAA8ADIAMAAxADQAMQAxADIANgAxADgA
MQAwAC4AcwBBAFEASQBBAFoAdgBLADAAMAA3ADMAMgA1AEAAdwBpAG4AZAAuAGUAbgBqAGUAbABs
AGkAYwAuAGMAbwBtAD4AAAACAXEAAQAAABsAAAABAdAJpFERx6JAL1grRqhJ1JntKkfnnHlZ24AA
HwBwAAEAAABYAAAAWwBTAGMAcwB0AC0AZABlAHYAZQBsAF0AIABOAGUAdwAgAHEAbABhADIAeAAw
ADAAdABnAHQAIABEAHIAaQB2AGUAcgAgAFEAdQBlAHMAdABpAG8AbgAAAB8ANRABAAAAfAAAADwA
MgBEADcAQgBCAEUARAA2ADIAOQA0ADcANQBGADQAQgBBAEEAOAA1AEMARgA2AEEAQgA5ADcAMAAy
AEYAMQAzADAAMQAwADgAOAAwADIAOAA3ADUAQABBAFYATQBCADEALgBxAGwAbwBnAGkAYwAuAG8A
cgBnAD4AAAAfADkQAQAAAIoAAAA8AG0AYQByAGMALgBzAG0AaQB0AGgAQABtAGMAYwAuAGUAZAB1
AD4AIAA8ADIAMAAxADQAMQAxADIANgAxADgAMQAwAC4AcwBBAFEASQBBAFoAdgBLADAAMAA3ADMA
MgA1AEAAdwBpAG4AZAAuAGUAbgBqAGUAbABsAGkAYwAuAGMAbwBtAD4AAAAAAAMA3j+vbwAAQAAH
MGuAH7u2DNABAwAmAAAAAAACAUcAAQAAAC4AAABjPVVTO2E9IDtwPVFMb2dpYztsPUFWTUIxLTE0
MTEzMDE2MDAxNVotNTg5NTAAAAAfABUQAQAAAFgAAABDADEAOAA0ADYARgAxAEIARAAwADkARQBE
AEYANAA4ADkANABCADcAMAA4AEMAQgAyADEANgA4AEYANQA3ADAAQABxAGwAbwBnAGkAYwAuAGMA
bwBtAAAAAgEUMAEAAAAMAAAAWgUAAI14i2tPAAAAHwD6PwEAAAAcAAAARAB1AGEAbgBlACAARwBy
AGkAZwBzAGIAeQAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAABYAAAB1AHMAZQByAC0AYQBnAGUA
bgB0AAAAAAABAAAARgAAAE0AaQBjAHIAbwBzAG8AZgB0AC0ATQBhAGMATwB1AHQAbABvAG8AawAv
ADEANAAuADQALgA2AC4AMQA0ADEAMQAwADYAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgA
AABDAG8AbgB2AGUAcgBzAGEAdABpAG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAA
AAEAAAAwAQAASQBJAD0AMAAxADAAMQBEADAAMABDAEIANgBCAEIAMABGAEMAOABFADIAMwA2ADAA
NABCADMANgBFADQANwA5ADAAMgBDADQAMwBBADAANQBBADMAMQBBAEEAQwA0ADsAUwBCAE0ASQBE
AD0AMwA7AFMAMQA9ADwAMgAwADEANAAxADEAMgA2ADEAOAAxADAALgBzAEEAUQBJAEEAWgB2AEsA
MAAwADcAMwAyADUAQAB3AGkAbgBkAC4AZQBuAGoAZQBsAGwAaQBjAC4AYwBvAG0APgA7AFYAZQBy
AHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMgAgACgAQgB1AGkAbABkACAAMwA4ADcA
LgAwACkALAAgAFMAdABhAGcAZQA9AEgAMgAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYB
AAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYD
AgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAA
AAEAAAAaAAAAWwAxADAALgA4AC4ANAAuADEANwA1AF0AAAAAAB8AAICGAwIAAAAAAMAAAAAAAABG
AQAAABYAAABkAGkAcwBjAGwAYQBpAG0AZQByAAAAAAABAAAADgAAAGIAeQBwAGEAcwBzAAAAAADs
4w==

--_000_2D7BBED629475F4BAA85CF6AB9702F130108802875AVMB1qlogicor_--
