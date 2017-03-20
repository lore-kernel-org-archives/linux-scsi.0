From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: libsas: fix ata xfer length
Date: Mon, 20 Mar 2017 08:59:40 +0000
Message-ID: <f5d6b941-f981-b05f-6266-9364878e135f@huawei.com>
References: <1489676848-103256-1-git-send-email-john.garry@huawei.com>
 <yq160j5ji6n.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq160j5ji6n.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 19/03/2017 17:21, Martin K. Petersen wrote:
> John Garry <john.garry@huawei.com> writes:
>
> John,
>
>> The total ata xfer length may not be calculated properly,
>> in that we do not use the proper method to get an sg element
>> dma length.
>>
>> According to the code comment, sg_dma_len() should be used
>> after dma_map_sg() is called.
>>
>> This issue was found by turning on the SMMUv3 in front of
>> the hisi_sas controller in hip07. Multiple sg elements
>> were being combined into a single element, but the original
>> first element length was being use as the total xfer length.
>

I should have added this originally to the changelog:
Fixes: ff2aeb1eb64c8a4770a6 ("libata: convert to chained sg")

BTW, I am surprised this issue has not been seen in almost 10 years, but 
we cannot attach a SATA disk when SMMU enabled without it.

Cheers,
John

> Applied to 4.11/scsi-fixes.
>
