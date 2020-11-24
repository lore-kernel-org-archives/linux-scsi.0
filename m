Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 860ECC56202
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 01:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3380F2075A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 01:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="TyG426is";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="TMj6+S8c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgKXBSo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 20:18:44 -0500
Received: from alln-iport-7.cisco.com ([173.37.142.94]:30247 "EHLO
        alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbgKXBSl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 20:18:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4590; q=dns/txt; s=iport;
  t=1606180720; x=1607390320;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s4SgPqXy9p1L+4bOJgxmFtJFc/aZr4UV9+VxZbKPej8=;
  b=TyG426istGOgzpf0zV4iUXPQq/HWxnI4C12cMkgAi8RBrDZ325TcgNPU
   wr/4f/ewRfS/Ooe/cXDUDDsAtw6OXd6I0DnDMJmQiMfMlev/uYDoc9zcg
   Ck3YvGCelMg+M4jGW/E/c0s08AfY4JmdwKAJ2MIeQ2aLKrUn+Cyfv/okE
   g=;
X-IPAS-Result: =?us-ascii?q?A0DHAQCGXbxffZpdJa1iHQEBAQEJARIBBQUBQIE+BQELA?=
 =?us-ascii?q?YFRKSiBVC8XFwqEM4NJA40zmSqBQoERA1QLAQEBDQEBLQIEAQGESgIXghQCJ?=
 =?us-ascii?q?TcGDgIDAQEBAwIDAQEBAQUBAQECAQYEFAEBhjwMhXMCAQMSEQQNDAEBNwEPA?=
 =?us-ascii?q?gEIGgImAgICMBUQAgQBDQUigjlLglYDLgGjWwKBPIhodn8zgwQBAQWFKBiCE?=
 =?us-ascii?q?AmBDioBgnKDdoZXG4FBP4E4DBCCIS4+hCUZF4MAgl+QJoMOPYdInREKgm6bH?=
 =?us-ascii?q?gMfogWTXKBgAgQCBAUCDgEBBYFqIoFZcBVlAYI+UBcCDY4fDBeDTopYdDcCB?=
 =?us-ascii?q?gEJAQEDCXyMOwGBEAEB?=
IronPort-PHdr: =?us-ascii?q?9a23=3Ac7m0ixR4c8l3YBfxpWg2u92+kdpsv++ubAcI9p?=
 =?us-ascii?q?oqja5Pea2//pPkeVbS/uhpkESQBNmJ4PNfgO2QuKflCiQM4peE5XYFdpEEFx?=
 =?us-ascii?q?oIkt4fkAFoBsmZQVb6I/jnY21ffoxCWVZp8mv9PR1TH8DzNFbTuXa1qzUVH0?=
 =?us-ascii?q?a3OQ98PO+gHInUgoy+3Pyz/JuGZQJOiXK9bLp+IQ/wox/Ws5wdgJBpLeA6zR?=
 =?us-ascii?q?6arw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.78,364,1599523200"; 
   d="scan'208";a="598322340"
Received: from rcdn-core-3.cisco.com ([173.37.93.154])
  by alln-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 24 Nov 2020 01:11:26 +0000
Received: from XCH-ALN-003.cisco.com (xch-aln-003.cisco.com [173.36.7.13])
        by rcdn-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id 0AO1BQTT032640
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 24 Nov 2020 01:11:26 GMT
Received: from xhs-aln-002.cisco.com (173.37.135.119) by XCH-ALN-003.cisco.com
 (173.36.7.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 19:11:26 -0600
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-aln-002.cisco.com
 (173.37.135.119) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 19:11:26 -0600
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 20:11:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFN+cs/CNFKRgMs1gO0tPBeB5R+yH6/jnrMYLbAsEK0821VoqoTHdtAz+2DvWwVXP5MwAjz8adifqdRUeIKeEIoWIhyCVGEFnZ9BDD58Opv/gLG5DDRvk+0jNDdHd3NkRO0Q2PlLZ75jdFJM/r72dUl0mqs2OMnMsyskf09xW73yaRfqEuFK97sB250gCu9mEi42hzNRN7Qv7kY+i2RVlYqUatLNBVPaeCofsWpuJEVH0PhzbdOUGFhErYynzrTgYNNB84Wz/Cq87L+G9bqC891iq/yyBMTngxgpERWrX1NsKd9mPIEb1G2YJHvXSeSs2AjsWnjSbUoz5YoCE9x1rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4SgPqXy9p1L+4bOJgxmFtJFc/aZr4UV9+VxZbKPej8=;
 b=ib+QxPEvandA+525VnN5/j1JDO6b7UAdJJs+aOjxMy6cWaWMe5Owi6NtrOK5LWTtLyBDupXkcCw8x/Wpxpv1ZlwBuHgwmDGiA6F9eGDwvwjDbY7V0GLnqq6IKbZLaBWSFeyzZkT5/jCX2fxrRCQFUx3YYXtcrYXvMBqnLonzPVpOBlVVwpCyp7PdwEL3jiArhyj/+gATardyhNNMEl+I/X7KFM/fWzEMleMnVlP0CGl9sYGSl7Z0rmpx6J4eGwxocFWHzLuwz1X32FVvt8Hk84u2+cSsfZuA8xtVa+LH0jiRY7o9+6KKxAlhoFY8BUUBdzFC7fFz7zyX9Z3QZ9BqIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4SgPqXy9p1L+4bOJgxmFtJFc/aZr4UV9+VxZbKPej8=;
 b=TMj6+S8c1RdkE4zNn814wznzWeL+6CEvTFc0/yB01dWnYzOCW/x/2pRS1t1KQb5RZ/3K8g1e7GKcZonHilrNxkiTtYk2hB8PJgRDGWC0/nj68z+9aznddmkv6Mi4rBdWHeoFSaFWEOIudeypUKBqfaY5aVib2k5VR43rqwRQkbc=
Received: from DM6PR11MB3289.namprd11.prod.outlook.com (2603:10b6:5:5f::10) by
 DM6PR11MB2601.namprd11.prod.outlook.com (2603:10b6:5:ce::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.22; Tue, 24 Nov 2020 01:11:25 +0000
Received: from DM6PR11MB3289.namprd11.prod.outlook.com
 ([fe80::dd7d:47e3:8339:16d2]) by DM6PR11MB3289.namprd11.prod.outlook.com
 ([fe80::dd7d:47e3:8339:16d2%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 01:11:25 +0000
From:   "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>
To:     "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
        "Satish Kharat (satishkh)" <satishkh@cisco.com>
CC:     "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: fnic: Avoid looping in TRANS ETH on unload
Thread-Topic: [PATCH] scsi: fnic: Avoid looping in TRANS ETH on unload
Thread-Index: AQHWv6S1Myc+rfoU+EyFl+ouAHy5JqnV+A4A
Date:   Tue, 24 Nov 2020 01:11:25 +0000
Message-ID: <4EB95B94-5780-4527-93EE-5804789590FE@cisco.com>
References: <20201121012145.18522-1-kartilak@cisco.com>
In-Reply-To: <20201121012145.18522-1-kartilak@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.43.20110804
authentication-results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [98.35.85.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3225642-2a58-4266-2f07-08d89015dd19
x-ms-traffictypediagnostic: DM6PR11MB2601:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB26014DCCD71C5EFD811B5E79D5FB0@DM6PR11MB2601.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SFIS6gIyP1e+d4QRCNtFLBtA33/CKUPFC8nThQJY9o272aWAvt1AkMOXhS9wSadK1bDRyXU6MZnYRhoXhopuWs8SGC6/7UpzNQSvYBsCaKpgJue1Nz5jkSPQZ3aTa9BbVdjRSHlruBcGHcXQfLSB/K1o41XiEpAXaw/gIaPHmwK5n0UzrOVBCsxlLHn64shpKp1BICGP9Q7vYbmIDCwMO3rzy+23ytT4w8TdPc5xSIVbM9hr3vEJsOKQcVWkHLRIuQ59FoKZRpWcOQPkMqeZX6jbVHyUfMABsJWdVcCVkD4op1TNB81A1gSc1XPiiD7o
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(136003)(39860400002)(4326008)(83380400001)(2616005)(54906003)(2906002)(316002)(478600001)(5660300002)(110136005)(8936002)(8676002)(6506007)(6486002)(86362001)(6636002)(36756003)(66556008)(91956017)(66476007)(71200400001)(76116006)(6512007)(66446008)(64756008)(33656002)(186003)(66946007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: v/yFMZayyBM5TXUe+Cab8bnEiC8otRLbzDqmsLiX1pWziOJ5eNmEMexrOPka2jFI50oh16uw+/zsB/B4Loc9LVW8DcGqSvZypte790HkI+04BbXAeIsY5ctXTfXfrzgn68DfW2szMqycKGq+nSUP7t3x02VG34ACWH+rs7S5x60lA/OyvlUWCMEGOyto8QNIFuIfRI6rXAkGxLNFeCuJorRT/Wipqh+kunnIMGij6uvdfLaavLAYqQeYzqN2h723356cpbRBQ3Whx6XLBAkWyz5WkcKuXX15Ov50SdCha0Q8/k+8alwgZapy4XwlWOSQavYwYqcCELy2DQ+7ptj39ofKtKESkZ6p8vPhB4nzYYFtsjR2vsM1gT85pYE+cN7W/hHiSnhiZ8n5pCbd2+ZBSYSzIQY+UGx5ytQQCsJbyp0rryyPMtMNPeWZ9isvVYLeoNtDEZI24fqmXw9pvzlxOD1P6FUEhKlwoX52tbrILxK3ls82qD/Rugftyzy47Ci6typJH7iHp9UpDxGIS02dvI8PO3mBCBhrUCsOHWbJrwPIPY5stQ2/ow6x4fOnOuko913xmqC62rkJHKFsEXpNdvwNWuR5qH/RgH7UaoJ2mTbj+4Ru5ZBkVH7krZ01jtNW8is5TlyAYQ+RlSvLLvlQzaaLMpukCF0dIBJ98OyQDbC5sLIo47i42xQrs3LIwacw2hHjEAJ6Cl1NbF0U3eqdz2ouRU7NlxeXIA5mFTGBU2AJIxzyOR1Mg461ESLks68vGGndv/Us9tdp1POYH98BG7hhQG14yoeG2Ig7SrewuPIdWvhlg+F2uRgnlk44YPZjdA3PKTF49aFTW17ZmmtibIaO4mStRrFrcw10kuaOobanOmVOIJIrRyIrHViV5bo8ril/MXrMhmoaOldvpjb4Jg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB8BCC0599750344AAA9489F79893FFC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3225642-2a58-4266-2f07-08d89015dd19
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2020 01:11:25.0483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QDmfM2Et2JYPx2JRN7Oasm6elN9Iu3siPaepASYV6iq83K4S922bwZvEROETf6oLeC5emKQ+uxUBeTyFUHsxPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2601
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.13, xch-aln-003.cisco.com
X-Outbound-Node: rcdn-core-3.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q2hhbmdlcyBsb29rIGdvb2QuDQpSZXZpZXdlZC1ieTogQXJ1bHByYWJodSBQb25udXNhbXkgPGFy
dWxwb25uQGNpc2NvLmNvbT4NCg0K77u/T24gMTEvMjAvMjAsIDU6MjIgUE0sICJLYXJhbiBUaWxh
ayBLdW1hciIgPGthcnRpbGFrQGNpc2NvLmNvbT4gd3JvdGU6DQoNCiAgICBUaGlzIGNoYW5nZSBp
cyB0byBhdm9pZCBsb29waW5nIGluDQogICAgZm5pY19zY3NpX2Fib3J0X2lvIGJlZm9yZSBzZW5k
aW5nIGZ3IHJlc2V0IHdoZW4NCiAgICBmbmljIGlzIGluIFRSQU5TIEVUSCBzdGF0ZSBhbmQgd2hl
biB3ZSBoYXZlIG5vdA0KICAgIHJlY2VpdmVkIGFueSBsaW5rIGV2ZW50cy4NCg0KICAgIFNpZ25l
ZC1vZmYtYnk6IEthcmFuIFRpbGFrIEt1bWFyIDxrYXJ0aWxha0BjaXNjby5jb20+DQogICAgU2ln
bmVkLW9mZi1ieTogU2F0aXNoIEtoYXJhdCA8c2F0aXNoa2hAY2lzY28uY29tPg0KICAgIC0tLQ0K
ICAgICBkcml2ZXJzL3Njc2kvZm5pYy9mbmljLmggICAgICB8IDMgKystDQogICAgIGRyaXZlcnMv
c2NzaS9mbmljL2ZuaWNfZmNzLmMgIHwgMiArKw0KICAgICBkcml2ZXJzL3Njc2kvZm5pYy9mbmlj
X21haW4uYyB8IDIgKysNCiAgICAgZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19zY3NpLmMgfCAzICsr
LQ0KICAgICA0IGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkN
Cg0KICAgIGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljLmggYi9kcml2ZXJzL3Nj
c2kvZm5pYy9mbmljLmgNCiAgICBpbmRleCBlZDAwYjYwNjFlMGMuLjZkYzhjOTE2ZGUzMSAxMDA2
NDQNCiAgICAtLS0gYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljLmgNCiAgICArKysgYi9kcml2ZXJz
L3Njc2kvZm5pYy9mbmljLmgNCiAgICBAQCAtMzksNyArMzksNyBAQA0KDQogICAgICNkZWZpbmUg
RFJWX05BTUUJCSJmbmljIg0KICAgICAjZGVmaW5lIERSVl9ERVNDUklQVElPTgkJIkNpc2NvIEZD
b0UgSEJBIERyaXZlciINCiAgICAtI2RlZmluZSBEUlZfVkVSU0lPTgkJIjEuNi4wLjQ5Ig0KICAg
ICsjZGVmaW5lIERSVl9WRVJTSU9OCQkiMS42LjAuNTAiDQogICAgICNkZWZpbmUgUEZYCQkJRFJW
X05BTUUgIjogIg0KICAgICAjZGVmaW5lIERGWCAgICAgICAgICAgICAgICAgICAgIERSVl9OQU1F
ICIlZDogIg0KDQogICAgQEAgLTI0NSw2ICsyNDUsNyBAQCBzdHJ1Y3QgZm5pYyB7DQogICAgIAl1
MzIgdmxhbl9od19pbnNlcnQ6MTsJICAgICAgICAvKiBsZXQgaHcgaW5zZXJ0IHRoZSB0YWcgKi8N
CiAgICAgCXUzMiBpbl9yZW1vdmU6MTsgICAgICAgICAgICAgICAgLyogZm5pYyBkZXZpY2UgaW4g
cmVtb3ZhbCAqLw0KICAgICAJdTMyIHN0b3BfcnhfbGlua19ldmVudHM6MTsgICAgICAvKiBzdG9w
IHByb2MuIHJ4IGZyYW1lcywgbGluayBldmVudHMgKi8NCiAgICArCXUzMiBsaW5rX2V2ZW50czox
OyAgICAgICAgICAgICAgLyogc2V0IHdoZW4gd2UgZ2V0IGFueSBsaW5rIGV2ZW50Ki8NCg0KICAg
ICAJc3RydWN0IGNvbXBsZXRpb24gKnJlbW92ZV93YWl0OyAvKiBkZXZpY2UgcmVtb3ZlIHRocmVh
ZCBibG9ja3MgKi8NCg0KICAgIGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX2Zj
cy5jIGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19mY3MuYw0KICAgIGluZGV4IDNmYzNhNzI3MWRj
MS4uMzMzN2Q2NjI3YmFmIDEwMDY0NA0KICAgIC0tLSBhL2RyaXZlcnMvc2NzaS9mbmljL2ZuaWNf
ZmNzLmMNCiAgICArKysgYi9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX2Zjcy5jDQogICAgQEAgLTU2
LDYgKzU2LDggQEAgdm9pZCBmbmljX2hhbmRsZV9saW5rKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29y
aykNCg0KICAgICAJc3Bpbl9sb2NrX2lycXNhdmUoJmZuaWMtPmZuaWNfbG9jaywgZmxhZ3MpOw0K
DQogICAgKwlmbmljLT5saW5rX2V2ZW50cyA9IDE7ICAgICAgLyogbGVzcyB3b3JrIHRvIGp1c3Qg
c2V0IGV2ZXJ5dGltZSovDQogICAgKw0KICAgICAJaWYgKGZuaWMtPnN0b3BfcnhfbGlua19ldmVu
dHMpIHsNCiAgICAgCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZmbmljLT5mbmljX2xvY2ssIGZs
YWdzKTsNCiAgICAgCQlyZXR1cm47DQogICAgZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9mbmlj
L2ZuaWNfbWFpbi5jIGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19tYWluLmMNCiAgICBpbmRleCA1
ZjhhN2VmOGY2YTguLmNhZDI5Njc5ZTkwZSAxMDA2NDQNCiAgICAtLS0gYS9kcml2ZXJzL3Njc2kv
Zm5pYy9mbmljX21haW4uYw0KICAgICsrKyBiL2RyaXZlcnMvc2NzaS9mbmljL2ZuaWNfbWFpbi5j
DQogICAgQEAgLTU4MCw2ICs1ODAsOCBAQCBzdGF0aWMgaW50IGZuaWNfcHJvYmUoc3RydWN0IHBj
aV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICplbnQpDQogICAgIAlmbmlj
LT5scG9ydCA9IGxwOw0KICAgICAJZm5pYy0+Y3Rsci5scCA9IGxwOw0KDQogICAgKwlmbmljLT5s
aW5rX2V2ZW50cyA9IDA7DQogICAgKw0KICAgICAJc25wcmludGYoZm5pYy0+bmFtZSwgc2l6ZW9m
KGZuaWMtPm5hbWUpIC0gMSwgIiVzJWQiLCBEUlZfTkFNRSwNCiAgICAgCQkgaG9zdC0+aG9zdF9u
byk7DQoNCiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19zY3NpLmMgYi9k
cml2ZXJzL3Njc2kvZm5pYy9mbmljX3Njc2kuYw0KICAgIGluZGV4IGQxZjdiODRiYmZlOC4uMTZl
NjZmNWI4MzNhIDEwMDY0NA0KICAgIC0tLSBhL2RyaXZlcnMvc2NzaS9mbmljL2ZuaWNfc2NzaS5j
DQogICAgKysrIGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19zY3NpLmMNCiAgICBAQCAtMjY3Myw3
ICsyNjczLDggQEAgdm9pZCBmbmljX3Njc2lfYWJvcnRfaW8oc3RydWN0IGZjX2xwb3J0ICpscCkN
CiAgICAgCS8qIElzc3VlIGZpcm13YXJlIHJlc2V0IGZvciBmbmljLCB3YWl0IGZvciByZXNldCB0
byBjb21wbGV0ZSAqLw0KICAgICByZXRyeV9md19yZXNldDoNCiAgICAgCXNwaW5fbG9ja19pcnFz
YXZlKCZmbmljLT5mbmljX2xvY2ssIGZsYWdzKTsNCiAgICAtCWlmICh1bmxpa2VseShmbmljLT5z
dGF0ZSA9PSBGTklDX0lOX0ZDX1RSQU5TX0VUSF9NT0RFKSkgew0KICAgICsJaWYgKHVubGlrZWx5
KGZuaWMtPnN0YXRlID09IEZOSUNfSU5fRkNfVFJBTlNfRVRIX01PREUpICYmDQogICAgKwkJICAg
ICBmbmljLT5saW5rX2V2ZW50cykgew0KICAgICAJCS8qIGZ3IHJlc2V0IGlzIGluIHByb2dyZXNz
LCBwb2xsIGZvciBpdHMgY29tcGxldGlvbiAqLw0KICAgICAJCXNwaW5fdW5sb2NrX2lycXJlc3Rv
cmUoJmZuaWMtPmZuaWNfbG9jaywgZmxhZ3MpOw0KICAgICAJCXNjaGVkdWxlX3RpbWVvdXQobXNl
Y3NfdG9famlmZmllcygxMDApKTsNCiAgICAtLSANCiAgICAyLjI5LjINCg0KDQo=
