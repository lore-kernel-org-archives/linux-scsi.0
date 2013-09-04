From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: Potential out-of-bounds access in drivers/scsi/sd.c
Date: Wed, 4 Sep 2013 19:37:54 +0400
Message-ID: <CACT4Y+Zose3b8xrmwYbpNfPAqiJtuS9w3Y61==kaOd_LHK6uMg@mail.gmail.com>
References: <CACT4Y+bt9weet_0DxfX3s=_xnxBGZjMG0gF7vea+8psov+ky8w@mail.gmail.com>
 <Pine.LNX.4.44L0.1309041030420.1186-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:53321 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762833Ab3IDPiQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2013 11:38:16 -0400
Received: by mail-ie0-f178.google.com with SMTP id f4so1015840iea.9
        for <linux-scsi@vger.kernel.org>; Wed, 04 Sep 2013 08:38:15 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.1309041030420.1186-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, richard <richard@r-senior.demon.co.uk>, ltuikov <ltuikov@yahoo.com>, jbottomley <jbottomley@parallels.com>, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>

On Wed, Sep 4, 2013 at 6:32 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 4 Sep 2013, Dmitry Vyukov wrote:
>
>> Hi,
>>
>> We are working on a memory error detector AddressSanitizer for Linux
>> kernel (https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel),
>> it can detect use-after-free and buffer-overflow errors.
>
> ...
>
>> The code in sd_read_cache_type does the following:
>>
>> while (offset < len) {
>> ...
>> }
>> ...
>> if ((buffer[offset] & 0x3f) != modepage) {
>>     sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
>>     goto defaults;
>> }
>>
>> When control leaves the while loop, offset >= len, so buffer[offset]
>> reads random garbage out-of-bounds.
>> It the worst case it can lead to crash, or if (buffer[offset] & 0x3f)
>> happen to be == modepage, then it will read more garbage.
>>
>> Please help validate and triage this.
>
> The tool's output is correct.  The patch below should fix it.

Thanks, Alan!

I agree with Paolo that the branch can be removed.

Will you take care of landing the patch?



> Index: usb-3.11/drivers/scsi/sd.c
> ===================================================================
> --- usb-3.11.orig/drivers/scsi/sd.c
> +++ usb-3.11/drivers/scsi/sd.c
> @@ -2419,7 +2419,7 @@ sd_read_cache_type(struct scsi_disk *sdk
>                         }
>                 }
>
> -               if (modepage == 0x3F) {
> +               if (modepage == 0x3F || offset + 2 >= len) {
>                         sd_printk(KERN_ERR, sdkp, "No Caching mode page "
>                                   "present\n");
>                         goto defaults;
>
