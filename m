From: Willy Tarreau <w@1wt.eu>
Subject: Re: Qlogic driver fix in backports induces target code regression.
Date: Fri, 23 Jun 2017 20:16:47 +0200
Message-ID: <20170623181647.GB25094@1wt.eu>
References: <201706231745.v5NHjHVs031535@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:53453 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754237AbdFWSRF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 14:17:05 -0400
Content-Disposition: inline
In-Reply-To: <201706231745.v5NHjHVs031535@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com
Cc: ben@decadent.org.uk, Quinn.Tran@cavium.com, Giridhar.Malavali@cavium.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

Hi,

On Fri, Jun 23, 2017 at 12:45:17PM -0500, Dr. Greg Wettstein wrote:
> Hi, I hope the week is ending well for everyone.
> 
> We just tracked this issue down and I wanted to bring it to the
> attention of Willy and Ben in particular, since it is has a high
> probability of negatively affecting storage consumers of the LTS
> kernel series.
> 
> The following fix from the mainline kernel has been actively
> backported to the LTS kernel series:
> 
> Commit ef86cb2 ("qla2xxx: Mark port lost when we receive an RSCN for it.")
> 
> This fix to the qla2xxx driver core provokes a regression in the
> target code which will probabilistically hang a kernel which is
> processing remote fibre-channel port deletion events.
> 
> The following commit from the mainline kernel fixes this:
> 
> Commit ba9f6f6 ("qla2xxx: Fix hardware lock/unlock issue causing kernel panic.)
> 
> This latter fix, while being tagged for 3.18+, does not appear as if
> it is being picked up for backporting.
> 
> So a situation arises where target users will get hit by this
> regression when they transition past the patch release which has the
> first 'fix' in it.  We just got done checking 3.10.106 and 3.16.44 and
> this situation is present in these most terminal LTS releases.

Indeed, regarding 3.10 it was merged in 3.10.85.

> We are in the process of validating application of the second 'fix' to
> the LTS series but a review of the patch doesn't suggest the potential
> for negative effects.  The same cannot be said for not having the
> fix.. :-)
> 
> Hopefully this is useful information.

Sure it is. Given that the regression was introduced two years ago in
our stable kernels, I guess there's no rush to revert the faulty fix
and that we'll wait for your feedback on testing the second fix above.
Please keep us informed about your progress and whether we need to
backport this patch.

thanks!
Willy
