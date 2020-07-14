Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEC6C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 18:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 827CC229C6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 18:16:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="wq+M71is";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="cVMsjAKX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728505AbgGNSQr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 14:16:47 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:26979 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgGNSQr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 14:16:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594750606; x=1626286606;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=na+Ibqf+AW6YpDYrcuOlrNWt4lYykIrxxdesauMF5Zc=;
  b=wq+M71isp5CKo3xRcUvbQTYec58VP26wY9x3XuK/1KpDrVpSDAvd6B30
   zYYMOwsLZ0YCqNByZvfa+T2FXrtX6w7FSvTrQEy/Gse1E5HpYxklI56FR
   eFJaJpK+gEflLqcuxQkgMpQvbJIcClNKgog6qPWFHlwMSZJ9i2zRDcgz0
   TPaIe9EskIRb2ZxrNne5bekV78FPBhNX9pfuwTeVURxMjekO1dVgnrBJM
   UhzuwTn5IS64pl5kQinI3FgAVmAvP9VnG0m0AXWJ3Ruz+Uxb9hmmsK6Vw
   oJVVnu4Kxf8DStl/vj0dJqcnqiMIQevcZyH65qqmpkKK/yfjcU75+VbAt
   w==;
IronPort-SDR: 8+dg8eddM2iRLgeJXQQDUB52iyOR1cItgv2Xhvzhc1V2z+Z51W76T+bsKjmRgsinY2/xT8oNJ6
 TU3pf5b3ux6LKEmKcTtHBNl6j+iToh87xIh1PLyJ0Qb9PxoHs5mS8+xwSgkL2/pQ/zjcty1I6J
 006vDMQmBYD7ENED5mDMH8WawYWxvqSiTTZAtR2J8EQmBLddCFs3lcVuYcbIQk3AxW00jds3ca
 el6JSmd8ttZwhP56dRc/B7+JqEY7+83YDbTi90ue/BesEIKhUlnMmiUi9LYQ0ouAp/bgLDUxCv
 I6Q=
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="81836617"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2020 11:16:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 14 Jul 2020 11:16:45 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Tue, 14 Jul 2020 11:16:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KemL7XzX2ewotMXh9uMgMGEz3svzxHsM5L4nbbSUtfwWvYnlJIYUzV78aT9Ns4ZwrsEm0rbE4/Jy9fFVAtMZ/MJKVPakuza4JQMsZFYWqhAvo4eOz7i4xY7R7j8HVld0I6AJCIbFn/y+rNj4zRhvEjZkhbGIJYNTxIZ5V4u3rXmRDY38E+lY/sM1fjng0/n8tqBDA7azN3SxsfYp9cpyGJI7ZEATIc82WwD38egazYZsVHW8jnD8iCt1ZAwsosHNx5tv6jElkhHzzoVgMEKCdf/p1HMUGxv2s2ktUCm7ZSJGCyTRvEP0ND1k9YpXDIF8XPuTD7D9b+wk69tXFPAu+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=na+Ibqf+AW6YpDYrcuOlrNWt4lYykIrxxdesauMF5Zc=;
 b=Wtjz0q8y2xYivp9Z7iL7J63YGzy30wVHAyQuIle7wNyNixVSkkvWdq3URSEHMmrHQLGFTO8uX3bHTvYHVKtHYQ89CotTV2vcFd1gDclvPJVdGpm6k2Cap+z44Qf48rVtz0Pe5E+DKxRdffwOXG8peCG3bneSVW+7U0nGC6KD3hjnCbL5U8WDbr/W72/qnkasoBqUf5P3TYZThh47k76KaFRh1ExQ/rfcPA4HpReh5CzRr797dbcwwEpQ+Y1aTGVv8DGMeFkajzmc9lHCllA581FV8NSh1EduihIjIzJgTp+6f7g8n175QyftOzleb+b16OX2jJsOHPaLHV2L3uPbiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=na+Ibqf+AW6YpDYrcuOlrNWt4lYykIrxxdesauMF5Zc=;
 b=cVMsjAKX6Do/a8ziq5HRjziY2CiFIYwuQcq+MOeuov6X5Xa5+xSFIbK0WYXSXpJacQHolbhgPXen5H5EWCg2vdde5j+3c7oHYtrwZ0i56yGtA0+74k91ib5pTLdMmPSt0i0GdNHIDFT4Vuxbh1s2aNNqBfF9sMn3NNA7n6bP8q4=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.24; Tue, 14 Jul
 2020 18:16:44 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::14d2:e9a7:be92:6dbb]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::14d2:e9a7:be92:6dbb%7]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 18:16:42 +0000
From:   <Don.Brace@microchip.com>
To:     <john.garry@huawei.com>, <don.brace@microsemi.com>, <hare@suse.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>, <hare@suse.de>
Subject: RE: [PATCH RFC v7 11/12] smartpqi: enable host tagset
Thread-Topic: [PATCH RFC v7 11/12] smartpqi: enable host tagset
Thread-Index: AQHWP01dB/wvCfQYy0iNVvGjZRulPKkHQ2oAgAAEKgCAABwicA==
Date:   Tue, 14 Jul 2020 18:16:42 +0000
Message-ID: <SN6PR11MB28486DB217EFB23F26321236E1610@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-12-git-send-email-john.garry@huawei.com>
 <a8afea5c-97f2-ac84-f4b5-155963bebb2c@huawei.com>
 <786e0b9d-ab42-aaf6-f552-072010892778@huawei.com>
In-Reply-To: <786e0b9d-ab42-aaf6-f552-072010892778@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96863841-c98e-4db0-b980-08d828220fab
x-ms-traffictypediagnostic: SN6PR11MB3184:
x-microsoft-antispam-prvs: <SN6PR11MB3184F2547EA7C5EA84CB55B7E1610@SN6PR11MB3184.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iLI7YXnNKWJTaPPXhdbq0IwT4eZkedOvLN4nfHx0BahGaXexBDy13kNmOf0yb3DN5ewfZbWkXQ3VNwY+KM+ZKXdxqK5OJBDgBZ9AnNe5C2zYoViWswzp+KBUNpWghN4dAiBw9ZufkgrOVS6EwoLs4LKIZRSYfftHtHJMFoAxXlUdBXop4Xvh6ewKiXT7OkaVpqxDQXZwSd33UsbsbwrcG4LNT8/L2352+zKrNkpmAhgr6LsQHFnoOKA6f8cjflRsv4D3JfFvd2Na7poogi4gRCSX5JIiBpnIJ/HTHhdZArAGmmrcMWhR1I8MObfNLRQAAoIt25ITvQ7vHiLCZRm7iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(366004)(376002)(346002)(136003)(396003)(2906002)(55016002)(33656002)(9686003)(186003)(26005)(558084003)(4326008)(66946007)(66476007)(66556008)(52536014)(66446008)(5660300002)(64756008)(71200400001)(86362001)(76116006)(6506007)(54906003)(478600001)(8676002)(110136005)(7696005)(8936002)(316002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wLLSblUiD5l+HCXAG8s7ozUytKiqPdLlmwF0ckm8WrTyDjJ9Z0zdeVAypuaYeze4OsK/wSC/JOm8tl9Xi8/r97aNev7cI7tVQ6mnz1t+ZqeBufej8SdJMBV7eXNH5OO8sWtPf7pOkE8oeDNilxp+WV0aC6ASq8Qx5Cpu1O62Pw/M8R6UQvJItq0vPuo81ulGhBCLAFlDwYSQ/0ENRS6hehcSOjPKCNcAJX/3uaO6rV1TP0E7SCUpg1NUkzq9AWvJR5f0UiAl4OvTu+Ld9GHg9pChDYlgH37Ir02acVwj6JLYyIq68HeRxmCjr6WKuL2xCv7I/zszC4McXBQ7RjdZiJEWifbASFuHJtTQzWWve4aV/qc4vFjUsCkDEfUsqnix62fi1nw1IczB+Fv9tXcHheFRb1kxT1N2wkr7utEl2LOwftJXcRgWexrZywGwT/Ju2akHLj4O5UoKHHt4WF9cul+hmwkxleLpoTQVGttxgcg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96863841-c98e-4db0-b980-08d828220fab
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2020 18:16:42.8337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HKN4FwKUD3Or0R4+JCNe4pp20/ruRUSxhSSfaez2r4nd2r7dfXywMWW3NMbj76koTlkPXlsSSmVxY2MEAAkKsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3184
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U3ViamVjdDogUmU6IFtQQVRDSCBSRkMgdjcgMTEvMTJdIHNtYXJ0cHFpOiBlbmFibGUgaG9zdCB0
YWdzZXQNCg0KDQpCb3RoIHRoZSBkcml2ZXIgYXV0aG9yIGFuZCBteXNlbGYgZG8gbm90IHdhbnQg
dG8gY2hhbmdlIGhvdyBjb21tYW5kcyBhcmUgcHJvY2Vzc2VkIGluIHRoZSBzbWFydHBxaSBkcml2
ZXIuDQoNCk5hay4NCg==
