From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH] scsi: sr: fix oob access in get_capabilities
Date: Mon, 20 Mar 2017 14:00:17 +0800
Message-ID: <0d4c496b-c435-b622-58f8-25bd4490186a@huawei.com>
References: <1488536272-10509-1-git-send-email-wangkefeng.wang@huawei.com>
 <yq1r31yf5ie.fsf@oracle.com>
 <3f08ece0-531e-6853-d47d-a860e81e55d6@huawei.com>
 <yq160j7lbx1.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq160j7lbx1.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org



On 2017/3/18 7:29, Martin K. Petersen wrote:
> Kefeng Wang <wangkefeng.wang@huawei.com> writes:
> 
> Kefeng,
> 
>> root@localhost ~]# sg_modes -p 0x2a /dev/sr0
>>     QEMU      QEMU DVD-ROM      0.15   peripheral_type: cd/dvd [0x5]
>> Mode parameter header from MODE SENSE(10):
>> Invalid block descriptor length=512, ignore
>>   Mode data length=36, medium type=0x70, specific param=0x00, longlba=0
>>   Block descriptor length=0
>>>> MM capabilities and mechanical status (obsolete), page_control: current
>>  00     2a 12 00 00 71 60 29 00  02 c2 00 02 02 00 02 c2
>>  10     00 00 00 00
>> Unexpectedly received extra mode page responses, ignore
> 
> That looks pretty broken.
> 
> Could you try the following patch?

The issue still exists, the patch return zero in scsi_mode_sense(), but zero means
SAM_STAT_GOOD in scsi_status_is_good(), so n will be still bigger than 512;

Thanks,
