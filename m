From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Kernel crash with unsupported DIF protection type
Date: Tue, 18 Sep 2012 12:20:42 +0200
Message-ID: <50584AFA.2020801@interlog.com>
References: <50583924.90708@suse.de> <50583F32.1010103@interlog.com> <50584067.2010505@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:47424 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757869Ab2IRKUo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2012 06:20:44 -0400
In-Reply-To: <50584067.2010505@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 12-09-18 11:35 AM, Hannes Reinecke wrote:
> On 09/18/2012 11:30 AM, Douglas Gilbert wrote:
>> On 12-09-18 11:04 AM, Hannes Reinecke wrote:
>>> Hi all,
>>>
>>> I recently got my hands on some weird drives, insisting on having
>>> been formatted with protection type 7:
>>>
>>> # sg_readcap --16 /dev/sdb
>>> Read Capacity results:
>>>      Protection: prot_en=1, p_type=6, p_i_exponent=0
>>>      Logical block provisioning: lbpme=0, lbprz=0
>>>      Last logical block address=1758174767 (0x68cb9e2f), Number of
>>> logical blocks=1758174768
>>>      Logical block length=512 bytes
>>>      Logical blocks per physical block exponent=0
>>>      Lowest aligned logical block address=0
>>> Hence:
>>>      Device size: 900185481216 bytes, 858483.8 MiB, 900.19 GB
>>>
>>> (I know. I've already complained.)
>>> However, this drive causes a horrible crash:
>>>
>>> sd 0:0:1:0: [sdb] formatted with unsupported protection type 7.
>>> Disabling disk!
>>> sd 0:0:1:0: [sdb] 1758174768 512-byte logical blocks: (900
>>> GB/838 GiB)
>>> sd 0:0:1:0: [sdb]  Result: hostbyte=DID_OK
>>> driverbyte=DRIVER_SENSE
>>> sd 0:0:1:0: [sdb]  Sense Key : Medium Error [current]
>>> sd 0:0:1:0: [sdb]  Add. Sense: Medium format corrupted
>>> sd 0:0:1:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
>>> end_request: I/O error, dev sdb, sector 0
>>> Buffer I/O error on device sdb, logical block 0
>>>
>>> [ tons and tons of I/O errors ]
>>>
>>> [   15.551689] sd 0:0:1:0: [sdb] Enabling DIX T10-DIF-TYPE1-CRC
>>> protection
>>> [   15.561353] ------------[ cut here ]------------
>>> [   15.569416] kernel BUG at
>>> /usr/src/linux-3.0/drivers/scsi/scsi_lib.c:1069!
>>>
>>> There are several odd things happening here:
>>> - It says 'Disabling disk', which _should_ have set the
>>>     capacity to '0':
>>>
>>> drivers/scsi/sd.c:sd_read_protection_type()
>>>      if (type > SD_DIF_TYPE3_PROTECTION) {
>>>          sd_printk(KERN_ERR, sdkp, "formatted with unsupported "    \
>>>                "protection type %u. Disabling disk!\n", type);
>>>          sdkp->capacity = 0;
>>>          return;
>>>      }
>>>
>>> - it enables type 1 protection, which it evidently is not.
>>>
>>> I've attached a tentative patch, which allows the system to boot.
>>> However, I'm not completely happy with that, as the capacity is
>>> _still_ updated after revalidation:
>>>
>>> sd 0:0:1:0: [sdb] formatted with unsupported protection type 7.
>>> Disabling disk!
>>> sd 0:0:1:0: [sdb] 0 512-byte logical blocks: (0 B/0 B)
>>> sd 0:0:1:0: [sdb] Write Protect is off
>>> sd 0:0:1:0: [sdb] Mode Sense: cf 00 10 08
>>> sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled,
>>> supports DPO and FUA
>>> sd 0:0:1:0: [sdb] 1758174768 512-byte logical blocks: (900 GB/838
>>> GiB)
>>> sd 0:0:1:0: [sdb] Attached SCSI disk
>>>
>>> Thoughts?
>>
>> The "Medium format corrupted" additional sense qualifier occurs
>> (with Seagate disks) when a FORMAT UNIT command is interrupted.
>> So maybe, for good measure, that disk also sets the DIF
>> protection type to an unsupported value (i.e. 7). So re-doing a
>> FORMAT  UNIT may clear that state.
>>
> Yeah, that's what I'm doing now.
>
> Incidentally:
>
> sg_format manpage says:
>
>         Format with type 1 protection:
>
>            sg_format --format --fmtpinfo=3 --pfu /dev/sdm
>
> but the '--pfu' option requires an argument.
> According to sbc3r23 the command should read:
>
> sg_format --format --fmtpinfo=3 --pfu=1 /dev/sdm
>
> Correct?

Yes. And it is corrected in the 1.34 betas that I have
sent you :-)


I placed a copy of my latest sg3_utils-1.34 beta
in the News section at the top of this page:
   http://sg.danny.cz/sg

Doug Gilbert


