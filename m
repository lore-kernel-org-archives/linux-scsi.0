Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 749B9C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 11:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B6DF20885
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 11:05:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bE4SRfIj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SmSIJ0kA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgHMLFf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Aug 2020 07:05:35 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:29785 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgHMLFe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2020 07:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1597316733; x=1628852733;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0UxFL9WIAzXagBNqpgVTC03StQS7VzY7lXfivx9Gg8c=;
  b=bE4SRfIjsiS8f8gW0miXArVInYgG8GWXKtT15s9kCRRP87P25gmqR3uT
   iC405/rVf34M4jAIGmsu/Jzl6zjStNATG91W6fxJaRwAyzvoPbINYyIkb
   Jzk4NDW3V9R/V1Fh0sqFSVORebrhbUuSJSUvg5/OKZDEvpfZ39Hz8PdGH
   QOJjm4kjmb54k1kPKs4Eh6lBR5Y+5A7ZXA7AdDZ4m+n9szlD6aXPBa//y
   uRZcdlqHWFiTZyM1gFB1+6cY3twF+TVz0rNpiFTmYmVyapnzIyjQMuOd3
   B6KuncC28sEuCtreYm8oPUAF5z0cBrG5YZmH49GQ/U/zZYA5HBbUJZApi
   A==;
IronPort-SDR: c1HROgVzzNC+jexvljpL83IQv7lU5EFsdbisqt/K+/AXJwY/EkGKuwrpv3dmaXUqtFiH4G6Asu
 yJp2f5P1CQP/IVN84rGHj4xFY6wKQ0aXPGHTU3gG0N+/wlZ/AtKk6/yXeqHmPwulWT3hxK2c60
 oPs+fKxZ8eICofftdQkIDbTczLtbw9S2osaOA0LhCC2QEtL9ecy1PF9BFpDk6MKQjozV1Y+8Ed
 3PQHQuGSXg1qn5VwcVbld7tBcQlhHa7B40AEFQ2p7MbIbVPufUeAuH9ZV+Z2XLChIoFXsjEZhR
 58Y=
X-IronPort-AV: E=Sophos;i="5.76,308,1592841600"; 
   d="scan'208";a="144839911"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
  by ob1.hgst.iphmx.com with ESMTP; 13 Aug 2020 19:05:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7IjWAJceg7jaEtPvae0e7vlZVsodTRWYEdtznB0idQNlvGRGzTVFwhffwBgcwe0erZV73rhybKjNc07sjc1ytApHLbsiszuC1VRB7i3gEdVACcUW4TPdySI1sp1NUETLi6uFFbfLGfsaxrvvizoqKSIiF6nuSjxMn4yEtc8+rMyP6Hnba96xK5As0/BpelJTLPT/UoI8U0b+heVved+hc4i2HetDyddSa6KHT/N31cbKlOOGujCz/g3eKtEDHtopx3kvmCsDjp060kbZ2yqTsLl+DCbCyfUmgq4klNBbpCP1pXaMdED2A+74KqqS8qwZ5ISB+mG4L3O/oKGgt5S0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0UxFL9WIAzXagBNqpgVTC03StQS7VzY7lXfivx9Gg8c=;
 b=ivzyyqRMR/dnDeCGGQUtWJOVpTVytK6YHPWjF49M6qeOVHcptevfItxF5aeq02BeYYjk4kRyNpSvzbEPMXC5xbfG7YryP12sMJVjB7LyP4dRpm+6HmDmOjRgkI5Gs8jpImXqwcIJg4ZwCTDv4pfwZXLcMNrlNZkwfhN5BteURbyZtqnvteklj0g7hXvF3aprIsb621i50nxIoshal7yj/AFlkX86dnH+3qFMzHEdK+phxWBdFyuwVJCoy+nrEEEGvH2xQpbHLCj7UE/xmTuCuSeu3HdL7+VpR83+h4rBGeHn5wgF7gJQA0LVm0aiTyHAWIHWkpszj9zB9SzDqY9OGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0UxFL9WIAzXagBNqpgVTC03StQS7VzY7lXfivx9Gg8c=;
 b=SmSIJ0kAUE9wpZQMGkOqwfoXAubf5Y8FGYi+gOxaVt7aqVAfirsP30li/wdvtLTaiWI2k7d7fvk1kXcIu/+A0wZQhjbyAmkpMW+wQSAmdsPLV5sNwHQ9/EhtrPPGf/R5+DynVMKejf5qWikDnpf/WmyzS/MkS8WpERXe6w6obkA=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4432.namprd04.prod.outlook.com (2603:10b6:805:33::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Thu, 13 Aug
 2020 11:05:30 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68%7]) with mapi id 15.20.3283.016; Thu, 13 Aug 2020
 11:05:30 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <huobean@gmail.com>
CC:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] scsi: ufs: Cleanup completed request without
 interrupt notification
Thread-Topic: [PATCH v2 1/2] scsi: ufs: Cleanup completed request without
 interrupt notification
Thread-Index: AQHWb+p2BNC50+YzfUqItX3ecFcBGKk0bcAAgAF1YJA=
Date:   Thu, 13 Aug 2020 11:05:30 +0000
Message-ID: <SN6PR04MB464021D667643DF688CB712DFC430@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200811141859.27399-1-huobean@gmail.com>
         <20200811141859.27399-2-huobean@gmail.com>
 <1597236472.26065.9.camel@mtkswgap22>
In-Reply-To: <1597236472.26065.9.camel@mtkswgap22>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c77ccb48-4860-4e9a-f441-08d83f78cae9
x-ms-traffictypediagnostic: SN6PR04MB4432:
x-microsoft-antispam-prvs: <SN6PR04MB4432BAA3A7FF711FE1EF637CFC430@SN6PR04MB4432.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZJ3TFEcFL+qHNYnpjFWSt6HQEdRbq4lEiviWC1hnDNmS0AaBbxicmivNwa1KH+203UdNh6SYkY7HkQtOEs8bbc26zojpQZk2x/5F7iV/L40jm1go/Z5JUos0ZVrrmevvt2cRuRR7NT8APMoXn5cV4a6zYEpr15PdTvQ0/W8Pr9IX9FY6gbIXaab6OHX7KJfbpUD52gL3pIzng3Pxf/qv6AfyPEKGKgzRAz8DJOa0LYSeKVj6Ge6q0d9NN8Su7NBzTv5huHEY2RBeUBtJ2MJ0wWFqjzHrA11gXJCUxBJVSuo4QQCxFASZvBVPuNfdL2rs9JcWalv7i8Ug2TbLSs7pig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(9686003)(478600001)(558084003)(4326008)(8936002)(316002)(6506007)(5660300002)(186003)(2906002)(8676002)(66446008)(66556008)(66476007)(52536014)(66946007)(76116006)(7416002)(71200400001)(86362001)(54906003)(7696005)(64756008)(55016002)(33656002)(26005)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ByuuMVvxU9vUhDmDN0DuxV4JIiZX5SbO0aG2JnF+VRKhzxJ8Q/3uCtmZCgrX0JOGi6d1Xs3erL4HtpGguwjHeLN9Ss6Fx+X6Sgk7jgH2yWMAGTjIpmwHMDxCX+9j6S33FQkEHeqhpxgb5t2JBYkWPiUfPdqs8++V5gDb4eh+vQ6xUETmWYXkDZg2a5F/OaHKIiwAZ6gZnw/ioKG5lteBct6Hd256miw/wjumtzOzoFw+JEElEox8Mj4CNm+RotUtgtitXVEl1c+7AHb7mo8zvnS6zBROT7PaQMj2/HwKi3O7Xn7D7DM3Bf+NN3mhk3YcZJlbW2N0Dh6yQj+VHBbjRZ97cYRYBhqyMfmCgPqX0RqH0pUAW70hYC3i7IFgZCM9k0c+nNoxSe/+Ei0MF2j8gyD9GJWhLnZ+sbubQ6OYbfWbWkjpHRaJB9pcwVjRN0zyWSjBn86B6q/qmTcUqigaFd6N4rMGAe5SoXI7OwQHzr3hSP4sF+O5AZzXV3bNxIzuoyaRLOdzIuvH2mZacEJ+8MylgsUbRQFw4ZlR9s5hfjGQzbp9EofaCkyB4xOCjjiE5tqDc1FDPsIAGzTeirbKo/YbxQ4jXePSt5/UuyrZ1b6+82AAX0CG8x5YbwgJTFesz3NNXdd8PhC0Zj0cHxhnCQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c77ccb48-4860-4e9a-f441-08d83f78cae9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2020 11:05:30.4661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ufbQ6XpTZtCBPvsHEKjGArQnaZIHNt64FKWJwVhnaSvUaHPm3zA6ap5Ij9VTTQCtBm3+laGn+eqfD/uul8wUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4432
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRp
YXRlay5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+
DQo+ID4gU2lnbmVkLW9mZi1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCkFja2Vk
LWJ5OiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCg==
