From: Mark Lord <mlord@pobox.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Sat, 03 Apr 2010 21:29:18 -0400
Message-ID: <4BB7EB6E.3010302@pobox.com>
References: <Pine.LNX.4.44L0.1004031648230.21507-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:54568 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab0DDB3s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2010 21:29:48 -0400
In-Reply-To: <Pine.LNX.4.44L0.1004031648230.21507-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jonas Schwertfeger <jschwertfeger@gmail.com>, dgilbert@interlog.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>

On 03/04/10 04:58 PM, Alan Stern wrote:
> On Sat, 3 Apr 2010, Jonas Schwertfeger wrote:
>
>> On 04/03/2010 06:42 PM, Alan Stern wrote:
>>> Can you acquire a usbmon trace showing what happens when you run this?
>>> Instructions are in the kernel source file
>>> Documentation/usb/usbmon.txt.
>>
>> Here you go:
>>
>> ffff8802123996c0 4253708718 S Bo:10:002:2 -115 31 = 55534243 9c000000
>> 00020000 80001085 082e0000 00010000 00000000 40ec00
>
> That's the first command.
>
>> ffff8802123996c0 4253708828 C Bo:10:002:2 0 31>
>> ffff8801f36c6a80 4253708841 S Bi:10:002:1 -115 512<
>> ffff8801f36c6a80 4253714580 C Bi:10:002:1 0 512 Z
>> ffff8802123996c0 4253714599 S Bi:10:002:1 -115 13<
>> ffff8802123996c0 4253714639 C Bi:10:002:1 0 13 = 55534253 9c000000
>> 00000000 00
>
> And it apparently succeeded.  It's not clear why hdparm reports "bad
> response".  Maybe it just doesn't like the data returned by the device.
>
>> ffff8802123996c0 4253714778 S Bo:10:002:2 -115 31 = 55534243 9d000000
>> 00020000 80001085 082e0000 00010000 00000000 40a100
>
> That's the second command, now presumably specifying a sector count of
> 1.
>
>> ffff8802123996c0 4253714813 C Bo:10:002:2 0 31>
>> ffff8801f36c6a80 4253714823 S Bi:10:002:1 -115 512<
>> ffff8801f36c6a80 4253715081 C Bi:10:002:1 -32 0
>> ffff8802123996c0 4253715119 S Co:10:002:0 s 02 01 0000 0081 0000 0
>> ffff8802123996c0 4253715383 C Co:10:002:0 0 0
>> ffff8802123996c0 4253715406 S Bi:10:002:1 -115 13<
>> ffff8802123996c0 4253715648 C Bi:10:002:1 0 13 = 55534253 9d000000
>> 00020000 01
>
> It failed.  But unlike your earlier experience, it didn't get a
> transport error.  A failure is more benign than an error; in particular
> it doesn't call for a reset.
>
>> ffff8802123996c0 4253715661 S Bo:10:002:2 -115 31 = 55534243 9e000000
>> 60000000 80000603 00000060 00000000 00000000 000000
>> ffff8802123996c0 4253715707 C Bo:10:002:2 0 31>
>> ffff8801f36c6a80 4253715723 S Bi:10:002:1 -115 96<
>> ffff8801f36c6a80 4253715763 C Bi:10:002:1 0 96 Z
>> ffff8802123996c0 4253715779 S Bi:10:002:1 -115 13<
>> ffff8802123996c0 4253715819 C Bi:10:002:1 0 13 = 55534253 9e000000
>> 00000000 00
>
> Here usb-storage asked the reason for the failure.  Unfortunately we
> can't see the response.  Did you run this on a computer with more than
> 1 GB of memory?  If you did, can you boot with "mem=900M" and try
> again?
>
>> ffff8802123996c0 4253717330 S Bo:10:002:2 -115 31 = 55534243 9f000000
>> 00100000 80000a28 00000000 00000008 00000000 000000
>> ffff8802123996c0 4253717373 C Bo:10:002:2 0 31>
>> ffff880211ace240 4253717386 S Bi:10:002:1 -115 4096<
>> ffff880211ace240 4253731794 C Bi:10:002:1 0 4096 Z
>> ffff8802123996c0 4253731815 S Bi:10:002:1 -115 13<
>> ffff8802123996c0 4253731854 C Bi:10:002:1 0 13 = 55534253 9f000000
>> 00000000 00
>
> This is a standard READ(10) command, asking for the first 8 sectors on
> the disk.  It succeeded.
>
> Alan Stern

I'll have a look at this stuff next week, after the Easter holiday.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
