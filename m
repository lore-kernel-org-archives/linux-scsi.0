From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH V3 09/16] scsi: ufs: introduce well known logical unit in ufs
Date: Thu, 11 Sep 2014 22:06:06 +0900
Message-ID: <CAC5umyid+ASquE=RzuNq8Q946et+Sv9dw6vJWMM=JjecoDJvmQ@mail.gmail.com>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
	<1410350063-23267-10-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:58607 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbaIKNGI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2014 09:06:08 -0400
In-Reply-To: <1410350063-23267-10-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>

2014-09-10 20:54 GMT+09:00 Dolev Raviv <draviv@codeaurora.org>:
> +static void ufshcd_set_queue_depth(struct scsi_device *sdev)
> +{
> +       int ret = 0;
> +       u8 lun_qdepth;
> +       struct ufs_hba *hba;
> +
> +       hba = shost_priv(sdev->host);
> +
> +       lun_qdepth = hba->nutrs;
> +       ret = ufshcd_read_unit_desc_param(hba,
> +                                         ufshcd_scsi_to_upiu_lun(sdev->lun),
> +                                         UNIT_DESC_PARAM_LU_Q_DEPTH,
> +                                         &lun_qdepth,
> +                                         sizeof(lun_qdepth));
> +
> +       /* Some WLUN doesn't support unit descriptor */
> +       if (ret == -EOPNOTSUPP)
> +               lun_qdepth = 1;
> +       else if (!lun_qdepth)
> +               /* eventually, we can figure out the real queue depth */
> +               lun_qdepth = hba->nutrs;
> +       else
> +               lun_qdepth = min_t(int, lun_qdepth, hba->nutrs);

If ufshcd_read_unit_desc_param() failed and its error code was not
-EOPNOTSUPP, lun_qdepth is undefined.  In such cases lun_qdepth
should be 1?
