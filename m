Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC109C4741F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 09:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5042920719
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 09:40:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Zmqi5duU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gk3fru4w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgKIJkV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 04:40:21 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:62779 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgKIJkV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 04:40:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604914820; x=1636450820;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yZFd9rYFbhcaopsp0mFntPprl3wTwi+NEi455ei16mk=;
  b=Zmqi5duUe5fXfiEpcy2Yf1/6/xKDwTRGxj5Up/rEMulDFz2Ey1tnxQzE
   FUOQgo1le3GvX8oxE6yOKP5isf1kRzuz5gVNpX6DAl5hdnsLcP4hS2mVz
   1+imv4h9cyCblSG2DV5w512/XNgp9Kp8FgpUXJWp3wFJxeO54mE/htAEo
   7pqU+cCQWHo93CgF8I9hRrFSOCPX8tZFuDZAMP5xMhqKqYMANJiPKZeep
   a312brGMdktZdHLGVMHHUQtKZNE7VOYdNZ4gDzxWF3Qcu50KM9pHPVPeg
   YYZ024BWkDkmHR8kLJIWcInC7Bsasoaq5JSmSH5gUx9wB+FWHicA9NsI4
   Q==;
IronPort-SDR: wib4g1mHxq/z24SyDmdd7Zah0UCZyl42JUCvRxSaT1vmzxdPxj2sKhe+e6WAeTvpO4/BFzQd+m
 HULzTCjXdJ7IKuOYg1ShpGozSUjPunIkbPKaBjbcehf29P6Yvb1HquTcGkq1VOaWovi0Ml3538
 M1eIaMIMIzpD6WvvgJyw4oBPi6i0VsgpRlq4g81zNevk6NQlkeLMgg/HybCNdd+HqPFnCsUQGM
 OyLrbBV8BKgIoOGuGSqZZZnRX+O36PzrcR/J1GsjX2TEECNBFrzzBpoMa2oC36+hYncvGQO0lO
 2mU=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="152280282"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 17:40:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8qYcPp8Q1rUiFYdTs8CJDZ7oTt4CGebxqTbRNcqz1pzHNXeS4ky/czoZVdsxhXhN6nDbxZcjj4taFbSPmHUeYsg3a2iXn7Bm9tz8+xaV9JHiIDOvzjekkrMuZb22PhTpIMMHfpp9v5gO8AgSbVksuz7+0Q+mDnX+YokJTrdeKG+MLZtVbfFn4Vu3WdAowDjXvxO3pnMNZ+N1fUAsLfvabJUZJ5wzktGxKswUX3/UbLlj8W3l1T9Etecu1f370VBGR/b54/yG7qyPEXzMVHlkCGNF9ojxnebnjSnMrV526SOrutUAawAI1izPsVPLBdlfP+x1a7m7GDPKSgb/0sFHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oskJtp0NJPD1w3JBbs4xZOqBVR8qCqVoQGgRYgdLBPI=;
 b=mCxUKNCX4+Yv4Cc444o7x6HWrCVrps86XaCY7W8ITc5WVL0hjAvNxI6vyKqa3W6Aax/YI1oHYW06CfB8HxuFbbJl3xkhrVR6GECCxt7+ScrK1hxbro/w3pDvjJSA/Q1C8AfMvbYq+3k9DCiqKCnGRYwPuXXJPmQpsa9qwyRX8GK6i6h4jcnCqLX9qP84D1OhLiYESeWObRkvfAjgY1Q9hwSmFvC0jVDyXbqtr4YIypfzziNAdTm8gvUYvjHvYnkp0pJeGnnVEpD9POMdZs2Vlxh6apJrVK18Wbe0s5o86PK7BbbWBu+d8w27TlAkMLFrwCUe5xd5rhfemGBtznFrOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oskJtp0NJPD1w3JBbs4xZOqBVR8qCqVoQGgRYgdLBPI=;
 b=gk3fru4w+Vjf88RoPIwMmot60Y0AEqFcnSLCztey2ccw4mFruS6Db961a4dvk79iocHF/rjJORGLfkJjxs9uzr8l6rIZeLfzBP9t5NPKXO2QWyk6XQ+TsK6dY1Q3ZAzK9SoUKyh8yBoy+DE+0o7MboQpkyYFhr8z4KTAAIn/n5c=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6649.namprd04.prod.outlook.com (2603:10b6:5:24c::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 09:40:19 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5c59:8281:ef4a:3e2a]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5c59:8281:ef4a:3e2a%9]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 09:40:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufshcd: fix missing destroy_workqueue() on error in
 ufshcd_init
Thread-Topic: [PATCH] scsi: ufshcd: fix missing destroy_workqueue() on error
 in ufshcd_init
Thread-Index: AQHWtngnTCWCeI4B/E2rY8FB5xQMBam/i4Yw
Date:   Mon, 9 Nov 2020 09:40:19 +0000
Message-ID: <DM6PR04MB6575DEC0E343A01B1A4D275AFCEA0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201109091522.55989-1-miaoqinglang@huawei.com>
In-Reply-To: <20201109091522.55989-1-miaoqinglang@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3c6b7dbc-89f6-4286-bba3-08d8849378be
x-ms-traffictypediagnostic: DM6PR04MB6649:
x-microsoft-antispam-prvs: <DM6PR04MB66490707425ED26716DD8FFDFCEA0@DM6PR04MB6649.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:175;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ff0sALKvpFf3zalxhnORZeUQiFY6PmgatTkaIHx5yAK48C8C3mZWCMmwDPGBDcl9Suf7EXuHZGtR5MiOqUpeLwSsDE+uVxVLls93gvSjomOqyEXuxYPgpULnhQ4Hmrw7KHdJBl1OcpMXcpMmaET8/HkrsS7ojvFkeM1xc+cnjxX/CwyFIYg/Bmmw2MRcdYx0QmFudTl9aC9oyZrPepnL6Qzdc+SqU/7b/xgsM4/SVGELu1KQ1SHdhCEuXFIKGpA/MOnYFtkkPamOC4zjP3+x2+wTxt2XQoed3Q7DG1mNRLshpXbYrDr/6A7xSAOpXRgvuoFKS8X9Arkg4F6gTysyIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(71200400001)(7696005)(6506007)(316002)(110136005)(186003)(26005)(8676002)(8936002)(4744005)(55016002)(33656002)(54906003)(5660300002)(2906002)(66446008)(64756008)(66556008)(66476007)(76116006)(478600001)(66946007)(9686003)(4326008)(52536014)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UhAeUITqdN8b0N/8oSBnhZRg4HdBJPjVyc3DNReJDt36wF5v/cReCFjOnI6uktBlCNmU5kEDe9pLGUmfnztiuerskRnhuQ7R6fjeakmBoiS9tA0lLqzMOq9Y12ucUnR8ElfW5D3h5blmcP8u/S+bZf8HRxlMBfauschTeITl3JgC/CWLcwEcN3cipfDXrgVu+/B75EfqLonyYU1hRH3niXIvDr5BvFASPMH2gp6IbiPr+W8xhY55wQ26cVFpJnYqUCBwXFHuOwCE/S4i3AnQPUrCte1v5Z65vcv13gLsyzEAVaL0K/Pc61/6j7xfN9TaGx8+gSSWngAObcB8cy/yMbBU07mS/NU9AZRQZmSPmFAOj+LZ2EOJnSUY/vqQTjyYyaMyDXEwge+zQkfoamPU7WDHKWYAjmJlSfpZoNLKWJ85ftxgwudiBt5O8KsaicLKvDasab0psKJuUpAh1tuoopRYnWLsxMQq6IIztNC8wyQLDWvYKHGgTskdaLYMyLywRS++38QZ3QSienTwcQIq8BYA5jn29AbQ0aS/EN1KgvuYAhAx7dmxpJz1jbFa63K0kM2OCKAt/dWA9VWDtzFHIWFmwqZ2Jcz2LPjsd7XCNISBFDk4NQjM77ftG2ayXtx3UiMArTluy5AqaAIhRx/MMQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c6b7dbc-89f6-4286-bba3-08d8849378be
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 09:40:19.3102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uSfT6+x3qwPq4Z6LTcC2nKBmWTBdkHeCiuUssfsyB6rFtjSEuDyqi4j0OtnTqtwwWuNnuIq65Bnwo13Q/7pFCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6649
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Add the missing destroy_workqueue() before return from
> ufshcd_init in the error handling case. It seems that
> exit_gating is an appropriate place.
>=20
> Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and oth=
er
> error recovery paths")
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b8f573a02713..9eaa0eaca374 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -9206,6 +9206,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> *mmio_base, unsigned int irq)
>  exit_gating:
>         ufshcd_exit_clk_scaling(hba);
>         ufshcd_exit_clk_gating(hba);
> +       destroy_workqueue(hba->eh_wq);
Maybe also in ufshcd_remove?
