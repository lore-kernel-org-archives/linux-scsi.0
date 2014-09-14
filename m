From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH] scsi: scsi_devinfo.c: Cleaning up unnecessarily
 complicated in conjunction with strncpy
Date: Mon, 15 Sep 2014 00:13:31 +0200
Message-ID: <CAFo99gbtGfEgcWukEQoEmcTro__aGND6-4bb4Ms+cV8Wu1FM4w@mail.gmail.com>
References: <1410727738-17430-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <94D0CD8314A33A4D9D801C0FE68B402958C7A75B@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C7A75B@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

2014-09-14 23:34 GMT+02:00 Elliott, Robert (Server Storage) <Elliott@hp.com>:
>
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Rickard Strandqvist
> ...
>> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> ...
>>  static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
>>                               char *from, int compatible)
>>  {
>> -     size_t from_length;
>> -
>> -     from_length = strlen(from);
>> -     strncpy(to, from, min(to_length, from_length));
>> -     if (from_length < to_length) {
>> -             if (compatible) {
>> -                     /*
>> -                      * NUL terminate the string if it is short.
>> -                      */
>> -                     to[from_length] = '\0';
>> -             } else {
>> -                     /*
>> -                      * space pad the string if it is short.
>> -                      */
>> -                     strncpy(&to[from_length], spaces,
>> -                             to_length - from_length);
>> -             }
>> -     }
>> -     if (from_length > to_length)
>> -              printk(KERN_WARNING "%s: %s string '%s' is too long\n",
>> +     strncpy(to, from, to_length);
>> +     if (to[to_length - 1] != '\0') {
>> +             to[to_length - 1] = '\0';
>> +             printk(KERN_WARNING "%s: %s string '%s' is too long\n",
>>                       __func__, name, from);
>> +     }
>
> The caller of this function, scsi_dev_info_list_add_keyed, created
> the "to" destination buffer, devinfo, with kmalloc, so it's not
> guaranteed to be full of zeros.
>
> If from_length is shorter than to_length, then this code will
> be inspecting an uninitialized character that strncpy didn't
> touch.
>
> ---
> Rob Elliott    HP Server Storage
>

Hi Elliott

How do you mean?

strncpy zeroes throughout the remainder of the string "from" until the
length off to_length, or otherwise guaranteed trailing zero characters
and a warning is printed.

Is not it exactly the functionality that is desired?

Kind regards
Rickard Strandqvist
