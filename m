Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88441C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60BA120739
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mi0iFHJd";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rfRqADEW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgGHMEN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:04:13 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:41427 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729286AbgGHMEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:04:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594209849; x=1625745849;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=31WOsdALl/hRE/HiwpNFxdLflG96c00HIMvr9kklsGc=;
  b=mi0iFHJdbCnEIiinGG+0W2q02pClYHLx5Kn4MgzUAOJ+NQMk4WE4OvmT
   vHB4prHlsdQ4niv64SjjtZSO46LCDwX0KpYeClp8wGjspSrUgk3DBxDps
   CZKSsKD2KTEJSKlgIrivZusBz0Jg8MasSQ5iWmlcTdzPCxO21bg1+CObY
   1p7+n1VpHRhCr1VA5Sz/qV4SDV70vsoTi5dnOIIKccISNIQj9OkwAUL46
   vjWSAL9ZmwjXEsltSxpCFOgE7EyTcWLBrRvkchvq+3DrOcQUclZKPbwt+
   sUe804wRFkrxU6w+aeaBwXj0dXZkgG89L1ViC749lBP3ri92tt8maOoDX
   Q==;
IronPort-SDR: sA+taxLlKmTAbOvT2X6PA/1F+3+MPpOLNduCJnckav4ALqp4/TtlqjSCpf07LKVqdWrOfrQLhV
 LGhHURY/3wjas4HDyjdLzTyhWT3gtQ63NRfW44VFvkSuos7Xiw7UBlRrOkyrNYJWD/gP4WlLbI
 8Jqock6tEbQ40Nmzb6Y8cksSr3lBQKKB8OVDxSaqhKLUWxu1O9wbJyScPriPIYx9HuWKDUIT7Z
 lnMUnEEfFT1uYU0C1NcCcqqc3La8vSGlVitbGjkBQIKBOs1q3B3Fcuap7Sy9WHpzCoXdL/ubLA
 +hU=
X-IronPort-AV: E=Sophos;i="5.75,327,1589212800"; 
   d="scan'208";a="143246171"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2020 20:04:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVuDjpI+Tc48dAyLei5soa3vZsIZx65wfL/26M/rcXacJiitp5U5dox2QN+W2smzupZZe7cwiOd98bhNHwk+DP26XiXcyvw31JfXhjIY1bBALLSnHWPF5lIGFThHeWXFN66z95WyQ3H0EDPFrnlMnrW2ottgckQpFoAWAfgnVnjc1Df8HaM8WzX1u0tU8/58EGHBvibmm/iU3w5RAVvF32w5sdyanxEZl+z+3qyS49El28OUbiIs4+i8YIB9bh3opT7iy9g50Fkv2h3+ybw9+zrewjg5QneUCZ1aXTKsV+p0Y1P2k0v3gVKga3ABsvdDyKxX6n2dK6wgqy1s3KCRxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31WOsdALl/hRE/HiwpNFxdLflG96c00HIMvr9kklsGc=;
 b=IK8uE+YHeYPvjKhsLWiAT9kGsd0M5se8Qb2tD1qoriONv10YRY2l4YQR5zQ1K/aXK3DV8BhhApBdVuvbtHyxlFOc1BenUAqqEcQJXMzNgBwpOlWj2h0xe/XTtK80O3FQVmEZC0aQmzq06DzNbrf8t98VvjPc8w19Cpfems09d/3nv8jkI0ESpuyMFz12TGtLgmvr3TQ+KuuoHpOYyi8HcGZeUXgAhw1V5CTvcN6nLP7uEP9EyK9ScJQXeGXlNVTHiLKE3tjkO5B8JOnjvWG+FbmHhbiEN285Aqo+b4SGVyJiDfVl/pmrcNmwwzieddzabXtnqgm5Fgoa0nrWgAumfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31WOsdALl/hRE/HiwpNFxdLflG96c00HIMvr9kklsGc=;
 b=rfRqADEWm48QVgBjMDrmxcNOe2Zj4W12a7MojbyAygtYU+5RL5kMwmcmlkjhQr3NZYZNeBlQW87DIfD/pHcbwFAcAkGViKYh/qIod8CKw7QTCvybiPf9oTnRqrqCYBGjWEppBxXkQdfCvmpFusOWBVKPO9RD/xXvQyyc3Hbr8dc=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4687.namprd04.prod.outlook.com
 (2603:10b6:805:aa::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 8 Jul
 2020 12:04:07 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3153.031; Wed, 8 Jul 2020
 12:04:07 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Lee Jones <lee.jones@linaro.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/30] scsi: libfc: fc_disc: trivial: Fix spelling mistake
 of 'discovery'
Thread-Topic: [PATCH 03/30] scsi: libfc: fc_disc: trivial: Fix spelling
 mistake of 'discovery'
Thread-Index: AQHWVR+pi6nQBSqyRkaYFJ9Wxo86QA==
Date:   Wed, 8 Jul 2020 12:04:07 +0000
Message-ID: <SN4PR0401MB35986D7CECA87EA6EB9CEFA99B670@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
 <20200708120221.3386672-4-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d257d037-3ff9-488a-8347-08d82337040e
x-ms-traffictypediagnostic: SN6PR04MB4687:
x-microsoft-antispam-prvs: <SN6PR04MB4687F18E6046F680002F5C689B670@SN6PR04MB4687.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eAhv7LYqUCYbAxCq2aFFd3op5TEqaHNj2olWnUNWpZlaJYERdcwUATs0qkApSeKD3F1PDsY5J4t4zCZG68fFsuIN0u+ONAAU0UKopPRKr3fitoK9zroBH+Fcb97YjRZK11ES1rvHl9F17XapIklM/sDvoU3YEiXFJg9gvYch19s4xGq+1Su0nBTjXvzwqkByHz33geQazG9nHY6UCn6YsQs2NlaQu1s93Xzrx5BVgyhQQyY94t2B2qKKaM0J+DoTbBn8NvqnpgkIbBLjgNTEM+yqzmdR6ohZ8/aRE52ItJS1b9ifYP3wZftM+RbpzUUKRCPSMTXimJLCuaYyoqoGEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(91956017)(8936002)(6506007)(26005)(186003)(52536014)(4326008)(7696005)(9686003)(86362001)(54906003)(5660300002)(110136005)(8676002)(558084003)(71200400001)(316002)(66946007)(64756008)(66446008)(55016002)(33656002)(2906002)(76116006)(478600001)(66556008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +pxVyklUQjXfiIygJOAQtJkiOJjzpBUMreYKJegdf6B95hjt60QWPrfifJeGhUTXBy27GNrBNUPDcZeeL9F74kJ0JX84lzXLIxQqb/7juQa4qRUXn+02ad8uCCsVNbPznyLOGth80htEV0o+abpP59XrtgsYLR7oOLV0Qr0X8aLcJtO1y0NoqFuc40mHw6KMeCLwnBkyx3CTEOa5tOTVWq73+lXEB2mtSLNzxvMsk2L7Ja6+X2T+vTOkYvLN8Yd3xETqTLp2prcy0aUBwA40yY2uPe/FB/6A3tt2fdh78CW8l6dkTFSyh1r6J1IjOj1gWCWo2H875kqWBp1NO3630nyhPWjB4Qx9DwDRC/XWrJNwkaTCtyqCVEp0rvvgZku4NhprrWzZUpflxh9CWJPW336L4zJzEfX8xdl/YrIT3fUaewwiFAL1Xql1PBsN3WMSWspnU5/3yBEgozAFnEOODTN7No9qv2SL6t9jqY16tcd88MmRpoE8o3wu82dmh1CZ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d257d037-3ff9-488a-8347-08d82337040e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 12:04:07.0140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EMRpTRwlks6JBdR9/+9J6d74U751LVypd/jSvWWU8qqAQle7B7iZKs4vszIvCoVXMTq8/LIS3/NPEHRBojChI41O1/GBPwDNCjNNHLBDAN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4687
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
=0A=
I think Martin can fold this one into the original one=0A=
