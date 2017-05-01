From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH v6 1/2] tcmu: Add dynamic growing data area featuresupport
Date: Mon, 1 May 2017 13:37:41 -0500
Message-ID: <59078075.3090309@redhat.com>
References: <1493187952-13125-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1493187952-13125-2-git-send-email-lixiubo@cmss.chinamobile.com>
 <59057AC0.2090804@redhat.com>
 <5f6a28f7-62ab-1096-625c-c42db78af99d@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5f6a28f7-62ab-1096-625c-c42db78af99d@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: Xiubo Li <lixiubo@cmss.chinamobile.com>, nab@linux-iscsi.org
Cc: agrover@redhat.com, iliastsi@arrikto.com, namei.unix@gmail.com, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

On 04/30/2017 05:22 AM, Xiubo Li wrote:
> On 2017年04月30日 13:48, Mike Christie wrote:
>> On 04/26/2017 01:25 AM, lixiubo@cmss.chinamobile.com wrote:
>>>       for_each_sg(data_sg, sg, data_nents, i) {
>>> @@ -275,22 +371,26 @@ static void alloc_and_scatter_data_area(struct
>>> tcmu_dev *udev,
>>>           from = kmap_atomic(sg_page(sg)) + sg->offset;
>>>           while (sg_remaining > 0) {
>>>               if (block_remaining == 0) {
>>> -                block = find_first_zero_bit(udev->data_bitmap,
>>> -                        DATA_BLOCK_BITS);
>>>                   block_remaining = DATA_BLOCK_SIZE;
>>> -                set_bit(block, udev->data_bitmap);
>>> +                dbi = tcmu_get_empty_block(udev, &to);
>>> +                if (dbi < 0)
>>
>> I know it you fixed the missing kunmap_atomic here and missing unlock in
>> tcmu_queue_cmd_ring in the next patch, but I think normally people
>> prefer that one patch does not add a bug, then the next patch fixes it.
> Do you mean the following kmap_atomic() ?
> 
> from = kmap_atomic(sg_page(sg)) + sg->offset;
> 
> In this patch there has no new kmap/kunmap introduced. This is the old
> code and
> the kunmap is at the end of aasda().

You added a new return in the error path in this patch in the if case
above, but did not add a kunmap_atomic.
