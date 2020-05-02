Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56B8C47247
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 15:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E22521973
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 15:23:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="goWwM/fn";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZstvIr/H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbgEBPXO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 11:23:14 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:8914 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727897AbgEBPXN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2020 11:23:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588432992; x=1619968992;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wU6Hn1QoFqxgocchw3TXAxm8RfIqCWu7dsHmcejUx0s=;
  b=goWwM/fnJm5tHm/RmYepzkHeP/rzbwEeYRKu6s5i2V320JBdbbF5/mts
   DTGRkcvuJccXQlxbFJsHeOmJPdcSBOMnuUhT54fiNwZm7n3iyJXU+ixJu
   N4oEnsLlFqnX6HicomAyP5WzbKZlbDVxhtJlBf8oQJ93oJodF5o7s6+2J
   vOZjY1ZuXE+9j0n5q+z/Wa/dpN9KgYGvw8QFjpCNwXhPTU3IA3OuQcMX8
   Lbu6HdRXyKp3nJxZxSS3B8AqnWhCPceGvhFdLK5tPDci0F9fjfUmR++dk
   wZZf4jcVZ+WaOhEjRpskk/Fm8kyzUYOGvkCrubXXiXoV0TsLIfcD+KU+9
   Q==;
IronPort-SDR: hWd2HlsXFCzxszpy1PxyEVnKMhdsIc1BJwnZNW1ByD2j6ALevmQHmS6ONEGzV+hbPsdjDNatVa
 XngdzQMt93UYAVGnr9DjuozZo8TJpUYc/1NegPBrXmU/qbbJQrt2YQ1vTLb4dsLjglVs3pkg+4
 gsFHDRjVKe1YmTL/7jh03htwpJeisMq42NMNlYbgb9HtxxtHuVslzrG0/fnhV/GGblxSWfkvTy
 WWH6i1TAfUizwTNI6h/YyPbXdo5QJawtfWPWHsggRRZPpmu8Eu+1pDEk5OrXVOXXORjhqIN4Eo
 SY4=
X-IronPort-AV: E=Sophos;i="5.73,343,1583164800"; 
   d="scan'208";a="136747771"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
  by ob1.hgst.iphmx.com with ESMTP; 02 May 2020 23:23:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbAbIqgTE+41KaZr1EQqDl15qoQxn6UhrozuEVcweJP2lqU9sfcCRrXcXqqKDzxAQJnAzn+Z4FQ6xJdyrx52Ng7/3CmVDMHVMJH3s0tTBRrmYL/ga5ekeYRzkbpDfDNLX9ryZDPWYbj7j+754T+Bu0+lqKqZK147LgUJaMfAaZUQFmYcRjtAwd3TT7KlI42xJpsvhyPPQPvnn0KD3tcZAOvoeVYvzKo/4htTBA3f6bKAq5cHEUBQyJ59Ugxspdxa5hxcPkQpAZ/wlD6ocsNnSUgG/OOlIiO5BoKnpgpOJvh5TM0KsZoGaZIB+vLj+tQpkG6Ami4nOnwjQvb4CZbwRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAarNdY0LRF1NAAYIxwK0+9OV6ZHf4MkhZuZv1qDILw=;
 b=LMZr8o8JURkp9B74MqOaUv6M7sc+Y0W9YefY0ONW3bxXUdzts7VGefCvDMDCXw9g93XOZeafjKUInA5cLlUiDiwaI5MD1KZhn+CrqZNTSbJUR0oQu3w3i0NGP64AMXBqMQsOlV804rbwXtiOjeIDaucMDZUntLaB0EDsjX0dWO+ClR9voHmVXa/S+zyZagP/guDYV2tGrOh6dqJVRpOyzWhqrgjud59pIwwhlvCp1KQTnm0DSjN1gehRztHHYDvT/4FwF6LtK3C8jeqzxwOEDfeC6+A8KcZp9/qwYawoCnUbN1KrSXDFhoNa54HwSbTL1NlR71k8B4zv4jVur5KL+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAarNdY0LRF1NAAYIxwK0+9OV6ZHf4MkhZuZv1qDILw=;
 b=ZstvIr/HBSwheHYneY4i6oDDMwHC2NVgWiFQ/clfS0ZYs1hnH0bAzoXA/9gb5VowbotDrs8OQpShPeJEeVJbTMckVhsx3t+O1rFtR6RNQ5bEduels2gkx9wPNaox4AnFZNhdTbllV2Ck6pXNljuCggx+SvYsutnrW28CzCSpIq0=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4591.namprd04.prod.outlook.com (2603:10b6:805:ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Sat, 2 May
 2020 15:23:08 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.2958.027; Sat, 2 May 2020
 15:23:08 +0000
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
Subject: RE: [PATCH v3 2/5] scsi: ufs: add "index" in parameter list of
 ufshcd_query_flag()
Thread-Topic: [PATCH v3 2/5] scsi: ufs: add "index" in parameter list of
 ufshcd_query_flag()
Thread-Index: AQHWH8Y7hGL68hem0US2UiZWqmAQY6iU6yiA
Date:   Sat, 2 May 2020 15:23:07 +0000
Message-ID: <SN6PR04MB4640D032215F66ED46B4D069FCA80@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200501143835.26032-1-stanley.chu@mediatek.com>
 <20200501143835.26032-3-stanley.chu@mediatek.com>
In-Reply-To: <20200501143835.26032-3-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 85aceabc-e0ba-4b62-98fe-08d7eeacb7b9
x-ms-traffictypediagnostic: SN6PR04MB4591:
x-microsoft-antispam-prvs: <SN6PR04MB4591BB3F3423DD3D2741AAD4FCA80@SN6PR04MB4591.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 039178EF4A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(478600001)(7696005)(54906003)(110136005)(8676002)(8936002)(26005)(6506007)(33656002)(64756008)(66556008)(66476007)(76116006)(66446008)(66946007)(86362001)(52536014)(186003)(4326008)(71200400001)(9686003)(316002)(55016002)(4744005)(5660300002)(7416002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ty+uPANuoFZwLewJ8H5POl3AW0QU2KKb/HT/3OS8tH6ae5fAT0seYhiyUjOD87gVKoEYzJLkUR0a81/V08Ht4FA+5IunCGMm/1akN6O/sHpAZ01TXtdu5G+TQu1reE0EFP8n72lVua5Mrv05xV87LRKL5Oc7dh6xLYmfhp66Ei+LpUS25W7LRSaycWg/gx2Nf/oTWL7uansI2Lsx7mt/mP1YRmeYf7w2yZTXEkVnN94YYWyi9goCMZWsZIp943FzxAntxd+N2EuaYzpiXes5tb0Kp2LwWh0BKgzuYWk02YwQCm+tu16BvR68rywf6WMYfIj1Ts3SGiJPd8SzlN5Dgk4VL3z8bxs/Ul0eA/jMj0uatY2SnsGp8cSlWEOL5zIOBkNPdpM7h7YgHKk9Me6iVytYq7fHhJHvMkWS97UOEn3HkZXXCxjOVbg9YiTBKDph
x-ms-exchange-antispam-messagedata: cyFnXUQQ3eeU7DTCVHmnb0zdNIhO03zLmsRYbzttbiz/hFr7bDh9VWTlrQBk2BCOCptaDkHiGRLigQlcFQLZG94N5DFA6OLrfBV43o7hVSFeckuWWcS1id7+hmdb0mdW4eA3YUC3R1lkgbO4cvWSV3zw6/xcwaplJ++lB+oDQ2giQ4wXyY3z/a56Y6CmoQ++CB9nkyfUO5vIrMERSubfapqYE03qGGU53GugVM2g6jzLNKFum4AMwJww0FDkm927k/i/grYryGAbpPglKdfkXwdRnpBe6aItUyJ0YhWbaN8rc0a3E8gq2YxX7w0szKQoczEr3Ts3f6XutkJtNXQswwQ2dw4v5R7dg7IpaWzRNbtajIZlwSrw0UyJMIAU13khwcJoMgJEQYDScQHBb2B5ouNmvudM7+xXmml2LwxAAKed0QBKmvGQAgzZ2eqeCXF3fcA++gIy0ic7yWn7fIeq4sjHuKRAOyNjkUSccC4Qc16+D1b2sSFNOY22surmQjG4AswAiwc2HUIhXAbFBOAm20Mo+6AG2rQ2u7yzwv5zPY8NBv9Mn1nm+cgITLGNUYHLzKeUJhtyGoB6JuawN5YjuyyjnGlH1q9YBuhWaE8lB4aF/h0Xag4Lpw07/0NVoJzFBR3FglyaA7LXFwjBcyY9LBXgZbXZWsRs2ZwGhihYFA8QBrFWQeLQxlCmBokFrtj1hjAPt7kMUByp7sNrBkgSH03hlS4GpyWywOHg/Gs30Kyab635Xz6kutD4ZGKzCGotC/w8G2559v8d9I95FAzzYiqxBZxGdCFxnGjhb1+XREo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85aceabc-e0ba-4b62-98fe-08d7eeacb7b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2020 15:23:07.8545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JY+WJWnFDrK2bZFiYKgcyL+Mq2DPTytrQZg/AvGaVtsYb1l8C/A6b5/4b8z+i/d9BchyCbsgn0nlqyNRADjfBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4591
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> For preparation of LU Dedicated buffer mode support on WriteBooster
> feature, "index" parameter shall be added and allowed to be specified
> by callers.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

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
Noticed that you are handling this in patch #3 - that's fine!
