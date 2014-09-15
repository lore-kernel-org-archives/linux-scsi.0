From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH V3 09/16] scsi: ufs: introduce well known logical unit in ufs
Date: Mon, 15 Sep 2014 23:55:16 +0900
Message-ID: <CAC5umyh+XzCouFLeVVZrnSt3ADb4OdvGg=cjLp3d39rWiprjLA@mail.gmail.com>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
	<1410350063-23267-10-git-send-email-draviv@codeaurora.org>
	<CAC5umyid+ASquE=RzuNq8Q946et+Sv9dw6vJWMM=JjecoDJvmQ@mail.gmail.com>
	<b216e24fcff2825f8ef0b01be4e7f9fe.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <b216e24fcff2825f8ef0b01be4e7f9fe.squirrel@www.codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: Jej B <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

2014-09-15 19:39 GMT+09:00 Dolev Raviv <draviv@codeaurora.org>:
>
>> 2014-09-10 20:54 GMT+09:00 Dolev Raviv <draviv@codeaurora.org>:
>>> +static void ufshcd_set_queue_depth(struct scsi_device *sdev)
>>> +{
>>> +       int ret = 0;
>>> +       u8 lun_qdepth;
>>> +       struct ufs_hba *hba;
>>> +
>>> +       hba = shost_priv(sdev->host);
>>> +
>>> +       lun_qdepth = hba->nutrs;
>>> +       ret = ufshcd_read_unit_desc_param(hba,
>>> +
>>> ufshcd_scsi_to_upiu_lun(sdev->lun),
>>> +                                         UNIT_DESC_PARAM_LU_Q_DEPTH,
>>> +                                         &lun_qdepth,
>>> +                                         sizeof(lun_qdepth));
>>> +
>>> +       /* Some WLUN doesn't support unit descriptor */
>>> +       if (ret == -EOPNOTSUPP)
>>> +               lun_qdepth = 1;
>>> +       else if (!lun_qdepth)
>>> +               /* eventually, we can figure out the real queue depth */
>>> +               lun_qdepth = hba->nutrs;
>>> +       else
>>> +               lun_qdepth = min_t(int, lun_qdepth, hba->nutrs);
>>
>> If ufshcd_read_unit_desc_param() failed and its error code was not
>> -EOPNOTSUPP, lun_qdepth is undefined.  In such cases lun_qdepth
>> should be 1?
>
> I'm not sure I follow your concern.
> If this lun does not support command queuing (ret == -EOPNOTSUPP)
> obviously, lun_qdepth should be 1.
> If there was an error and lun_qdepth, was returned as 0, hba->nutrs will
> be our default choice.
> last, even if the query succeed we want to make sure we don't exceed the
> hba->nutrs.

I missed that the local variable lun_qdepth is initialized to
hba->nutrs just before calling ufshcd_read_unit_desc_param().  So what
I said undefined in the last message was just wrong.  Thanks for the
clarification.
