From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 2/2] sd: disable write same for SAT as per the comment
Date: Sat, 27 Feb 2016 04:32:39 +0800
Message-ID: <CAGnHSE=8d2=b3nN=0f14t_5Nf_GLsb0HXYeajZtz5As8SophsA@mail.gmail.com>
References: <56d0b08c.e99c420a.dbca1.0415@mx.google.com>
	<1456517794.2369.43.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f193.google.com ([209.85.160.193]:35928 "EHLO
	mail-yk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbcBZUck (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2016 15:32:40 -0500
Received: by mail-yk0-f193.google.com with SMTP id z13so2478907ykd.3
        for <linux-scsi@vger.kernel.org>; Fri, 26 Feb 2016 12:32:40 -0800 (PST)
In-Reply-To: <1456517794.2369.43.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Oh I made a mistake on this one then.

Since I send it with another patch, should I resend that alone?

On 27 February 2016 at 04:16, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Sat, 2016-02-27 at 04:07 +0800, tom.ty89@gmail.com wrote:
>> From: Tom Yan <tom.ty89@gmail.com>
>>
>> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 1179ec1..9eeee51 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -2786,7 +2786,7 @@ static void sd_read_write_same(struct scsi_disk
>> *sdkp, unsigned char *buffer)
>>                * CODES is unsupported and the device has an ATA
>>                * Information VPD page (SAT).
>>                */
>> -             if (!scsi_get_vpd_page(sdev, 0x89, buffer,
>> vpd_buf_len))
>> +             if (scsi_get_vpd_page(sdev, 0x89, buffer,
>> vpd_buf_len))
>>                       sdev->no_write_same = 1;
>>       }
>
>
> If you're inverting the condition, you'd need to invert the comment as
> well.  scsi_get_vpd_page returns 0 on success so !scsi_get_vpd_page is
> true if it got the page (which is what the comment says).
>
> James
>
