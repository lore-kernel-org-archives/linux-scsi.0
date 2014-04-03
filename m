From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] OSS target - VMware SCSI reservation bug
 conformity.
Date: Thu, 03 Apr 2014 13:21:04 -0700
Message-ID: <1396556464.21998.5.camel@haakon3.risingtidesystems.com>
References: <201404022029.s32KTrqs006179@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51469 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaDCUVQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2014 16:21:16 -0400
In-Reply-To: <201404022029.s32KTrqs006179@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Wed, 2014-04-02 at 15:29 -0500, Dr. Greg Wettstein wrote:
> On Mar 28,  8:53pm, Vladislav Bolkhovitin wrote:
> } Subject: Re: [Scst-devel] OSS target - VMware SCSI reservation bug conform
> 
> > Dr. Greg Wettstein, on 03/27/2014 11:21 AM wrote:
> > > Hi, hope the week is going well for everyone.
> > >
> > > There appears to be evidence that VMware has an issue with exact SCSI
> > > standards compliance when it comes to handling corner cases with SCSI
> > > reservation requests.  It appears as if Dell is pushing firmware hot
> > > fixes for the EqualLogic controllers to work around the issue.
> 
> > Hi Greg,
> 
> Hi Vlad, thanks for taking the time to respond.
> 
> > That's interesting, but, unfortunately, your message doesn't contain
> > sufficient technical details to look at this issue, if it exists. Or
> > do you think we are magicians who can read minds and see through
> > walls? ;)
> 
> Actually I did, but I assumed a maintenance contract would be needed
> for that.
> 
> I had the following reasons for raising the issue:
> 
> 	1.) Does anyone in the open-source storage eco-system,
> 	    ie. SCST/LIO whatever, have any confirmation that this
> 	    is a known issue.
> 

FYI guys, AFAICT this bug is specific to targets that don't support VAAI
AtomicTestandSet (COMPARE_AND_WRITE), and need to use the legacy SCSI-2
reservations instead.

When AtomicTestandSet is available, ESX will avoid using reservations to
lock the whole LUN and obtain exclusive access to individual VMFS extent
on a per node basis instead.

--nab

> 	2.) To alert other open-source storage users/vendors that, at
> 	    least from our experience, it appears as if the problem
> 	    may be rare but legitimate.
> 
> 	3.) To determine, if the bug could be found, whether things
> 	    like mode pages would make sense in an open-source stack
> 	    to address issues such as this.
> 
> I've had a fair amount of private feedback that there is a good chance
> the issue may be legitimate.  I've also had feedback that there may be
> other issues with VMware 'corner-case' behavior.  Given the nature of
> the VAAI extensions/primitives rolling out I would anticipate that to
> be a fertile area for these types of issues as well.
> 
> I'm not even sure, given the nature of the issue, if it could be
> tracked down but everyone who is interested in the issue can now be
> looking for it.
> 
> Here is the essence of what we have to work with, redacted due to the
> volume of messages, to sentinel events.
> 
> SDS proxy: ----------------------------------------------------------------
> Mar 19 21:50:30 PROXY kernel: rport-3:0-0: blocked FC remote port time out: removing target and saving binding
> Mar 19 21:50:30 PROXY kernel: sd 3:0:0:0: rejecting I/O to offline device
> Mar 19 21:50:32 PROXY kernel: qla2xxx [0000:04:00.1]-8009:3: DEVICE RESET ISSUED nexus=3:0:0 cmd=da751240.
> ..
> .. Noise from Qlogic adapter doing DTB reset.
> ..
> Mar 19 21:50:40 PROXY kernel: qla2xxx [0000:04:00.1]-8018:3: ADAPTER RESET ISSUED nexus=3:0:0.
> ..
> .. More noise from the Qlogic adapater.
> ..
> Mar 19 21:55:43 PROXY kernel: qla2xxx [0000:04:00.1]-8017:3: ADAPTER RESET SUCCEEDED nexus=3:0:0.
> ---------------------------------------------------------------------------
> 
> VMware logs: --------------------------------------------------------------
> Mar 19 21:49:08 VMWARE1 2014-03-20T02:49:08.592Z VMWARE1 vmkernel: cpu2:8432)<6>qla2xxx 0000:42:00.0: scsi(8:0:1): Abort command succeeded -- 1 1247096017.
> Mar 19 21:49:12 VMWARE1 2014-03-20T02:49:12.664Z VMWARE1 vobd:  [vmfsCorrelator] 11527431227280us: [esx.problem.vmfs.heartbeat.timedout] 52f3b635-9ea13918-af49-bc305bee68bc VOLUMENAME
> Mar 19 21:49:14 VMWARE1 2014-03-20T02:49:12.670Z VMWARE1 Hostd: [24FDEB90 info 'Vimsvc.ha-eventmgr'] Event 466 : Lost access to volume 52f3b635-9ea13918-af49-bc305bee68bc (VOLUMENAME) due to connectivity issues. Recovery attempt is in progress and outcome will be reported shortly.
> ..
> .. Noise from VMWARE hosts about wanting path updates - only single path
> .. to proxy, heartbeat timeouts etc.
> ..
> Mar 19 21:49:32 VMWARE1 2014-03-20T02:49:32.911Z VMWARE1 vmkernel: cpu10:8202)NMP: nmp_PathDetermineFailure:2084: SCSI cmd RESERVE failed on path vmhba2:C0:T0:L1, reservation state on device eui.6665356665393330 is unknown.
> ..
> .. More noise from VMWARE hosts, additional reservation failures etc.
> ..
> Mar 19 21:50:32 VMWARE2 2014-03-20T02:50:30.554Z VMWARE2 vmkwarning: cpu22:8237)WARNING: HBX: 564: Volume 52f3b635-9ea13918-af49-bc305bee68bc ("VOLUMENAME") may be damaged on disk. Corrupt heartbeat detected at offset 3653632: [HB state 0 offset 0 gen 0 stampUS 0 uuid 00000000-00000000-0000
> ---------------------------------------------------------------------------
> 
> And at that point things were pretty much over with.
> 
> I would certainly be open to suggestions on how to track or obtain
> useful information for you.  The SDS proxy was sustaining about 350
> megabytes/second of I/O from seven initiators so I don't think turning
> on target mode debugging and cmd tracing is much of an option.
> 
> > Thanks,
> > Vlad
> 
> Have a good weekend.
> 
> Greg
> 
> }-- End of excerpt from Vladislav Bolkhovitin
> 
> As always,
> Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
> 4206 N. 19th Ave.           Specializing in information infra-structure
> Fargo, ND  58102            development.
> PH: 701-281-1686
> FAX: 701-281-3949           EMAIL: greg@enjellic.com
> ------------------------------------------------------------------------------
> "After being a technician for 2 years, I've discovered if people took
>  care of their health with the same reckless abandon as their computers,
>  half would be at the kitchen table on the phone with the hospital, trying
>  to remove their appendix with a butter knife."
>                                 -- Brian Jones
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Scst-devel mailing list
> https://lists.sourceforge.net/lists/listinfo/scst-devel


