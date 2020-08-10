Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF70C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 10:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C3B52070B
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 10:15:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UeoS4CKj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vJ7cHlQO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgHJKP1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 06:15:27 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:13477 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgHJKP1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 06:15:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1597054526; x=1628590526;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=DQVtCKfQWgd9j8u2FjhcHwL96GUGhMxt2LQ6gqd4zgU=;
  b=UeoS4CKji2rGqTcPRhV2zLakw0RGSJZe8C5GLiseZBXJbEVARHTsAupf
   LuejD9iPYX/L+NvlHPlcdiAvt+SYHerAxg3Ag+LFNGZaZNOtpi/9GJ+fg
   T/kfNqJ/UevmxK938EuW/53cghvi3AmYRJMPz0Q5fe8R7V40DqHzic+99
   pRB+u3LZPwVyRANiqMdpUYmTJTzvavBwaU/iTQVzzQUD8jIg2xmgh+h+A
   2TIuIwtloEE1qz+2gYdiUIOUSdQUx+gURZLYDut7zJxyco938+eyJ+cZD
   3eBZ8sfDY64hXMRY8ReslNvyjpQ/26zmQcxmwBYt6z3k+hqaJXdyIRgdi
   w==;
IronPort-SDR: CdPMiBC0xXyzIpH1GOlWfzZ2tQwtcQYcAGYjCsq6SWD9DwzKqRI7Q8xFxfNSKaVsNJkwVB+jOT
 j/yKsr1LHunJDF2JU/9czp54YUGGexhA0AsdWPSCMOJYyn/Yplqf3BDpox1/pGfBunnJmZ7zAG
 eXfMJlcFYyiU7iO9ilPAPxv4TCKoPoLI+gKM/72KV4JYL5o0pO9bIPIr1t55ec3qg7Zq6bGbX8
 SGMKKZZFHbjEYZHWp/zihvESSFoMGssj8fi1i73KZTr4Wk6nr02lXZSIKoyid1u4wg9VE8WJ+u
 7vo=
X-IronPort-AV: E=Sophos;i="5.75,457,1589212800"; 
   d="scan'208";a="145788972"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 10 Aug 2020 18:15:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofLV7yMQYkW3E2qnAjnqMTfEGDwCnS1BzuKlgL3XxQyK4gXmHvc8c/jLNmcsX6La7G4E1D8zg/txeNnTSySWaCmgg/r+eMdx+V4VA5n/VMPpLr5R1OLWDrm5ornDU1LtZTZ3SnhleTVsWI9XNEKgK2qLjhrAq9FbUUMVarPXChokmoGF519JQ+d0rj8ULW8O3XrLRMrd4dWmXyRuL1IcUXslkTx0LJ0AVlJbgKY/mEd9x0wT+o85loEmACTKdRn17//kWPLLjITcC4xPsPbM+WJb/mmabeJ0VUU77r/CB6s58k6hA06WCMW/TyUeIfzRjMSBvRHkFhJlrY4bA3tNBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQVtCKfQWgd9j8u2FjhcHwL96GUGhMxt2LQ6gqd4zgU=;
 b=WSROBgdo+PriziJ8pmC1tZEoGS7ehhhdNxqmVdtUtGN/upbZPiPq9KEiWRUF/uF58PrQgjK9N9Q1DHLpRo48tRaYgLBOXYc65XyIGsNAL8LLrENgTBkeKm/83Y4TVlMdhQTNWPxL0O2QDLfeFwN9YhG3BBpX2ODR5/TbiMLPmGctfiDIFnkkAGUN57eFWpf1PLFnAEjusnUrWi2OBdkLqNcpVU/G1lT+xBioWAScdrYNmCgx/Tu8Egh3RWGAc8i1XP/Pg8s7FND3sboZ/uHP1nJXVWw82UN65tpk3WtAQpB1OQ6YioNh2naFD5sHksKLtmRa1h5z5mdQzgMD54N6AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQVtCKfQWgd9j8u2FjhcHwL96GUGhMxt2LQ6gqd4zgU=;
 b=vJ7cHlQOxAb1nYp4/WB88D23WpSMie3sV3P7ajmzZ5f0XcLc1l4u7g8kQ551RIFp4/mgxRP9HllO5J+es6cjrTiyyD6sa3LL+aJUxF7Vkw0ia+N+/C1qhuwibCIbZWar/IBD+AWq6Y0u5aZbgc9Qsve3AVcfwfGbyBq7NevyGBg=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4717.namprd04.prod.outlook.com (2603:10b6:805:a8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.20; Mon, 10 Aug
 2020 10:15:23 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68%7]) with mapi id 15.20.3261.024; Mon, 10 Aug 2020
 10:15:23 +0000
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
Subject: RE: [PATCH v3] ufs: change the way to complete fDeviceInit
Thread-Topic: [PATCH v3] ufs: change the way to complete fDeviceInit
Thread-Index: AQHWbv6OA7wnwTRmxEGEMu+q6YeUQ6kxIB2A
Date:   Mon, 10 Aug 2020 10:15:23 +0000
Message-ID: <SN6PR04MB4640676A86C1A3C598CD804AFC440@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200810101054epcas2p2e1a4a550e7f4732e2ad1ee127317b0d2@epcas2p2.samsung.com>
 <1597053747-75171-1-git-send-email-kwmad.kim@samsung.com>
In-Reply-To: <1597053747-75171-1-git-send-email-kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f75d880c-4b20-4c21-386a-08d83d164b2b
x-ms-traffictypediagnostic: SN6PR04MB4717:
x-microsoft-antispam-prvs: <SN6PR04MB47178862ACDFF80C619F058CFC440@SN6PR04MB4717.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 165EIcdUqThPfhXojFLDi5l7pNabncXdrgQuzNvezFACjEMERJZ+m+Y/eh27aACef7x5XXKdyxW+IgmPdujwNNqmEKgvam5kOk0Oeh1MiQOBl7Blo014vYhrCHcGi4NdLof98HvwLGvgY/dalGpO+MP/4iqn4GwAcJjkWnjKMItYC8L7MdHF/c7/fOLHCQMAhtbN60doexYSWy4tD4ohw1IAKnKhweTwxxPgxl3t9iB6RNsx+qidFZrYiMaUhG9iHO5dxF3zoxMrJeYOcGMEjq+9OcZJ/KZGsVgily8QlY6YvBsc+xsQ0mpcZTqZM2PgF7X5dE7TVCKuqFXwPkkwsi39UL57YdB5IUJniklvM0ul8THYtSrJeKrPTT82hRqfaLX7sxGdascWSVBD6/cauw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(8936002)(33656002)(478600001)(55016002)(9686003)(7416002)(110136005)(4744005)(76116006)(66556008)(64756008)(66446008)(66476007)(316002)(6506007)(66946007)(7696005)(71200400001)(186003)(26005)(8676002)(52536014)(2906002)(86362001)(5660300002)(43043002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zE7/vrqww92CeRpcS7fqMD8wQzMu7juyiaW/ZjOeokMQsWRlgpp2TySXrT6/a+pB5qMNdEIpbVMfG0HLczVqW/IonvXX0aCudZ7rbenrhFGwDrTQmPjRSuB+Ua8CaeIzOkLf7fZ61fD/E0NCMByoYa86M3V77q8Wk7SFQ5GKgr3kvNbwM8xIPa9SAATrrLcTe1fTxTGpvKgmFNqSJUXDeqtYBbcacDCSy+UybGHRI/N2uxK37ru4YAXGCaksQ+IRqM7vZIjg4g+t+YL+5z8I0cZSPFWtB/dn6O3ms+XK/bO7rbC2gMgtyRtszhn1pKjJuHrbditsr4m5TSe1MJz0CBVa6jYIjmpntsZ+/cyhbPDOfGdN5ZmUk4tScyu1UUgmF2ECkLPBczLoMAz/BwQbNt+Biqx3I1fXsUcnjyA7SWTNM1swnMEFVePUGKrj5yJKQl93bxmFt6bu5egWWmBm7iLDYd5Al6OpTlRlSSgB8NQIoHcQgG4Ka97HpexZ5BkmJ15gfRxzVY8+Bee+uXUYaNiHLS9VtvXtRiZEDOKW+HOwkI1Pg2jXsck+7wi6cL6aOxLVt+UwUE/PIflgtJ15P1eyDpY3EluKpC55+2XKpMdGyBnmWph9IAeym3cntph2hliGLoetpYT20jviJjN7BA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f75d880c-4b20-4c21-386a-08d83d164b2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2020 10:15:23.0994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dGMtFpWkME2LvztTmKWEnZtdopRRqcbVQqPeR68uuQG1TlNzw8TzOZk+hzTqBnuQ0aPUdNtHQJt88A9oxFGCFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4717
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+IEN1cnJlbnRseSwgVUZTIGRyaXZlciBjaGVja3MgaWYgZkRldmljZUluaXQNCj4g
aXMgY2xlYXJlZCBhdCBzZXZlcmFsIHRpbWVzLCBub3QgcGVyaW9kLiBUaGlzIHBhdGNoDQo+IGlz
IHRvIHdhaXQgaXRzIGNvbXBsZXRpb24gd2l0aCB0aGUgcGVyaW9kLCBub3QgcmV0cnlpbmcuDQo+
IE1hbnkgZGV2aWNlIHZlbmRvcnMgdXN1YWxseSBwcm92aWRlcyB0aGUgc3BlY2lmaWNhdGlvbiBv
bg0KPiBpdCB3aXRoIGp1c3QgcGVyaW9kLCBub3QgYSBjb21iaW5hdGlvbiBvZiBhIG51bWJlciBv
ZiByZXRyeWluZw0KPiBhbmQgcGVyaW9kLiBTbyBpdCBjb3VsZCBiZSBwcm9wZXIgdG8gcmVnYXJk
IHRvIHRoZSBpbmZvcm1hdGlvbg0KPiBjb21pbmcgZnJvbSBkZXZpY2UgdmVuZG9ycy4NCj4gDQo+
IHYxIC0+IHYyOiBzd2l0Y2ggdGhlIG1ldGhvZCB0byBnZXQgdGltZSBmcm9tIGppZmZpZXMgdG8g
a3RpbWUNCj4gDQo+IFRlc3RlZC1ieTogS2l3b29uZyBLaW0gPGt3bWFkLmtpbUBzYW1zdW5nLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogS2l3b29uZyBLaW0gPGt3bWFkLmtpbUBzYW1zdW5nLmNvbT4N
ClJldmlld2VkLWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCg==
