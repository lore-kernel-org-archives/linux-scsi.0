From: ygardi@codeaurora.org
Subject: Re: [PATCH v2 7/8] scsi: ufs-qcom: add debug prints for test bus
Date: Sun, 23 Aug 2015 08:54:11 -0000
Message-ID: <ebb5fc34ca07673286a7b914432eadca.squirrel@www.codeaurora.org>
References: <1440079144-26461-1-git-send-email-ygardi@codeaurora.org>
    <1440079144-26461-8-git-send-email-ygardi@codeaurora.org>
    <CAC5umyhX0kD=v+3fsU+BYSbsfde6jAxuG4EgvvYTQc7hF8mW6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAC5umyhX0kD=v+3fsU+BYSbsfde6jAxuG4EgvvYTQc7hF8mW6g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Rob Herring <robherring2@gmail.com>, Jej B <james.bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

> 2015-08-20 22:59 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
>
>> +static bool ufs_qcom_testbus_cfg_is_ok(struct ufs_qcom_host *host)
>> +{
>> +       if (host->testbus.select_major >= TSTBUS_MAX) {
>> +               dev_err(host->hba->dev,
>> +                       "%s: UFS_CFG1[TEST_BUS_SEL} may not equal
>> 0x%05X\n",
>> +                       __func__, host->testbus.select_major);
>> +               return false;
>> +       }
>> +
>> +       /*
>> +        * Not performing check for each individual select_major
>> +        * mappings of select_minor, since there is no harm in
>> +        * configuring a non-existent select_minor
>> +        */
>> +       if (host->testbus.select_major > 0x1F) {
>
> select_minor should be checked instead of select_major here?

you are correct. should be select_minor

>
>> +               dev_err(host->hba->dev,
>> +                       "%s: 0x%05X is not a legal testbus option\n",
>> +                       __func__, host->testbus.select_minor);
>> +               return false;
>> +       }
>> +
>> +       return true;
>> +}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
