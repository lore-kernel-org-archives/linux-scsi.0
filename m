From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCHv2 00/18] ALUA update and Referrals support
Date: Wed, 20 Nov 2013 11:22:53 -0800
Message-ID: <1384975373.4307.64.camel@haakon3.risingtidesystems.com>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
	 <1384904569.4307.34.camel@haakon3.risingtidesystems.com>
	 <1384905976.4307.39.camel@haakon3.risingtidesystems.com>
	 <528C6870.6090607@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49316 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab3KTTXB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 14:23:01 -0500
In-Reply-To: <528C6870.6090607@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2013-11-20 at 08:44 +0100, Hannes Reinecke wrote:
> On 11/20/2013 01:06 AM, Nicholas A. Bellinger wrote:
> > On Tue, 2013-11-19 at 15:42 -0800, Nicholas A. Bellinger wrote:
> >> Hey Hannes!
> >>
> >> On Tue, 2013-11-19 at 09:07 +0100, Hannes Reinecke wrote:
> >>> Hi Nic,
> >>>
> >>> here's the second version of my ALUA update & Referrals support patches.
> >>> As per request I've split up the supported states into individual
> >>> attributes, and while there I've also renamed the rather confusing
> >>> 'alua_access_type' and 'alua_access_status' into 'alua_management_type'
> >>> and 'alua_status_modification', respectively.
> >>>

<SNIP>

> > 
> > OK, I'm having second thoughts about the user-visible changes to
> > existing configfs attributes..
> > 
> > I'm fine with these types of changes, but need some more time to sort
> > out how it's going to effect existing userspace dependencies.  The one
> > that immediately made do a double take is changing 'alua_access_state'
> > to change input/output, but keep the same attribute name which makes
> > backwards compatibility alot more tricky.
> > 
> It's just a matter of parsing, innit?
> 
> > So all that said, let's defer to v3.14 for this particular series, and
> > sort out the user visable changes first, and make adjustments as
> > necessary from there.
> > 
> > WDYT..?
> > 
> Sigh.
> Another patchset getting nowhere.
> 

Awww, I like to think target-pending is still a whole lot more merge
friendly than linux-scsi.  ;)

> Okay, here's the thing:
> The patchset can be split into three individual parts:
> The ALUA update proper, which affects only the internal flow of
> control (patches 1-6 and 11-16), then there's the ALUA configfs
> modifications (patches 7-10) and the Referrals support (17 and 18).
> If you have second thoughts you should be able to pull patches 7-10;
> the rest will work as designed even without them.

Ok, I'm completely fine with patches 1-6, which only add new attributes
and don't change input/output or rename existing attributes.

It's 7-10 that introduce the changes that are of concern..

> But then, there's not much difference on having all the patches in
> for 3.13, and sort out the userspace then, or wait for the next
> round and adjust the userspace during that time.
> 

As much as I'd like to merge this now, the changes to existing
attributes is what needs to be thought out some more, to avoid overt
backwards compatibility ugliness.

> Anyway, I don't mind either way. You're the maintainer, you get to
> decide. As least I got feedback about the patchset, which is more
> than one can hope for nowadays :-(

Lets merge 1-6 now for v3.13, and I'll merge the rest for v3.14 into
for-next as soon as -rc1 is released, and we can duke it out on the
specific details starting next week.

--nab

