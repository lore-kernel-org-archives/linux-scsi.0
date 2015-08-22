From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 7/8] scsi: ufs-qcom: add debug prints for test bus
Date: Sat, 22 Aug 2015 11:56:14 +0900
Message-ID: <CAC5umyj8i2N3Xzdqye2mQY3WF5MbpEm61LjO0HYMk-mvbUnL7A@mail.gmail.com>
References: <1440079144-26461-1-git-send-email-ygardi@codeaurora.org>
	<1440079144-26461-8-git-send-email-ygardi@codeaurora.org>
	<CAC5umyhRBDW0OxmDiw9TMHNm-kz1f_wcE0iZ3dY=MkfnMywUNw@mail.gmail.com>
	<545cd2cdf947a2a59f5d021c27bdc78f.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <545cd2cdf947a2a59f5d021c27bdc78f.squirrel@www.codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Jej B <james.bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-08-22 7:23 GMT+09:00  <ygardi@codeaurora.org>:
>> 2015-08-20 22:59 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
>>> @@ -30,6 +48,14 @@ static void ufs_qcom_get_speed_mode(struct
>>> ufs_pa_layer_attr *p, char *result);
>>>  static int ufs_qcom_get_bus_vote(struct ufs_qcom_host *host,
>>>                 const char *speed_mode);
>>>  static int ufs_qcom_set_bus_vote(struct ufs_qcom_host *host, int vote);
>>> +static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host
>>> *host);
>>> +static void ufs_qcom_dump_regs(struct ufs_hba *hba, int offset, int
>>> len,
>>> +               char *prefix)
>>> +{
>>> +       print_hex_dump(KERN_ERR, prefix,
>>> +                       len > 4 ? DUMP_PREFIX_OFFSET : DUMP_PREFIX_NONE,
>>> +                       16, 4, hba->mmio_base + offset, len * 4, false);
>>> +}
>>
>> This causes a sparse warning as __iomem pointer is passed to
>> print_hex_dump().
>
> indeed.
> any suggestions how it can be fixed ? I guess I shall try casting.

I think introducing generic print_hex_dump_io() library function
is useful for this and other drivers want to use it.  But for now we can just
create simple local dump function which readl() and print for each register.
