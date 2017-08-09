From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v3 03/13] mpt3sas: SGL to PRP Translation for I/Os to NVMe devices
Date: Wed, 9 Aug 2017 18:07:13 +0530
Message-ID: <CA+RiK65ccL8tMKhpyW=ZPRnSX2tetNhHJMnGzn2P=oBbK1LU4w@mail.gmail.com>
References: <1502183035-7441-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1502183035-7441-4-git-send-email-suganath-prabu.subramani@broadcom.com> <yq1o9rq6ntu.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1o9rq6ntu.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "JBottomley@Parallels.com" <JBottomley@parallels.com>, jejb@kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, linux-kernel@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Hi Martin,
This code was added to detect holes, when we started testing with 4.9
kernel. when we disabled "use_blk_mq" and no merges, we are hitting
issues with holes. Anyhow In latest upstream, it got fixed with this
commit 5a8d75a1b8c99bdc926ba69b7b7dbe4fae81a5af

So we are removing the code related to hole detection .

Thanks,
Suganath Prabu S



On Tue, Aug 8, 2017 at 9:42 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Suganath,
>
>> +     /*
>> +      ** Below code detects gaps/holes in IO data buffers.
>> +      ** What does holes/gaps mean?
>> +      ** Any SGE except first one in a SGL starts at non NVME page size
>> +      ** aligned address OR Any SGE except last one in a SGL ends at
>> +      ** non NVME page size boundary.
>> +      **
>> +      ** Driver has already informed block layer by setting boundary rules
>> +      ** for bio merging done at NVME page size boundary calling kernel API
>> +      ** blk_queue_virt_boundary inside slave_config.
>> +      ** Still there is possibility of IO coming with holes to driver because
>> +      ** of IO merging done by IO scheduler.
>
> All this SGL to PRP code needs to go.
>
> If you are seeing anything that's not a valid PRP after setting the
> queue virt boundary then there's a block layer bug that needs to be
> debugged and fixed. Regardless of whether you are using an I/O scheduler
> or not.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
