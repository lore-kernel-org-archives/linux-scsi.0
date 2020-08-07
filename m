Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAA2C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 07:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9259220866
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 07:01:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bKjsUIjC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgHGHA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 03:00:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43123 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgHGHAy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 03:00:54 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200807070051epoutp01e1c0e693a38bbc8c4e57a2dfb5ff3141~o6kVwA8k70610406104epoutp01C
        for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2020 07:00:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200807070051epoutp01e1c0e693a38bbc8c4e57a2dfb5ff3141~o6kVwA8k70610406104epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1596783651;
        bh=o13f+voQct8FNX9FFUIBvbtago50uKqLaBKpzJtj3GY=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=bKjsUIjChvMmK3G94ixUHQNIo3uqZYxsDFWUA615sSF+lo7Nl5Ic+eyb31KOCClwm
         jH+qd3Ntkqdi5PjLjctlt6rbRDxmTgYkpPcuXlxwdvMez4X+ALZnD08kSQETeXPs8J
         2GTlwBlKY/gn6QhaA5yyHbxDWT6Y1Zpiqs3GuvQQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200807070048epcas2p1439cb7c6f2bf3367f092cff6e53b156c~o6kSTNCET0984609846epcas2p1X;
        Fri,  7 Aug 2020 07:00:48 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.186]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4BNGTp01s6zMqYlt; Fri,  7 Aug
        2020 07:00:46 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2B.58.18874.D1CFC2F5; Fri,  7 Aug 2020 16:00:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200807070041epcas2p4b8b6678a7cb175b620317e5497e0cdc1~o6kLxhrFB2878928789epcas2p4N;
        Fri,  7 Aug 2020 07:00:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200807070040epsmtrp19d66e161b9fa82aee1ed7c22f0799c12~o6kLblcDP1640616406epsmtrp1B;
        Fri,  7 Aug 2020 07:00:40 +0000 (GMT)
X-AuditID: b6c32a46-503ff700000049ba-da-5f2cfc1dc892
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.57.08382.81CFC2F5; Fri,  7 Aug 2020 16:00:40 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200807070040epsmtip285925e2732f59b02db396293314be835~o6kLH_xo60243302433epsmtip2F;
        Fri,  7 Aug 2020 07:00:40 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <bvanassche@acm.org>, <grant.jung@samsung.com>,
        <sc.suh@samsung.com>, <hy50.seo@samsung.com>,
        <sh425.lee@samsung.com>
In-Reply-To: <1596782143-22748-1-git-send-email-kwmad.kim@samsung.com>
Subject: RE: [PATCH v4] ufs: change the way to complete fDeviceInit
Date:   Fri, 7 Aug 2020 16:00:39 +0900
Message-ID: <000401d66c88$7605c510$62114f30$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLH0w8V9HtZbIUMssUE5YA+mUsR4gFrWSVnpz4PlJA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJsWRmVeSWpSXmKPExsWy7bCmma7sH514g61NvBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiMqxyUhN
        TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6WUmhLDGnFCgU
        kFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhYoFecmFtcmpeul5yfa2VoYGBkClSZkJNx5skT
        1oJPQhVTpsxkbGB8wdfFyMkhIWAisfXGRMYuRi4OIYEdjBJnp39jgXA+MUrcnLGeDcL5xigx
        Z8pBdpiWKbNBbJDEXkaJK/eWgSWEBF4wShx4xA9iswloS0x7uJsVpEhE4CyTxKPOH2wgCU4B
        N4kj2/qZQGxhAWeJ28d2gMVZBFQkPvy/wghi8wpYSkz+/xHKFpQ4OfMJC4jNLCAvsf3tHGaI
        KxQkfj5dxgpiiwhYSfTsvc4MUSMiMbuzjRlksYTACQ6JOdc3MkI0uEjc29UD9YKwxKvjW6Bs
        KYmX/W1Qdr3EvqkNrBDNPYwST/f9g2o2lpj1rB3I5gDaoCmxfpc+iCkhoCxx5BbUbXwSHYf/
        skOEeSU62oQgGpUlfk2aDDVEUmLmzTtQmzwkFvRsZp/AqDgLyZezkHw5C8k3sxD2LmBkWcUo
        llpQnJueWmxUYIQc25sYwelZy20H45S3H/QOMTJxMB5ilOBgVhLhzXqhHS/Em5JYWZValB9f
        VJqTWnyI0RQY7hOZpUST84EZIq8k3tDUyMzMwNLUwtTMyEJJnLde8UKckEB6YklqdmpqQWoR
        TB8TB6dUA9OuV6vT/n5YwsV8NDnS+m3AbrdExeo939S1a899uSsiV3M94uGzbM6VQqnMshqO
        GfYPVn6zElZfOi9zU7FFUWey1II08f9/p77PUFX9Ivig5EjApWjDHytyz1wy7t7P9VpJ1ULY
        fVHbhgV8/BordPXq/vOddi/e1pyY9OnLy78Z65tC1gSW8YidmvFnxZVvG7MdE31rlvYv+Xvf
        OseDeWvqJ+Pe47Pm8B5Q2Ds5UdBWI1OGh7tkhW/Ep7V7xBZ+E+R8rfeuqu8Nw9JNyzrZFgbW
        7nv042C6QMzslcrSmVu/Wjw1mWD+biOjntXrXJf66Jp+7V31UV1/fYuzrf1iNjUt3hFkO+vE
        szutxgwf45VYijMSDbWYi4oTAfpeZiRYBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSvK7EH514g+79qhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKOPPkCWvBJ6GKKVNmMjYwvuDrYuTkkBAwkZgy+yB7FyMXh5DAbkaJZ/vbmCES
        khIndj5nhLCFJe63HGGFKHrGKPGj/T8LSIJNQFti2sPdYAkRgbtMEn17PrNAVE1nlPh84D5Y
        O6eAm8SRbf1MILawgLPE7WM72EBsFgEViQ//r4DV8ApYSkz+/xHKFpQ4OfMJ2AZmoA29D1sZ
        IWx5ie1v50CdpyDx8+kyVhBbRMBKomfvdWaIGhGJ2Z1tzBMYhWYhGTULyahZSEbNQtKygJFl
        FaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcExqae5g3L7qg94hRiYOxkOMEhzMSiK8
        WS+044V4UxIrq1KL8uOLSnNSiw8xSnOwKInz3ihcGCckkJ5YkpqdmlqQWgSTZeLglGpgUhI6
        N11J9LNpdtxrzq979+vVyOl8eHvCvq6ofta2rhd/excdPCld6KoUw/vm4J8H02duunHb2m2a
        qoGTUrpy/67Ij6XXnosdj7xnrSxRGP/9QZSA6f0WbSlTaZVCm2s/tnq1iUzIeNQuuyXr3gmp
        /CfFBy3Fnl/V8BZi+LTm30r+M2vdH85hvxHqEWt2zOj6kcVf7RjXegXdcz9pHK6/68sb/iN1
        jsqs/w+UGXGYKGT8d55YM9uINeLJF7bJhZ73s19c39c67TjDp9lL5qxtWD1xId/EWzOm7Qy5
        Gvi7Nvh+7Ym0d1uyHy9/pv+rxTLjYX/f5YrZV0WnuYUJxi5s4vyyd7r0M9G2uOUKqhbr+pRY
        ijMSDbWYi4oTAX+A0RQ4AwAA
X-CMS-MailID: 20200807070041epcas2p4b8b6678a7cb175b620317e5497e0cdc1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200807064407epcas2p464c2400c3868cfaa12b0e23310617a29
References: <CGME20200807064407epcas2p464c2400c3868cfaa12b0e23310617a29@epcas2p4.samsung.com>
        <1596782143-22748-1-git-send-email-kwmad.kim@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Currently, UFS driver checks if fDeviceInit is cleared at several times,
> not period. This patch is to wait its completion with the period, not
> retrying.
> Many device vendors usually provides the specification on it with just
> period, not a combination of a number of retrying and period. So it could
> be proper to regard to the information coming from device vendors.
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 31 +++++++++++++++++++------------
>  1 file changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 092480a..c508931 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4148,7 +4148,8 @@ EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
>   */
>  static int ufshcd_complete_dev_init(struct ufs_hba *hba)  {
> -	int i;
> +	u32 dev_init_compl_in_ms = 1500;
> +	unsigned long timeout;
>  	int err;
>  	bool flag_res = true;
> 
> @@ -4161,20 +4162,26 @@ static int ufshcd_complete_dev_init(struct ufs_hba
> *hba)
>  		goto out;
>  	}
> 
> -	/* poll for max. 1000 iterations for fDeviceInit flag to clear */
> -	for (i = 0; i < 1000 && !err && flag_res; i++)
> -		err = ufshcd_query_flag_retry(hba,
> UPIU_QUERY_OPCODE_READ_FLAG,
> -			QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
> +	/* Poll fDeviceInit flag to be cleared */
> +	timeout = jiffies + msecs_to_jiffies(dev_init_compl_in_ms);
> +	do {
> +		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> +					QUERY_FLAG_IDN_FDEVICEINIT, 0,
> &flag_res);
> +		if (!flag_res)
> +			break;
> +		usleep_range(5000, 10000);
> +	} while (time_before(jiffies, timeout));
> 
> -	if (err)
> +	if (err) {
>  		dev_err(hba->dev,
> -			"%s reading fDeviceInit flag failed with error %d\n",
> -			__func__, err);
> -	else if (flag_res)
> +				"%s reading fDeviceInit flag failed with
> error %d\n",
> +				__func__, err);
> +	} else if (flag_res) {
>  		dev_err(hba->dev,
> -			"%s fDeviceInit was not cleared by the device\n",
> -			__func__);
> -
> +				"%s fDeviceInit was not cleared by the
> device\n",
> +				__func__);
> +		err = -EBUSY;
> +	}
>  out:
>  	return err;
>  }
> --
> 2.7.4

I'll post again with v1 because this patch is teared from the patch set
That I had posted before. Sorry for bothering you.

Thanks.
Kiwoong Kim

