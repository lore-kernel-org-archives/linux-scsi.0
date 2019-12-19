Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A16FC43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 22:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F121824679
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 22:40:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Q1qSGA6B";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="WwXUww25"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfLSWkG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 17:40:06 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19672 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726818AbfLSWkG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Dec 2019 17:40:06 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJMUxq9007900;
        Thu, 19 Dec 2019 14:39:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=mmCPFUDfEZvohBr/NjLD+K6OqXX8el6/OG5PFqGbURE=;
 b=Q1qSGA6BVR/EWlaGSt3xYDBiuSFmQQRPi9FKZHLQH/3TwEsk/AQyNwYs3BS6RTaQedKj
 a2NOpgEAU7FMGQhjyx8ToYl+rGo1MPPx7UaW8c6N9SpZFNdhkVlRQTKX/8b309yCmzMs
 4FyC2gscP1c1YlUAy+abz3E8zQg4BW8cqCp7CegF7a7MM4+dpREJAlnKlMIi9Y//AP3+
 Qd9wq7XktiZnHe2b1jEMSsBvIUVh/XONlc9FPAbMrkjRvLAp1/mgFruTLNFMpbCmGMRM
 08u4FacQtlpUOROudK8yDztb/X56d+AIBvup8gr2XVcs/K8MdvFD7eA7w66w6nbWX4BR aA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wxn0ww1fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 14:39:55 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Dec
 2019 14:39:53 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.55) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 19 Dec 2019 14:39:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECWyC8UBWtzmFjUwyTEHQ/xvN0O7Wn0G1dmHntu8lAxkY8+O1dSIwma+0goLmbol39Og6CkhOgsiQhXq92eq7gfa5kZd6Y66Qzpt1MX3SAayFf5w9DmbGibQGrT9O+36CkuIbZ3KmJ3f9zIzWNqRbylqxEf4xehXj1YZCIIvwOoL6oJwu2i8H/HOkq9SQYAm5Vn1zUrGKt7YAGBC98xqNL2ku5/SqzCA3oOsntvsuoj8f24rbzVVRZg7hFFdUdVv7054jfM2hbp05lxXZ0kQnKk8YtUrSAUu6pDp7Rk5i+b5jLrTzoBWEw1cMrX5W6YBwDBfpf3BxaG68XfqQz11TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mmCPFUDfEZvohBr/NjLD+K6OqXX8el6/OG5PFqGbURE=;
 b=WFAKF5fQyheQjHXU6KTa4izHew321zu0ynYQdwERd40IDo7qQWeu5Mlj9Gi8r/maZNFfP7NqKVWe9Auc1SOA+wwq0CB0N5I0AEkNZ7gn5mu3iVCRvDcq93ZuQvDT1ygbQGA8GbmtUBDcT30rUwQdpVBnS5VX9YE0CObZGx+lmykzFcXWGtwwpLQKWKFSMCE8YKgnI5lRuktzTwRPzeMJYjLD6jUJC3T//9nTqWd5hYv++q9KhEtU8uOBxqgY2A3OmEr6oXIcc4NZAL6NG4P3uUYfSiPMtDCVrD8XVkqRTVpdpK9UdXJQLpClfSJocc1iqE4pbknEgvjziPAuXF9Vww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mmCPFUDfEZvohBr/NjLD+K6OqXX8el6/OG5PFqGbURE=;
 b=WwXUww25gbauySE1ZHRIK9P4mgVZym3t6onmb3yhX3wVFQWopf92EI8ItWiEqxAwsbz4wkpntlB07Osc7xpccn2E/tC7pBOukrwcmAMBJGFIymAlumuPRZPCpol1pz3VYThjBbu2wp0GSQrle785yCrmiFulbFHSpFnJ24b58bA=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3165.namprd18.prod.outlook.com (10.255.237.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Thu, 19 Dec 2019 22:39:50 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::eda7:1699:29f1:9eb8]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::eda7:1699:29f1:9eb8%5]) with mapi id 15.20.2559.016; Thu, 19 Dec 2019
 22:39:50 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [EXT] [PATCH] qla2xxx: Fix sparse warnings triggered by the PCI
 state checking code
Thread-Topic: [EXT] [PATCH] qla2xxx: Fix sparse warnings triggered by the PCI
 state checking code
Thread-Index: AQHVtgV3olJqe0Jbnk6Mam50Xqi+9KfBqdCA
Date:   Thu, 19 Dec 2019 22:39:50 +0000
Message-ID: <00D35BE5-B846-4451-A1A4-27FED46640F7@marvell.com>
References: <20191219004412.37639-1-bvanassche@acm.org>
In-Reply-To: <20191219004412.37639-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.20.0.191208
x-originating-ip: [66.73.206.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75cec3df-071f-42b0-9bc2-08d784d45bff
x-ms-traffictypediagnostic: MN2PR18MB3165:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB31655E0C717E5597673F9C54D6520@MN2PR18MB3165.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(199004)(189003)(66946007)(2906002)(4326008)(66556008)(66476007)(33656002)(8676002)(110136005)(6506007)(91956017)(186003)(5660300002)(26005)(76116006)(66446008)(81166006)(6486002)(71200400001)(81156014)(86362001)(54906003)(6512007)(36756003)(316002)(478600001)(64756008)(2616005)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3165;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IkkGGsWbqrjkCemGoLSFQilp1DgCJFtXbHLIXDGNjf952+OxjJtuwO/qqx2fWWKubGNVx8K3GcoU7geeVpLfgI+1EoEjdASvj0vK/LS9AuQ3CPpVRYS7xZosmW5Qu2S+QXrwCqPMtBxcdbx9UsAxxkpGU8+yK49o49itONy0zzDoHu4oA5fT3LPX/sUZHooMAr1b6Saf3wllIlUgJqQSbRgTj1C9IyL+Eel/pTo+c7Rqu2QhpnhRE/61tyhUgFqp+jANXrxk8li4r7CBLgkT0Mh4KSCjWuo/KRSICR0LJGp1Rn6uCMiDi9VG7ahw2fCahdKXOsjGJJifxrvmPFu920+J3KUNiAwFBycoWB7IXf6UGyGKXREnGw6QjdRR8oWffcmK8gCJ1ZMVZIEkqvxE5yjjEmDRkwUuNU6b80nWUTS0PqxcN4Hy/RImupymleFz
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB3913868C2DC04CB7AE1FE7EC6144C3@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 75cec3df-071f-42b0-9bc2-08d784d45bff
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 22:39:50.5926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yl4bqfgNnuY7lqpyJ/4/PUWfghIP9xcWoLdP049LeKuIoau87HrJDXSnQERzzBRy90Yoq76Pm8sEVis+1caP2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3165
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_07:2019-12-17,2019-12-19 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDEyLzE4LzE5LCA2OjQ0IFBNLCAiQmFydCBWYW4gQXNzY2hlIiA8YnZhbmFzc2No
ZUBhY20ub3JnPiB3cm90ZToNCg0KICAgIEV4dGVybmFsIEVtYWlsDQogICAgDQogICAgLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQ0KICAgIFRoaXMgcGF0Y2ggZml4ZXMgdGhlIGZvbGxvd2luZyBzcGFyc2Ugd2Fybmlu
Z3M6DQogICAgDQogICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX21ieC5jOjEyMDoyMTogd2Fy
bmluZzogcmVzdHJpY3RlZCBwY2lfY2hhbm5lbF9zdGF0ZV90IGRlZ3JhZGVzIHRvIGludGVnZXIN
CiAgICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbWJ4LmM6MTIwOjM3OiB3YXJuaW5nOiByZXN0
cmljdGVkIHBjaV9jaGFubmVsX3N0YXRlX3QgZGVncmFkZXMgdG8gaW50ZWdlcg0KICAgIA0KICAg
IFRoaXMgcGF0Y2ggZG9lcyBub3QgY2hhbmdlIGFueSBmdW5jdGlvbmFsaXR5LiBGcm9tIGluY2x1
ZGUvbGludXgvcGNpLmg6DQogICAgDQogICAgZW51bSBwY2lfY2hhbm5lbF9zdGF0ZSB7DQogICAg
CS8qIEkvTyBjaGFubmVsIGlzIGluIG5vcm1hbCBzdGF0ZSAqLw0KICAgIAlwY2lfY2hhbm5lbF9p
b19ub3JtYWwgPSAoX19mb3JjZSBwY2lfY2hhbm5lbF9zdGF0ZV90KSAxLA0KICAgIA0KICAgIAkv
KiBJL08gdG8gY2hhbm5lbCBpcyBibG9ja2VkICovDQogICAgCXBjaV9jaGFubmVsX2lvX2Zyb3pl
biA9IChfX2ZvcmNlIHBjaV9jaGFubmVsX3N0YXRlX3QpIDIsDQogICAgDQogICAgCS8qIFBDSSBj
YXJkIGlzIGRlYWQgKi8NCiAgICAJcGNpX2NoYW5uZWxfaW9fcGVybV9mYWlsdXJlID0gKF9fZm9y
Y2UgcGNpX2NoYW5uZWxfc3RhdGVfdCkgMywNCiAgICB9Ow0KICAgIA0KICAgIENjOiBIaW1hbnNo
dSBNYWRoYW5pIDxobWFkaGFuaUBtYXJ2ZWxsLmNvbT4NCiAgICBDYzogUXVpbm4gVHJhbiA8cXV0
cmFuQG1hcnZlbGwuY29tPg0KICAgIENjOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4N
CiAgICBDYzogRGFuaWVsIFdhZ25lciA8ZHdhZ25lckBzdXNlLmRlPg0KICAgIENjOiBSb21hbiBC
b2xzaGFrb3YgPHIuYm9sc2hha292QHlhZHJvLmNvbT4NCiAgICBTaWduZWQtb2ZmLWJ5OiBCYXJ0
IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCiAgICAtLS0NCiAgICAgZHJpdmVycy9z
Y3NpL3FsYTJ4eHgvcWxhX21ieC5jIHwgNSArKy0tLQ0KICAgICBkcml2ZXJzL3Njc2kvcWxhMnh4
eC9xbGFfbXIuYyAgfCA1ICsrLS0tDQogICAgIDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25z
KCspLCA2IGRlbGV0aW9ucygtKQ0KICAgIA0KICAgIGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kv
cWxhMnh4eC9xbGFfbWJ4LmMgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbWJ4LmMNCiAgICBp
bmRleCBiN2MxMTA4YzQ4ZTIuLjkzNWFmNzdlNTE5ZiAxMDA2NDQNCiAgICAtLS0gYS9kcml2ZXJz
L3Njc2kvcWxhMnh4eC9xbGFfbWJ4LmMNCiAgICArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9x
bGFfbWJ4LmMNCiAgICBAQCAtMTE3LDEwICsxMTcsOSBAQCBxbGEyeDAwX21haWxib3hfY29tbWFu
ZChzY3NpX3FsYV9ob3N0X3QgKnZoYSwgbWJ4X2NtZF90ICptY3ApDQogICAgIA0KICAgICAJcWxf
ZGJnKHFsX2RiZ19tYngsIHZoYSwgMHgxMDAwLCAiRW50ZXJlZCAlcy5cbiIsIF9fZnVuY19fKTsN
CiAgICAgDQogICAgLQlpZiAoaGEtPnBkZXYtPmVycm9yX3N0YXRlID4gcGNpX2NoYW5uZWxfaW9f
ZnJvemVuKSB7DQogICAgKwlpZiAoaGEtPnBkZXYtPmVycm9yX3N0YXRlID09IHBjaV9jaGFubmVs
X2lvX3Blcm1fZmFpbHVyZSkgew0KICAgICAJCXFsX2xvZyhxbF9sb2dfd2FybiwgdmhhLCAweDEw
MDEsDQogICAgLQkJICAgICJlcnJvcl9zdGF0ZSBpcyBncmVhdGVyIHRoYW4gcGNpX2NoYW5uZWxf
aW9fZnJvemVuLCAiDQogICAgLQkJICAgICJleGl0aW5nLlxuIik7DQogICAgKwkJICAgICJQQ0kg
Y2hhbm5lbCBmYWlsZWQgcGVybWFuZW50bHksIGV4aXRpbmcuXG4iKTsNCiAgICAgCQlyZXR1cm4g
UUxBX0ZVTkNUSU9OX1RJTUVPVVQ7DQogICAgIAl9DQogICAgIA0KICAgIGRpZmYgLS1naXQgYS9k
cml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfbXIuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9t
ci5jDQogICAgaW5kZXggNjA1YjU5Yzc2YzkwLi41ZjdlZmRiMGNjZTcgMTAwNjQ0DQogICAgLS0t
IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX21yLmMNCiAgICArKysgYi9kcml2ZXJzL3Njc2kv
cWxhMnh4eC9xbGFfbXIuYw0KICAgIEBAIC01MywxMCArNTMsOSBAQCBxbGFmeDAwX21haWxib3hf
Y29tbWFuZChzY3NpX3FsYV9ob3N0X3QgKnZoYSwgc3RydWN0IG1ieF9jbWRfMzIgKm1jcCkNCiAg
ICAgCXN0cnVjdCBxbGFfaHdfZGF0YSAqaGEgPSB2aGEtPmh3Ow0KICAgICAJc2NzaV9xbGFfaG9z
dF90ICpiYXNlX3ZoYSA9IHBjaV9nZXRfZHJ2ZGF0YShoYS0+cGRldik7DQogICAgIA0KICAgIC0J
aWYgKGhhLT5wZGV2LT5lcnJvcl9zdGF0ZSA+IHBjaV9jaGFubmVsX2lvX2Zyb3plbikgew0KICAg
ICsJaWYgKGhhLT5wZGV2LT5lcnJvcl9zdGF0ZSA9PSBwY2lfY2hhbm5lbF9pb19wZXJtX2ZhaWx1
cmUpIHsNCiAgICAgCQlxbF9sb2cocWxfbG9nX3dhcm4sIHZoYSwgMHgxMTVjLA0KICAgIC0JCSAg
ICAiZXJyb3Jfc3RhdGUgaXMgZ3JlYXRlciB0aGFuIHBjaV9jaGFubmVsX2lvX2Zyb3plbiwgIg0K
ICAgIC0JCSAgICAiZXhpdGluZy5cbiIpOw0KICAgICsJCSAgICAiUENJIGNoYW5uZWwgZmFpbGVk
IHBlcm1hbmVudGx5LCBleGl0aW5nLlxuIik7DQogICAgIAkJcmV0dXJuIFFMQV9GVU5DVElPTl9U
SU1FT1VUOw0KICAgICAJfQ0KICAgICANCkxvb2tzIEdvb2QuIA0KDQpBY2tlZC1ieTogSGltYW5z
aHUgTWFkaGFuaSA8aG1hZGhhbmlAbWFydmVsbC5jb20+DQoNCg0K
