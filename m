From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/VM TOPIC] Handling of invalid requests in virtual HBAs
Date: Wed, 14 Apr 2010 06:49:04 -0700
Message-ID: <1271252944.27110.28.camel@haakon2.linux-iscsi.org>
References: <4BB45632.5020700@suse.de> <4BC099C5.9090704@vlnb.net>
	 <4BC431C8.9020800@suse.de>  <4BC4A559.4090806@vlnb.net>
	 <1271183865.32337.39.camel@haakon2.linux-iscsi.org>
	 <4BC4C4C9.70103@vlnb.net>
	 <1271191520.32337.77.camel@haakon2.linux-iscsi.org>
	 <4BC5BC22.7080003@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:22884 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755666Ab0DNNuo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Apr 2010 09:50:44 -0400
In-Reply-To: <4BC5BC22.7080003@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Hannes Reinecke <hare@suse.de>, lsf10-pc@lists.linuxfoundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2010-04-14 at 16:59 +0400, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger, on 04/14/2010 12:45 AM wrote:
> > On Tue, 2010-04-13 at 23:23 +0400, Vladislav Bolkhovitin wrote:
> >> Nicholas A. Bellinger, on 04/13/2010 10:37 PM wrote:
> >>> On Tue, 2010-04-13 at 21:09 +0400, Vladislav Bolkhovitin wrote:
> >>>> LIO doesn't support 1 to many pass-through devices sharing, so SCST in 
> >>>> the only option.
> >>> Sorry, but this statement about your perceived limitiations wrt TCM/LIO
> >>> is completely incorrect.
> >>>
> >>> Using a single passthrough backstore device (eg: plain /dev/sdX) with
> >>> TCM/pSCSI (or any TCM subsystem plugin) has been supported since the
> >>> dawn of time to allow for any number of TCM_Loop Virtual SAS Ports with
> >>> SG_IO going into KVM Guest.  The same is also true for LIO-Target
> >>> (iSCSI) and TCM_FC (FCoE) ports as well regardless of TCM subsystem
> >>> backstore.
> >>>
> >>> Perhaps you would be so kind to provide a TCM/LIO source code reference
> >>> from where you came up with this make-believe notion..?
> >> I've just rechecked with the latest 
> >> git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git and 
> >> still wasn't able to find in LIO required pieces of functionality to 
> >> support 1 to many pass-through. I see only code for non-enforced 1 to 1 
> >> pass-through (single initiator only). You can use with it more 
> >> initiators only as the SCSI violation, from pointing on which I started 
> >> my participation in this discussion.
> >>
> > 
> > Sorry, but listing the path to my git tree on k.o is not the same as
> > citing a actual TCM/LIO source+line reference.
> 
> That's interesting. How can I point to the code which doesn't exist?
> 
> >> Particularly, I can't see the code, which in pass-through mode upon 
> >> receive of RESERVE command sends it also to the backend device, if 
> >> necessary (i.e. only the first time), and then sends RELEASE command to 
> >> the device upon the reservation holder removal. Could you point me on 
> >> the *exact* code which implements that?
> >>
> > 
> > Again, since *you* are the one making a claim, *you* are the one
> > expected to back it up with a concrete code reference and example
> > scenario.   Please, do the leg-work yourself wrt TCM SPC-3 persisetent
> > reservations and legacy SPC-2 reservations instead of expecting me to do
> > the actual work for you to verify your own fanciful claims about target
> > mode, seriously..
> > 
> > So, short of you being able to produce a response that is concrete and
> > human-readable, your claim will once again be dismissed as generic
> > hand-waving.
> 
> Well, this is an Open Source and in Open Source code auditing is the 
> most important way to verify an implementation. I reviewed TCM/LIO and 
> my conclusion is pretty clear:

Actually no, you have not reviewed or commented on a *single* one of the
'one patch per feature' commit series implementing >= SPC-3 Persistent
Reservations and implict/explict ALUA that I have posted to linux-scsi
in the last 18 months.  Instead you pick out this LSF thread about
Virtual HBAs + megasas + KVm Guest to start airing your persistent
reservations concerns with me, why on earth would that possibily be..?

See, the way that us here in the real world review patches is by posting
digestable individual feature bits so that they can be understood and
reviewed by actual humans instead of randomly posting 10,000s lines of
code with *zero* context for anyone to care about or understand.

>  it misses too many important bits to be a 
> 1 to many pass-through implementation, so it implements only 
> not-enforced 1 to 1 pass-through. You implemented reservations 
> emulation, but that's _NOT_ enough. I gave an example of the one among 
> many missed functionality.

Sorry, but again you are completely incorrect.  Why don't you have a
look at what TCM supports for iSCSI, SAS and FC target ports from the
link below and get specific about the 'many missed functionality'..?

http://linux-iscsi.org/index.php/Persistent_Reservations

> 
> I'm not going to go any deeper than I've already gone doing your home 
> work for you and explaining you the SCSI basics (although for me it's 
> really hard to believe that a person implemented something as big as 
> TCM/LIO can't see such obvious things), because when I did it before, 
> when you asserted that if a pass-trough device supports Persistent 
> Reservations, LIO in pass-through mode with this device automatically 
> supports them too, which is obviously wrong (see the end of 
> http://lkml.org/lkml/2008/7/14/273), I didn't have even a bit of 
> appreciation for my effort. Instead I received privately from you 
> insulting and threatening e-mails.
> 

Wow, this is where you are getting your ideas from..?  An email from
2008 talking about LIO 2.x code..?  Seriously, you attempting to ignore
all of the work that has gone into TCM/ConfigFS v3.x -> v4.0 means that
you are living in a world of fantasy.

> If you are not agree with my conclusion about pass-through 
> implementation in TCM/LIO, you can either point us on the code 
> implementing the necessary functionality, which I missed, or argue why 
> it isn't needed. But if you continue attacking me personally trying to 
> discredit me, everybody will see that my conclusions are definitely 
> correct as well as which is your preferred way of cooperation.
> 

Sorry, but I cannot make it any more clear for you.  Either you provide
a code reference and scenario for your claim against TCM/LIO code from
this decade for lio-core-2.6.git, or I will once again ignore your
hand-waving until you can learn how to have an on-topic discussion of
meaning and substance.

--nab


