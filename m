Return-Path: <SRS0=/6u/=WU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B34C3A59E
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Aug 2019 10:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FBF620874
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Aug 2019 10:03:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="a0rMiwi1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="sA/YPTlx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfHXKDe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Aug 2019 06:03:34 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:16603 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfHXKDd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Aug 2019 06:03:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566641014; x=1598177014;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c73cz6khD4BIgTV4VFwoEQRXCDKwd/zNvpvXkkDvV18=;
  b=a0rMiwi1Z0WSsPk5cxzsW/YRp//MQNZ4ePVV8eQFZwwfjcPcZxxiKzxs
   AqzEgu30iw6siPvLQbKssHwi3VzqwMbXQVf5aLlRM6lPb99cyKDFayPtP
   x7NBqxML4t+rnVs+i5IpbZtY/RrSR9xPJhOHTBYtoilhW2ZDJh+81d9d0
   TBo7TKTER9/4Z8tL7gQFxom+wbjEN1q+KJC2j89stbO3Zwg5ZW9TyGQn4
   fB2wVuGvqVWai0b9z6R0DzFKTEursn4ra4+O40lwFg8wsk0Z3ZGIvAI7y
   9rjwOVf/juQHwWRXPJ9bhZ8Okj5rN9RQaU3nPvOjazAwmF8undQQVtv/o
   w==;
IronPort-SDR: d9Wd0eUVQHLcxL0DEKdstL/b3g7frOddpus7QGiYAwAE23/YFwEoP0/j3vxc1lXB7nLd3YNX1f
 ATDx3uBypAzGpabrqbsJ6AgEfxf89jScWKiA0/IJ7gPwoqJZc4Yg4+fzxl5fN0uhANfqZROaC/
 3lS3I0EdEP2aCUCzBnAEdwV6uF/13cGfi5CPv0kGiqWlJby1pT9gxFDjQm+9eqMNrEIVL2ZtQS
 xx2tBMM6a18lbMmf/orC0+kfs8dpTvjSwUYrc2j/k8FmN54dsJP8FhjoG7scsVCSAyEVu/E0bl
 Mb8=
X-IronPort-AV: E=Sophos;i="5.64,424,1559491200"; 
   d="scan'208";a="121157974"
Received: from mail-by2nam05lp2058.outbound.protection.outlook.com (HELO NAM05-BY2-obe.outbound.protection.outlook.com) ([104.47.50.58])
  by ob1.hgst.iphmx.com with ESMTP; 24 Aug 2019 18:03:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLiWEc37M5KmX1dDJEF1HmwN1CIXc30MrQdiOWl4inP6CLV7CoUtd9NO4Xus5xaG5jzIEdd59PVwycxIeHqATab/b1uSl7G+jQBw+TZYr5pgtIQcVbEj5ZUV81Bmm0hJEN+5RJE9Jlv0dbdUaaDJ1Zntx5p3RDqH+ajmRpLYyjBYyFQy5T+69qmR1xAv7NgCV2/f5+G4VjSKCon0a7O9k/GZhCFvJO7zCszcf/YllJfhO8tlX+eRWm4jgJLi9PU8iUGxBug6vp7Hq2SmnZI34cyzTaSyX/YY+fWStnPXZf1eqNnpJymmDtspXvjV67yTcGxJWeYPCNi/5iOrFSzCgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZprDJJ529TbHc5mSO4thkrU33NU8WGrtQ0XVNmq4q4=;
 b=Mo84k1ufi6BC3ukQ5CV+BOgSGWe7j13ybz3I772wC8zW3YDUDuv4ssW2PgaQr8PJg0CnxpnZf2tj3behjtue7lpnay5zBhVRl9ucg2dDEKaE/WvlXa5lVoXAq2icoDuE9hLRaM4cAkEohLyGz66hpj9Hu1zvOupedkAGL1ENAG5+hDC2ZX7WjkBOiCuEKD88l7eas3qYXW9ifhBqwU6uqCFN7bkjxGr29P1HkmRpq2ShLo3aLlf7zQ8lulcRGo1mNbRpjTst50SnJL0WCp1470mLPJ0R6+5E+dxRkUN41OQ9mAuX+rjATARKre0PAsJnXeFLWAG3/tWOhnMlwsMy8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZprDJJ529TbHc5mSO4thkrU33NU8WGrtQ0XVNmq4q4=;
 b=sA/YPTlxIG2X+ND9qBFiy+xTJhddQFP8H77IS+xqfRy5aMGegMHF9/DPVMTozkOpBsN6Zlsb9CuTFVUaNCxCdumBgfH6pw5XLCuUqgS9imgz/r0XSOnfnOWb8IklpFXQi7dBoIXHwaNgMXkMGiZduU+N/7f/DWSfBINyRVZomlY=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6095.namprd04.prod.outlook.com (20.178.245.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Sat, 24 Aug 2019 10:03:31 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5d3b:c35e:a95a:51e2]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5d3b:c35e:a95a:51e2%3]) with mapi id 15.20.2178.020; Sat, 24 Aug 2019
 10:03:31 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     zhengbin <zhengbin13@huawei.com>,
        "agross@kernel.org" <agross@kernel.org>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "yi.zhang@huawei.com" <yi.zhang@huawei.com>
Subject: Re: [PATCH] scsi: ufs: remove set but not used variable 'val'
Thread-Topic: [PATCH] scsi: ufs: remove set but not used variable 'val'
Thread-Index: AQHVWbxWutHRQVh4g0CQaC3vFGC4yKcKEfoI
Date:   Sat, 24 Aug 2019 10:03:30 +0000
Message-ID: <MN2PR04MB69918EA15BA501FC88FF2254FCA70@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1566569726-75596-1-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1566569726-75596-1-git-send-email-zhengbin13@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [2a00:a040:19b:4327:492b:bc90:1e5:e780]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03546d70-d1e8-47a6-d7a0-08d7287a5140
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB6095;
x-ms-traffictypediagnostic: MN2PR04MB6095:
x-microsoft-antispam-prvs: <MN2PR04MB6095206510CF4D272B43A09FFCA70@MN2PR04MB6095.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(199004)(189003)(14454004)(476003)(186003)(81156014)(8676002)(74316002)(11346002)(64756008)(446003)(6506007)(66556008)(66446008)(71200400001)(7696005)(66946007)(6436002)(305945005)(55016002)(9686003)(2906002)(46003)(8936002)(81166006)(316002)(486006)(66476007)(229853002)(76176011)(478600001)(6246003)(14444005)(5024004)(2201001)(86362001)(102836004)(53546011)(6116002)(2501003)(7736002)(4326008)(91956017)(256004)(76116006)(5660300002)(33656002)(52536014)(53936002)(99286004)(25786009)(71190400001)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6095;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hol4oxV7OMOrlvYuSLiCf7JCF7A5PG8ZrHj0ubfb/C7Pu3yoGLItNNhK8P1TK7h3dVGUpICCUbUBqNm+W9Dsk9eAidw503E1XFVtYZbaLIQwIVet6sM5q/ulppzYsuTDBQi7/NkztLKDOc9ld1DRu4YCFzwsHLQeWfoMmdCXHvqdWXjmbRNItjt2TstOG2yDty5eDtELR2h3XXz/fjXL7lCbsLHFigKCj9I5ne66ylb3zf0q9FJfUdPrGUZ07Q9u774ML7WNkWdc5m7rpt/1SrDMUEKX0jhvkGyH+vMHvV7E0rQX8n0qK0br71+rchUiXft17gE0YQZ/EH1HgM3//65sz6cOdVtImWB/CrKee1J8EYILeHmrCKBH4UBotMNQp9SgI+LQSPLhaxDljUfm6AymTbYOtfo/8Gq7wwkB+AI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03546d70-d1e8-47a6-d7a0-08d7287a5140
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2019 10:03:30.9398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n2WFDEGUawShJ0Ln/fiURG4YF3vdl6+zreVttDIBqa6BU1StYYHckTJBauM4vjp36JS1/RmzQlPVP7pYcQ+u6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6095
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

nit: you are missing the 'fixes' tag:
fixes: 1e1e465c6d23 (scsi/ufs: qcom: Remove ufs_qcom_phy_*() calls from hos=
t)

Otherwise, looks good to me.

Thanks,
Avri
________________________________________
From: zhengbin <zhengbin13@huawei.com>
Sent: Friday, August 23, 2019 5:15 PM
To: agross@kernel.org; Avri Altman; pedrom.sousa@synopsys.com; jejb@linux.i=
bm.com; martin.petersen@oracle.com; linux-scsi@vger.kernel.org
Cc: yi.zhang@huawei.com; zhengbin13@huawei.com
Subject: [PATCH] scsi: ufs: remove set but not used variable 'val'

CAUTION: This email originated from outside of Western Digital. Do not clic=
k on links or open attachments unless you recognize the sender and know tha=
t the content is safe.


Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/ufs/ufs-qcom.c: In function ufs_qcom_pwr_change_notify:
drivers/scsi/ufs/ufs-qcom.c:808:6: warning: variable val set but not used [=
-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/ufs/ufs-qcom.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 4473f33..02cdcef 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -800,7 +800,6 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *h=
ba,
                                struct ufs_pa_layer_attr *dev_max_params,
                                struct ufs_pa_layer_attr *dev_req_params)
 {
-       u32 val;
        struct ufs_qcom_host *host =3D ufshcd_get_variant(hba);
        struct ufs_dev_params ufs_qcom_cap;
        int ret =3D 0;
@@ -869,8 +868,6 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *h=
ba,
                        ret =3D -EINVAL;
                }

-               val =3D ~(MAX_U32 << dev_req_params->lane_tx);
-
                /* cache the power mode parameters to use internally */
                memcpy(&host->dev_req_params,
                                dev_req_params, sizeof(*dev_req_params));
--
2.7.4

