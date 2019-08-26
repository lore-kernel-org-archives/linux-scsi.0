Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B28C3A59E
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 06:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 008B52190F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 06:04:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="nwaE9YOs";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="cMA8rTN3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbfHZGEA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Aug 2019 02:04:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62036 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729100AbfHZGEA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Aug 2019 02:04:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7Q5xo86018372;
        Sun, 25 Aug 2019 23:03:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=+J2nee7WUuhjRo0cdRJzy7sUD4BIbwxafh3xi3AZos8=;
 b=nwaE9YOsMhhesS86hbqO7boWCoeG+L/7QDg7PLsHn0Lw/MLdd6MO/GYqM4zol9tSZAYJ
 SLkT2lcwSg5aZXIGXtawCFRUy6XElusYovsC/zLIOlTr6NoEq0LHMyyKnkeItS6BLgOa
 T0uWju3nxPvngcQtMEjB7h4HiO6qdUGuDpY53Atk0X4kmLB25l2A+B4cDlhSFPnopqEo
 MkVvgAUgogBnGs+j4ZNeVU3LSP/angVAgZLSzmrlUGE6onki0SAHA+jo/Jr0TnF+rIMf
 AbhuNkrSJyggvRLeTWXP9iDJFBy4hvViIY1KB2dgZjG27l/tiTxL41zBipA6fKw4LziB vw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uk4rkdg2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 25 Aug 2019 23:03:49 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 25 Aug
 2019 23:03:47 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (104.47.50.51) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 25 Aug 2019 23:03:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzLcot9IkXwGSjjCgqmDfecL+IaU/FGuvuZR91/t6vN9R0SHu0YAr8NuuREMC+BE7EPzywzIzm3OZCYGmSq8INIFGhpXBQosAPNBu+rH76Ha5j3bNvm7NrsYb1M0cESWHa06EdP4fcem4tB925Yqs+y6yGj5ukfUZJ/WGlid7aACNOULwFufPNOv2v6l9Nc8WK+r7FCmkgIgLuhE9NscHVX2nXSDWutXzl2tHey2U+aVlyW7/Fte23GgiTuiVqCaaO//HUMkryZAbO5jn7IMOR9sw4eb/OGOAsMlX2xTF/qOltduE6QtueQevfGY6FWrx3k0HMrPtBo+iuBvxfouOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+J2nee7WUuhjRo0cdRJzy7sUD4BIbwxafh3xi3AZos8=;
 b=M+sV1kR7/R2QaaZvCYYLTYp59yO3qDGPQOiyp2cDOguiZh/XgMbQVY1QtJ63A0ZXCVbG72seTRuOFURYYovGaageLLaIrarneoThFQRt9x4sNS5r9c/pxSLxSMqcKinQZvCm23A+plsD6pap2+mA67RH9Coxy65NShOLoy6lChc0IZsZpaYte+33ImiIAXVDot7P59ae7tfjYIWIxwcZJPsBc2plgzofVAlrCYL21oGSaaRtueCJ9M8vkDd4iS3IJ9FvML2fyeE8Cp9SVtpKics51sKA2Hj1jBOBApiRdApI38N94f11Sydb/3VmYpg+oImivs8uIAt1tuMN75ItQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+J2nee7WUuhjRo0cdRJzy7sUD4BIbwxafh3xi3AZos8=;
 b=cMA8rTN3bdA9rEfBIW/G4kkeJ+87OCEPDUpRvsxrKX6FkSFD9/OvyI+G/x6C/a2fLeUqlKGaxPDK13eGJq9pc2uZoq5T+uG6pK0Eg/TqDmEkMFfNe0G2SwwYP28sl7yGa2/fDCIf6G+c2etpZbbyNYBybIYr9RjkPnGae9EbV2o=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (20.179.82.202) by
 MN2PR18MB2671.namprd18.prod.outlook.com (20.179.84.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Mon, 26 Aug 2019 06:03:43 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::849c:fe5a:a645:5668]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::849c:fe5a:a645:5668%7]) with mapi id 15.20.2178.020; Mon, 26 Aug 2019
 06:03:43 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     zhengbin <zhengbin13@huawei.com>,
        "QLogic-Storage-Upstream@qlogic.com" 
        <QLogic-Storage-Upstream@qlogic.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "yi.zhang@huawei.com" <yi.zhang@huawei.com>
Subject: Re: [PATCH 3/3] scsi: bnx2fc: remove set but not used variables
 'task','port','orig_task'
Thread-Topic: [PATCH 3/3] scsi: bnx2fc: remove set but not used variables
 'task','port','orig_task'
Thread-Index: AQHVWbUKXEyo/2g3GEeChWfWIXsSo6cNUM8A
Date:   Mon, 26 Aug 2019 06:03:43 +0000
Message-ID: <5BE30777-3664-42D0-B151-E5C06BFD2F3A@marvell.com>
References: <1566566573-49300-1-git-send-email-zhengbin13@huawei.com>
 <1566566573-49300-4-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1566566573-49300-4-git-send-email-zhengbin13@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9fc97463-7e11-47df-ae3b-08d729eb262e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2671;
x-ms-traffictypediagnostic: MN2PR18MB2671:
x-microsoft-antispam-prvs: <MN2PR18MB26714211AEB0C04F06F27BDAD2A10@MN2PR18MB2671.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:229;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(366004)(39850400004)(136003)(189003)(199004)(6512007)(86362001)(53936002)(2201001)(99286004)(71190400001)(71200400001)(6506007)(76176011)(8936002)(256004)(14444005)(5660300002)(6116002)(3846002)(6436002)(229853002)(6486002)(11346002)(446003)(33656002)(186003)(102836004)(26005)(4326008)(66446008)(64756008)(66476007)(76116006)(91956017)(81156014)(81166006)(7736002)(2616005)(476003)(486006)(305945005)(478600001)(25786009)(66066001)(2501003)(14454004)(316002)(110136005)(66946007)(36756003)(6246003)(8676002)(66556008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2671;H:MN2PR18MB2527.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6zQjvGAHg/+KDKrAarDZ9EdIZ4BHYJvyB8j60UGuKTSkwsanHnjlvtpqKaF/CpDcbU2M0luqyu2EA3hyaIx+RotnhA7sDQN0O32PDb8wWTwAJFNFvdoZXerNTZLtkD3gQeRkKXEdll3d3gzi6ThEIDqE1Vz0epPfsM6dqyKj0O4tQZ+q5QoMb7tnWpgYYzGuynvLLLiQ8d1/bJUQUesWyBMW0CST+xE39qtP2wBJJ4P4hCvKkkVLBac0byQ8eUxYMQj5yvkGbEYblrSduSFuIh760/rBXkr1VRi0CBslHB2+zvvfbuEFZ0SXBTI6OnqbQOGBUI8q1XFJ6iQbfZn5/c5MqFsxVnrwHkFYpv5oqzm/OiZ8owkzUSP8lEYuV0wkLFn8mYr4i2wlWz1REmtlSbPByEc0e7gyrku/p2/4djQ=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <644DE7BBA87938489FD73A67B94254F8@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc97463-7e11-47df-ae3b-08d729eb262e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 06:03:43.0141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vnyYxhE8StSxv06WPJaVNcqb1gMHKYSdYi27FwOA9suCSa9CLaxTmSaXtGO5IVpucmjgxntgiAjVw2H1mU4mSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2671
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-26_03:2019-08-23,2019-08-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDIzLzA4LzE5LCA2OjQ2IFBNLCAibGludXgtc2NzaS1vd25lckB2Z2VyLmtlcm5l
bC5vcmcgb24gYmVoYWxmIG9mIHpoZW5nYmluIiA8bGludXgtc2NzaS1vd25lckB2Z2VyLmtlcm5l
bC5vcmcgb24gYmVoYWxmIG9mIHpoZW5nYmluMTNAaHVhd2VpLmNvbT4gd3JvdGU6DQoNCiAgICBG
aXhlcyBnY2MgJy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGUnIHdhcm5pbmc6DQogICAgDQogICAg
ZHJpdmVycy9zY3NpL2JueDJmYy9ibngyZmNfaHdpLmM6IEluIGZ1bmN0aW9uIGJueDJmY19wcm9j
ZXNzX3Vuc29sX2NvbXBsOg0KICAgIGRyaXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2h3aS5jOjYz
NjozMDogd2FybmluZzogdmFyaWFibGUgdGFzayBzZXQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1i
dXQtc2V0LXZhcmlhYmxlXQ0KICAgIGRyaXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2h3aS5jOiBJ
biBmdW5jdGlvbiBibngyZmNfcHJvY2Vzc19vZmxkX2NtcGw6DQogICAgZHJpdmVycy9zY3NpL2Ju
eDJmYy9ibngyZmNfaHdpLmM6MTEyNToyMTogd2FybmluZzogdmFyaWFibGUgcG9ydCBzZXQgYnV0
IG5vdCB1c2VkIFstV3VudXNlZC1idXQtc2V0LXZhcmlhYmxlXQ0KICAgIGRyaXZlcnMvc2NzaS9i
bngyZmMvYm54MmZjX2h3aS5jOiBJbiBmdW5jdGlvbiBibngyZmNfaW5pdF9zZXFfY2xlYW51cF90
YXNrOg0KICAgIGRyaXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2h3aS5jOjE0Njg6MzA6IHdhcm5p
bmc6IHZhcmlhYmxlIG9yaWdfdGFzayBzZXQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1idXQtc2V0
LXZhcmlhYmxlXQ0KICAgIA0KICAgIFJlcG9ydGVkLWJ5OiBIdWxrIFJvYm90IDxodWxrY2lAaHVh
d2VpLmNvbT4NCiAgICBTaWduZWQtb2ZmLWJ5OiB6aGVuZ2JpbiA8emhlbmdiaW4xM0BodWF3ZWku
Y29tPg0KICAgIC0tLQ0KICAgICBkcml2ZXJzL3Njc2kvYm54MmZjL2JueDJmY19od2kuYyB8IDE2
IC0tLS0tLS0tLS0tLS0tLS0NCiAgICAgMSBmaWxlIGNoYW5nZWQsIDE2IGRlbGV0aW9ucygtKQ0K
ICAgIA0KICAgIGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvYm54MmZjL2JueDJmY19od2kuYyBi
L2RyaXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2h3aS5jDQogICAgaW5kZXggNzQ3ZjAxOS4uZjA2
OWUwOSAxMDA2NDQNCiAgICAtLS0gYS9kcml2ZXJzL3Njc2kvYm54MmZjL2JueDJmY19od2kuYw0K
ICAgICsrKyBiL2RyaXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2h3aS5jDQogICAgQEAgLTYzMyw3
ICs2MzMsNiBAQCBzdGF0aWMgdm9pZCBibngyZmNfcHJvY2Vzc191bnNvbF9jb21wbChzdHJ1Y3Qg
Ym54MmZjX3Jwb3J0ICp0Z3QsIHUxNiB3cWUpDQogICAgIAl1MTYgeGlkOw0KICAgICAJdTMyIGZy
YW1lX2xlbiwgbGVuOw0KICAgICAJc3RydWN0IGJueDJmY19jbWQgKmlvX3JlcSA9IE5VTEw7DQog
ICAgLQlzdHJ1Y3QgZmNvZV90YXNrX2N0eF9lbnRyeSAqdGFzaywgKnRhc2tfcGFnZTsNCiAgICAg
CXN0cnVjdCBibngyZmNfaW50ZXJmYWNlICppbnRlcmZhY2UgPSB0Z3QtPnBvcnQtPnByaXY7DQog
ICAgIAlzdHJ1Y3QgYm54MmZjX2hiYSAqaGJhID0gaW50ZXJmYWNlLT5oYmE7DQogICAgIAlpbnQg
dGFza19pZHgsIGluZGV4Ow0KICAgIEBAIC03MTEsOSArNzEwLDYgQEAgc3RhdGljIHZvaWQgYm54
MmZjX3Byb2Nlc3NfdW5zb2xfY29tcGwoc3RydWN0IGJueDJmY19ycG9ydCAqdGd0LCB1MTYgd3Fl
KQ0KICAgIA0KICAgICAJCXRhc2tfaWR4ID0geGlkIC8gQk5YMkZDX1RBU0tTX1BFUl9QQUdFOw0K
ICAgICAJCWluZGV4ID0geGlkICUgQk5YMkZDX1RBU0tTX1BFUl9QQUdFOw0KICAgIC0JCXRhc2tf
cGFnZSA9IChzdHJ1Y3QgZmNvZV90YXNrX2N0eF9lbnRyeSAqKQ0KICAgIC0JCQkJCWhiYS0+dGFz
a19jdHhbdGFza19pZHhdOw0KICAgIC0JCXRhc2sgPSAmKHRhc2tfcGFnZVtpbmRleF0pOw0KICAg
IA0KICAgICAJCWlvX3JlcSA9IChzdHJ1Y3QgYm54MmZjX2NtZCAqKWhiYS0+Y21kX21nci0+Y21k
c1t4aWRdOw0KICAgICAJCWlmICghaW9fcmVxKQ0KICAgIEBAIC04MzksOSArODM1LDYgQEAgc3Rh
dGljIHZvaWQgYm54MmZjX3Byb2Nlc3NfdW5zb2xfY29tcGwoc3RydWN0IGJueDJmY19ycG9ydCAq
dGd0LCB1MTYgd3FlKQ0KICAgIA0KICAgICAJCXRhc2tfaWR4ID0geGlkIC8gQk5YMkZDX1RBU0tT
X1BFUl9QQUdFOw0KICAgICAJCWluZGV4ID0geGlkICUgQk5YMkZDX1RBU0tTX1BFUl9QQUdFOw0K
ICAgIC0JCXRhc2tfcGFnZSA9IChzdHJ1Y3QgZmNvZV90YXNrX2N0eF9lbnRyeSAqKQ0KICAgIC0J
CQkgICAgIGludGVyZmFjZS0+aGJhLT50YXNrX2N0eFt0YXNrX2lkeF07DQogICAgLQkJdGFzayA9
ICYodGFza19wYWdlW2luZGV4XSk7DQogICAgIAkJaW9fcmVxID0gKHN0cnVjdCBibngyZmNfY21k
ICopaGJhLT5jbWRfbWdyLT5jbWRzW3hpZF07DQogICAgIAkJaWYgKCFpb19yZXEpDQogICAgIAkJ
CWdvdG8gcmV0X3dhcm5fcnFlOw0KICAgIEBAIC0xMTIyLDcgKzExMTUsNiBAQCBzdGF0aWMgdm9p
ZCBibngyZmNfcHJvY2Vzc19vZmxkX2NtcGwoc3RydWN0IGJueDJmY19oYmEgKmhiYSwNCiAgICAg
CQkJCQlzdHJ1Y3QgZmNvZV9rY3FlICpvZmxkX2tjcWUpDQogICAgIHsNCiAgICAgCXN0cnVjdCBi
bngyZmNfcnBvcnQJCSp0Z3Q7DQogICAgLQlzdHJ1Y3QgZmNvZV9wb3J0CQkqcG9ydDsNCiAgICAg
CXN0cnVjdCBibngyZmNfaW50ZXJmYWNlCQkqaW50ZXJmYWNlOw0KICAgICAJdTMyCQkJCWNvbm5f
aWQ7DQogICAgIAl1MzIJCQkJY29udGV4dF9pZDsNCiAgICBAQCAtMTEzNiw3ICsxMTI4LDYgQEAg
c3RhdGljIHZvaWQgYm54MmZjX3Byb2Nlc3Nfb2ZsZF9jbXBsKHN0cnVjdCBibngyZmNfaGJhICpo
YmEsDQogICAgIAl9DQogICAgIAlCTlgyRkNfVEdUX0RCRyh0Z3QsICJFbnRlcmVkIG9mbGQgY29t
cGwgLSBjb250ZXh0X2lkID0gMHgleFxuIiwNCiAgICAgCQlvZmxkX2tjcWUtPmZjb2VfY29ubl9j
b250ZXh0X2lkKTsNCiAgICAtCXBvcnQgPSB0Z3QtPnBvcnQ7DQogICAgIAlpbnRlcmZhY2UgPSB0
Z3QtPnBvcnQtPnByaXY7DQogICAgIAlpZiAoaGJhICE9IGludGVyZmFjZS0+aGJhKSB7DQogICAg
IAkJcHJpbnRrKEtFUk5fRVJSIFBGWCAiRVJST1I6b2ZsZF9jbXBsOiBIQkEgbWlzLW1hdGNoXG4i
KTsNCiAgICBAQCAtMTQ2MywxMCArMTQ1NCw3IEBAIHZvaWQgYm54MmZjX2luaXRfc2VxX2NsZWFu
dXBfdGFzayhzdHJ1Y3QgYm54MmZjX2NtZCAqc2VxX2NsbnBfcmVxLA0KICAgICB7DQogICAgIAlz
dHJ1Y3Qgc2NzaV9jbW5kICpzY19jbWQgPSBvcmlnX2lvX3JlcS0+c2NfY21kOw0KICAgICAJc3Ry
dWN0IGJueDJmY19ycG9ydCAqdGd0ID0gc2VxX2NsbnBfcmVxLT50Z3Q7DQogICAgLQlzdHJ1Y3Qg
Ym54MmZjX2ludGVyZmFjZSAqaW50ZXJmYWNlID0gdGd0LT5wb3J0LT5wcml2Ow0KICAgICAJc3Ry
dWN0IGZjb2VfYmRfY3R4ICpiZCA9IG9yaWdfaW9fcmVxLT5iZF90YmwtPmJkX3RibDsNCiAgICAt
CXN0cnVjdCBmY29lX3Rhc2tfY3R4X2VudHJ5ICpvcmlnX3Rhc2s7DQogICAgLQlzdHJ1Y3QgZmNv
ZV90YXNrX2N0eF9lbnRyeSAqdGFza19wYWdlOw0KICAgICAJc3RydWN0IGZjb2VfZXh0X211bF9z
Z2VzX2N0eCAqc2dsOw0KICAgICAJdTggdGFza190eXBlID0gRkNPRV9UQVNLX1RZUEVfU0VRVUVO
Q0VfQ0xFQU5VUDsNCiAgICAgCXU4IG9yaWdfdGFza190eXBlOw0KICAgIEBAIC0xNTI4LDEwICsx
NTE2LDYgQEAgdm9pZCBibngyZmNfaW5pdF9zZXFfY2xlYW51cF90YXNrKHN0cnVjdCBibngyZmNf
Y21kICpzZXFfY2xucF9yZXEsDQogICAgIAkJb3JpZ190YXNrX2lkeCA9IG9yaWdfeGlkIC8gQk5Y
MkZDX1RBU0tTX1BFUl9QQUdFOw0KICAgICAJCWluZGV4ID0gb3JpZ194aWQgJSBCTlgyRkNfVEFT
S1NfUEVSX1BBR0U7DQogICAgDQogICAgLQkJdGFza19wYWdlID0gKHN0cnVjdCBmY29lX3Rhc2tf
Y3R4X2VudHJ5ICopDQogICAgLQkJCSAgICAgaW50ZXJmYWNlLT5oYmEtPnRhc2tfY3R4W29yaWdf
dGFza19pZHhdOw0KICAgIC0JCW9yaWdfdGFzayA9ICYodGFza19wYWdlW2luZGV4XSk7DQogICAg
LQ0KICAgICAJCS8qIE11bHRpcGxlIFNHRXMgd2VyZSB1c2VkIGZvciB0aGlzIElPICovDQogICAg
IAkJc2dsID0gJnRhc2stPnJ4d3Jfb25seS51bmlvbl9jdHgucmVhZF9pbmZvLnNnbF9jdHguc2ds
Ow0KICAgICAJCXNnbC0+bXVsX3NnbC5jdXJfc2dlX2FkZHIubG8gPSAodTMyKXBoeXNfYWRkcjsN
CiAgICAtLQ0KICAgIDIuNy40DQoNCkhpLA0KVGhhbmtzIGZvciBwYXRjaC4NCg0KQWNrZWQtYnk6
IFNhdXJhdiBLYXNoeWFwIDxza2FzaHlhcEBtYXJ2ZWxsLmNvbT4NCg0KVGhhbmtzLA0KflNhdXJh
dg0KICAgIA0KICAgIA0KDQo=
