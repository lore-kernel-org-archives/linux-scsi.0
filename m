Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF48C3A59E
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 06:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38FCC2190F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 06:04:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QvFha0DZ";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="uTRAJnQX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbfHZGEO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Aug 2019 02:04:14 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25680 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729100AbfHZGEN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Aug 2019 02:04:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7Q5xpwH018646;
        Sun, 25 Aug 2019 23:04:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=dEOcJBfkH+6AcEDdVvpQIT+c6MqtLiXG8KKy7DR9qms=;
 b=QvFha0DZDcv/gbklUPj/RFW/cGkuFvFny+GSqiw3QFqV+fZhWXr1wUaFR3uDxxH5uc5W
 o+P1rp+al8IvNkg25p+J9aqHqcgirtqY//90rkvKJyhZpn8BrcVXzbc8xjYJSGiTzLgs
 RP+xDZuroYjjD6ZhQMo+oVzA5NOu/UUfFrGrAXb4Inp06tRfdnYCFBQsDWN4IGxqFk6D
 MtYHcl2v4NyHoQHo2ClCpQaGPuBDAjvuizsMiytEHI2XKLZARKV2A889wLq8an4vOil9
 /UParQyZU2gXjcrUFfyFprXsQSYcQQhLIjyzLgRpRi9SA3kHFPpU7bNjj63rSEvtWsl2 DQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uk4rkdg34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 25 Aug 2019 23:04:01 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 25 Aug
 2019 23:03:59 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.53) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 25 Aug 2019 23:03:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axgC0aUG1ZWPxhB6wzgV5Da0LOyIiMgWwHdCi3V2iYAHC4PqP8ISQH5AzcCfpolRdWEQPqcjc3DzgwOXeqBHSXsq87fAnpRwBl6n0urj7iES4m/apUN8wuLZMWZPRZSQm1VlWct2iAdOAK4YDYJB2yWO9vXYliowbbdmoh/5IQBkJ779Lzs5nFpOqQbbX3FU8nfSqxMWfcm9+JgXfHySfzFGINuQgu0zg7bttK1e+4nFhHg4EvQxf0rVDHqU4mqywBWSftqKCvzrzHZPdDJNQTNRU4HXBfQre5zw5TpdQfCBfJpg78AzlXgl+wi0vUiFKNBStEnS6Og8NOffOjfTtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEOcJBfkH+6AcEDdVvpQIT+c6MqtLiXG8KKy7DR9qms=;
 b=QyCdZfwZifxs75Rv9uPeQoZIylMKZLKm6UA0jql/cGPdHPHcrtjfMFyk+5vQpnQnSBHMvDB3M/mbWrCne2714/06WHk/QQbWbpd97KhydrNG5Ks1E1JDN+g1bHEds3njRXsIujcdRbKXnrK04MO1kY6zk4VWud7+xBo+9JbMTNzTUqFdUW0fNX/e2UH8ODTu7k3fU4wlXfSXTuMpnaDvlq4UHuiMdjLqIEefb1Hk52lZ60JbD8+oij6mQwFJpz8ZEHQ7+U1BMCilhnO6oAN7u/3VClWikaJl6InjexMYjNtUSbXdcW9qj/+wsAtTHQi36eqRmWCFi+G/+FkPyVfcJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEOcJBfkH+6AcEDdVvpQIT+c6MqtLiXG8KKy7DR9qms=;
 b=uTRAJnQXBC/pY3dABWaEyY7EAp2Rd1qa1x87P75gWnxke3qc1QH6YUXKoc22JweFATQCyqDdTj5i/MsXdHiSe49SWAkXe3RWWZt2OTPy5E9K+TCs9vBRCsIpkFEmoUBY+9Qvc/6zIU/wcqjBn3Dv4YngVsyljhe8nD4VISltjvc=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (20.179.82.202) by
 MN2PR18MB2671.namprd18.prod.outlook.com (20.179.84.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Mon, 26 Aug 2019 06:03:55 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::849c:fe5a:a645:5668]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::849c:fe5a:a645:5668%7]) with mapi id 15.20.2178.020; Mon, 26 Aug 2019
 06:03:55 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     zhengbin <zhengbin13@huawei.com>,
        "QLogic-Storage-Upstream@qlogic.com" 
        <QLogic-Storage-Upstream@qlogic.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "yi.zhang@huawei.com" <yi.zhang@huawei.com>
Subject: Re: [PATCH 2/3] scsi: bnx2fc: remove set but not used variables
 'lport','host'
Thread-Topic: [PATCH 2/3] scsi: bnx2fc: remove set but not used variables
 'lport','host'
Thread-Index: AQHVWbUVVN5/cWaDpUWy0TgGuL+7DKcNUN0A
Date:   Mon, 26 Aug 2019 06:03:55 +0000
Message-ID: <9631CFB0-F3C7-43DF-81F5-262328AC17F3@marvell.com>
References: <1566566573-49300-1-git-send-email-zhengbin13@huawei.com>
 <1566566573-49300-3-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1566566573-49300-3-git-send-email-zhengbin13@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ad17c18-fafe-4f95-d58c-08d729eb2d88
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2671;
x-ms-traffictypediagnostic: MN2PR18MB2671:
x-microsoft-antispam-prvs: <MN2PR18MB2671616FBB08F9800DF37F32D2A10@MN2PR18MB2671.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:238;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(366004)(39850400004)(136003)(189003)(199004)(6512007)(86362001)(53936002)(2201001)(99286004)(71190400001)(71200400001)(6506007)(76176011)(8936002)(256004)(14444005)(5660300002)(6116002)(3846002)(6436002)(229853002)(6486002)(11346002)(446003)(33656002)(186003)(102836004)(26005)(4326008)(66446008)(64756008)(66476007)(76116006)(91956017)(81156014)(81166006)(7736002)(2616005)(476003)(486006)(305945005)(478600001)(25786009)(66066001)(2501003)(14454004)(316002)(110136005)(66946007)(36756003)(6246003)(8676002)(66556008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2671;H:MN2PR18MB2527.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: erFARTnfI4GS5lm3XiJQ1WfKGyQW6enzXxQGC3MTgb8yyNh8trKK1GQAperaKJ9SZNbUtPdJ5JEOfUg2NMqMQxoaRPeIxxdM3SQof9u+5Haj+7r/IJjCLFeUrjlvR1zH2y+4NR2EhpcQtj9Lk4SJJmlTwNTdhYQrme3rQhZ+ezBLqqtPDYkhUqxH4KeYKF2T1+hx7lq+FLwgLl3++v9PeoTP4TEKDewWYBh+ya2PBr8htFSNIEvb/9ecxsNuU1K3bdorGPcOKzHPp7A2d+HnBbDKkpfLxforZnbXuMSD9B3WYNZ++xax5hrhE/c9n5n6FtfpITZw52h6YbzdLNqw67zqsZfsbjaDBv8FhPp9ipUu2UXz7fz4pFjVkRiDCXBJTsrZg5kEfwiQ8UcITjwfnMO45gpH/hFXPAV/fftsFz4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <861E6F57666A554EB68EFC395E5BC63B@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad17c18-fafe-4f95-d58c-08d729eb2d88
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 06:03:55.2900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MvVCSwU0bgOum+wL8FXxe2jaT1F4lFyIxmVaj4+F+mmDrTwJINqEhc3qajvVifDNs2DaIA2MwxYNiuh4XzlaSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2671
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-26_03:2019-08-23,2019-08-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDIzLzA4LzE5LCA2OjQ3IFBNLCAibGludXgtc2NzaS1vd25lckB2Z2VyLmtlcm5l
bC5vcmcgb24gYmVoYWxmIG9mIHpoZW5nYmluIiA8bGludXgtc2NzaS1vd25lckB2Z2VyLmtlcm5l
bC5vcmcgb24gYmVoYWxmIG9mIHpoZW5nYmluMTNAaHVhd2VpLmNvbT4gd3JvdGU6DQoNCiAgICBG
aXhlcyBnY2MgJy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGUnIHdhcm5pbmc6DQogICAgDQogICAg
ZHJpdmVycy9zY3NpL2JueDJmYy9ibngyZmNfaW8uYzogSW4gZnVuY3Rpb24gYm54MmZjX2luaXRp
YXRlX3NlcV9jbGVhbnVwOg0KICAgIGRyaXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2lvLmM6OTMy
OjE5OiB3YXJuaW5nOiB2YXJpYWJsZSBscG9ydCBzZXQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1i
dXQtc2V0LXZhcmlhYmxlXQ0KICAgIGRyaXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2lvLmM6IElu
IGZ1bmN0aW9uIGJueDJmY19pbml0aWF0ZV9jbGVhbnVwOg0KICAgIGRyaXZlcnMvc2NzaS9ibngy
ZmMvYm54MmZjX2lvLmM6MTAwMToxOTogd2FybmluZzogdmFyaWFibGUgbHBvcnQgc2V0IGJ1dCBu
b3QgdXNlZCBbLVd1bnVzZWQtYnV0LXNldC12YXJpYWJsZV0NCiAgICBkcml2ZXJzL3Njc2kvYm54
MmZjL2JueDJmY19pby5jOiBJbiBmdW5jdGlvbiBibngyZmNfcHJvY2Vzc19zY3NpX2NtZF9jb21w
bDoNCiAgICBkcml2ZXJzL3Njc2kvYm54MmZjL2JueDJmY19pby5jOjE4ODI6MjA6IHdhcm5pbmc6
IHZhcmlhYmxlIGhvc3Qgc2V0IGJ1dCBub3QgdXNlZCBbLVd1bnVzZWQtYnV0LXNldC12YXJpYWJs
ZV0NCiAgICANCiAgICBSZXBvcnRlZC1ieTogSHVsayBSb2JvdCA8aHVsa2NpQGh1YXdlaS5jb20+
DQogICAgU2lnbmVkLW9mZi1ieTogemhlbmdiaW4gPHpoZW5nYmluMTNAaHVhd2VpLmNvbT4NCiAg
ICAtLS0NCiAgICAgZHJpdmVycy9zY3NpL2JueDJmYy9ibngyZmNfaW8uYyB8IDcgLS0tLS0tLQ0K
ICAgICAxIGZpbGUgY2hhbmdlZCwgNyBkZWxldGlvbnMoLSkNCiAgICANCiAgICBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL2JueDJmYy9ibngyZmNfaW8uYyBiL2RyaXZlcnMvc2NzaS9ibngyZmMv
Ym54MmZjX2lvLmMNCiAgICBpbmRleCA5ZTUwZTViLi5kYTAwY2E1IDEwMDY0NA0KICAgIC0tLSBh
L2RyaXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2lvLmMNCiAgICArKysgYi9kcml2ZXJzL3Njc2kv
Ym54MmZjL2JueDJmY19pby5jDQogICAgQEAgLTkzMCw3ICs5MzAsNiBAQCBpbnQgYm54MmZjX2lu
aXRpYXRlX2FidHMoc3RydWN0IGJueDJmY19jbWQgKmlvX3JlcSkNCiAgICAgaW50IGJueDJmY19p
bml0aWF0ZV9zZXFfY2xlYW51cChzdHJ1Y3QgYm54MmZjX2NtZCAqb3JpZ19pb19yZXEsIHUzMiBv
ZmZzZXQsDQogICAgIAkJCQllbnVtIGZjX3JjdGwgcl9jdGwpDQogICAgIHsNCiAgICAtCXN0cnVj
dCBmY19scG9ydCAqbHBvcnQ7DQogICAgIAlzdHJ1Y3QgYm54MmZjX3Jwb3J0ICp0Z3QgPSBvcmln
X2lvX3JlcS0+dGd0Ow0KICAgICAJc3RydWN0IGJueDJmY19pbnRlcmZhY2UgKmludGVyZmFjZTsN
CiAgICAgCXN0cnVjdCBmY29lX3BvcnQgKnBvcnQ7DQogICAgQEAgLTk0OCw3ICs5NDcsNiBAQCBp
bnQgYm54MmZjX2luaXRpYXRlX3NlcV9jbGVhbnVwKHN0cnVjdCBibngyZmNfY21kICpvcmlnX2lv
X3JlcSwgdTMyIG9mZnNldCwNCiAgICANCiAgICAgCXBvcnQgPSBvcmlnX2lvX3JlcS0+cG9ydDsN
CiAgICAgCWludGVyZmFjZSA9IHBvcnQtPnByaXY7DQogICAgLQlscG9ydCA9IHBvcnQtPmxwb3J0
Ow0KICAgIA0KICAgICAJY2JfYXJnID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IGJueDJmY19lbHNf
Y2JfYXJnKSwgR0ZQX0FUT01JQyk7DQogICAgIAlpZiAoIWNiX2FyZykgew0KICAgIEBAIC05OTks
NyArOTk3LDYgQEAgaW50IGJueDJmY19pbml0aWF0ZV9zZXFfY2xlYW51cChzdHJ1Y3QgYm54MmZj
X2NtZCAqb3JpZ19pb19yZXEsIHUzMiBvZmZzZXQsDQogICAgDQogICAgIGludCBibngyZmNfaW5p
dGlhdGVfY2xlYW51cChzdHJ1Y3QgYm54MmZjX2NtZCAqaW9fcmVxKQ0KICAgICB7DQogICAgLQlz
dHJ1Y3QgZmNfbHBvcnQgKmxwb3J0Ow0KICAgICAJc3RydWN0IGJueDJmY19ycG9ydCAqdGd0ID0g
aW9fcmVxLT50Z3Q7DQogICAgIAlzdHJ1Y3QgYm54MmZjX2ludGVyZmFjZSAqaW50ZXJmYWNlOw0K
ICAgICAJc3RydWN0IGZjb2VfcG9ydCAqcG9ydDsNCiAgICBAQCAtMTAxNSw3ICsxMDEyLDYgQEAg
aW50IGJueDJmY19pbml0aWF0ZV9jbGVhbnVwKHN0cnVjdCBibngyZmNfY21kICppb19yZXEpDQog
ICAgDQogICAgIAlwb3J0ID0gaW9fcmVxLT5wb3J0Ow0KICAgICAJaW50ZXJmYWNlID0gcG9ydC0+
cHJpdjsNCiAgICAtCWxwb3J0ID0gcG9ydC0+bHBvcnQ7DQogICAgDQogICAgIAljbGVhbnVwX2lv
X3JlcSA9IGJueDJmY19lbHN0bV9hbGxvYyh0Z3QsIEJOWDJGQ19DTEVBTlVQKTsNCiAgICAgCWlm
ICghY2xlYW51cF9pb19yZXEpIHsNCiAgICBAQCAtMTkyNyw4ICsxOTIzLDYgQEAgdm9pZCBibngy
ZmNfcHJvY2Vzc19zY3NpX2NtZF9jb21wbChzdHJ1Y3QgYm54MmZjX2NtZCAqaW9fcmVxLA0KICAg
ICAJc3RydWN0IGZjb2VfZmNwX3JzcF9wYXlsb2FkICpmY3BfcnNwOw0KICAgICAJc3RydWN0IGJu
eDJmY19ycG9ydCAqdGd0ID0gaW9fcmVxLT50Z3Q7DQogICAgIAlzdHJ1Y3Qgc2NzaV9jbW5kICpz
Y19jbWQ7DQogICAgLQlzdHJ1Y3QgU2NzaV9Ib3N0ICpob3N0Ow0KICAgIC0NCiAgICANCiAgICAg
CS8qIHNjc2lfY21kX2NtcGwgaXMgY2FsbGVkIHdpdGggdGd0IGxvY2sgaGVsZCAqLw0KICAgIA0K
ICAgIEBAIC0xOTU3LDcgKzE5NTEsNiBAQCB2b2lkIGJueDJmY19wcm9jZXNzX3Njc2lfY21kX2Nv
bXBsKHN0cnVjdCBibngyZmNfY21kICppb19yZXEsDQogICAgIAkvKiBwYXJzZSBmY3BfcnNwIGFu
ZCBvYnRhaW4gc2Vuc2UgZGF0YSBmcm9tIFJRIGlmIGF2YWlsYWJsZSAqLw0KICAgICAJYm54MmZj
X3BhcnNlX2ZjcF9yc3AoaW9fcmVxLCBmY3BfcnNwLCBudW1fcnEpOw0KICAgIA0KICAgIC0JaG9z
dCA9IHNjX2NtZC0+ZGV2aWNlLT5ob3N0Ow0KICAgICAJaWYgKCFzY19jbWQtPlNDcC5wdHIpIHsN
CiAgICAgCQlwcmludGsoS0VSTl9FUlIgUEZYICJTQ3AucHRyIGlzIE5VTExcbiIpOw0KICAgICAJ
CXJldHVybjsNCiAgICAtLQ0KICAgIDIuNy40DQoNCkhpLA0KVGhhbmtzIGZvciBwYXRjaC4NCg0K
QWNrZWQtYnk6IFNhdXJhdiBLYXNoeWFwIDxza2FzaHlhcEBtYXJ2ZWxsLmNvbT4NCg0KVGhhbmtz
LA0KflNhdXJhdg0KICAgIA0KICAgIA0KDQo=
