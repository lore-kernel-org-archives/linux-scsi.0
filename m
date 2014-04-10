From: Andreas Reis <andreas.reis@gmail.com>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Thu, 10 Apr 2014 14:26:34 +0200
Message-ID: <53468DFA.2080903@gmail.com>
References: <Pine.LNX.4.44L0.1404091358340.28384-100000@netrider.rowland.org> <53467950.3010403@gmail.com> <53468297.1040909@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:57791 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030405AbaDJM0h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Apr 2014 08:26:37 -0400
In-Reply-To: <53468297.1040909@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

Only your 0/3 patch to which Alan linked, along with two other patches=20
by Mathias Nyman ("disable usb3 on intel hosts" and "disable all lpm=20
related control transfers", one of which is the source of the "do=20
nothing"s).

I'll revert the latter two and apply the rest of the set. Which I'm=20
guessing currently consists of said 0/3 patch =97
http://www.spinics.net/lists/linux-scsi/msg73502.html
=97 plus 2/3 and 3/3?

Or should I just omit 0/3 and try whichever of the two in 1/3 "works=20
best"? Rather confusing ATM.

Anyway, for whatever reason the bug is happening rather frequently now.=
=20
I've spotted the following occurring after the "Device offlined" line=20
two times now:

[  206.901385] sd 11:0:0:0: [sdg] Unhandled error code
[  206.901394] sd 11:0:0:0: [sdg]
[  206.901397] Result: hostbyte=3D0x01 driverbyte=3D0x00
[  206.901400] sd 11:0:0:0: [sdg] CDB:
[  206.901403] cdb[0]=3D0x2a: 2a 00 02 25 1b 50 00 00 08 00
[  206.901419] end_request: I/O error, dev sdg, sector 35986256

The second time had "sd 12:0:0:0", "cdb[0]=3D0x28: 28 00 03 94 77 20 00=
 00=20
08 00" and a different sector.

Andreas Reis

On 10.04.2014 13:37, Hannes Reinecke wrote:
> On 04/10/2014 12:58 PM, Andreas Reis wrote:
>> That patch appears to work in preventing the crashes, judged on one
>> repeated appearance of the bug.
>>
>> dmesg had the usual
>> [  215.229903] usb 4-2: usb_disable_lpm called, do nothing
>> [  215.336941] usb 4-2: reset SuperSpeed USB device number 3 using
>> xhci_hcd
>> [  215.350296] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
>> with disabled ep ffff880427b829c0
>> [  215.350305] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
>> with disabled ep ffff880427b82a08
>> [  215.350621] usb 4-2: usb_enable_lpm called, do nothing
>>
>> repeated five times, followed by one
>> [  282.795801] sd 8:0:0:0: Device offlined - not ready after error
>> recovery
>>
>> and then as often as something tried to read from it:
>> [  295.585472] sd 8:0:0:0: rejecting I/O to offline device
>>
>> The stick could then be properly un- and remounted (the latter if it
>> had been physically replugged) without issue =97 for the bug to
>> reoccur after one to three minutes. I tried this three times, no
>> dmesg difference except the ep addresses varied on two of that.
>>
> Was this just that patch you've tested with or the entire patch serie=
s?
>
> If the latter, Alan, is this the expected outcome?
> I would've thought the error recover should _not_ run into
> offlining devices here, but rather the device should be recovered
> eventually.
>
> Andreas, can you test with the entire patch series and enable
> 'scsi_logging_level -s -E 5' prior to running the tests?
>
> THX.
>
> Cheers,
>
> Hannes
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
