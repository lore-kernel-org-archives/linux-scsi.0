Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C528CC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 18:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A79C82075B
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 18:40:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="rtoZvBEL";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="XHKo9bCn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbgHQSkB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 14:40:01 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:30193 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730440AbgHQSjz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 14:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1597689594; x=1629225594;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Pvqc+CJNHuba1gf0FOgtvg6MnKztUfvxSZ5CLZ2bpXg=;
  b=rtoZvBEL5tWnFW9KMpQqfecI09FT97o4wTAHjglHmY/Qx5zu65I5ihR6
   19ILTbyqUro8KJBOysqWq9ZhgvnISVADHobNWCaKJ4Dla09ceKecEVUsv
   7Sf08SzzZfxE4M7GAiZTy/RenicPTfVOd4C7X4OEqAOPNRiskSt16yi0h
   hAqjQmISJwsEG8fnml3dSessvk5UCjpOEjxJXYAd1R0Lp+ULeRGCGOrtU
   CSLdifUeQ2Sn21nhzau+UpzXHCRref9OOmmbh0pQZv8VFutUQstrzKUCQ
   bS+AHB5pQKZ3nibKniRVLF2Dr6AzKoX7doJAlyWmd6XmJG7yU3SYbL4dM
   A==;
IronPort-SDR: wgdTG4YXiz4eVzDdugxSUzGQhGo1g2olw3LjvEpf3x6lbjgn6X/wdNfOEdVmR7WvI+we3XTMCJ
 N9h/f5igkgJtEEotu84e5BtD/Jsod9LPFVFrInEsUOMQPr/ZJcG4SAlq2UQO/lHO1uJeaxHrCN
 D4CG//G/Oquzi6vMj0KuyFIVYjt3Zdt14X/lsagL+jicWEc80S5Rx/kraEBDGkBk36bPveEsP4
 uTF/CRcWwzbuWRCIX73P30MX6QTzUfNeEub+UDeGIpMYPw8Yk5rscM52vIbl1BtSTudsAbYsvX
 Yss=
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="92072295"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2020 11:39:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 17 Aug 2020 11:39:10 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 17 Aug 2020 11:39:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ks9x2/8IR2vEE3GqyP4TKJZO3O7ENX92tCQMCME1n6CDqIDUfxnDSNpBm02ZCnKpeA+YsZ8vJbVi1lp6UxDl0kJk2TthXaqP4o3V6iFkMvvkOWxqvhYAylgq6Ix8FDkyVCRgYkUADpcAqeS/+Dn8p0oSmebnq+X6eAzjtjBZXL2N8c0ZgA8OlGOVsEaLrFJ4YMOR8vlYxOvz6yQmhuXdGJjGxsxvk21rl6PcP+YS/hTlD0nhSBrrmcHRvLW6clBskrUuT6myICo37wFmDuIx8rAGi50NcCFEA4XVCxkApgOO8N6XGS27pyRXhQmJEcXBZehZlYxGdzagpdbHqKLfOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pvqc+CJNHuba1gf0FOgtvg6MnKztUfvxSZ5CLZ2bpXg=;
 b=HkupVWKqQdgx03NAR+SJew0pLf+91Q8TAu+i8NmqINbtcyYinIBexNI13oe0iHGiFFjpsgqCLQBkAIhCm6LPXKSFkQowDoXBhWIN2X5pfWsHYijsRBCgHt6eyIXvnL4nd90+BGqdn0Xjj8HQseMt8LULcWtz2lDh+QtfybWau/k4S0TkWqAfvjxDO8U5C5rFRIuZOechzhnizfPgbogbcEKPzwXUDPmRHcbFWlDw93rtePrjykscGl/HHlrdfeXpwwGetD9is8kBqyTAwiJD/MuVq5G2PwvSkICn2bqliZqZnT/bcL29WqtpPBgZxlfUjD6jF6MnolqNpCPOmD+zxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pvqc+CJNHuba1gf0FOgtvg6MnKztUfvxSZ5CLZ2bpXg=;
 b=XHKo9bCnX2riDpaAU9Jn2ZtgXk6tTxBOhfuRr8NJ7YzCr0ri8KRMcfv8HqpyC3p6m1VfkqI+I1CqkTZCrCJIvMXJtmKK3lPRLZQ+ptE+51pSSH/RRnVdrM8N6mJGiT+mMcI2tYYlDZjVh+cZxjyKv2k2hCSwyHNKt44Twj4YheM=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3183.namprd11.prod.outlook.com (2603:10b6:805:b9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Mon, 17 Aug
 2020 18:39:50 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::91b:b9d9:867e:c00f]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::91b:b9d9:867e:c00f%5]) with mapi id 15.20.3283.027; Mon, 17 Aug 2020
 18:39:50 +0000
From:   <Don.Brace@microchip.com>
To:     <john.garry@huawei.com>, <hare@suse.de>, <don.brace@microsemi.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
Subject: RE: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
Thread-Topic: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
Thread-Index: AQHWP01RAs2BRuCN0k+i3rLwgMsJTKkG5J+AgAABKwCAAAMVAIAgQ/rQgADXkYCAAGEqcIABUPKAgA7GHXCAA927gIAAsjMQ
Date:   Mon, 17 Aug 2020 18:39:50 +0000
Message-ID: <SN6PR11MB28485C73403978121C2EF9B8E15F0@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
 <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
 <3b3ead84-5d2f-dcf2-33d5-6aa12d5d9f7e@suse.de>
 <4319615a-220b-3629-3bf4-1e7fd2d27b92@huawei.com>
 <SN6PR11MB28489516D2F4E7631A921BD9E14D0@SN6PR11MB2848.namprd11.prod.outlook.com>
 <ccc119c8-4774-2603-fb79-e8c31a1476c6@huawei.com>
 <SN6PR11MB2848F0DD0CB3357541DBDAA9E14A0@SN6PR11MB2848.namprd11.prod.outlook.com>
 <013d4ba6-9173-e791-8e36-8393bde73588@huawei.com>
 <SN6PR11MB2848E10B3322C7186B82F1BCE1400@SN6PR11MB2848.namprd11.prod.outlook.com>
 <6c5c4da7-9fd3-82b0-681f-c113e7fe85b8@huawei.com>
In-Reply-To: <6c5c4da7-9fd3-82b0-681f-c113e7fe85b8@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19e27066-910c-40d2-6c3a-08d842dceca1
x-ms-traffictypediagnostic: SN6PR11MB3183:
x-microsoft-antispam-prvs: <SN6PR11MB31839A84C9E161F3627F761FE15F0@SN6PR11MB3183.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rEYTwQuGk6FBnE9QJ86HpsldFL202mfADQiWTnB3RqPgU94ozrC/ze4WK/0x8PFt3VTyggYaH35fG55qOEC8krhrloShv2br/5rTU6U/6+xQZsr2WeIo/FI4HQmtM2FUFcogZ5gzTkBbptKRs1TPkojrkSO6vrnFjlPvb5v0O5c/sX760WHjbaqQo3StbzmbvqoM730u7vUVlST0Y8IboWjLq0x02ZIC5Lj6YRwyP40jONDhIZx27cXh/M5fLqVwoSCYFzx3xHyjLUTXOScOvK5+elAUUsXHH3I5y8RSR8OimKumR5txfvVsu6yQwRkamk/FB5miRx6xncNLPKTXGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(346002)(396003)(366004)(7696005)(52536014)(478600001)(6506007)(4326008)(33656002)(110136005)(54906003)(86362001)(2906002)(66946007)(55016002)(66556008)(66476007)(7416002)(71200400001)(26005)(66446008)(64756008)(76116006)(5660300002)(316002)(8936002)(9686003)(186003)(8676002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: KC64sl31EKVwmdaoR+htLgHi2tB1P6O/2M4Oyc2wg87kXSkZpNEdujOPDFeVUz33dVB0QadoUEx/p4awDVmcpRMuXHRiZUNirn5JPs33WKowZGXebH0/RNJmOg3YmWaJ5AQYv+mwzVKYbUe/PCuPgDApzGgIywfxw2m6DRNEe2vexpqyc470XiIuyU2WzTeO4Dk888xiLPbPtrCvn6MjJNCUhyrsTjjtXAm7WbKggW3v7vXYM8IcMdTSwX0q/HZIr+aSvj0qa7oyohS8ZTpAkuz6833ZPDkNWSfn94APsYlMWJy6SS9ZIy1Uj5Tkdlhi4FnGSCkUhgMyX8TpUCUgLuZBL9KlwP/vFa0DqJwMmvd71k6F9GI8dmhx5a8dBnDFTgIxwBp8cwJmmQSPpuOH8Sj2WuDQ71IV5bJ6l1Kq2Wr8K0UgK0GzkvXqDTe3Lj3c8wE2OvibqE/zc0FwLl8+4ZmXjVgGtCvgvyi5DvjeurWS3gWwGjz1mr9l5y8M70xbsUNPzoHnkvrW/SoKL+PXdZYh3DuLXxqGbVRgenm86+pUM0DdhIZbLkPeg7NHG5lNLvE4OV/bcb/QGaKbgat5piQtO3OZ/MzgWNkMeDB6nnKhrH7SlJIvJnhmhAUEH3NSPGpvLJqhbePC4WXfAPxwjQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19e27066-910c-40d2-6c3a-08d842dceca1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2020 18:39:50.1556
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: voxQrwDyAP5hiNYjL5x2lAVIsXOyZq18Grh1w8WJWo9qpDaV2fgr+/f+VsjUoE8bXny1gFId3SKw7yLrohnqnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3183
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U3ViamVjdDogUmU6IFtQQVRDSCBSRkMgdjcgMTIvMTJdIGhwc2E6IGVuYWJsZSBob3N0X3RhZ3Nl
dCBhbmQgc3dpdGNoIHRvIE1RDQoNCj4gV2UgYXJlIGFsc28gcmVjb25zaWRlcmluZyBjaGFuZ2lu
ZyBzbWFydHBxaSBvdmVyIHRvIHVzZSBob3N0IHRhZ3MgYnV0IGluIHNvbWUgcHJlbGltaW5hcnkg
cGVyZm9ybWFuY2UgdGVzdHMsIEkgZm91bmQgYSBwZXJmb3JtYW5jZSByZWdyZXNzaW9uLg0KPiBO
b3RlOiBJIG9ubHkgdXNlZCB5b3VyIFY3IHBhdGNoZXMgZm9yIHNtYXJ0cHFpLg0KPiAgICAgICAg
SSBoYXZlIG5vdCBoYWQgdGltZSB0byBkZXRlcm1pbmUgd2hhdCBpcyBjYXVzaW5nIHRoaXMsIGJ1
dCB3YW50ZWQgdG8gbWFrZSBub3RlIG9mIHRoaXMuDQoNCj4+VGhhbmtzLiBQbGVhc2Ugbm90ZSB0
aGF0IHdlIGhhdmUgYmVlbiBsb29raW5nIGF0IG1hbnkgPj5wZXJmb3JtYW5jZXMgaW1wcm92ZW1l
bnRzIHNpbmNlIHY3LCBhbmQgdGhlc2Ugd2lsbCBiZSA+PmluY2x1ZGVkIGluIHY4LCBzbyBtYXli
ZSBJIGNhbiBzdGlsbCBpbmNsdWRlIHNtYXJ0cHFpIGluID4+dGhlIHY4IHNlcmllcyBhbmQgeW91
IGNhbiByZXRlc3QgaWYgeW91IHdhbnQuDQoNClN1cmUsDQpUaGFua3MgZm9yIHlvdXIgcGF0Y2hl
cw0KRG9uDQoNCj4NCj4gRm9yIGhwc2E6DQo+DQo+IFdpdGggYWxsIG9mIHRoZSBwYXRjaGVzIG5v
dGVkIGFib3ZlLA0KPiBUZXN0ZWQtYnk6IERvbiBCcmFjZTxkb24uYnJhY2VAbWljcm9zZW1pLmNv
bT4NCj4NCj4gRm9yIGhwc2Egc3BlY2lmaWMgcGF0Y2hlczoNCj4gUmV2aWV3ZWQtYnk6IERvbiBC
cmFjZTxkb24uYnJhY2VAbWljcm9zZW1pLmNvbT4NCg0KVGhhbmtzLiBQbGVhc2UgYWxzbyBub3Rl
IHRoYXQgSSB3YW50IHRvIGRyb3AgdGhlIFJGQyB0YWcgZm9yIHY4IHNlcmllcywgc28gSSB3aWxs
IGp1c3QgaGF2ZSB0byBub3RlIHRoYXQgd2Ugc3RpbGwgZGVwZW5kIG9uIEhhbm5lcycgd29yayBm
b3IgaHBzYS4gV2UgY291bGQgYWxzbyBjaGFuZ2UgdGhlIHBhdGNoLCBidXQgbGV0J3Mgc2VlIGhv
dyB3ZSBnby4NCg0KQ2hlZXJzLA0KSm9obg0KDQo=
