From: Ewan Milne <emilne@redhat.com>
Subject: Re: [dm-devel] ALUA - rescan device capacity on zero sized block
 devices
Date: Fri, 12 Jun 2015 11:17:52 -0400
Message-ID: <1434122272.22842.80.camel@localhost.localdomain>
References: <1887682221.152035.1428939145196.JavaMail.zimbra@kangaroot.net>
	 <552C008A.9070201@sandisk.com>
	 <987831457.156812.1428996031503.JavaMail.zimbra@kangaroot.net>
	 <552CCC77.9040703@suse.de>	<552CE2C2.8000809@sandisk.com>
	 <CABr-GnefEhc_dOKs360Hox7asbvO5qN8BqPczqC+V8CQ6Myh8w@mail.gmail.com>
	 <55349580.1040205@suse.de>
	 <1433948530.27387.92.camel@localhost.localdomain>
	 <55792206.3090505@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbbFLPRy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2015 11:17:54 -0400
In-Reply-To: <55792206.3090505@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, Christophe Varoqui <christophe.varoqui@opensvc.com>

On Thu, 2015-06-11 at 07:52 +0200, Hannes Reinecke wrote: 
> On 06/10/2015 05:02 PM, Ewan Milne wrote:
> > On Mon, 2015-04-20 at 07:58 +0200, Hannes Reinecke wrote:
> >> On 04/19/2015 12:56 AM, Christophe Varoqui wrote:
> >>> About five years ago, we faced a somewhat simular issue with
> >>> Symmetrix arrays, where the replicated LU of a SRDF pair (R2) was
> >>> flagged read-only by the kernel upon discovery. Splitting the pair
> >>> with a symcli command  made the LU read-write from the array
> >>> controller point of view, but the Linux kernel would not promote it
> >>> read-write dynamically.
> >>>
> >>> I don't know if the Symmetrix array also use a unit attention to
> >>> signal the change to the initiators. If it does, it might be worth
> >>> trying to address both the 3par peer persistance and the Symmetrix
> >>> SRDF situations.
> >>>
> >>> On the other hand, if the SRDF R2 rw promotion issue has been fixed
> >>> since, the patch might give guidance about where/how to plug the
> >>> 3par peer persistance ghost path rescans.
> >>>
> >> It's not only that; if you are faced with LUNs in standby even the
> >> kernel wouldn't detect them properly.
> >>
> >> I'm currently debugging this issue and will have an update soon(-ish).
> > 
> > I have a patch set to have the kernel automatically rescan the device
> > when the ALUA state changes to an ACTIVE state, if it couldn't read
> > capacity when the device was initially probed.  I've had it for a while,
> > but I haven't had *any* response from the vendor if it actually works
> > with their product, so I haven't posted it to the list for review yet.
> > 
> Please hold off that patchset.

Sure.  It was really meant to be an RFC anyway.  I didn't want to
take up anyone's time unless it was a viable solution.

We talked a bit about having the kernel automatically update device
attributes at LSF back in March, this was a step towards that.
It implemented a notification mechanism so lower layers (e.g. ALUA
device handler) could propagate status changes up to upper layers
(e.g. sd device class).

> 
> I've posted the ALUA update patchset a while ago, and are working on
> including the suggestions from hch.
> 
> Please check if that patchset fixes the issue.

Will do, it's on my to-do list as soon as we get past a bunch of
other major stuff in the near term.

> 
> Additionally, I've got some patches for lio-target which will blank
> out the READ CAPACITY command when in standby; with that one has an
> easy testbed for this kind of issues.
> 
> > I did point out to them that the T10 spec does not *prohibit* supporting
> > the READ CAPACITY command in the ALUA standby state, which would avoid
> > the problem, and is what other vendors seem to do.  However, they then
> > raised the issue that if the capacity changes in the standby state then
> > they should be generating the capacity changed UA, etc and you can sort
> > of see their point of why this gets complicated.
> > 
> Which is actually not true. The capacity did _not_ change, it's just
> the command which isn't supported. If the command was supported and
> would have reported a size of '0' in standby _then_ it would have
> been a capacity change. But that's not the case here.

Yes, their argument was really more theoretical, in that "if we tell
you about the capacity in standby, we have to tell you when it changes
in standby" and they didn't want to implement that complexity in their
device server.

There's an interesting, somewhat-related issue I've come across with
iSCSI storage, when an event happens while the connection is not
established (i.e. link down, or logged out for some reason).  The T10
spec says that UAs are supposed to be reported on the I-T nexuses,


> 
> Cheers,
> 
> Hannes



