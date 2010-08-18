From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/1] Remove LUNs that no longer exist when we scan a
 target with REPORT LUNS.
Date: Wed, 18 Aug 2010 10:13:17 -0500
Message-ID: <1282144397.3035.32.camel@mulgrave.site>
References: <1281917313-1855-1-git-send-email-realrichardsharpe@gmail.com>
	 <1281917313-1855-2-git-send-email-realrichardsharpe@gmail.com>
	 <AANLkTi=LvbUnQjPjFrHFtszMkY526mu8X9vCrMDEBO5C@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58943 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab0HRPNW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 11:13:22 -0400
In-Reply-To: <AANLkTi=LvbUnQjPjFrHFtszMkY526mu8X9vCrMDEBO5C@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Sharpe <realrichardsharpe@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2010-08-18 at 08:10 -0700, Richard Sharpe wrote:
> On Sun, Aug 15, 2010 at 5:08 PM,  <realrichardsharpe@gmail.com> wrote:
> > From: Richard Sharpe <realrichardsharpe@gmail.com>
> >
> > If the target returns logical_unit_not_supported when we send REPORT LUNS
> > it means that it supports REPORT LUNS but there really are no LUNs there.
> > Delete LUN 0 in that case.
> >
> > Also, when parsing the LUNs reported, remove any LUNs that used to exist
> > in the gaps, and remove LUNs beyond the end of those reported. They no
> > longer exist.
> >
> > Also don't scan a target where the ID is too large or the channel is
> > too large.
> >
> > Tested by adding four LUNs with scst_local and then deleting them in
> > various combinations, including deleting from LUN 0, deleting from last
> > LUN and deleting in the middle out.
> 
> Hmmm, before James responds, it turns out that I did not test as
> carefully as I thought, and deleting LUNs in the order 0, 2, ... does
> not produce the results I expected, so I will have to rework this.

OK, so I think what I'd really like is an AEN notification
infrastructure based on the unit attentions that bubbles this up to user
space for a decision.  That way if user space does the removal, we're
not going to get into locking or other problems.

James



