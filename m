Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E12C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 14:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377703AbhKZOQF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 09:16:05 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63853 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348782AbhKZOOE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 09:14:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637935851; x=1669471851;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=mDKn/a/2SSa/p267PHVwYojWX/yPmJ5iqkzO8UEcF/QEMj6mSvzYvKQ4
   5WUDejgCRoVP3u4/J6EEy2Hx1fkJo4wpE5dKiIaYN9xWuUF4PEPEH2jmh
   p+8ccnWLft1TRy8gN72QyxTPECSjjyLMkC5kW0Jmi54Mt4MfeQ272Egpd
   F3CPBs7qNcGt4h63OIy3wRxF2Fb0wrd20Qh8aDgU/uB/4wjBDXsZdSwBI
   C4SWlMbm0JU8nytGtIaOT47cHORpScdG0sl/kjw2XFgkDdhl/03CUCEOC
   P+doHZk5DeEBQF66TYHFSvU9KEjafJlqjMnSYBWzYIES6cAq520CalpdM
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,266,1631548800"; 
   d="scan'208";a="298574001"
Received: from mail-bn1nam07lp2048.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.48])
  by ob1.hgst.iphmx.com with ESMTP; 26 Nov 2021 22:10:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xa6F/nwf8WTymso7nnzMr6GRoyE8Svl336UMdJobhqE3Mv5MjRSF1vRI5JoBcy1Nq3bEfLdbzG/RooP33GAWIFTMIOVenComuEOEq1rr9CRoFuqSZFQusiNUEyupdRnxiJr/o2fmroxbOHQcrA7FMejQZiQnxHZzzZH+MWR//NLuD1ccj4/nIvTQu2ugBNJfHcrf65e1FOH3R2U3nkpAOTqyrWHr0NwA9qNdSIOTJPCmS8gKIJjvP86X8n1G4e9wN0h74s+lgSwO0x1u6kY8SQN8HsrT8SF91s3oao+Zf7qIItIfwe6vsHeNPfRiPWkfsZqiboVDYV5UqdDOMpahrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=PvaDwJVcbOUAtPWFcCguLiWFH9fV3j9OmepdSiQqayTe0QncO1WHiqK17aV2N2Mui4okd38Qp+qvT1EcRjmhjZgW98r4in/9uOUhXOuHGZG5IeYR6X0ocdbakopG7/z0JFgEYmucKMslrqJmFlHqZhvxq+GjTOirhdzfobl6IMWEdcix1tcRRjDVP/CdgdgHfZrzckMyaCW1wUvqqHU8cfh8Q5NB6hSo+A4Xulv/U6HRLEAao1R4DoFQx/bdUsjy1JRqZNFnAWFigdJ8+nflpTj6m9Po+hQDUaomyMpCgePX8IVh5SZnkzFv/wcJGjd/EUR6OQC1B0rp49wRYHmzyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=pSUUkhXs9cAvfLLxyS8SbgbCDqXcy4FkGdqEyjtYCgIT5lJHmgByNr2m4NqIiMKHQZ6jxY4NBk/o/WoM3UrHZITuduQ9OVUxbyO6LHWkzn8DETmiW+CS2JH8DxpPnxO6MPBMWm5Qq4c9/pucUxFIiOVgkbZo4SeqdgMhpeCT4RU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7734.namprd04.prod.outlook.com (2603:10b6:510:5b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19; Fri, 26 Nov
 2021 14:10:47 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3418:fa40:16a4:6e0c]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3418:fa40:16a4:6e0c%3]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 14:10:47 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: sd_zbc: Clean up sd_zbc_parse_report() setting
 of wp
Thread-Topic: [PATCH 2/2] scsi: sd_zbc: Clean up sd_zbc_parse_report() setting
 of wp
Thread-Index: AQHX4sT2GcpwnIKOLkekqsyXmCouYw==
Date:   Fri, 26 Nov 2021 14:10:47 +0000
Message-ID: <PH0PR04MB74160D785558E624FB4941F19B639@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20211126125533.266015-1-Niklas.Cassel@wdc.com>
 <20211126125533.266015-2-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 088b3c92-61b4-4711-28f5-08d9b0e68b2d
x-ms-traffictypediagnostic: PH0PR04MB7734:
x-microsoft-antispam-prvs: <PH0PR04MB773406E0F13746DBF7FDA8559B639@PH0PR04MB7734.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rhju2tMW5hd+vhlpp47yxrqXEWrmO3pUQ1HI/PIrx7TQd28bn4DuXxAg9kVkfblLsrwair3D5IYD1DWldwNugHlFAVolIB4wZAU/DqEwJTAWbEcYQfvBSdMMISjMheNP/ua+thW9GQUK9EyQ+FVshgybLG8S6N/kDTNABbAk6WiAbd7v9Y8FN8/lW7Sn1nwWO3axei4dYMpczIcGyiDA9O5L8wwO/R0cSr009AGApTH/PWfGDC+lecfiIOaZFwlo/oqB513W3NItURB/8Wx9vcQ4TyT1lbRNCOEF8YfMTrgZ7pCgIs7gzt+OkvRmnLnXxYgFDVzcbvnI2F004GpH9NNMnP43TzkWh82p6SOUddeUn7/qiD05PwscQfeXrs3pX6YNk0X2bTkzIiRZ7MwcxKxeXxzZi0sYLDDvsLPKt1RwVbsWhZtpjB2iigOTZdl/cvbHt/waDconDgBH9PzjCR2pGkLeZRZo2htLuea4T45K2K59D0zwYGgMeyjEEAtWMFf9imflplZXuIlK96qQ2qOj9tM17b50q11KFEsE2198c6IFOcj+8he6Z1BEcRzbMaUEk2AGaQlOsTTR8lffUysA6LbukP60SqYfJvDTr0NGXcjWtzc6cCArHtVgdkPgjbzSpld2JlNNw5v7g2+HsMEPgy3iT5PPdrWHi7TJOTA/k3smLk1uebRuXU7peRXFe3AvkmBUJJEjyxqj6zQgag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(186003)(71200400001)(9686003)(66476007)(66446008)(19618925003)(66946007)(64756008)(66556008)(55016003)(4270600006)(54906003)(76116006)(91956017)(508600001)(4326008)(26005)(122000001)(33656002)(8676002)(86362001)(316002)(5660300002)(7696005)(82960400001)(8936002)(38070700005)(558084003)(52536014)(2906002)(38100700002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y3o121N2QIr3Rvdivq6Ps7HaulzYDDeH5MiMg131O4yOTPt4VhygSJqfbgAF?=
 =?us-ascii?Q?8OMQ2HV8KNKJGlRT7AE7xyc1kgF36ollCrjFACyLmEZZV/pctlNHcmrfzXtI?=
 =?us-ascii?Q?oSnXUleSkjMCBefFXV0gWVUoV0Z9AN//bk2JYKNYvFHlkm7nLHgMUti2F7D1?=
 =?us-ascii?Q?d0Mg9nIGhJWMbarqpy9kqhEmfj8x2gOJ9FEIfaGLT9O5HMqHwvdkk7jhenmS?=
 =?us-ascii?Q?K6FlUkcFCug7xMJ08ifqJAnkN73he29K6I0zY+fLuU7nOKAyISRIjBQ3qxLl?=
 =?us-ascii?Q?bzY+BoGp9pbXTq4bx2FCBWpUOPk5IEa5FgVFgy0100ev1mMSzekifVyjD2Tl?=
 =?us-ascii?Q?GeiQ0WeF3sSEJ/nIPfsov/uyK3hcLUzMumUCBTv9MSP8oFaYlu+PUVocmyeg?=
 =?us-ascii?Q?vnTMLpoGQLs94/wnBDADnqR5tgOfSIH2YSv8PQQ109PU2RcBLK2lrHJnCjX+?=
 =?us-ascii?Q?kyDrsBBru3WiTLjnEvEoRuY8gD+FFkDMLtnJ4ZSZcuJL6nYLZFIaHxOMkSfq?=
 =?us-ascii?Q?mGE2pnHNYsqtog32EIa2FzgkpN+0q/BLrTCzgH6Jyjw6QSP6yawlNzWzEXht?=
 =?us-ascii?Q?tgx4x54fCQwFgeXpZjjmMxxeo1Qt7Fv93KuvkVdpyCpQubjpxEFL6Vf89JDB?=
 =?us-ascii?Q?RAiWaM3dxcX2R1/fvwGurwn0FXoy30zU9K/8jzA2U1/amss6egO0zPM9s0Gn?=
 =?us-ascii?Q?DtyrQWb6FG3itYz/SM26RRpuVRLkeC9NUTmpChKxdKi556yEe4Qx9WePFQCX?=
 =?us-ascii?Q?EJOYMzsCM11D9CNabdTy6bYCug5uq/AP0If6XRXz0Ljk+AWGcqIfS8ibccTg?=
 =?us-ascii?Q?0nUWVPjo//AWx4b0BNyRCy3kp/Am1EamQdxI7Q/46TXMzh7YtfhwV1azAckZ?=
 =?us-ascii?Q?dUAD5ddzJsbQaWAuLxb2VxMP9etaGZ61zIk8cN3mSHRkdAGMRtfYXkq+LzXh?=
 =?us-ascii?Q?UAK93K/RlGROuK1CyxsWzlxHngAmnw7qajM57+HeEeLDD/BuuMoqdJFdlZE1?=
 =?us-ascii?Q?Clfo5AEsWbsQTe1nzPzF05Y9A9vqIYJ45mPOjpfZEEPSwjNvwbg9enmSdJDy?=
 =?us-ascii?Q?YrM35ZgS46GxRcdz2btp0h8BveEW7+vrt/YoY25teZGCdEX9AMcc5aDE+oTW?=
 =?us-ascii?Q?cDopeFARtRrcPZa4SEdwbFl1laJZchrqew94nQ9UOewBz+idHxYaQsvYvXjq?=
 =?us-ascii?Q?IIRKpBFlQSDW7G3/D3HYtV0zGsN2Mk92X1/Kmo4KkYP01ogcCLskqSM6/bGA?=
 =?us-ascii?Q?bnKW+RxDmkRthPUJSW4f5BNeyxlw7ayslHCI6KVFyXMEjrgJHN5SBCZ0k10M?=
 =?us-ascii?Q?ecW75XvGGKBom8xPZMPpYFX8mySbjexlui/NuL9FkGB9z1uygLrbHmeoYZaf?=
 =?us-ascii?Q?u3nhBhrCbmf/WLaJrPEHYQlNiTGy+YymvA/Tsa3QpO+frjtp/bvPpEgU+S6H?=
 =?us-ascii?Q?fbTKiK3K+YeJeaorFFt6OkDDVINwHKIm4jnPIXLX+LLo0A+2+bTRINYeRwFS?=
 =?us-ascii?Q?E4gom+1VyiKRDa6Wm0igQu6xNBFV6vMTPAJHH+A8Q//ukJcuzbRJPPPyjW1h?=
 =?us-ascii?Q?CDSboqzBnL62fCFfa/bW3vas5FUf70vGu33ifGycl56ZmBJUHiEn+hEPyAJe?=
 =?us-ascii?Q?f0eLgoJlrJFLk+ST8QeUSrXpS3RoyPKGr3Wp+AkeOK35eSKtmLtD7IIAw1Hi?=
 =?us-ascii?Q?MbFKxmm88zLtgnNLyu4yS1P1/9g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 088b3c92-61b4-4711-28f5-08d9b0e68b2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 14:10:47.2480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lhEKeCeNnWHXnELm8uifhIj0gJvFlrq3YJ86FW6jG7M2LCxnKs+gXYnolsxFNrmevKeCpNxttxWJHIqL9AgsXOBxH6uuAllNCHnCwxvjm0o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7734
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
