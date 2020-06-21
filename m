Return-Path: <SRS0=/9Oe=AC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F29C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 12:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 612E12076E
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 12:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HftzI3re";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Cm/Oukwi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbgFUMfV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Jun 2020 08:35:21 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:38103 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730020AbgFUMfU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2020 08:35:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592742919; x=1624278919;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MKt6JflvVuLaTkGlyalprjRA1EBWaaDublKPcX3HyfM=;
  b=HftzI3redJvxjKvC6JiFuprTBGj8Drx+rQzeIs9OeZ/k16SDM4nqkE6a
   x8vETWc+LLH7Xr8rDrq5o9R9YEseYXvE2m2+UwptGO9742umW25HZxOR3
   BFh+24dg3+t+tzFIGPAVbC0i7+t3xbIN8jVKJ0EWEyLJgohfbT9bDXYss
   tKTxOEOkGghooySbmjZX0EDDn3jsXrgNPJpbabeIPeN6ZM9qHOgTVtlp+
   /nO2ORHVw9WLZmJ0Rg30yE5ZVPxU/Z/TNb3pllUMCBhSkiqWDqEjMPQJV
   ELsCyUILoJoxqbpDskaoah214FprFgf/WGVHBButWJeXnq5xAyb01ZH9H
   g==;
IronPort-SDR: rKDwQKDoxoAQhLDOUPzTiuFAX/1hbuSQklJ2OqxZvrX4ZUSAkoKHM0YYZG0wfDuDWZs9UiFYUH
 RET9fHyr5tk3OJV7DSD81LP+3G/oxUuCEA9/R0eD2WEc/y9lMJvaw1pNeRzCoSpu3b4a0j31O7
 UBdtlBxs/ztA696JbQLDhTmY98G6Vbf6QIE93972FJaJNjY+a8xxB9dDMC1YGzrU0TxbP6eM7f
 2+7Wo8DkrrnryQQAjxQBwAxIudo++N1xbqkabYBWGA0ViS3aIcr98VU+MlCYXV0bBMhnGqEcXZ
 mig=
X-IronPort-AV: E=Sophos;i="5.75,263,1589212800"; 
   d="scan'208";a="249742893"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2020 20:35:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzD5DwMz7Hc/MeK/OwNIS5WFFAfyeuB4yFcrTrIt4ooXzzorYXYfzLrlXr1ligzk13EV9uZSd+2yxEAa2VEX7+QfnVrQR22C3tdVyOWL8ii0vNBS0XI6IRUMuVDsFgArgckYgELtJt9YLTLIie16XDm2rQcrCZErMT0VZgAM8Ryl6d0iFFl9CPwFFzURrvw7QUCASbBMi3y0Kd3QN9SSQKw+H8Rl+AXjePh3YMsLv3AHWbcTWl/dMelKVQ9pxu5U91LDHy6bJtlLfRFI9J/S/mdYI9+Ajy8a6X09thGIib4F0CBSOYDsxYqZXoPjxcxyLKd4Vs/NYz4hC/O/RQD2IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzWC6V6iYMoItfZ0e8SvojjxFL/QLCGUr3kxTMbi5WQ=;
 b=ALUsUJ/Bstd7GARMrjE6/geEOREIQtaIzSgGvbhidoq/xJLvOdTfPC/5T0wmaFLiD6VxUUnQsOq8lT4icfyKw6R6/mcfMkWVLLTI0zik6KRsYcb/3u8474pijg1BZ06YZByMVCWepcRwCIaZ6YWkdKVPTFaxzxHK4a1danhxMIRK5u8QLRXF6FGINr5ufjHzuQnifiJvAzTnVx6p5LLGDFjs30WLfd6ko2789rQWila2Ys29fALF1iem3RTz31WiJ8qgRYGQ4bDETmye+S4ecjsiRG5njxdnBme1TAIFhHgxDWPLkbMpOqGacuX3s73jPLjCsK3sidTswxZl4TwBew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzWC6V6iYMoItfZ0e8SvojjxFL/QLCGUr3kxTMbi5WQ=;
 b=Cm/OukwiI/mQYnkQDC88jMZmS//87eMalRzHFifT13VgCMNvaEKCAWlVgkwk4DUcbgYiGoVjZvWqU+J4k9Sw069Hgf/9IKyUiR+WFufMIWlVPQq6k+YSBqlzvj9yx64fIpws7ke24rnZ3Q3wgpmIXEBP8O6WSCHRDSpbW86XZi0=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN4PR0401MB3629.namprd04.prod.outlook.com (2603:10b6:803:49::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Sun, 21 Jun
 2020 12:35:13 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.026; Sun, 21 Jun 2020
 12:35:13 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Satya Tangirala <satyat@google.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: RE: [PATCH v2 0/3] Inline Encryption support for UFS
Thread-Topic: [PATCH v2 0/3] Inline Encryption support for UFS
Thread-Index: AQHWRrYXnkxifjeS80qrV/YqWlM3YqjjAQoA
Date:   Sun, 21 Jun 2020 12:35:13 +0000
Message-ID: <SN6PR04MB4640005BEC3EE690CB904298FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200618024736.97207-1-satyat@google.com>
 <yq1a70yh1f3.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1a70yh1f3.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1e9f2e70-ddd4-422a-f259-08d815df8b5a
x-ms-traffictypediagnostic: SN4PR0401MB3629:
x-microsoft-antispam-prvs: <SN4PR0401MB36290ADBED358806B48C14ACFC960@SN4PR0401MB3629.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04410E544A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RayVn7iVfUIF07VE02OXaJQwAEx9nkfpso9gwzC9NrJrRXLSoW2dqvnC6vAmXzir/8VKTqHopA1Dwe+sHeUGXCn+roFMql6n9nUj+18e40lWdGgLK0PnXl75GF29klGGR2x4XsgZFl7wAbYfir5znuGOshlNpgvYRRFFSrn6Cdxwwi5BwAe076mtj4ubc/dEPfZdhnicpGZVa8kYRoaMYgqEt2vkBIpUnQiLGbZ2AlSY3qpJAhWgVlHCLO27jqdl7cL8qcyltjVxz5uVQoM16iMJMt4HgT4OUbcFrwscsdQk2TQEG5+Dsg9pLpdsV9mQRxvmleJaGoJ3XRyI27SbLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(39850400004)(346002)(396003)(366004)(83380400001)(7696005)(186003)(66946007)(26005)(8936002)(6506007)(33656002)(8676002)(4326008)(9686003)(4744005)(5660300002)(55016002)(76116006)(54906003)(86362001)(52536014)(110136005)(66556008)(2906002)(64756008)(66476007)(66446008)(478600001)(316002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: EIqfjBWyofWou38ZBrJQKTmZyBsc6Pz6406SH8o4W0oMUn5Wp34oQ6R3OX2AJFur2szUVCUozn0ZhId1zNb8+QfzvziAIvSkKYAaN6w1srMGRsBqaitz4d572D+HYj/5B9D6kVKP57KNmJUM8DHFwh1ldX6qy7wezRybeCXRPGgEnu9A/1u2atcdy2fGB4+Zt8PsNfbJJBso8R+83w2xsK7sMep6Ql3ajN/pR/Xe5fos8eHNdlPW2jHsU4lm9RPVRWtWCg50AqPHxTz9f+XzKU4KZ3q2R2G/Td03lobPhFvskBPKXepyOhCSPFddkN62HJvnt54wwhLj5ZSqcWua60xzOqIbMlkwBoFtRfnVtonb4Ckrk3l8hYYh/UyqYe8i0z8Zx6XFrFmZbDDQX9FhQJZfxrAqbl4tlyvVd4JO3EytYggO9Ggz+0RstbCxSFDpTb9XEVXrfcViL8JeAkLjz90wyp3I4RXLTm7VTq3jGUrQe/0uQYkKpbyyixfjKP2m
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e9f2e70-ddd4-422a-f259-08d815df8b5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2020 12:35:13.1369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w5RB0gnzbaRPkbp5rS0eA+2yrz3DjnxHhkH+h+wsZOye/ETGkVUS3KkC92CXqZ/ToNPUGi3yz1chlZwofNBvuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3629
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+Alim & Asutosh

Hi Satya,

>=20
> Avri,
>=20
> > This patch series adds support for inline encryption to UFS using
> > the inline encryption support in the block layer. It follows the JEDEC
> > UFSHCI v2.1 specification, which defines inline encryption for UFS.
>=20
> I'd appreciate it if you could review this series.
>=20
> Thanks!
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
A quick question and a comment:

Does the IE infrastructure that you've added to the block layer invented fo=
r ufs?
Do you see other devices using it in the future?

Today, chipset vendors are using a different scheme for their IE.
Need their ack before reviewing your patches.

Thanks,
Avri
