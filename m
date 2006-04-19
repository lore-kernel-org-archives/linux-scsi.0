From: Orion Poplawski <orion@cora.nwra.com>
Subject: Re: Vendor specific cdrom error messages
Date: Wed, 19 Apr 2006 15:55:43 -0600
Message-ID: <4446B1DF.9000105@cora.nwra.com>
References: <e25obb$2fp$1@sea.gmane.org> <44468948.6000109@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earth.cora.nwra.com ([65.125.157.180]:7149 "EHLO
	earth.cora.nwra.com") by vger.kernel.org with ESMTP
	id S1751254AbWDSVz7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 17:55:59 -0400
In-Reply-To: <44468948.6000109@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Orion Poplawski wrote:
>> I got the following error trying to burn a DVD on an IBM USB2 DVD-R burner:
>>
>> Nov  7 11:40:36 makani kernel: cdrom: This disc doesn't have any tracks
>> I recognize!
>> Nov  7 11:41:59 makani kernel: sr 0:0:0:0: SCSI error: return code =
>> 0x8000002
>> Nov  7 11:41:59 makani kernel: sr0: Current: sense key: Data Protect
>> Nov  7 11:41:59 makani kernel:     ASC=0x27 <<vendor>> ASCQ=0xff
>>
>> This is on Fedora Core 4 and kernel 2.6.13-1.1532_FC4.
>>
>> It turns out that this is because the drive did not have enough power
>> (it was not plugged into the separate ac adapter).  I was able to
>> determine this by booting into Windows, which gave me a nice descriptive
>> error message.
>>
>> I was wondering if it makes sense for the kernel drivers to know these
>> error messages and report better errors, of it should be left up to user
>> space tools.
> 
> I think that you can guess the answer to the above query.
> Asc and/or ascq codes >= 0x80 (and <= 0xff) mark the
> additional sense code as vendor specific.

Sorry, I'm a bad guesser.  So, user space?

> The ascq code looks suspicious. An asc/ascq tuple of
> <0x27,0x0> ("Write protected") would tie in pretty well
> with the sense key of "Data Protect". A better choice
> might be <0x5e,0x0> "Low power condition on".

But we don't have any choice here right?  Isn't this simply what the 
drive returns to us?  Are these codes passed on to user space?

Sorry, completely unfamiliar with the linux scsi stack.  Just trying to 
get the tools (dvd+rw-tools in this case) to return more informative 
error messages and thought I'd start from the bottom.


