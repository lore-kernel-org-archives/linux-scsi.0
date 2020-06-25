Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C18C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 05:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D2892063A
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 05:48:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OtJ4PUBv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HZs9ZOMg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389768AbgFYFsG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 01:48:06 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:3537 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389497AbgFYFsG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2020 01:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593064086; x=1624600086;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iijraJqM+zqQp6qWUj6CedchYiKCyWWavoqnVOfj92Q=;
  b=OtJ4PUBv/Nb9pA1co7WCPe2hXgrBF1ojcyUV1iUC+URcFs9SMODnQZP4
   q9wo+EkPqSCX2B3t0Jbbacaz5V9ZpdrevTy7+uwTJQGRxOONOnun/k/qX
   zwoK2eGWbVwmx0jbDLZXtrctAtIb9AmBCRIHh2HRxCrtukhqcqOzwGscJ
   hMYL2ShYtO5BcuVoDl5CWcICWYyMi7e0w1ZzCT9zfamenvSBWkEHSviVs
   XFwYBy3V9l+yn7b1Pe+4xloouQz+H5DZa5Zfgg5qoqUOzYkAYXfHa1WWl
   lLcMbHfoscm2Nei7gvZKknqjBIH2100WxxiqQUhvcjdBx+1nHGwIHak9H
   w==;
IronPort-SDR: ASQCGcF+hOfMB9Ch+8NjJFff1d+oFr1HEYkZ0E7vvWv6qFdC3o7L71JyCYMJ+3/OqlgORCQ67W
 Wx49DzoqGvzXRyw6PLk9cD3wr7xIvM1xNPFgBT/kvwNBBthotXYW++9cLyR9zG9tQtBCvq7FT3
 SdeRS090hwlekKQEAM4NBp5rMRgv6j0UxuNiPpzoY1wAHTLHMDcJs4+FXQ+WCKq6cB6Al2/CQw
 Avk+vxBvL5I1X+qI2JVu8ua5iJeWm7xXx/Ivi/gCD2TGmY7xXNO6Wc18q/+0Lhu8fqISmLh0Ik
 gAc=
X-IronPort-AV: E=Sophos;i="5.75,278,1589212800"; 
   d="scan'208";a="141112597"
Received: from mail-bn7nam10lp2109.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.109])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jun 2020 13:48:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aiwvq8Dz5Qb0dlZOaXvapB3IX/Ir1+tvEMiGwzya3Xx6aeBtFqIRA6gMxObsT8KwUdUkfuoKD5hmqvVwsDS3HqoTTG7E3Pk9s5cCBRdVYBJukwpmzBfP4YHPDr3oecQHh/tbeoMiQgHXICyJ9dZmILXv85AJYBorPRHjNIKlLTKOKt9Qvvr04s3grgM6FhJ51aJNiBWMkBO4UC8G7qjXZI72NvJejCsxKusePkErlFb7GnmoDy6Pw0U0024iy06W2uz/R7s3+hKVhkdyHCVGNPPITsD7Fy9sgfc8PwQfdsqUw4YE0pQoKkoEPfTy8dCn98MTszHo29DGsZ/w/Q7MVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iijraJqM+zqQp6qWUj6CedchYiKCyWWavoqnVOfj92Q=;
 b=iPJsj++DZO9YYYndThZJzY+zaQt5FrSEap9qf6uk9JX91YQxuUeE5PA8+oElQSAeRakNYKz4Bk5tSI9RdsiiI/m/JkCLxUgng7pGfGC2l5fYlVD+kSrMF96Ut95dVwroFKtiAxVdZE0DQCKdM6cOFVHASO1BfioEY9WPfiALwh85mhBHuaARGiT0DE2n6cdDBl6DEjk88Z8K6nDhKc/9TNZ+rs8kKJmkFVw56UyzmwNBJZRm7ZiIQX9K9zD09KwvlHM/KNDwxfOWLSdqlXfQHWZkKBTykqCR/JXT+v+C6DQoq8l1VSAk7Wu0chiEWdxXWf3zQ883LPhJRB1G7E4oZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iijraJqM+zqQp6qWUj6CedchYiKCyWWavoqnVOfj92Q=;
 b=HZs9ZOMgPDUS3nNTG7DykYh8v3HOdyNIGRqCWndGWF8sLqJdu9SKwc6MbMHCEMj8oCT28C8Og3iDtlu3Fh9Mnv7L+k3XQQp/rXnEs5r2EYRkDY5lzXSKBQ6PH5RNtfwj5xRmqlqa255hhJ9veEAyVy0oi8cuV5JO8JLgwnlKQ1k=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4719.namprd04.prod.outlook.com (2603:10b6:805:ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 25 Jun
 2020 05:48:02 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 05:48:02 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "kwmad.kim@samsung.com" <kwmad.kim@samsung.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [PATCH -next] scsi: ufs: allow exynos ufs driver to build as
 module
Thread-Topic: [PATCH -next] scsi: ufs: allow exynos ufs driver to build as
 module
Thread-Index: AQHWRytj7q4ajAgTOEi/fYYjfXFBj6jo2dQA
Date:   Thu, 25 Jun 2020 05:48:02 +0000
Message-ID: <SN6PR04MB46401185DCB0815401DBB399FC920@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200620175104epcas5p25068bb07029c9d6aff56623e4ecb0a26@epcas5p2.samsung.com>
 <20200620173232.52521-1-alim.akhtar@samsung.com>
In-Reply-To: <20200620173232.52521-1-alim.akhtar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: add088d8-7968-4c06-8c31-08d818cb5353
x-ms-traffictypediagnostic: SN6PR04MB4719:
x-microsoft-antispam-prvs: <SN6PR04MB4719EADB4B0ED8F8A4887430FC920@SN6PR04MB4719.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sx8NanzysQ/ORk2OOkNRt+50wuRwmKxoY7xv2MRcXuIMoC7pofQ8gpxl+6K/x5pCBI+nQzdUCt9KvLT3y3D+y5yuBAibXttrdsKy79JCETHsEwG/yDF99udU8MFi8R2fCBEUCV3u4zbHIcCR15SLW0nUABGjE1VCCqn1gLumcQxRdb0BxELM/qlsehlcBUsh3hnvA/mMMgOFshK64TKDAbrshDsn2fmhlrMkE/u+1U060j1zFzxI1nn48WO+PCGCg/MYblWXoDYg4GSSBHq358RsRXrgYg9gMQXCtiF5QcD8D6912b7BkMS7izC2QVsHuRmjVuDESu4ztF6K9JMC2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(55016002)(52536014)(66476007)(66556008)(64756008)(66446008)(316002)(76116006)(66946007)(33656002)(5660300002)(4326008)(9686003)(86362001)(478600001)(2906002)(8676002)(54906003)(83380400001)(8936002)(71200400001)(6506007)(110136005)(26005)(7696005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: k1RypGUuZ9ARUI6xCZcrRDI6QRk0BVKGkukG7Z9WTgYa1H9ig0/2L2HG7QY6hvVpakTVLIa0dL44eR3jtgeXSgi/hmJRs2YJ1AzNtBxw70e/gmBcV/CMB00Jys95X/X+aim8+CgUuK+utXZiYFuaf0t331+3s6ZXXJPc4IchUHvJkV5bgJNCFy/yy1xVxLO9+NtkQkQCPCgA47uAfpqppFuqJZL3yG96/L/qbXBCZ9eM1lsJkv0c0VmSlq0kUH+iJSOhz6qPRhpi8nufpDbRSTVc5vVNgn+VAel2M0Ns+kh0plyFniY5ZdenisjjfFIp+fGHhqM2X2KpMaQSzYZKS6lgUGqOvfvzFl1JEudQ+8jdudJTktIkW1Fmuc3m/1kUqsd+KIpyRIgF78Dd24QuTJ1J9i8CowyToGDuTU5Hf1yAF5w0bNV254m5ObFYIgMixKrlK6G3m7MaKT2PugFjOzlxEwa3e20afltLnkBBo3E=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: add088d8-7968-4c06-8c31-08d818cb5353
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 05:48:02.7217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kJmS29s7yJbPJuvqWogSLlCIoPN7fJY5eiUPk3crIATXp7gpCxTnrjQn7AANdlqaZTxU5gtFR2Tb/uubmUXtiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4719
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gQWxsb3cgRXh5bm9zIFVGUyBkcml2ZXIgdG8gYnVpbGQgYXMgYSBtb2R1bGUuDQo+
IFRoaXMgcGF0Y2ggZml4IHRoZSBiZWxvdyBidWlsZCBpc3N1ZSByZXBvcnRlZCBieQ0KPiBrZXJu
ZWwgYnVpbGQgcm9ib3QuDQo+IA0KPiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1leHlub3MubzogaW4g
ZnVuY3Rpb24gYGV4eW5vc191ZnNfcHJvYmUnOg0KPiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1leHlu
b3MuYzoxMjMxOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGB1ZnNoY2RfcGx0ZnJtX2luaXQnDQo+
IGRyaXZlcnMvc2NzaS91ZnMvdWZzLWV4eW5vcy5vOiBpbiBmdW5jdGlvbiBgZXh5bm9zX3Vmc19w
cmVfcHdyX21vZGUnOg0KPiBkcml2ZXJzL3Njc2kvdWZzL3Vmcy1leHlub3MuYzo2MzU6IHVuZGVm
aW5lZCByZWZlcmVuY2UgdG8NCj4gYHVmc2hjZF9nZXRfcHdyX2Rldl9wYXJhbScNCj4gZHJpdmVy
cy9zY3NpL3Vmcy91ZnMtZXh5bm9zLm86dW5kZWZpbmVkIHJlZmVyZW5jZSB0bw0KPiBgdWZzaGNk
X3BsdGZybV9zaHV0ZG93bicNCj4gZHJpdmVycy9zY3NpL3Vmcy91ZnMtZXh5bm9zLm86dW5kZWZp
bmVkIHJlZmVyZW5jZSB0byBgdWZzaGNkX3BsdGZybV9zdXNwZW5kJw0KPiBkcml2ZXJzL3Njc2kv
dWZzL3Vmcy1leHlub3Mubzp1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGB1ZnNoY2RfcGx0ZnJtX3Jl
c3VtZScNCj4gZHJpdmVycy9zY3NpL3Vmcy91ZnMtZXh5bm9zLm86dW5kZWZpbmVkIHJlZmVyZW5j
ZSB0bw0KPiBgdWZzaGNkX3BsdGZybV9ydW50aW1lX3N1c3BlbmQnDQo+IGRyaXZlcnMvc2NzaS91
ZnMvdWZzLWV4eW5vcy5vOnVuZGVmaW5lZCByZWZlcmVuY2UgdG8NCj4gYHVmc2hjZF9wbHRmcm1f
cnVudGltZV9yZXN1bWUnDQo+IGRyaXZlcnMvc2NzaS91ZnMvdWZzLWV4eW5vcy5vOnVuZGVmaW5l
ZCByZWZlcmVuY2UgdG8NCj4gYHVmc2hjZF9wbHRmcm1fcnVudGltZV9pZGxlJw0KPiANCj4gRml4
ZXM6IDU1ZjRiMWY3MzYzMSAoInNjc2k6IHVmczogdWZzLWV4eW5vczogQWRkIFVGUyBob3N0IHN1
cHBvcnQgZm9yIEV4eW5vcw0KPiBTb0NzIikNCj4gUmVwb3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJv
Ym90IDxsa3BAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGltIEFraHRhciA8YWxpbS5h
a2h0YXJAc2Ftc3VuZy5jb20+DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFu
QHdkYy5jb20+DQo=
