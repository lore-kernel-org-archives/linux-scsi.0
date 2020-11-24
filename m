Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB98C63697
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 01:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3953320729
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 01:18:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="JybPIJWi";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="pG6bqFkw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgKXBRz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 20:17:55 -0500
Received: from alln-iport-2.cisco.com ([173.37.142.89]:40285 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727735AbgKXBRy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 20:17:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3548; q=dns/txt; s=iport;
  t=1606180674; x=1607390274;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/jQHFCGSDs5nO12AdDAu+Q3Vzte7SGZ4/hz9JWPOlAc=;
  b=JybPIJWi0RXnKUSF/3CxPEkUBxS9E4UjGuIEP6dCRPZaJyINeAomwuzB
   gCyuWJKi3CVEoeYpCxwFNETC/EA3Htwr2wz1A7Go+VfdU8/bXFxQ0Z8YJ
   SCz6Pif6q+jvLlFIHhoQQeLK9qQdNKN4GL3BZLatEtDEKEj283M1smHQQ
   Q=;
X-IPAS-Result: =?us-ascii?q?A0DSCADKXLxffZJdJa1iHgEBCxIMQIMhUYFULxcXCoQzg?=
 =?us-ascii?q?0kDpl2CUwNUCwEBAQ0BAS0CBAEBhEoCF4IUAiU4EwIDAQEBAwIDAQEBAQUBA?=
 =?us-ascii?q?QECAQYEFAEBhjwMhXMCAQMSEQQNDAEBNwEPAgEIGgImAgICMBUQAgQBDQUig?=
 =?us-ascii?q?wSCVgMuAaNaAoE8iGh2fzODBAEBBYUoGIIQCYEOKoJzg3aGVxuBQT+BOByCT?=
 =?us-ascii?q?z6EPheDADOCLJM0PZJ/kVoKgm6bHgMflhSLcS2TL6BgAgQCBAUCDgEBBYFrI?=
 =?us-ascii?q?YFZcBU7KgGCPlAXAg2OHwwXg06KWHQ3AgYBCQEBAwl8jDsBgRABAQ?=
IronPort-PHdr: =?us-ascii?q?9a23=3AZv6nKxMUgV5E4TZ1cOQl6mtXPHoupqn0MwgJ65?=
 =?us-ascii?q?Eul7NJdOG58o//OFDEvKwx3lTIRo7crflDjrmev6PhXDkG5pCM+DAHfYdXXh?=
 =?us-ascii?q?AIwcMRg0Q7AcGDBEG6SZyibyEzEMlYElMw+Xa9PBteGd31YBvZpXjhpTIXEw?=
 =?us-ascii?q?/0YAxyIOm9E4XOjsOxgua1/ZCbYwhBiDenJ71oKxDjpgTKvc5Qioxneas=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.78,364,1599523200"; 
   d="scan'208";a="620310046"
Received: from rcdn-core-10.cisco.com ([173.37.93.146])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 24 Nov 2020 01:10:47 +0000
Received: from XCH-ALN-005.cisco.com (xch-aln-005.cisco.com [173.36.7.15])
        by rcdn-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id 0AO1Alwp008495
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 24 Nov 2020 01:10:47 GMT
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by XCH-ALN-005.cisco.com
 (173.36.7.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 19:10:46 -0600
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-rcd-002.cisco.com
 (173.37.227.247) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 19:10:45 -0600
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 19:10:45 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EdgXfeGr/tph9G+m1MoMLO0/NBCca1w3zmEJN1ftId93VcKFVwAuLb6AyFFJPMl/cwGr/HpUiLqTuGvqjBAT/DMQfT06IggNn35ZxyzFUpaB/VLz2fdYNK8uCgng+MqQ1qCIVm9xLCfpIB2/nW5gvsgR2OoTtMaBKeUJTwq7kBtPT8qtYeNisXV3IcEejB1DO0jn4Z6XrX6eKHARpu1AFR/vx1AqGFAgvsuCmlr2hDUn4kPLtYedvl/4zotT3giw8qOOzqM7BY2I+AVyd/WJb9xI7jhNuICSmt30RX0m4Q9tvqVCgCvUT12snHISFXfSFQ8brU2hhsjzgw2HF62QiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jQHFCGSDs5nO12AdDAu+Q3Vzte7SGZ4/hz9JWPOlAc=;
 b=A20ypSDZUO+i5gG43vrqjb8dk1RtguviBnfIOO0ROKBiZxssLzuueglCG1SdeDnubgVPY+yECcpIyOWu1SaibpD/4DN0UOQyCHei2foImRSCzO9U//L2McZSiaOj6SIvKZB5wXp9l+gjSGLkaTsYPP++xmispQwwZluFZZwj6x+1Co8giaCn1HM31sH64nuyesgaesjUCseWrp1ld8LAjA3Z9TTUcKQrJm0rT5gOvllxFmiRNIu5TfxDl4HxbE9ubGpsk8jRoIZPvI7mZ45aTaPVVZL3ukC/jQbST8fpX1UpBn/CFjqSsFytGTfa8+3YJCgj2/d2eMqV4u8erO8mnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jQHFCGSDs5nO12AdDAu+Q3Vzte7SGZ4/hz9JWPOlAc=;
 b=pG6bqFkwaQJWrKFAdeRVRvMj4kpvb/IqpOvVqkscR43+PcVXcdQMSzmtEJgvPCtMq64IAD1d/AmWQuje/SvX0nry8TID4ssHgXGrY5Bny/pn500PPnhK1HDow+LzWtbfK3oeSiwQpWRSOEFAOxjw+MxqAlSLSVYEngPj+WuOe54=
Received: from DM6PR11MB3289.namprd11.prod.outlook.com (2603:10b6:5:5f::10) by
 DM6PR11MB2601.namprd11.prod.outlook.com (2603:10b6:5:ce::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.22; Tue, 24 Nov 2020 01:10:45 +0000
Received: from DM6PR11MB3289.namprd11.prod.outlook.com
 ([fe80::dd7d:47e3:8339:16d2]) by DM6PR11MB3289.namprd11.prod.outlook.com
 ([fe80::dd7d:47e3:8339:16d2%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 01:10:45 +0000
From:   "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>
To:     "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
        "Satish Kharat (satishkh)" <satishkh@cisco.com>
CC:     "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: fnic: Change shost_printk with FNIC_FCS_DBG
Thread-Topic: [PATCH] scsi: fnic: Change shost_printk with FNIC_FCS_DBG
Thread-Index: AQHWv4mda8aRcxBZsECDlJL+p5prG6nV+BOA
Date:   Tue, 24 Nov 2020 01:10:45 +0000
Message-ID: <58CCBA06-7F76-46C8-B0D5-194B5157E861@cisco.com>
References: <20201120220712.16708-1-kartilak@cisco.com>
In-Reply-To: <20201120220712.16708-1-kartilak@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.43.20110804
authentication-results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [98.35.85.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51c51e5f-21ab-476d-3413-08d89015c55d
x-ms-traffictypediagnostic: DM6PR11MB2601:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB2601C4AB1D632CCEC119FA29D5FB0@DM6PR11MB2601.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vbWxRnPilPpwnbONMSvbz5UZacfkdfAfRQQK+EfVPGDQTKcOIiPrzoJ0fjSddXulJwIxa81tuRjZnnxkSXnKV/FlGAOoztkBlZChBCssJst/EYm6hZc9evG8LqRYOOBuGCkiGYcDWl5eh2OfsSCiYWlxpJt/ad9oEPaiaALxwANIeDW6+mjMyCSqXH6XVItVtHJj1AAYxzrR4sI+OBGsvVnfPmkMJF+CzimSuUMUaicEL1BwoV705mOLdV0CsPf9YNk/JoYDKRWTCfwfzauk3ZQU94lp438o4TdSwgcpdvSMQihHt3uSbQrzjroys2RIxDyiknK3OvOWZdSgZCnEgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(136003)(39860400002)(4326008)(83380400001)(2616005)(54906003)(2906002)(316002)(478600001)(5660300002)(110136005)(8936002)(8676002)(6506007)(6486002)(86362001)(6636002)(36756003)(66556008)(91956017)(66476007)(71200400001)(76116006)(6512007)(66446008)(64756008)(33656002)(186003)(66946007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZMrHd4J1AihBKVDn36ioKH+UYjS0rdA218txjIgJebA8iw0J6axC+Lw7uC5wN1DJ1ttg9D0bRA8ngwzkPZLe9k9pxyHWNMtedhSD8JNnJVO0JChVF0Z+Pe854NaR/PbTwujZB7UrX+C0MD60vun0RbCQENlNzMf67AN3qaDqkimH2nCm5qAHqDSLMV6RsI9wDt2CxRoa+MTFeTRAZ3a1gOgY/29EesfVldwo53OJVok/B4D1/NvcFmEWc5NP/qa5RUHDGNTuDF7+AH0s+4Yn8Z7olGqoelFOjEC0cX4miOVEOXmfpN73Gr71L13h4ej6QD0Dy4IB/wNwR25aHAgkDlx3RmTuVEdKE08WumgYdb8+kfj95/yDVrS2g6UrLFVO9HTLKjwkmc4lmg0H1OBivBqAivr4m04Fj1WnYfXMdG4jDcOv8UMaa94aS9Oc9SQ4njTsPYidKEn2o5H0+cfRtYE3MUmfE5wRSINH9lh2ViKQggI8DhJzbWmqYfZHqLjgzM5ejsg/OBiC0aNa96FZwopCoHNXODsJAjNftDWk9lMfSWrITf9q2lcYNEN5e/8idnvwqgc2KeTSLTW/XYtAXZdbhJVR1g045kWW91EYJ+DhFYBJECpfZ4QxqZfDpjXTJA8aipMWCNhC9e4Fuum9XrJwbpeQ2VqIzBI5hVW94ccr9Q0GAXRiB+U+i/vNNE0hUcVYfM5xcfs97GocscdtwmlIMAYAM+BnMEgxZxk27zPagq4Mq286H9mkzZcfZUDVo+uwfOavXwoOQqEfyEn3iTD4ghNYX3zhLjlYhKnOFnyHGjj9GkfvJTN0O8W2oH8RNzwUN0IcBChj+CM12y1yIhNEz1770dL6uEjfDMJNCEPYoGHdSMOyTyWWjRVfl1UUjpAOsQ9unIwkLgMDMJ1vFg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <D236FFAA2357E94C8B7BA0E4EEDAAE4B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51c51e5f-21ab-476d-3413-08d89015c55d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2020 01:10:45.2248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: acGsSG2Peb0jwO85COYOJ97bkOPQ2EiCmsUlc0UDCnb+j9lM2XtAde+8PhFe2A7gdBkberO+DHYo4U1XuxIuuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2601
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.15, xch-aln-005.cisco.com
X-Outbound-Node: rcdn-core-10.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Q2hhbmdlcyBsb29rIGdvb2QuDQpSZXZpZXdlZC1ieTogQXJ1bHByYWJodSBQb25udXNhbXkgPGFy
dWxwb25uQGNpc2NvLmNvbT4NCg0K77u/T24gMTEvMjAvMjAsIDI6MDggUE0sICJLYXJhbiBUaWxh
ayBLdW1hciIgPGthcnRpbGFrQGNpc2NvLmNvbT4gd3JvdGU6DQoNCiAgICBSZXBsYWNpbmcgc2hv
c3RfcHJpbnRrIHdpdGggRk5JQ19GQ1NfREJHIHNvIHRoYXQNCiAgICB0aGVzZSBsb2cgbWVzc2Fn
ZXMgYXJlIGNvbnRyb2xsZWQgYnkgZm5pY19sb2dfbGV2ZWwNCiAgICBmbGFnIGluIGZuaWNfZmlw
X2hhbmRsZXJfdGltZXIuDQoNCiAgICBCdW1waW5nIHVwIHZlcnNpb24gbnVtYmVyIGZyb20gNDcg
dG8gNDkgdG8NCiAgICBtYWludGFpbiBzYW1lIGxldmVsIGFzIGludGVybmFsIHZlcnNpb24uDQoN
CiAgICBTaWduZWQtb2ZmLWJ5OiBLYXJhbiBUaWxhayBLdW1hciA8a2FydGlsYWtAY2lzY28uY29t
Pg0KICAgIFNpZ25lZC1vZmYtYnk6IFNhdGlzaCBLaGFyYXQgPHNhdGlzaGtoQGNpc2NvLmNvbT4N
CiAgICAtLS0NCiAgICAgZHJpdmVycy9zY3NpL2ZuaWMvZm5pYy5oICAgICB8IDIgKy0NCiAgICAg
ZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19mY3MuYyB8IDYgKysrLS0tDQogICAgIDIgZmlsZXMgY2hh
bmdlZCwgNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KDQogICAgZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS9mbmljL2ZuaWMuaCBiL2RyaXZlcnMvc2NzaS9mbmljL2ZuaWMuaA0KICAg
IGluZGV4IDQ3NzUxM2RjMjNiNy4uZWQwMGI2MDYxZTBjIDEwMDY0NA0KICAgIC0tLSBhL2RyaXZl
cnMvc2NzaS9mbmljL2ZuaWMuaA0KICAgICsrKyBiL2RyaXZlcnMvc2NzaS9mbmljL2ZuaWMuaA0K
ICAgIEBAIC0zOSw3ICszOSw3IEBADQoNCiAgICAgI2RlZmluZSBEUlZfTkFNRQkJImZuaWMiDQog
ICAgICNkZWZpbmUgRFJWX0RFU0NSSVBUSU9OCQkiQ2lzY28gRkNvRSBIQkEgRHJpdmVyIg0KICAg
IC0jZGVmaW5lIERSVl9WRVJTSU9OCQkiMS42LjAuNDciDQogICAgKyNkZWZpbmUgRFJWX1ZFUlNJ
T04JCSIxLjYuMC40OSINCiAgICAgI2RlZmluZSBQRlgJCQlEUlZfTkFNRSAiOiAiDQogICAgICNk
ZWZpbmUgREZYICAgICAgICAgICAgICAgICAgICAgRFJWX05BTUUgIiVkOiAiDQoNCiAgICBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19mY3MuYyBiL2RyaXZlcnMvc2NzaS9mbmlj
L2ZuaWNfZmNzLmMNCiAgICBpbmRleCBlMzM4NGFmYjdjYmQuLjNmYzNhNzI3MWRjMSAxMDA2NDQN
CiAgICAtLS0gYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX2Zjcy5jDQogICAgKysrIGIvZHJpdmVy
cy9zY3NpL2ZuaWMvZm5pY19mY3MuYw0KICAgIEBAIC0xMzQ5LDcgKzEzNDksNyBAQCB2b2lkIGZu
aWNfaGFuZGxlX2ZpcF90aW1lcihzdHJ1Y3QgZm5pYyAqZm5pYykNCiAgICAgCX0NCg0KICAgICAJ
dmxhbiA9IGxpc3RfZmlyc3RfZW50cnkoJmZuaWMtPnZsYW5zLCBzdHJ1Y3QgZmNvZV92bGFuLCBs
aXN0KTsNCiAgICAtCXNob3N0X3ByaW50ayhLRVJOX0RFQlVHLCBmbmljLT5scG9ydC0+aG9zdCwN
CiAgICArCUZOSUNfRkNTX0RCRyhLRVJOX0RFQlVHLCBmbmljLT5scG9ydC0+aG9zdCwNCiAgICAg
CQkgICJmaXBfdGltZXI6IHZsYW4gJWQgc3RhdGUgJWQgc29sX2NvdW50ICVkXG4iLA0KICAgICAJ
CSAgdmxhbi0+dmlkLCB2bGFuLT5zdGF0ZSwgdmxhbi0+c29sX2NvdW50KTsNCiAgICAgCXN3aXRj
aCAodmxhbi0+c3RhdGUpIHsNCiAgICBAQCAtMTM3Miw3ICsxMzcyLDcgQEAgdm9pZCBmbmljX2hh
bmRsZV9maXBfdGltZXIoc3RydWN0IGZuaWMgKmZuaWMpDQogICAgIAkJCSAqIG5vIHJlc3BvbnNl
IG9uIHRoaXMgdmxhbiwgcmVtb3ZlICBmcm9tIHRoZSBsaXN0Lg0KICAgICAJCQkgKiBUcnkgdGhl
IG5leHQgdmxhbg0KICAgICAJCQkgKi8NCiAgICAtCQkJc2hvc3RfcHJpbnRrKEtFUk5fSU5GTywg
Zm5pYy0+bHBvcnQtPmhvc3QsDQogICAgKwkJCUZOSUNfRkNTX0RCRyhLRVJOX0lORk8sIGZuaWMt
Pmxwb3J0LT5ob3N0LA0KICAgICAJCQkJICAiRGVxdWV1ZSB0aGlzIFZMQU4gSUQgJWQgZnJvbSBs
aXN0XG4iLA0KICAgICAJCQkJICB2bGFuLT52aWQpOw0KICAgICAJCQlsaXN0X2RlbCgmdmxhbi0+
bGlzdCk7DQogICAgQEAgLTEzODIsNyArMTM4Miw3IEBAIHZvaWQgZm5pY19oYW5kbGVfZmlwX3Rp
bWVyKHN0cnVjdCBmbmljICpmbmljKQ0KICAgICAJCQkJLyogd2UgZXhoYXVzdGVkIGFsbCB2bGFu
cywgcmVzdGFydCB2bGFuIGRpc2MgKi8NCiAgICAgCQkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
JmZuaWMtPnZsYW5zX2xvY2ssDQogICAgIAkJCQkJCQlmbGFncyk7DQogICAgLQkJCQlzaG9zdF9w
cmludGsoS0VSTl9JTkZPLCBmbmljLT5scG9ydC0+aG9zdCwNCiAgICArCQkJCUZOSUNfRkNTX0RC
RyhLRVJOX0lORk8sIGZuaWMtPmxwb3J0LT5ob3N0LA0KICAgICAJCQkJCSAgImZpcF90aW1lcjog
dmxhbiBsaXN0IGVtcHR5LCAiDQogICAgIAkJCQkJICAidHJpZ2dlciB2bGFuIGRpc2NcbiIpOw0K
ICAgICAJCQkJZm5pY19ldmVudF9lbnEoZm5pYywgRk5JQ19FVlRfU1RBUlRfVkxBTl9ESVNDKTsN
CiAgICAtLSANCiAgICAyLjI5LjINCg0KDQo=
