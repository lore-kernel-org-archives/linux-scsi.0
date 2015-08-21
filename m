From: ygardi@codeaurora.org
Subject: Re: [PATCH v2 7/8] scsi: ufs-qcom: add debug prints for test bus
Date: Fri, 21 Aug 2015 22:23:30 -0000
Message-ID: <545cd2cdf947a2a59f5d021c27bdc78f.squirrel@www.codeaurora.org>
References: <1440079144-26461-1-git-send-email-ygardi@codeaurora.org>
    <1440079144-26461-8-git-send-email-ygardi@codeaurora.org>
    <CAC5umyhRBDW0OxmDiw9TMHNm-kz1f_wcE0iZ3dY=MkfnMywUNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAC5umyhRBDW0OxmDiw9TMHNm-kz1f_wcE0iZ3dY=MkfnMywUNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Rob Herring <robherring2@gmail.com>, Jej B <james.bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

> 2015-08-20 22:59 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
>> @@ -30,6 +48,14 @@ static void ufs_qcom_get_speed_mode(struct
>> ufs_pa_layer_attr *p, char *result);
>>  static int ufs_qcom_get_bus_vote(struct ufs_qcom_host *host,
>>                 const char *speed_mode);
>>  static int ufs_qcom_set_bus_vote(struct ufs_qcom_host *host, int vote);
>> +static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host
>> *host);
>> +static void ufs_qcom_dump_regs(struct ufs_hba *hba, int offset, int
>> len,
>> +               char *prefix)
>> +{
>> +       print_hex_dump(KERN_ERR, prefix,
>> +                       len > 4 ? DUMP_PREFIX_OFFSET : DUMP_PREFIX_NONE,
>> +                       16, 4, hba->mmio_base + offset, len * 4, false);
>> +}
>
> This causes a sparse warning as __iomem pointer is passed to
> print_hex_dump().

indeed.
any suggestions how it can be fixed ? I guess I shall try casting.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
