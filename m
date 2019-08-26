Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2CAC3A59E
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 06:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A875521848
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 06:03:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cnMHN2m0";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="fOh+nrzp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfHZGDo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Aug 2019 02:03:44 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60670 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729100AbfHZGDo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Aug 2019 02:03:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7Q5xo83018372;
        Sun, 25 Aug 2019 23:03:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=/lt9ewiYFj36o0Mk/UxSnGLcMgxfXiKNMejYgbE6/70=;
 b=cnMHN2m0lX+skDyt4Sdglk6qtPmObS9eQY55hbhpRQ6Hu+QpnqaluQnHUTK4EeTwlLZm
 fcFteHUqwANANTP48uSzcca3cq0rIIEpYQxWKnAP5noeYJCfN0JNTn6Rym2YH3Tqosfj
 LSdzasihYCw+yvHuqJ3WVlNXhog2Q0KOjVpx/SVnNIqBP5krc+0/u/cYWrzWwzen333l
 PAAb0ZkJdYD5VKVZGUbP1OZPwFNmLVOxAf1sZfB+27ZEU9Zj7f2r05/o3/7R2rnSLAgb
 WpaSFrpw6soQVNp2Oy5wmE5uylaznaVO/rXQGa2LNeDjUkRpf1t0IUlbWWErtqJ9us4t hw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uk4rkdg1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 25 Aug 2019 23:03:34 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 25 Aug
 2019 23:03:33 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.57) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 25 Aug 2019 23:03:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frJWSjrLbzxWeqHQCs+UlC5Zt7RHSVZsM+JOerpvBJVTBKcWBuz+WrpdiHjEtbyEFnVQMZxqMZaeudJ4Cb4wBCXPp4eB3uUS5uD7o66OqCvqo2d7XygHE7JxxCQ2wtZ/XazUmxa0JMVoaYtYeNp219u9Wwwr+3e2PGAIAoR8lzqOjM0QnSesuEUIb99fRDL2LvLe/p1C/9GJ5C+luPVstcyvXCsnTK82xZQIuLa05CTi9lNt64HDmhRzuIBsD/RH7TKj2gu77ecOexazTwQmlE+DhH5r9lqEDJWVr0uX4dgRVaTWmw7ZMadIEcTYvmZMVa1U/MHWH0ettmNdH6okDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lt9ewiYFj36o0Mk/UxSnGLcMgxfXiKNMejYgbE6/70=;
 b=mV83M8I4qV0p6ZmX+q/nBwBz+ecTs4WNbRZdKsM/6g6y6F8RRi12mzuf9moiI8mgbfaZqHtlV3RSAPYUGdYijwBd+K/mxjM6Z6vZKYYjPBorER3hqFh1d7ByW8+5bTcgEFSxXX1LgMrd4IncTJS6i6K4udm1YbSNArZOeeHrFKTYaMjxunr8SY3HvqYAmrrgELOvmL6JkTAy6xfa4pSajApFGQxRtE0Gcsn06I9u1gUa1R9FDUgxThPdO8F1M/GMNT4bd9jyH+rklnYzj6HZq7Kj8ku/uJfeZf6ZFzFDqiI4llChAoH6mQpSib8TYX7RJY2EbTDFTCrbX0R9SiIBIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lt9ewiYFj36o0Mk/UxSnGLcMgxfXiKNMejYgbE6/70=;
 b=fOh+nrzpQWzD0MnYP+5o9E58QPIk0m55tn5gbxeAQWYEo3IVXVSxUs2uUfffx5+kGZSm3Yp4gI5gsInfDmuAYQxNiXh4etB5eqW2xdg6Dh7hmghYT/9o2lnykC1spC3j13qA2vVXZkYXmfasl4f1UoQtQjS37mCXVKmjpIM/cvQ=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (20.179.82.202) by
 MN2PR18MB2671.namprd18.prod.outlook.com (20.179.84.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Mon, 26 Aug 2019 06:03:31 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::849c:fe5a:a645:5668]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::849c:fe5a:a645:5668%7]) with mapi id 15.20.2178.020; Mon, 26 Aug 2019
 06:03:31 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     zhengbin <zhengbin13@huawei.com>,
        "QLogic-Storage-Upstream@qlogic.com" 
        <QLogic-Storage-Upstream@qlogic.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "yi.zhang@huawei.com" <yi.zhang@huawei.com>
Subject: Re: [PATCH 1/3] scsi: bnx2fc: remove set but not used variable 'fh'
Thread-Topic: [PATCH 1/3] scsi: bnx2fc: remove set but not used variable 'fh'
Thread-Index: AQHVWbUF2yXDKx6o20S0Yzs5FSbH/qcNUMEA
Date:   Mon, 26 Aug 2019 06:03:31 +0000
Message-ID: <14A46C66-12BC-40CD-98F3-3838BB95D3D6@marvell.com>
References: <1566566573-49300-1-git-send-email-zhengbin13@huawei.com>
 <1566566573-49300-2-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1566566573-49300-2-git-send-email-zhengbin13@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0824f9e-1bd7-4257-81cc-08d729eb1f59
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2671;
x-ms-traffictypediagnostic: MN2PR18MB2671:
x-microsoft-antispam-prvs: <MN2PR18MB2671E76BC421FD6E4A178D34D2A10@MN2PR18MB2671.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(346002)(396003)(376002)(366004)(39850400004)(136003)(189003)(199004)(6512007)(86362001)(53936002)(2201001)(99286004)(71190400001)(71200400001)(6506007)(76176011)(8936002)(256004)(14444005)(5660300002)(6116002)(3846002)(6436002)(229853002)(6486002)(11346002)(446003)(33656002)(186003)(102836004)(26005)(4326008)(66446008)(64756008)(66476007)(76116006)(91956017)(81156014)(81166006)(7736002)(2616005)(476003)(486006)(305945005)(478600001)(25786009)(66066001)(2501003)(14454004)(316002)(110136005)(66946007)(36756003)(6246003)(8676002)(66556008)(2906002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2671;H:MN2PR18MB2527.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WXAyuWGK2IZCYZ7hyQ9NSckEfk+sF84X5vRmzX2o0n67e2VrdQ5YlBF7SpCvl7DPH57AYYAOlgxUjioUA1M+khM+Jmc1diN6vJMliB0rJl8LM/im9A+ulMwVH9Jc0zdsUXXemP19nSPwqszLZEl2v5erDLbVlyipYRcxBEZqcyf0UUuOPkZK3IZfI0rWi7wvtxPGBS/0b/FyLyBWp8UEKQRlaz2B2qEwjPeQgulBSFTTztilaaGrNfBLwawMoViLf2+xtrBDW1DDsmwv9IxxJpL//kd+5HWLQO4tHRtfsRmuL4CyT65P7ZvjzvgzG0wGF+5/pJQ4lZjbhEdIgUlWqlgJsZNh+z8ZwzSm7vb72mJkcYhNggyY4B20lWa7tstHFqdrzP7xFhbMMss0QjEuhxfmiRjrx9Hsh0dhG8ELJZM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B0D2A5C57BF36E4C964024AB0FA57016@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f0824f9e-1bd7-4257-81cc-08d729eb1f59
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 06:03:31.3748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fp+bXrSB0Zt5UouftYeQCfRTYVdnQJCleNzMwApfFyXZ3185o3SjLOpIxAFThsxIZK7j4XN5nQkxGRMiw5RY3Q==
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
ZHJpdmVycy9zY3NpL2JueDJmYy9ibngyZmNfZmNvZS5jOiBJbiBmdW5jdGlvbiBibngyZmNfcmN2
Og0KICAgIGRyaXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2Zjb2UuYzo0MzE6MjY6IHdhcm5pbmc6
IHZhcmlhYmxlIGZoIHNldCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVd
DQogICAgDQogICAgUmVwb3J0ZWQtYnk6IEh1bGsgUm9ib3QgPGh1bGtjaUBodWF3ZWkuY29tPg0K
ICAgIFNpZ25lZC1vZmYtYnk6IHpoZW5nYmluIDx6aGVuZ2JpbjEzQGh1YXdlaS5jb20+DQogICAg
LS0tDQogICAgIGRyaXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2Zjb2UuYyB8IDIgLS0NCiAgICAg
MSBmaWxlIGNoYW5nZWQsIDIgZGVsZXRpb25zKC0pDQogICAgDQogICAgZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS9ibngyZmMvYm54MmZjX2Zjb2UuYyBiL2RyaXZlcnMvc2NzaS9ibngyZmMvYm54
MmZjX2Zjb2UuYw0KICAgIGluZGV4IDc3OTY3OTkuLmFiNzIxYWIgMTAwNjQ0DQogICAgLS0tIGEv
ZHJpdmVycy9zY3NpL2JueDJmYy9ibngyZmNfZmNvZS5jDQogICAgKysrIGIvZHJpdmVycy9zY3Np
L2JueDJmYy9ibngyZmNfZmNvZS5jDQogICAgQEAgLTQyOCw3ICs0MjgsNiBAQCBzdGF0aWMgaW50
IGJueDJmY19yY3Yoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKmRldiwN
CiAgICAgCXN0cnVjdCBmY19scG9ydCAqbHBvcnQ7DQogICAgIAlzdHJ1Y3QgYm54MmZjX2ludGVy
ZmFjZSAqaW50ZXJmYWNlOw0KICAgICAJc3RydWN0IGZjb2VfY3RsciAqY3RscjsNCiAgICAtCXN0
cnVjdCBmY19mcmFtZV9oZWFkZXIgKmZoOw0KICAgICAJc3RydWN0IGZjb2VfcmN2X2luZm8gKmZy
Ow0KICAgICAJc3RydWN0IGZjb2VfcGVyY3B1X3MgKmJnOw0KICAgICAJc3RydWN0IHNrX2J1ZmYg
KnRtcF9za2I7DQogICAgQEAgLTQ2Myw3ICs0NjIsNiBAQCBzdGF0aWMgaW50IGJueDJmY19yY3Yo
c3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCiAgICAgCQlnb3Rv
IGVycjsNCiAgICANCiAgICAgCXNrYl9zZXRfdHJhbnNwb3J0X2hlYWRlcihza2IsIHNpemVvZihz
dHJ1Y3QgZmNvZV9oZHIpKTsNCiAgICAtCWZoID0gKHN0cnVjdCBmY19mcmFtZV9oZWFkZXIgKikg
c2tiX3RyYW5zcG9ydF9oZWFkZXIoc2tiKTsNCiAgICANCiAgICAgCWZyID0gZmNvZV9kZXZfZnJv
bV9za2Ioc2tiKTsNCiAgICAgCWZyLT5mcl9kZXYgPSBscG9ydDsNCiAgICAtLQ0KICAgIDIuNy40
DQoNCkhpLA0KVGhhbmtzIGZvciBwYXRjaC4NCg0KQWNrZWQtYnk6IFNhdXJhdiBLYXNoeWFwIDxz
a2FzaHlhcEBtYXJ2ZWxsLmNvbT4NCg0KVGhhbmtzLA0KflNhdXJhdg0KICAgIA0KICAgIA0KDQo=
