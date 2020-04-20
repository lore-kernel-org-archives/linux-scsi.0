Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C98A1C38A30
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 10:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3D4C2145D
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 10:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WY8dihLj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NI1nK1TY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgDTK0N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 06:26:13 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22419 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgDTK0N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2020 06:26:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587378372; x=1618914372;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ue3fdm2+yt+qFqyIKS53nvyhAo6tnuDoBPHozr2SAUA=;
  b=WY8dihLjyZaRfxaSqx/FKCZf3WQFBAKym43j4S/uDFVeJsBlmlXF0PjS
   Dl7UJX9axQsvEAhWi98Ac0QVBo/9ypR9rrbDJ9Ahx28AzxT//y4VPkAVI
   +idcSkUdR7Rn0httklGH1rMebglnfRvdMRdcNtofQOjUQGX3CNgBE6PIZ
   MYJJKKQCFy9bQFZaAcePsiDAHk6J+bXtGQ2WBJqcU1xl+Vm1UOdoFaCeM
   BZGnBTKrSJvszWWNuRuDZvKh2rW0CK0ANYE/CBH69uSQpOES/TJbhx2xA
   /HKBOhuGCYNyZc54AKFcYVdl4RdMqkEs/trH+OTf6TM0TcRMOgSOx5lPc
   A==;
IronPort-SDR: 2xo+meC+FMAs+wbV0sILAkJyg/dClQrmAW8O9pE7BmW5On1BC20yakP0yUVy3cmfqE7nJqas41
 VQYokQ5cHweA12PPPjvKVfj+gh8A+frJg0UpgkgeBIyxPKDOCbUAWFtdYoFqS0Kxun4Uc8kGkE
 v/Ii4BoEkFVg/YDT9gEgrD4TEMliQMUWqBlCOBzbs10gj4iu0WI4C6P7/xyxBVpPdXe/pPvpKl
 n6D9vgi4Y5Okczl35PA6zWYbusONlAeulgXJFyeojXHsjvOMBnDowFSRQsEBSirIcwMea/KG+V
 iUY=
X-IronPort-AV: E=Sophos;i="5.72,406,1580745600"; 
   d="scan'208";a="140055228"
Received: from mail-sn1nam02lp2051.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.51])
  by ob1.hgst.iphmx.com with ESMTP; 20 Apr 2020 18:26:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPXm+wKAF9U4/wuq2ZOMjOxb6W/Swc1nj3G/076s0Xz2GH9STElJUTlyBbhkc2byHZBMe75wUE7WrEqbm7pKN0nuiUc1LG24g8WJelgQ8MbbqTc/LEO0U1Dz7/RUFcvlAGtUKVdyNhvq916xMt0HAS2Vb2ql8G/Yp8eVi0HlV1xdgapWI+t5HJVBRiZtgoTEAIP6NAlAi0MP5Z/vbW7pMwaaD/BT3nKgJ23JYC4x84VNgwy9xiDdsZsfecvdpgJWRO2lD5cvr4vzu3lTr6bsVS5Gb70jxiQW3Y7ECoFTKED9H1Npqa9Rj/epW3PAjCM9P46riyy/DMHnQL2pSKKJoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ue3fdm2+yt+qFqyIKS53nvyhAo6tnuDoBPHozr2SAUA=;
 b=BNizqJer82f8aP8FY2/7x9NqyqZlf0rlMb9ZgQL3Q1SA1eOk39uJmRV5bLrAzNGrYXT/2llrUwqmlbd6ceD085N4A0+iV97HfNjI5Wn7q1ea3yZDs4MmavPSWpPQrLm0PLOd5OZ64Ptz1uAkYTjtLVmvedkL84S772jmM0vjr/70h+ma9WLw3BEWvTEeoIT+aKNjbuiQpg5BBLkTw2L54ReIQjtTEyI/ZEaE4SE6jksXXEGcBjsuJR+bHHkIQu9XxRTRYf9d4RhNbTcLyS2n985y57QiwVckwyJ0X/zWCmYTzmEXSg5WotQ+kuISxhiN7BAPSwgIN7mD/7igN9fPvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ue3fdm2+yt+qFqyIKS53nvyhAo6tnuDoBPHozr2SAUA=;
 b=NI1nK1TYhmZyCxRfEN9ZQvLIay3NOhGw5EPr1H+AmHDRotTIBWkRP1dNWG7ZWreGoBzAXheRMv/1bNvI0qHIkbEQYe2s/kuQIoNjhpGQCIqf4tB5vxMv5GnvvKyfWI16GO0WMwcCuoigoi6R5V2lDt+wc7DHT8YcrUyjNsAmsXI=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4333.namprd04.prod.outlook.com (2603:10b6:805:37::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Mon, 20 Apr
 2020 10:26:08 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 10:26:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "robh@kernel.org" <robh@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "krzk@kernel.org" <krzk@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "kwmad.kim@samsung.com" <kwmad.kim@samsung.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 09/10] scsi: ufs-exynos: add UFS host support for
 Exynos SoCs
Thread-Topic: [PATCH v6 09/10] scsi: ufs-exynos: add UFS host support for
 Exynos SoCs
Thread-Index: AQHWFON9I42YB5gW00u/wT+K3g+GzaiB0ZlA
Date:   Mon, 20 Apr 2020 10:26:07 +0000
Message-ID: <SN6PR04MB464049754716338FA4202E62FCD40@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181024epcas5p4231ae3dd2598155854e9b7ee52438bcb@epcas5p4.samsung.com>
 <20200417175944.47189-10-alim.akhtar@samsung.com>
In-Reply-To: <20200417175944.47189-10-alim.akhtar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 13416250-60d8-436c-4b59-08d7e5153d1a
x-ms-traffictypediagnostic: SN6PR04MB4333:
x-microsoft-antispam-prvs: <SN6PR04MB4333007425952B576169086AFCD40@SN6PR04MB4333.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(6029001)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(2906002)(186003)(7416002)(5660300002)(4326008)(55016002)(26005)(86362001)(8936002)(8676002)(6506007)(81156014)(66556008)(9686003)(7696005)(33656002)(52536014)(71200400001)(4744005)(76116006)(316002)(64756008)(66446008)(66946007)(66476007)(478600001)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kPeB2swhmQ066thH3FyvM6WTuM/2rlIS0+jJ0oCIIgDmlYjNaQeMSKWG07OTtshK8zc4Hcopo1sxwC2Aqpp+/7dWESmjJX1o90iZFLCW98Ejy9FGld8Sh/5T8+kLhd/eJPdneLCotOCBzl0PbqgxAumxWXKeG5adwId8it7wCANBPcp0E/SlQNuTHFEi391PM5rBnByrIcBmnmMizEYL3cDpxPFN7NuOHGF7AE0hhs1g4Oa/bAIGLIOAs+vIgxnNLwMr4W0eyY8tezXySIbV9QF0tzlCLNVSuMn3hjAyJhAMze/DVvrIOiVzl0kWC5Wqn6VtQ51pJ9buXKTz6MQdD3ihw9HD1SXDv12/baqvEKyENW2nT1LsOA89A01WlIWzA201pEIsx6RLpaKpzV6RxRTBylRuUVgtQX2yek/DL1zk/Pjw+RJP597F1XIKjwkC
x-ms-exchange-antispam-messagedata: a2K5aU1fLwpiJsEq0GgV3TEUk8nBc9qiCon6P95f9PmjfUGqJvLFXLnNiNr2s3Xbmxa9Qy4KEwRHmtRzBCqc8ZpEYI7j4Vv79qj3CVEnOe8tQM17JmX4n+3Mks/n+NdRN9w+d2pSJ5shwY8PHhn4Mw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13416250-60d8-436c-4b59-08d7e5153d1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 10:26:07.7662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Giwf3eRr3v7p5QPp3gtq2mhtQdIvNKOpzbuJJWDEbxE+MeBrkjRuJHLi8ZJeuwpD31MuVi3Whmj4bflpEFyuuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4333
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiArICAgICAgIHN0cnVjdCBleHlub3NfdWZzX2Rydl9kYXRhICpkcnZfZGF0YTsNCj4gKw0KPiAr
ICAgICAgIHUzMiBvcHRzOw0KPiArI2RlZmluZSBFWFlOT1NfVUZTX09QVF9IQVNfQVBCX0NMS19D
VFJMICAgICAgICAgICAgICAgIEJJVCgwKQ0KPiArI2RlZmluZSBFWFlOT1NfVUZTX09QVF9TS0lQ
X0NPTk5FQ1RJT05fRVNUQUIgICBCSVQoMSkNCj4gKyNkZWZpbmUgRVhZTk9TX1VGU19PUFRfQlJP
S0VOX0FVVE9fQ0xLX0NUUkwgICAgQklUKDIpDQo+ICsjZGVmaW5lIEVYWU5PU19VRlNfT1BUX0JS
T0tFTl9SWF9TRUxfSURYICAgICAgIEJJVCgzKQ0KPiArI2RlZmluZSBFWFlOT1NfVUZTX09QVF9V
U0VfU1dfSElCRVJOOF9USU1FUiAgICBCSVQoNCkNCkNvdWxkIG5vdCBmaW5kIHdoZXJlIHRoZSBs
YXN0IDIgYXJlIGJlaW5nIHVzZWQuDQoNClRoYW5rcywNCkF2cmkNCg==
