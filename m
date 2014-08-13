From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: [RFC PATCH 01/10] scsi/constants: Cleanup printk message in __scsi_print_sense()
Date: Wed, 13 Aug 2014 12:14:37 +0900
Message-ID: <53EAD81D.9010609@hitachi.com>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115006.6768.5118.stgit@yuno-kbuild.novalocal> <94D0CD8314A33A4D9D801C0FE68B402958BE5A76@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958BE5A76@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi Elliot,

Thank you for your comment.

(2014/08/12 23:51), Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Yoshihiro YUNOMAE
>> Sent: Friday, 08 August, 2014 6:50 AM
> ...
>> Subject: [RFC PATCH 01/10] scsi/constants: Cleanup printk message in
>> __scsi_print_sense()
>>
>> A device name is output like "sda: Sense Key : Medium Error [current]"
>> in __scsi_print_sense(), but it should be "[sda] Sense Key : Medium Error
>> [current]" because other printk messages output a device name like "[sda]
>> foo."
>>
> ...
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index c6a7a4a..a0e8159 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -1470,7 +1470,7 @@ void __scsi_print_sense(struct scsi_device *sdev,
>> const char *name,
>>   		return;
>>   	}
>>
>> -	sdev_printk(KERN_INFO, sdev, "%s: Sense Key : %s %s%s\n", name,
>> +	sdev_printk(KERN_INFO, sdev, "[%s] Sense Key : %s %s%s\n", name,
>>   	       scsi_sense_key_string(sshdr.sense_key),
>>   	       scsi_sense_type_string(&sshdr),
>>   	       scsi_sense_format_string(&sshdr));
>>
>
>
> The callers of __scsi_print_sense do not always pass in a name
> like "sda".  In fact, sd.c doesn't even call that function; its
> sd_print_sense_hdr calls sd_printk (which prints name as "[%s]")
> and scsi_show_sense_hdr.

OK, I understood.
Current Linux kernel also outputs "<name>:" in __scsi_print_sense(),
so we should not change this.

Thanks,
Yoshihiro YUNOMOAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
