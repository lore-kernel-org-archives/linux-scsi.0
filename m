From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH] scsi_debug: rework resp_report_luns
Date: Wed, 25 Feb 2015 07:54:02 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B34BB49C6@HASMSX106.ger.corp.intel.com>
References: <1424813825-1970-1-git-send-email-tomas.winkler@intel.com>
 <54ED0C56.7040900@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:18270 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbbBYHyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2015 02:54:08 -0500
In-Reply-To: <54ED0C56.7040900@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> On 15-02-24 04:37 PM, Tomas Winkler wrote:
> > 1. Fix the error check: the alloc length should be > 16
> > and not > 4
> 
> You are proposing to make a marginally incorrect test
> completely incorrect!

Quoting from the spec:
The ALLOCATION LENGTH field is defined in 2.2.6. The allocation length should be at least 16.
Note. Device servers compliant with SPC return CHECK CONDITION status, with the sense key set to
ILLEGAL REQUEST, and the additional sense code set to INVALID FIELD IN CDB when the allocation
length is less than 16 bytes.
This is how it is implemented also in other drivers in the scsi drivers.

> 
> The governing rule for almost all "allocation length" fields
> in SCSI commands (that return data-in) is:
> 
> "An allocation length of zero specifies that no data shall
> be transferred. This condition shall not be considered an
> error." [in section 4.2.5.6 of spc5r03.pdf and REPORT LUNS
> refers to this]

Correct, but this wasn't the case also in the original code it checked for < 4.


> If the REPORT LUNS allocation length is less that 4 then
> the caller doesn't even get the response length back so that
> has no practical use IMO. If allocation_length=0 and the SCSI
> status is GOOD then all that tells you is that REPORT LUNS is
> supported, but it has been a mandatory command for 10 years
> so that is to be expected.

I believe that also original code doesn't handle that case.
 
> > 2. Remove duplicated boundary checks which simplify
> > the fill-in loop
> > 3. Use more of scsi generic API
> 
> Something else you might fix is the stack allocation of
> 2048+8 bytes:
>     u8 arr[SDEBUG_RLUN_ARR_SZ];
> 
> It would be better to work out how many LUs the
> parent target has and use kmalloc() (or friend)
> to make a response buffer large enough.

That might be fixed the question is if this not out of scope  for emulation  purposes.
To get spec limit to 16K maybe it will overcomplicate code uncessary. 
 
 And
> "large enough" needs to be no larger than the
> allocation_length indicates however that requires
> extra care in the loop stopping conditions.

We are not getting anything unexpected insde the loop, the boundaries are known before we entering the loop. 

Tomas


