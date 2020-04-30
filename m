Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD99C83001
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 07:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3F87214D8
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 07:56:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nKYxepLp";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fUvjuy6D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgD3H4l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 03:56:41 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:18025 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgD3H4l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2020 03:56:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588233440; x=1619769440;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AHpPHIdSCuLujDbRlpm1jzx8b1L8Cgq7g9RvAvcpuwc=;
  b=nKYxepLpMPhR/vMQEJ+qNxfK8c0zilJohL1Rbdc2zif1miFxzO77mfeu
   ZiyrroifoH6H4XKkoX6s3jtO6/3LP6MhJ3GrvP65g8RUEhEH/TQHnbCrX
   P7KU2NQeAsiVVdUyesGEwN8pKiF+WpF6fjtTC6UdVD56W8R30T00nRqji
   3WbnKMQ/AWg5Zwh64KXT/IRpM3RGQ20+VdAvLmD510wtXICnhz/NZy932
   eA9QEQrByfT/IMGT/mLfgQ2E7ysrTAWuD4MRr3zJ0jPzFkxwivKIrbti+
   QGDyWr+NNRz/8pejkjzdVguYUqtusVYv9Tr0sHXLGb+Mvy1E69metgs5b
   A==;
IronPort-SDR: 3F5NKtOXOCF0x5VCuKwTzGSrAIB0TbZwCAEDqiSro+5QL0zZ78L687QAsBK0Ui0gHGkRThezYP
 GsjFFs+SKNGmaPmiS5FE2mNujx+QXZY1OAHOo/OA82udAbRnbt5J65rKlReOE9eoN4nbvQ4vYV
 wZtgup+okvgSYkkoXMj05fJM0+1S9iRNr5UUR/OkhxRnGAb2eg+xCJDOic59+fY0DbS0yYchsj
 PGbg1SXnSC7fvmB3imCK5V4jAnaXUncVu8761BSmrlXbiznGVEMSV7dac8LdFb9waPcuZLK1iR
 UeM=
X-IronPort-AV: E=Sophos;i="5.73,334,1583164800"; 
   d="scan'208";a="239114168"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 30 Apr 2020 15:57:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1HqH13wKTwyRsRTI8HcfBEczLRJzIXgTdlcxfvWDI2uGvHdNPiD65LUNoxOBA5hAATRgDjwNPuCn91bZey4qaOKmL0m+W9RT3w+LkWOAkb9f6PeE3aQELkEPeVoW3Fwf0HwNb0Y+ZWFer6E5AKtt7e/3Y9LpE3CigapnieRyqA/0BkqaeARJY1SNuij0zaFY73tJTzeOvMWHDFTafghld95XlWg/CoRzJACRIHxcIjk/piLyz4QGgCHK07CkBqYDIgDdDIrq0xLs3nJItSfMdZFOriuunGkK64XpFKPmnnQ0DqGe1bKc9P+adNRszOuLIoiO0nfGSCbTOhbZ4/BnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8UElqIP+1Ir7J7JyIb7PNo8qhgPJylq0O8p+oEqkSo=;
 b=X/cByvFiCIjeyNi7OGAkRESAvLHdYKN99ptYxUJyqDJR97aroRpcDyco1q6fSFcdDpyjI2RKV5NM+4Izl4A0iRzS8uJ7N26tqCF80QgALDdD+cY/iZbQ1i1veTICTI+pOJnbPNWEDmp19XCvIUFPglAZE0cd91UBDtzAE9F2LUYMA8qvCdLwNNxXD/mzZN2VnDf1ZO/LuBMAHn3idNCKxfwCdkTzfDLzIq6m+Vi2s8w6ghZ31dixKVVwlY4fonka6ihp/tg9oGmRjhURoWUVK5NELaHBcHpBBHtpFwwZbrA22VAVm1vrf5oN4ISdpTkhTWUSe9KqTme/jMg8dkYpdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8UElqIP+1Ir7J7JyIb7PNo8qhgPJylq0O8p+oEqkSo=;
 b=fUvjuy6DBl6rnJuTEa3zLMBL2JS4U1QQ8J0v7mFywJgUTaygVVf6/lW77g4egk/oNxrHk0/TfKyD5sTR/cx3NoPOXyQ6+PyoaF1Fyigy/N29F3K9FApXF30DBEQfXmHGWCPiTGeuBIxMq09CWWjZzfl3gm/1/gmfjDq36S42Ew8=
Received: from BYAPR04MB4629.namprd04.prod.outlook.com (2603:10b6:a03:14::14)
 by BYAPR04MB4662.namprd04.prod.outlook.com (2603:10b6:a03:14::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 07:56:38 +0000
Received: from BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1]) by BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1%6]) with mapi id 15.20.2958.019; Thu, 30 Apr 2020
 07:56:38 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v2 2/5] scsi: ufs: add "index" in parameter list of
 ufshcd_query_flag()
Thread-Topic: [PATCH v2 2/5] scsi: ufs: add "index" in parameter list of
 ufshcd_query_flag()
Thread-Index: AQHWHi3/YyJYvbtdE0K1lTCqV5rChKiRTEmA
Date:   Thu, 30 Apr 2020 07:56:37 +0000
Message-ID: <BYAPR04MB46296FE5C0C4AE0CE7B24478FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200429135610.23750-1-stanley.chu@mediatek.com>
 <20200429135610.23750-3-stanley.chu@mediatek.com>
In-Reply-To: <20200429135610.23750-3-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 494f130f-cf2c-4200-2bcb-08d7ecdc02e5
x-ms-traffictypediagnostic: BYAPR04MB4662:
x-microsoft-antispam-prvs: <BYAPR04MB466236CAA33BF86F8D8DC0D2FCAA0@BYAPR04MB4662.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0389EDA07F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4629.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(7416002)(5660300002)(66476007)(64756008)(55016002)(66446008)(71200400001)(4326008)(66556008)(26005)(76116006)(9686003)(316002)(4744005)(8936002)(66946007)(54906003)(478600001)(2906002)(33656002)(6506007)(86362001)(110136005)(52536014)(8676002)(186003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Iqq0kXZHFiTy0cTKwArrfJ37mABwagaCB/ATPWYFhUz2wC1m2AGU7i+HSb8WPp9K4kQecXdzPHbDnpVKuEU5zkBnijHd0LtbIGt1OL4xG6lUI8RS7/FnYxZVQVrIOFfOewBkeWUi2P5Vw/GFe1/0mV0rZvqEg+Ys0kOA28a/YbIwEAi6QVf3npIVltjsUpPv4l9cpHWbq89V9Ksacibur+lS5RNFSPixhHD5WmOzWHJditUSdO3UyBqG81C0j1Wx4YDv2Ylb3weyTb3ZJugi6Ub+UwjCTMQGt6hFA4cTlFY/9X+Fm2kKwzwZYYYWRCtUEvs3lOY9EQEse6VlLP/MROAMrF1JvTqYRvsgQpUu2+4hYrU+Sof6pW5Sf4q8on3GAsTGlBn264NWe1wJ56CPDuCk9wTByIIlAKvWlzWZlU2R4UH+e8L3ZmAToJToOYFM
x-ms-exchange-antispam-messagedata: BDGB7Tv8st4gCOAxIvuBOwea+iI++TnjB6H1IImfuOHXE6Zp7y9qh63oazGiuQy3westxCKNff2EsoefhfjHa22imzGN83y8Ks1W7rO5ULA1yzOMcxvmrMtyaBhJHiw0vjRHcIt6NJE95NQQSoqSOXuOhG1Xt2PnMIv1CxWNd/3ZNxUhQ/0/sbuK5PFZqpMTpawpxvjbTW1IDZcc0V3SDwi4rYB3kpZJ5DpbOG8g9BryV5ZyK3PhNn47O3JnB+SMkbGqGspajQ24yJzSyVmVMmKkaI3jORYDN/nDk9iDRlRhTBn/sCBEgQsqcHMpSlh7iX+cjflMcKKeMCBGcqVMEYzxuMrn3z417HlBULDqeXn6qBtljYoyl9PqJsvO7Z9f99i9l1dJHlInKboHR+SRGRi6+KTIdQW3WcMneLDQpxGX4uu12dtk87LwOA3DV/Kjbq2N2Szq4RveViIqQDbTIV67QMjySKyDpgwCbYr1aeeF2Qvtns0cMMmJ2ni4QwYuW/+7h+6tcAOmIdTN+0/Gka2PPiT3gnR3vT4ZR4nFmH+XaeMQjaCXrIr38wbaK5HlbbCM3/0TTs+pgwnWdmaCY6UmdrutKRH+L9PNhfmIaFk7NRztJu/CfCPnHsxDWmmUtiLYtFX/A9aUOlqfJ+iSjvCYaLVF0zBW2oU3ZVVEsztY7pKedSMTFKGSH0z6e+j69i4UF+dYE3k1yiEA33oN8EESaHgLasa+lr3GxdVk768bVhiDKr4UzO+N7mDvA60g5lhh5Wm2p8CC08uauAjuJDdlxUTY4w8hTWk0v/45Auc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 494f130f-cf2c-4200-2bcb-08d7ecdc02e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 07:56:38.0558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c0flrD3Yb0gkolSR6+ug0FXokJIY+mtas+EOkooCHuNfMiZ2OerK/cyvW0jZhuHlz0Z0L74onz7+gUixf8cYlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4662
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>=20
> For preparation of LU Dedicated buffer mode support on WriteBooster
> feature, "index" parameter shall be added and allowed to be specified
> by callers.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs-sysfs.c |  2 +-
>  drivers/scsi/ufs/ufshcd.c    | 28 +++++++++++++++-------------
>  drivers/scsi/ufs/ufshcd.h    |  2 +-
>  3 files changed, 17 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index 93484408bc40..b86b6a40d7e6 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -631,7 +631,7 @@ static ssize_t _name##_show(struct device *dev,
> \
>         struct ufs_hba *hba =3D dev_get_drvdata(dev);                    =
 \
>         pm_runtime_get_sync(hba->dev);                                  \
>         ret =3D ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,      =
 \
> -               QUERY_FLAG_IDN##_uname, &flag);                         \
> +               QUERY_FLAG_IDN##_uname, 0, &flag);                      \
The sysfs entries for flags needs to get an _index argument now
