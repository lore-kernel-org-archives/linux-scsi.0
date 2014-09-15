From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: Re: [PATCH V3 09/16] scsi: ufs: introduce well known logical unit in
 ufs
Date: Mon, 15 Sep 2014 10:39:40 -0000
Message-ID: <b216e24fcff2825f8ef0b01be4e7f9fe.squirrel@www.codeaurora.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
    <1410350063-23267-10-git-send-email-draviv@codeaurora.org>
    <CAC5umyid+ASquE=RzuNq8Q946et+Sv9dw6vJWMM=JjecoDJvmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAC5umyid+ASquE=RzuNq8Q946et+Sv9dw6vJWMM=JjecoDJvmQ@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>, Jej B <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org


> 2014-09-10 20:54 GMT+09:00 Dolev Raviv <draviv@codeaurora.org>:
>> +static void ufshcd_set_queue_depth(struct scsi_device *sdev)
>> +{
>> +       int ret = 0;
>> +       u8 lun_qdepth;
>> +       struct ufs_hba *hba;
>> +
>> +       hba = shost_priv(sdev->host);
>> +
>> +       lun_qdepth = hba->nutrs;
>> +       ret = ufshcd_read_unit_desc_param(hba,
>> +
>> ufshcd_scsi_to_upiu_lun(sdev->lun),
>> +                                         UNIT_DESC_PARAM_LU_Q_DEPTH,
>> +                                         &lun_qdepth,
>> +                                         sizeof(lun_qdepth));
>> +
>> +       /* Some WLUN doesn't support unit descriptor */
>> +       if (ret == -EOPNOTSUPP)
>> +               lun_qdepth = 1;
>> +       else if (!lun_qdepth)
>> +               /* eventually, we can figure out the real queue depth */
>> +               lun_qdepth = hba->nutrs;
>> +       else
>> +               lun_qdepth = min_t(int, lun_qdepth, hba->nutrs);
>
> If ufshcd_read_unit_desc_param() failed and its error code was not
> -EOPNOTSUPP, lun_qdepth is undefined.  In such cases lun_qdepth
> should be 1?

I'm not sure I follow your concern.
If this lun does not support command queuing (ret == -EOPNOTSUPP)
obviously, lun_qdepth should be 1.
If there was an error and lun_qdepth, was returned as 0, hba->nutrs will
be our default choice.
last, even if the query succeed we want to make sure we don't exceed the
hba->nutrs.

Thanks,
Dolev

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
