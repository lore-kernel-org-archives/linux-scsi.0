Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84222C432C0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 10:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51C932073C
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 10:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gG6Bc6JV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfLCKbb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 05:31:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:30817 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfLCKba (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 05:31:30 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20191203103127epoutp04bc4fed1e7285aef1ad9188ddadf63a9c~c1da9NP802448924489epoutp04b
        for <linux-scsi@vger.kernel.org>; Tue,  3 Dec 2019 10:31:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20191203103127epoutp04bc4fed1e7285aef1ad9188ddadf63a9c~c1da9NP802448924489epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1575369087;
        bh=k4smPxscGQus0agxESMLr3cncxJ0TeOpX6R7z78OuEs=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=gG6Bc6JVvPPaTqo7CSH5SH6VhThgD2GfwerLqxYmMHO1GmjGJvb0SsqQgNJCVtkyy
         qgG6jVw+dGAJ+qlbo4DwH44pl3rCMv4ic37RBNXEVXqCt1vLH8et8AGnSGq4KN9s9a
         kq86eLFWGvfLw/SRKbuwkr6sKpXSIdakuX79whc8=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20191203103127epcas5p1f7d66300090a96eb363dad698a7cce92~c1daM2YXb0700907009epcas5p1B;
        Tue,  3 Dec 2019 10:31:27 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.A7.19629.F7936ED5; Tue,  3 Dec 2019 19:31:27 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20191203103126epcas5p440b714f961f05ce87fcf35f70699c689~c1dZm-Yup0517505175epcas5p4h;
        Tue,  3 Dec 2019 10:31:26 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191203103126epsmtrp1cd47add7f9a16655907182e738965c9b~c1dZmIGvl0666506665epsmtrp1J;
        Tue,  3 Dec 2019 10:31:26 +0000 (GMT)
X-AuditID: b6c32a4b-345ff70000014cad-43-5de6397ff18c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DA.50.06569.E7936ED5; Tue,  3 Dec 2019 19:31:26 +0900 (KST)
Received: from alimakhtar02 (unknown [107.111.84.32]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191203103122epsmtip22107dabcbc4b6ebbe155a966bc08959d~c1dVjMGzp1815318153epsmtip2W;
        Tue,  3 Dec 2019 10:31:22 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'sheebab'" <sheebab@cadence.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <yuehaibing@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vigneshr@ti.com>
Cc:     <mparab@cadence.com>, <rafalc@cadence.com>
In-Reply-To: <1575367635-22662-1-git-send-email-sheebab@cadence.com>
Subject: RE: [PATCH] scsi: ufs: Disable autohibern8 feature in Cadence UFS
Date:   Tue, 3 Dec 2019 16:01:18 +0530
Message-ID: <011201d5a9c4$d0f99780$72ecc680$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFBe579HXcCclZGAfVZug4m7IsA/AH+fHYWqMCd0NA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUhTYRTGee/ee3c3XVxn6EnLahSlpFYqXCPKoOhmCfZHZNGokTcVdemm
        piU4afg1q6UEOURSK6EWlpiaWS7zI4s+SIdmpVjOz5TULEapOa+R/z3nnN/zPufAS4vk/aQH
        HaNO4jVqVZyCkuKa597evhnBg8qtnx6T7IjdSrHP+nMxW9ZdQ7Ad9cUUa+iqo9iKtjmC7X01
        hVl96wxmddXXKbbkvo5gbz38gNj519/F7KeZIRwi48y5YwSnbx4nOWOZBXH69kbM/arMobhJ
        Ww/mqhunEdfWXUtw01VeXLbFQIRLj0t3RvJxMSm8xn/XKWn0bKVTQqdz6qtrdrEOtUjzkIQG
        JhDelXZReUhKy5nHCLpts6RQTCHos5uRUPxEMJ87KfpnyZ8yL1meIGjoK8VCMYpgYnCeclAU
        4wt15VmL1ErmAQH2sR7CMRAxfmDOLMIOLWH2QmlhB3JoVyYUbK+fLzKY2QAVN+cW+zImGL61
        FZKCdoH2ogEsvLMWaseLl1ZaB3bb7QWGXgjbAdnWNQLiDi32fJFjB2CeisFS8JFyMLCQa3x2
        RLC6wmhbtVjQHjByJUssILGQXx8gtNPhVkkrFvRusHQWYwciYryhst5fSFoBl34PEIJTBjlZ
        coHeCBcnrEtOT7hqMJCC5mDSOEoZ0XrTsrNMy84yLdvf9D/sBsJ30Co+QRsfxWuDEgLU/Dk/
        rSpem6yO8jt9Nr4KLX48n4N1qOrNoSbE0EjhLLP8GVDKSVWKNi2+CQEtUqyU1YBNKZdFqtLO
        85qzJzXJcby2CXnSWOEuKyCtJ+RMlCqJj+X5BF7zb0rQEg8d2vCjavXny4pHeud5p95Y6NwX
        dIBTeYVl7EfTpoKOtzNfXsRlhXk5l+P+4cN3twy7TGd7kGfuHfTe7NOsbl9RsTczXXNREr5H
        E9EwkfjeGhja3VRvN/QE9OUZTUMBEalG8eimr+MnT710CxnS8W4TsH2wr7rxQuLRgkmlZKZ5
        5JgCa6NV23xEGq3qL+yuwe10AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsWy7bCSvG6d5bNYg84pYhYvf15lszj4sJPF
        YtGNbUwWl3fNYbPovr6DzWL58X9MFvdOf2KxaDn2lcWiYcsMNot5GxqYLJZuvclo8f/sB3aL
        O1+fszjweqzpfM3k0XLkLavHhEUHGD1aTu5n8fi+voPN4+PTWyweW/Z/ZvQ4fmM7k8fnTXIe
        7Qe6mQK4orhsUlJzMstSi/TtErgy/q7nLrjCU3F66k/2BsajXF2MnBwSAiYSPZ/WsHUxcnEI
        CexmlHh+YRITREJa4vrGCewQtrDEyn/P2SGKXjBK3H58kRkkwSagK7FjcRtYt4jAXiaJOTen
        gXUwCxhIfHz5gRGiYyqjxMPd+8A6OAVcJBZOvswIYgsLeEk8PXsYbB2LgIrE8iX/wOK8ApYS
        b45PZoWwBSVOznzC0sXIATRUT6JtIyPEfHmJ7W/nMENcpyDx8+kyVpASEQErifarshAl4hJH
        f/YwT2AUnoVk0CyEQbOQDJqFpGMBI8sqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzg
        yNXS2sF44kT8IUYBDkYlHt6MX09ihVgTy4orcw8xSnAwK4nwbpN4GivEm5JYWZValB9fVJqT
        WnyIUZqDRUmcVz7/WKSQQHpiSWp2ampBahFMlomDU6qBcX7klbvKU+IFShgrhLarnLt74vH9
        g2sC20L6nn3Y/JynruyO6fvSi/eCD/lsPrZtclfg4dMvGwp5lr9keMh24FlGtvSjHl+NFQGP
        /s+VEjH/v6F42oJNXIt0tKJ+664p6DJZbGvdJjNvXsPx4NZr10TnP3Dbrr2o+ZvPVBcva/WU
        7RcMDLQsq5RYijMSDbWYi4oTAWIkvUXYAgAA
X-CMS-MailID: 20191203103126epcas5p440b714f961f05ce87fcf35f70699c689
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191203100929epcas3p3e781cc87ff70f82bc1e708ba654456d2
References: <CGME20191203100929epcas3p3e781cc87ff70f82bc1e708ba654456d2@epcas3p3.samsung.com>
        <1575367635-22662-1-git-send-email-sheebab@cadence.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: sheebab <sheebab@cadence.com>
> Sent: 03 December 2019 15:37
> To: alim.akhtar@samsung.com; avri.altman@wdc.com;
> pedrom.sousa@synopsys.com; jejb@linux.ibm.com;
> martin.petersen@oracle.com; stanley.chu@mediatek.com;
> beanhuo@micron.com; yuehaibing@huawei.com; linux-scsi@vger.kernel.org;
> linux-kernel@vger.kernel.org; vigneshr@ti.com
> Cc: mparab@cadence.com; rafalc@cadence.com; sheebab
> <sheebab@cadence.com>
> Subject: [PATCH] scsi: ufs: Disable autohibern8 feature in Cadence UFS
> 
> This patch disables autohibern8 feature in Cadence UFS.
> The autohibern8 feature has issues due to which unexpected interrupt
trigger is
> happening. After the interrupt issue is sorted out autohibern8 feature
will be re-
> enabled
> 
> Signed-off-by: sheebab <sheebab@cadence.com>
> ---
Probably we want to mark this as FIX for the older kernel version?
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/cdns-pltfrm.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c
b/drivers/scsi/ufs/cdns-pltfrm.c index
> b2af04c57a39..882425d1166b 100644
> --- a/drivers/scsi/ufs/cdns-pltfrm.c
> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> @@ -98,6 +98,12 @@ static int cdns_ufs_link_startup_notify(struct ufs_hba
> *hba,
>  	 * completed.
>  	 */
>  	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
> +
> +	/*
> +	 * Disabling Autohibern8 feature in cadence UFS
> +	 * to mask unexpected interrupt trigger.
> +	 */
> +	hba->ahit = 0;
> 
>  	return 0;
>  }
> --
> 2.17.1


