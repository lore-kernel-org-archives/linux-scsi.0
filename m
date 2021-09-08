Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD76C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30993610C9
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351902AbhIHOTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 10:19:01 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5436 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348439AbhIHOTA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 10:19:00 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188DoIjA010809;
        Wed, 8 Sep 2021 14:17:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=uYXH3TD6eC89ubvDH6cgurHifk+lTFJqrrdt9Z1Wra4=;
 b=ZEPpA+eHH5FLJUZ07eM6/yEmrr4/v65ccg5v0KFEJerhtnkKq05/MeeKctb1WSaKpbrN
 xWai6hMv+wkaPsRR7sv/42zQllHbpiruuGoTbsgEZ5QC143ucQMNadKW3LCmGA6dL9Cs
 2Ue3rW3xaiimm1fUW/KVobE83nJw1wBy8fY+zJfeAy9z7I2Me3EJtpR+g/xE/+SJ03TM
 n4ZNk5ii4QKye6Tm4yI6apfTlI3ZyeG5LJUkcpwYfGk0tcpmq7h4EsCTc0IreOHtrSjg
 bWGLFjNMb5Gv9FH4lRMp0gq0zBj54Eu1I1n6z6kpxwjpXD6TMQMMY8GwMLh1Hv1d3ZwE VA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uYXH3TD6eC89ubvDH6cgurHifk+lTFJqrrdt9Z1Wra4=;
 b=AM8wun88sby6vU9+4NHDKIkETowH6zxSJRoyPne9nPDd6pmVSAWaRD+S4em+t0fjyHRi
 sqHvLv3rqVhNYVOG1DMNxe45R2gVhPfoXd/+I0qJWZWP8n++KSfzXcd08yzPxL7mfN9u
 xhKTbqc+SFYKs0Bo7/zhimVG7VQdL3kFqDnIbOFATsPCTTw6J/rfTMobsXgUMdmKaBHv
 q3Fzg/IgpGonOob2xl8Hm9uTSCH+w/MOlyfJ0L0ucnw3QZKUKDEBLA3Vu0b5iJDz6VcK
 xTtGaSVVhceskw7cZpFY1XiweGHqI0bJF3cz6EKxtEnhyfAJFrvusdVDl/j1VVA08t+/ gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axcw6avks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:17:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 188EA52O076343;
        Wed, 8 Sep 2021 14:17:44 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by aserp3020.oracle.com with ESMTP id 3axcpma6c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:17:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYfBWoDCgcpeSpIfDPuvkpaj03eCvXIewA4H5larB5EIEz4Jlko5ioKIeaI94mi21vBXoDxFPEJ5YIBrM8Mxccac2KwgfDBEythQ3d4o+4azIIE2iT6HEoLz8IdVNVjRM9KohlAu2I6o2eAI2ZNx+g22P48KkkmBKzD+E7As4lKPzY4QIo1eRxmyNmOk40cN1QcHa4lvt/iRlYLBCLedGQVmRndD7igVwZpJ2Nz8L8QB91a5P4JX4S6pvpS/Ekm+iISJINLwAIjZ4QGzf63Ebh6az4dz++UuADbN+KTPSWxgqgbzYmbDiMAvNZmnbRFqoHWaPO5ajvvoXxTSgM/wEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uYXH3TD6eC89ubvDH6cgurHifk+lTFJqrrdt9Z1Wra4=;
 b=Rc5ZFd5Co9cifvR5YA8T9GEPmnAz1zCpz7kWSCf/0RusaG4g2XwBzcb2PJlbK5/Yhyv5vuehBV2DeU0nzfOaZ+mg3FMjKuNWFJx7c1RnTyt4bE1XgwSNjE0GM73VUPS15WbqoyRNZZW9nuQhNn4OEXI5vpFCZzAinF6xnXvLl49hiAAdz925bwBCF2wK+PbL6ma3cFBeEbhC9EMU5Zm6+gFosR+/3VrgxRG4Ywm8gzFBWUv4sB7YjS5e6NrsD50nyNXJe5GcIiCawZPAr0IrE5rQ0iL0rAjLNuyoh8MYwwFSDxeG/VqTrVUxdnArD32BxcGohO+uIHsz49EenhCvcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYXH3TD6eC89ubvDH6cgurHifk+lTFJqrrdt9Z1Wra4=;
 b=I1DYhtIzkdKUG8UHV8YA66oHGYOBaOYdKZ5SIj9udpj6/hUoIQb8l41nQIKPavQp37BbgEnwl9afAeQ4bmXYdXxL77gg+SBTNJiUbGzdH/NfQUjiVJFzCcbVNmSoH5oNk/mzB8eT63WH3jI4GiPBoiJsr//x6L1YOUW9jlUwR9s=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4537.namprd10.prod.outlook.com (2603:10b6:806:116::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 14:17:43 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe%3]) with mapi id 15.20.4500.015; Wed, 8 Sep 2021
 14:17:43 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: Re: [PATCH 10/10] qla2xxx: Update version to 10.02.07.100-k
Thread-Topic: [PATCH 10/10] qla2xxx: Update version to 10.02.07.100-k
Thread-Index: AQHXpIN3JobLabg2N0y+n19R1J5ICquaL4sA
Date:   Wed, 8 Sep 2021 14:17:42 +0000
Message-ID: <3B76F543-EEF3-49A7-89C0-38DB9944A44B@oracle.com>
References: <20210908072846.10011-1-njavali@marvell.com>
 <20210908072846.10011-11-njavali@marvell.com>
In-Reply-To: <20210908072846.10011-11-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d22de3b9-d58d-419a-2bba-08d972d36c94
x-ms-traffictypediagnostic: SA2PR10MB4537:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4537FF4DA178AB7A2D3BFC5DE6D49@SA2PR10MB4537.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:202;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ko12tvVy+q4auMPCRfpwo1ta1h8OHiiywPxnQbYbRJjeLY4YFb4OwGeac5Dj4o2lG5b3DAH9GUlKibbpBbCvqckBvUu8oFZEOfXx1DiqXa7d9IDcXyBsv9ddK9/jAcFEMu5wE3o5gC4DJ05PuXhyZvHq4jNPo2K5mc/FkS9/AnCnxAqLthUnHr7/Mr9Nbm63EsD+dUMy0Kumex8XC9GxC5WiBXcyuCZtpK3XbQncX1DNkx61G03ZuGDb6NauohkDePXjz/5IC6zjFaNQyFsTL3Gy2ClCk99lxhXURaFsFwACK/bdAFHDOELt201rNyMRsrFfQW0EJceyTCHYNhwpe/m9gkNpmHa5pPz1jehOxaajI4rbYNjctayyaK27/3nKEB2aeaFsaaKSOyShYNPjZSUDqlKGJCEv0xJjlluXRrhH6KiKRdUJR5bZr3pyJ8f76vZnU5HAHh5eoxzOmZ2Pw8+aIo/UggbB6r7Q930Gm8GaTr1a/2+Kk33WF5+6fA63rTujoo4HcjWHp4rvq8GzXz25rj4wYCHhYsQlZPho9ZAk/x6Ce7h/Av5fG+Xk1rppOPQknUkuZ+bygfaKZJ/H6MtQ9XeZl8iebvOt0vuj4HOAqjIL1K3z8hnxWk9gwz+my5ib35Gdgt8ZW33gGzhSng9nQAFDnd4Pkuqr0USH2dBv7xYeNSWV+HCWD80765796bo/MrH+fGC6PPG2ZEPd8hrJgjp1XRdnSJ2BW1hvqqPXHW2KwQ5NbmZ/pzIUutIj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(136003)(39860400002)(4744005)(36756003)(186003)(71200400001)(54906003)(33656002)(66476007)(6506007)(76116006)(6486002)(5660300002)(8936002)(38100700002)(53546011)(44832011)(26005)(66946007)(4326008)(64756008)(66446008)(8676002)(86362001)(66556008)(2616005)(2906002)(316002)(122000001)(478600001)(6916009)(6512007)(38070700005)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0M7fjBIfDOzsw6cF2YuP+YJ6JS5N5f9J0Hlt2ZqjQ56tTL0XS+t2v8aPSqiM?=
 =?us-ascii?Q?Xl3Q00wR5R7mHY0R5+MDAd6Zu7bqH8OPTBn/nTWzPszXe0WrJ4d6xxCJ9NyN?=
 =?us-ascii?Q?6fMD2PsZpUgmiQMOxP8NV0NjTClEngSx86/BKjK33YRDgY4fR5tmo+KHEkYp?=
 =?us-ascii?Q?g/aM1oueQRapnFW/iKHd81HZ5vcselOIJ/nMpnxUWCVnvmJ/wwRZGUo+2Fh+?=
 =?us-ascii?Q?lvp/1gQcHpcp8ETPfEOyRLLv7O5tYXjXS0vkWH7iD8RGPieUHQuqRgsk3TTG?=
 =?us-ascii?Q?DyKGqk4F456UwvB/NJY8fdB7jcVywsyOOsn8Ncb8q9Ival8iTpbjiWgey/rb?=
 =?us-ascii?Q?Si+ybvaLzabsMptiSP2D//XXW0AszGNqWUx77tBgRqDhDZ4iCaZXIQvB1QYI?=
 =?us-ascii?Q?bAzJf2ucMTBOuu63yh2vmdKIWVBY4iVrlRt4eZPnbyg0aBavK0a2kDAYj0Jg?=
 =?us-ascii?Q?M6wtoETYxXTZdOtO29/tnbFKsY9ud3+xqLf3xs258d1Uqo6j/WMRJBHQ2CQx?=
 =?us-ascii?Q?8o+9sGGixwFupkdU17O2qny4T7wsQjNiiBpf9ad8UuImouqNOzuyHlOGG/CC?=
 =?us-ascii?Q?4/0Gzs9bODk71VFKSwjguSFuEFWCmq+XuOLLPyUi8f4xQilIaSEnKoY7mACM?=
 =?us-ascii?Q?UW1/gcyIKDoqLTtHuY/WdQvAQi5i5ixAjHbc9n3Id3wqpI+1+xNCTfSkPXKn?=
 =?us-ascii?Q?cw3XlWk0uqZnmEysPYsIG8cmF6ncnSoakNFzF7F2qnMbz5EZHFfx+dB1zS80?=
 =?us-ascii?Q?oig2TQGU8HktavU6/s6IuTKNL0ZGBvxIwqxAcRCBzs6FceTL/d9VbC4Nfuxt?=
 =?us-ascii?Q?UIo1VHgW07CCA6uIL72rpN1rVvB6wxug8z+GWN8Kh1Y66lKFNjeJn0RmlH0B?=
 =?us-ascii?Q?WgZWauCzhuYxj5UYvV+zoDTmAf3uIROQ2jCqI0Kds3vx8QVD+Fg68PxVhj4P?=
 =?us-ascii?Q?QzanCUnTuQkGgknvcJKZiM7ve+8PIUD+C4xpHvVuXDlXmbJ9u+SOdriuUV0p?=
 =?us-ascii?Q?e/NRv7yLvDZB0wC11SMICW9FQEh8TLvRnfErUWeCstQtgUpp5KjT53Q8T6Ep?=
 =?us-ascii?Q?k8of1p9bR/ekUIVeDJIjgt/1tRg4cMUzmrsRY1AheerhzD7Js5vhAPKMmvJx?=
 =?us-ascii?Q?uvtUZUZ/O4Ps7r1d+9ZJMGKUnfDobynm0qfAEViWV1hRihS6DdnLAAk0z1TE?=
 =?us-ascii?Q?VB91ly9RL3FCVeDXp4CAK1ZVzdMA2T6exZvq7rJb/DxzgmhESqZseigVZ9HK?=
 =?us-ascii?Q?2ySjM6pA1bzK7wfcBsPEw1anV/ainVselx1nwfZTgFC+buwmxXYDthSY3jnB?=
 =?us-ascii?Q?Q9k8fqN1he+S9fLaLNKOi4xhDd7/30ZLECXkyZPcqwunyw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <324DCCC993F0F34788D9F7F3B5913540@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d22de3b9-d58d-419a-2bba-08d972d36c94
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 14:17:42.9954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z/Bw6BdFgzlFwRKr2Nx8EI9U0OJSYWcrIF8Ih6084gZk72Ze4oAEDgh5Rv1x3WNgFOYIqbXCMcCtP7rgs3GSn8/s4C4Eu4PZ5CUAEnIM7tQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4537
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080091
X-Proofpoint-GUID: okrFewLxZbhoyDSgy3isM_e2CXlDZQQh
X-Proofpoint-ORIG-GUID: okrFewLxZbhoyDSgy3isM_e2CXlDZQQh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 8, 2021, at 2:28 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_version.h | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/ql=
a_version.h
> index 055040cbef9b..4b117165bf8b 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
> /*
>  * Driver version
>  */
> -#define QLA2XXX_VERSION      "10.02.06.200-k"
> +#define QLA2XXX_VERSION      "10.02.07.100-k"
>=20
> #define QLA_DRIVER_MAJOR_VER	10
> #define QLA_DRIVER_MINOR_VER	2
> -#define QLA_DRIVER_PATCH_VER	6
> -#define QLA_DRIVER_BETA_VER	200
> +#define QLA_DRIVER_PATCH_VER	7
> +#define QLA_DRIVER_BETA_VER	100
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

