From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: rework resp_report_luns
Date: Tue, 24 Feb 2015 18:42:14 -0500
Message-ID: <54ED0C56.7040900@interlog.com>
References: <1424813825-1970-1-git-send-email-tomas.winkler@intel.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:52228 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbbBXXmd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2015 18:42:33 -0500
In-Reply-To: <1424813825-1970-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>, "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

On 15-02-24 04:37 PM, Tomas Winkler wrote:
> 1. Fix the error check: the alloc length should be > 16
> and not > 4

You are proposing to make a marginally incorrect test
completely incorrect!

The governing rule for almost all "allocation length" fields
in SCSI commands (that return data-in) is:

"An allocation length of zero specifies that no data shall
be transferred. This condition shall not be considered an
error." [in section 4.2.5.6 of spc5r03.pdf and REPORT LUNS
refers to this]

If the REPORT LUNS allocation length is less that 4 then
the caller doesn't even get the response length back so that
has no practical use IMO. If allocation_length=0 and the SCSI
status is GOOD then all that tells you is that REPORT LUNS is
supported, but it has been a mandatory command for 10 years
so that is to be expected.

> 2. Remove duplicated boundary checks which simplify
> the fill-in loop
> 3. Use more of scsi generic API

Something else you might fix is the stack allocation of
2048+8 bytes:
    u8 arr[SDEBUG_RLUN_ARR_SZ];

It would be better to work out how many LUs the
parent target has and use kmalloc() (or friend)
to make a response buffer large enough. And
"large enough" needs to be no larger than the
allocation_length indicates however that requires
extra care in the loop stopping conditions.

Doug Gilbert


