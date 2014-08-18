From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: Re: [RFC PATCH 04/10] scsi/constants: Cleanup printk message
 in scsi_dump_sense_buffer()
Date: Mon, 18 Aug 2014 14:06:34 +0900
Message-ID: <53F189DA.1040802@hitachi.com>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>  <20140808115014.6768.44632.stgit@yuno-kbuild.novalocal> <1408115326.1223.147.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1408115326.1223.147.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: emilne@redhat.com
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

(2014/08/16 0:08), Ewan Milne wrote:
> On Fri, 2014-08-08 at 11:50 +0000, Yoshihiro YUNOMAE wrote:
>> Unrecognized sense data should be output after linebuf is filled because
>> "[%s] Unrecognized sense data (in hex): %s" message is output many times in
>> loop.
>>
>> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Doug Gilbert <dgilbert@interlog.com>
>> Cc: Martin K. Petersen <martin.petersen@oracle.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>> Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> ---
>>   drivers/scsi/constants.c |   13 +++++--------
>>   1 file changed, 5 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index 5956d4d..6fad6b4 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -1385,16 +1385,13 @@ EXPORT_SYMBOL(scsi_print_sense_hdr);
>>
>>   static void
>>   scsi_dump_sense_buffer(struct scsi_device *sdev, const char *prefix,
>> -		       const unsigned char *sense_buffer, int sense_len,
>> -		       struct scsi_sense_hdr *sshdr)
>> +		       const unsigned char *sense_buffer, int sense_len)
>>   {
>>   	char linebuf[128];
>>   	int i, linelen, remaining;
>>
>>   	if (sense_len < 32)
>>   		sense_len = 32;
>> -	sdev_printk(KERN_INFO, sdev,
>> -		    "[%s] Unrecognized sense data (in hex):", prefix);
>>
>>   	remaining = sense_len;
>>   	for (i = 0; i < sense_len; i += 16) {
>> @@ -1403,9 +1400,10 @@ scsi_dump_sense_buffer(struct scsi_device *sdev, const char *prefix,
>>
>>   		hex_dump_to_buffer(sense_buffer + i, linelen, 16, 1,
>>   				   linebuf, sizeof(linebuf), false);
>> -		sdev_printk(KERN_INFO, sdev, "[%s] Sense: %s\n",
>> -			    prefix, linebuf);
>>   	}
>> +	sdev_printk(KERN_INFO, sdev,
>> +		    "[%s] Unrecognized sense data (in hex): %s",
>> +		    prefix, linebuf);
>>   }
>
> See my earlier comment regarding PATCH 03/10.
>
> This doesn't look right -- In Hannes' tree what the code is doing is
> printing out a separate line for each 16 bytes of the sense data.
> Your change will cause only the last (partial?) 16 bytes to be printed.

That's true. We should not apply this as well.

> The removal of the unused sshdr argument is fine, though.

Thanks!

Yoshihiro YUNOMAE

> -Ewan
>
>>
>>   static void
>> @@ -1467,8 +1465,7 @@ void __scsi_print_sense(struct scsi_device *sdev, const char *name,
>>
>>   	if (!scsi_normalize_sense(sense_buffer, sense_len, &sshdr)) {
>>   		/* this may be SCSI-1 sense data */
>> -		scsi_dump_sense_buffer(sdev, name, sense_buffer,
>> -				       sense_len, &sshdr);
>> +		scsi_dump_sense_buffer(sdev, name, sense_buffer, sense_len);
>>   		return;
>>   	}
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
