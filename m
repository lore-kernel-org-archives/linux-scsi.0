Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB55C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 08:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB64422A84
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 08:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbhAKIQP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 03:16:15 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:56695 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbhAKIQP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 03:16:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610352974; x=1641888974;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VOwtCGnRGfQeXY+32ffcgZsx2cyV/7vjgtkls7Hs1tI=;
  b=Dda9q2LIm1PK9+AmPruZWsat+74VleoZgnsnslcAfEsBcKZMZ0EHcNJ2
   qlP2f5XuYD44wzvApSJzo/i79TpxT7pDaVm+luzucp2DxV7kFA1o/Q1e/
   vod+oCLqUdRfIcgME8/xwWF7NPuGcoECnEZzCHy5uDpbfZ2BncBl20aau
   Db0uJzIDkRz5MXcOT0SZXepoY7D6g/hTZe0PRjetA+kh5j8QErJB8tnJV
   weEYLmgCi0Mtu/Zhl8RVcUGTnFpSEvJXc/ILH4HmWamimTwQPbLy7NvFb
   J0fYPsZlKpF7HsABx5RVb3rEkaV7tFJi8lbxChtpl6E62NS/KPJNBt3KB
   w==;
IronPort-SDR: UJk5LooZ7bsCV8x4P5cXjveUxZMAe4cPNPB5rjiPRbd4z7JjyFM6rl5s6e6QR5lbpmhjKCSOdI
 qkRRczt65k0Bt0Jawyvgs2l8uScU8Zu4W9VMJx67WH784we0jfSZauVV3MGze/uOWV3oQCQSK8
 S+AYB9I2gsDKq+8daATQPOelkbpGLfobwknNSu0gZaQXF2dll0FJIQ8ykfZJF6oX86iZAmTcsP
 2Q248pY0dBoyFJ87yAm/GTLu2zVkTQUQALrEiNwPp1TBrMkd6FdZ0+8zzwZe5KGzE/KiShVaQu
 nzA=
X-IronPort-AV: E=Sophos;i="5.79,338,1602518400"; 
   d="scan'208";a="157131618"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jan 2021 16:15:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLfgWMN1D0z8siXLKTTWIguDLYdqZsJA8SVdX9F2G5r0Dma9BeAYIQeT1QnXPWwT/gOl5wETPKD/seTa+/9c4MGNS411pygb0EkRZ4gwQf7tVN0ZWhQQfgbUzjG1/nzmawuhLuNbtG6oEcF0yBrCY2rg03KAI40zm81HUHmZ07E4+GYZ+vWE8NwE0AWHMtWk6fftcbrOi+n5HQfnby6l5dyc8J2kFCPbMB4JnkFTGn5tvk2Fk8gUmstMsQTbUTC0UWS85hL4Dp1Vn+zctKRbvsNp+wu/i9JdkSgLzYgR+Zr9h4+x2j3KPcI/N6xsY+t1e5s6eWAOfxefAhjafzQN5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VOwtCGnRGfQeXY+32ffcgZsx2cyV/7vjgtkls7Hs1tI=;
 b=Gw87AFbVVSDdToi3p1KfkBPRJgztiWEUrhX7+/lfV6OikKfG3cu9LTIAsP4ZoWHnzWP7zQhSYLvZHyqhZFokbQjBgzgVGwGPSfLkSm3BJOSYhuKEQiGVkfP31qrL5jFaOK5KWPDlqcfnd5Fgy/Bc73Nxddjq8k08Icw5wPEEzahDAJWtxfu9K/ZH6krgRsqGaVSSgRDCfUelaGInT9d5u4HMH2EwzE2LykdxkMjamTl4xoiLgCMPGyAhKgrgT/FZQMgO0bFQIDXjbQ8t2PLcZDWFAuDs4f+5oQTf6If3i01Df+WmiKxpPIIudodLztmtf1Z0UnZsNDHfsM7sN5Ifmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VOwtCGnRGfQeXY+32ffcgZsx2cyV/7vjgtkls7Hs1tI=;
 b=pVYl7K0v+Juq438Jki58B0RNXyCj3uUj47HGsaFdGW3t7zxGmX4ITsuCTqsQaDCKOoyxdink1SoLPC+xk7hzrSe2Kog8y67HhQjY5sA8DjWQzhDwMZZh0ktBkRSdSUXmXVfDpPss8yy0vkzoLNFBM027CC9TFMdqAg3hLCVdU0U=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6252.namprd04.prod.outlook.com (2603:10b6:5:12b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Mon, 11 Jan 2021 08:15:08 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 08:15:08 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        Jaegeuk Kim <jaegeuk@google.com>
Subject: RE: [PATCH] scsi: ufs: should not override buffer lengh
Thread-Topic: [PATCH] scsi: ufs: should not override buffer lengh
Thread-Index: AQHW59R/eNlUdvqgSkSDB6KY+CfEAaoh7GwAgAACjwCAACD18A==
Date:   Mon, 11 Jan 2021 08:15:07 +0000
Message-ID: <DM6PR04MB65753C88CF333FABF5CB1704FCAB0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210111044443.1405049-1-jaegeuk@kernel.org>
 <6551e7d6dd7dc4132dc69e77a51f6f21@codeaurora.org>
 <e1b29f7cdd62cefcc9355baaed66641f@codeaurora.org>
In-Reply-To: <e1b29f7cdd62cefcc9355baaed66641f@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e041ac42-e2ab-4abb-b684-08d8b6090231
x-ms-traffictypediagnostic: DM6PR04MB6252:
x-microsoft-antispam-prvs: <DM6PR04MB6252E2C732FAFD252A1AE896FCAB0@DM6PR04MB6252.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TSEspOo2+I5rTJ0nCS8IkRTnFbPtcABtZqJSED1Lgn10FRoL2wAyi0Dlhc/1mbO29VYcoFlq0zyFOYA3FXyzeBvomeyCJR2zLBOfnm9tAKKwEojm/QtvpUCtSpn7A+Vfb1JE5UafnT634IstkZww0/KznHRsPm0Ph7a0zKC2jyHalvqhXYZ5q2b8FCNhB49cDRQvIhNCKM88ZcNi3LPNlGchr+wInvq/E9T034/45XJ+1PbViZPHMVfYsUo5VJCXuzdoOFFc53P2oiXgV7YsXpqe272e7MYRMeVhQtBf4a+O59I6DHP+IZnUlhKx2Zweb5xqzNzZOpTcDRMJ411coZYPkvBPDESs0N4gBS3xzeFUOmuR+1sC/wyZWj46VGW0pFwFbUr5QG/VuY63kY0+oQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(4326008)(64756008)(316002)(66476007)(6506007)(66446008)(83380400001)(66556008)(71200400001)(8936002)(86362001)(52536014)(54906003)(2906002)(4744005)(186003)(66946007)(33656002)(5660300002)(55016002)(9686003)(478600001)(7696005)(76116006)(110136005)(7416002)(8676002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?k2Y3al246IennntmOfBIFQzh14PPzUe5aSDcz+7a+9ScdHtktftmlSzC/Pby?=
 =?us-ascii?Q?J4LIh6BBXVm4VnbA3rmCb8m9kkTsINc+1d/t44w7YvKvC6livIwaWPqkPxvd?=
 =?us-ascii?Q?EG0esXjQyh0SxvnQIKD6IFdyefujLoZwLwlYzOsotzEOSjsl4pPM9ctTYHQF?=
 =?us-ascii?Q?qMaRKUQWKKl7u6Nkq3YwutZDBOoV/RgKGYqw/vB9UohrMG3kBSVParQarb1G?=
 =?us-ascii?Q?84WonTsMqLVHzHyDS8gJOrfaYYy2Z9msyC6/PO91/rx53t7nj4Z56aVCvj/A?=
 =?us-ascii?Q?YIPmxmw+8zQCBEwO26MSot74pRC9YUJs8FA+TpOrjewnAOe0oJ+Ae7Eq1e0m?=
 =?us-ascii?Q?7X2ruvEZr6lJOIlARLh6YjK4E9ldKqxIyOXlfoT5048HfVPVFWH7UeyeYqLK?=
 =?us-ascii?Q?aLyk3ugD1hta7Kg8cwmo8dYCCJLqyjXB/4Ia5FzUCS+8oH281ZrhjqzlREft?=
 =?us-ascii?Q?h07/wiCZvmV0+oqUKC6rrh26/9RpnpkzNYBK88MU0S1jBuBusEfFXqzRrcOQ?=
 =?us-ascii?Q?DWZ1lbijfLW8omgOap3hfFFipGo85T+qz4k1RXbScHPNO8ZcT7TZKqjZaytM?=
 =?us-ascii?Q?OEwV2Oha2CGRjci+5hv3Ys0Uz4d0sIfmyleeU5bcLmKTF/OLJ8WkEDW8KTgv?=
 =?us-ascii?Q?RT63imWsev829P4jTeVyFmqLSThEECFWAEqdMmWVrRiMvqt033+T8cCN8ihY?=
 =?us-ascii?Q?mcXnVEJIbnVV1GfETPp3aWk3i9+hP10/4aXldzbC3TDZFOTUyjxiNC2zjf0o?=
 =?us-ascii?Q?Zz2JwPmdc+CgyqjBQZmsvZ7/WnegoqcKfchf1uKn9KnqgoLZW/wAFdIyzcyp?=
 =?us-ascii?Q?WFFVwoPUvx1W0HDWy7tRPv/D+kFU+A9GXchOaEElFqvlJAVnuc2Ibz1qttnU?=
 =?us-ascii?Q?B0QsOlVN43lXcONBRqx0GKiPeT9n6E6Q3bUyuIF4m+ncZBnFUjRxAKUpw5sg?=
 =?us-ascii?Q?8CJaz/ajlhtdSacdergb8KxeIo4GTneYW595lmUzyiI=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e041ac42-e2ab-4abb-b684-08d8b6090231
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2021 08:15:07.9563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /b8/7iOms42tIRhA8BeRxvDa7IvglpMVW7VorM4H7EbQNXmBf7IciZQHltRWBv14GxIrJnJuiinteOgEqfBqhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6252
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Sorry, typo corrected.
>=20
> Hi Jaegeuk,
>=20
> I think the problem is that func ufshcd_read_desc_param() is not
> expecting
> one access unsupported descriptors on RPMB LU.
Correct.
This is about wb introducing a new constraint: wb buffer is only allowed in=
 lu 0..7.
And this is why, IMHO, the fix should be in ufs_is_valid_unit_desc_lun,
To include param offset, as it is only called in contingency of ufshcd_read=
_desc_param.

Thanks,
Avri

