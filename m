Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1252C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 06:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9F0D20714
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 06:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DgJG/3xd";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jv6ywnbq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgG0GYX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 02:24:23 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:36523 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgG0GYX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 02:24:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595831063; x=1627367063;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=S9XbUd6WNlZYyBolhzlMH9FWxwb1Sd7SGZtWXVOi/00=;
  b=DgJG/3xdppEpkL9PPXwzgkov60FOR8Nn3ePp9Vs1XWveikrfog+Ydwq9
   fdBx8ENFTHgz3CELu9uAko17xoNQCkpdmBgKum9SzWAETe/ftqQPTmi3W
   ydVUnCdYTC2MwcPu2B9KFQPrJ2wdfpX8NqmU2+2hCxoQGSPdZ5qZmsNCU
   n5TaYpVjk5aSFCIs8+UuSY8shCwnGYA2RSoOv106KW/hTF+newkIAJD0T
   2OAmspp2wtJE/rCBCli3unbMzHvxWl6sam3WiapeKSw1SLcvP8XBrCMth
   rzCtfJ+P3isGgOY4AnE0vyCVcjyo3sNyNKocpT8kzAfTnQi13K820loEq
   A==;
IronPort-SDR: e9LBkvL9aQIpI209LjmU/Kx/CZWDq04OUlEbr/X8FBPnvsqCswtntBhRHHRv5VhJkisjzShJCS
 r7R9uOfx1eemv/+xMin+dydwSRVsncNOxOHIg94Ry8ujoT6lvUC6L6wAF2NX67K+aojdJulhih
 j1q1NVakdDrFA7AV1f2tOOxGRszBNAv6WXpBAdNJ8MNzQK/xht0MOP36sL8xdnMt/mPJRlrlHL
 hZ1/ckof3GCuJSdGH0236a5qbDW/5nunx0/voqrWBFh9fsj78LLwo+OBZhJ9ZkUqQs7WWHPbqu
 HPM=
X-IronPort-AV: E=Sophos;i="5.75,401,1589212800"; 
   d="scan'208";a="143533625"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2020 14:24:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wps2WvrqoAF/GtgaRaMLvHxiE8rIwI1gGmWMrAT1XJy966OzK96gLGF7AoS4HeP5HdMGoUj5sF88AmXS5EUdPAiQ0KeLBLbf7IazkfayAx+CgGOkI9pkH6pMiDjL1Fprh5M3VgmF4gFK7Ey9plP8lHVnJ8Jmhrg3CyEjqtUAPgpNfRbLF2/n4eYWjIoOoOHJft8w5ttbjFTAcsEFOnr82cr8AEUPSsdYcAwSlTfRXWMdm3z4z6/bdMK4RdyDELunERVgNnX+O/SdcRpMhFgIpwppwazl2N5s8hdzeOlXV2cJ3fV1UWrs3zwGb3Z6MjIXwBuUoiL3mUkpyvnuNFcWDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9XbUd6WNlZYyBolhzlMH9FWxwb1Sd7SGZtWXVOi/00=;
 b=O17BP9Kx7fkag3ZDVrdYQya9jk5UTnWK8TjSi6eBFepxBSvKUUcjkscU6HCyiHvCspznrLjTJ/Vk73MqJl6ck0l7WBQepXFyS2DsGbzOTeFjn5SkEYdAjoe/qES3bA1OZP/u5O3SDdL73H0MrpiR3pc7VPdfEJEZxdoR2WP0A6LWu6c/8kMIjEZteotHuKssQHtwnbbRE6DB+F1LmKST1OT0XltMZK8H1o35cw4VRiWDICaU8x/pNWmtRUeMiVFEy+1e4FMbK4t5bZCVec/7Sj78nBAezmFYPXR3eyZOCheAFkjRy0yLrxs7vlMA/XoBo3KSZWmRqqihugvHFXOKGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9XbUd6WNlZYyBolhzlMH9FWxwb1Sd7SGZtWXVOi/00=;
 b=jv6ywnbqRb9rlOlmvlgKvfZYk3SqXAthD0XK4EA2/Cu7xAUWPhpXjCDcKVFajuSfQvW//UTBnf4Zc7yF4tRIZksoridPAWnwmZxBXGwOJD8g8MOkn9DAiUgO6GrrOuG/H6GZw/Gc/ZpHSBXVk3f3SnwV22cIXx9AUfmk8wG3uZI=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4896.namprd04.prod.outlook.com (2603:10b6:805:99::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Mon, 27 Jul
 2020 06:24:20 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 06:24:20 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>
Subject: RE: [PATCH v1] ufs: fix a bug of wrong usage of test_and_set_bit
Thread-Topic: [PATCH v1] ufs: fix a bug of wrong usage of test_and_set_bit
Thread-Index: AQHWY75qluOWJ3xFQkyykjUMHnAL+qka9VZQ
Date:   Mon, 27 Jul 2020 06:24:19 +0000
Message-ID: <SN6PR04MB46400FC0AE28E07011B071B2FC720@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200727023402epcas2p2722148df6f3e24533f09381dc47aa906@epcas2p2.samsung.com>
 <1595816749-108744-1-git-send-email-kwmad.kim@samsung.com>
In-Reply-To: <1595816749-108744-1-git-send-email-kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 72cd7a5b-8c04-49e0-73c3-08d831f5b257
x-ms-traffictypediagnostic: SN6PR04MB4896:
x-microsoft-antispam-prvs: <SN6PR04MB489604BD724BB60B3ED033A4FC720@SN6PR04MB4896.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9+sE4gffU4n5pxhluFlJf7EQElhA76TYj6RSUhmuRGo1Tpm5qUJgSn97G7MHjy4vwuE+ARs4Y0IsjNpAQ1I6DVxr4jzwEJ/LjpD9B07GXVTi4+ohMAp6N4fYFWozzvprx1w0TzljglItNPNWhvcu95KdjDcbsSxwYA8Ddj31oPjLyYcAacoqSem1x2g+LXwVrb/qXReBWkfxmViehnmomsgjCYNMpbObP5DHB4ZoisYnrGbJgekoRs5zVWLYHyHDNyhgBF/FoZWnbcg3vqNQE76Pvp4O/fz507d7Tol1hJavx849FJ6iVkeXmaSVWXnFs6qCUourDy3UUFy+1007E0mc5aZs1tTXr9A5osPAkdKlKppa7eq8GzBY/bG4l07V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(6506007)(9686003)(52536014)(8936002)(478600001)(26005)(316002)(186003)(110136005)(5660300002)(33656002)(8676002)(4744005)(66446008)(64756008)(66556008)(2906002)(76116006)(86362001)(66476007)(83380400001)(7416002)(7696005)(55016002)(66946007)(71200400001)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tMz8RgPEzK3rq8n58dXgY0DVHpTTFEWisvtArNpCMZ7rIzXqTkPoZztoRzRQEVb2WThLkR6TeOLZJpKCs2UKALO9xYaXoiO2dL+1OAPUamdBvhGnELPp6oAAQLkjkbFLaJbaO8ug4KE+DVqyyAf7lX4qnL4xrsXFQfacsQWmOKNJLgm9QNK1mchAbqJEbNZYv9hFgbA/aoLhQM5iYq1dIk6MczprQhvwCgT5Oso5DEGcx2ydra2vlqLZvWytUqRbcUubm0V25xPCVvWKHEaj+rnqOmkGKEtKUXvIVxFKZ7V2DG07NcNP8d+6A3TDuI38ubHUkPhOsHT43Q3RW46bzJQfGHGk6U4eXSFnhQy2xO3VU5Od1Btn3JzK8OldKFqOwa+r0SlqMmjfxlqrXmJekL1QtuuCXrJc39O7ywc4BEgzCZdAYcAA6+sRuezPTv4U+e+6RWvMjMo616vwZRI9wstl7BPkMBU/xv3zwIP3aR0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72cd7a5b-8c04-49e0-73c3-08d831f5b257
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 06:24:20.0110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hDAhCKmFBBWM+QCriSYW58tLpUwzIADzBrwwlQSaF+KW8s9h9qBPskc9F69J00QuDMAdShllBapFNOwMXr+38A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4896
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gSnVzdCBhIG51bWJlciBzaG91bGQgaGF2ZSBiZWVuIHVzZWQsIG5vdCBhIHNoaWZ0
ZWQgdmFsdWUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBLaXdvb25nIEtpbSA8a3dtYWQua2ltQHNh
bXN1bmcuY29tPg0KUmV2aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29t
Pg0KDQpTb3JyeSBmb3Igbm90IGNhdGNoaW5nIHRoaXMgZWFybGllci4NClRoYW5rcywNCkF2cmkN
Cg0KPiAtLS0NCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzLWV4eW5vcy5oIHwgMiArLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnMtZXh5bm9zLmggYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
cy1leHlub3MuaA0KPiBpbmRleCBhOTE2NTZjLi4wMzJiYjUwIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL3Njc2kvdWZzL3Vmcy1leHlub3MuaA0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmcy1l
eHlub3MuaA0KPiBAQCAtMjE2LDcgKzIxNiw3IEBAIHN0cnVjdCBleHlub3NfdWZzIHsNCj4gDQo+
ICAgICAgICAgc3RydWN0IHVmc19leHlub3NfaGFuZGxlIGhhbmRsZTsNCj4gICAgICAgICB1bnNp
Z25lZCBsb25nIGRiZ19mbGFnOw0KPiAtI2RlZmluZSBFWFlOT1NfVUZTX0RCR19EVU1QX0NYVCAg
ICAgICAgICAgICAgICAgICAgICAgIEJJVCgwKQ0KPiArI2RlZmluZSBFWFlOT1NfVUZTX0RCR19E
VU1QX0NYVCAgICAgICAgICAgICAgICAgICAgICAgIDANCj4gIH07DQo+IA0KPiAgI2RlZmluZSBm
b3JfZWFjaF91ZnNfcnhfbGFuZSh1ZnMsIGkpIFwNCj4gLS0NCj4gMi43LjQNCg0K
