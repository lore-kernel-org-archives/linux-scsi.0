From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/2] [SCSI] a3000: use module_platform_driver_probe()
Date: Tue, 5 Mar 2013 21:43:31 +0100
Message-ID: <CAMuHMdUx1jHiOQRSoEDtbhPrLzrp3x7u-BCgL3bdhn5MDydhYQ@mail.gmail.com>
References: <005601ce1953$5b83b020$128b1060$%han@samsung.com>
	<005701ce1953$77188a40$65499ec0$%han@samsung.com>
	<1362474522.22821.8.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:52740 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3CEUnc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Mar 2013 15:43:32 -0500
Received: by mail-ie0-f180.google.com with SMTP id bn7so8250863ieb.25
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2013 12:43:31 -0800 (PST)
In-Reply-To: <1362474522.22821.8.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-scsi@vger.kernel.org

On Tue, Mar 5, 2013 at 10:08 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2013-03-05 at 12:42 +0900, Jingoo Han wrote:
>> This patch uses module_platform_driver_probe() macro which makes
>> the code smaller and simpler.
>
> These drivers are in deep maintenance mode.  Unless you can find someone
> to actually test the changes, we err on the side of not touching the
> code except for serious bugs.
>
> I've cc'd Geert because he may actually have one of these things.

I don't have one, but there are A3000s in active use as Debian build daemons.

>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

>> ---
>>  drivers/scsi/a3000.c |   13 +------------
>>  1 files changed, 1 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
>> index e29fe0e..519832d 100644
>> --- a/drivers/scsi/a3000.c
>> +++ b/drivers/scsi/a3000.c
>> @@ -279,18 +279,7 @@ static struct platform_driver
>> amiga_a3000_scsi_driver = {
>>         },
>>  };
>>
>> -static int __init amiga_a3000_scsi_init(void)
>> -{
>> -       return platform_driver_probe(&amiga_a3000_scsi_driver,
>> -                                    amiga_a3000_scsi_probe);
>> -}
>> -module_init(amiga_a3000_scsi_init);
>> -
>> -static void __exit amiga_a3000_scsi_exit(void)
>> -{
>> -       platform_driver_unregister(&amiga_a3000_scsi_driver);
>> -}
>> -module_exit(amiga_a3000_scsi_exit);
>> +module_platform_driver_probe(amiga_a3000_scsi_driver,
>> amiga_a3000_scsi_probe);
>>
>>  MODULE_DESCRIPTION("Amiga 3000 built-in SCSI");
>>  MODULE_LICENSE("GPL");

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
