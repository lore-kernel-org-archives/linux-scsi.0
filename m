From: "Anand Kumar Santhanam" <AnandKumar.Santhanam@pmcs.com>
Subject: RE: [PATCH V4 2/12] pm80xx: Added SPCv/ve specific ids, variables and modify for SPC
Date: Mon, 6 May 2013 09:48:43 -0700
Message-ID: <E5DEE6F468524847995699AD11E80885017C76B6@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <51703A99.5030605@pmc-sierra.com> <1367532744.3133.13.camel@dabdike> <E5DEE6F468524847995699AD11E80885013304BA@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca> <1367560743.24627.5.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:33311 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613Ab3EFQsx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 May 2013 12:48:53 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1367560743.24627.5.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Harry Yang <Harry.Yang@pmcs.com>, Vishwanath Maram <Vishwanath.Maram@pmcs.com>, sakthivel.sk@hcl.com, Rich Bono <Rich.Bono@pmcs.com>, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>

Hi James,

I have resubmitted the patchset after fixing the array out of bounds
issue. Pls pull the same.

I guess I did not make myself clear with my earlier mail. I compiled my
earlier patchset using the 
Kernel Makefile and I did not get the array out of bounds warning even I
had -Wall -O2 flags enabled.
So I was just wondering whether you are using any special settings such
that you are able to see the 
warning.

Regards
Anand

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Friday, May 03, 2013 11:29 AM
To: Anand Kumar Santhanam
Cc: linux-scsi@vger.kernel.org; Harry Yang; Vishwanath Maram;
sakthivel.sk@hcl.com; Rich Bono; Sangeetha Gnanasekaran
Subject: Re: [PATCH V4 2/12] pm80xx: Added SPCv/ve specific ids,
variables and modify for SPC

On Thu, 2013-05-02 at 19:26 -0700, Anand Kumar Santhanam wrote:
> James,
>  
> Can you pls let us know the warning flags you are including in your 
> makefile such that we can check from our end.
> Obviously it looks like we did not use -Warray-bounds in this case.

Oh good grief, please stop wasting my time.  You have the definition
here in your patch:

> +	u32			rsvd1[2];

And then you use it as:

> +	pm8001_ha->gs_tbl.pm8001_tbl.rsvd1[0]		=
> +				pm8001_mr32(address, 0x38);
> +	pm8001_ha->gs_tbl.pm8001_tbl.rsvd1[1]		=
> +				pm8001_mr32(address, 0x3C);
> +	pm8001_ha->gs_tbl.pm8001_tbl.rsvd1[2]		=
> +				pm8001_mr32(address, 0x40);

That last one goes over the array bounds because an array declared as
rsvdl1[2] only has two elements: 0 and 1 ... this isn't rocket science
or esoteric compiler flags, this is basic C.

Stop quibbling and fix it, please.

James


