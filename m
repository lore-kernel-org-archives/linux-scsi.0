From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH] scsi: sr: fix oob access in get_capabilities
Date: Thu, 16 Mar 2017 13:21:01 +0800
Message-ID: <3f08ece0-531e-6853-d47d-a860e81e55d6@huawei.com>
References: <1488536272-10509-1-git-send-email-wangkefeng.wang@huawei.com>
 <yq1r31yf5ie.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1r31yf5ie.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 2017/3/16 8:07, Martin K. Petersen wrote:
> Kefeng Wang <wangkefeng.wang@huawei.com> writes:
> 
> Kefeng,
> 
>> 'n = header_length + block_descriptor_length' could be greater than 512,
>> and will lead to oob access, so enlarge transfer buffer to fix it.
> 
> Can you share the output of sg_modes -p 0x2a /dev/srN for the offending
> drive?


root@localhost ~]# sg_modes -p 0x2a /dev/sr0
    QEMU      QEMU DVD-ROM      0.15   peripheral_type: cd/dvd [0x5]
Mode parameter header from MODE SENSE(10):
Invalid block descriptor length=512, ignore
  Mode data length=36, medium type=0x70, specific param=0x00, longlba=0
  Block descriptor length=0
>> MM capabilities and mechanical status (obsolete), page_control: current
 00     2a 12 00 00 71 60 29 00  02 c2 00 02 02 00 02 c2
 10     00 00 00 00
Unexpectedly received extra mode page responses, ignore

note: the issue was found in guestos?  maybe some bugs exist in qemu?

Kefeng

> 
> This mode page is usually much smaller than 512 bytes (typically between
> 32 and 128 bytes).
> 
