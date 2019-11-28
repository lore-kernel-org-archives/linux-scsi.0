Return-Path: <SRS0=EtEA=ZU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6173C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 13:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5018F21739
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 13:59:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dObXyuI7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfK1N7i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 08:59:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22817 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbfK1N7h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2019 08:59:37 -0500
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20191128135935epoutp016ad4e686f4210a102e25873b2c625387~bWEtROl-y0965609656epoutp01g
        for <linux-scsi@vger.kernel.org>; Thu, 28 Nov 2019 13:59:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20191128135935epoutp016ad4e686f4210a102e25873b2c625387~bWEtROl-y0965609656epoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574949575;
        bh=QRyw0lLQtVQOLJHLaBfOinFSbqQnNEXXqAEqLzOVO5g=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=dObXyuI7ef1FgcMMF9S01dV3Og7XKp3VkLHYhc3sPapWcUn2zcAWa+7wNGiAFlIo2
         jQTvOgsM0d4mRw7vqBSAn5uzHLXQy0upU+REczJjZ9XkrUWDVFAdXWq6EBLR8fqWW0
         Dg0qALomW1ZfK7yMBx+FNONhEyRObUxWLaQWp0Ys=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20191128135933epcas5p2bf2ee973d1d0ccc435f43446487de2c9~bWEsAZErN3228632286epcas5p2M;
        Thu, 28 Nov 2019 13:59:33 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        15.2F.19629.5C2DFDD5; Thu, 28 Nov 2019 22:59:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20191128135933epcas5p1537a2987cfbd31cbe97c45e2f2268e83~bWErPjGEi0354203542epcas5p12;
        Thu, 28 Nov 2019 13:59:33 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191128135933epsmtrp1f6e58e8c9e56b0ae05fd69484427caf2~bWErOz1zv2878528785epsmtrp1G;
        Thu, 28 Nov 2019 13:59:33 +0000 (GMT)
X-AuditID: b6c32a4b-32dff70000014cad-7b-5ddfd2c5c95c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7C.57.06569.4C2DFDD5; Thu, 28 Nov 2019 22:59:32 +0900 (KST)
Received: from alimakhtar02 (unknown [107.111.84.32]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191128135930epsmtip29a07a267da03acad7434bae7bf992ea7~bWEpFnazX2555125551epsmtip2U;
        Thu, 28 Nov 2019 13:59:30 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'sheebab'" <sheebab@cadence.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <yuehaibing@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vigneshr@ti.com>, <linux-block@vger.kernel.org>
Cc:     <rafalc@cadence.com>, <mparab@cadence.com>
In-Reply-To: <1574147082-22725-3-git-send-email-sheebab@cadence.com>
Subject: RE: [PATCH RESEND 2/2] scsi: ufs: Update L4 attributes on manual
 hibern8 exit in Cadence UFS.
Date:   Thu, 28 Nov 2019 19:29:29 +0530
Message-ID: <0b8f01d5a5f4$0f7a8a70$2e6f9f50$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHedmnDsV+0XJYctqc2u08WFWQfYAMqNNbiAjPboCmnZAqHgA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTcRjtd+/d3XU4uc6FX0oPVxoWPkKFW5ipCF4qIgpKQtGVFxe5KZuP
        rMBZZj7J1D9ymNW0hyFYuubSRNPcUEvwRSaZFJr5xApfGK22q+R/53zfOb9zPvhRuGRS4EZd
        VKVwapU8UUaKCGOHt7dPZ/9YjP/9bj9manWIZN58ySMY/bARY1pG9jMDTRUkU/DBRDJPLH8w
        5nPPT4LJNi8SjNZwl2Qqn2sx5tHLj4ixvl8QMp8WJ4lQJ7Y2bwZjs9/OCdhifRtis7taCXa5
        Lpdkf0yMEKyh9RdiLcONGPurfgd7q60AOyk6JwqO5xIvpnFqv5A4kWJ64o8wucv/8mR5jVCL
        hvbmIwcK6EB4XNovyEciSkI3I/j06iHGk58I9L2tBE+WEBSVjJAblusvjOuLFgTLwzM4T6YR
        3OutEdhUJO0Dpqoc0raQ0v0YTIxm2e047Qt9s/O4DTvQEaCf//AvkKJcaAWYqznbmKA9wWLS
        2+Vi+iBUD5ZjPHaGrvJxgn9mJzTOVeB8o12wOvHYniulw+H301Ehr3GFztVCezmgu4Wg+zaA
        8YYIaGhcWccuMG0xCHnsBlO3c4S2PkBfgsKmAH58DR5VmgkeH4G2wQrCJsFpb6hr8uOjnKBo
        bRzjnWLIzZHwak+4MT+07nSHOwUFAh6zYF35jhcjD92mw3SbDtNtOkD3P+wBIp6hbVyyRpnA
        aYKSA1Rcuq9GrtSkqhJ8LyQp65H9++07ZkL1vcfbEU0hmaNYYRiLkQjkaZoMZTsCCpdJxefv
        /RuJ4+UZVzh1Uqw6NZHTtCN3ipC5iksEQ9ESOkGewl3iuGROvbHFKAc3LbqKWkatPe7jJ/Z7
        VWUeXHPh3ANKzWlrkZUxgePbpV6ndn9XL2TNCtkmSfFhx2VKa+1O6kxfMhqlUUerqcmtprKz
        8fqqqRBlcINqSRHkuBwZV+a8J90SYfy66NUX9C62ozbc52bzIBt+xvzaw2qMDdviHfot5HT8
        Vf2hqGh9ZpiM0CjkB/bhao38L+hV9ip6AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWy7bCSvO6RS/djDb4+tLB4+fMqm8XBh50s
        FotubGOy2HtL2+LyrjlsFt3Xd7BZLD/+j8ni3ulPLBYtx76yWDRsmcFmMW9DA5PF0q03GS3+
        n/3AbnHn63MWBz6PNZ2vmTxajrxl9Ziw6ACjR8vJ/Swe39d3sHl8fHqLxWPL/s+MHsdvbGfy
        +LxJzqP9QDdTAFcUl01Kak5mWWqRvl0CV8arp//YC04aVDyfuZK9gfGqehcjJ4eEgIlE08Zt
        LF2MXBxCArsZJSa+vMsIkZCWuL5xAjuELSyx8t9zdoiiF4wSs68uBkuwCehK7FjcxgaSEBG4
        xyRx/9AlFpAEs4CBxKVLn5lBbCGBs4wSizYWgdicAi4Si95dZwKxhQXSJFatWA62jUVAVeL4
        jkVsIDavgKXEkiszmSBsQYmTM58AzeQAmqkn0baREWK8vMT2t3OYIY5TkPj5dBkriC0i4CTx
        Z8VddogacYmjP3uYJzAKz0IyaRbCpFlIJs1C0rGAkWUVo2RqQXFuem6xYYFRXmq5XnFibnFp
        Xrpecn7uJkZwDGtp7WA8cSL+EKMAB6MSD6/ApvuxQqyJZcWVuYcYJTiYlUR4k+YChXhTEiur
        Uovy44tKc1KLDzFKc7AoifPK5x+LFBJITyxJzU5NLUgtgskycXBKNTAy/vmi2vHWb9I9b8F7
        G2s8TqfYe6a5zRGI3n/WocHPK13HeW5reZlAl6q5U7PAcusvyYGXVAsi1z3yrzO2nP5d/q/y
        Gc4jZ4tmPjz0RPlL/9usZbXL3JlDV+v3rZyiELgz7FE7ww/+D7/d6hN077z2aD9rfZLjUtdF
        vnu3Zro5VN9etW+6rbkSS3FGoqEWc1FxIgAn7zMG3QIAAA==
X-CMS-MailID: 20191128135933epcas5p1537a2987cfbd31cbe97c45e2f2268e83
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191119070557epcas4p1e2ff5e9d4c69f15cb7510ab5277f0391
References: <1574147082-22725-1-git-send-email-sheebab@cadence.com>
        <CGME20191119070557epcas4p1e2ff5e9d4c69f15cb7510ab5277f0391@epcas4p1.samsung.com>
        <1574147082-22725-3-git-send-email-sheebab@cadence.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: sheebab <sheebab@cadence.com>
> Sent: 19 November 2019 12:35
> To: alim.akhtar@samsung.com; avri.altman@wdc.com;
> pedrom.sousa@synopsys.com; jejb@linux.ibm.com;
> martin.petersen@oracle.com; stanley.chu@mediatek.com;
> beanhuo@micron.com; yuehaibing@huawei.com; linux-scsi@vger.kernel.org;
> linux-kernel@vger.kernel.org; vigneshr@ti.com; linux-block@vger.kernel.org
> Cc: rafalc@cadence.com; mparab@cadence.com; sheebab
> <sheebab@cadence.com>
> Subject: [PATCH RESEND 2/2] scsi: ufs: Update L4 attributes on manual
hibern8
> exit in Cadence UFS.
> 
> Backup L4 attributes duirng manual hibern8 entry and restore the L4
attributes
> on manual hibern8 exit as per JESD220C.
> 
> Signed-off-by: sheebab <sheebab@cadence.com>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/cdns-pltfrm.c | 97
> +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 95 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c
b/drivers/scsi/ufs/cdns-pltfrm.c index
> adbbd60..5510567 100644
> --- a/drivers/scsi/ufs/cdns-pltfrm.c
> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> @@ -19,6 +19,14 @@
> 
>  #define CDNS_UFS_REG_HCLKDIV	0xFC
>  #define CDNS_UFS_REG_PHY_XCFGD1	0x113C
> +#define CDNS_UFS_MAX 12
> +
> +struct cdns_ufs_host {
> +	/**
> +	 * cdns_ufs_dme_attr_val - for storing L4 attributes
> +	 */
> +	u32 cdns_ufs_dme_attr_val[CDNS_UFS_MAX];
> +};
> 
>  /**
>   * cdns_ufs_enable_intr - enable interrupts @@ -47,6 +55,77 @@ static
void
> cdns_ufs_disable_intr(struct ufs_hba *hba, u32 intrs)  }
> 
>  /**
> + * cdns_ufs_get_l4_attr - get L4 attributes on local side
> + * @hba: per adapter instance
> + *
> + */
> +static void cdns_ufs_get_l4_attr(struct ufs_hba *hba) {
> +	struct cdns_ufs_host *host = ufshcd_get_variant(hba);
> +
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERDEVICEID),
> +		       &host->cdns_ufs_dme_attr_val[0]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERCPORTID),
> +		       &host->cdns_ufs_dme_attr_val[1]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_TRAFFICCLASS),
> +		       &host->cdns_ufs_dme_attr_val[2]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_PROTOCOLID),
> +		       &host->cdns_ufs_dme_attr_val[3]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_CPORTFLAGS),
> +		       &host->cdns_ufs_dme_attr_val[4]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_TXTOKENVALUE),
> +		       &host->cdns_ufs_dme_attr_val[5]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_RXTOKENVALUE),
> +		       &host->cdns_ufs_dme_attr_val[6]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_LOCALBUFFERSPACE),
> +		       &host->cdns_ufs_dme_attr_val[7]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERBUFFERSPACE),
> +		       &host->cdns_ufs_dme_attr_val[8]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_CREDITSTOSEND),
> +		       &host->cdns_ufs_dme_attr_val[9]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_CPORTMODE),
> +		       &host->cdns_ufs_dme_attr_val[10]);
> +	ufshcd_dme_get(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
> +		       &host->cdns_ufs_dme_attr_val[11]);
> +}
> +
> +/**
> + * cdns_ufs_set_l4_attr - set L4 attributes on local side
> + * @hba: per adapter instance
> + *
> + */
> +static void cdns_ufs_set_l4_attr(struct ufs_hba *hba) {
> +	struct cdns_ufs_host *host = ufshcd_get_variant(hba);
> +
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID),
> +		       host->cdns_ufs_dme_attr_val[0]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID),
> +		       host->cdns_ufs_dme_attr_val[1]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS),
> +		       host->cdns_ufs_dme_attr_val[2]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PROTOCOLID),
> +		       host->cdns_ufs_dme_attr_val[3]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS),
> +		       host->cdns_ufs_dme_attr_val[4]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_TXTOKENVALUE),
> +		       host->cdns_ufs_dme_attr_val[5]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_RXTOKENVALUE),
> +		       host->cdns_ufs_dme_attr_val[6]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_LOCALBUFFERSPACE),
> +		       host->cdns_ufs_dme_attr_val[7]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERBUFFERSPACE),
> +		       host->cdns_ufs_dme_attr_val[8]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CREDITSTOSEND),
> +		       host->cdns_ufs_dme_attr_val[9]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTMODE),
> +		       host->cdns_ufs_dme_attr_val[10]);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
> +		       host->cdns_ufs_dme_attr_val[11]); }
> +
> +/**
>   * Sets HCLKDIV register value based on the core_clk
>   * @hba: host controller instance
>   *
> @@ -134,6 +213,7 @@ static void cdns_ufs_hibern8_notify(struct ufs_hba
> *hba, enum uic_cmd_dme cmd,
>  		 * before manual hibernate entry.
>  		 */
>  		cdns_ufs_enable_intr(hba, UFSHCD_UIC_HIBERN8_MASK);
> +		cdns_ufs_get_l4_attr(hba);
>  	}
>  	if (status == POST_CHANGE && cmd == UIC_CMD_DME_HIBER_EXIT) {
>  		/**
> @@ -141,6 +221,7 @@ static void cdns_ufs_hibern8_notify(struct ufs_hba
> *hba, enum uic_cmd_dme cmd,
>  		 * after manual hibern8 exit.
>  		 */
>  		cdns_ufs_disable_intr(hba, UFSHCD_UIC_HIBERN8_MASK);
> +		cdns_ufs_set_l4_attr(hba);
>  	}
>  }
> 
> @@ -245,15 +326,27 @@ static int cdns_ufs_pltfrm_probe(struct
> platform_device *pdev)
>  	const struct of_device_id *of_id;
>  	struct ufs_hba_variant_ops *vops;
>  	struct device *dev = &pdev->dev;
> +	struct cdns_ufs_host *host;
> +	struct ufs_hba *hba;
> 
>  	of_id = of_match_node(cdns_ufs_of_match, dev->of_node);
>  	vops = (struct ufs_hba_variant_ops *)of_id->data;
> 
>  	/* Perform generic probe */
>  	err = ufshcd_pltfrm_init(pdev, vops);
> -	if (err)
> +	if (err) {
>  		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
> -
> +		goto out;
> +	}
> +	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> +	if (!host) {
> +		err = -ENOMEM;
> +		dev_err(dev, "%s: no memory for cdns host\n", __func__);
> +		goto out;
> +	}
> +	hba =  platform_get_drvdata(pdev);
> +	ufshcd_set_variant(hba, host);
> +out:
>  	return err;
>  }
> 
> --
> 2.7.4


