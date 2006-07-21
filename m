From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [dm-devel] Re: [PATCH RFC] move scsi parts of dm hw handlers to	scsi layer
Date: Fri, 21 Jul 2006 14:36:12 -0700
Message-ID: <20060721213612.GC15236@us.ibm.com>
References: <1153480817.8030.15.camel@max> <581472.1153482088210.SLOX.WebMail.wwwrun@imap-dhs.suse.de> <44C0BF4C.5060102@cs.wisc.edu> <44C0C0BA.90006@cs.wisc.edu> <4880914.1153483821524.SLOX.WebMail.wwwrun@imap-dhs.suse.de> <44C0C548.4080806@cs.wisc.edu> <20060721151656.GA10239@us.ibm.com> <44C10848.3080509@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:14043 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751194AbWGUVgM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jul 2006 17:36:12 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k6LLaCvb010295
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2006 17:36:12 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k6LLaBEF178196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2006 15:36:12 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k6LLaBFt000848
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2006 15:36:11 -0600
Content-Disposition: inline
In-Reply-To: <44C10848.3080509@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, device-mapper development <dm-devel@redhat.com>, agk@redhat.com, linux-scsi@vger.kernel.org

Mike Christie <michaelc@cs.wisc.edu> wrote:
> Mike Anderson wrote:
> > Mike Christie <michaelc@cs.wisc.edu> wrote:
> >> Hannes Reinecke wrote:
> >>> Am Fr 21.07.2006 13:55 schrieb Mike Christie <michaelc@cs.wisc.edu>:
> >>>
> >>>> Mike Christie wrote:
> >>>>> Hannes Reinecke wrote:
> >>>>>>> The patch below begins to push the scsi hw handler code down to
> >>>>>>> the
> >>>>>>> scsi
> >>>>>>> layer. I only began to covert dm-emc.c and it only hooks in at the
> >>>>>>> sense
> >>>>>>> decoding in scsi_error.c. I wanted to make sure I was going about
> >>>>>>> the
> >>>>>>> module loading and binding correctly. With a new target bus we
> >>>>>>> could
> >>>>>>> do
> >>>>>>> some driver model stuff instead, but I was not sure if that was
> >>>>>>> appropriate for this?
> >>>>>>>
> >>>>>> Why don't we use scsi_devinfo for this?
> >>>>> I was adding my fields when I noticed this comment:
> >>>>>
> >>>>>
> >>>>> * Do not add to this list, use the command line or proc interface to
> >>>>>  add
> >>>>>  * to the scsi_dev_info_list. This table will eventually go away.
> >>>>>
> >>>>>
> >>>>>> We have to have some sort of device table anyway as these handlers
> >>>>>> are
> >>>>>> far from being generic, so any sense code which triggers action on
> >>>>>> one
> >>>>>> device might be perfectly ok for others.
> >>>>> When I was looking for the history of that commet, I thought I read
> >>>>> that
> >>>>> we are supposed to be moving to some userspace approach that pushes
> >>>>> that
> >>>>> info down via some magic interface.
> >>>>>
> >>>> I added this comment at the wrong place. I meant to say I thought we
> >>>> are
> >>>> supposed to be moving away from the kernel devinfo list to some
> >>>> userspace one that gets sent down via the module_param or some new
> >>>> magic
> >>>> interface.
> >>> Or so they claim. I seem to remember some discussion about it; the net
> >>> result was the scsi_devinfo will stay with us for the time being.
> >>>
> >>> Otherwise you'll end up having to configure your kernel / module during
> >>> startup. With parameters which are static anyway. Can't say I like it.
> >>> And the tricky bit is that these information has to be present prior
> >>> to any initialisation, so you basically have to feed it during
> >>> modprobe time. Not really clever.
> >>>
> >> He He fun :)
> >>
> >> Sticking what we need in devinfo is a lot easier. And I think it makes
> >> sense since the devices info we want to bind with is in there already.
> >> If nobody says anything, I will send the next version of the path with
> >> devinfo integration.
> > 
> > I think Patrick added the comment and the interface so he can add the
> > history. One can use the module or proc interface to pass update devinfo
> > information in (the sysfs migration never was done). Well it has the
> > drawback stated above it can address the issue that certain devices can be
> > supported without a kernel recompile.
> > 
> > Post storage summit I started creating a hardware handler in SCSI, but for
> > some reason that I do not recall I started working on SDEV state model
> > change integrated into devinfo. The thought being that devices would come
> > up in a standby state and then all the varied commands to determine path
> > state could be executed from user space.
> > 
> > Well it did solve the issue I was trying to address (passive paths
> > generating errors on startup), it would need user space assistance with all
> > the plus / minus issues that brings.
> > 
> 
> Yeah, I am fine with all that and have no complaints. How can I complain
> when I always pop up with the do it in userspace comment :)
> 
> My main focus for this was not really the startup. That was a side
> benefit to having the sense and that info in the kernel for failover
> requests and IO that is executed when the path is passive or active.
> 
> So today, we could use your userspace start up for bring up but we still
> need something to do failover and process those results and possibly
> process the results of other IO (similar to the emc first IO to the path
> case in the patch). For the latter, I think the EMC check_sense tests I
> am doing in my patch are already handled by other checks in scsi-ml so
> the sense stuff in scsi_emc_clariion.c is not exactly needed. So maybe
> we do not need hw handlers for that. As I have said before, I keep
> running into this problem where vendors say yes we need it but we do not
> have many good examples.


Well I would not say that the scsi-ml sense / decide_disposition is doing
exactly what we want. One thing I ran into with the PPRC units was that an
error was generated when the PPRC connection between the units was broken.
The error generated was a hardware error which we retry unless the
fastfail flag was set (which it was). This error was then bubbled up to dm
but there was not much it could do with it as it was blind to the context
of the error.

> 
> But if scsi-ml's sense decoding is ok by default and we do not need to
> override it, this just leaves explicit/manual failover. If we throw that
> to userspace along with your strart up code then I guess we do not need
> kernel hw handlers at all.
> 
> Did you guys end up doing a hw handler that runs in userspace for xdr or
> something? Has it worked out? Is there some common code that can be
> reused today by any chance? Or is this one of those cases where we are
> going too far with putting stuff in userspace do you think?

I do not think this is model to repeat for general support as the
environment was unique due the control for the PPRC failover was out of
band and cluster like decisions where being made to decide if to failover
at all. 

My previous attempt was adding a ops table to the scsi_dev_info_list, but
I dropped this for some reason. At the time I was more focused on having a
capability where paths to devices inside SCSI core could be in different
states to reduce the boot up issue with active / passive paths.

-andmike
--
Michael Anderson
andmike@us.ibm.com
