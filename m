Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758F5C433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 14:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55F252070C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 14:03:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NhmRIhcs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="CI1xBdO+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgGFODZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 10:03:25 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:25794 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729140AbgGFODY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 10:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594044203; x=1625580203;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EalPNVb0Vw0wWP9U9qmkWyocdSSQ6L+t2j3YxTZvkQM=;
  b=NhmRIhcsrZKQuoFc4000QozYqxO1pGHIkkPUFTadhKTe1l/HHJJy6JWQ
   YfgyxZ5CfEFkHSJhEIAMO9rLsvxhiSndD0vT8Vf+GcI7VdFT5QbhpXS47
   oyQ5IU5HWIfLWhpDl3DjDlOEcVDGPAXZb6rPic6lpm84zD7OKIwktiwJx
   uSXhuXVfSq/zw7/By3UmBzX2wHeKteUqCgKEwTW3sh5Gblu4L9nvqZ0OE
   qnJKkPqRG5ZbfNq7gDm0hylZB+ubYiCtBAcYttLSLEqSbS632mKn+hOUd
   kCNHXu4u6L5wKQD0b7x3bJDI/YybowFLJKVwrm9dYOuScppM0NgGs/F3V
   A==;
IronPort-SDR: FMP4oi3EJnmEit2egD2iS6SB3flIoi8mt/6PY8pmsR5mum1s7Q+JjHOiX2Sw4/DwFpKmFEMvKG
 C4wL64+GWBexL+SDi/KdZkDSbmzt0EXx9UkxqH3XfICh3kv0pEijvP3m07Be3axox8ISWAofcw
 e1QDMGkZm0HmIXK+2VpQCy+vdnNXCcd7c1i3n0HEq4SMK134p2XNcEg46GgAIg8MnaKc6FGXwr
 fEW0qer/mkVG1tM4uAd0VvdmIe9EUz6771QIHru6jEjJEE/FbXjHznTYy9MKCtjuw4OEqU3pMw
 +Gk=
X-IronPort-AV: E=Sophos;i="5.75,320,1589212800"; 
   d="scan'208";a="141737316"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 22:03:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yq6IiijucBXvIAzYxjz6W9WluJ2YPN6Xfgsp4mFxxXk7l3lnmM1RPpKi17MQ9a+UZmA2+6An8RW0PbH+s56FIQ/+90BeCkTcF0EnszQHWKZryZCPqfPc3IM+3TUK0MBYyic1hs0VdwJ4i7dxMVctQizGLAwv/pkjuljiWcYr8iOKzAqxAZ2Nn6XLiWpeSjAcGSE8n41h7HYPn7b87wYtv6O8GotsGkCUyTDoI08GY71eKfrF5+e9I2eUYyRtqRI2LnccwmH9KdXXGgGxluBSHxr6TBrEaN3X1rU0znkgaNWeKp1HaLk6i9rSQCJ79YqjHuEsXt5j94MAdOM+SEENcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EalPNVb0Vw0wWP9U9qmkWyocdSSQ6L+t2j3YxTZvkQM=;
 b=odQUvLb4zJa2yDfZ3bzRTguYg58C2cl4KRI6UA9PZ4FIUZPt1BpF4tfu3QZcdH4s5BIjYVGPEQED9VnjSxgsX/Fp6peiHpL4fgmvhmr8WHnaChIvncPOxusw5T4i0IMNMoK3/38NOuLaivQfvGQhA3QvUjrGh3jwICq3fSxKd84TpbpPLegPXEVGvwBy3GvUFSqZMrSLcYASajS71jcvNUl18Gl/qd7+Ex/TeNdxWlioNbzotJiNPe9DiQKS76gKvEGyiER4AYizvHbPO2lzy2QfuJtvzYUkwiaOXXkTH5DhkBb9QMpGZ4t4k1nKEBB1ZUozqs/DD6KRhdRRi1dVXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EalPNVb0Vw0wWP9U9qmkWyocdSSQ6L+t2j3YxTZvkQM=;
 b=CI1xBdO+ntNnI7bFmCGDHTlwd8EMRJypYtr80XVKmI2iP8IKEYFTC9xkt0Z+4GnCBPahxcQ3Gk/48vhyNA8OHFd77ZyJkU/ZcJkVJT5PhcoUYI+57N8h1ue+4lyWvUC5K1WZed6FKEsH7747gLU1OEac3VVBmFRamdIQZVXS3Kk=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4269.namprd04.prod.outlook.com (2603:10b6:805:2d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Mon, 6 Jul
 2020 14:03:19 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 14:03:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: change upiu_flags to be u8
Thread-Topic: [PATCH] scsi: ufs: change upiu_flags to be u8
Thread-Index: AQHWU5KOk90XS+bzbEu6wOOwVZOt26j6lPUQ
Date:   Mon, 6 Jul 2020 14:03:18 +0000
Message-ID: <SN6PR04MB4640DDD8167D2F817DD4D4B8FC690@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200706123936.24799-1-huobean@gmail.com>
In-Reply-To: <20200706123936.24799-1-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2f1152ee-a0b4-4bcc-d20a-08d821b5561e
x-ms-traffictypediagnostic: SN6PR04MB4269:
x-microsoft-antispam-prvs: <SN6PR04MB42690D09E26D1F479132A007FC690@SN6PR04MB4269.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 04569283F9
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zEahlyy9NoVkBVQaLRsvi9XwxejFHS541R4aXAGbMKgjKwiJFvb1p6BX7Iobvm9ouSB4OoTqlGw/V3FFZM8B9qK6Vbc/VczhkJHt1R2PJKIG7FmnhneIyfpUqWGQcYC64g3o4Smj6Tc0/n6P+eBdTbyPFWguZf8rw/uYlrtz+NLLx5qvrVnHv9kDk3k+1w9Jjky+oO0vHj7e5PiwGkOPwGIehfXN552NIQnEoEGuu4+WN5hHHGar6jywL8EVeS99BAO7LvxtBYQ3d4NOQVf72+F408f3tExwXzrXGMB8WvnMnEh/GbXLyGGgLBbDsU5aW1YZwTrWo4FzMZPeLJiDVa/l9sINlbYfgcGl18TIKPLg35GDGC/vTAmdFuDqsa/V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(54906003)(7696005)(8936002)(33656002)(186003)(5660300002)(478600001)(76116006)(66946007)(64756008)(6506007)(26005)(9686003)(55016002)(66446008)(52536014)(66476007)(66556008)(8676002)(2906002)(4326008)(316002)(7416002)(86362001)(110136005)(558084003)(71200400001)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: se7X20Quv6C0eW1L9KQ9HBdfHzDkKedIAESu5ulCVmeLvcH7Aq9nx86AUrzW4ClWSEHhUgiTIC1LrQfDUm1yQq7sGvW5Gczd182qZt6GQnwIHfy5jiRhK2utWARKv/FbKEZGF07V82w1DWZFDyoF2EO7o9vsRSj6O5nyeKgGr8Ri1yzRojgKNP5V3Z9APAPGGmzLNvIcfVlTonvcme8QEVmutkAgYWG35tXxoQRLjkDyQQSmNXt6l3Di90cyFQO+2Zo3p5nAk2oX0VdzKu+8YJVcGA3ltgikhSd4ZMPFw+NcZqxUdw1mB6+ftI0Oy3DW+M73Qr0iXxpebDm0p+wRxnopoZgTsJXgkzD+5jLQtdBvCe52rmcXK8DmQotVLMwNXRn+610jZTTLNmRO/M3VgoxwREx1rwVfYQr4tLriF7PlUTBvEQLosBJiwS/t1LfKwZCOG7AXEYyhYMxHl9AWP9qj5I7/m5wIbYFTGCwOOYU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1152ee-a0b4-4bcc-d20a-08d821b5561e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2020 14:03:18.9433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rZwrObM/Iot2xRu+BTWYIWIHK3GnivkOkG4Snq8mdx18+vPgHgmwxFbiAGon7TA6LwU7Tfv3QRk3FczEfsMwtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4269
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> According to the UFS Spec, the Flags in the UPIU is one-byte length, not
> 4 bytes. change it to be u8.
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
