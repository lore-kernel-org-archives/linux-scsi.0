From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/11] mpt2sas: Discription patch
Date: Wed, 05 Aug 2009 08:59:35 -0500
Message-ID: <1249480775.4183.14.camel@mulgrave.site>
References: <20090805053107.GA13733@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44119 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934390AbZHEN7k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 09:59:40 -0400
In-Reply-To: <20090805053107.GA13733@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Wed, 2009-08-05 at 11:01 +0530, Kashyap, Desai wrote:
> MPT2SAS driver bug fixes. Please consider it for 2.6.32.

You mean for 2.6.31?

> "Previous Power cycling cascaded expanders causes kernel panic patch "
> is divided into small sub patches considering James comment.
> 
> Patch 1/11 is kernel panic fix and required to port back to stable kernel.

So you should add a

Cc: Stable Tree <stable@kernel.org>

to the signoff line; that's a flag that causes an automatic backport to
stable when the patch gets upstream.

Regarding the rest of the patches, the to be bug fixes they have to fix
actual bugs, not just move code around:

> [PATCH 1/11] mpt2sas: Power cycling cascaded expanders causes kernel panic

Yes

> [PATCH 2/11] mpt2sas: Host Reset code cleanup 

No - code clean up isn't a bug fix

> [PATCH 3/11] mpt2sas: Return immediately if host is under recovery.

Not sure: what bug is this fixing?

> [PATCH 4/11] mpt2sas: Code cleanup for _scsih_link_change function

No - code clean up isn't a bug fix

> [PATCH 5/11] mpt2sas: Attempt only 2 config_request retry.

This looks like it's fixing an infinite loop in the config request; if
so, it's definitely a bug fix, but the change log actually needs to say
this.

> [PATCH 6/11] mpt2sas: Added proper error handling for _scsih_expander_add.

This is marginal:  give me a better description of the problem it's
fixing.

> [PATCH 7/11] mpt2sas: Raid 10 Value is showing as Raid 1E in /va/log/messages

The change log of this reads like a feature addition: that's not a bug
fix.

> [PATCH 8/11] mpt2sas: When activating a inactive volume, hidden raid
> 		     components disapper.

Yes

> [PATCH 9/11] mpt2sas: During Full port cable breaks get sas iounit config
> 		     page0 timeout

This line reads like a bug fix ... the change log reads like a feature
enhancement; what is it?

> [PATCH 10/11] mpt2sas: OS is not going into standby mode.

Yes, but it's three fixes in one patch ... could we have one in each
patch, please?  

> [PATCH 11/11] mpt2sas: Bump driver version 01.100.06.00

Yes

James


