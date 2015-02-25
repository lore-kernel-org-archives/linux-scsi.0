From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: rework resp_report_luns
Date: Wed, 25 Feb 2015 11:22:22 -0500
Message-ID: <54EDF6BE.2030000@interlog.com>
References: <1424813825-1970-1-git-send-email-tomas.winkler@intel.com> <54ED0C56.7040900@interlog.com> <5B8DA87D05A7694D9FA63FD143655C1B34BB49C6@HASMSX106.ger.corp.intel.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:43658 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbbBYQWl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2015 11:22:41 -0500
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B34BB49C6@HASMSX106.ger.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>, "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Elliott, Robert (Server Storage)" <elliott@hp.com>

On 15-02-25 02:54 AM, Winkler, Tomas wrote:
>> On 15-02-24 04:37 PM, Tomas Winkler wrote:
>>> 1. Fix the error check: the alloc length should be > 16
>>> and not > 4
>>
>> You are proposing to make a marginally incorrect test
>> completely incorrect!
>
> Quoting from the spec:

The great thing about standards is that there are so many
to choose from :-)
So it is best to say _which_ spec.

> The ALLOCATION LENGTH field is defined in 2.2.6. The allocation length should be at least 16.
> Note. Device servers compliant with SPC return CHECK CONDITION status, with the sense key set to
> ILLEGAL REQUEST, and the additional sense code set to INVALID FIELD IN CDB when the allocation
> length is less than 16 bytes.
> This is how it is implemented also in other drivers in the scsi drivers.

The scsi_debug driver contains this line:

#define DEF_SCSI_LEVEL   6    /* INQUIRY, byte2 [6->SPC-4] */

so by default it reports SPC-4 compliance. And what I have quoted
below is for SPC-4 and draft SPC-5.

My guess is that this was changed (between SPC-3 and SPC-4 ***)
for consistency (e.g. with LOG SENSE and INQUIRY) and flexibility.
It is awkward for an application client to set up a data-in
buffer for a size it does not yet know.

So if those "other drivers" report SPC-4 or later compliance
then they should be fixed since a REPORT LUNS allocation_length<16
is valid.

>> The governing rule for almost all "allocation length" fields
>> in SCSI commands (that return data-in) is:
>>
>> "An allocation length of zero specifies that no data shall
>> be transferred. This condition shall not be considered an
>> error." [in section 4.2.5.6 of spc5r03.pdf and REPORT LUNS
>> refers to this]
>
> Correct, but this wasn't the case also in the original code it checked for < 4.

>> If the REPORT LUNS allocation length is less that 4 then
>> the caller doesn't even get the response length back so that
>> has no practical use IMO. If allocation_length=0 and the SCSI
>> status is GOOD then all that tells you is that REPORT LUNS is
>> supported, but it has been a mandatory command for 10 years
>> so that is to be expected.
>
> I believe that also original code doesn't handle that case.

Correct, so if the app client sets an allocation length
of 3, then at your discretion, you can either leave the
code doing what it does now, or return those 3 bytes.
IOW leave it alone, improve it but don't make it worse.

>>> 2. Remove duplicated boundary checks which simplify
>>> the fill-in loop
>>> 3. Use more of scsi generic API
>>
>> Something else you might fix is the stack allocation of
>> 2048+8 bytes:
>>      u8 arr[SDEBUG_RLUN_ARR_SZ];
>>
>> It would be better to work out how many LUs the
>> parent target has and use kmalloc() (or friend)
>> to make a response buffer large enough.
>
> That might be fixed the question is if this not out of scope  for emulation  purposes.
> To get spec limit to 16K maybe it will overcomplicate code uncessary.
>
>   And
>> "large enough" needs to be no larger than the
>> allocation_length indicates however that requires
>> extra care in the loop stopping conditions.
>
> We are not getting anything unexpected insde the loop, the boundaries are known before we entering the loop.

I was noting that the boundary specified by the allocation
length (e.g. 3 or 11) may be an awkward fit for the loop
logic. For example you can't unconditionally use
put_unaligned_be32() into the response buffer if it was
kmalloc-ed for an allocation length of 3 bytes.

Doug Gilbert

*** The change was due to this T10 document: 11-004r0
     authored by Rob Elliott. It first appeared in spc4r20
     [20110331]



