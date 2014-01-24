From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Open/INQUIRY fails on RESERVE'd tape device
Date: Fri, 24 Jan 2014 11:22:24 -0500
Message-ID: <52E29340.3010401@interlog.com>
References: <11934060.3620421390552523314.JavaMail.kai.makisara@kolumbus.fi>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40874 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaAXQWj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jan 2014 11:22:39 -0500
In-Reply-To: <11934060.3620421390552523314.JavaMail.kai.makisara@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kai.makisara@kolumbus.fi, Matthias Eble <psychotrahe@gmail.com>, linux-scsi@vger.kernel.org

On 14-01-24 03:35 AM, kai.makisara@kolumbus.fi wrote:
> Matthias Eble [psychotrahe@gmail.com] kirjoitti:
>> Hi list,
>>
>> When a tape device is reserved with old reserve/release commands,
>> we see inquiry only works on the scsi generic device. For scsi tape devices
>> open() fails already:
>>
>> # lsscsi -g | grep st15
>> [2:0:6:0]    tape    HP       Ultrium 5-SCSI   I5DZ  /dev/st15  /dev/sg17
>>
>> # sg_vpd -vvv /dev/st15
>>   open /dev/st15 with flags=0x800
>>   error opening file: /dev/st15: Input/output error
>>
>> # sg_vpd -vvv /dev/nst15
>>   open /dev/nst15 with flags=0x800
>>   error opening file: /dev/nst15: Input/output error
>>
>> # sg_vpd -vvv /dev/sg17
>> open /dev/sg17 with flags=0x800
>> Supported VPD pages VPD page:
>>     inquiry cdb: 12 01 00 00 fc 00
>>       duration=2 ms
>>     inquiry: requested 252 bytes but got 22 bytes
>>    [PQual=0  Peripheral device type: tape]
>>   Supported VPD pages [sv]
>>   Unit serial number [sn]
>>   ...
>>
>>
>> So: should open() fail on a reserved tape device?
>> SPC2 states that INQUIRY should never conflict.
>> Or does that only apply to the generic device?
>> Okay, it doesn't conflict, but open fails. A SunOS st man page I found
>> states, INQUIRY shall be possible with reserved devices.
>>
> Opening a st device does more than INQUIRY (TEST_UNIT_READY, READ_BLOCK_LIMITS,
> MODE_SENSE). Can this explain what you see?

TEST UNIT READY is allowed in SPC-4 but there is a note
about it being disallowed (i.e. RESERVATION CONFLICT) in
SPC-2 and SPC-3. MODE SENSE conflicts with some types of
reservations and READ BLOCK LIMITS is allowed.

But EIO, arrrrr; that should be banned from the whole
storage subsystem. Either that or equate it to "I don't
have a clue why this failed". A Reservation Conflict is
a very useful piece of information that tells the user
twiddling knobs in sysfs ain't going to help.


And back to the original question; situations like these
are exactly why there needs to be pass-throughs (and
bsg should work as well as sg). A pass-through implements
a policy of "you asked for it, you got it, and with a
minimum of side effects".

Doug Gilbert


