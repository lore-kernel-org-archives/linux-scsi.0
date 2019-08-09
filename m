Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E39BC433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 14:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E22A20665
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 14:39:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="K+wMQSaF";
	dkim=temperror (0-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="dfw745z1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406048AbfHIOjh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Aug 2019 10:39:37 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20386 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726157AbfHIOjg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Aug 2019 10:39:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x79EZsPM019681;
        Fri, 9 Aug 2019 07:39:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=c3srnvUUqkF0lnuFvsoL5hgfRCRm4WIaNxjL0bNlr6o=;
 b=K+wMQSaFV7eW+f1zc/yco/9estbkV0tI9mvRsk/TmIvmiG+tzQRItb5zdFcdkKqqO/T5
 8G03nyNav7DJ7Azu57qs82G4Li6YaaL3wyAUR1+y9c44giD+woetdJNmR/xo511cFQIh
 4GY9dP55fzQLuTkmrNWaWTDDjdXVD3PzLLTcecyZl8MswRmv6ovcZnCJSx/rBZckpNTE
 1wJrJzcbxEDiomcwqZdsRNSzhnY3XO0kT0rIE9FkwcrSSnqqhMaAXENWDCfNk7rGE/gl
 LqLY8jm7o7dWiQ0feGaU3twk8jVMbFJ5R6wDqrCbxmsvxu85LzyE42FGnklKRG7VicDn rg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2u8cqjegq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 07:39:33 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 9 Aug
 2019 07:39:32 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.53) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 9 Aug 2019 07:39:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XACoiVL+pmsrp5VcI7PjfydYhaqe3Tz0g+mRN+ICuZkC7+LvFWuVz15dfv2fIYNSse8v1hSpIaWATrp2j5h4yzZRt6AlU0RsjnFYhixL5gda/6xqLRd9aQvNNHu/ivGNsMjdTbmJnqTOA1zlPbibqkytiIYMfWtsEKHscK4tv8g0h25nZZGOu+1ZLxBljbP0mw9Nq12Vf+0ZSEQ+tXerNsagoElvpNqLnGDbySP9g9tF5bE4v87IUpiLny9/nBXjVkkau81Hy2eNcvHhUj3q0uaqA8LwJR64nXSZRjs74/QMP1hin0m6s7/9AkxfguD49TSzWh4oYcHvco/qFXqeSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3srnvUUqkF0lnuFvsoL5hgfRCRm4WIaNxjL0bNlr6o=;
 b=Et0yiAX32TVQR+f5jsBm/4F79ExEREAGIScEudHKSYcw4b6+pqCra/TRwwoyo17nzjdN/GshSX/oIVDRfyxzBaA6yMmlkDbwdiUT+VRcU4geMxJ+fnCTMz/0jN7qKSYqciz8o7TwHZ8SeXFojTgwvkT4TJKnmxofF+SxM1X+fHwM9h3/qheHB9RRZ8W6BwcA/lQsOFolzopB7VmLr2ZIEGCN/sZHhpKKlzBJzEnbY+1dOxX+w/Jg4pan435R//g1JkvwhTHTK1pAWDnHXX0Z+uADLRlFT8HSlDnOVXnl8qm5xbqL8fg1RSNL6h20/i28HTdbqVusVhF2/TtQ8smwbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3srnvUUqkF0lnuFvsoL5hgfRCRm4WIaNxjL0bNlr6o=;
 b=dfw745z1+tufO8yqRFXeUXCGFOEWGZfw7IVxxMwYeBpC1LYpcqoKIVCzTHEOGxHS60sBXSqs1x9IZjichoKYwyh0jRY+AwYFvL2mqFkHeCzFbXri/ijKJ82ishO+fu0Y2U6rr8lTd6z24vwO5VaNFVrpqYpm00hGi3fxGTSnr8M=
Received: from DM6PR18MB2715.namprd18.prod.outlook.com (20.179.51.138) by
 DM6PR18MB2908.namprd18.prod.outlook.com (20.179.50.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.20; Fri, 9 Aug 2019 14:39:30 +0000
Received: from DM6PR18MB2715.namprd18.prod.outlook.com
 ([fe80::b5fb:cea7:1ed8:de90]) by DM6PR18MB2715.namprd18.prod.outlook.com
 ([fe80::b5fb:cea7:1ed8:de90%6]) with mapi id 15.20.2136.018; Fri, 9 Aug 2019
 14:39:30 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 00/58] qla2xxx patches for kernel v5.4
Thread-Topic: [PATCH v2 00/58] qla2xxx patches for kernel v5.4
Thread-Index: AQHVTl7pdQmmHc1mgUW9A/9bCk31IKbyj/CA
Date:   Fri, 9 Aug 2019 14:39:30 +0000
Message-ID: <2FFCA45D-6575-408D-93EE-17A49BFE6958@marvell.com>
References: <20190809030219.11296-1-bvanassche@acm.org>
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1b.0.190715
x-originating-ip: [2600:1700:211:eb30:7578:d479:595a:fcbf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cb31789-dd4e-4c94-da60-08d71cd76319
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR18MB2908;
x-ms-traffictypediagnostic: DM6PR18MB2908:
x-microsoft-antispam-prvs: <DM6PR18MB2908B399178A54069A67F1FDD6D60@DM6PR18MB2908.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(346002)(376002)(136003)(366004)(189003)(199004)(478600001)(81156014)(486006)(81166006)(14444005)(256004)(36756003)(6486002)(8676002)(76176011)(229853002)(58126008)(110136005)(25786009)(99286004)(305945005)(7736002)(8936002)(14454004)(6436002)(4326008)(6506007)(446003)(5660300002)(71200400001)(2906002)(6116002)(64756008)(76116006)(316002)(6512007)(91956017)(46003)(6246003)(2616005)(476003)(186003)(11346002)(102836004)(33656002)(66946007)(66446008)(53936002)(66556008)(71190400001)(66476007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2908;H:DM6PR18MB2715.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GfCCLPqB9LSNf9O7tYtXyN2uhy6uUvTsMA9+wofouVKNPc8YjFH8jPgNSpD0i6N37fRoX9bNfGBJZw5XK+BFVRh2ij8dom4aQ+GOV745fnaxneR7hsqV8li7id7662UnrcERpF5balyF3GXicUNbcv55+m7mtvTMZ3FXmPThJ/CjYSmrT9Y07AvZAycVnbrONu3EAP/S02NKI/ax7+cIYgg66XGwGp7MzZbozZnAevQGWaeKmO+eD+DhCruXAjIb3SsTUnfw0QrVIjUjkcKUMLhN8lZivjTBrA0vtSQbJafXyN1y0CCQXQ0YdCLDQ5QQf6korj1nq1RGXRoTj6fZ5yf/YkpMViN80VzymSIRXJkk1dHsxx/k/3/5G53SLrrQ0v8r+bW/7bAgO1NwbOHsTwxRHbBqknGxfrTlCi6rm58=
Content-Type: text/plain; charset="utf-8"
Content-ID: <864DB58E2A11B0468B77BECB8A27493C@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb31789-dd4e-4c94-da60-08d71cd76319
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 14:39:30.0920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hmadhani@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2908
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-09_04:2019-08-09,2019-08-09 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwgDQoNCg0K77u/T24gOC84LzE5LCAxMDowMiBQTSwgImxpbnV4LXNjc2ktb3duZXJA
dmdlci5rZXJuZWwub3JnIG9uIGJlaGFsZiBvZiBCYXJ0IFZhbiBBc3NjaGUiIDxsaW51eC1zY3Np
LW93bmVyQHZnZXIua2VybmVsLm9yZyBvbiBiZWhhbGYgb2YgYnZhbmFzc2NoZUBhY20ub3JnPiB3
cm90ZToNCg0KICAgIEhpIE1hcnRpbiwNCiAgICANCiAgICBUaGUgcGF0Y2hlcyBpbiB0aGlzIHNl
cmllcyBpbXByb3ZlIHRoZSByb2J1c3RuZXNzIG9mIHRoZSBRTG9naWMgRmlicmUgQ2hhbm5lbA0K
ICAgIGluaXRpYXRvciBhbmQgdGFyZ2V0IGRyaXZlcnMuIFRoZXNlIHBhdGNoZXMgYXJlIGEgcmVz
dWx0IG9mIG1hbnVhbCBjb2RlDQogICAgaW5zcGVjdGlvbiwgYW5hbHlzaXMgb2YgQ292ZXJpdHkg
cmVwb3J0cyBhbmQgc3RyZXNzIHRlc3Rpbmcgb2YgdGhlc2UgdHdvDQogICAgZHJpdmVycy4gUGxl
YXNlIGNvbnNpZGVyIHRoZXNlIHBhdGNoZXMgZm9yIGtlcm5lbCB2ZXJzaW9uIHY1LjQuDQogICAg
DQogICAgVGhhbmtzLA0KICAgIA0KICAgIEJhcnQuDQogICAgDQogICAgQ2hhbmdlcyBjb21wYXJl
ZCB0byB2MToNCiAgICAtIEluY2x1ZGVkIGEgcmVncmVzc2lvbiBmaXggZm9yIHFsYTJ4eHhfZWhf
YWJvcnQoKSBpbiB0aGUgc2Vjb25kIHBhdGNoIG9mIHRoaXMNCiAgICAgIHNlcmllcyAodGhlIGZp
eCBIaW1hbnNodSBtZW50aW9uZWQgaW4gaGlzIGUtbWFpbCkuDQogICAgLSBNb3ZlZCBhIFdBUk5f
T05fT05DRSgpIHN0YXRlbWVudCBmcm9tIGEgbGF0ZXIgcGF0Y2ggdG8gdGhlIHNlY29uZCBwYXRj
aCBpbg0KICAgICAgdGhpcyBzZXJpZXMuDQogICAgLSBEcm9wcGVkIG9uZSBwYXRjaCB0aGF0IHJl
bmFtZXMgYSBmdW5jdGlvbi4NCiAgICANCiAgICBCYXJ0IFZhbiBBc3NjaGUgKDU4KToNCiAgICAg
IHFsYTJ4eHg6IE1ha2UgcWxhMngwMF9hYm9ydF9zcmIoKSBhZ2FpbiBkZWNyZWFzZSB0aGUgc3Ag
cmVmZXJlbmNlDQogICAgICAgIGNvdW50DQogICAgICBxbGEyeHh4OiBSZWFsbHkgZml4IHFsYTJ4
eHhfZWhfYWJvcnQoKQ0KICAgICAgcWxhMnh4eDogSW1wcm92ZSBMaW51eCBrZXJuZWwgY29kaW5n
IHN0eWxlIGNvbmZvcm1hbmNlDQogICAgICBxbGEyeHh4OiBVc2UgdGFicyBpbnN0ZWFkIG9mIHNw
YWNlcyBmb3IgaW5kZW50YXRpb24NCiAgICAgIHFsYTJ4eHg6IEluY2x1ZGUgdGhlIDxhc20vdW5h
bGlnbmVkLmg+IGhlYWRlciBmaWxlIGZyb20gcWxhX2RzZC5oDQogICAgICBxbGEyeHh4OiBSZW1v
dmUgYW4gaW5jbHVkZSBkaXJlY3RpdmUgZnJvbSBxbGFfbXIuYw0KICAgICAgcWxhMnh4eDogUmVt
b3ZlIGEgc3VwZXJmbHVvdXMgZm9yd2FyZCBkZWNsYXJhdGlvbg0KICAgICAgcWxhMnh4eDogRGVj
bGFyZSB0aGUgZm91cnRoIHFsX2R1bXBfYnVmZmVyKCkgYXJndW1lbnQgY29uc3QNCiAgICAgIHFs
YTJ4eHg6IENoYW5nZSB0aGUgcmV0dXJuIHR5cGUgb2YgcWxhMngwMF91cGRhdGVfbXNfZmRtaV9p
b2NiKCkgaW50bw0KICAgICAgICB2b2lkDQogICAgICBxbGEyeHh4OiBSZWR1Y2UgdGhlIHNjb3Bl
IG9mIHRocmVlIGxvY2FsIHZhcmlhYmxlcyBpbg0KICAgICAgICBxbGEyeHh4X3F1ZXVlY29tbWFu
ZCgpDQogICAgICBxbGEyeHh4OiBEZWNsYXJlIHFsYV90Z3RfY21kLmNkYiBjb25zdA0KICAgICAg
cWxhMnh4eDogQ2hhbmdlIGRhdGFfZHNkIGludG8gYW4gYXJyYXkNCiAgICAgIHFsYTJ4eHg6IFZl
cmlmeSBsb2NraW5nIGFzc3VtcHRpb25zIGF0IHJ1bnRpbWUNCiAgICAgIHFsYTJ4eHg6IFJlZHVj
ZSB0aGUgbnVtYmVyIG9mIGNhc3RzIGluIEdJRCBsaXN0IGNvZGUNCiAgICAgIHFsYTJ4eHg6IFNp
bXBsaWZ5IHFsdF9scG9ydF9kdW1wKCkNCiAgICAgIHFsYTJ4eHg6IFJlbW92ZSBhIHN1cGVyZmx1
b3VzIHBvaW50ZXIgY2hlY2sNCiAgICAgIHFsYTJ4eHg6IFJlbW92ZSB0d28gc3VwZXJmbHVvdXMg
dGVzdHMNCiAgICAgIHFsYTJ4eHg6IFNpbXBsaWZ5IHFsYTI0eHhfYWJvcnRfc3BfZG9uZSgpDQog
ICAgICBxbGEyeHh4OiBGaXggc2Vzc2lvbiBsb29rdXAgaW4gcWx0X2Fib3J0X3dvcmsoKQ0KICAg
ICAgcWxhMnh4eDogUmVwb3J0IHRoZSBmaXJtd2FyZSBzdGF0dXMgY29kZSBpZiBhIG1haWxib3gg
Y29tbWFuZCBmYWlscw0KICAgICAgcWxhMnh4eDogRG8gbm90IGNvcnJ1cHQgdmhhLT5wbG9naV9h
Y2tfbGlzdA0KICAgICAgcWxhMnh4eDogVXNlIHN0cmxjcHkoKSBpbnN0ZWFkIG9mIHN0cm5jcHko
KQ0KICAgICAgcWxhMnh4eDogQ29tcGxhaW4gaWYgYSBtYWlsYm94IGNvbW1hbmQgdGltZXMgb3V0
DQogICAgICBxbGEyeHh4OiBDb21wbGFpbiBpZiBwYXJzaW5nIHRoZSB2ZXJzaW9uIHN0cmluZyBm
YWlscw0KICAgICAgcWxhMnh4eDogUmVtb3ZlIGRlYWQgY29kZQ0KICAgICAgcWxhMnh4eDogU2lt
cGxpZnkgYSBkZWJ1ZyBzdGF0ZW1lbnQNCiAgICAgIHFsYTJ4eHg6IEZpeCBxbGEyNHh4X3Byb2Nl
c3NfYmlkaXJfY21kKCkNCiAgICAgIHFsYTJ4eHg6IFJlbW92ZSB1bnJlYWNoYWJsZSBjb2RlIGZy
b20gcWxhODN4eF9pZGNfbG9jaygpDQogICAgICBxbGEyeHh4OiBTdXBwcmVzcyBhIENvdmVyaXRp
eSBjb21wbGFpbnQgYWJvdXQgaW50ZWdlciBvdmVyZmxvdw0KICAgICAgcWxhMnh4eDogU3VwcHJl
c3MgbXVsdGlwbGUgQ292ZXJpdHkgY29tcGxhaW50IGFib3V0IG91dC1vZi1ib3VuZHMNCiAgICAg
ICAgYWNjZXNzZXMNCiAgICAgIHFsYTJ4eHg6IEFsd2F5cyBjaGVjayB0aGUgcWxhMngwMF93YWl0
X2Zvcl9oYmFfb25saW5lKCkgcmV0dXJuIHZhbHVlDQogICAgICBxbGEyeHh4OiBEZWNsYXJlIGZv
dXJ0aCBxbGEyeDAwX3NldF9tb2RlbF9pbmZvKCkgYXJndW1lbnQgY29uc3QNCiAgICAgIHFsYTJ4
eHg6IENvbXBsYWluIGlmIHdhaXRpbmcgZm9yIHBlbmRpbmcgY29tbWFuZHMgdGltZXMgb3V0DQog
ICAgICBxbGEyeHh4OiBDaGVjayB0aGUgUENJIGluZm8gc3RyaW5nIG91dHB1dCBidWZmZXIgc2l6
ZQ0KICAgICAgcWxhMnh4eDogVXNlIG1lbWNweSgpIGFuZCBzdHJsY3B5KCkgaW5zdGVhZCBvZiBz
dHJjcHkoKSBhbmQgc3RybmNweSgpDQogICAgICBxbGEyeHh4OiBDb21wbGFpbiBpZiBhIHNvZnQg
cmVzZXQgZmFpbHMNCiAgICAgIHFsYTJ4eHg6IEludHJvZHVjZSB0aGUgYmVfaWRfdCBhbmQgbGVf
aWRfdCBkYXRhIHR5cGVzIGZvciBGQyBzcmMvZHN0DQogICAgICAgIElEcw0KICAgICAgcWxhMnh4
eDogQ2hhbmdlIHRoZSByZXR1cm4gdHlwZSBvZiBxbGEyNHh4X3JlYWRfZmxhc2hfZGF0YSgpDQog
ICAgICBxbGEyeHh4OiBDaGVjayBzZWNvbmRhcnkgaW1hZ2UgaWYgcmVhZGluZyB0aGUgcHJpbWFy
eSBpbWFnZSBmYWlscw0KICAgICAgcWxhMnh4eDogTWFrZSBpdCBleHBsaWNpdCB0aGF0IEVMUyBw
YXNzLXRocm91Z2ggSU9DQnMgdXNlIGxpdHRsZQ0KICAgICAgICBlbmRpYW4NCiAgICAgIHFsYTJ4
eHg6IFNldCB0aGUgcmVzcG9uZGVyIG1vZGUgaWYgYXBwcm9wcmlhdGUgZm9yIEVMUyBwYXNzLXRo
cm91Z2gNCiAgICAgICAgSU9DQnMNCiAgICAgIHFsYTJ4eHg6IFJld29yayBrZXkgZW5jb2Rpbmcg
aW4gcWx0X2ZpbmRfaG9zdF9ieV9kX2lkKCkNCiAgICAgIHFsYTJ4eHg6IEVuYWJsZSB0eXBlIGNo
ZWNraW5nIGZvciB0aGUgU1JCIGZyZWUgYW5kIGRvbmUgY2FsbGJhY2sNCiAgICAgICAgZnVuY3Rp
b25zDQogICAgICBxbGEyeHh4OiBJbnRyb2R1Y2UgdGhlIGZ1bmN0aW9uIHFsYTJ4eHhfaW5pdF9z
cCgpDQogICAgICBxbGEyeHh4OiBGaXggYSByYWNlIGNvbmRpdGlvbiBiZXR3ZWVuIGFib3J0aW5n
IGFuZCBjb21wbGV0aW5nIGEgU0NTSQ0KICAgICAgICBjb21tYW5kDQogICAgICBxbGEyeHh4OiBN
YWtlIHFsdF9oYW5kbGVfYWJ0c19jb21wbGV0aW9uKCkgbW9yZSByb2J1c3QNCiAgICAgIHFsYTJ4
eHg6IE1vZGlmeSBOVk1lIGluY2x1ZGUgZGlyZWN0aXZlcw0KICAgICAgcWxhMnh4eDogSW50cm9k
dWNlIHFsYTJ4eHhfZ2V0X25leHRfaGFuZGxlKCkNCiAgICAgIHFsYTJ4eHg6IE1ha2Ugc3VyZSB0
aGF0IGFib3J0ZWQgY29tbWFuZHMgYXJlIGZyZWVkDQogICAgICBxbGEyeHh4OiBDb21wbGFpbiBp
ZiBzcC0+ZG9uZSgpIGlzIG5vdCBjYWxsZWQgZnJvbSB0aGUgY29tcGxldGlvbiBwYXRoDQogICAg
ICBxbGEyeHh4OiBMZXQgdGhlIGNvbXBpbGVyIGNoZWNrIHRoZSB0eXBlIG9mIHRoZSBTQ1NJIGNv
bW1hbmQgY29udGV4dA0KICAgICAgICBwb2ludGVyDQogICAgICBxbGEyeHh4OiBSZW1vdmUgc3Vw
ZXJmbHVvdXMgc3RzX2VudHJ5XyogY2FzdHMNCiAgICAgIHFsYTJ4eHg6IFJlcG9ydCBpbnZhbGlk
IG1haWxib3ggc3RhdHVzIGNvZGVzDQogICAgICBxbGEyeHh4OiBJbmxpbmUgdGhlIHFsYTJ4MDBf
ZmNwb3J0X2V2ZW50X2hhbmRsZXIoKSBmdW5jdGlvbg0KICAgICAgcWxhMnh4eDogSW50cm9kdWNl
IHFsYTJ4MDBfZWxzX2RjbWQyX2ZyZWUoKQ0KICAgICAgcWxhMnh4eDogUmVtb3ZlIHR3byBzdXBl
cmZsdW91cyBpZi10ZXN0cw0KICAgICAgcWxhMnh4eDogU2ltcGxpZnkgcWxhMjR4eF9hc3luY19h
Ym9ydF9jbWQoKQ0KICAgICAgcWxhMnh4eDogRml4IGEgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNl
DQogICAgDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9hdHRyLmMgICAgfCAgIDYgKy0N
CiAgICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2JzZy5jICAgICB8ICAxOSArLS0NCiAgICAg
ZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2RiZy5jICAgICB8ICAgMyArLQ0KICAgICBkcml2ZXJz
L3Njc2kvcWxhMnh4eC9xbGFfZGVmLmggICAgIHwgMTMwICsrKysrKysrKystLS0tDQogICAgIGRy
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9kZnMuYyAgICAgfCAgIDkgKy0NCiAgICAgZHJpdmVycy9z
Y3NpL3FsYTJ4eHgvcWxhX2RzZC5oICAgICB8ICAgMiArDQogICAgIGRyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9mdy5oICAgICAgfCAgIDggKy0NCiAgICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X2dibC5oICAgICB8ICAzMyArKy0tDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9ncy5j
ICAgICAgfCAyMTkgKysrKysrKysrLS0tLS0tLS0tLS0tLS0tDQogICAgIGRyaXZlcnMvc2NzaS9x
bGEyeHh4L3FsYV9pbml0LmMgICAgfCAyNjEgKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0N
CiAgICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lubGluZS5oICB8ICAyOCArKy0tDQogICAg
IGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMgICAgfCAyMjEgKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYyAgICAgfCAgMjQg
KystDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9tYnguYyAgICAgfCAgMTAgKy0NCiAg
ICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX21pZC5jICAgICB8ICAgNCArLQ0KICAgICBkcml2
ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbXIuYyAgICAgIHwgIDY3ICsrKystLS0tDQogICAgIGRyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9udm1lLmMgICAgfCAgMjggKy0tLQ0KICAgICBkcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfbnZtZS5oICAgIHwgICA1ICstDQogICAgIGRyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9ueC5jICAgICAgfCAgMTYgKy0NCiAgICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X254LmggICAgICB8ICAxNCArLQ0KICAgICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbngyLmMg
ICAgIHwgICAyICstDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9vcy5jICAgICAgfCAy
MTMgKysrKysrKysrKy0tLS0tLS0tLS0tLS0NCiAgICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxh
X3N1cC5jICAgICB8ICAgOCArLQ0KICAgICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfdGFyZ2V0
LmMgIHwgMjA5ICsrKysrKysrKy0tLS0tLS0tLS0tLS0tDQogICAgIGRyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV90YXJnZXQuaCAgfCAgMzUgKystLQ0KICAgICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9x
bGFfdG1wbC5jICAgIHwgICA3ICstDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3RjbV9xbGEy
eHh4LmMgfCAgMjcgKystDQogICAgIGluY2x1ZGUvbGludXgvbnZtZS1mYy1kcml2ZXIuaCAgICAg
fCAgIDIgKw0KICAgICAyOCBmaWxlcyBjaGFuZ2VkLCA2NzcgaW5zZXJ0aW9ucygrKSwgOTMzIGRl
bGV0aW9ucygtKQ0KICAgIA0KICAgIC0tIA0KICAgIDIuMjIuMA0KICAgIA0KDQoNClRoYW5rcyBm
b3IgcG9zdGluZyB2MiBvZiB0aGUgc2VyaWVzLg0KDQpGb3IgdGhlIHNlcmllcywgDQoNClRlc3Rl
ZC1ieTogSGltYW5zaHUgTWFkaGFuaSA8aG1hZGhhbmlAbWFydmVsbC5jb20+DQpSZXZpZXdlZC1i
eTogSGltYW5zaHUgTWFkaGFuaSA8aG1hZGhhbmlAbWFydmVsbC5jb20+DQoNCg==
