From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V4 2/12] pm80xx: Added SPCv/ve specific ids, variables
 and modify for SPC
Date: Thu, 02 May 2013 22:59:03 -0700
Message-ID: <1367560743.24627.5.camel@dabdike>
References: <51703A99.5030605@pmc-sierra.com>
	 <1367532744.3133.13.camel@dabdike>
	 <E5DEE6F468524847995699AD11E80885013304BA@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54199 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761387Ab3ECF7G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 May 2013 01:59:06 -0400
In-Reply-To: <E5DEE6F468524847995699AD11E80885013304BA@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Cc: linux-scsi@vger.kernel.org, Harry Yang <Harry.Yang@pmcs.com>, Vishwanath Maram <Vishwanath.Maram@pmcs.com>, sakthivel.sk@hcl.com, Rich Bono <Rich.Bono@pmcs.com>, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>

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


