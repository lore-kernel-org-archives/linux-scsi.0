Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C915C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 05:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 376BF20758
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 05:27:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="T5tBiOmJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="dbQwx8r4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgGGF10 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 01:27:26 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:59056 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgGGF1Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 01:27:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594099645; x=1625635645;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cexNgB508HnqFDo1p9Rht+qDkutJNA+hLl2s9F2t7cc=;
  b=T5tBiOmJoNHmaffT3T5R1VG+/GfoCU6RrDX07pYFV4iEb2dRRLy8bGW3
   aMPdHtmOh2KTIZ2CYoixVG4wAfknstwFueZQ9h2ItU70HG09gvAbpDC9G
   7QRWZ/JtW/tos3hhRPXgBORXJN8Vcyaukev6E5ItEySGJJ3R/yE0wuGek
   fVTQeh4eDAVSjAgx3L5exYuH9xyXEsi4K55yjdk0FX3ARZcxVIVQdHKQL
   h8EAox8iGhNyZVAE1s+/WNhPD0EtNzlZCv2bNGdQTu6YWHY6KJJC5Ztmy
   0wqKNK3UI4FNM25OirV3ZWhLXJ8feFPWqBhC5ny9ooVuDf3nOKQjfCyVA
   Q==;
IronPort-SDR: JypQ7q9KogBXS9CfSDberICnbZU41bx8Kr8XkeIo851FYRV2fqiw2UESG09fwgmZwDhK2tz83L
 EGK5MWoezTeXH/HQ3yxeGKrov68FvxXpjxiGr+8SobjwZg9Fq/33H1QKrgPc9auvdIIlzM67T3
 NbyUSjLUzKFPVFDMUVgjuKkf7SLFXqGeRDymTkb2VQAOiq/ykDtHVNz2bmRHHubiQrkEyp6IEP
 3+pw9PTBylF1Q6kt6tQUvyq6KuGka7HGe/Z8mJ0ndq7JYpAdQ1io3FDiSuwXWTmGSXYw4uGqgt
 zF4=
X-IronPort-AV: E=Sophos;i="5.75,321,1589212800"; 
   d="scan'208";a="146109445"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2020 13:27:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEJvSFNzu2w05j5ji1M2xVG/DMYYhPKOs91smuDMFrz/xYRIStjHfjSh2TQI3oOA/pSS6u6ZVzichN4LUHfAN2J3glnsNU7XUOqWcYeGiV6SH71eF37Z29YbEPYFDePzuEUJJd/4c5U1khyhzGTynGx4d5lj53pYnSslMO1/GcbUdXVYeKYKdvTQdcvQpTPM5vRMivXZ66rEJLqzjY4w59d+0uaiVZaR6vO1I4cj0oJmYa4fibPMbcOLeeWn+zgqsZUc2P8Rqhpv2hufUyynsbOnNypchQfSkDTjOcyu5ZPh4buSmZwUWejYndt8uIrc1XB8wNZSKezJapc3Lfan6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cexNgB508HnqFDo1p9Rht+qDkutJNA+hLl2s9F2t7cc=;
 b=FgGcUju6RC5NDNyaB1LM0QW5JtEYysbNfPHrDEsdfc7laBEWiYhaPvdXD4yEPKtloVA2wO67n/D/XvCYBj7XVKRh0OdPJkdqAdHK9ZyLcNooiRgTGIf80sqEaW/n4Xw+U/bIRpbEgiGFnJMjWpH6rwN7MBrHDC/xPTqtl/oUb1BMBaPgb3V+BpDlTDJqsIIVgItun/5cA5y/V74N27TUcUMvCHtqMjcG4QyMN7Pc8pFqioidpfKpf9qeA9rWNcLfsbczrRrU4utNP560L4kT7fI/Jd5CIZond62yVJ5W0gfsD1cEWCLYBVWgIovc1Te5RRoKiOii0657scrlzF1QXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cexNgB508HnqFDo1p9Rht+qDkutJNA+hLl2s9F2t7cc=;
 b=dbQwx8r4Ht5knbZea27JL+HRaLBHRv2wmYT+Ag/w06qaknnRcIoMD5Z2fc85SjksLv0ISi1AgDoq9lFvlDBDX/bquyBsS0aGESSouNSR2zjkwuuXN6KMd3Nx/6gjZM+t3NK24M39CA9iGQFnNO1zvxwqfxhE6pPjR7gkOmOCR3U=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN4PR0401MB3549.namprd04.prod.outlook.com (2603:10b6:803:4e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Tue, 7 Jul
 2020 05:27:21 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 05:27:21 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 2/2] scsi: ufs: change ufshcd_comp_devman_upiu() to
 ufshcd_compose_devman_upiu()
Thread-Topic: [PATCH v1 2/2] scsi: ufs: change ufshcd_comp_devman_upiu() to
 ufshcd_compose_devman_upiu()
Thread-Index: AQHWU3aMirCU5JvHpkWOz4q3eXibr6j7l2JQ
Date:   Tue, 7 Jul 2020 05:27:21 +0000
Message-ID: <SN6PR04MB4640D2E6528014A82C1B3635FC660@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200706091905.12885-1-huobean@gmail.com>
 <20200706091905.12885-3-huobean@gmail.com>
In-Reply-To: <20200706091905.12885-3-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d7005479-7679-41f5-c899-08d822366c98
x-ms-traffictypediagnostic: SN4PR0401MB3549:
x-microsoft-antispam-prvs: <SN4PR0401MB3549DC7178CE2C683AAB9FA7FC660@SN4PR0401MB3549.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:513;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +UW1ixrUs5JetftvHZWQF4ESej6VVYaH++xbCMqPP8Iw83JQzEM92i0iBg0osx8auDD1vSARjNZZ/i5fcLholcPXZZ7naXoNFd09CtBofWouwgqFZ3til3A48EDPAYKXhI1jUZGNZKkdFSEOzE93ncdWpPv1Os3uX71bueAZ5gkG1jj/HkwffRn8T4tb5sHZboWoMz9tvJOnaAp4xyHI/MTvLPZzuQ0iB8Z5DxWspkvTyoaOkJfNwfnQtXb0U2bDPrrSW8y9FknCnNC7MegnKNRr8nB9L3VtroxO0Ip+uQrTh5fo7l+kNTv1ZwnSpiryUcGmneVv4qOWelYwCo43sY/Hf9isb9pUNjycAP6WBNJvtXqbmQloTFRnlXCNL8yg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(86362001)(558084003)(7696005)(2906002)(33656002)(71200400001)(316002)(110136005)(54906003)(64756008)(55016002)(9686003)(478600001)(5660300002)(66556008)(83380400001)(66476007)(76116006)(66446008)(66946007)(52536014)(8676002)(186003)(7416002)(26005)(4326008)(6506007)(8936002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 0E44lD5CAvTGJCliggjq/8m69dhbxca83JFdiNWokT4K9FW7FUU6roRF33MC77TDNqzHDXcBKDwiuT300DD2ei/BtdxWji3O77EsAj+w+kDf6XXN4X1V1F0jOQp6Tmqq2RPlPh8GxUJ1ncHpB0y6tqIfeumd+J4jFTOkCeppmgpC5+sOvisQG7GofEQMMV925jb6YgVrxcMQPxhpRAh/vScUlhaE+30n8VwjrK/cw3J/JR/MeA0Jpsv33i8iiuKjPZ+5hDevNlcoUROr9jT9/brRD6BtyQlto/xVTMQoZpJzEGCwqv2fOFG6kDe74TL+biWs5bsWguVeGlFTefo7FLlTzew4cxWZarYcryhgWH3cC+1V8l9Htgh014H3jhlPQ0XWsywsR4q42XYG74mMLRandxP8muLa/flcsQQwy+7OEiC/a+V66MSP2UpZu6iR3TlZMPleEKws69WdVaOXGpYY43Lj4iR54DrG+D8Otqc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7005479-7679-41f5-c899-08d822366c98
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 05:27:21.6686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S+5Zh6im+JmvtwKjov48DjoU6xuJrKQI3DukfdTkyPf57v9jLPmjEcP2c95pG9YzUt0rKctMdLt74D3XmlWDOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3549
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> ufshcd_comp_devman_upiu() alwasy make me confuse that it is a request
> completion calling function. Change it to ufshcd_compose_devman_upiu().
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
