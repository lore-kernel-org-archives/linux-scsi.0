Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4C0C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 06:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6F016109E
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 06:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhEXGwY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 02:52:24 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:46901 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbhEXGwX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 02:52:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621839063; x=1653375063;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NQaiOnWmTwRLzuuQvoOhYz43lIYqtpO7cKE4i2Er+cs=;
  b=g4b/eS5YczYWAVBksaDrknaW4vj1Ra+PaxumpI23kQxCMQLpqpeAUM4D
   lFwln4yPjOcYmqK7v63Re9U7LjcZK/EbYLBJkyWnEX7hswTCi4CwZ5OxH
   BtnFx1NnP+KxxXvw2K0z+kmgsnsvayu27ApB5wkGWZ3niJxNNq59v3QKC
   5JLokHQv3WP6hFxZwGh6cdJq4h28GylmFMdQ8AjKAk3selXcUyj8zrAyt
   l+payFqPaRuIQbBrItUPONbh3ke2PyQwfZGhdEH46eqxgQSIpnL6uL3b1
   lEe5piEukUHslYXMaGLx13HVKUALd7svIZ98J1RGyZTbD6/S/EFPKG69e
   Q==;
IronPort-SDR: EMrhTWFiHe4G6QtAKq5G8m+U+E8dJhT5hfUi1OmA9thIQj6hrP0GHSnjxQdK7ljtmRu1GrsMDK
 8mJwQr+kFsy1THBkek7pwQT0jKomDBR9BivMUSL5Mo6LYpbkqV6rqW5HZjrgyjK/jqpA0GsYkg
 sHKJ/VrphSlo9dGgWB+NkQb9RuIN9nzW8V4AlxPixGY8usgQC2vYy5bo+SPC9VQfO+xASRs8OR
 J2cr+ubZaa3tXA9c/XXwr9QI1Qoi6X8PZ0wXKnttteXvWAFtVC25DvDaoAI2Ny+Z9Cb9M3QQzV
 V7g=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; 
   d="scan'208";a="273119051"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 14:51:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8k8X6voqXkeJtduuR3hmJ+HKiJ7PE4fIrOdSgbYA6tzRleiBB5h6WYLcJ3NkTEZwqwJl3AR71AaepWmg679siutJuQG052PmrwM3uPVIrcMHu3mOia2KfPAMBurGvESJi1xIRC8j+k6TLIOs4wp0aPY34CUVZjMPOF/ntZsSNFn7kvxTx80onkmw2vpVV74IW6IABGUqCQP5vVoTr/pm93NM4+kXRuBWKa28eUS4lqRd6btZumSjFh8XfVaT2J1camZoY179IsxKugDYCnzThMyvHp0fkcQBJzW/Ktu4i0+Y6p+4hiA1ZolaroVSfiw1jy8jOpEuIRZe0bArXy2TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQaiOnWmTwRLzuuQvoOhYz43lIYqtpO7cKE4i2Er+cs=;
 b=P1GO5XeTMKZWm8ugZVr4FdbhmH+0ZJR1xpPEmeI8IEFlhy36xtxpasSIzKVRmdiHWYTYM6LwuwEc0CMmBXtbbe8mCQBh2aeUUBthn3EJP9fg1vuT8FbV7WsZRhC3iNA2g2Fw3Z82ndP50+dKlVfGvRCbL50uDa/O7g7pgAinCUlMCvrUTPiVhACTcNTMjr66vC2mqLh8ZcuC4/wxAa39pNYGCmhK4C1l3kEyyaNZw8Zcpejxbnb/Pdh5crOtETyVAhouP6DD9DpTDHbrDInZAF/HbkS2leudVSQfjIrUF5oT9bukYrw56I9P9b8pRWb0fvWKXXCrk09yrvau7r/2ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQaiOnWmTwRLzuuQvoOhYz43lIYqtpO7cKE4i2Er+cs=;
 b=JI9Zm9EDRPX57tuYXAQuG2/uAESLJXBfBNy3vo1GmeT7GMwlNiIN+dEvo5IU60IdTQkHUiEQod0EfJ0uoJ5LmN9YcVLNzeTnnSL2s3D9lqaWeDcbLtOUwLbRrsEYk2vdlusxv/JMTY8N38Oy5mJcqTbONtzktS+Em9GGzTnjsk0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6923.namprd04.prod.outlook.com (2603:10b6:5:242::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.26; Mon, 24 May 2021 06:50:51 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%5]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 06:50:50 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>, Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 2/3] scsi: ufs: Let command trace only for the cmd !=
 null case
Thread-Topic: [PATCH v1 2/3] scsi: ufs: Let command trace only for the cmd !=
 null case
Thread-Index: AQHXUBierK4G9a3mGEiLWvJ5+PaBs6rx2QcAgABXL2A=
Date:   Mon, 24 May 2021 06:50:50 +0000
Message-ID: <DM6PR04MB6575C932FD523BD50E99EEA9FC269@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210523211409.210304-1-huobean@gmail.com>
 <20210523211409.210304-3-huobean@gmail.com>
 <1d06cc01-a642-e8e0-a251-1b392e4935c7@acm.org>
In-Reply-To: <1d06cc01-a642-e8e0-a251-1b392e4935c7@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3123a394-fb04-439a-7014-08d91e8044cc
x-ms-traffictypediagnostic: DM6PR04MB6923:
x-microsoft-antispam-prvs: <DM6PR04MB692340861D55FB86064D4720FC269@DM6PR04MB6923.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nZ+2Y3PGas7KJpS90G/BggR4PvUgBONa3sTdIRdLPmyQbb3ELkqOxZa8p8cGQ/jYcmER4BMwse1VWFR7sXiQhRHG2yZYsnErR7EEbDVO0mczAPOjdCWpu9MAeQeDlDTpGavaf1HsMuECYRpSf7x+WXZtH8TAk5YkNqs/rRRdDO5S+svvh4ukfW4trsXx7kvcGdlSr8Z0iz2MsOJR1NY8HFR0U1UmDuxgjkOzbLrwkGcuk4/lsOEKq1NPtEEVD04Od28+FABKkammwiZo4E3hdpbqr4G1lP1t3jpB6Zsu3+m9FcQTwrzwbiRx14idRudWD8sbXsCerydP6H+73+3JujW8k0kbGNXdbtMLRh+PRRck1OTCAPGn9n/hkzA9s6xi55ts6gJCv7DXa5ZLcxLUXA2g8Ou+vnoHwMxyFzcyw05TgpaZaGfH8wEg3K98rHK4hFFfB4uho/HR5xqnalIGltJdUOm5tTUcDUG/6rb0aJi5gMJvz37LDAumPkHJTkkiQYZt7BOD8F+4jLBq6DW7kpP66YAyA+5ElyfWFHsNHMBt7E4ezOvW2bvxA0HDupNdA7MsOTSuVHdeh1zVXvxlh0kg6Ehb1RNGfHM99NvpYR5gdrhuaEnKx3k6z5NqRUKMSxHuq7FSB2T8m5ljbn2RJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(66446008)(186003)(66476007)(64756008)(66556008)(33656002)(66946007)(5660300002)(9686003)(52536014)(6506007)(7416002)(8936002)(921005)(55016002)(8676002)(26005)(4326008)(38100700002)(122000001)(7696005)(316002)(2906002)(76116006)(478600001)(110136005)(71200400001)(558084003)(86362001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TEtodVlhK0N3UGpzbzM0RTRhaHE3dXNac21SS1VEM09nUE5wQXgzTHJTQmI2?=
 =?utf-8?B?VXQ4UWMzQzU0RUx0OS8zYyszenJBa3JjZnNQbzVHazhmTlFQNnlhZzZJVkJM?=
 =?utf-8?B?M3BnNFpUMUlsMUtCOFozbEdkck8yVDhyYnRPa0NVekJtQU1PbHFCTG8rU2I2?=
 =?utf-8?B?OVVyc01zYThpc3B4bXNlSGtCS0xEaVpFVzRhUU5CK3h5eGpXUmdoMFZnNDFD?=
 =?utf-8?B?MjBnRzUrWVdPNXZLbjNyMFpzOStyTWNhT3pxMkpwYVFTWXFuMGF2bE5kYzZY?=
 =?utf-8?B?MVhMYzBzQlpCSHo4U0V5U0dMd295YVEwclFaRjFsRHdWcXVaYXNUNS9YUGhB?=
 =?utf-8?B?TENCZVUxWEl2dVRvcHRpVU0ra3NISFFCVS9CUkJ5ZzlPMnlId0pYTDdSaXFa?=
 =?utf-8?B?dHgxME15cHB0TUY4SzNHSDJXTTNIeTN0M1hyUk8wSTZRYXhZZXd4WjJBbjZL?=
 =?utf-8?B?bGpJblY1bWRQMlVORmdKMWVYMlpwRG9SNzlsZUVPQUFzTzF5OVhERyt3NXNH?=
 =?utf-8?B?ZjlpM05La3NMc09iTGxiUXh6ZGdKRUlmcHBqWGJXVmdKMm53L29Ed255M0py?=
 =?utf-8?B?UmE4VFdITWhkMEJiQkxua0JsTmVjM09xdmlwL0daWEVxeEEzUXBXY3V4Z1NQ?=
 =?utf-8?B?Nm9mcUJqei94OERkVXNId0NGQ0RHOHpCKzJyd0JpYjVBWFlHZnpKdGh1M0Nn?=
 =?utf-8?B?SzNGY2pIZkVKRk8wd2w5d3BJbVJCMXRGdnFITmZWQjlrcGF6bnJkUDk0UmVF?=
 =?utf-8?B?dU1xSlRyWWo1bzNnb3Z2Nm93Y0x6MUwra3dVaENSS0hNRW10KzJyMXM5STM0?=
 =?utf-8?B?V3ppWGVRQ2Fza2JGOXZMMVVkZ0JVTG1iZzcrZTlybHJJYUNQVDBHR3dVR0V0?=
 =?utf-8?B?RmRqaTYzSm8ycjhIeWdMNWtNOEs4SG9XSzI0cmFhei9tRFlOeWN4VGl4dzFi?=
 =?utf-8?B?SkdaVlBSamZ2cHREKzRPcGxjSWt5SEkrOEU5cTl2MFFCc2JFUnRTVnJWSVZG?=
 =?utf-8?B?VktTcDlvaXZ4VzlkWnM4V011d1ZmbWFMR1QydFRaOS9PblQ5TkMzR1ZpR25V?=
 =?utf-8?B?QUpGYnJNREJMZll5K0p2MExOQ21VOG1ORVJTclJPSllQVW5VMFFlNm9kUzJS?=
 =?utf-8?B?OGRFZWNhZ2d5RnBaMFRub1Z0T0h6K0QramMzNktoeXRBVkE2Z3VLOWF3YnMr?=
 =?utf-8?B?VG1hbmkrWmVDbGlqTy9xMzBSdHQ0RExzZ0tac1F6SVllYnRHYXIvd0xQZWlF?=
 =?utf-8?B?a3FXSnozazBrZHI3SU96ZTR5WExtajMraVBIcE90MHhpcitEL3VHc1NUaURN?=
 =?utf-8?B?UEJFR2x2aGlaWHAzR0xXRHN4STdKK2J0SDRET2ZzNTVxUnQzTVZEcmRjaWlT?=
 =?utf-8?B?TWQyckNMWWRTSmdCV3JmR3UxZWxYbWk3d2EyWDkrNVdyWG11OUNBNENMMEVB?=
 =?utf-8?B?MjRQa21uSXBnaDY1ZVhVdWxZUU96NytwcERSOWxzQnVSWkI0YkRqUXFpK0Np?=
 =?utf-8?B?bXdXdCswZjZHWk5xUUZoQTR5Y0poVktTNnhtRjdwaUJFaXJLakxpQkpIVXFL?=
 =?utf-8?B?S3FJT1BmMnU2UnpNend0d0Rqcy82Ti9lek9JSXFrMjE1MHVVbTU0V1RFNUNI?=
 =?utf-8?B?djZ2QnVBbkRPemdqNis0NWlOK21xVkdpMFhjMzlYSDNaMTcvYzFBTHpiRVRV?=
 =?utf-8?B?Z1UxRXFJUVNSYm9tZWFycjlZRm50ZUZ2dVZVbk9NMlg2TWIyVzl4YW9tR0pB?=
 =?utf-8?Q?nXWw6zT9sdhM9NU3KguaY57G/GjWSm7ApzONBLe?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3123a394-fb04-439a-7014-08d91e8044cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2021 06:50:50.7307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sjyVOPxka6uhuywakFCvEi9ZKrH7pr75rlUsbS32hyn5flah0x5HsDxYdqZ0jzhYRbrjU2bbwJ3FVQWGYE46Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6923
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gV2h5IGFyZSBSRUFEXzE2IGFuZCBXUklURV8xNiBpZ25vcmVkPw0KRm9yIHByYWN0aWNh
bCByZWFzb25zIC0gdTMyIGlzIGxhcmdlIGVub3VnaCB0byBjYXJyeSBhZGRyZXNzZXMgZm9yIGFs
bCBmb3Jlc2VlbiBkZXZpY2VzLg0KU28gUkVBRDE2IGlzIHByYWN0aWNhbGx5IG5vdCB1c2VkIGlu
IHVmcywgYWx0aG91Z2ggcGVyIHNwZWMgaXQgaXMgc3VwcG9ydGVkLg0K
