Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E6EC2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 01:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36FDD20728
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 01:17:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="mtWJ/Z+U";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="p6XCy8+Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgKXBRu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 20:17:50 -0500
Received: from alln-iport-4.cisco.com ([173.37.142.91]:18464 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727735AbgKXBRt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 20:17:49 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2020 20:17:46 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2246; q=dns/txt; s=iport;
  t=1606180667; x=1607390267;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v/W2xRlWDt36+5t6ADBR8kkHMP09nZpL9qN0Ana+vGY=;
  b=mtWJ/Z+U9CYhDtvlPxWJLYYKiPKsBphfAJMW8oDtmI7qhTN5IvE7oSlN
   MPXELPkNRyu70MyWdM8/4aYWZQwgAY8w5SB0s33WyFJ2mbvpZCj+42T9t
   gEeLPIaD9v3uDMYnDv331TArbJXmoKtZTuZRPULbugCVEfd5oemP48BMQ
   c=;
X-IPAS-Result: =?us-ascii?q?A0BYBwAlXLxffYMNJK1iHQEBAQEJARIBBQUBQIFPgVJRg?=
 =?us-ascii?q?VQvFxcKhDODSQOmXoJTA1QLAQEBDQEBLQIEAQGESgIXghQCJTgTAgMBAQEDA?=
 =?us-ascii?q?gMBAQEBBQEBAQIBBgQUAQGGPAyFcwIBAxIRBA0MAQE3AQ8CAQgaAiYCAgIwF?=
 =?us-ascii?q?RACBAENBSKDBIJWAy4Bo1gCgTyIaHZ/M4MEAQEFhSgYghAJgQ4qgnODdoZXG?=
 =?us-ascii?q?4FBP4E4HIJPPoQ+F4MAM4IskzQ9pFkKgm6bHgMWCaIFLZMvoGACBAIEBQIOA?=
 =?us-ascii?q?QEFgWshgVlwFWUBgj5QFwINjh8MF4NOilh0NwIGAQkBAQMJfIw7AYEQAQE?=
IronPort-PHdr: =?us-ascii?q?9a23=3AZcmnTBREUUUJpdk6NlY2oIJWatpsv++ubAcI9p?=
 =?us-ascii?q?oqja5Pea2//pPkeVbS/uhpkESQBNmJ4PNfgO2QuKflCiQM4peE5XYFdpEEFx?=
 =?us-ascii?q?oIkt4fkAFoBsmZQVb6I/jnY21ffoxCWVZp8mv9PR1TH8DzNFbTuXa1qzUVH0?=
 =?us-ascii?q?a3OQ98PO+gHInUgoy+3Pyz/JuGZQJOiXK9bLp+IQ/wox/Ws5wdgJBpLeA6zR?=
 =?us-ascii?q?6arw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.78,364,1599523200"; 
   d="scan'208";a="598418768"
Received: from alln-core-1.cisco.com ([173.36.13.131])
  by alln-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 24 Nov 2020 01:14:43 +0000
Received: from XCH-ALN-001.cisco.com (xch-aln-001.cisco.com [173.36.7.11])
        by alln-core-1.cisco.com (8.15.2/8.15.2) with ESMTPS id 0AO1Eh2i014325
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 24 Nov 2020 01:14:43 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-ALN-001.cisco.com
 (173.36.7.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 19:14:43 -0600
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 19:14:41 -0600
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 19:14:42 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYxZSTp+elTXNAPRb3geVYUyi/oaOuf2P6Vx9E8WEi0q/Sr49+RueiQnXGgvYQrKo8xoVCBxB64/lvT/cxhBaW73fFLHsE3bVCO47qnTPvMcoqjjQArv6Z/vDny1KJGMWjCTnZYqTQvQz1j0uozAqwZgLC2gl6D3Kd9GR79EkbdTdaofNEtJSEqW7hvwIEPS8Q8WAQe9gaMMuuUHCCKlbglI1bmFJAf5hegzHZOX/9zw/GLm67yy9rZ827D9U6z/me/oshRoO3o0Kn4C+NVNmk/qOfQfSrWq+l7WbAZcU8kzF34fDYZ/9F5rDFmokUlzO0f1ZGDkZjv9xiS46olyxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/W2xRlWDt36+5t6ADBR8kkHMP09nZpL9qN0Ana+vGY=;
 b=ElcCXrDU792Ec9CHLRJ+pnquQ7lV3vbriM61tsgPxAY2OvO3nQNoYW+f3Vw1raKjMOW45nhbWBIF7kmcvXl//0RpbVBGwV5Ba4iCKW6CJW8pO7lYT+UR8ENUdVGwL1zhWlK2xUqRsvFqW2e4qHUgPEBMhl5wvPYDkCH24Yh/Igi0dDVMkWP0t/f+gsKDn8xYGuHEqUVGxnwBEeS6L4kdq1kSNBbhCwqSwdpgTKC3nTTg47Om+umSlHuKAmDWE1Ue1oj3xnbApLlrAlKp731k3R5pH/HeEVe3doJr9JZuBVrwKAmSh5AyugAa6dZstWDLsnUjNRGenZxJR5weAYts6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/W2xRlWDt36+5t6ADBR8kkHMP09nZpL9qN0Ana+vGY=;
 b=p6XCy8+QZATBT8xEWJP9pigIFLUNvYfHoY0wsoClUICqRbJn7FAjZVc14OwU59AjsXICq75WSr3kgGEUo86+pEiv3n7ZaGpszUgb+9vxkBb5Ov8WMWIEwxkx9SIMuHGoLvvF0swzg2u5MmdDTfXKD7IblWmiIEmEC4PbFlV/5YU=
Received: from DM6PR11MB3289.namprd11.prod.outlook.com (2603:10b6:5:5f::10) by
 DM6PR11MB2601.namprd11.prod.outlook.com (2603:10b6:5:ce::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.22; Tue, 24 Nov 2020 01:14:40 +0000
Received: from DM6PR11MB3289.namprd11.prod.outlook.com
 ([fe80::dd7d:47e3:8339:16d2]) by DM6PR11MB3289.namprd11.prod.outlook.com
 ([fe80::dd7d:47e3:8339:16d2%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 01:14:40 +0000
From:   "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>
To:     "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
        "Satish Kharat (satishkh)" <satishkh@cisco.com>
CC:     "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: fnic: Change shost_printk to FNIC_MAIN_DBG
Thread-Topic: [PATCH] scsi: fnic: Change shost_printk to FNIC_MAIN_DBG
Thread-Index: AQHWv6cBOJG+nRK+7EOQ8t+oDJ2nSqnV+PKA
Date:   Tue, 24 Nov 2020 01:14:40 +0000
Message-ID: <E34F9542-55FC-41EA-B757-9BBDCD6331C0@cisco.com>
References: <20201121013739.18701-1-kartilak@cisco.com>
In-Reply-To: <20201121013739.18701-1-kartilak@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.43.20110804
authentication-results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [98.35.85.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22350fc3-d6bf-4cbb-4b44-08d8901651b1
x-ms-traffictypediagnostic: DM6PR11MB2601:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB26011A53788E44F676AE1725D5FB0@DM6PR11MB2601.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IaRmpBo94iezE+TTfHy70yNKSMF5VY6t7wj1t1OKJPPgboApZ5oSRApMzFcDCFbaNOG3NZYMMyCORIll3ZSA6t3w0U7JP/FeA0OBr6Tdx1Zy13KWVAUNCFhgGZABD7I2Lpf3ieHAP57FRlObcrqyPi0iPnVmmmhjKr+vcLOQcknA15Eb2rQacQ+at2k/Bxc+3DHKM+dR2wPzkSyUsdcWKHq0ERO8N62JrkPwkN15PWIUVdzb9RlQodbYClPvuu+5Yzt7yM5/SArgsZtLCMKYZbqD1356fCbW9WVgHLEBiNm7lZzRf2WljaUkGUSJMObr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(136003)(39860400002)(4326008)(83380400001)(2616005)(54906003)(2906002)(316002)(478600001)(5660300002)(110136005)(8936002)(8676002)(6506007)(6486002)(86362001)(6636002)(36756003)(66556008)(91956017)(66476007)(71200400001)(76116006)(6512007)(66446008)(64756008)(33656002)(186003)(66946007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wx8NGamXYaTvL5EBHPsw+bk00qHuUSgezo0Ggo6Pdl1RScSY7XEyok6uLSLS91Dut0IVjgj/ELBI4wUDpXgQZHA2mWULlp4bnHFVIpnkTFIuN7X+h412n+nNNo5z0G3OC29/dI/EM8wKyB7tNbv/YYp7C4poSfZ5fwK+6YEIGNxwbHOTQE5ZL9zG9IihHTmPRmoZS6ebD52N1z9aINKSqDzjRFmwWc1e5WbcV5GWy38Fd+P5DK8E3BS6xZwY5PQEFDoj67reux0v3gvriYqlLPGjzzAsKfXcAhxQL8bKAASlG15Y2xm0TGnsN6p3G6qbGX3nu3OvM2rFJ05atMmlHj9OE/4xH40zJqBt31oE5aN2wAQMPDeOw3RpF44c0kXRlbf0XNCsv6OlIc4O3KTH7RiDXVV+PKszXGCAx2FrJSLzRlV29fv3hgfOP+SXO3+KJ0GyrZ0V7FfTlD8B38oaHwkKw33HyEGIWscRqHomDFN846HnAnXR2o4IoNXKph7yYD29xu6n6VYg5PPZzpLg9D4xIilblW5UWpPPWxKQ6jXL5cTRO908kcO6nBs9mC9euJuhT2AhcWIeqwcKVKBDsOoKl9cchkJ/xQTjqvVdo/GCIjMmv0ltQ/6SMr5vyI2GVkOfHw69UKxyK8oV6/1vMODAGQzWCm3Ldb2rQ967/uUn5ksGBgYX7o+gL0EnlTiJGCLYrEUDhn7mV1iduYkbPGzbh6vsFFV9WF+Ln748UYSuvYvhkOFXoZ3LW4gjlMWqmIqtVopKf0qd8v+9N/GXPMTecusGgKZMqpyrEm12XZocXklousn3trHbgAC6knscL7JkvuyTM1tpkTZq5v5K2vLafTT7ye2/Pvl2fMryw880WQ4qXOwa6LJRbYy7uBa9SQwjjNB4ecVSOfSisYb+vg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <2378A7A47797B44BAB78FD0143F6D9BD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22350fc3-d6bf-4cbb-4b44-08d8901651b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2020 01:14:40.6779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wrk2OEu4S12h/mLVDF6KBPplGIunv62K4GqR/R39r9sqt6uzmbEAuIqOJidN9ikEB4O2JTWwct8QV81D0//ZcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2601
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.11, xch-aln-001.cisco.com
X-Outbound-Node: alln-core-1.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZC4NClJldmlld2VkLWJ5OiBBcnVscHJhYmh1IFBvbm51c2FteSA8YXJ1bHBvbm5A
Y2lzY28uY29tPg0KDQrvu79PbiAxMS8yMC8yMCwgNTozOCBQTSwgIkthcmFuIFRpbGFrIEt1bWFy
IiA8a2FydGlsYWtAY2lzY28uY29tPiB3cm90ZToNCg0KICAgIFJlcGxhY2luZyBzaG9zdF9wcmlu
dGsgd2l0aCBGTklDX01BSU5fREJHIHNvIHRoYXQNCiAgICB0aGVzZSBsb2cgbWVzc2FnZXMgYXJl
IGNvbnRyb2xsZWQgYnkgZm5pY19sb2dfbGV2ZWwNCiAgICBmbGFnIGluIGZuaWNfaGFuZGxlX2xp
bmsuDQoNCiAgICBTaWduZWQtb2ZmLWJ5OiBLYXJhbiBUaWxhayBLdW1hciA8a2FydGlsYWtAY2lz
Y28uY29tPg0KICAgIFNpZ25lZC1vZmYtYnk6IFNhdGlzaCBLaGFyYXQgPHNhdGlzaGtoQGNpc2Nv
LmNvbT4NCiAgICAtLS0NCiAgICAgZHJpdmVycy9zY3NpL2ZuaWMvZm5pYy5oICAgICB8IDIgKy0N
CiAgICAgZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19mY3MuYyB8IDIgKy0NCiAgICAgMiBmaWxlcyBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQoNCiAgICBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL2ZuaWMvZm5pYy5oIGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5pYy5oDQog
ICAgaW5kZXggNmRjOGM5MTZkZTMxLi43YzVjOTExYjI2NzMgMTAwNjQ0DQogICAgLS0tIGEvZHJp
dmVycy9zY3NpL2ZuaWMvZm5pYy5oDQogICAgKysrIGIvZHJpdmVycy9zY3NpL2ZuaWMvZm5pYy5o
DQogICAgQEAgLTM5LDcgKzM5LDcgQEANCg0KICAgICAjZGVmaW5lIERSVl9OQU1FCQkiZm5pYyIN
CiAgICAgI2RlZmluZSBEUlZfREVTQ1JJUFRJT04JCSJDaXNjbyBGQ29FIEhCQSBEcml2ZXIiDQog
ICAgLSNkZWZpbmUgRFJWX1ZFUlNJT04JCSIxLjYuMC41MCINCiAgICArI2RlZmluZSBEUlZfVkVS
U0lPTgkJIjEuNi4wLjUxIg0KICAgICAjZGVmaW5lIFBGWAkJCURSVl9OQU1FICI6ICINCiAgICAg
I2RlZmluZSBERlggICAgICAgICAgICAgICAgICAgICBEUlZfTkFNRSAiJWQ6ICINCg0KICAgIGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX2Zjcy5jIGIvZHJpdmVycy9zY3NpL2Zu
aWMvZm5pY19mY3MuYw0KICAgIGluZGV4IDMzMzdkNjYyN2JhZi4uZTBjZWU0ZGNiNDM5IDEwMDY0
NA0KICAgIC0tLSBhL2RyaXZlcnMvc2NzaS9mbmljL2ZuaWNfZmNzLmMNCiAgICArKysgYi9kcml2
ZXJzL3Njc2kvZm5pYy9mbmljX2Zjcy5jDQogICAgQEAgLTc1LDcgKzc1LDcgQEAgdm9pZCBmbmlj
X2hhbmRsZV9saW5rKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiAgICAgCWF0b21pYzY0X3Nl
dCgmZm5pYy0+Zm5pY19zdGF0cy5taXNjX3N0YXRzLmN1cnJlbnRfcG9ydF9zcGVlZCwNCiAgICAg
CQkJbmV3X3BvcnRfc3BlZWQpOw0KICAgICAJaWYgKG9sZF9wb3J0X3NwZWVkICE9IG5ld19wb3J0
X3NwZWVkKQ0KICAgIC0JCXNob3N0X3ByaW50ayhLRVJOX0lORk8sIGZuaWMtPmxwb3J0LT5ob3N0
LA0KICAgICsJCUZOSUNfTUFJTl9EQkcoS0VSTl9JTkZPLCBmbmljLT5scG9ydC0+aG9zdCwNCiAg
ICAgCQkJCSJDdXJyZW50IHZuaWMgc3BlZWQgc2V0IHRvIDogICVsbHVcbiIsDQogICAgIAkJCQlu
ZXdfcG9ydF9zcGVlZCk7DQoNCiAgICAtLSANCiAgICAyLjI5LjINCg0KDQo=
