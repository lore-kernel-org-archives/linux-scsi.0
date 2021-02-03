Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B634FC433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 07:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CFD664F68
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 07:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhBCHud (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 02:50:33 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19032 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbhBCHuc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 02:50:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612338632; x=1643874632;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7Ac7Kgtgf3j1Kol/DbvRekXieIZ3HmqZVJQZvgMnnXA=;
  b=QFi2JbNrsb3lIbRpMH03UQ5Ij975xu82MRkSfu5MZq2r93f36ViMQU0I
   VUaE6n3VglN4eov+KhkwBFaxwr450w6rwLOcqN5vn4T6W7gaSMU1ctCXD
   OJ3nNuwUE496sC+lS6bo2UchMjwgGY9A9hAy92mHuy4c+LgmMehRyb4p1
   Cndxy4Qat7UAOAdxKBzDUTR7GwyjqcdwNv6eC0A9rz3jPd96RC1NcCeDb
   4vyEskHmUNo793IHnBF0AZgqvU4EaY5YWanlZynVJEBN+Q0UlmVk7M40v
   YTARplxiklkZxh6waamXwFV4wn/+hbe07xdvr2GQBjMx6yh4hlu2bD3v1
   w==;
IronPort-SDR: ADqnf4BUx0q0hD2Cjy5+rYeZrE8/0P78SK81tgSdEYhL5nI+U0Mx8rCHPsikbXb86xX9NYm2cc
 w9s6PYiab97edixR5PJigs/dgGM+YKk/0aegDd9oPyxuptw64KVuFoNX7Dp1gUDooH0no6dRmI
 1Zj1kmK7SUSxHpWMkR5EfRCBNB1/GQI2eFS0rkkTBN21+iyRzVrSbPojjqOP1WlqCcFfoBCzck
 krFajQSX1WD1XOL1NtWrwtE6t15AsBE/niC+pTxEESdW8M9Zhs5u8pt5iKLEfJUIBaNSU2U/df
 NaU=
X-IronPort-AV: E=Sophos;i="5.79,397,1602518400"; 
   d="scan'208";a="163448895"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2021 15:49:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INGhMXuNX3I0LS6tdsllQWwiPdavk+SRVdB/L6AOyarnVZiXzDDqo/ZJKTD6qj6fgjvavX9vkPJbZQ6nlWt6/hLu9gFxDSbldHS5pDfoap84bYU4rgCtDy1BnNpB/hSWKhUkKwxH/NeOIX7X00Nw1PusOpGvFW9QQ9GwT2/ROARaUm7KwZ+cOY3piRZSLjsby5BitGUAshIb3KsRLNE7Nu0f1BYk6rCBYX+Tf3d+QeKTspllR5g6/SifnyncsBDIiphkF0Uf89buddPL7isASEF2JosqMOLowoGPL2D8Gc+E9Z5bnmDt8pk90xbxo7z8pC1lLO+7G9SNQuxL0H7LVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Ac7Kgtgf3j1Kol/DbvRekXieIZ3HmqZVJQZvgMnnXA=;
 b=NYWxYETXrgfzV8Xk2ikMvYGmSNL1gKSumaAEkoJTDsEOTOJHaq32iCmPoS/nSnhtIUJMV1ayhGoBmxC0oc0yCgs2GeNh3e+ZmrQFDYRVcrl9INZgP5/PDzGulkCeqfXuPGHcd88sCsZA3T37pdg8ugB1iMD28A+1X2QJZo4eEvoAczSS9/Fuws3yEba8W15RY5f+/v/WB6Ay5Bozwdy2skwdLIkYT+dO8+nM0nIh2BdWGASjI9N82ksAeaiLMsdTU5gEZXcLno2HF8EC1x/0e1BsvJBAjUdAgPl1uXgZ04PEld2+oZV6VXA3pZwWPCwvu9/iF6B09HEjx9hGwq3fJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Ac7Kgtgf3j1Kol/DbvRekXieIZ3HmqZVJQZvgMnnXA=;
 b=F7cF0ZfJpfsE6CjxAhckBWSyZlzWOGwBG0K0oDbijLGysErL/hE6LC6Ta5O7m0CaNajaje1oL7VBkPcL2o9oj8TEaO1gGNPrWnwkx1FgfM/CWRqZ+7LzEZRXCAC2dh2EMvx9vtGQs3wS7OxO8wZNIt2/mZFqdLStDo52VgF7arM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1098.namprd04.prod.outlook.com (2603:10b6:4:45::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.23; Wed, 3 Feb 2021 07:49:24 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Wed, 3 Feb 2021
 07:49:24 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: convert sysfs sprintf/snprintf family to
 sysfs_emit
Thread-Topic: [PATCH] scsi: ufs: convert sysfs sprintf/snprintf family to
 sysfs_emit
Thread-Index: AQHW+f/MnrKgDFQezEakeXLwPvovxapGDgRw
Date:   Wed, 3 Feb 2021 07:49:24 +0000
Message-ID: <DM6PR04MB65754456DA1AFE3422BF19ECFCB49@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1612337990-88873-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1612337990-88873-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5c66c382-1df3-4617-3276-08d8c81839bf
x-ms-traffictypediagnostic: DM5PR04MB1098:
x-microsoft-antispam-prvs: <DM5PR04MB10981CADD33E980F95B6E7FBFCB49@DM5PR04MB1098.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1BP9d9BzYTDnbhuFQ11Z+LVrSzdZ2WUcsFDecBNpWv35vVbhPh25MgZ7AmaBKLpMLJFHPm+GT+xYETsEH7+PUCHr+z13amJVtRIGoGc+DlDV2Vk7qIiesyeOeHOiMRRRNRdlMPePhaxW9Wq7Dr/gS97oTNAu4miXQ93kTNNgd1mzukYji67E3Ei/Mmz24AcVpJEtNTPOWPcP1+9Fnz9j4ovkpZHcT7QYNJWWegROzCRD7nEl2xQ3iR9SNMh3ZG6WO+19oFDKZ7uKA/HFN/kDQOz6fI0JD2hmF6v+aIm6ExP/Nqx8QYfhLQd8Bcwv7EnK28dLxGmsRxToF+q3VW9i6rZMA2ZL7+slhrXvUqq1rMXEK1CDxiXteIBei15dmGPypiY5aSZFDNHbApnRUqO7z3uweKJdGd+kClCCvzykittNJ5OvigeTK+Fe9HX4LB4bK8z4nwXr/KMvvWuYI5rl1AoKZmhxnOxZ7mOkydyK/w7xijdILVRq9W6+xCzMib335O6TsU8FP2DoHtsfM+O2tw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(4326008)(316002)(64756008)(66446008)(66556008)(66946007)(66476007)(52536014)(110136005)(5660300002)(478600001)(6506007)(26005)(54906003)(9686003)(86362001)(33656002)(4744005)(2906002)(83380400001)(8676002)(71200400001)(7696005)(186003)(8936002)(76116006)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3PDOM+hc1EHccScA1nQAhurCKztHxDo2Y+t/QzNbMq7XN4a+wPseLmPTHC6n?=
 =?us-ascii?Q?5Xj/ELZiTXtXTMDLRQrLiw4FbiTe6HdciTqCw869i+QQuqXEyiuO2QhCIoGS?=
 =?us-ascii?Q?+jadqAmbziHZQ3lEq7Mr1dN0Kkrq4sYhMrv9DAjr9oSQilmexeA5eivIg/vx?=
 =?us-ascii?Q?UL2MGaqJzbvTYuA6GiSeI9uxmh76kPd2bCgACTIHWYR0hXFsGMQOHoTAoVut?=
 =?us-ascii?Q?gk3XfCEBJHG58CzMqUnCr1ko4dqJtVWWcBccc7Oetoqzhz34leKR75ODFdCA?=
 =?us-ascii?Q?3ZRMqqnzkEZsOYC282INuVu8NcT0c9kLrZWTsra/eRCOtU1dKq9F4HGJfswA?=
 =?us-ascii?Q?nYf0OPiCuSLo1104QaHarg/gkYhYQt1O+vV8J+VAWqVZNHFxf4nyiyu/ifE5?=
 =?us-ascii?Q?Q4RzXA7tRJrYMbmf0UW+Z93bN/0eEKJi4bP0dWt7/ORU4RzP8MSv+odywG+e?=
 =?us-ascii?Q?397qsqor+XgX5l0bADxo3gix4VyDM5CCMhOkfbcoIjXpw9sU13z9b5cqofBG?=
 =?us-ascii?Q?/SLkpXpi57Q9vRe4T3b+tSqEwY0h6hQU1a4RfvZR7tDYCG/6gok+xQe/hZ/i?=
 =?us-ascii?Q?ZUyvE/h8u9aOpQpCaUAYfHCXymfGSvma93Iymma4hJU9aq1/7/cmLPNe0L4v?=
 =?us-ascii?Q?haw3Y+KQrMTvJ1w02NIACn64LwprsNV2EtI8qD67hwrJnMlUEe/ISn5v7I+1?=
 =?us-ascii?Q?LVct24Mx0ZGnHeDb/orNkPld2DAIZPwAm/ML4OABfWhXD2Cl6FQlc0zZETrf?=
 =?us-ascii?Q?+Pan/9vY88RerIHx5kx8qM3R8UmuVH1btymIOZV5lF1ZDqhlfw0JYqfxe3pL?=
 =?us-ascii?Q?LRBSaJXCeGEQck4uPF0lCqB/aMslUhDcsP2mNJMWQ/oSPtQ1OzcBq++3D0RY?=
 =?us-ascii?Q?e2Z1gOgYuEOiFMrsJnFakKEW9EmkLP0+5GyYMd0aioYfhzjNfWQnZ9qUIMPr?=
 =?us-ascii?Q?XNIRmaow001u6a0+Z5f7E4k+04pB4qXZozNGHjepxOdd43IjH9Z6/kbmPLI+?=
 =?us-ascii?Q?UxPC5nPSK7O+RMLm1UWtelyiG+1w2MIOEFzKujs8uQ3EwsvLB9CwFDgsmyKI?=
 =?us-ascii?Q?shLa37MQ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c66c382-1df3-4617-3276-08d8c81839bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 07:49:24.5511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tHVVPT9jhokcl2Z9IsitThIL7h1G4LmrMXSA4UiqZ9FI4Sd+ta4BdBpnnGNmJO2ZOYH/2E91HynvURGzDtky/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1098
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Fix the following coccicheck warning:
>=20
> ./drivers/scsi/ufs/ufshcd.c:1838:8-16: WARNING: use scnprintf or
> sprintf.
>=20
> ./drivers/scsi/ufs/ufshcd.c:1815:8-16: WARNING: use scnprintf or
> sprintf.
>=20
> ./drivers/scsi/ufs/ufshcd.c:1525:8-16: WARNING: use scnprintf or
> sprintf.
>=20
> Reported-by: Abaci Robot<abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
