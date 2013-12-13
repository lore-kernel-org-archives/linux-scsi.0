From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCHv2 00/18] ALUA update and Referrals support
Date: Fri, 13 Dec 2013 15:43:50 -0800
Message-ID: <1386978230.20247.164.camel@haakon3.risingtidesystems.com>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
	 <1384904569.4307.34.camel@haakon3.risingtidesystems.com>
	 <1384905976.4307.39.camel@haakon3.risingtidesystems.com>
	 <528C6870.6090607@suse.de>
	 <1384975373.4307.64.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50484 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3LMXnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2013 18:43:04 -0500
In-Reply-To: <1384975373.4307.64.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2013-11-20 at 11:22 -0800, Nicholas A. Bellinger wrote:
> On Wed, 2013-11-20 at 08:44 +0100, Hannes Reinecke wrote:
> > On 11/20/2013 01:06 AM, Nicholas A. Bellinger wrote:
> > > On Tue, 2013-11-19 at 15:42 -0800, Nicholas A. Bellinger wrote:
> > >> Hey Hannes!
> > >>
> > >> On Tue, 2013-11-19 at 09:07 +0100, Hannes Reinecke wrote:
> > >>> Hi Nic,
> > >>>
> > >>> here's the second version of my ALUA update & Referrals support patches.
> > >>> As per request I've split up the supported states into individual
> > >>> attributes, and while there I've also renamed the rather confusing
> > >>> 'alua_access_type' and 'alua_access_status' into 'alua_management_type'
> > >>> and 'alua_status_modification', respectively.
> > >>>
> 

<SNIP>

> > Okay, here's the thing:
> > The patchset can be split into three individual parts:
> > The ALUA update proper, which affects only the internal flow of
> > control (patches 1-6 and 11-16), then there's the ALUA configfs
> > modifications (patches 7-10) and the Referrals support (17 and 18).
> > If you have second thoughts you should be able to pull patches 7-10;
> > the rest will work as designed even without them.
> 
> Ok, I'm completely fine with patches 1-6, which only add new attributes
> and don't change input/output or rename existing attributes.
> 
> It's 7-10 that introduce the changes that are of concern..
> 
> > But then, there's not much difference on having all the patches in
> > for 3.13, and sort out the userspace then, or wait for the next
> > round and adjust the userspace during that time.
> > 
> 
> As much as I'd like to merge this now, the changes to existing
> attributes is what needs to be thought out some more, to avoid overt
> backwards compatibility ugliness.
> 
> > Anyway, I don't mind either way. You're the maintainer, you get to
> > decide. As least I got feedback about the patchset, which is more
> > than one can hope for nowadays :-(
> 
> Lets merge 1-6 now for v3.13, and I'll merge the rest for v3.14 into
> for-next as soon as -rc1 is released, and we can duke it out on the
> specific details starting next week.
> 

Ok, a bit longer than next week for getting back to this series, but now
I've a better idea where the user visable changes should end up.. 

What I'd really like to see for -v3 is:

Patch 7: Keep alua_access_state attribute store/show formatting (as is).
Patch 8: Keep alua_access_type attribute store/show formatting (as is)
         within a single attribute + drop support_* prefix to
         alua_supported_states attributes merged in v3.13
Patch 9: Drop alua_access_type attribute rename

So AFAICT none of these changes are strictly required to support
Referrals.  Granted, some of the early formatting decisions for these
ALUA attributes did not make a ton of sense, but regardless I very much
do not want name + formatting changes for existing attributes without a
really good reason.

I do like the usability aspects of the proposed name + formatting
changes, but these types of user facing things really should be
implemented at the rtslib + targetcli level, and not as changes to
existing configfs attributes.

That said, care to respin the series minus the above bits..?  ;)

Thank you,

--nab

