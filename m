From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCHv2 00/18] ALUA update and Referrals support
Date: Tue, 19 Nov 2013 16:06:16 -0800
Message-ID: <1384905976.4307.39.camel@haakon3.risingtidesystems.com>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
	 <1384904569.4307.34.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34860 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3KTAG1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2013 19:06:27 -0500
In-Reply-To: <1384904569.4307.34.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2013-11-19 at 15:42 -0800, Nicholas A. Bellinger wrote:
> Hey Hannes!
> 
> On Tue, 2013-11-19 at 09:07 +0100, Hannes Reinecke wrote:
> > Hi Nic,
> > 
> > here's the second version of my ALUA update & Referrals support patches.
> > As per request I've split up the supported states into individual
> > attributes, and while there I've also renamed the rather confusing
> > 'alua_access_type' and 'alua_access_status' into 'alua_management_type'
> > and 'alua_status_modification', respectively.
> > 
> > The other features are:
> > 
> > - Make supported states configurable:
> >   We should make the list of supported ALUA states configurable,
> >   as some setups would possibly like to support a small subset
> >   of ALUA states only.
> > - Asynchronous transitioning: I've switched 'transitioning'
> >   handling to use a workqueue, that should allow us to simulate
> >   asynchronous transitioning modes. IE TCM should now be capable
> >   of handling requests while in transitioning, and properly terminate
> >   these with the correct sense code.
> > - Include target device descriptor in VPD page 83
> >   For the ALUA device handler we'd need to identify the target device
> >   where a given target port belongs to. So include the respective
> >   values in the VPD page.
> > 
> > And, of course, referrals support.
> > 
> 
> Ok, even though it is late, I've applied this series to for-next.
> 
> So the one main concern here is that the user visible changes to
> existing ALUA configfs attributes end up breaking the lio-utils code
> related to ALUA that depend upon them, which will need to be resolved
> separately.
> 
> However, this breakage is pretty minor and having more sensible +
> consistent attribute naming is worth the inconvenience.
> 

OK, I'm having second thoughts about the user-visible changes to
existing configfs attributes..

I'm fine with these types of changes, but need some more time to sort
out how it's going to effect existing userspace dependencies.  The one
that immediately made do a double take is changing 'alua_access_state'
to change input/output, but keep the same attribute name which makes
backwards compatibility alot more tricky.

So all that said, let's defer to v3.14 for this particular series, and
sort out the user visable changes first, and make adjustments as
necessary from there.

WDYT..?

--nab


