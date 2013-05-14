From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: SCSI testing/USB devices are amazing
Date: Tue, 14 May 2013 18:43:12 -0400
Message-ID: <yq1r4h989of.fsf@sermon.lab.mkp.net>
References: <CAN05THR+P7nzzTe6FCmG+F8_frkL=z-PS1GvoBVn57EyDMo-dw@mail.gmail.com>
	<yq1k3n7eer4.fsf@sermon.lab.mkp.net>
	<CAN05THQ3ugPcgz7obJZKc=c6uGY47KTKahcxrAG9RW=sRn4yoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35439 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429Ab3ENWmv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 May 2013 18:42:51 -0400
In-Reply-To: <CAN05THQ3ugPcgz7obJZKc=c6uGY47KTKahcxrAG9RW=sRn4yoQ@mail.gmail.com>
	(ronnie sahlberg's message of "Mon, 13 May 2013 19:36:59 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Ronnie" == ronnie sahlberg <ronniesahlberg@gmail.com> writes:

Ronnie,

Ronnie> I have added tests for the block limits VPD as
Ronnie> SCSI.Inquiry.InquiryBlockLimits.  It checks that the pagelength
Ronnie> is valid. 3C if SBC3 is claimed and 0C if prior to SBC3.

Well, there are devices out there that claim SPC3/SBC2 compliance but do
support some of the newer features from SPC4/SBC3.

In this case I'd rely on the supported VPD page list. And if the BL VPD
is present and the device reports SPC3/SBC2 I'd print a warning.


Ronnie> It then validates that the UNMAP counts are sane.  Sane being
Ronnie> that if LBPU==0 then these must be 0, and if LBPU==1 then these
Ronnie> must be >1, must be >than 2**LBPPBE and either 0xffffffff or
Ronnie> <1M. (1M is arbitrary for "crazy large" number of blocks)

That's a good start, anyway.


Ronnie> The other fields I had a hard time to come up with good sanity
Ronnie> tests for. Any suggestions ?  Do you have examples of things
Ronnie> that vendors get wrong here ?

Maximum Write Same Length vs. support for WS10 and WS16.

Another interesting Write Same test: I have several devices that support
WS16 but which only support a 2-byte block count in WS16. I.e. you get
the larger LBA but not a bigger block count with WS16.

There's also the Logical Block Provisioning VPD page. You could verify
that UNMAP is supported when LBPU=1. Repeat for LBPWS and LBPWS10.

You could verify that the device actually returns zeroes when LBPRZ=1.


Ronnie> I will add tests for when protection information is enabled in
Ronnie> the future, I will need to find time to add it to tgt first.

I have a fairly extensive set of PI tests in my test suite. But that
gets pretty involved. We can deal with those later.


Ronnie> Very nice document.  Section 1.3 could update
Ronnie> though. READCAPACITY16 is only mandatory in SBC-2 IF the device
Ronnie> supports protection information, but optional if it does not.
Ronnie> In SBC-3 it is always mandatory though. Thin provisioning and
Ronnie> different logical/physical block sizes were only added to this
Ronnie> command in SBC-3 not SBC-2.

I describe what we actually do, not what's spec compliant :)

This is our current heuristic for READ CAPACITY(16):

static int sd_try_rc16_first(struct scsi_device *sdp)
{
        if (sdp->host->max_cmd_len < 16)
                return 0;
        if (sdp->scsi_level > SCSI_SPC_2)
                return 1;
        if (scsi_device_protection(sdp))
                return 1;
        return 0;
}


Ronnie> I have thus updated my READCAPACITY16 tests so that IF SBC-3 is
Ronnie> claimed, or if IQN->PROTECT is set then the device must support
Ronnie> this opcode or the test will fail.  Otherwise, if it is not
Ronnie> SBC-3 and if PROTECT is clear, then the test will be skipped but
Ronnie> not fail if the opcode is missing.

*nod*

-- 
Martin K. Petersen	Oracle Linux Engineering
