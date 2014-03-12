From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 2/5] scsi: Return VPD page length in scsi_vpd_inquiry()
Date: Wed, 12 Mar 2014 22:43:41 +0100
Message-ID: <5320D50D.1090803@interlog.com>
References: <1394461725-76203-1-git-send-email-hare@suse.de>	<1394461725-76203-3-git-send-email-hare@suse.de> <CAFR8ueeATrBwSMg_dmA2gY-Bt2D2+F8rR5zmDbN1ZC3Aw5bJMw@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33091 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbaCLVnq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2014 17:43:46 -0400
In-Reply-To: <CAFR8ueeATrBwSMg_dmA2gY-Bt2D2+F8rR5zmDbN1ZC3Aw5bJMw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muthukumar R <muthu.lkml@gmail.com>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Bart van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 14-03-12 10:14 PM, Muthukumar R wrote:
> On Mon, Mar 10, 2014 at 7:28 AM, Hannes Reinecke <hare@suse.de> wrote:
>> We should be returning the number of bytes of the
>> requested VPD page in scsi_vpd_inquiry.
>> This makes it easier for the caller to verify the
>> required space.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/scsi.c | 17 ++++++++++-------
>>   1 file changed, 10 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index d8afec8..ecaeff1 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -954,7 +954,7 @@ EXPORT_SYMBOL(scsi_track_queue_full);
>>    * This is an internal helper function.  You probably want to use
>>    * scsi_get_vpd_page instead.
>>    *
>> - * Returns 0 on success or a negative error number.
>> + * Returns size of the vpg page on success or a negative error number.
>>    */
> Typo:                              ^^^
>
>   Should be: vpd page
>
>
>>   static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
>>                                                          u8 page, unsigned len)
>> @@ -962,6 +962,9 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
>>          int result;
>>          unsigned char cmd[16];
>>
>> +       if (len < 4)
>> +               return -EINVAL;
>> +
>>          cmd[0] = INQUIRY;
>>          cmd[1] = 1;             /* EVPD */
>>          cmd[2] = page;
>> @@ -982,7 +985,7 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
>>          if (buffer[1] != page)
>>                  return -EIO;
>>
>> -       return 0;
>> +       return get_unaligned_be16(&buffer[2]) + 4;
>>   }
>>
>>   /**
>> @@ -1009,18 +1012,18 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
>>
>>          /* Ask for all the pages supported by this device */
>>          result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
>> -       if (result)
>> +       if (result < 4)
>>                  goto fail;
>
>
> You mean:
>
>              if (result < 0)
>                     goto fail;

I think that he means:
      if (result < 4)
           goto fail;

The first 4 bytes of a VPD page are a header with buf[2] and
buf[3] being the length of the following payload. Without
both of them "fail" is a quite accurate description.

That said, it is hard to get a number between 0 and 3 with:
    return get_unaligned_be16(&buffer[2]) + 4;
but if you wanted to take resid into account it is possible.

IMO this snippet is fine.


Doug Gilbert




