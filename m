From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 9/13] mpt2sas: T10 DIF Support - EEDP
Date: Wed, 15 Apr 2009 18:26:55 -0400
Message-ID: <yq1ljq1y2mo.fsf@sermon.lab.mkp.net>
References: <660360F4F2570145BD872F298951B17A76B5F1A5@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:25357 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbZDOW1E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2009 18:27:04 -0400
In-Reply-To: <660360F4F2570145BD872F298951B17A76B5F1A5@cosmail03.lsi.com>
	(Eric Moore's message of "Wed, 15 Apr 2009 14:07:34 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Eric" == Moore, Eric <Eric.Moore@lsi.com> writes:

Eric,

Eric> The SAS controller firmware checks the tags, not device driver.
Eric> What this code is doing is setting flags in the SCSI_IO Request
Eric> message that is being sent to controller firmware.

Yeah, I figured that much.  I guess it makes sense when you treat the
app tag as being constant (modulo the mask) for one request.


Eric> Obviously the only errors the current implementation will only be
Eric> flaged on READs.

Eric> My line of thinking was I write the code so it won't need to be
Eric> rewrote later when DIX support is added for SAS3.0.

Ok, that's fine then.


Eric> Yes, I was told by the LSI software test lab, they saw drives
Eric> returning check condition with these ref tag errors.  I wasn't
Eric> able to repro that.  What I saw were the IOCSTATUS errors, which
Eric> is what the code handles in _scsih_eedp_error_handling().  Either
Eric> way, both cases are covered right?

Yeah.  With READ the difference is mostly academic.


>> If I understand correctly, your firmware only deals with the Type 2
>> usage model of the application tag.  And Type 1 + 2 usage of the
>> reference tag.

Eric> Our controller firmware support all three types of protection..

So you can actually set the application tag (and reference tag) on a
per-sector basis for Type 1 and 3 provided the OS sends down 520-byte
sectors?


>> + scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
>> 
>> Technically speaking that is only required for DIX exchange.  But
>> setting it doesn't hurt.

Eric> I wasn't sure whether it needed to be set.  Our controller
Eric> generates the CRC. I'm not sure whether firmware or hardware
Eric> implementation.

Given that it sounds like your next chip rev. will use the same driver
it should be ok to leave it in place.

-- 
Martin K. Petersen	Oracle Linux Engineering
