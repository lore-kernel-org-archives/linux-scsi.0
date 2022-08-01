Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E090C00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 16:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbiHAQhn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 12:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiHAQhe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 12:37:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B078257
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 09:37:34 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271G995v021273;
        Mon, 1 Aug 2022 16:37:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=RmY3LIjFAJUYO+qFviMdJZSYYuMZWlqCPlXVCkrWGTA=;
 b=Yg4tW+dGGK/pnZAm14+ZJc2+d6uACFATcIH1RZquTvEiurIWYND/Xm1WmdXCfftn5TfS
 wvZ3EFAUh8mZQh3eF+3pHCFmN4Nk2K4q3HBAFTuFNWIO40txFICRA/jJKMcua7wA+2Da
 Kf+maHrJoOtNn0mWIlU6gPYuT071XiQ6foDCcPBINZzkFUyJrabJz3plpp9rWUw1xgGA
 c/BeS1f3krUInuDq8/KkztjJR2tXKcKrouYULkMTl9q57fg8aCYVb/F8AXTqNYYlGCyH
 hAx6hYaoLM0jCoDEwDyNymf5bTYlvpY/RCNy+HWyzitk9TSoedJUgCfeDO81aEmQaFfL KA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu80v8ts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 16:37:33 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271EjHDF007361;
        Mon, 1 Aug 2022 16:37:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu317mpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 16:37:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpMvOg588c92qb+1+a83UWqYF0DVN/7XhKBaHivKPIDlIOTCHo5X02czhnbiyBhAWz6UZwMHLlvCcWHc27veZl2YgIZ9JJNA0uU4oeNnDroc9NuSNygFaiiX9K3l5J+fV00jfrPIF4XYJsnpztSDVK/bBBfWG1uISb+RezAUOqRmlrIo95An7CbnShOU7RkUhnSrDnsEHKQhJP2qNdxuE3Z337HZWpNZ/iedINrcP7qaRYKJHIXcckAVaOq+iEn+6Sc8zWjxIYet8/Mmae5Fq6oZ+rLAqY+qKCakbXSunulyh+xFg6G0lhugdXAjJmAvFtPzf+ryOeVbAtfjYvvEBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RmY3LIjFAJUYO+qFviMdJZSYYuMZWlqCPlXVCkrWGTA=;
 b=TbUogLIyd/DrpOReo7F2OwBtITnplgZHd3MztdxcuyOcWtOLaynIP8l8qdyOfWzX9mDEUFGIi09YvFh03DXVdoAWxwrGfwiQ864Er0RUS1CqTPSVOhuR10pyPSpSA8+gGbR3rQk2W/zX8a8k3mxkBMZVIIG2QJNDQ+IPP0G67k7GS8teafnB3Z64TS0NhtZnqLR5YPsuNlZB0/d0B9E+RzEAgzixIQoGmWqw3rv+cYkHGaTjIAyHaW82t0s8Q9JRKHjh6fxn8P+ivntVgw80tZBdfR+jzpR7vH189m581ZlJjP4s42dDDxTc/UQ+HOB8sz2/FAA0MPvmCtbCdlYF9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RmY3LIjFAJUYO+qFviMdJZSYYuMZWlqCPlXVCkrWGTA=;
 b=y6yhNjo8Is/z0cY06OBOonhmrbQ5vLZ1x7/DR4KlasyIfLLIjnpbp/VNmA5Z2q36+e3iCRAzR5MSUEEyT3jNrU69XZltmbPlZGbEDtUJxXk4ArFdeu4UwQbygmXiTU5WCTzHWYR9GlHAvf/uTh+tvlvLT7QvRgfAlN1MG+NoY2E=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB3788.namprd10.prod.outlook.com (2603:10b6:5:1f7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Mon, 1 Aug
 2022 16:37:29 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3%3]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 16:37:29 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/15] mpi3mr: Add framework to issue cnfg requests
Thread-Topic: [PATCH 02/15] mpi3mr: Add framework to issue cnfg requests
Thread-Index: AQHYo0vgtDmoRebGdUSSaYhiRCESP62Vkq4AgAQapoCAAJYNAA==
Date:   Mon, 1 Aug 2022 16:37:29 +0000
Message-ID: <EDE15ECF-9F11-4BE0-8B75-83C2573D7CD1@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-3-sreekanth.reddy@broadcom.com>
 <AA2A58CA-8EB7-408B-AFE0-696E0BB04CE3@oracle.com>
 <CAK=zhgrfjJT8AWOorn7yZVWLivoBfdd0Nn9gZ+Lbk23uHUOMYA@mail.gmail.com>
In-Reply-To: <CAK=zhgrfjJT8AWOorn7yZVWLivoBfdd0Nn9gZ+Lbk23uHUOMYA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bbbd5d13-33ec-4dfa-0c9f-08da73dc2025
x-ms-traffictypediagnostic: DM6PR10MB3788:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wshXumYlaTfBUTg4Ww/mnoQDlkJorsbGkQFS3LFC90A/fpTFlol54tZFWza+hKbJWDPcbZHlFdvZPg2k0uHg/WJ+7l+g+aoM1Hr+a3I/5BtrnYyScRDH4csqwO/MOPEksOAQyvU6ufzWjNB3x8+naWMcvTm3m3nRQ27TVK7y/+A9ZD6JnFWs3xfxEpvBLc+WDZWoTcV4K404lrr7cY1wpiqgyan5oRwOJY5/d/xiHS1JIaCRBTo9OllNnUmzRz8czBHI9aWFE7E7JXI9DegzSsMVNmpNyBVWD/XemOabRS/Q+obkSRigHmtgVE1M0afIraqwvY3Q1ZGJQP4swRxHaE7UDTM80T+mqg9gQ/hHukdJco2A46fblISIgTVHq+Y693n/zEdkZAJErlhC0RyhSH6lvsvtrUjpCObDMYqw9aQAdu2qgrDOd8RYvOSjEClQL0xdmkqr4Xm6DYv585xIEQktNKWglWHwWPza3lc7xIZBNPZJDa0nDU4J9nUgZnD3KsaXXkHHFeM6xiaXx+s6Hp7INPxUrMVTGne55O0DDOhKZr5QamkwgSNnPTTXqCtrWwETbCW5ozM/Ze+kSX/Apm0ZlWCbh9pPVW0dDhSq63HzqEtbXwN+F/BF3ZI2CG+UzjTwDAKhE5E185YhEPS7G8wKEmpdiSA1yVfgzOwLRly4VL2slhMbU7o6teRP8Foyq93owDglCs7sAfJA0en4T7SoZl9zSWvT9Lkb1kBkZerTOqtYX+175xDeWb99qT0UaPOEcGuAOjZONitRtFVN2ztZezKohb7F6ikw9GnyQn5ySVKsFqZU17eIEE+2kg+/qS+0PGGvFAqqpj+ywBk0QvvlF0kf/4HNg9eKFy5fD1Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(346002)(376002)(136003)(366004)(36756003)(38070700005)(33656002)(122000001)(66446008)(38100700002)(8676002)(86362001)(91956017)(8936002)(64756008)(76116006)(4326008)(71200400001)(66476007)(66946007)(66556008)(6486002)(478600001)(316002)(6916009)(186003)(5660300002)(107886003)(2616005)(83380400001)(54906003)(41300700001)(4744005)(44832011)(2906002)(6512007)(53546011)(6506007)(26005)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jRog/dIirDVsD1AcmN/6Y9UwhsvhJz6muo9C4gKGPEGSxtTsEQrMx6+nQFmX?=
 =?us-ascii?Q?TsifjL1oraepAQ53p0p0ajIr13Hs+R699yoYiKwYD60twbBkJgHhqRQAmx4v?=
 =?us-ascii?Q?pZpO1VyQdhoN60Kh/i68PnX5cIvmx7+2HNGg0vn+bh/rw4xR3EZZhHuE1LS6?=
 =?us-ascii?Q?PurT6x5fgJ5NTiQ3+mhKdLHxg6Oht7oydo5zpymRCTY9ivM8krDCZHxcAKQI?=
 =?us-ascii?Q?fueJledmAh6+ywrNhRjf0v+Q/40hF6t2SCsByzXlr+jqQa4BAqy9CzMoNTrI?=
 =?us-ascii?Q?PTqE62uEqk8UeflNiJjiHacPYHBZHIcCW0e/zapSA4TrGMCAK+aD2Yatm1/Y?=
 =?us-ascii?Q?86n1kx++9qCXRbIM3mtMasCMGtWOtGwWebVshUWEzakNukN+pgn+R2wYgbnq?=
 =?us-ascii?Q?dEWTyLr5hP+SCBd5iFfDxPe6juhsQ42xxIE1hQrbX/6XHBVRnsMT/icrFz7I?=
 =?us-ascii?Q?kCpLVh3UXO3r39yNX98kGtVj7P7LSac0zQ1ji8WluBXRmuGP7HQ53i1tkWT3?=
 =?us-ascii?Q?l1fwBp8BYL9doefHqNL87U36SdGq0lhMVO2Dgv+pJRrMApaYm9fM/VvWyC78?=
 =?us-ascii?Q?tlkiI4p7wAYblMs6EtmKG5JBaq7to7ma3PoLNNve14k5Hkc82FBQhpIR/pNa?=
 =?us-ascii?Q?XG/50cCRbZOy9xLOLtF/Nyw8Izm2vsa+vUo8IUoEIj17o+gp0uGQSsIzHpaw?=
 =?us-ascii?Q?ZR42jWKQWE9Vg0gQjusWBsKBjA51/Ki0kK89aMJv4ODd7anUSOu3aKn911Kg?=
 =?us-ascii?Q?9VZVc6h0Lr3Kb32I/wiikHZaQqEVQ/QFTNe4qnJ3iEpDrRGdbOhkPsvSMWUV?=
 =?us-ascii?Q?Sq0k0Z9aUDmndnN3rcj+hfhHgHyFvvRmta4GDHZtZc1+a3/dtZ0fIG5rIiGk?=
 =?us-ascii?Q?A3BIBtaOf8aHNDe/quLyzJ2EMChMvTRoJ1OqZrTWGDn9RCCmzSjzVuKKhM2y?=
 =?us-ascii?Q?IdxncTQXNU89La9xmfgMBplsPyV8oc2KKVtHU/3FErfuF6TVEqVgYDHwRxfD?=
 =?us-ascii?Q?xgONytjCdarSfsHlEiEjdCtymO8ps/a9A71yrpD7m1KgsRX8ooXpm3+ZUJUS?=
 =?us-ascii?Q?SV3vyPmTOl7Ic9Iz9mnVixPKOsu7agBw6d3/y/DOxDxeOdh4OyDG86pODlXD?=
 =?us-ascii?Q?rxhFC9/HMBiVjBjVkaDMF9ajsnBjJdQmDQ0KCp4Wpav3ADFKVEOyIAxcxc9n?=
 =?us-ascii?Q?zeJ/+HeKNtMxloq6hIYAqZT9XFBTVGCyEAekH4feZv/lYHveZJe1UkW7+yFh?=
 =?us-ascii?Q?F1xfqNwgiatb2b/tRXO8NdFCeZjOvD1ElpNmmjvAWG7gu9PsrLz27REKsugQ?=
 =?us-ascii?Q?d6B0G3Vx5P934DOMYLfRNaXAUGK5Ep1Ll56c+w5dvcoJZLo6eS/+i1nsSCtb?=
 =?us-ascii?Q?LB2LpRDTcuzeIi89EoukRsbQ5YB9Eyz8aBl3UwyCTThq+vludETnAj13z42T?=
 =?us-ascii?Q?shjGW142Lc/mS2o7pnUVsBePZVg8wwmLi0IPkui4CZdSLKh7o2nYQigx5qjt?=
 =?us-ascii?Q?oCBYoIbTzerwvQ4KiMGwViTMu1SmUtzigTEng/y8Rx0JvlHCu24mYBuYCdm5?=
 =?us-ascii?Q?y73z4R9YBZFW01Sx1nO3LIRRd4K9abHe61RcKndbkiyeLvxG47pT7Nly3R5Z?=
 =?us-ascii?Q?3w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BD7CA6165674F145B76C233197507CD7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbbd5d13-33ec-4dfa-0c9f-08da73dc2025
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 16:37:29.5332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jYO6LQMFLSeOeDo1YZjlt5l6Tb9Yp15MFoHSTHB6irnkpsl33HKzKfNJFhKBmWf+Za12tx1w2l2YgDcMWT0Ni2vny3DSIXcPY4+wlXA06Ng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3788
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_07,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=975 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208010084
X-Proofpoint-ORIG-GUID: O5UJnVIH6pUA_KEWNEOYjBfY6iTL539O
X-Proofpoint-GUID: O5UJnVIH6pUA_KEWNEOYjBfY6iTL539O
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 1, 2022, at 12:40 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> It is getting cleared in mpi3mr_process_admin_reply_desc() with below lin=
es,
>=20
> if (cmdptr->is_waiting) {
> complete(&cmdptr->done);
> cmdptr->is_waiting =3D 0;
> } else if (cmdptr->callback)
> cmdptr->callback(mrioc, cmdptr);

Ah.. I see that now.=20

--
Himanshu Madhani	Oracle Linux Engineering

