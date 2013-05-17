From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: SCSI testing/USB devices are amazing
Date: Fri, 17 May 2013 16:53:07 -0700
Message-ID: <CAN05THQ16Aw3MedzTCw4bV6AKt4o0-cuYUXM4-_5DxMxG0R20Q@mail.gmail.com>
References: <CAN05THR+P7nzzTe6FCmG+F8_frkL=z-PS1GvoBVn57EyDMo-dw@mail.gmail.com>
	<yq1k3n7eer4.fsf@sermon.lab.mkp.net>
	<CAN05THQ3ugPcgz7obJZKc=c6uGY47KTKahcxrAG9RW=sRn4yoQ@mail.gmail.com>
	<yq1r4h989of.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:40139 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab3EQXxI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 May 2013 19:53:08 -0400
Received: by mail-pb0-f42.google.com with SMTP id up7so3766404pbc.15
        for <linux-scsi@vger.kernel.org>; Fri, 17 May 2013 16:53:07 -0700 (PDT)
In-Reply-To: <yq1r4h989of.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Martin,
Thansk for your suggestions.

On Tue, May 14, 2013 at 3:43 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Ronnie" == ronnie sahlberg <ronniesahlberg@gmail.com> writes:
...
> Ronnie> I have added tests for the block limits VPD as
> Ronnie> SCSI.Inquiry.InquiryBlockLimits.  It checks that the pagelength
> Ronnie> is valid. 3C if SBC3 is claimed and 0C if prior to SBC3.
>
> Well, there are devices out there that claim SPC3/SBC2 compliance but do
> support some of the newer features from SPC4/SBC3.
>
> In this case I'd rely on the supported VPD page list. And if the BL VPD
> is present and the device reports SPC3/SBC2 I'd print a warning.

I have updated the tests so that IF the device claims SBC-3 then the
SBC-3 page of pagelength 0x3c must be present.
If the device is not SBC-3, then I allow either the SBC-2 version of
the page that is 0x0c in length OR the SBC-3 version.

If the device returns a SBC-3 style page without claiming SBC-3
support I print a warning but allow the test to pass.

This is now part of the test  --test SCSI.Inquiry.InquiryBlockLimits

> Ronnie> The other fields I had a hard time to come up with good sanity
> Ronnie> tests for. Any suggestions ?  Do you have examples of things
> Ronnie> that vendors get wrong here ?
>
> Maximum Write Same Length vs. support for WS10 and WS16.
>
> Another interesting Write Same test: I have several devices that support
> WS16 but which only support a 2-byte block count in WS16. I.e. you get
> the larger LBA but not a bigger block count with WS16.

I have added tests to verify that WS16 supports >16 bit block count.
I also added tests that both WS10 and WS16 support >8 bit block counts.

These are part of:

--test SCSI.WriteSame10.WriteSame10Unmap
--test SCSI.WriteSame16.WriteSame16Unmap


Could you check if these tests catch the devices that you have that
had problem in this area?


>
> There's also the Logical Block Provisioning VPD page. You could verify
> that UNMAP is supported when LBPU=1. Repeat for LBPWS and LBPWS10.

I added tests that IF UNMAP works, then both LBPU and LPBME must be clear.
Analog for WS10/WS16.

If either of them does not work, then I check that the corresponding
LBPU/LBPWS10/LBPWS flags are clear.

This is tested in
--test SCSI.Unmap.UnmapVPD
--test SCSI.WriteSame10.WriteSame10UnmapVPD
--test SCSI.WriteSame16.WriteSame16UnmapVPD
>
> You could verify that the device actually returns zeroes when LBPRZ=1.

Tested in
--test SCSI.Unmap.Unmap
--test SCSI.WriteSame10.WriteSame10Unmap
--test SCSI.WriteSame16.WriteSame16Unmap


>
>
> Ronnie> I will add tests for when protection information is enabled in
> Ronnie> the future, I will need to find time to add it to tgt first.
>
> I have a fairly extensive set of PI tests in my test suite. But that
> gets pretty involved. We can deal with those later.

I would love to implement those tests in my testsuite,  but that is
probably not near future since I would have to add support for PI to
both wireshark and tgtd first.



Other tests you would like to see in the test tool ?


regards
ronnie sahlberg
