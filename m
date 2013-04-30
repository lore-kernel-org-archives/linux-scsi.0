From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 2/5] scsi: ufs: wrap the i/o access operations
Date: Tue, 30 Apr 2013 16:53:22 +0530
Message-ID: <517FA9AA.1060101@codeaurora.org>
References: <002001ce4105$afbcf000$0f36d000$%jun@samsung.com> <5178B5C9.90000@codeaurora.org> <000b01ce423b$d626e520$8274af60$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57730 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760004Ab3D3LX0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Apr 2013 07:23:26 -0400
In-Reply-To: <000b01ce423b$d626e520$8274af60$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On 4/26/2013 10:36 AM, Seungwon Jeon wrote:
> Hi,
>
> On Thursday, April 25, 2013, Sujit Reddy Thumma wrote:
>> On 4/24/2013 9:36 PM, Seungwon Jeon wrote:
>>> Simplify operations with hiding mmio_base.
>>>
>>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
>>> ---
>>>    drivers/scsi/ufs/ufshcd.c |  106 +++++++++++++++++++--------------------------
>>>    drivers/scsi/ufs/ufshcd.h |    5 ++
>>>    2 files changed, 49 insertions(+), 62 deletions(-)
>>>
>>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>>> index 1680394..6728450 100644
>>> --- a/drivers/scsi/ufs/ufshcd.h
>>> +++ b/drivers/scsi/ufs/ufshcd.h
>>> @@ -190,4 +190,9 @@ int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
>>>    			unsigned int);
>>>    void ufshcd_remove(struct ufs_hba *);
>>>
>>> +#define ufshcd_writel(hba, reg, val)	\
>> Let this be consistent with writel() arguments - "val" as second arg and
>> "reg" as third?
> You got a point there.
> When considering an array of arguments in two functions and value part can be some long expression,
> I think it seems more coherent.
> 	ufshcd_readl(hba, reg);
> 	ufshcd_writel(hba, reg, val);
> How about keeping these?

I somehow tend to agree with what Sujit suggested. Its good to be 
consitent with writel() for better code readability.

>
> Thanks,
> Seungwon Jeon
>
>>> +	writel((val), (hba)->mmio_base + (reg))
>>> +#define ufshcd_readl(hba, reg)	\
>>> +	readl((hba)->mmio_base + (reg))
>>> +
>>>    #endif /* End of Header */
>>>
>> --
>> Regards,
>> Sujit
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

