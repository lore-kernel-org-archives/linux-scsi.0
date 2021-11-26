Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EED4C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 14:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353614AbhKZOPN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 09:15:13 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:61844 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377691AbhKZONN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 09:13:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637935800; x=1669471800;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=FPCP7TauXFkZN5/t2jP/Vh45n9XE+oDbvfDTTBJ4uXABJRiIdEKmymFl
   JxIrio7kQxs9pWWpHeJOkcQrtCGiy4Guqyq0J84Qtp4f4pxHbP25s3E8s
   HiomwwpFwxascMk59KaurgfjDqDkWrFhy0XKC35CRWiU9U7Y176kus1RK
   q3IOBlnUwzqm3lVqEKF1uo2Hy3jGBixjH1aI6kCGTWteKIs+HhIfudM+q
   WEI2zvxX6B7isMaLiNqc0P6ga07IIZa2q4PPPRmr0LMOcBbQrOVyzVi+j
   Xn/e5pdvfbd6EH2xcm0X90ziQrOOmWnJlKBg1vZvCY6p6rjP6LbFK96zD
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,266,1631548800"; 
   d="scan'208";a="185731133"
Received: from mail-bn1nam07lp2044.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.44])
  by ob1.hgst.iphmx.com with ESMTP; 26 Nov 2021 22:09:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQK3oRnWzAhvXihWb+e93ks74/+aQJzBC7USPSM7mjnhbSGy8ewfkyJTu2+nqToC3cegRZIh6KH8lwpJvJQt5lY8koP0DVLC7XYIZAE0akqYS8Q5C7zTIXCsY+SemqoYoI6D7uN9GbO+FE0hrf3+bdneP4lLcsyqrw+zssiUop2ZQ9k6jxpG8vIOprb+ytMH1mj4rb3IuoJRKxK718SoTFB5DJzAT8lMOIeEaxw48+jW8Ijo7K+8lzK3RH3GgSYF6QS98FKyL/u4H8wn9izLBYtuzs1wmbLVDg29iUM1K9QI53R0w3bBMr0CsWHUtBbKpoLvSBcyO40gAtNVnXxJfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=fLlgumdNLQFDEkF3mpqa2J4BhhBjJqGwEfFC7acW0bHMS38rmjpL0bZ5uLENPTfd3pka4j1c2ov5736KK1Y9ZkYWqN3oBXsuzbU94Gj64AVVnPjLKgrV2Ezj12mjBg0P6Rg+xXFf8Cx0paNXdnDRH+RIOlD4NL1i3EQORWcY13r+J/FRaiNd76EkBlSjS5UebEwIba7XAK2q4w8UqVlPJYzigmr64YcE6BNQQCpXknLiSYFxO6l9bz2UWRCRKbqxPJGkoEKpMM7lacaPLJb/dFY8lyquj9MehTNf3RTeMCoUzsbMaHfPPohDA9XDsoq7uc29NKkIVjgLEEP47mwbxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=A26jCUUhDR0K7ABGqUUcGFIRYCa59kAc0/j/xhaPCdNpdOk5aZRg/Uev52UvA+RIYnezPbdoHt6WP5wHAvEPbHJ0txBUFZYBxCJS/2mamRhbigQ/SBIKr3DhOuwLrZ4xnjCOybLOUiAIO94nlsJ3fLvQ2IEZOsUV5186ZnNQDpI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7734.namprd04.prod.outlook.com (2603:10b6:510:5b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19; Fri, 26 Nov
 2021 14:09:56 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3418:fa40:16a4:6e0c]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3418:fa40:16a4:6e0c%3]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 14:09:56 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: sd_zbc: Compare against block layer enum values
Thread-Topic: [PATCH 1/2] scsi: sd_zbc: Compare against block layer enum
 values
Thread-Index: AQHX4sT1wmIgicv9UkS/qqm8MDen0Q==
Date:   Fri, 26 Nov 2021 14:09:55 +0000
Message-ID: <PH0PR04MB741648A8130D9EB516CBBB599B639@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20211126125533.266015-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3bbc3983-04f9-4e8c-c334-08d9b0e66c9d
x-ms-traffictypediagnostic: PH0PR04MB7734:
x-microsoft-antispam-prvs: <PH0PR04MB773422DB6FB7683D473F71979B639@PH0PR04MB7734.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ERFRi0gBtMhNdWlqrPPmf7zmyI5MxOGP30w/l/f38nrqTP0loLZFWCoPH+a9Eir/mqe0DYvzfYKYORjgiM9BU6XAPyScxFhtkq7/F1HRQ3GlV3xvlsUl5wuNZY4m9nfY+D1vp+8bZrb5Q4BCwzWzukdvw4aWCVkGJZyWM9/MtYniWNaSV29WQdlYcNN9H/IpV+9GXqZto/v7G1ukW+d9zAlfMEoXCZwgafxjYj21oek4TEcGqI4R6foJ+KUqOUKIsFBupQ3RiuL2AzmZWL3W/F3ENGlSw0ZDKg6/lMcacI1Q9jXjSQ0TLgeuqGBmDaTmslsrvJ1Egb/sjyOpGpKwMvJMqIinT3p1qjGR0fkuyezJlMKP6/Za2JrzHfEaBJbk2LnANoS84lnc5KnhvVRPPKEtrAJww3NjrD2mcs9WL7+whPsqfd3BaNR3vi1wvlXyjBDT3AUam0DK9uwTRDDwGWnTrcTveJKg7mQ/3D7/IrDPJYozHfIgdeaJD5iiogYNfYWkyWg2mwQRsyMZm7hcxvBKfZAuHVB4bcIhkfsqGBUXQ1lZoetoPcuiKci5Q1qK7Hu4Uio8NTSJeQDJbhMYxmQlDbCFFUcG8+zMIBrLrEKERkDlf8yDpXi0KzUgLKNZRISDtRYJsysjtka+zrk5lMZFzCk1N/GcgAoegAMo8LY1FydyzSFyS47CYAODIs6gFJgVMHiJevOVTsvMsBGq6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(186003)(71200400001)(9686003)(66476007)(66446008)(19618925003)(66946007)(64756008)(66556008)(55016003)(4270600006)(54906003)(76116006)(91956017)(508600001)(4326008)(26005)(122000001)(33656002)(8676002)(86362001)(316002)(5660300002)(7696005)(82960400001)(8936002)(38070700005)(558084003)(52536014)(2906002)(38100700002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Fvww3t67A5b0BM0ypEYNxSwVuzHa5cxAdcOL8eMhc+6dSv4o7fLCdZphu5xB?=
 =?us-ascii?Q?husRSwB0F50U+tkdPsIl3EGj6M5Gmzei0vaF+4tkl0KMQGUts6nNeUQGsyue?=
 =?us-ascii?Q?M1mqitRk1G3dE7x59eIQn2szoibY9jWn78Y14TjL9KKTN6ULxnqo3oVinDSB?=
 =?us-ascii?Q?JvfiD5QrU8Hr31D/hE5oRRCY+8JrOz1cmFsIDsprOPrJT47l6Kb0zUkqQuHo?=
 =?us-ascii?Q?KTYpk7aEkDDVifU4Vvr2alRqqEoPwHSC6EleU3x0nQmGjCjW9G0bvvAX+H7j?=
 =?us-ascii?Q?pK2jlpyLU68i6f+aQ2yVc1QoC7VBXgJSLhCsuZsMkQ4RBzPIEcohTrndgdfA?=
 =?us-ascii?Q?RjIJ+d1BiCcUEst0uhGbHHAFoKL1I0q4OJ1sKAQ2dhvF8cMC0g8Q3BwRyY2N?=
 =?us-ascii?Q?5Ev2DU0J+FCKzl/T3WliZXto+CneQtZGsEkwXna9xdktIIRjZFkGozSie2KK?=
 =?us-ascii?Q?QFjbVNUleaJ/nuQOUka0BthGnhkGEQaAgKW6wjdaSjAqY4jv7O8/r2LS0heq?=
 =?us-ascii?Q?qSHe9liMw8/ZI87TfW4K0mdpKgL9FuMGM5BZ2rNC+6Ae0yKAMuE1WC+7V1+Z?=
 =?us-ascii?Q?o8380WmQ4+0c86WSfaF2jEOMvqZ45l0HMrtyda/lf2JiD6OKF/uZAuVyqkTe?=
 =?us-ascii?Q?QJv12futk+5hZ4KASOjLfRkcrdg5C/N/n8nU3NnU8aGnOVnZhDD+m5FPXUBX?=
 =?us-ascii?Q?gz+EQC8DZnUsUKQj00Zljc6WqHeqqM0zDkBvaYDMbLYrw1AlnDDQjyq9BAVD?=
 =?us-ascii?Q?4EiVfD1i3fbBIlMS2D/8dLFycXibjIm1zq4AHzvQD5tv2Nv3Ro027A7CBmiB?=
 =?us-ascii?Q?ExnXuVpdSMAsGKH+kMauD1ta6vvnljkQ3JxYebPqBX7xxE/IYCLa6uU5lonp?=
 =?us-ascii?Q?UcTFp5ZMlI963CpWvZoFDlBntu1dlwH3vwv/Ts8vWgzXMhcpSj+O8yh5j6wR?=
 =?us-ascii?Q?DpCx4PKq9LYQ3/Hol3TKYVXsmmlOGJ+khABdIskH5jfRYd9MijRbT1Ue3FdQ?=
 =?us-ascii?Q?K8VKgXil020f5iTsxanO0Owxy8DGVBCHwYmBUhA+CESStK8BWAnrR01Pg6Fa?=
 =?us-ascii?Q?RBASAcCmntEu2vTICxi0y6Iwp5otaSgVhsHf8suLCjNRNnXtgYrlDjUGfU8v?=
 =?us-ascii?Q?zy3uO6CidrKzu8AS9sDbFd4SQjv2K8AgkSv0onmUefNZZw0K+Z6k3mCU+Wr4?=
 =?us-ascii?Q?JcC66NhdwDMWPjS8LzkkonBcxrNhbIi/BDY7veaZ48KqnQhC1oou8PAph95m?=
 =?us-ascii?Q?RIYWIr5UzzIg+J7HMYXWr0iLToZ3y/OE+0FQQzDixUXGDd1QsiFSwdM1Fxaz?=
 =?us-ascii?Q?xmiT/PI5mKGYFKNZVrvBJPk5XeWQBzIA1FDjercqp/FJubB0WtGU+MsQfDlu?=
 =?us-ascii?Q?DcGJkkyBBAOtFfRmQeD9AVgJvjVQl3m2bMKrd0dd4JSBwY//2JG1ew8z0c9b?=
 =?us-ascii?Q?Oq9Afw3Cp7MOhuEHvnFRKBAdMxnMaWRuIrMRqlBAb18U1OxU+f1AAlRt/1+X?=
 =?us-ascii?Q?46iSIyB3Ry68fMEKS2KZGhMxYSUsPutEi6LZllgm6VqTQXDf6WDzRs60ihnU?=
 =?us-ascii?Q?KKGqL5VEpss66YR7I47Qe600CVF8I6rQHMnUM9ZpScWHxVZ2Ji8yHPO2/3Pd?=
 =?us-ascii?Q?AVjMeBbplzXCwZ84s10faaDdefgcm/GLvamcr9zkuOoMz4V3dpTc8DKbR8gM?=
 =?us-ascii?Q?3S0mwW44gXEp7Z95Nr8fFKIUeOM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bbc3983-04f9-4e8c-c334-08d9b0e66c9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 14:09:55.9706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qXgSzQTBimbbsIl6k0SQ+Vn83K5p+ye45+WSBajJ/dZiiwIKDN+X+R7vXUvGQSm4SAB/SWDarGc458UsX13ka1Cxy74E9f97bKFYtp+mxdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7734
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
