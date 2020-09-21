Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EDAC35257
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 21:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E64423A61
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 21:42:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="SGicCG7g";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="ZRy9BuHb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgIUVmj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 17:42:39 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:52874 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgIUVmj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 17:42:39 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 17:42:39 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1600724559; x=1632260559;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uOLsKD2nRhFVfWe1G85hdAEE9Fqbg4Mcxgy5YH0dffQ=;
  b=SGicCG7gUa7ZEXvTvaagQtCCfzGw+YiGD6p4vxWZF7fGUVgjjf437geb
   po6yNz6KWGXdYwjViMEd7GWu7qMMDXorn/YetfxgWuTDBQ5tlC5bmmsqG
   JgwmDs6UTLc52j8WIYWnSyelfM09Kuy60WKrYZ6JKy0wD1nW6ZyLabC3D
   hWO03luiCXh/n0jHxXeGWEfLWojf0Qm+nFCCFjSXdyN2WhVnqc2/mZ6wM
   ANijLbzkHZUVp7XkjiPqDvwo94SQFE8nIKTgI/K8YwpdVH9ZfIcpV+KYy
   wwmEsupkM3/D7EO7aTwp9VGkv88fVt+OoRiUDFIF73tINQkuZOZ1HCFUK
   g==;
IronPort-SDR: pHBAu1czQ6gzFpajtz365wJ0tPP6sWP3NtJ4nOr/cWhFAHGhS8OErcsFsHI6Z5n6uUovlbEYaD
 JvXls95lWvo9RvDPu/4didwPEwssFmEinF+6WsEeZoFiT3roUIHnlY5wdvObUqFY9ZCqxccU7b
 lLSlmI/mGTPFUNM673yKzrjR7wmG0T4GX8d7Hl8VTeCIbZo3BaO+owlwZIdjZJqppjaRZscTjh
 kFpS4ACpdfOeETkOA5h9ZmNKMHRo66I3P45YNLq4SVTdfAfH1OTu/YKrOB+NP5Fvkqj41maVVO
 ivU=
X-IronPort-AV: E=Sophos;i="5.77,288,1596524400"; 
   d="scan'208";a="27175289"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Sep 2020 14:35:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 21 Sep 2020 14:35:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 21 Sep 2020 14:35:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dy0laXQET2cZf4xvbUMViGCkLvUbJ6Rq1jvGe83X36zIWRbyZMy2LS0juZn7EoKdclaL67NfwSU+5b3NvRVB5G65r4O5FBXghoVvxGBLkhkAWS0XGLYnylqHwQX08bn9Qpo1GNqW4VCHdDcJ9LQr//E3iWLqUGzMMqIHWWBKNfKJx+kB2faV3fL7W7ZjN9LGEn6/Lt4WcLCm2oIaZQe2wvMeUGDGQSF/38aK9j3lIXVM2I0NvOISUwF79BBklcbm9SiSpPbFTNRBZQmzqocO3rJaWxnfOuOeTDqLmPmfuiqu6ntaFArNTSatnYzh33Nh5Ts12LQwPZpgigedKJ07Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOLsKD2nRhFVfWe1G85hdAEE9Fqbg4Mcxgy5YH0dffQ=;
 b=SeqIJNv/MnV5cNWNE2cBa+v4iGpYINrpUjM6IF+/0mO9y4mfkiMvkjTRDTR/seLVyi4RNmsi4LODXqutBWQZbwz23bdkGYlsI44HIwYtr89EMwDIiDCJBqbSnWtRPoSOlyVHRy9t6tN0jzFMsbAn9bbBeOnq+4VPs2siO/eJvi/UCrYpou1B5xBOHw1kP+jQvgD3s9vHVQIh8rGQtCe1u/KezQL5HSKM8pZGGiOKrPn6GvLCsoao34BFjgQl4smpY/5frgaoS7Kp+ErRMH2mIMO42cjb1+G7uud9Da4OgkxNy4yuruy3VfGlVie7v3g/IKiUdfsQM9qGsmGaEBjglg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOLsKD2nRhFVfWe1G85hdAEE9Fqbg4Mcxgy5YH0dffQ=;
 b=ZRy9BuHbSKcexqqva3iRL9BCc2YHjNWO/SStK7OBbTWRGkoqAjfzk0GjEhu4+Sf+aHYzV0wRMF63RHGOG5h55HDWpl1GvKLj6kM8xEenDjV3F2NhTOQ5JtFNejaUGS58OjNM+msrrNycuDZacZceLfMOrpeJY9bx9Nrujz4+aRk=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2702.namprd11.prod.outlook.com (2603:10b6:805:60::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.17; Mon, 21 Sep
 2020 21:35:30 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::cc4c:c230:c557:d721]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::cc4c:c230:c557:d721%7]) with mapi id 15.20.3391.024; Mon, 21 Sep 2020
 21:35:30 +0000
From:   <Don.Brace@microchip.com>
To:     <john.garry@huawei.com>, <martin.petersen@oracle.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <dgilbert@interlog.com>,
        <paolo.valente@linaro.org>, <hare@suse.de>, <hch@lst.de>,
        <sumit.saxena@broadcom.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>
Subject: RE: [PATCH v8 00/18] blk-mq/scsi: Provide hostwide shared tags for
 SCSI HBAs
Thread-Topic: [PATCH v8 00/18] blk-mq/scsi: Provide hostwide shared tags for
 SCSI HBAs
Thread-Index: AQHWdjz+6UL/WK9o/kG683JLD8mSYKlXhIGAgADFMoCAADyOL4ASgT2AgAErQiyAAF3DgIAHQKsQ
Date:   Mon, 21 Sep 2020 21:35:29 +0000
Message-ID: <SN6PR11MB2848BF85607B18D23EC40B9BE13A0@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
 <df6a3bd3-a89e-5f2f-ece1-a12ada02b521@kernel.dk>
 <379ef8a4-5042-926a-b8a0-2d0a684a0e01@huawei.com>
 <yq1363xbtk7.fsf@ca-mkp.ca.oracle.com>
 <32def143-911f-e497-662e-a2a41572fe4f@huawei.com>
 <yq1imcdw6ni.fsf@ca-mkp.ca.oracle.com>
 <7e90cb73-632c-ad37-699f-cb40044029ee@huawei.com>
In-Reply-To: <7e90cb73-632c-ad37-699f-cb40044029ee@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d6c8204-9e82-4d07-a35a-08d85e764345
x-ms-traffictypediagnostic: SN6PR11MB2702:
x-microsoft-antispam-prvs: <SN6PR11MB270216F767D137ECF0455DBCE13A0@SN6PR11MB2702.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mQ7pTN2EcKNrF85HFZ3hHAyJnQ+c3SZDBvw/4iiHVcLBi5ZJVeqp2L/6IdY/ylEIpdLhf3hYh8bgD9GROtwgXk+2hPWgjSDbVKbSmDXL3mhv3yOEXLobcNRIxrEZbzWsLKozbaMgHC2nPZBPKNEZ2KPeGPxxCg3aDtiyWcifdw302eE0aiIj8SGY8pjDdCiuCuerPOU1YopUVtCWoLObX1KAbKJE/8t0mskmA0ZWKtpIOg6pnRvoGob8p0E2zURH8i/HO2iu3IvWQ9lQwNr3qBJ0VDkBpLqJRQFGBz6EKM8GBtFwFYUJiYMqJSF+06w+ZmdePN+de5KdEmOY1yEPOIdu3wGPylvgNZa5g6YJ9DL4yi63z4xNXRwj+wW0Qy1l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(39860400002)(376002)(136003)(54906003)(33656002)(478600001)(2906002)(83380400001)(86362001)(4326008)(7416002)(8936002)(52536014)(4744005)(9686003)(186003)(76116006)(8676002)(110136005)(66446008)(66946007)(66476007)(66556008)(64756008)(5660300002)(71200400001)(26005)(55016002)(7696005)(6506007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: aqXwSojI+m1Hds+N1zc5T0CjPZW1PPZGf9FCA2i+hSG0YNvklus0NlJmkVRyGWv+htoLv1Vb+VWA/wecp24Lbc31zqjRN0hsbvRxFCsLbOpAH/S20uKQ7nbQFzJcgwcmCkHAnn0tF70yBlT6AvB7C73Nugn3qoHbl9EcL/HOtkzo0n3UXRjwXsqfViGQNSFMZMkhX3h7gGgetUlBn3Ian5/kFawyOkSq47n1HEvKe8lDYSCHoo38hMl3ECMeDBuPdiJYeeYpiNOmWjoJ+lduVGTrJHxEkPSuR6udt0CGCVD4LIkGPgJB5zpFFukqfF0NQh/Ci7U0+uDkYHrOF4VPnErXjsYZDz7S2ewjfFG6bOZkMnkMhclczslGoljsNxnHLCYoFWBCTfLuP3wc0J+8WxZGlb0io0H3JCbPZJkScsZ7hPpVW7G4TIGpb3e5m5kU+YJRQR0wrn0gEUruAfg+WjWqMC03pD6cM+Q+RoJrH+3dlBFSClhGcyRQhH7Ex8ystqQ5a3aYn8TxUYU5uqh9tp5j636H2fZHbygNkZr2pYxSNaw4BnIlpG0ZdeGZy0c0tJ8uqJJPIx/OQBRwUYvc32c8UMlyY5IRGw58LCAaruxRZFizMF1dpa2Bme9TdUYA4rF9nV94izttEi14cenwow==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d6c8204-9e82-4d07-a35a-08d85e764345
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2020 21:35:29.8435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dywNhzr0LUi+9wiM7lFtbyWqjno6JCvHPuGftbjnRnotTumUU6XNnKVWngSI/egDnUUQYTRZzI5/THg1G5y8nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2702
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U3ViamVjdDogUmU6IFtQQVRDSCB2OCAwMC8xOF0gYmxrLW1xL3Njc2k6IFByb3ZpZGUgaG9zdHdp
ZGUgc2hhcmVkIHRhZ3MgZm9yIFNDU0kgSEJBcw0KDQo+PkhpIEplbnMsDQoNCj4+SSdtIHdhaXRp
bmcgb24gdGhlIGhwc2EgYW5kIHNtYXJ0cHFpIHBhdGNoZXMgPj51cGRhdGUsIHNvIHBsZWFzZSBr
aW5kbHkgbWVyZ2Ugb25seSB0aG9zZSA+PnBhdGNoZXMsIGFib3ZlLg0KDQo+PlRoYW5rcyENCg0K
Sm9obiwgdGhlIGhwc2EgZHJpdmVyIGNyYXNoZXMsIHRoZSAgb3IgbW9yZSBwYXRjaGVzIHRvIGFs
bG93IGludGVybmFsIGNvbW1hbmRzIGZyb20gSGFubmFzIHNlZW0gdG8gYmUgbWlzc2luZy4NCg0K
SSdsbCBsZXQgeW91IGtub3cgZXhhY3RseSB3aGljaCBvbmVzIHNvb24uDQoNClRoYW5rcywNCkRv
bg0K
