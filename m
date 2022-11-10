Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6AD6C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 02:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiKJCUS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 21:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKJCUQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 21:20:16 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4AF1FFBB
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 18:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668046813; x=1699582813;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9FJm6xhc1iys0YXk/X3X+oeXlk3wjOghk64JgdepByg=;
  b=Aq6PdggHCv7B43sKC5gFI8NEqf7XJDUthOHvmjjAWSMdOIQFYQULsRGn
   DvEO9+Hw+Be3PSvhG3MzYi3QwCMd8fyRJWYTDCZuofZYIWtOrChNrSoqR
   +wuegfyoCA6VUYdNPB1jULBxIhe37u3pM42Py6TV+UaXv29SFRY6S/tgm
   /ZEj2MyMdpHXZ0EhXtZfJjA+vAmU4BlJkd3qAMh23TEXS49XIUqH/PNC/
   UjT1IqyquZPMUOAjb5ZUDBai14YnOpp8dfKQhuST7S99DgBUoLayLVGn8
   e4XTM+x5DWMChqgYo4P1nlCuHHrPALTfUe4uytwrrFKyXggq/bo/s6d3X
   g==;
X-IronPort-AV: E=Sophos;i="5.96,152,1665417600"; 
   d="scan'208";a="320252411"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2022 10:20:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkEMUKKYNRtTh/A0j59TCYi8WNSDyaOow9PyGoo3ko36J/feEybuSr2tsKJ/Ki9WRSAo1dckyOwK7frpKv4/zRFDwMIOB3OxaMeDsIU2IurYP8fBFbMJy+D0kqhktBw3qAFCM1jDJswTGizJLQf7aThm0v24rmWUjc00nqfyo3TvGmEN5mj8HUiNI1zms/pDdYjT2gyjos1Y76wkHeW6UrFLdNYY8cZQBkrNOyqTiILrf+yp/G4hg7Ov/LT9Wsx9YF+LBroYqpRvCpgfJTbdi4MyDt0SJ7Craj5anhJ3vQr9bOQZBnOF3setLTeC6k3cIs3ZedmK/hWzyeYRESa/FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfBFml0mA+QAo1vg0ywGcOQzSOK1MlkX7rsvrsyeKMY=;
 b=NX7OhOZ6hpxrasxGGrU+TCUh/X+vsm+dbSetNCG17e7/vmNR2x6njHL0fwXXIdTlN9GqMaJ1/vCNo06YJPo4H++2j0Rb4iRAf5o9UpFcBOg8CbnHv8vY+uamDutycArtwv3x/om4NJV9cA9YWp6/nb7uoNfSOJHYznDnguu/rsaoHYCWDWuq44dNbUsHwnBYaxlnyyni3y3ySaiBd5MYIa9XtJWxq7nTLxMoUfpgRPa+/MfZWvGdgFlhnnjUhWcHeOrugluo9joaRQ7SfYkk10Q+pFgorPKmrUt6A6EEUlJGfR4heY6KJdgyNh0c1RjSFk2nMnQn8vK4ukGCS8PY/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfBFml0mA+QAo1vg0ywGcOQzSOK1MlkX7rsvrsyeKMY=;
 b=vl1r2iVQAQtqYn5+QuirbJtjdXH7vDX/X9vV/f1PTXUzRrfmCUxSsntyJ19u/BfddJrg+Z7MoNz2/cFyq0inCt0UFX8qHA2v42Ty1Xk/8jwbhYRYc83Gn4M+RKI/KBtHNKf6qyJ+Q8fmO411sC3IaF05peUdssMenDDpS18+Yj4=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 MWHPR04MB1214.namprd04.prod.outlook.com (2603:10b6:300:7b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Thu, 10 Nov 2022 02:20:10 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0%7]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 02:20:09 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 0/2] scsi: sd: use READ/WRITE/SYNC (16) commands per ZBC
Thread-Topic: [PATCH 0/2] scsi: sd: use READ/WRITE/SYNC (16) commands per ZBC
Thread-Index: AQHY8+dTcwmfg7ex7ESXffXNxEBulq42iAgAgADmEoA=
Date:   Thu, 10 Nov 2022 02:20:09 +0000
Message-ID: <20221110022009.xdfmlpdpw2kyu32x@shindev>
References: <20221109025941.1594612-1-shinichiro.kawasaki@wdc.com>
 <Y2ue2rZzf74/1V+U@infradead.org>
In-Reply-To: <Y2ue2rZzf74/1V+U@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|MWHPR04MB1214:EE_
x-ms-office365-filtering-correlation-id: a76c01c9-4a49-40e0-5efc-08dac2c21779
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4YHWVjKQIHRQ0mid+4Wwgdw6SeVtUYrKArsvaj1Av/CkqON53CpjLSObKmEdVFzNvsN0v9/XPvc/aFWHXpYcbd3I5wh3WLKNgKahS8+vbNrEzV9bkHc4a49hrwjq8/pttZbyj7JFMGvGvRNMDUEiMIe7ja4hcu8PBwnhH56EgzfnTaRsOePtGWXSOXutR4JiuGnqzaNK44foteO/tEdvLfIP4HpLixFhYd6D50EUc5uZI+1qCShJZh6DkIf5yd/OTyX1wDQCtmvOiOPykUShGzYRtv4beT7w8lRNaZNhSXloYXfbufwFGpsoUEHkz+RErVV2tywi+TD6D9mC/fFqbiPIgF6hkfFLKJnWWs/oZE/nShl7gZKLIf3infe8a30kxDtY+BMaCj7M++hMbPQIHa3Xt3RVSWe0xHSUIQy55LAlO2y5RcSe1khAAA9HgXtz70qJNJ59QIy3XuyLHKRfsRFjXLwGb36G9lJhEi8FmWtJb3W7HdHVIlIbtH/BLt3m6swe1INZAoOZii4tOmBxkK8ndJIvmmYye1MOuz58El2A5+CzpHYMqAzpM7tKhmQS4GOCc//8zxPFNZS01C6vKqZThoA1GKVd7mPdQ0yRqK8HmUyjrdOwyXapqOkip4BlqZBiYgE1U1CDwo724oTx8x2o6ySCpKFYjmavyPMUvCfjuHQY3yjErqVNDcelJHuB1mAfkSa5Bj1O+uG28oTIxM7BXSp4HTEuJ3WavKOeqYTuCKIiXxMQxfHFhQQu0+PfkfaFsyWNujhWCnlno5rrNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(396003)(376002)(39860400002)(136003)(366004)(451199015)(44832011)(86362001)(41300700001)(8936002)(2906002)(4744005)(4326008)(8676002)(5660300002)(66476007)(6486002)(64756008)(122000001)(1076003)(38100700002)(91956017)(66446008)(6506007)(71200400001)(6916009)(9686003)(66946007)(66556008)(76116006)(38070700005)(54906003)(316002)(26005)(6512007)(478600001)(82960400001)(186003)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IE3oCQjUiHIvPMJ6vlqgmycF88qgmBHBDmlur/s6XmPxHWOuvFnUkqY2ZBzj?=
 =?us-ascii?Q?SMrFyoiWUsi5tPjg7XIL3fBuKcuJfQ6AD23J923xjqKC98xxDnJmwmG9VUeY?=
 =?us-ascii?Q?xUPAiqQKMWmnj5AfUVN77dygAbwQ+vX52Dbj8LlCNbiANm78r3nrLQnx+t+5?=
 =?us-ascii?Q?22lATo55pd3qU2sR6zIgE+0Dn7QNYVj0lFefYHWKIqN0eGhFS+cwZfYH5hZ2?=
 =?us-ascii?Q?E7LCs7WAzTkvP9RUHOhnOErE8zn8yRmjKV6G8CY2fyK6As1KOc7+BzGUVa68?=
 =?us-ascii?Q?zlG1xhrak7UWJOzdszeAFWZKYkPDe3HNhuW5gkkcW2KwlFBLaE4ezkanWBEx?=
 =?us-ascii?Q?bOXbdA7uWhhDtyAQDW6OEinvSQ3XfjG3IrDGfvs/XL+/S7nJrxlarjmkWWp0?=
 =?us-ascii?Q?Vzjvr/l3a4QdS5h38rS6tJvLQtTCtyY+9I9wWfFwyUzTyLcj9TV5pjy5KY8W?=
 =?us-ascii?Q?zGOPv16w5TDrrWywMg5OTTLMY+zywmBVuZWcc3jcAsZmSNjxD8rbF4j6Kuy4?=
 =?us-ascii?Q?eO5sLoEoQhQ2onappz/1QfmrMUD1jwyRZsc0JNi5raY1dKKUbLdp7OUYBafP?=
 =?us-ascii?Q?XNiucQC5pOxoq55kdRmhpcnqI0R+gvUoa0d3V63uAL2BFBWbEuVMd0sYFLAe?=
 =?us-ascii?Q?v/aF+FftjKlOwUyHyBkjsC26/ndaO5OiLIUKPbIWusVif78068XyM0VvMTEJ?=
 =?us-ascii?Q?cBQy1y7yj/tDtp+AD/qN76o68heI2pzHrD8JLZOUBOmxmZ5B7vvytwOl7IPg?=
 =?us-ascii?Q?oih9vQfVhejgLRGI8Q6rRY4+W3AcyIuwKrgTP4y0HQqIw1ZZO5fn/NVO+c1T?=
 =?us-ascii?Q?sWWVSlj7YfxkfQ1IGvqmwsnkZojUW+AUhUwG9HpKg92+SqIXPQHn5IJ9AFt4?=
 =?us-ascii?Q?opFHh9gTx+cLAutdgSSKpNFdB4inymnKyQodlr/6OeFcGDgHXS6mO5wHK/3Y?=
 =?us-ascii?Q?LlpMh0qN99Z9BrAp4ZKgw3rKzsRK505rwCC9czrQtj2NKZa5QvLV5q/KgVtb?=
 =?us-ascii?Q?iOJuas6kzY/5qcxIqRQ+cZZrqqUBqQd7kVm1z6mQZlvUwDPmAfOxTswTSyP3?=
 =?us-ascii?Q?ZtuA1qzQ4YAL25+P5SgSokXGTI5IpIYP7HNpIBw0YxwQu0L4/fFKjQ3ln5OC?=
 =?us-ascii?Q?Iu8nYAAYo77va5hXf0WWYBeco0ti0hCLOGViwKuMHHWM9BW9Dm0VN3EHwk2w?=
 =?us-ascii?Q?SLsmClHN1bdsEycnpyGfLxO8cxdfkLqClLkpsW2BWxAgKbqEm16RphEkQSyJ?=
 =?us-ascii?Q?dg854GdIH/OWZdh2+CW1SR5TCqVrOwgJ7yWgrptcfg7oB0sNUlv9xx4WgpM7?=
 =?us-ascii?Q?m4aD6gtaAU5QSVPng7rz44oEtAFUoj8c2GUFRjEWIyY69+EfCjw97IXn20i7?=
 =?us-ascii?Q?5SMJW0nd4vs9SoJHf4Pj9Xu56FwWcgcLaSt2uhzlIrkGggHPFqndZF7vAjku?=
 =?us-ascii?Q?+YG1VZ4+Qkj3n1To2sg9jo6j0giex+3mfBOyPOaRY8I8CQsk95b7oavF0Hpw?=
 =?us-ascii?Q?gRTofdVQb3fN0Bipkw2rLiyFUX7okvzK4SmZ2Y3tNsDwiA2OHK/JxZlMyOez?=
 =?us-ascii?Q?iFhO5oqTVXRaNzXYosubA6v4WPOkilDNirIjX7yavCUTi2oTxR5o+M6olDcN?=
 =?us-ascii?Q?YROH+8vzsyUvq3sUIaX/Lk4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <668B13E5A023314C9A447403CBA4AFBB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a76c01c9-4a49-40e0-5efc-08dac2c21779
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 02:20:09.9464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eNCywfuRmakSr1eU2bJ5Up4bwm5rAn/PWYylJPbcUY2Te6R0F0KokZ40fHx0MkgWMF38oZbMcwVugwZEGqpgphNoy+M/un8vLPusMS8E1Ok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB1214
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Nov 09, 2022 / 04:36, Christoph Hellwig wrote:
> What is the point in relaxing this?  Every modern device better support
> 16 byte commands even if they aren't strictly required for host aware
> devices.

My point was to make the check strictly follow the ZBC spec. But now I see =
that
it's the better to keep enforcing 16 byte commands to host-aware devices. I=
 will
drop the first patch and revise the second patch to enforce SYNC 16 on both
host-aware and host-managed devices.

--=20
Shin'ichiro Kawasaki=
