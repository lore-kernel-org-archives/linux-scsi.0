Return-Path: <SRS0=lUfO=A6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FBBC433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 06:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D83C420738
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 06:35:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SoHRt2N+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="neDaFSP1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgGSGf2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 02:35:28 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:16654 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgGSGf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2020 02:35:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595140528; x=1626676528;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AjNKQYlEp1tavXKJhua036o6KiikJsnoUH+wGG83eBc=;
  b=SoHRt2N+I1qWz2XghaUSMLT7Q+tuiXmUlBuUifbXLpyt9VN14ZhAvPUn
   HcGZujxm8dJUQ6HEUprrziI6pmjGGrKZ/WUJzqP9shex6sbQ7YSONbpPG
   2jNMrOUeW6JOqfWzaBbzk3mKgwx+KBgmDnXaI7CYv6KPORlpOb9MQjN0X
   Xn1UxepUSBOi2jet2eUhJiB2yHe7w+9fW+hhWK1damv+soq2AgvMKVAdl
   Y0V3x9Le8Rv4p7xTTlfR3CLvOGTLsiCmfXSfDJ0C6Yp3Hwv51LI/ybVdQ
   Kh/LKcwj0bmjw6zIlY4ZZg++DVwAQmYrRNFNJboDJNBPtAR4TPYId39p9
   w==;
IronPort-SDR: GwcBF0tETMETRIbnpUWYH1sqXNE7hjqY7aNxfb+sHT5ZAP1csYw/qXUedu0KUa1AYL/5Cn1Qdm
 hgzVW8DTPsO2tFXZlimIBbGUdN6Xw1AC4mVUlpsOSg9akGPwxzNw/pQNaIaiK6qJo6Nua1m8eV
 R/FiTzvO747dYcOOys2gdWy6J9Tk0zN1KjBafdCpTUb9EvGbRdh0RJDo66bteum41E/k+4IUZw
 kXXRWdNEMCPS/oxOqtg/N39vi579Nvhp4Hz4Ech5bUJGbqfpjlgln67L5CIpk5YqZz+amZQeIe
 XBs=
X-IronPort-AV: E=Sophos;i="5.75,370,1589212800"; 
   d="scan'208";a="147136639"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2020 14:35:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVwSn1DNhAof1ah4Zbklbwt6u/naCydWdGKvZhxxGiknNwKvOC2cDX1oO1ty19aOHVD3DhRWLBroUY0yuH3BXZ2eiWv2KNjHOiXmlJv1QlZHc2jGfLKQqRPcnbhsZgVvm8osWck/Gvh9Uk7Bl0Sy1xBLYxCDtokVMjdNN6Yg4lESZra6x64LTJR3kmACKcL9c6pI4F0F9kLRKPgpkGw8oLpyLTfH0vFSrkaoGybhr1VCGC4f7laDdg6KuIT4AJADsZWeaCegqLzArH9qVOjf5dySxgYv0lJ+LaZNcDDEbQ1jlijubRtuX3oev8Gdk5Wm8UjYq510VMq9763w57jQIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjNKQYlEp1tavXKJhua036o6KiikJsnoUH+wGG83eBc=;
 b=kgtpG0+ztOtO5suizfVf9rhiHPXZo0+utK2sznHaiI6o9fJ+lVWqQHrkBuZCm51iADlOjuCTiYFDtvqLrAg0MN3736dYzT4U8DrutYP9WH5boELc6GOmYuf6Hs/PfREP5bBAFWReGXTRAjPpZtA/kdxm2rffsExAYuUcHSYPfhnbpygxFUT8B/1TSG4Mr9C7mjDNatuDkG4KkUjM/V/aRCrTADq/9biLVCa00OTt7FmfgsbGIdqpFB2FtUT1XuWoVgYPZuuq7Esx31SnjNjDsWwNyaWiTsA4Ib92e+xKMax0mlgQhwgRdXDLFKJKlnCcSh9nTzSWMed80MZFtwQFFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjNKQYlEp1tavXKJhua036o6KiikJsnoUH+wGG83eBc=;
 b=neDaFSP1pBGoDfaZX3xdD3PZDWbnhDSkbUpQazjOaXlz2WTV88cCpkWJzTVSuORg42gmD2tPdszR2DAlB/yb5xpYgOy+V1qTBePls1e+94svyLF0znRJgz3SG7qXTi/n2NbSKnGs/dHbfV3CO34XBnyZ73MscXmnTFk781B+U18=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5360.namprd04.prod.outlook.com (2603:10b6:805:100::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Sun, 19 Jul
 2020 06:35:23 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3195.023; Sun, 19 Jul 2020
 06:35:23 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        'Sang-yoon Oh' <sangyoon.oh@samsung.com>,
        'Sung-Jun Park' <sungjun07.park@samsung.com>,
        'yongmyung lee' <ymhungry.lee@samsung.com>,
        'Jinyoung CHOI' <j-young.choi@samsung.com>,
        'Adel Choi' <adel.choi@samsung.com>,
        'BoRam Shin' <boram.shin@samsung.com>
Subject: RE: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Topic: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Thread-Index: AQHWWQGynHMGu/0fRkiVvG9Dpk1z6KkJaD4AgAHaWnCAAzipQA==
Date:   Sun, 19 Jul 2020 06:35:23 +0000
Message-ID: <SN6PR04MB4640A85E665E20D709885E16FC7A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
        <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
 <077301d65b0d$24d79920$6e86cb60$@samsung.com>
 <SN6PR04MB4640A5A8C71A51DB45968DAFFC7C0@SN6PR04MB4640.namprd04.prod.outlook.com>
In-Reply-To: <SN6PR04MB4640A5A8C71A51DB45968DAFFC7C0@SN6PR04MB4640.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 37a52ee9-e8b9-47b2-ef21-08d82badea46
x-ms-traffictypediagnostic: SN6PR04MB5360:
x-microsoft-antispam-prvs: <SN6PR04MB53607767CB40712212FC866EFC7A0@SN6PR04MB5360.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:569;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h4YEYG/BnoDfPahLjtG+B+OD4+YKud0DraUpnzfI+KittUXnjWhNey5ojQHtB+zH8F7PTIXiurDz/H3CIfjWPxWeVJP3mGkLB41mSaP9XLodeNrAxj8mqtnggKYljL7b3u+7obd7+apLLWO4Oqkzh4TY0QNoRtlTXXNMCb8bIf1/xDSZY9560pqwqUL/i9NuH39irbVzeyGfHqeP28a+/hdFTVoUueHV0OIE/8e8rVhNJhm9uo7VL+POlaSlJphFGMH8xCJluwRHbCc3uk6R+ZQ/6RO5+SxPJsq02ADHAMTYiUoCjFvrUCMmZPpA0r+SkH9VwoaMn/FcT8q+EDr1Rno/4oruEJWFdSIAEjRGrSbj1BCEGQjaOs05PYmz2Z62
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(2906002)(7696005)(8936002)(64756008)(5660300002)(76116006)(186003)(52536014)(66446008)(66946007)(66556008)(66476007)(86362001)(71200400001)(9686003)(4744005)(33656002)(4326008)(54906003)(6506007)(110136005)(8676002)(7416002)(26005)(478600001)(83380400001)(316002)(55016002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: aPBWRVFrNiJ0ikXTcuW3SLka6pli9dOG2HZFhzacidYEmVXF+pwqxUSMHzvKbuc8PMVF1RuR/jGdDb1/KXtGiZiUp8MmvFZ3d/BsPrkkwNSQ/V3UnetocHgCltWomhWte7d4QSNnAju9caFePCfiTZiFbZdpKMhTeF6nG+2yTMAwUXWP54UFCaMTomC0dPn4KwWcrpi8YGNeHcxKAgMwLl9yD+/BuK0DEthiImLbqVx2WH49NFyWHFtTJOM7Ud9UouIw2nJ60U7DFP2OvMVCb+EmXo/I7tZc3ZEKiXc40r+RD6M5NjqKbhA0GQKWO9JPGsgo+ABIcn9PT0T7GHuPeZeS8zZsZZLz8wzF0grZE3qQMC1IEjL1yqDwyZbGMFEBgcLbGC5kQ7TK5i0qNIiFM/nvrzL+KCITWG0Tpj24JVPW2eE75cnwJh1QRHKvJseBVs6KsetlPg+EJJLdm4O7IRTQL3q8ihylaxiuq+ZL9/4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a52ee9-e8b9-47b2-ef21-08d82badea46
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2020 06:35:23.1249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IeqW3FOySViuRyhdg2QcZdLMOa0CHDWZn8qH1dS8Ptoq7hJOeeuP7EFtDFk8k6BqVFJuiYPhfncdKCZVE8PJIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5360
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TWFydGluIC0gQ2FuIHdlIG1vdmUgZm9yd2FyZCB3aXRoIHRoaXMgb25lPw0KDQpUaGFua3MsDQpB
dnJpDQoNCj4gDQo+ID4gPiB2NSAtPiB2Ng0KPiA+ID4gQ2hhbmdlIGJhc2UgY29tbWl0IHRvIGI1
MzI5M2ZhNjYyZTI4YWUwY2RkNDA4MjhkYzY0MWMwOWYxMzM0MDUNCj4gPiA+DQo+ID4gSWYgbm8g
ZnVydGhlciBjb21tZW50cywgY2FuIHRoaXMgc2VyaWVzIGhhdmUgeW91ciBSZXZpZXdlZC1ieSBv
ciBBY2tlZC1ieQ0KPiA+IHRhZywgc28gdGhhdCB0aGlzIGNhbiBiZSB0YWtlbiBmb3IgNS45Pw0K
PiA+IFRoYW5rcyENCj4gSGV5LCB5ZXMuICBTbyBzb3JyeSBmb3IgdGhpcyBkZWxheSwgSSB3YXMg
YXdheSBmb3IgZmV3IGRheXMuDQo+IFllcyAtIFRoaXMgc2VyaWVzIGxvb2tzIGdvb2QgdG8gbWUu
DQo+IA0KPiBUaGFua3MsDQo+IEF2cmkNCj4gDQo+ID4NCj4gPiA+IHY0IC0+IHY1DQo+ID4gPiBE
ZWxldGUgdW51c2VkIG1hY3JvIGRlZmluZS4NCj4gPg0KDQo=
