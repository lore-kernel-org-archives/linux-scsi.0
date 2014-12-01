From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: [Scst-devel] New qla2x00tgt Driver Question
Date: Mon, 1 Dec 2014 16:26:18 -0600
Message-ID: <201412012226.sB1MQIDx009973@wind.enjellic.com>
References: <duane.grigsby@qlogic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:42166 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbaLAW0i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2014 17:26:38 -0500
In-Reply-To: Duane Grigsby <duane.grigsby@qlogic.com>
       "Re: [Scst-devel] New qla2x00tgt Driver Question" (Nov 30,  4:00pm)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Duane Grigsby <duane.grigsby@qlogic.com>, "greg@enjellic.com" <greg@enjellic.com>, Marc Smith <marc.smith@mcc.edu>, scst-devel <scst-devel@lists.sourceforge.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Nov 30,  4:00pm, Duane Grigsby wrote:
} Subject: Re: [Scst-devel] New qla2x00tgt Driver Question

Hi, I hope everyone had an enjoyable weekend, holiday or otherwise.

Duane, thanks for taking the time to respond.  Obviously in a fabric
of this size switching adapters or block transport modalities is not
something which is entertained lightly.

> On 11/26/14, 10:10 AM, "Dr. Greg Wettstein" <greg@wind.enjellic.com> wrote:
> 
> >On Nov 19, 11:54am, Marc Smith wrote:
> >} Subject: [Scst-devel] New qla2x00tgt Driver Question
> >
> >> Hi,
> >
> >Hi, I hope the day continues to go well for everyone.
> >
> >It is -15C here with a -26C windchill so Izzy, my golden retriever and
> >I, are answering e-mails rather then putting up outside Christmas
> >decorations.
> >
> >> I've noticed a change in behavior with the new qla2x00tgt
> >> driver. With the previous version of this driver, sessions to Fibre
> >> Channel switches were deleted, but now they seem to stay around
> >> indefinitely (eg, they show up in the list of sessions for a target
> >> in SCST).
> >
> >It seems to be a generic problem with the Qlogic target driver
> >architecture.  There really is only one target driver, but
> >unfortunately for everyone involved, multiple variants.
> >
> >I'm including linux-scsi on this since this is as much a problem for
> >the mainline kernel storage infrastructure as it is for SCST.
> >
> >I believe I may have mentioned before that the entire storage
> >community, which is dependent on Qlogic hardware, needs to rally
> >around a single version of this target architecture... :-)(

> Yes, the 'exclusive' option is really not operating in exclusive
> target mode.  The driver transitions to target mode from initiator
> mode, so there's a transition period. One way around this is to use
> the laser control attribute. We can turn OFF the laser during
> initializaton and turn it back ON after target is up and running.
> We will look into this change and see what can be done.

I suspect that is the same approach that Vlad may have taken when we
funded him to implement that functionality in the in-tree qla2x00tgt
code.

The 2.6.18/RHEL5 kernels had a bug in the initiator code that would
'poison' the initiator if it saw a transition between initiator and
target mode on an endpoint.  Once that occurred the initiator had to
be rebooted in order to regain access to the target.  I believe the
bug in the initiator code was fixed secondary to our documenting its
existence.

This discussion has clarified a number of issues and we believe it is
increasingly apparent that the root cause of what we are seeing is
secondary to the initiator/target transition being visible on the
fabric.  We had concerns that this may be secondary to issues with
asynchronous event handling in the Nexus FCOE fabric but Marc's report
is from a Qlogic switch so it appears to be generic.

We transitioned to 'exclusive' mode since our software defined storage
proxies run one card in initiator mode and the second in target mode.
Locking the driver in target mode would cause us to lose initiator
functionality since it doesn't appear the functionality can be
restricted to a particular card.

> >> I've also noticed this behavior for remote target interfaces if I zone
> >> multiple SCST targets together (eg, target interfaces from multiple SCST
> >> hosts), and I load the "qla2xxx_scst" module first which puts it into
> >> initiator mode initially, and then load qla2x00t which changes it to
> >>target
> >> mode (qlini_mode=3Dexclusive). On one of the SCST host it sees it
> >>initially
> >> in initiator mode which establishes a session, and on the remote SCST
> >>host
> >> its then switched to target mode as initialization progresses, the dead
> >> initiator session sticks around in the list of sessions for that target.
> >> Its never removed even though the SCST target interface is now only in
> >> "target mode".
> >>=20
> >> Its really not hurting anything, but was curious if this is expected
> >> behavior, or is it a new/changed option that needs to be set for the
> >> qla2xxx_scst module?
> >
> >I'm not totally convinced that this is harmless behavior given our
> >work on Qlogic/Cisco fibre-channel task management stability, see my
> >most recent post today.

> Interesting, I haven't seen that posting. Did you post it to
> scst-devel or linux-scsi?

That posting was to scst-devel only, check for the following subject:

'[Scst-devel] SCST & XenServer - HIGH IO causes VM's to Hang'

I included in that mail a log entry from instances we see where a
NEXUS_LOSS_SESS TM event ends up causing an I/O abort event to be
lost.  Our log entry matches almost perfectly with what that user
reported suggesting there is some related theme.

An interesting datapoint in that case is that we only seem to be able
to replicate this issue on a fibre-channel only initiator in an FCOE
fabric.  If we run the same random TMF test on an FCOE based initiator
we can't seem to generate the regression.

I've been running the test on on our FCOE test initiator for the last
half hour and it is still going strong.  The same test against the
same target with a FC only card only lasts a few minutes.

> >> I see another similar post that may or may not be related:
> >> http://sourceforge.net/p/scst/mailman/message/32823494/
> >>=20
> >> That user refers to an error message I do not see in my logs, but some
> >>of
> >> the other messages in the log are similar to whats below... probably
> >> because those messages are common. Figured it was worth mentioning in
> >>case
> >> they are related.
> >>=20
> >> Linux: 3.14.19 (SCST patches applied)
> >> SCST: trunk/r5854
> >> qla2x00t_git: 8.07.00.16.Trunk-SCST.15-k (from qla_version.h)
> >>=20
> >> I believe this is the relative section of logs for session
> >> "2f:fc:00:c0:dd:0d:b3:6d" (a QLogic Fibre Channel switch):
> >> --snip--
> >> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978104] qla2xxx
> >> [0000:05:00.0]-500a:9: LOOP UP detected (4 Gbps).
> >> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978120] [0]:
> >> q2t_async_event:6406:qla2x00t(9): Loop up occured
> >> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978171] [0]:
> >> q2t_async_event:6430:qla2x00t(9): Port update async event 0x8014 occured
> >> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978188] [0]:
> >> q24_handle_els:4893:qla2x00t(9): ELS opcode 3 hndl 0x0 ox_id=3D0x2a69
> >> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978194] [0]:
> >> q24_handle_els:4903:ELS PLOGI rcv 0x2ffc00c0dd0db36d portid=3Dfffc04 hnd=
> l
> >>0x0
> >> Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978201] [0]:
> >> q2t_sched_sess_work:1795:Scheduling work (type 5, prm ffff880229c923c0)
> >>to
> >> find session for param ffff8800a2d1c2c0 (size 64, tgt
> >> ffff88011dea41b8)
> Yes, it may be related. It has to do with receiving a PLOGI from an
> initiator with the same port_id, but a different WWPN. Can you send me
> your complete driver log?
> =20
> >
> >I was very interested in seeing your mail Marc, since it confirms
> >issues we have been tracking and documenting for some time.
> >
> >What appears to be happening is that the target driver, regardless of
> >pedigree, is establishing sessions for the Fibre-Channel Name Services
> >(FCNS) directory servers which are running on each switch.  You can
> >find the clue in your following debug line from above:
> >
> >Nov 19 11:10:29 cloverleaf-1a kernel: [ 3386.978194] [0]:
> >q24_handle_els:4903:ELS PLOGI rcv 0x2ffc00c0dd0db36d portid=3Dfffc04 hndl
> >0x0
> >				^^^^^^^^^^^^^
> >
> >The first two octets, ff:fc, is the 'well-known' address of the FCNS
> >name server on each switch.  The octet '04', in your case, is the
> >domain id of the switch on which the nameserver is running.
> >
> >As I noted in my other e-mail this morning, we are running down issues
> >with possible task management function (TMF) regressions in a large
> >storage fabric.  We believe that occurrences of a TMF are linked to
> >catastrophic VMware/VMFS corruption.
> >
> >Here is a snippet from our logs when we induce a NEXUS_LOSS_SESS event
> >in a multi-datacenter/multi-hop Cisco Nexus FCOE fabric:
> >
> >Sep  3 13:58:31 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f842:9:
> >Unable to find initiator with S_ID ff:fc:bf
> >			   ^^^^^^^^-> NOTE
> >
> >Sep  3 13:58:32 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f820:9:
> >Terminating work cmd ffff880818f484d0 <4>qla2xxx [0000:02:00.3]-f810:9:
> >qla_target(0): ABTS: Unknown Exchange Address received
> >
> >Issueing the following command on one of the core 7010 switches:
> >
> >show fcns internal info vsan 2020
> >
> >Yields the following:
> >
> >Info for vsan 2020
> >=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >Interop mode: 0
> >R_A_TOV: 10000; D_S_TOV: 5000
> >Local Domain: 0x90(144)
> >Remote Domains: 0xe(14) 0x45(69) 0x71(113) 0xbf(191)
> >
> >Which demonstrates, as you can see, that the 'bf' in our case is the
> >identity of one of the switches/domains in the fabric.
> >
> >I omitted the log entries but we also see similar messages for the
> >0x71 and 0x45 switches/domains during each event.  The 0xe switch is
> >in a third data-center we have projected converged traffic to since
> >these tests were run.  I'm sure we will see the 0xe switch included in
> >the logs when we resume our testing.
> >
> >We need to add additional debug code to confirm this but what we think
> >is happening is that the target driver is establishing sessions for
> >each of the FCNS servers when the target port establishes its fabric
> >login.  When an asynchronous event occurs on the fabric, such as a
> >NEXUS_LOSS_SESS, each of the FCNS servers issues the following
> >sequence of Extended Link Service (ELS) actions against the target:
> >
> >	PLOGI	(Port login)
> >	PRLI	(Process login)
> >	ADISC	(Device discovery)
> >
> >Which I am not convinced is well handled by any of the target driver
> >variants or storage stacks which use this infrastructure.  In our
> >environment the firmware/card/stack has to handle 3 x
> >NUMBER_OF_SWITCHES actions on each event.
> >
> >One of the interesting things we seem to be seeing is that only the
> >Nexus 55xx ingress switches seem to be establishing these sessions.
> >We have not documented the storage VDC's on the 7009/7010 core
> >switches doing this.  The target server from which the log was
> >generated is directly attached to a 7009 on the backbone of this
> >fabric.  There is an adjacent 7010 which should, in theory, be doing
> >this as well, if our analysis on the root cause of this is correct.
> >
> >As the log above notes we believe that all of this is possibly
> >implicated in abort sequence processing issues.  We have tracked the
> >issue with the 'unknown exchange address' back into the IOCB coming
> >out of the ISP engine on the Qlogic 8362 FCOE cards which is about as
> >far as we can take this without knowing what is going on inside the
> >card.
> >
> >We are also suspicious, as you indicate, that this may having
> >something to do with the fabric port on the target coming up in
> >iniatiator and then transitioning to target mode.  Obviously the FCNS
> >directory servers are involved in tracking the state of the ports.
> >One of the things we are going to rigidly document is if this FCNS
> >target session establishment can be avoided by only allowing the
> >target port login to occur after the interface is broadcasting FCP
> >target status.
> >
> >The open question seems to be how to handle the root cause of this
> >issue which is the fact that the target code is granting sessions to
> >the FCNS directory servers.  Even if it is harmless it would seem to
> >be anomalous behavior which, in the storage business, is one of those
> >'nothing good will come of this' type issues.

> Hi Greg, Yes, I think there may be a issue there, but let me look at your
> logs.

I still had our test harness setup so I did a bit of testing this
afternoon.  Our target servers split logs in 'messages' and 'syslog'
with everything above loglevel warn going into syslog.  I'm including
those logs below, they document the FCNS directory servers on the
three Nexus 55xx switches issueing various combinations of ELS events
(PLOGI/PLOGO/PRLI/ADISC) against the target.

You can find the anomalies beginning at 13:07:03 when target mode was
enabled on the interface.

There is one target and two initiators currently in this zone.  The
following intiatior:

Dec  1 13:02:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f84b:9: qla_target(0): session for wwn 21:01:00:e0:8b:a6:d1:9f (loop_id 3, s_id 45:2:0, confirmed completion not supported) added

Was the first initiator which had been placed in the zone.  This
follows a very similar pattern where the first initiator always
appears with a loop id of NUM_OF_SWITCHES+1 which we are assuming to
be secondary to the first set of session slots being taken by the FCNS
directory servers.

Normally when we provoke a NEXUS_LOSS_SESS event by issuing an adapter
reset against the block device provicded by the target we see the
switches issuing sequences of asynchronous transactions against the
target.  In the last round of testing which we just completed we did
not see that.  I will go back and run it from the straight FC
initiator to see if that is somehow implicated in all this since it
appears behaviors are changing between an FC and FCOE initiator.

As an FYI we are running with 3.10.57 on the target using the
in-kernel target code plus our target interface driver for SCST.
Included in that is a cherry pick of a few target patches which you
have rolled into mainline which seemed important.  I'm a little short
of time right now but I will generate a full patch later tonight with
the exact diff and put it on the FTP server if you want it for
testing.

Once again I apologize for this being less then deterministic
debugging information.  We have been chasing these anomalies for a
long time and this last go around has helped better clarify what we
are looking for and how to reproduce it.

Let us know if you need anything else.

Greg

/var/log/messages: --------------------------------------------------------
Dec  1 00:01:02 fc-rp1-targ10-s su[30299]: + ??? root-nobody 
Dec  1 02:11:45 fc-rp1-targ10-s ntpd[1910]: kernel time sync status change 4001
Dec  1 03:02:59 fc-rp1-targ10-s ntpd[1910]: kernel time sync status change 0001
Dec  1 05:53:44 fc-rp1-targ10-s ntpd[1910]: kernel time sync status change 4001
Dec  1 07:19:09 fc-rp1-targ10-s ntpd[1910]: kernel time sync status change 0001
Dec  1 08:27:29 fc-rp1-targ10-s ntpd[1910]: kernel time sync status change 4001
Dec  1 08:44:35 fc-rp1-targ10-s ntpd[1910]: kernel time sync status change 0001
Dec  1 10:09:57 fc-rp1-targ10-s ntpd[1910]: kernel time sync status change 4001
Dec  1 11:35:21 fc-rp1-targ10-s ntpd[1910]: kernel time sync status change 0001
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [0]: sqa_qla2xxx_handle_tmr:497:sqatgt(9/0): NEXUS_LOSS_SESS received.
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [0]: scst: scst_rx_mgmt_fn:6701:TM fn 6 (mcmd ffff8803148bde00, initiator 21:00:00:0e:1e:31:83:5f, target 21:00:00:0e:1e:15:19:f1)
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [0]: scst_rx_mgmt_fn:6713:sess=ffff880315408980, tag_set 0, tag 0, lun_set 1, lun=0, cmd_sn_set 0, cmd_sn 0, priv ffff88031967a328
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [0]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff8803148bde00 to active mgmt cmd list
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff8803148bde00 from active cmd list
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess ffff880315408980 (mcmd ffff8803148bde00)
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [0]: scst: scst_alloc_set_UA:7963:Queuing new UA ffff88081aead210 (6:29:7, d_sense 0) to tgt_dev ffff8803197904c0 (dev r10:prox1, initiator 21:00:00:0e:1e:31:83:5f)
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio task_mgmt_fn_done(fn=6)
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio task_mgmt_fn_done() returned
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: scst: scst_mgmt_cmd_send_done:6372:TM fn 6 (mcmd ffff8803148bde00) finished, status 0
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: sqa_task_mgmt_fn_done:1361:sqatgt(9/0): scst_mcmd (ffff8803148bde00) status 0x0 state 0x6
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6387:Target's sqatgt task_mgmt_fn_done() returned
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [0]: sqa_qla2xxx_handle_tmr:497:sqatgt(9/0): NEXUS_LOSS_SESS received.
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [0]: scst: scst_rx_mgmt_fn:6701:TM fn 6 (mcmd ffff8803148bde00, initiator 21:00:00:0e:1e:31:83:5f, target 21:00:00:0e:1e:15:19:f1)
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [0]: scst_rx_mgmt_fn:6713:sess=ffff880315408980, tag_set 0, tag 0, lun_set 1, lun=0, cmd_sn_set 0, cmd_sn 0, priv ffff88031967a328
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [0]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff8803148bde00 to active mgmt cmd list
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff8803148bde00 from active cmd list
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess ffff880315408980 (mcmd ffff8803148bde00)
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio task_mgmt_fn_done(fn=6)
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio task_mgmt_fn_done() returned
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: scst: scst_mgmt_cmd_send_done:6372:TM fn 6 (mcmd ffff8803148bde00) finished, status 0
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: sqa_task_mgmt_fn_done:1361:sqatgt(9/0): scst_mcmd (ffff8803148bde00) status 0x0 state 0x6
Dec  1 12:49:01 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6387:Target's sqatgt task_mgmt_fn_done() returned
Dec  1 12:49:10 fc-rp1-targ10-s kernel: [0]: scst_set_pending_UA:7822:Setting pending UA cmd ffff8803197904c0 (tgt_dev ffff88031548cf00, dev r10:prox1, initiator 21:00:00:0e:1e:31:83:5f)
Dec  1 12:49:10 fc-rp1-targ10-s kernel: [0]: scst_set_pending_UA:7827:Setting pending UA ffff88081aead210 to cmd ffff88031548cf00
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [0]: sqa_qla2xxx_handle_tmr:497:sqatgt(9/0): NEXUS_LOSS_SESS received.
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [0]: scst: scst_rx_mgmt_fn:6701:TM fn 6 (mcmd ffff8803148bdd90, initiator 21:00:00:0e:1e:31:83:5f, target 21:00:00:0e:1e:15:19:f1)
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [0]: scst_rx_mgmt_fn:6713:sess=ffff880315408980, tag_set 0, tag 0, lun_set 1, lun=0, cmd_sn_set 0, cmd_sn 0, priv ffff880319679f40
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [0]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff8803148bdd90 to active mgmt cmd list
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff8803148bdd90 from active cmd list
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess ffff880315408980 (mcmd ffff8803148bdd90)
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [0]: scst: scst_alloc_set_UA:7963:Queuing new UA ffff88081aead320 (6:29:7, d_sense 0) to tgt_dev ffff8803197904c0 (dev r10:prox1, initiator 21:00:00:0e:1e:31:83:5f)
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio task_mgmt_fn_done(fn=6)
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio task_mgmt_fn_done() returned
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: scst: scst_mgmt_cmd_send_done:6372:TM fn 6 (mcmd ffff8803148bdd90) finished, status 0
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: sqa_task_mgmt_fn_done:1361:sqatgt(9/0): scst_mcmd (ffff8803148bdd90) status 0x0 state 0x6
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6387:Target's sqatgt task_mgmt_fn_done() returned
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [0]: sqa_qla2xxx_handle_tmr:497:sqatgt(9/0): NEXUS_LOSS_SESS received.
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [0]: scst: scst_rx_mgmt_fn:6701:TM fn 6 (mcmd ffff8803148bdd90, initiator 21:00:00:0e:1e:31:83:5f, target 21:00:00:0e:1e:15:19:f1)
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [0]: scst_rx_mgmt_fn:6713:sess=ffff880315408980, tag_set 0, tag 0, lun_set 1, lun=0, cmd_sn_set 0, cmd_sn 0, priv ffff880319679f40
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [0]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff8803148bdd90 to active mgmt cmd list
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff8803148bdd90 from active cmd list
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess ffff880315408980 (mcmd ffff8803148bdd90)
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio task_mgmt_fn_done(fn=6)
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio task_mgmt_fn_done() returned
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: scst: scst_mgmt_cmd_send_done:6372:TM fn 6 (mcmd ffff8803148bdd90) finished, status 0
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: sqa_task_mgmt_fn_done:1361:sqatgt(9/0): scst_mcmd (ffff8803148bdd90) status 0x0 state 0x6
Dec  1 12:52:57 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6387:Target's sqatgt task_mgmt_fn_done() returned
Dec  1 12:53:06 fc-rp1-targ10-s kernel: [0]: scst_set_pending_UA:7822:Setting pending UA cmd ffff8803197904c0 (tgt_dev ffff88031548cf00, dev r10:prox1, initiator 21:00:00:0e:1e:31:83:5f)
Dec  1 12:53:06 fc-rp1-targ10-s kernel: [0]: scst_set_pending_UA:7827:Setting pending UA ffff88081aead320 to cmd ffff88031548cf00
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [0]: sqa_qla2xxx_handle_tmr:497:sqatgt(9/0): NEXUS_LOSS_SESS received.
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [0]: scst: scst_rx_mgmt_fn:6701:TM fn 6 (mcmd ffff8803148bdd20, initiator 21:00:00:0e:1e:31:83:5f, target 21:00:00:0e:1e:15:19:f1)
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [0]: scst_rx_mgmt_fn:6713:sess=ffff880315408980, tag_set 0, tag 0, lun_set 1, lun=0, cmd_sn_set 0, cmd_sn 0, priv ffff880319679b58
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [0]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff8803148bdd20 to active mgmt cmd list
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff8803148bdd20 from active cmd list
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess ffff880315408980 (mcmd ffff8803148bdd20)
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [0]: scst: scst_alloc_set_UA:7963:Queuing new UA ffff88081aead430 (6:29:7, d_sense 0) to tgt_dev ffff8803197904c0 (dev r10:prox1, initiator 21:00:00:0e:1e:31:83:5f)
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio task_mgmt_fn_done(fn=6)
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio task_mgmt_fn_done() returned
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: scst: scst_mgmt_cmd_send_done:6372:TM fn 6 (mcmd ffff8803148bdd20) finished, status 0
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: sqa_task_mgmt_fn_done:1361:sqatgt(9/0): scst_mcmd (ffff8803148bdd20) status 0x0 state 0x6
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6387:Target's sqatgt task_mgmt_fn_done() returned
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [0]: sqa_qla2xxx_handle_tmr:497:sqatgt(9/0): NEXUS_LOSS_SESS received.
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [0]: scst: scst_rx_mgmt_fn:6701:TM fn 6 (mcmd ffff8803148bdd20, initiator 21:00:00:0e:1e:31:83:5f, target 21:00:00:0e:1e:15:19:f1)
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [0]: scst_rx_mgmt_fn:6713:sess=ffff880315408980, tag_set 0, tag 0, lun_set 1, lun=0, cmd_sn_set 0, cmd_sn 0, priv ffff880319679b58
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [0]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff8803148bdd20 to active mgmt cmd list
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff8803148bdd20 from active cmd list
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess ffff880315408980 (mcmd ffff8803148bdd20)
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio task_mgmt_fn_done(fn=6)
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio task_mgmt_fn_done() returned
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: scst: scst_mgmt_cmd_send_done:6372:TM fn 6 (mcmd ffff8803148bdd20) finished, status 0
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: sqa_task_mgmt_fn_done:1361:sqatgt(9/0): scst_mcmd (ffff8803148bdd20) status 0x0 state 0x6
Dec  1 12:55:15 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6387:Target's sqatgt task_mgmt_fn_done() returned
Dec  1 12:55:24 fc-rp1-targ10-s kernel: [0]: scst_set_pending_UA:7822:Setting pending UA cmd ffff8803197904c0 (tgt_dev ffff88031548c000, dev r10:prox1, initiator 21:00:00:0e:1e:31:83:5f)
Dec  1 12:55:24 fc-rp1-targ10-s kernel: [0]: scst_set_pending_UA:7827:Setting pending UA ffff88081aead430 to cmd ffff88031548c000
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [0]: sqa_qla2xxx_handle_tmr:497:sqatgt(9/0): NEXUS_LOSS_SESS received.
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [0]: scst: scst_rx_mgmt_fn:6701:TM fn 6 (mcmd ffff8803148bdcb0, initiator 21:00:00:0e:1e:31:83:5f, target 21:00:00:0e:1e:15:19:f1)
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [0]: scst_rx_mgmt_fn:6713:sess=ffff880315408980, tag_set 0, tag 0, lun_set 1, lun=0, cmd_sn_set 0, cmd_sn 0, priv ffff880319679770
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [0]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff8803148bdcb0 to active mgmt cmd list
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff8803148bdcb0 from active cmd list
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess ffff880315408980 (mcmd ffff8803148bdcb0)
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [0]: scst: scst_alloc_set_UA:7963:Queuing new UA ffff88081aead540 (6:29:7, d_sense 0) to tgt_dev ffff8803197904c0 (dev r10:prox1, initiator 21:00:00:0e:1e:31:83:5f)
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio task_mgmt_fn_done(fn=6)
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio task_mgmt_fn_done() returned
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: scst: scst_mgmt_cmd_send_done:6372:TM fn 6 (mcmd ffff8803148bdcb0) finished, status 0
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: sqa_task_mgmt_fn_done:1361:sqatgt(9/0): scst_mcmd (ffff8803148bdcb0) status 0x0 state 0x6
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6387:Target's sqatgt task_mgmt_fn_done() returned
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [0]: sqa_qla2xxx_handle_tmr:497:sqatgt(9/0): NEXUS_LOSS_SESS received.
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [0]: scst: scst_rx_mgmt_fn:6701:TM fn 6 (mcmd ffff8803148bdcb0, initiator 21:00:00:0e:1e:31:83:5f, target 21:00:00:0e:1e:15:19:f1)
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [0]: scst_rx_mgmt_fn:6713:sess=ffff880315408980, tag_set 0, tag 0, lun_set 1, lun=0, cmd_sn_set 0, cmd_sn 0, priv ffff880319679770
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [0]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff8803148bdcb0 to active mgmt cmd list
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff8803148bdcb0 from active cmd list
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess ffff880315408980 (mcmd ffff8803148bdcb0)
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio task_mgmt_fn_done(fn=6)
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio task_mgmt_fn_done() returned
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: scst: scst_mgmt_cmd_send_done:6372:TM fn 6 (mcmd ffff8803148bdcb0) finished, status 0
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: sqa_task_mgmt_fn_done:1361:sqatgt(9/0): scst_mcmd (ffff8803148bdcb0) status 0x0 state 0x6
Dec  1 12:58:48 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6387:Target's sqatgt task_mgmt_fn_done() returned
Dec  1 12:58:57 fc-rp1-targ10-s kernel: [0]: scst_set_pending_UA:7822:Setting pending UA cmd ffff8803197904c0 (tgt_dev ffff88031548c000, dev r10:prox1, initiator 21:00:00:0e:1e:31:83:5f)
Dec  1 12:58:57 fc-rp1-targ10-s kernel: [0]: scst_set_pending_UA:7827:Setting pending UA ffff88081aead540 to cmd ffff88031548c000
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [1652]: sqa_enable_tgt:1547:sqatgt(9/0): Disabling target pwwn=21:00:00:0e:1e:15:19:f1
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [46]: sqa_qla2xxx_free_session:561:sqatgt(9/0): Deleting session: type=non-local, loop id=3, fcid=450200
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [46]: scst_unregister_session:7188:Unregistering session ffff880315408000 (wait 0)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [46]: scst_rx_mgmt_fn:6703:TM fn 10 (mcmd ffff88101c2519a0)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [46]: scst_rx_mgmt_fn:6713:sess=ffff880315408000, tag_set 0, tag 0, lun_set 0, lun=0, cmd_sn_set 0, cmd_sn 0, priv           (null)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [46]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff88101c2519a0 to active mgmt cmd list
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff88101c2519a0 from active cmd list
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [1670]: scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess ffff880315408000 (mcmd ffff88101c2519a0)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6375:TM fn 10 (mcmd ffff88101c2519a0) finished, status 0
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [30573]: sqa_qla2xxx_free_session:561:sqatgt(9/0): Deleting session: type=non-local, loop id=5, fcid=0e0000
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [30573]: scst_unregister_session:7188:Unregistering session ffff880315408980 (wait 0)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [30573]: scst_rx_mgmt_fn:6703:TM fn 10 (mcmd ffff88101c251a10)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [30573]: scst_rx_mgmt_fn:6713:sess=ffff880315408980, tag_set 0, tag 0, lun_set 0, lun=0, cmd_sn_set 0, cmd_sn 0, priv           (null)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [30573]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff88101c251a10 to active mgmt cmd list
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff88101c251a10 from active cmd list
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [1670]: scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess ffff880315408980 (mcmd ffff88101c251a10)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio task_mgmt_fn_done(fn=10)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio task_mgmt_fn_done() returned
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6375:TM fn 10 (mcmd ffff88101c251a10) finished, status 0
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [11982]: scst: scst_cmd_thread:4914:Processing thread r10:prox10_0 (PID 11982) finished
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [894]: sqa_qla2xxx_free_session:561:sqatgt(9/0): Deleting session: type=local, loop id=2, fcid=450040
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [894]: scst_unregister_session:7188:Unregistering session ffff880315408e40 (wait 0)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [894]: scst_rx_mgmt_fn:6703:TM fn 10 (mcmd ffff88101c251a80)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [894]: scst_rx_mgmt_fn:6713:sess=ffff880315408e40, tag_set 0, tag 0, lun_set 0, lun=0, cmd_sn_set 0, cmd_sn 0, priv           (null)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [894]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff88101c251a80 to active mgmt cmd list
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff88101c251a80 from active cmd list
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [1670]: scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess ffff880315408e40 (mcmd ffff88101c251a80)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6375:TM fn 10 (mcmd ffff88101c251a80) finished, status 0
Dec  1 13:02:49 fc-rp1-targ10-s kernel: [1948]: sqa_qla2xxx_check_initiator_node_acl:626:sqatgt(9/0): Registering initiator: pwwn=21:01:00:e0:8b:a6:d1:9f, fcid=0x450200, loop=0x0003
Dec  1 13:02:49 fc-rp1-targ10-s kernel: [1671]: scst: scst_init_session:6940:Using security group "fc-iacc1-prox2-s.ndsu_3" for initiator "21:01:00:e0:8b:a6:d1:9f" (target 21:00:00:0e:1e:15:19:f1)
Dec  1 13:02:49 fc-rp1-targ10-s kernel: [1948]: sqa_qla2xxx_check_initiator_node_acl:626:sqatgt(9/0): Registering initiator: pwwn=21:00:00:0e:1e:31:83:5f, fcid=0x0e0000, loop=0x0005
Dec  1 13:02:49 fc-rp1-targ10-s kernel: [1671]: scst: scst_init_session:6940:Using security group "fc-barry1-prox4-s.ndsu_1" for initiator "21:00:00:0e:1e:31:83:5f" (target 21:00:00:0e:1e:15:19:f1)
Dec  1 13:02:49 fc-rp1-targ10-s kernel: [1671]: scst_alloc_add_tgt_dev:4373:Device r10:prox1 on SCST lun=0
Dec  1 13:02:49 fc-rp1-targ10-s kernel: [1671]: scst: scst_alloc_set_UA:7963:Queuing new UA ffff880315448220 (6:29:0, d_sense 0) to tgt_dev ffff8803197904c0 (dev r10:prox1, initiator 21:00:00:0e:1e:31:83:5f)
Dec  1 13:02:49 fc-rp1-targ10-s kernel: [30574]: scst: scst_cmd_thread:4885:Processing thread r10:prox10_0 (PID 30574) started
Dec  1 13:07:03 fc-rp1-targ10-s kernel: [1652]: sqa_enable_tgt:1547:sqatgt(9/0): Enabling target pwwn=21:00:00:0e:1e:15:19:f1
Dec  1 13:09:35 fc-rp1-targ10-s kernel: [0]: sqa_qla2xxx_handle_tmr:447:sqatgt(9/0) TARGET_RESET received.
Dec  1 13:09:35 fc-rp1-targ10-s kernel: [0]: scst: scst_rx_mgmt_fn:6701:TM fn 5 (mcmd ffff8803148bdc40, initiator 21:00:00:0e:1e:31:83:5f, target 21:00:00:0e:1e:15:19:f1)
Dec  1 13:09:35 fc-rp1-targ10-s kernel: [0]: scst_rx_mgmt_fn:6713:sess=ffff8803154097c0, tag_set 0, tag 0, lun_set 1, lun=0, cmd_sn_set 0, cmd_sn 0, priv ffff880319679388
Dec  1 13:09:35 fc-rp1-targ10-s kernel: [0]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff8803148bdc40 to active mgmt cmd list
Dec  1 13:09:35 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff8803148bdc40 from active cmd list
Dec  1 13:09:35 fc-rp1-targ10-s kernel: [1670]: scst: scst_target_reset:5854:Target reset (mcmd ffff8803148bdc40, cmd count 1)
Dec  1 13:09:35 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio task_mgmt_fn_done(fn=5)
Dec  1 13:09:35 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio task_mgmt_fn_done() returned
Dec  1 13:09:35 fc-rp1-targ10-s kernel: [1670]: scst: scst_mgmt_cmd_send_done:6372:TM fn 5 (mcmd ffff8803148bdc40) finished, status 0
Dec  1 13:09:35 fc-rp1-targ10-s kernel: [1670]: sqa_task_mgmt_fn_done:1361:sqatgt(9/0): scst_mcmd (ffff8803148bdc40) status 0x0 state 0x6
Dec  1 13:09:35 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6387:Target's sqatgt task_mgmt_fn_done() returned
Dec  1 13:34:54 fc-rp1-targ10-s ntpd[1910]: kernel time sync status change 0001
Dec  1 14:26:08 fc-rp1-targ10-s ntpd[1910]: kernel time sync status change 4001
Dec  1 14:43:11 fc-rp1-targ10-s ntpd[1910]: kernel time sync status change 0001
Dec  1 14:52:57 fc-rp1-targ10-s kernel: [0]: sqa_qla2xxx_handle_tmr:447:sqatgt(9/0) TARGET_RESET received.
Dec  1 14:52:57 fc-rp1-targ10-s kernel: [0]: scst: scst_rx_mgmt_fn:6701:TM fn 5 (mcmd ffff8803148bdc40, initiator 21:00:00:0e:1e:31:83:5f, target 21:00:00:0e:1e:15:19:f1)
Dec  1 14:52:57 fc-rp1-targ10-s kernel: [0]: scst_rx_mgmt_fn:6713:sess=ffff8803154097c0, tag_set 0, tag 0, lun_set 1, lun=0, cmd_sn_set 0, cmd_sn 0, priv ffff880319679388
Dec  1 14:52:57 fc-rp1-targ10-s kernel: [0]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff8803148bdc40 to active mgmt cmd list
Dec  1 14:52:57 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff8803148bdc40 from active cmd list
Dec  1 14:52:57 fc-rp1-targ10-s kernel: [1670]: scst: scst_target_reset:5854:Target reset (mcmd ffff8803148bdc40, cmd count 1)
Dec  1 14:52:57 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio task_mgmt_fn_done(fn=5)
Dec  1 14:52:57 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio task_mgmt_fn_done() returned
Dec  1 14:52:57 fc-rp1-targ10-s kernel: [1670]: scst: scst_mgmt_cmd_send_done:6372:TM fn 5 (mcmd ffff8803148bdc40) finished, status 0
Dec  1 14:52:57 fc-rp1-targ10-s kernel: [1670]: sqa_task_mgmt_fn_done:1361:sqatgt(9/0): scst_mcmd (ffff8803148bdc40) status 0x0 state 0x6
Dec  1 14:52:57 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6387:Target's sqatgt task_mgmt_fn_done() returned
Dec  1 14:54:22 fc-rp1-targ10-s kernel: [0]: scst_set_pending_UA:7822:Setting pending UA cmd ffff8803197904c0 (tgt_dev ffff88031548cc80, dev r10:prox1, initiator 21:00:00:0e:1e:31:83:5f)
Dec  1 14:54:22 fc-rp1-targ10-s kernel: [0]: scst_set_pending_UA:7827:Setting pending UA ffff880315448220 to cmd ffff88031548cc80
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [0]: sqa_qla2xxx_handle_tmr:497:sqatgt(9/0): NEXUS_LOSS_SESS received.
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [0]: scst: scst_rx_mgmt_fn:6701:TM fn 6 (mcmd ffff8803148bdc40, initiator 21:00:00:0e:1e:31:83:5f, target 21:00:00:0e:1e:15:19:f1)
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [0]: scst_rx_mgmt_fn:6713:sess=ffff8803154097c0, tag_set 0, tag 0, lun_set 1, lun=0, cmd_sn_set 0, cmd_sn 0, priv ffff880319679388
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [0]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff8803148bdc40 to active mgmt cmd list
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff8803148bdc40 from active cmd list
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess ffff8803154097c0 (mcmd ffff8803148bdc40)
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [0]: scst: scst_alloc_set_UA:7963:Queuing new UA ffff88081aead650 (6:29:7, d_sense 0) to tgt_dev ffff8803197904c0 (dev r10:prox1, initiator 21:00:00:0e:1e:31:83:5f)
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio task_mgmt_fn_done(fn=6)
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio task_mgmt_fn_done() returned
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: scst: scst_mgmt_cmd_send_done:6372:TM fn 6 (mcmd ffff8803148bdc40) finished, status 0
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: sqa_task_mgmt_fn_done:1361:sqatgt(9/0): scst_mcmd (ffff8803148bdc40) status 0x0 state 0x6
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6387:Target's sqatgt task_mgmt_fn_done() returned
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [0]: sqa_qla2xxx_handle_tmr:497:sqatgt(9/0): NEXUS_LOSS_SESS received.
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [0]: scst: scst_rx_mgmt_fn:6701:TM fn 6 (mcmd ffff8803148bdc40, initiator 21:00:00:0e:1e:31:83:5f, target 21:00:00:0e:1e:15:19:f1)
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [0]: scst_rx_mgmt_fn:6713:sess=ffff8803154097c0, tag_set 0, tag 0, lun_set 1, lun=0, cmd_sn_set 0, cmd_sn 0, priv ffff880319679388
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [0]: scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff8803148bdc40 to active mgmt cmd list
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: scst_tm_thread:6514:Deleting mgmt cmd ffff8803148bdc40 from active cmd list
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess ffff8803154097c0 (mcmd ffff8803148bdc40)
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio task_mgmt_fn_done(fn=6)
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio task_mgmt_fn_done() returned
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: scst: scst_mgmt_cmd_send_done:6372:TM fn 6 (mcmd ffff8803148bdc40) finished, status 0
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: sqa_task_mgmt_fn_done:1361:sqatgt(9/0): scst_mcmd (ffff8803148bdc40) status 0x0 state 0x6
Dec  1 14:55:49 fc-rp1-targ10-s kernel: [1670]: scst_mgmt_cmd_send_done:6387:Target's sqatgt task_mgmt_fn_done() returned
Dec  1 14:55:58 fc-rp1-targ10-s kernel: [0]: scst_set_pending_UA:7822:Setting pending UA cmd ffff8803197904c0 (tgt_dev ffff88031548db80, dev r10:prox1, initiator 21:00:00:0e:1e:31:83:5f)
Dec  1 14:55:58 fc-rp1-targ10-s kernel: [0]: scst_set_pending_UA:7827:Setting pending UA ffff88081aead650 to cmd ffff88031548db80
---------------------------------------------------------------------------

/var/log/syslog: ----------------------------------------------------------
Dec  1 12:49:01 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83c:9: qla_target(0): Async event 0x8015 occurred (m[0]=8015, m[1]=45, m[2]=40, m[3]=0)
Dec  1 12:49:01 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x03
Dec  1 12:49:01 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9: qla_target(0): Doing NEXUS_LOSS_SESS
Dec  1 12:49:01 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM response mcmd (ffff88031967a328) status 0x0 state 0x1
Dec  1 12:49:01 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=5, m[2]=4, m[3]=600)
Dec  1 12:49:01 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 12:49:01 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=5, m[2]=4, m[3]=600)
Dec  1 12:49:01 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 12:49:01 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x20
Dec  1 12:49:01 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9: qla_target(0): Doing NEXUS_LOSS_SESS
Dec  1 12:49:01 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM response mcmd (ffff88031967a328) status 0x0 state 0x1
Dec  1 12:49:03 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x52
Dec  1 12:52:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x03
Dec  1 12:52:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9: qla_target(0): Doing NEXUS_LOSS_SESS
Dec  1 12:52:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM response mcmd (ffff880319679f40) status 0x0 state 0x1
Dec  1 12:52:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=5, m[2]=4, m[3]=600)
Dec  1 12:52:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 12:52:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=5, m[2]=4, m[3]=600)
Dec  1 12:52:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 12:52:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x20
Dec  1 12:52:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9: qla_target(0): Doing NEXUS_LOSS_SESS
Dec  1 12:52:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM response mcmd (ffff880319679f40) status 0x0 state 0x1
Dec  1 12:52:59 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x52
Dec  1 12:55:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x03
Dec  1 12:55:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9: qla_target(0): Doing NEXUS_LOSS_SESS
Dec  1 12:55:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM response mcmd (ffff880319679b58) status 0x0 state 0x1
Dec  1 12:55:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=5, m[2]=4, m[3]=600)
Dec  1 12:55:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 12:55:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=5, m[2]=4, m[3]=600)
Dec  1 12:55:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 12:55:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x20
Dec  1 12:55:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9: qla_target(0): Doing NEXUS_LOSS_SESS
Dec  1 12:55:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM response mcmd (ffff880319679b58) status 0x0 state 0x1
Dec  1 12:55:17 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x52
Dec  1 12:58:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x03
Dec  1 12:58:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9: qla_target(0): Doing NEXUS_LOSS_SESS
Dec  1 12:58:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM response mcmd (ffff880319679770) status 0x0 state 0x1
Dec  1 12:58:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=5, m[2]=4, m[3]=600)
Dec  1 12:58:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 12:58:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=5, m[2]=4, m[3]=600)
Dec  1 12:58:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 12:58:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x20
Dec  1 12:58:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9: qla_target(0): Doing NEXUS_LOSS_SESS
Dec  1 12:58:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM response mcmd (ffff880319679770) status 0x0 state 0x1
Dec  1 12:58:50 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x52
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-1020:9: **** Failed mbx[0]=4005, mb[1]=a, mb[2]=1553, mb[3]=8000, cmd=75 ****.
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f804:9: Timeout: sess ffff88081be3c3c0 about to be deleted
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f801:9: Unregistration of sess ffff88081be3c3c0 finished
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-1020:9: **** Failed mbx[0]=4005, mb[1]=a, mb[2]=1492, mb[3]=d000, cmd=75 ****.
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f804:9: Timeout: sess ffff88081c782d80 about to be deleted
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f801:9: Unregistration of sess ffff88081c782d80 finished
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-1020:9: **** Failed mbx[0]=4005, mb[1]=a, mb[2]=1492, mb[3]=d000, cmd=75 ****.
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f804:9: Timeout: sess ffff880315859840 about to be deleted
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f801:9: Unregistration of sess ffff880315859840 finished
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f809:9: Waiting for sess works (tgt ffff880819e99400)
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f80a:9: Waiting for tgt ffff880819e99400: list_empty(sess_list)=1 sess_count=0
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-00af:9: Performing ISP error recovery - ha=ffff88081ab1c000.
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:00:00.0]-f803: : Target mode disabled
Dec  1 13:02:46 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-0075:9: ZIO mode 6 enabled; timer delay (200 us).
Dec  1 13:02:47 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f840:9: qla_target(0): Async event 0x8030 occurred: ignore (m[0]=8030, m[1]=41, m[2]=1000, m[3]=0)
Dec  1 13:02:47 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83b:9: qla_target(0): Async LOOP_UP occurred (m[0]=8011, m[1]=13, m[2]=44ef, m[3]=0)<3>qla2xxx [0000:02:00.3]-505f:9: Link is operational (10 Gbps).
Dec  1 13:02:47 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=ffff, m[2]=6, m[3]=0)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=ffff, m[2]=6, m[3]=0)qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=4, m[3]=600)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=4, m[3]=600)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=4, m[3]=600)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=4, m[3]=600)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=4, m[3]=600)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=4, m[3]=600)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=7, m[3]=b00)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=7, m[3]=b00)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=7, m[3]=b00)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=7, m[3]=b00)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=7, m[3]=b00)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=7, m[3]=b00)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=4, m[3]=600)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=4, m[3]=600)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=4, m[3]=600)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=4, m[3]=600)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=7, m[3]=b00)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=7, m[3]=b00)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=4, m[3]=600)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=4, m[3]=600)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=7, m[3]=b00)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=7, m[3]=b00)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=7, m[3]=b00)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=7, m[3]=b00)
Dec  1 13:02:48 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:02:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f80b:9: Waiting for 0 IRQ commands to complete (tgt ffff880819e99400)
Dec  1 13:02:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f80c:9: Stop of tgt ffff880819e99400 finished<4>qla2xxx [0000:02:00.3]-f806:9: Adding sess ffff88031545ecc0 to tgt ffff880819e99400 via ->check_initiator_node_acl()
Dec  1 13:02:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f84b:9: qla_target(0): session for wwn 21:01:00:e0:8b:a6:d1:9f (loop_id 3, s_id 45:2:0, confirmed completion not supported) added
Dec  1 13:02:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f806:9: Adding sess ffff88031545e900 to tgt ffff880819e99400 via ->check_initiator_node_acl()
Dec  1 13:02:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f84b:9: qla_target(0): session for wwn 21:00:00:0e:1e:31:83:5f (loop_id 5, s_id e:0:0, confirmed completion not supported) added
Dec  1 13:07:03 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-00af:9: Performing ISP error recovery - ha=ffff88081ab1c000.
Dec  1 13:07:03 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f808:9: qla_tgt_fc_port_deleted ffff88031545ecc0
Dec  1 13:07:03 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f808:9: qla_tgt_fc_port_deleted ffff88031545e900<4>qla2xxx [0000:00:00.0]-10710: : HOST-ABORT-HNDLR: base_vha->dpc_flags=8.
Dec  1 13:07:03 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-0075:9: ZIO mode 6 enabled; timer delay (200 us).
Dec  1 13:07:04 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f840:9: qla_target(0): Async event 0x8030 occurred: ignore (m[0]=8030, m[1]=41, m[2]=1000, m[3]=0)
Dec  1 13:07:04 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83b:9: qla_target(0): Async LOOP_UP occurred (m[0]=8011, m[1]=13, m[2]=44ef, m[3]=0)<3>qla2xxx [0000:02:00.3]-505f:9: Link is operational (10 Gbps).
Dec  1 13:07:04 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=ffff, m[2]=6, m[3]=0)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=ffff, m[2]=6, m[3]=0)<4>qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x03
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x03
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x03
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=4, m[3]=600)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=4, m[3]=600)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x20
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x20
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x20
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=4, m[3]=600)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=4, m[3]=600)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=4, m[3]=600)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=4, m[3]=600)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=4, m[3]=a00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=4, m[3]=a00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=4, m[3]=a00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=4, m[3]=a00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=4, m[3]=a00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=4, m[3]=a00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x21
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x21
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x21
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=7, m[3]=b00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=7, m[3]=b00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x05
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x05
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x05
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=7, m[3]=b00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=7, m[3]=b00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=7, m[3]=b00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=7, m[3]=b00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x03
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x03
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x03
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=4, m[3]=600)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=4, m[3]=600)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x20
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=4, m[3]=600)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=4, m[3]=600)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x20
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=4, m[3]=600)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=4, m[3]=600)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=4, m[3]=a00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=4, m[3]=a00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x20
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x21
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=4, m[3]=a00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=4, m[3]=a00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x21
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=4, m[3]=a00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=4, m[3]=a00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x21
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x05
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=7, m[3]=b00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=2, m[2]=7, m[3]=b00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=7, m[3]=b00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=1, m[2]=7, m[3]=b00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x05
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=7, m[3]=b00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=0, m[2]=7, m[3]=b00)
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9: Async MB 2: Port Logged Out
Dec  1 13:07:05 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x05
Dec  1 13:07:06 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f808:9: qla_tgt_fc_port_deleted ffff88031545ecc0
Dec  1 13:07:06 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f84c:9: qla_target(0): local session for port 21:01:00:e0:8b:a6:d1:9f (loop ID 3) reappeared
Dec  1 13:07:06 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f807:9: Reappeared sess ffff88031545ecc0
Dec  1 13:07:06 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f84d:9: qla_target(0): local session for port 21:01:00:e0:8b:a6:d1:9f (loop ID 3) became global
Dec  1 13:07:06 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f808:9: qla_tgt_fc_port_deleted ffff88031545e900
Dec  1 13:07:06 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f84c:9: qla_target(0): local session for port 21:00:00:0e:1e:31:83:5f (loop ID 5) reappeared
Dec  1 13:07:06 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f807:9: Reappeared sess ffff88031545e900
Dec  1 13:07:06 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f84d:9: qla_target(0): local session for port 21:00:00:0e:1e:31:83:5f (loop ID 5) became global
Dec  1 13:09:35 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10801:9: qla_target(0): TARGET_RESET received
Dec  1 13:09:35 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM response mcmd (ffff880319679388) status 0x0 state 0x0
Dec  1 14:52:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10801:9: qla_target(0): TARGET_RESET received
Dec  1 14:52:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM response mcmd (ffff880319679388) status 0x0 state 0x0
Dec  1 14:55:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x03
Dec  1 14:55:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9: qla_target(0): Doing NEXUS_LOSS_SESS
Dec  1 14:55:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM response mcmd (ffff880319679388) status 0x0 state 0x1
Dec  1 14:55:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=5, m[2]=4, m[3]=600)
Dec  1 14:55:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 14:55:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=5, m[2]=4, m[3]=600)
Dec  1 14:55:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9: Async MB 2: Got PLOGI Complete
Dec  1 14:55:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x20
Dec  1 14:55:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9: qla_target(0): Doing NEXUS_LOSS_SESS
Dec  1 14:55:49 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM response mcmd (ffff880319679388) status 0x0 state 0x1
Dec  1 14:55:51 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x52
---------------------------------------------------------------------------


}-- End of excerpt from Duane Grigsby

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If you ever teach a yodeling class, probably the hardest thing is to
 keep the students from just trying to yodel right off. You see, we build
 to that."
                                -- Jack Handey
                                   Deep Thoughts
