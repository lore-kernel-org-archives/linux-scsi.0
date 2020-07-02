Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA90DC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:11:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CD38207E8
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 02:11:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qppze0Hy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgGBCLX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:11:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64742 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgGBCLW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 22:11:22 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200702021118epoutp026127dd1e0c26f3e02f5fc4758cd956fd~dzZP4JBNl2377723777epoutp02X
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 02:11:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200702021118epoutp026127dd1e0c26f3e02f5fc4758cd956fd~dzZP4JBNl2377723777epoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593655878;
        bh=Br0jRx6PNEeo/E7pOujQ0maFzvBXrS8DIl6lcKnNoXU=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=qppze0Hy8rQ7q6ar5JdJ81RhEpI2Yl54CmoF4jN968pw3Y8FJ6wNpMKYzvW33SbnD
         UPsZ4eJ8XIPoDdhsr/nBZAT6tGV0n55Mr0EXirMoKS6xKWT4TRQWNUgjAwsNsX1Qzi
         c7t2FwaAcqeGDZs2tIYeQTdEKCqRYZ1BSpaHhNWQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200702021117epcas2p18209a536776de543fb7742e6f53afda3~dzZPIGjw_0375303753epcas2p1L;
        Thu,  2 Jul 2020 02:11:17 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49y1mM4YRJzMqYkV; Thu,  2 Jul
        2020 02:11:15 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.5F.18874.1424DFE5; Thu,  2 Jul 2020 11:11:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200702021113epcas2p2c17102a7f9d9094daa03c0fb3a79f68d~dzZK5mk1d0596605966epcas2p2k;
        Thu,  2 Jul 2020 02:11:13 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200702021113epsmtrp26babfc4c1192b4044899e5ecf4e8da3a~dzZK5Anjs0997309973epsmtrp2K;
        Thu,  2 Jul 2020 02:11:13 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-a3-5efd42415596
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.BF.08303.1424DFE5; Thu,  2 Jul 2020 11:11:13 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200702021113epsmtip1dfa5c11acace170df9e5b034d66435b2~dzZKwkm_D1470614706epsmtip1r;
        Thu,  2 Jul 2020 02:11:13 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Grant Jung'" <grant.jung@samsung.com>,
        <linux-scsi@vger.kernel.org>
In-Reply-To: <047001d64e96$3e3dd970$bab98c50$@samsung.com>
Subject: RE: [RFC PATCH v2 2/2] ufs: change the way to complete fDeviceInit
Date:   Thu, 2 Jul 2020 11:11:12 +0900
Message-ID: <009f01d65016$0f561290$2e0237b0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFK3dcLjmJa+k4JeQp1dmQok7cMGwJjn9aGAdeRtSoBkhaXIKncBhfQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsWy7bCmma6j0984gxVPtCx+/V3PbtF9fQeb
        A5NH35ZVjB6fN8kFMEXl2GSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qba
        Krn4BOi6ZeYAjVdSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFBgaFugVJ+YWl+al
        6yXn51oZGhgYmQJVJuRk7N9xmqXgoUzFyr/v2BsYZ4l1MXJySAiYSJw9/4Gti5GLQ0hgB6PE
        /gXr2CGcT4wSf5/shnI+M0osWtTMAtOyZOVEZojELkaJ1jdtUM4LRol/LzcxglSxCWhLTHu4
        mxXEFhHwlDj7YD47iM0pYCUxY8lrMFtYwFti07HpYDUsAioSv3ftBevlFbCUuPPwKRuELShx
        cuYTsM3MAvIS29/OYYa4QkHi59NlUPPdJG6vWMAKUSMiMbsT4iAJgVPsEo+717BCNLhIrJzT
        CfWCsMSr41vYIWwpic/v9rJB2PUS+6Y2sEI09zBKPN33jxEiYSwx61k7kM0BtEFTYv0ufRBT
        QkBZ4sgtqNv4JDoO/2WHCPNKdLQJQTQqS/yaNBlqiKTEzJt3oLZ6SBx6PYV1AqPiLCRfzkLy
        5Swk38xC2LuAkWUVo1hqQXFuemqxUYERcmxvYgSnPS23HYxT3n7QO8TIxMF4iFGCg1lJhPe0
        wa84Id6UxMqq1KL8+KLSnNTiQ4ymwHCfyCwlmpwPTLx5JfGGpkZmZgaWphamZkYWSuK89YoX
        4oQE0hNLUrNTUwtSi2D6mDg4pRqYtmWJZISsa/vBzy3WKBMrluehs3DDOcvzsX/fVc2L26en
        5b9nNk/J62yTrNgjqtpaurv2zLloVpcQfaFizdwVWz9KaLEsdmAPKzN9vnEWk0hXzJWrt2Pk
        xTcdOvMk+9lvFwt/5y2pK1WCrU3P+klNNb5m5LtZ78Dxt++dpr5+G5O1gMVOte/lPA6hVf8e
        Nz+doP/tn/aysI6bHOn3tybamZ8xZP2j3BMRUyC0adrtBz8dzpcaG6VNmNfe4T/hiWhZ3Rb/
        ko6vx6c9YX9uesDn5W2tkpO7t2iIz56ccI/D5sHrs0kT3/+YaGazMLxE4Zpl0NWvd+9m1bzV
        7qnR1vr8gtM+4R7ffBXZ2TKmEw5LKrEUZyQaajEXFScCAKy01vQEBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSnK6j0984gxnnOS1+/V3PbtF9fQeb
        A5NH35ZVjB6fN8kFMEVx2aSk5mSWpRbp2yVwZezfcZql4KFMxcq/79gbGGeJdTFyckgImEgs
        WTmRuYuRi0NIYAejxOINf1khEpISJ3Y+Z4SwhSXutxxhhSh6xijxZeZuJpAEm4C2xLSHu8Ea
        RAS8Jdb9P8YGUdTBJPHm/GqwBKeAlcSMJa/ZQWxhoKJNx6aDxVkEVCR+79oLtoFXwFLizsOn
        bBC2oMTJmU9YQGxmoAW9D1sZIWx5ie1v5zBDXKQg8fPpMqjFbhK3VyxghagRkZjd2cY8gVFo
        FpJRs5CMmoVk1CwkLQsYWVYxSqYWFOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgQHupbWDsY9
        qz7oHWJk4mA8xCjBwawkwnva4FecEG9KYmVValF+fFFpTmrxIUZpDhYlcd6vsxbGCQmkJ5ak
        ZqemFqQWwWSZODilGpiceDOsLDzvsK5KqT+7YMnLKxuC94nMET8wzb1FrfeyJ7fBjZmtqy+v
        PrBb6GmdQLfHtJNNbzsdKlY3HVv663+oRLHLtOfGtzVl9LpDazoXsvT9nPOx6Fz9ggNiyy7+
        1tuZUdf/r0dH9dqayUe+H9vmwhUjXiPhc+HUjW0TM9W3P/QuNt6ePSXjDVuC84fQ0rM8zxlE
        TRqNBee7HWp59jVNgCutp2FhYYr+tOVhcjVfjq70Dm/o/T4xd07rhi2XZBpSHY0N4kwmr9ii
        vP3A3e03/m/6L9zyY3+/QvXlTk7ZvqBXG1Yp2gYpS8qWTpW8/T5v3spL+8+aTskPZeVKtlZ/
        z1R7xfb6F4lrVjKHPB4rsRRnJBpqMRcVJwIAjB/qfeMCAAA=
X-CMS-MailID: 20200702021113epcas2p2c17102a7f9d9094daa03c0fb3a79f68d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200629102355epcas2p13f8714a906291e5444adfb2f5ac2c469
References: <cover.1593412974.git.kwmad.kim@samsung.com>
        <CGME20200629102355epcas2p13f8714a906291e5444adfb2f5ac2c469@epcas2p1.samsung.com>
        <1ca1a52df36ad3393c0487537832cf7f0a7e1260.1593412974.git.kwmad.kim@samsung.com>
        <047001d64e96$3e3dd970$bab98c50$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Currently, UFS driver checks if fDeviceInit is cleared at several
> > times, not period. This patch is to wait its completion with the
> > period, not retrying.
> > Many device vendors usually provides the specification on it with just
> > period, not a combination of a number of retrying and period. So it
> > could be proper to regard to the information coming from device vendors.
> >
> > I first added one device specific value regarding the information.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 36 ++++++++++++++++++++++++------------
> >  1 file changed, 24 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index
> > 7b6f13a..27afdf0 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -208,6 +208,7 @@ static struct ufs_dev_fix ufs_fixups[] = {  };
> >
> >  static const struct ufs_dev_value ufs_dev_values[] = {
> > +	{UFS_VENDOR_TOSHIBA, UFS_ANY_MODEL, DEV_VAL_FDEVICEINIT, 2000,
> > false},
> >  	{0, 0, 0, 0, false},
> >  };
> >
> > @@ -4162,9 +4163,12 @@ EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
> >   */
> >  static int ufshcd_complete_dev_init(struct ufs_hba *hba)  {
> > -	int i;
> > +	u32 dev_init_compl_in_ms = 500;
> 
> I think default timeout value is too small. Most UFS vendors which are
> Samsung, Kioxia, SKHynix, Micron and WD want to set more than 1 seconds
> for a worst case of fdeviceinit. We need to add many quirks for every ufs
> vendors if the default value is 500ms.
> 
> > +	unsigned long timeout;
> >  	int err;
> >  	bool flag_res = true;
> > +	bool is_dev_val;
> > +	u32 val;
> >
> >  	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> >  		QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL); @@ -4175,20 +4179,28
> @@
> > static int ufshcd_complete_dev_init(struct ufs_hba *hba)
> >  		goto out;
> >  	}
> >
> > -	/* poll for max. 1000 iterations for fDeviceInit flag to clear */
> > -	for (i = 0; i < 1000 && !err && flag_res; i++)
> > -		err = ufshcd_query_flag_retry(hba,
> > UPIU_QUERY_OPCODE_READ_FLAG,
> > -			QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
> > +	/* Poll fDeviceInit flag to be cleared */
> > +	is_dev_val = ufs_get_dev_specific_value(hba, DEV_VAL_FDEVICEINIT,
> > &val);
> > +	dev_init_compl_in_ms = (is_dev_val) ? val : 500;
> > +	timeout = jiffies + msecs_to_jiffies(dev_init_compl_in_ms);
> > +	do {
> > +		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> > +					QUERY_FLAG_IDN_FDEVICEINIT, 0,
> > &flag_res);
> > +		if (!flag_res)
> > +			break;
> > +		usleep_range(1000, 2000);
> 
> How about think to increase the value of usleep() to 5 ~ 10ms. I think 1 ~
> 2ms is too small.
> 
> > +	} while (time_before(jiffies, timeout));
> >
> > -	if (err)
> > +	if (err) {
> >  		dev_err(hba->dev,
> > -			"%s reading fDeviceInit flag failed with error %d\n",
> > -			__func__, err);
> > -	else if (flag_res)
> > +				"%s reading fDeviceInit flag failed with
> > error %d\n",
> > +				__func__, err);
> > +	} else if (flag_res) {
> >  		dev_err(hba->dev,
> > -			"%s fDeviceInit was not cleared by the device\n",
> > -			__func__);
> > -
> > +				"%s fDeviceInit was not cleared by the
> > device\n",
> > +				__func__);
> > +		err = -EBUSY;
> > +	}
> >  out:
> >  	return err;
> >  }
> > --
> > 2.7.4
> 
> Thanks for this patch. We are changing this code and value for all
> projects.
> Fdeviceinit fail is one of most frequently happened defects. So it's
> important to set with proper value.
> 
> BR
> Grant

Got it.

Thanks.
Kiwoong Kim

