From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Qlogic driver fix in backports induces target code regression.
Date: Fri, 23 Jun 2017 12:45:17 -0500
Message-ID: <201706231745.v5NHjHVs031535@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:38703 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753786AbdFWSLB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 14:11:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: w@1wt.eu, ben@decadent.org.uk
Cc: Quinn.Tran@cavium.com, Giridhar.Malavali@cavium.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

Hi, I hope the week is ending well for everyone.

We just tracked this issue down and I wanted to bring it to the
attention of Willy and Ben in particular, since it is has a high
probability of negatively affecting storage consumers of the LTS
kernel series.

The following fix from the mainline kernel has been actively
backported to the LTS kernel series:

Commit ef86cb2 ("qla2xxx: Mark port lost when we receive an RSCN for it.")

This fix to the qla2xxx driver core provokes a regression in the
target code which will probabilistically hang a kernel which is
processing remote fibre-channel port deletion events.

The following commit from the mainline kernel fixes this:

Commit ba9f6f6 ("qla2xxx: Fix hardware lock/unlock issue causing kernel panic.)

This latter fix, while being tagged for 3.18+, does not appear as if
it is being picked up for backporting.

So a situation arises where target users will get hit by this
regression when they transition past the patch release which has the
first 'fix' in it.  We just got done checking 3.10.106 and 3.16.44 and
this situation is present in these most terminal LTS releases.

We are in the process of validating application of the second 'fix' to
the LTS series but a review of the patch doesn't suggest the potential
for negative effects.  The same cannot be said for not having the
fix.. :-)

Hopefully this is useful information.

Have a good weekend.

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"You and Uncle Pete drank the whole thing?  That was a $250.00 bottle
 of whisky.

 Yeah, it was good."
                                -- Rick Engen
                                   Resurrection.

-- 
