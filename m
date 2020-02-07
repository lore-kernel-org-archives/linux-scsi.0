Return-Path: <SRS0=jGTy=33=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BB1C352A2
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 11:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BEBA21741
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 11:55:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jkCDTx9V";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="H086kTvO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgBGLz4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 06:55:56 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:9591 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgBGLz4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2020 06:55:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581076557; x=1612612557;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DB5++TLsqiEYNZ7sVKjF++7nd7BHKcB43692GluI65I=;
  b=jkCDTx9V4pMMSklsXvlqi22Xb2IQcUEBlayJKW0WapNSiMCTzhzWPtuq
   KgZ0l6mnnU7NslsA5aUei14ATPZSacyh6urY4m+9Z5uCxdkQVflDby7kD
   Y7UsyoacI+7XI8vZtXACjoq3Blaf1aEVWOkfr4aPTSKwkXuyZ2FnaZ8z1
   LA6TYytgooDRMDT35Ph+OvNM15o7Xr4vc28HOVok7QfzC8yElpeIeG5Wk
   pRLQcq54hbNDw2N243pE6594cFQO1PXvnZl/joGmPx1PUpgoVS9eeA1lX
   BalAnX5C9w1DYRS8pxRhZqCuL4F58ithEVsg9tUMz8mZQ+uIIviR7PONa
   Q==;
IronPort-SDR: VwKY7aO0i+E1NOr/k7ptb/qYRZQovq406PVUrzMMhAynsYTMUYXK7r9YDcKv7JgHQ4WnYiysDS
 98aneDo3GKSrI+O9RfHdfFuPlpY7Nm6Uf3aP1Px+cFxqEg9OeNJ1cHHgwPM79M/UUQRLsXoe5N
 xNYiQdegj/JDinXR9oDl1a/rqgxitrYJjg4fVX3I7UQ0VIXblXjWqn7CdwMPmfBUs/k6aCgvjy
 +f/x7aMh3/F8wM7OKh9aQ/n+8v8itozyzkzZeXLLIVwjcsN0THi2e0F0TxencrqePXbDcLOCYY
 ZCY=
X-IronPort-AV: E=Sophos;i="5.70,413,1574092800"; 
   d="scan'208";a="133698483"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2020 19:55:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDYgp/MNuyXaPkMVLqIona37jrtiqX0Ht4m3sTIxYS8iwHZUFab1MVxHa+KkWmfBRlYM0JxKqWHpDeM41BjhfQ/P+SF8GBQ2IuzCE/W/Mle0jkdlxDnaRZQMSl4ApbAxDM5SFHPidPeWfLjOZTKJ+lETp9roUvsCNIaS4hlQ+FXoAui7/ClciFJyqrVTAKG3cwMyKwlFknBM5dToBEKjpSueY816ScTC5NlqVCDijqbaVJvJAGEYjVamBx4Fz+KUO545LMgCOzAsv1IivW2GV/K8/gcR7e+Fn198+uVBzE/2PBvQ6NJfYWElXm5hTr41cHq14TNJSiehaQQ7uQZq5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DB5++TLsqiEYNZ7sVKjF++7nd7BHKcB43692GluI65I=;
 b=T89YWC2oEu81M/JyjhBDu9J35UFccBBINkxQ/uXzCPFLEHDp+YN98vi8tvs1K7c92/eBkeW8CYDfdv0vdNomql2hWbYQYETbe7yJiOD8OXviutDS5UjH1yJp7mSNW6Vi/vjF4aKoRL5+UGosGYWSnoXK+MKn0J8jkbSHuKbxiNRRcGPNKTXCQ0EfU+XJsBtiSk5n3s4jxz5LryoXOVjkiHFTeXDJH4mJzxeg9ge81WnztZ+UX0/i4ir1WESmHIKG8sB6AWatTO0Z7mGwsAM0LZViwex8ds786UJbeJOJD8ryzEgjFXDnEPiIto4mngPYqNY/Pn5ucri1P3JABWCscg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DB5++TLsqiEYNZ7sVKjF++7nd7BHKcB43692GluI65I=;
 b=H086kTvOqMYanN2ryCF7CwY+iRkF4+ntPt1g5jFHimDb0Rdl8y3bw6QjcZJPATqAh5y3NRKVBYHSnUndGV0fS1mzJTJ0PL1mpw1i+A/+K0qbO5qmPL5SWUIG4yUafK0YWNEBLykb2HfB/Qft/oi5dqlY81NSJqN1JWQ64MvkT/A=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6880.namprd04.prod.outlook.com (10.186.145.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Fri, 7 Feb 2020 11:55:53 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2707.020; Fri, 7 Feb 2020
 11:55:53 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
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
Subject: RE: [PATCH v1 2/2] scsi: ufs: introduce common function to disable
 host TX LCC
Thread-Topic: [PATCH v1 2/2] scsi: ufs: introduce common function to disable
 host TX LCC
Thread-Index: AQHV3YTLmKd3QNgd7UGc9fDV0CDqxagPn8Hw
Date:   Fri, 7 Feb 2020 11:55:53 +0000
Message-ID: <MN2PR04MB69917CBE43A3EAE2419B114CFC1C0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200207070357.17169-1-stanley.chu@mediatek.com>
 <20200207070357.17169-3-stanley.chu@mediatek.com>
In-Reply-To: <20200207070357.17169-3-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.137.114.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d91ad029-2412-47f1-eeb8-08d7abc4af02
x-ms-traffictypediagnostic: MN2PR04MB6880:
x-microsoft-antispam-prvs: <MN2PR04MB68806E0292DAB561614DBFE0FC1C0@MN2PR04MB6880.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0306EE2ED4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(199004)(189003)(478600001)(316002)(26005)(54906003)(110136005)(86362001)(7696005)(76116006)(66946007)(186003)(7416002)(71200400001)(81156014)(2906002)(4326008)(33656002)(55016002)(9686003)(52536014)(64756008)(5660300002)(558084003)(66446008)(81166006)(8676002)(6506007)(66476007)(8936002)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6880;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BdokZG4t9yypQ3VsBYsSCisHrK9cTsvF/FOw2HdZNBja9u4jpcly7/s5n6Y4vEwxZ2mJsjJHBTQ+AuC2sgWb+9ScSV6drG/M66fyGnVj3VHCA7mTjqyOH4QsJUQA8+Kx9UkqMIOykkWVjd1kGftwdop/10xzcxBP559qhfh0GnldhI1Zcy3EL4AEc06t0c4vo56DVGhcYuktbX5mImE1ivcGaG0X6w+sO5xYEXaxCPd8hAWw6bupCI6KjSC9dKUNP/jV3EHK5dWAlSy6nMLEAGq8vy59imHfTNUA9DZ830MCuywpAbUDFAUBzUzbWDAXeWStm7JC7F7fej0/SifpGi5Hr49vAYkXa4S1NlZYP1GofRY6mgoEauw7GwvlTmhDyDTmo5eA4EUsSpyGuQZ1XWW22qOsQ3BpYKYHdGxDYNK+FJaMMkCjjFiqAk9FG43X
x-ms-exchange-antispam-messagedata: kPDBfr1hcgMyiYpEMDZrZRyGWT+NmBsi5uViLNff/Yy5TYebwU9W7Lgj1O0oiI1FBsGFQmfD2ic6SzZWhaq1qJ8ch30qGr++t3fYPlFdCbu8tnmT03wGVMJK4g3wdKpbVOqYDJ8oXSW59AZwxnnn9w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d91ad029-2412-47f1-eeb8-08d7abc4af02
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2020 11:55:53.3901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MV1dl2C3kCrOhSQhXElexCPUkJ2oeloI9Y/sxi/Oq8neh8b98CQtVqPY4N4kh9ZAVVhqzqNfeg6ldSoZbCg1xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6880
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> Many vendors would like to disable host TX LCC during initialization
> flow. Introduce a common function for all users to make drivers easier to
> read and maintained. This patch does not change any functionality.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
