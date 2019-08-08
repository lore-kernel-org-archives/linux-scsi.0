Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A49C0650F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 16:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46C3B21743
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 16:10:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="tomRvKhP";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="bXMdfMiN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404001AbfHHQKd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 12:10:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6876 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732662AbfHHQKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 12:10:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x78FuRqV027567;
        Thu, 8 Aug 2019 09:10:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=Rz7LJ9vYMrH7CZZoAlVNFWjndADNlW3l3h3vIBW11wo=;
 b=tomRvKhPeLTkmjnrXpCVKuOgZvu3rC4BAsK7bTrpM0mM8EuO5r8Oz1n0VimLEUJuTfBq
 LTU7BfLubMaYYdwUJSkKChe83Rhnh5CvySWrYvrlG4Q24cScRaMmZU+eFESnyffQ3iqf
 JrV4ksmLtEBVvvKrfrBh84AFlcn2XE2gXZATHjxzlVU6C+77apuFcipT4ohZpCFELB07
 6GoRGxJTLHArwjhBJkBeL9A8ngET4twku0/XZDf1ymYnAeZGnG4pN6YokUjJgJjqlUHK
 kDeagixrTJSTBJ9G3oyD2OWSJ8hxbmhSFLhEL5mzUfGL882ZVcKTnB1jtxdGMCP0MMv4 9w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2u59sm4cdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 09:10:25 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 8 Aug
 2019 09:10:23 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.56) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 8 Aug 2019 09:10:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYyM8H7VxlVx7VB8LgfoffuIa0yiIFlGesSy/DMtqAmddHeZyJ5QS4adyCOvK9kFXhaVohf+IXnzSaFXSF9jg+UOk45ytBAm5Wm/uNT/9+m4oqpSaG45NOdP0hZBebLofat5pDdIkELMnMBK2fWY8oEZl6VIDeAq22tiQXTyx3iSCtZt60Qv6wWORuk3bhVPS5fWAaux+c22Z7FwvlzD2Asc+k8MZk+r6Oe7g8aYOcNX6068x0B02A8z4jWRxPBJ9rEm+meTKdcd3JvaSUxpou8RG8+xRJqi9CsxLMYVPcMVJjQUn6kQ/sLun6sIDtHhQfTTBzBaS/fzHVgLtIuahQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rz7LJ9vYMrH7CZZoAlVNFWjndADNlW3l3h3vIBW11wo=;
 b=ciXh6mHDJHD4wi40UVOdLKq2g0N77PxuuidM7MdEWZcvtK6oBNDpm70m7sS+l5aceLqKw0z8YTmKfwfSfjmsErMsQ11nWlXQsKHYw1yEi6tyn5NGGN3FfN2Au1VELylQHE/XnDqUrM7vAMcJUAtwebsURmn3h7JlJfMZ4JQcxG89MlgVq0/lu4tFs+a+DIFF3/olrBAE2wubaoeEij3FsKhIbY0AYoI9M5D+V8mThm8Ky9odujSlyrNmv7IXJxqhi2F32EP+XMMCJifauqfIFGdrH885+jnjvzpsvQDZGX7hJYj+rOKYUyAHf4L3Dg/d4mDQYfobjsP4PjS5Zz+Hdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rz7LJ9vYMrH7CZZoAlVNFWjndADNlW3l3h3vIBW11wo=;
 b=bXMdfMiNylTzYo5ZxXt9nTLXO0o9b5Tp2bF5DY5se4CWewHKCo85gi9Ma9eCvNEoig6+xcjZLzPv4CaWcD+b+zmH9f4bfa9fdlLB1nHpSYuTlxFXr/4J44hvqnadIPUV7X0Pv40a6xdbsRI2FT8NNHRXSXVBtRdSETIl3DTdBiA=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2672.namprd18.prod.outlook.com (20.179.84.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.20; Thu, 8 Aug 2019 16:10:19 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a%6]) with mapi id 15.20.2136.022; Thu, 8 Aug 2019
 16:10:18 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 00/59] qla2xxx patches for kernel v5.4
Thread-Topic: [PATCH 00/59] qla2xxx patches for kernel v5.4
Thread-Index: AQHVSJJ022sCI1XYH0SMvtN3Wp3gXKbxdmSA
Date:   Thu, 8 Aug 2019 16:10:18 +0000
Message-ID: <15721365-7930-4A43-B08D-47C5BCBC7FDB@marvell.com>
References: <20190801175614.73655-1-bvanassche@acm.org>
In-Reply-To: <20190801175614.73655-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [66.73.206.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9441d760-5e6c-4a85-0b16-08d71c1ae866
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2672;
x-ms-traffictypediagnostic: MN2PR18MB2672:
x-microsoft-antispam-prvs: <MN2PR18MB2672111F2F5E64F00479DC64D6D70@MN2PR18MB2672.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(199004)(189003)(66556008)(8676002)(446003)(14454004)(6512007)(54906003)(14444005)(11346002)(53936002)(256004)(81156014)(6506007)(33656002)(81166006)(6246003)(6916009)(486006)(53546011)(8936002)(50226002)(229853002)(99286004)(36756003)(76176011)(26005)(2906002)(316002)(478600001)(186003)(6436002)(6486002)(25786009)(57306001)(102836004)(86362001)(4326008)(476003)(2616005)(66066001)(7736002)(305945005)(91956017)(76116006)(5660300002)(3846002)(6116002)(71190400001)(64756008)(66446008)(71200400001)(66476007)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2672;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vHHMuzLkeOXjJ9LX8hM5vpCcM9iG2qE8xMLTohacgoidp0iPEk6nWwKMelXLNpnFiFrn+Gu9kqHbRxwvsEgTZn1J+Af37SVUgpV/8ssOrkPHMuCLEpt1TpP1l5GokL1b+LmmTAU0Wre1n0mib0yYhxzekRNFe1T/NcP+gVKks8plQsbOqLip3XAtGwbheY+wCFFNqdravkQLjtoixL9LfU5TK9gJZQN/T73yHMVH6xSrPZ9bJvufLJea9OIG0NhvpjrPKHcILCML/FnWW6FbXnmKIRwPOmghqMQCSuD4SccZs9GlS4wTGBzq6RrcgG/0iIpy56+mR6O1Hu/nl9DdunhKQYcMYfpRagTBHS0g8i/6+dvoTOa+4srhWtsQTjOeF8nClSmWw7LwHb+kUhkysAzLoVbH3eyI9e6uplCPcKk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF651A170F4610448D30FDCE872B6BC1@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9441d760-5e6c-4a85-0b16-08d71c1ae866
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 16:10:18.8334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hmadhani@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2672
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-08_06:2019-08-07,2019-08-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwgDQoNCg0KPiBPbiBBdWcgMSwgMjAxOSwgYXQgMTI6NTUgUE0sIEJhcnQgVmFuIEFz
c2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPiB3cm90ZToNCj4gDQo+IEhpIE1hcnRpbiwNCj4gDQo+
IFRoZSBwYXRjaGVzIGluIHRoaXMgc2VyaWVzIGltcHJvdmUgdGhlIHJvYnVzdG5lc3Mgb2YgdGhl
IFFMb2dpYyBGaWJyZSBDaGFubmVsDQo+IGluaXRpYXRvciBhbmQgdGFyZ2V0IGRyaXZlcnMuIFRo
ZXNlIHBhdGNoZXMgYXJlIGEgcmVzdWx0IG9mIG1hbnVhbCBjb2RlDQo+IGluc3BlY3Rpb24sIGFu
YWx5c2lzIG9mIENvdmVyaXR5IHJlcG9ydHMgYW5kIHN0cmVzcyB0ZXN0aW5nIG9mIHRoZXNlIHR3
bw0KPiBkcml2ZXJzLiBQbGVhc2UgY29uc2lkZXIgdGhlc2UgcGF0Y2hlcyBmb3Iga2VybmVsIHZl
cnNpb24gdjUuNC4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo+IA0KPiBCYXJ0IFZhbiBB
c3NjaGUgKDU5KToNCj4gIHFsYTJ4eHg6IE1ha2UgcWxhMngwMF9hYm9ydF9zcmIoKSBhZ2FpbiBk
ZWNyZWFzZSB0aGUgc3AgcmVmZXJlbmNlDQo+ICAgIGNvdW50DQo+ICBxbGEyeHh4OiBSZWFsbHkg
Zml4IHFsYTJ4eHhfZWhfYWJvcnQoKQ0KPiAgcWxhMnh4eDogSW1wcm92ZSBMaW51eCBrZXJuZWwg
Y29kaW5nIHN0eWxlIGNvbmZvcm1hbmNlDQo+ICBxbGEyeHh4OiBVc2UgdGFicyBpbnN0ZWFkIG9m
IHNwYWNlcyBmb3IgaW5kZW50YXRpb24NCj4gIHFsYTJ4eHg6IEluY2x1ZGUgdGhlIDxhc20vdW5h
bGlnbmVkLmg+IGhlYWRlciBmaWxlIGZyb20gcWxhX2RzZC5oDQo+ICBxbGEyeHh4OiBSZW1vdmUg
YW4gaW5jbHVkZSBkaXJlY3RpdmUgZnJvbSBxbGFfbXIuYw0KPiAgcWxhMnh4eDogUmVtb3ZlIGEg
c3VwZXJmbHVvdXMgZm9yd2FyZCBkZWNsYXJhdGlvbg0KPiAgcWxhMnh4eDogRGVjbGFyZSB0aGUg
Zm91cnRoIHFsX2R1bXBfYnVmZmVyKCkgYXJndW1lbnQgY29uc3QNCj4gIHFsYTJ4eHg6IENoYW5n
ZSB0aGUgcmV0dXJuIHR5cGUgb2YgcWxhMngwMF91cGRhdGVfbXNfZmRtaV9pb2NiKCkgaW50bw0K
PiAgICB2b2lkDQo+ICBxbGEyeHh4OiBSZWR1Y2UgdGhlIHNjb3BlIG9mIHRocmVlIGxvY2FsIHZh
cmlhYmxlcyBpbg0KPiAgICBxbGEyeHh4X3F1ZXVlY29tbWFuZCgpDQo+ICBxbGEyeHh4OiBEZWNs
YXJlIHFsYV90Z3RfY21kLmNkYiBjb25zdA0KPiAgcWxhMnh4eDogQ2hhbmdlIGRhdGFfZHNkIGlu
dG8gYW4gYXJyYXkNCj4gIHFsYTJ4eHg6IFZlcmlmeSBsb2NraW5nIGFzc3VtcHRpb25zIGF0IHJ1
bnRpbWUNCj4gIHFsYTJ4eHg6IFJlZHVjZSB0aGUgbnVtYmVyIG9mIGNhc3RzIGluIEdJRCBsaXN0
IGNvZGUNCj4gIHFsYTJ4eHg6IFNpbXBsaWZ5IHFsdF9scG9ydF9kdW1wKCkNCj4gIHFsYTJ4eHg6
IFJlbW92ZSBhIHN1cGVyZmx1b3VzIHBvaW50ZXIgY2hlY2sNCj4gIHFsYTJ4eHg6IFJlbW92ZSB0
d28gc3VwZXJmbHVvdXMgdGVzdHMNCj4gIHFsYTJ4eHg6IFNpbXBsaWZ5IHFsYTI0eHhfYWJvcnRf
c3BfZG9uZSgpDQo+ICBxbGEyeHh4OiBGaXggc2Vzc2lvbiBsb29rdXAgaW4gcWx0X2Fib3J0X3dv
cmsoKQ0KPiAgcWxhMnh4eDogUmVwb3J0IHRoZSBmaXJtd2FyZSBzdGF0dXMgY29kZSBpZiBhIG1h
aWxib3ggY29tbWFuZCBmYWlscw0KPiAgcWxhMnh4eDogRG8gbm90IGNvcnJ1cHQgdmhhLT5wbG9n
aV9hY2tfbGlzdA0KPiAgcWxhMnh4eDogVXNlIHN0cmxjcHkoKSBpbnN0ZWFkIG9mIHN0cm5jcHko
KQ0KPiAgcWxhMnh4eDogQ29tcGxhaW4gaWYgYSBtYWlsYm94IGNvbW1hbmQgdGltZXMgb3V0DQo+
ICBxbGEyeHh4OiBDb21wbGFpbiBpZiBwYXJzaW5nIHRoZSB2ZXJzaW9uIHN0cmluZyBmYWlscw0K
PiAgcWxhMnh4eDogUmVtb3ZlIGRlYWQgY29kZQ0KPiAgcWxhMnh4eDogU2ltcGxpZnkgYSBkZWJ1
ZyBzdGF0ZW1lbnQNCj4gIHFsYTJ4eHg6IEZpeCBxbGEyNHh4X3Byb2Nlc3NfYmlkaXJfY21kKCkN
Cj4gIHFsYTJ4eHg6IFJlbW92ZSB1bnJlYWNoYWJsZSBjb2RlIGZyb20gcWxhODN4eF9pZGNfbG9j
aygpDQo+ICBxbGEyeHh4OiBTdXBwcmVzcyBhIENvdmVyaXRpeSBjb21wbGFpbnQgYWJvdXQgaW50
ZWdlciBvdmVyZmxvdw0KPiAgcWxhMnh4eDogU3VwcHJlc3MgbXVsdGlwbGUgQ292ZXJpdHkgY29t
cGxhaW50IGFib3V0IG91dC1vZi1ib3VuZHMNCj4gICAgYWNjZXNzZXMNCj4gIHFsYTJ4eHg6IEFs
d2F5cyBjaGVjayB0aGUgcWxhMngwMF93YWl0X2Zvcl9oYmFfb25saW5lKCkgcmV0dXJuIHZhbHVl
DQo+ICBxbGEyeHh4OiBEZWNsYXJlIGZvdXJ0aCBxbGEyeDAwX3NldF9tb2RlbF9pbmZvKCkgYXJn
dW1lbnQgY29uc3QNCj4gIHFsYTJ4eHg6IENvbXBsYWluIGlmIHdhaXRpbmcgZm9yIHBlbmRpbmcg
Y29tbWFuZHMgdGltZXMgb3V0DQo+ICBxbGEyeHh4OiBDaGVjayB0aGUgUENJIGluZm8gc3RyaW5n
IG91dHB1dCBidWZmZXIgc2l6ZQ0KPiAgcWxhMnh4eDogVXNlIG1lbWNweSgpIGFuZCBzdHJsY3B5
KCkgaW5zdGVhZCBvZiBzdHJjcHkoKSBhbmQgc3RybmNweSgpDQo+ICBxbGEyeHh4OiBDb21wbGFp
biBpZiBhIHNvZnQgcmVzZXQgZmFpbHMNCj4gIHFsYTJ4eHg6IEludHJvZHVjZSB0aGUgYmVfaWRf
dCBhbmQgbGVfaWRfdCBkYXRhIHR5cGVzIGZvciBGQyBzcmMvZHN0DQo+ICAgIElEcw0KPiAgcWxh
Mnh4eDogQ2hhbmdlIHRoZSByZXR1cm4gdHlwZSBvZiBxbGEyNHh4X3JlYWRfZmxhc2hfZGF0YSgp
DQo+ICBxbGEyeHh4OiBDaGVjayBzZWNvbmRhcnkgaW1hZ2UgaWYgcmVhZGluZyB0aGUgcHJpbWFy
eSBpbWFnZSBmYWlscw0KPiAgcWxhMnh4eDogTWFrZSBpdCBleHBsaWNpdCB0aGF0IEVMUyBwYXNz
LXRocm91Z2ggSU9DQnMgdXNlIGxpdHRsZQ0KPiAgICBlbmRpYW4NCj4gIHFsYTJ4eHg6IFNldCB0
aGUgcmVzcG9uZGVyIG1vZGUgaWYgYXBwcm9wcmlhdGUgZm9yIEVMUyBwYXNzLXRocm91Z2gNCj4g
ICAgSU9DQnMNCj4gIHFsYTJ4eHg6IFJld29yayBrZXkgZW5jb2RpbmcgaW4gcWx0X2ZpbmRfaG9z
dF9ieV9kX2lkKCkNCj4gIHFsYTJ4eHg6IEVuYWJsZSB0eXBlIGNoZWNraW5nIGZvciB0aGUgU1JC
IGZyZWUgYW5kIGRvbmUgY2FsbGJhY2sNCj4gICAgZnVuY3Rpb25zDQo+ICBxbGEyeHh4OiBJbnRy
b2R1Y2UgdGhlIGZ1bmN0aW9uIHFsYTJ4eHhfaW5pdF9zcCgpDQo+ICBxbGEyeHh4OiBGaXggYSBy
YWNlIGNvbmRpdGlvbiBiZXR3ZWVuIGFib3J0aW5nIGFuZCBjb21wbGV0aW5nIGEgU0NTSQ0KPiAg
ICBjb21tYW5kDQo+ICBxbGEyeHh4OiBNYWtlIHFsdF9oYW5kbGVfYWJ0c19jb21wbGV0aW9uKCkg
bW9yZSByb2J1c3QNCj4gIHFsYTJ4eHg6IE1vZGlmeSBOVk1lIGluY2x1ZGUgZGlyZWN0aXZlcw0K
PiAgcWxhMnh4eDogUmVuYW1lIHFsYTI0eHhfYXN5bmNfYWJvcnRfY29tbWFuZCgpIGludG8NCj4g
ICAgcWxhMjR4eF9zeW5jX2Fib3J0X2NvbW1hbmQoKQ0KPiAgcWxhMnh4eDogSW50cm9kdWNlIHFs
YTJ4eHhfZ2V0X25leHRfaGFuZGxlKCkNCj4gIHFsYTJ4eHg6IE1ha2Ugc3VyZSB0aGF0IGFib3J0
ZWQgY29tbWFuZHMgYXJlIGZyZWVkDQo+ICBxbGEyeHh4OiBDb21wbGFpbiBpZiBzcC0+ZG9uZSgp
IGlzIG5vdCBjYWxsZWQgZnJvbSB0aGUgY29tcGxldGlvbiBwYXRoDQo+ICBxbGEyeHh4OiBMZXQg
dGhlIGNvbXBpbGVyIGNoZWNrIHRoZSB0eXBlIG9mIHRoZSBTQ1NJIGNvbW1hbmQgY29udGV4dA0K
PiAgICBwb2ludGVyDQo+ICBxbGEyeHh4OiBSZW1vdmUgc3VwZXJmbHVvdXMgc3RzX2VudHJ5Xyog
Y2FzdHMNCj4gIHFsYTJ4eHg6IFJlcG9ydCBpbnZhbGlkIG1haWxib3ggc3RhdHVzIGNvZGVzDQo+
ICBxbGEyeHh4OiBJbmxpbmUgdGhlIHFsYTJ4MDBfZmNwb3J0X2V2ZW50X2hhbmRsZXIoKSBmdW5j
dGlvbg0KPiAgcWxhMnh4eDogSW50cm9kdWNlIHFsYTJ4MDBfZWxzX2RjbWQyX2ZyZWUoKQ0KPiAg
cWxhMnh4eDogUmVtb3ZlIHR3byBzdXBlcmZsdW91cyBpZi10ZXN0cw0KPiAgcWxhMnh4eDogU2lt
cGxpZnkgcWxhMjR4eF9hc3luY19hYm9ydF9jbWQoKQ0KPiAgcWxhMnh4eDogRml4IGEgTlVMTCBw
b2ludGVyIGRlcmVmZXJlbmNlDQo+IA0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfYXR0ci5j
ICAgIHwgICA2ICstDQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9ic2cuYyAgICAgfCAgMTkg
Ky0NCj4gZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2RiZy5jICAgICB8ICAgMyArLQ0KPiBkcml2
ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZGVmLmggICAgIHwgMTMwICsrKysrKysrKystLS0tDQo+IGRy
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZnMuYyAgICAgfCAgIDkgKy0NCj4gZHJpdmVycy9zY3Np
L3FsYTJ4eHgvcWxhX2RzZC5oICAgICB8ICAgMiArDQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3Fs
YV9mdy5oICAgICAgfCAgIDggKy0NCj4gZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2dibC5oICAg
ICB8ICAzNSArKy0tDQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9ncy5jICAgICAgfCAyMTkg
KysrKysrKysrLS0tLS0tLS0tLS0tLS0NCj4gZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQu
YyAgICB8IDI2NyArKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBkcml2ZXJzL3Njc2kv
cWxhMnh4eC9xbGFfaW5saW5lLmggIHwgIDI4ICstLQ0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9x
bGFfaW9jYi5jICAgIHwgMjIxICsrKysrKysrKy0tLS0tLS0tLS0tLS0tLQ0KPiBkcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfaXNyLmMgICAgIHwgIDI0ICsrLQ0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4
eC9xbGFfbWJ4LmMgICAgIHwgIDEyICstDQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9taWQu
YyAgICAgfCAgIDQgKy0NCj4gZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX21yLmMgICAgICB8ICA2
NyArKysrLS0tLQ0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbnZtZS5jICAgIHwgIDI4ICst
LQ0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbnZtZS5oICAgIHwgICA1ICstDQo+IGRyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9ueC5jICAgICAgfCAgMTYgKy0NCj4gZHJpdmVycy9zY3NpL3Fs
YTJ4eHgvcWxhX254LmggICAgICB8ICAxNCArLQ0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFf
bngyLmMgICAgIHwgICAyICstDQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9vcy5jICAgICAg
fCAyMjIgKysrKysrKysrKy0tLS0tLS0tLS0tLS0tDQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3Fs
YV9zdXAuYyAgICAgfCAgIDggKy0NCj4gZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3RhcmdldC5j
ICB8IDIwOSArKysrKysrKystLS0tLS0tLS0tLS0tDQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3Fs
YV90YXJnZXQuaCAgfCAgMzUgKystLQ0KPiBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfdG1wbC5j
ICAgIHwgICA3ICstDQo+IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3RjbV9xbGEyeHh4LmMgfCAgMjcg
KystDQo+IGluY2x1ZGUvbGludXgvbnZtZS1mYy1kcml2ZXIuaCAgICAgfCAgIDIgKw0KPiAyOCBm
aWxlcyBjaGFuZ2VkLCA2ODUgaW5zZXJ0aW9ucygrKSwgOTQ0IGRlbGV0aW9ucygtKQ0KPiANCj4g
LS0gDQo+IDIuMjIuMC43NzAuZzBmMmM0YTM3ZmQtZ29vZw0KPiANCg0KSSBmb3VuZCBpc3N1ZSB3
aXRoIHRoaXMgc2VyaWVzIGluIG15IHRlc3RpbmcuIFRoYW5rcyBmb3IgcHJvbXB0bHkgcHJvdmlk
aW5nIGZpeC4gDQoNCknigJlsbCBsZXQgbXkgdGVzdCBiZWQgaGF2ZSBtb3JlIHNvYWsgdGltZSB3
aXRoIG5ldyBmaXggYW5kIHdpbGwgdXBkYXRlLg0KDQpQbGVhc2UgcmVwb3N0IHYyIG9mIHRoaXMg
c2VyaWVzIHdpdGggdGhlIGZpeCBmb3IgUGF0Y2ggIzIuIA0KDQpUaGFua3MsDQotIEhpbWFuc2h1
