Return-Path: <SRS0=kzw7=DL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F4AC47095
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Oct 2020 07:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6EF6206C3
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Oct 2020 07:21:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Emxk9PEE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wtnElEyH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgJDHVA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Oct 2020 03:21:00 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:1248 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDHVA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Oct 2020 03:21:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601796060; x=1633332060;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cuX35NZCxmLaPAE4V+bJcgKNfQtt6XH9TL4RC1ZvbU4=;
  b=Emxk9PEEAXQiSm0kZ39si4mj5CA9YWAMBXwfLANL3UTS6Kuln5Vbqcuf
   VTW7kkeuBgcRhdDLNh1MARo42R9ItIXkpDigATvyUklNC3IZl4uU5jECC
   pbQcV/3mlDE469Gwem34feIVKxIwH3CbiTEeRDhe0a+mQmgEAR+U/U+pn
   tEj5quJ36e8iPBwsjh2bYcvO8spqEsrAFw894EcyCUPbXcPSO4vGqNzH9
   EyjvpXk9ZKDG/QArsHKLt2yKRa9J+omcLkVfKzn6xZcCskTeHlqAVqe1d
   MXiF8+1GXBSuH2wHlO8Idu2B+6KdO85xhEfJZ77INnauS8yJrRZRrF9DS
   g==;
IronPort-SDR: ROP/plRzvZbtqzD+uuSLBuU3lkpCPFEYfLm7bX/3frnCeUlwrifAvdkazSHPOmxcpulkXF+X9C
 zJEOZ787JHvvJV0isQECsWDGe6SUPjR2/oy/pp6h40OoHEVor4uMeW/shMddxXlp7qE2z6aCJP
 k1+BgJOHrxFSZLbb2cimNG/sPivhtt1tZaft2I/Twq9sQekQpCZoB4hVd7f3ByTAwWqLAxvYjs
 IiY7hs+dm4S7wqOw+cx5hoc7TbzCFSTFxlIw40jbHMj4dxsYkb+1a59UukxtoqRrlroBIrJ9yo
 VSI=
X-IronPort-AV: E=Sophos;i="5.77,334,1596470400"; 
   d="scan'208";a="258790465"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 04 Oct 2020 15:20:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKVJf0JHRusRROA/8YPIptxJAoQsg8KPyj4DxSzMIdttMseG6soV166S2TvXHsOM0l3tIQXVNu0cpLd3ADyOdTxSBuW7zBFkzvdi7++xctJa8B4InXQIsiMSeye3ijXZfmk3Yw+AIW3JVfFS2ifC1hwIE8pNiVV/HFYc8bBqVjClYG5BDodjkeomP+AbpkkXYtuyiXf/VIt+uZZTipicL+p0tTi5ZBklHqND1LXHzJg+c5Knyx46WxYTS5esRuxjML0W+wYcgnJILdxU+KkTIQc6TpYuivWAhN0TyspFq0m2sYloY8zcFGUBDfDRLL8TcfB75UmmVyRWX7XuP0MpQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JMDeCMvqmJDQcRNpMXrbpHmIohpislWjU4QvlfEf0Y=;
 b=Svaer/Gn6NEU/dtFvxGhXvxCPt5E0dN40h1MrPSdlZcS/jHCr5ko5BpvlrWFM8vXIMzXKtcHvkWH1I+JPqBtshxo9VCngFaCBFeS8iytBIVSKrpILA8rp7lDS5idaC294wVJddeRwoNs2Umg3stoVqcoUFN4nTk0jmouomrCYDL+Es72X7t6/i1Doe599ix5simpKJiL8SURjxWJWBK5A035gs3YO+KCncPMB5fgYdcXDknl2idheN7DnkGbSDMSHxBsvdMrcGoLr9ZfWiIuRmPtsTUZXN74qg4cEDLGtIUtzPg0zlXOMJ28qrSyitRyaJgPovNvCyyVJL/FWLrYLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JMDeCMvqmJDQcRNpMXrbpHmIohpislWjU4QvlfEf0Y=;
 b=wtnElEyHzp89eJRPibr0lZEeHeDGhHfMRVOTv2pQ6iuv0Mqy0m5kpDl71FSSzpKMOfXM5WVdJgPr0W/QpGSsgUAmpacXGYJlffRE7IZoBzHncdcbiXyXbcr6q7j6FwdnWPe1bbYfwUJ1QZpKKDLwZKUIIDwwTQcbe9chJOQ3IaY=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BYAPR04MB4087.namprd04.prod.outlook.com (2603:10b6:a02:a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Sun, 4 Oct
 2020 07:20:57 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::5567:207e:4c1b:3ce1]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::5567:207e:4c1b:3ce1%8]) with mapi id 15.20.3433.041; Sun, 4 Oct 2020
 07:20:57 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [PATCH 1/2] scsi: ufs: Add DeepSleep feature
Thread-Topic: [PATCH 1/2] scsi: ufs: Add DeepSleep feature
Thread-Index: AQHWmLlX/36ef3l9WEy26/6zpaIUz6mHC2pQ
Date:   Sun, 4 Oct 2020 07:20:57 +0000
Message-ID: <BY5PR04MB67053A1985F6FD419214C6B9FC0F0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <20201002124043.25394-1-adrian.hunter@intel.com>
 <20201002124043.25394-2-adrian.hunter@intel.com>
In-Reply-To: <20201002124043.25394-2-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2017d997-3ae8-47d9-1032-08d8683609ac
x-ms-traffictypediagnostic: BYAPR04MB4087:
x-microsoft-antispam-prvs: <BYAPR04MB408771588C8252D1F80F1F58FC0F0@BYAPR04MB4087.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s9POC3CE5oasXAM5dTZOisNyvXTCmSh7jyS7xM4aOmE4jgsWvy3vJI60GP3m6horI9vcX4TQm1+Dqr8GpFZ5JyMkkET24EDx1LoayBJcn0ZnMp2SOFJRAcS80MkKzqi7zG9HUOjxWEZI/GQnopb7azi6xKPpTpbXxZz3uoTUKFW23dZ2IozWnX3PrxyVijMS/a/6SgrhIt1IJHm3CT21ZmQzi5Lp51U5/zhLfMtwTS0tXuDpc8ShI+vLl5LrCDyiorxHzMTmywbw4HI51xFSwUJhuaJvDnw9hStgKQn9kpsR2dlDvsa0+F4kJ8xScFfJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(136003)(39850400004)(76116006)(52536014)(558084003)(86362001)(5660300002)(316002)(54906003)(7696005)(8936002)(110136005)(2906002)(8676002)(4326008)(6506007)(9686003)(55016002)(33656002)(26005)(478600001)(186003)(66476007)(71200400001)(66446008)(64756008)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wdK3gSo194UOH+55QkWYVxlLr2dHgRIxMdVSOxyRWwsLKHrc+/0gAYQgAkkPfF7wHSWzT/4d5yfCAcd7BYZJ/QB+fEe7Hr3HC/FYgOyxvPd5k1pyxNoWTevYbaWrirW843yfNtwqqW2JOLkXuwDsX5hsBVVzlDrg/Db5D0gRVKl6E1qc/f7z/3vqhgrdqoKLXrSdS7IDMiPv3eQ7+K2l4+FEGrfAIK8N0y/n7znIk+/sX2BXdlfwrULU6am5hyuLKYO6vcu51eEcbcPmHyitXhA49BWF/6FugGYQqToR2x1+sCbv47qq4vQzY6gCPevIWNSe2tXW7IPpgyT0LkgITUi5Si1s2vOT6ofrm1XsA9R8VXFsqIVkgJGRU/6P3mGiwxHfFBleci7/ZsOcoPm/ED4OnlSdRxYJ+Tk6tUaJOgmM+jZp4q918kxRhafyRovbXjkbgzLnXtGgW+vEY+aEf0QO1ERlAthBKuyl/Kmy8YS4t1ux7cArIF4ZtcJKptgIMXTXPRVJ8mrPr4HuQbkwdr4M1NKeUK/8WrH83EbBSLFfV5Jt9op/h+jJfu8kPRkgwXPpKbs8qotBwzUCAq13qDEgbodWQew+MrmQVvyRrOyK53tY4twA5gFKJFo65RYnSMrTP03Ae3DpKatddEsmoQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2017d997-3ae8-47d9-1032-08d8683609ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2020 07:20:57.1295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K2tlhivLrisVkTp3OrOez8o7b3UajKUQQXMowvtrnh03LVQ0ij/YtPSFFq9FF7DbjYTy4hV+mUXdxeKz5mPidA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4087
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +       /*
> +        * DeepSleep requires the Immediate flag. DeepSleep state is actu=
ally
> +        * entered when the link state goes to Hibern8.
> +        */
> +       if (pwr_mode =3D=3D UFS_DEEPSLEEP_PWR_MODE)
> +               cmd[1] =3D 1;
Shouldn't it be bit1, i.e. cmd[1] =3D 2 ?

>         cmd[4] =3D pwr_mode << 4;
>=20
