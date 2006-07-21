From: Hannes Reinecke <hare@suse.de>
Subject: Re: Re: [PATCH RFC] move scsi parts of dm hw
	handlers	to	scsi layer
Date: Fri, 21 Jul 2006 22:38:34 +0200 (CEST)
Message-ID: <2236943.1153514314265.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
References: <1153480817.8030.15.camel@max>
	<581472.1153482088210.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
	<44C0BF4C.5060102@cs.wisc.edu> <44C0C0BA.90006@cs.wisc.edu>
	<4880914.1153483821524.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
	<44C0C548.4080806@cs.wisc.edu> <20060721151656.GA10239@us.ibm.com>
	<44C10848.3080509@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44C10848.3080509@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Anderson <andmike@us.ibm.com>, agk@redhat.com, linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Am Fr 21.07.2006 19:00 schrieb Mike Christie <michaelc@cs.wisc.edu>:

> Mike Anderson wrote:
> > Mike Christie <michaelc@cs.wisc.edu> wrote:
> >> He He fun :)
> >>
> >> Sticking what we need in devinfo is a lot easier. And I think it
> >> makes
> >> sense since the devices info we want to bind with is in there
> >> already.
> >> If nobody says anything, I will send the next version of the path
> >> with
> >> devinfo integration.
> > 
> > I think Patrick added the comment and the interface so he can add
> > the
> > history. One can use the module or proc interface to pass update
> > devinfo
> > information in (the sysfs migration never was done). Well it has the
> > drawback stated above it can address the issue that certain devices
> > can be
> > supported without a kernel recompile.
> > 
> > Post storage summit I started creating a hardware handler in SCSI,
> > but for
> > some reason that I do not recall I started working on SDEV state
> > model
> > change integrated into devinfo. The thought being that devices would
> > come
> > up in a standby state and then all the varied commands to determine
> > path
> > state could be executed from user space.
> > 
> > Well it did solve the issue I was trying to address (passive paths
> > generating errors on startup), it would need user space assistance
> > with all
> > the plus / minus issues that brings.
> > 
> 
> Yeah, I am fine with all that and have no complaints. How can I
> complain
> when I always pop up with the do it in userspace comment :)
> 
Actually I talked to hch; he was fine with modifying / updating
scsi_devinfo.
He doesn't see any way of getting rid of scsi_devinfo.c in the near
future,
too. So go for it.

> My main focus for this was not really the startup. That was a side
> benefit to having the sense and that info in the kernel for failover
> requests and IO that is executed when the path is passive or active.
> 
> So today, we could use your userspace start up for bring up but we
> still
> need something to do failover and process those results and possibly
> process the results of other IO (similar to the emc first IO to the
> path
> case in the patch). For the latter, I think the EMC check_sense tests
> I
> am doing in my patch are already handled by other checks in scsi-ml so
> the sense stuff in scsi_emc_clariion.c is not exactly needed. So maybe
> we do not need hw handlers for that. As I have said before, I keep
> running into this problem where vendors say yes we need it but we do
> not
> have many good examples.
> 
> But if scsi-ml's sense decoding is ok by default and we do not need to
> override it, this just leaves explicit/manual failover. If we throw
> that
> to userspace along with your strart up code then I guess we do not
> need
> kernel hw handlers at all.
> 
> Did you guys end up doing a hw handler that runs in userspace for xdr
> or
> something? Has it worked out? Is there some common code that can be
> reused today by any chance? Or is this one of those cases where we are
> going too far with putting stuff in userspace do you think?
> 
Argl. No, I wouldn't put that one in userspace. The thing I really liked
about this approach is that the hardware handler are indeed decoupled
from
the multipath tools, so they would even work without multipathing
active.
Eg during boot. Which would rid us of the boot errors.

Cheers,

Hannes
