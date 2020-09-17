Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2C8C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 16:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C724120708
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 16:41:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NbrTEzPL";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="d1vXTJlx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgIQQl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 12:41:28 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60660 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728575AbgIQQiL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 12:38:11 -0400
X-Greylist: delayed 3194 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 12:38:10 EDT
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HFLOXH028366;
        Thu, 17 Sep 2020 08:44:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=/LSczgg6tlWhm6Im9ISNjCHEgEd8P/PnCrCkwviHZIs=;
 b=NbrTEzPL5Ke36EJ83NsCEqQzDoMFS50OvzAtRZbqFIYNwS2azaCTV0/4jKreYGtHZSVZ
 FPg073o+iP5Zqwy5fDbtozr6AieVued491rJzXf/7CohLyJuC5KjtXY8VxjaG2n5iN4p
 UW7SNWjZyMfsx9C763gABZ4fSuNJEu5jFSFMey+4N3cfrt4QRgd+oa4wIpcX0QTygfX4
 kntSFG3F61L8Evhp0xtf5insY5oCxlqUsugw6pz2t3hG+gcG+PM2FBFMoywMuonSsiM6
 YfNKJWNSE8eBTPgW+nLBPq0boeHx8Mv0MeDXOYSUkC0+BlycVHtm7HgDz3AL4cPQc7Gh mw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33m73p0sc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 08:44:32 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Sep
 2020 08:44:31 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Sep
 2020 08:44:30 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 17 Sep 2020 08:44:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJxNYEVkItlDPC80xh88jHVSMt90YP7K7yoSpNdNCr84eGKSDFrosb5vbfRMa9lyvhG/ITHh+uRUXImNV/fR5tQM0FcyOyHNwYLkww/doyWEoBs9SRUBei0b7X4kxrtH97Tp1LXuTQC9DuuUcq6kuu3TSkZF5sPBvkkykzE6tN7HVkr1yDkot8qU+WB/Q8ILMhZWWzHLOSiVczQn/4Zt0sxrhEVD5ghhXAEVCykuZH+0j+ThlSnPQN3a3Zjb69plX+Sa8HIRx5TpHuZBq2hNRHCtpGBf1rEG2WIUJ1t3Y6L55yTMpfhCC7nwZ03Rin3alUOGl4pOCMOBgduWM0jWbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/LSczgg6tlWhm6Im9ISNjCHEgEd8P/PnCrCkwviHZIs=;
 b=Q5xLDDhEvhkcpnrEjAVO3xvpWqDVhTdqlLe/AjcsBFPU/4EmHNlCi2FeDoxrsDgtVYc/zm8fP+0CzI0duudndo65OOYJU+kPBNmjzHhdq7roQFbLxXKMPdHET87eshI9CBmfdfmQarP1N6QM3aSrlzRZx2NKUZdOiuFNQRYH/bl/vu/J6BrmI/OsCtoGLA5vwXSDSSTfhgjJshHJRSpmKkRGj6bieXrTqFul/zaKngfkdBsmSG6XZr9hpT8djRwTQjJOMNn7iguJjTA2Iu5Imj2pvtZumPgC+T7/egZQpajB1+khxKgy0+9FmF6Pvn66Mq6vU0SEN1dAJ3534/dM8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/LSczgg6tlWhm6Im9ISNjCHEgEd8P/PnCrCkwviHZIs=;
 b=d1vXTJlxbY/K2Rn8pOm3k7JArdKYHmaM09FO7Q31BdVWzCJgYz8XGrK2hSQ3cM4BMPAd06+9eicJrcA+sIeLEOY7htS/A/P2oXU+6gA1OJL8QCcjvkRLGnT5fIedp9SaDpLmjTHmaqHnZRL9gZZJW0q5m009+udFWt6N7uYoKUQ=
Received: from BYAPR18MB2759.namprd18.prod.outlook.com (2603:10b6:a03:10b::24)
 by BYAPR18MB2501.namprd18.prod.outlook.com (2603:10b6:a03:131::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Thu, 17 Sep
 2020 15:44:28 +0000
Received: from BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::b859:f213:6b19:6095]) by BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::b859:f213:6b19:6095%6]) with mapi id 15.20.3391.015; Thu, 17 Sep 2020
 15:44:28 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH v3 11/13] qla2xxx: Add IOCB resource tracking
Thread-Topic: [PATCH v3 11/13] qla2xxx: Add IOCB resource tracking
Thread-Index: AQHWgne7rcsV+CpI1kq7Qdnu7WkZXqlYnVmAgBRv2dA=
Date:   Thu, 17 Sep 2020 15:44:28 +0000
Message-ID: <BYAPR18MB2759BFC109D95D019D027304D53E0@BYAPR18MB2759.namprd18.prod.outlook.com>
References: <20200904045128.23631-1-njavali@marvell.com>
 <20200904045128.23631-12-njavali@marvell.com>
 <bd547541-5a29-5ec5-305a-8614d5a8792c@acm.org>
In-Reply-To: <bd547541-5a29-5ec5-305a-8614d5a8792c@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [98.164.229.97]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b33dc5e-d3c1-43f2-3fc5-08d85b208ff6
x-ms-traffictypediagnostic: BYAPR18MB2501:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB25014549374EEECA1F474418D53E0@BYAPR18MB2501.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kolgR3t60qKJzCJlwhOBjJAXHf2t6LAPBT47MM8iDHUSI5af+nZZpy2GZst4vKtAcHAb5tz1F9tTXNxRDH8iGXFve3fZgDWOpN3sNH/L5fgywU7x5vHWikZsAU7V8eyxqEQGAWMoIho9Bfo0j5AfNxalY3THhjaeH3BqWtuW4F3OU3jJW7XAuJNPKWNGF9Mxf8F2Mj1lQaA6h5WbbxN93Sz9dx1tcTY1WKMvKF976sYoCMajbdAt8Mp/ljVheSaQ6MQxWk+dYjf46jL7pKUynrFCMktX+jf3jmZoEfPi7W15NOUKKVTjkJbuPp7fpnIA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2759.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(396003)(136003)(376002)(76116006)(55016002)(186003)(83380400001)(107886003)(4326008)(52536014)(54906003)(86362001)(316002)(110136005)(9686003)(26005)(66476007)(66946007)(66556008)(64756008)(66446008)(4744005)(8936002)(478600001)(53546011)(2906002)(6506007)(5660300002)(33656002)(71200400001)(7696005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vhxC2Qc3RW7XRmiRgShuxEolTVapOHdux9l4dzhwNgD/6Jd03ZLKbUCUU+npyAzCbVatwwyFlQXCcnz2c82tTGJr1K27Brr1yge8yIhIQCQ2nFoF5XtnxWypV+dSMqXcxO4J/+53YrxOEeloEGgrxEeLVm30bZW2+qsI5wQE6qCtb79qL1r80g9PkMuryvO+vuGk7OJ3aMP9+EolEiaD2/VgWsCXJCxm61vq5qDrRg4X0WeKx4vcIB1rmgScki9miCu13iCrl50Gw/edWX59KOxahIc4CFEiKA1F8NAr8LPR4L3NdqoGCFXHS2ly3ZtUuZYCJtIyWZSFgxYW0qTEb9sj9CE5oM0pynweOtBuZ17rHzX11Vhg3J3FEJ577dObYwTxyFbxVAUfB/puuUWIllWqgVkI0s0bnHZpY2VzNzQBd25ilaQEcQYhh0wtjGAfz90SrzGDF3UpqGmC1DvOoNfGD8cMlN//1Iq7K8JlQqkWYqNO4RlYa7DShIH+NKx5LlBej78SpoqRhrNCe1pFqoExNFiuqOA7PCXK23BAnbWeRTAMtcpy0pnpci611/e28dOXX9wtQAPgehUxS+mQdRliTU6oRx5a1fMQxp1DyxJSVm74vbVT3zZ/YGGEqqwdstm+6QiJDP7BxxcBRxIllQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2759.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b33dc5e-d3c1-43f2-3fc5-08d85b208ff6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2020 15:44:28.3537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SCa3uieol8+HzCIi/4ElhUQsLS9+eIzLkBWuGCQdr8H98+iO7t3rBarbS9dmm4eB6dRTFVh7TWr9VjJFajU0Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2501
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_10:2020-09-16,2020-09-17 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCk9uIDIwMjAtMDktMDMgMjE6NTEsIE5pbGVzaCBKYXZhbGkgd3JvdGU6DQo+IFRoaXMgcGF0
Y2ggdHJhY2tzIG51bWJlciBvZiBJT0NCIHJlc291cmNlcyB1c2VkIGluIHRoZSBJTyBmYXN0IHBh
dGguIA0KPiBJZiB0aGUgbnVtYmVyIG9mIHVzZWQgSU9DQnMgcmVhY2ggYSBoaWdoIHdhdGVyIGxp
bWl0LCBkcml2ZXIgd291bGQgDQo+IHJldHVybiB0aGUgSU8gYXMgYnVzeSBhbmQgbGV0IHVwcGVy
IGxheWVyIHJldHJ5LiBUaGlzIHByZXZlbnRzIG92ZXIgDQo+IHN1YnNjcmlwdGlvbiBvZiBJT0NC
IHJlc291cmNlcyB3aGVyZSBhbnkgZnV0dXJlIGVycm9yIHJlY292ZXJ5IGNvbW1hbmQgDQo+IGlz
IHVuYWJsZSB0byBjdXQgdGhyb3VnaC4NCj4gRW5hYmxlIElPQ0IgdGhyb3R0bGluZyBieSBkZWZh
dWx0Lg0KDQpQbGVhc2UgdXNlIHRoZSBibG9jayBsYXllciByZXNlcnZlZCB0YWcgbWVjaGFuaXNt
IGluc3RlYWQgb2YgYWRkaW5nIGEgbWVjaGFuaXNtIHRoYXQgaXMgKGEpIHJhY3kgYW5kIChiKSB0
cmlnZ2VycyBjYWNoZSBsaW5lIHBpbmctcG9uZy4NCg0KUVQ6IFRoZSBCbG9jayBsYXllciByZXNl
cnZlIHRhZyBkb2VzIGZpdCByZXNvdXJjZSB3ZSdyZSB0cmFja2luZy4gIFRoZSByZXNlcnZlIHRh
ZyBpcyBwZXIgY29tbWFuZC4gIFRoZSBJT0NCIHJlc291cmNlIGlzIGFkYXB0ZXIgc3BlY2lmaWMg
YmVoaW5kICBhbGwgY29tbWFuZHMuDQoNCg0K
