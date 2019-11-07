Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2570CC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 21:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F23D021D7E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 21:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfKGVHk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 16:07:40 -0500
Received: from m9a0002g.houston.softwaregrp.com ([15.124.64.67]:48758 "EHLO
        m9a0002g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbfKGVHk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 16:07:40 -0500
Received: FROM m9a0002g.houston.softwaregrp.com (15.121.0.190) BY m9a0002g.houston.softwaregrp.com WITH ESMTP;
 Thu,  7 Nov 2019 21:07:00 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 7 Nov 2019 21:04:59 +0000
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (15.124.8.11) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 7 Nov 2019 21:04:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlqFiJRxRCtuxt/+o0YflkqDfbqvNm9x1V3pzbKlbRoOsXyp7Fe87zxcrSzLf+BjZNZQqhjVdMDFcJykLyAnsfTrlwc1OWuDczepHHXmhotDq69pNNrL+4Br12Ykc22HcNOTOHjBPtyR5iyUBxlQjRsdtqkjDD+KFxaGlDkkGblZLB8ckqMgj9pstdYD3AxPTH31O/NLLWpcgmvgQw8eJ0X8bxVfRhpTnPePI2APGPqE9ebQmbtEmVpQkElTVxqo294wrqtXEMR3dhvv9WJqaoGTdwJEceM6JwiGgzVPt13WEX9/O/7bJOFkaVV1v5gClcSkgKjEEpAigzKqf3QGug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGuou6Zmsq19aCTRhPpwZz2R+COVvvzZSGazzfZ/Dec=;
 b=csEsT0I5K8073RpCnv4iu9V7/QQPoy4my3QtbDOG+er7DlVP9uB/3BzKFcWw+dpGhaIprD9OeO+Jskd1De5LR9w6/pFNJIu4jwA8/83glnN1XokqcI7S9QJjkumonR0tQsiMDCB0p0R+7sGuWIcJXHXT3V1765Fwijkd3djdQVgRFVHP/9h+V9eXp0KsP2IRLJfUjmHR3XCHA5ep0ax9glx534Xij4MMt9PYIclwGU0qVMWgfd7DRHnkhxKEOoIbVN92zm1QXNrHX+4F3OcVHRv0p8wQZMv+CZ2Locdw72e/1AE5QRCE7399NrMQk6RpqpsaFT43H3l9ob6wq3U3vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB1402.namprd18.prod.outlook.com (10.173.212.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Thu, 7 Nov 2019 21:04:59 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::d1db:c70a:b831:8150%5]) with mapi id 15.20.2408.024; Thu, 7 Nov 2019
 21:04:59 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        David Bond <DBond@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "mhernandez@marvell.com" <mhernandez@marvell.com>
CC:     "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: qla2xxx: initialize fc4_type_priority
Thread-Topic: [PATCH 1/2] scsi: qla2xxx: initialize fc4_type_priority
Thread-Index: AQHVlYtKGAtbuPovK0S3qRD6fzlmP6eAMxMA
Date:   Thu, 7 Nov 2019 21:04:58 +0000
Message-ID: <bdc94dafc5dc9c9c15cb42c5380e6c37e78f20fd.camel@suse.com>
References: <20191107164848.31837-1-martin.wilck@suse.com>
In-Reply-To: <20191107164848.31837-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-originating-ip: [2.206.153.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 983d4d02-df3c-4801-2d1c-08d763c62620
x-ms-traffictypediagnostic: DM5PR18MB1402:|DM5PR18MB1402:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB140271F03FF4240B80F3C881FC780@DM5PR18MB1402.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(199004)(189003)(66066001)(26005)(81166006)(6486002)(2906002)(76176011)(99286004)(71190400001)(102836004)(478600001)(6436002)(2501003)(6246003)(118296001)(71200400001)(229853002)(54906003)(110136005)(14454004)(86362001)(6512007)(66556008)(5660300002)(3846002)(7736002)(8676002)(305945005)(316002)(486006)(6506007)(4744005)(91956017)(25786009)(6116002)(81156014)(446003)(8936002)(66446008)(1691005)(76116006)(66946007)(256004)(66476007)(11346002)(64756008)(476003)(186003)(4326008)(36756003)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB1402;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XbdEpshdTTFancxiNA/nCzRant6bqBtoAljsPxCJmhSiC6sYp4ka7EIVFruC/7ZrCgzTkC9ru1nDFozUd9kVFYtdIFX9tJep7XOiykJX1rNdrMxWrJtxu0cd2x+rF0kjK8xrzsiIj7Awn4/5uEHagZ1MioJ//Q1qHeUMnerDZjk/jvpqnSvph5wdusrfqI6SyDrDi31zuwxIh7DlHtHnJoktOvxW8mjuVuwRFMo2ZJAXd963mG4em90/dZCguPc2RyLA+12Ry8CQiXxkZYjzT7AwAbP694sjCqG1rYI9UluAJOOieNQQWvtXYpIQ6zGeoexyGS0u5aItnaZazGDtF3eP8safMoUP9K7I/BzwFQWXbqX+Nak7GQAbHpUynwi3FXMGrniiMI981l4lRE8C6Lz765S4tVWZ38XsxfcfkFYIpjDGD4VvCPFNd8dwn0Hx
Content-Type: text/plain; charset="utf-8"
Content-ID: <10CD57CCBCE5CE4DA21E0F67BF4F9C79@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 983d4d02-df3c-4801-2d1c-08d763c62620
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 21:04:59.0062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZfDEWMBJ5G0iemm2mJQE/fjm2bKwf7ovEtOixzqQ83TOeS5faYpb+vGB/AFq1XVNiIX59+t8vxLUBEq4TT8Kow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1402
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE5LTExLTA3IGF0IDE2OjQ5ICswMDAwLCBNYXJ0aW4gV2lsY2sgd3JvdGU6DQo+
IEZyb206IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPg0KPiANCj4gaGEtPmZjNF90eXBl
X3ByaW9yaXR5IGlzIGN1cnJlbnRseSBpbml0aWFsaXplZCBvbmx5IGluDQo+IHFsYTgxeHhfbnZy
YW1fY29uZmlnKCkuIFRoYXQgbWFrZXMgaXQgZGVmYXVsdCB0byBOVk1lIGZvciBvdGhlcg0KPiBh
ZGFwdGVycy4NCj4gRml4IGl0Lg0KPiANCj4gRml4ZXM6IDg0ZWQzNjJhYzQwYyAoInNjc2k6IHFs
YTJ4eHg6IER1YWwgRkNQLU5WTWUgdGFyZ2V0IHBvcnQNCj4gc3VwcG9ydCIpDQo+IFNpZ25lZC1v
ZmYtYnk6IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMv
c2NzaS9xbGEyeHh4L3FsYV9pbml0LmMgfCAxMiArKysrKysrKysrLS0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCAxMCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpUZXN0ZWQtYnk6IERhdmlk
IEJvbmQgPGRib25kQHN1c2UuY29tPg0KDQo=
