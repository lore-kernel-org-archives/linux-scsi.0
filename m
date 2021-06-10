Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3FDC48BCD
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6903D61421
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhFJDJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 23:09:18 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58586 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhFJDJM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 23:09:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A36d8g057109;
        Thu, 10 Jun 2021 03:07:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Kh25ldvxh1jht5+9V3bciieUMloh34sXaJEYkNLlE0Y=;
 b=QExIHZnbUvyBVYC/r6PfIiyt4EfwfxVWIHd1CRGEk7ZgNAxdvl5MaNreOYkJN8QrZlMs
 OZLQ/gwSROR7vggZQi8uo9UnnxrpJdkk48LtVAsAdbjScWoQcp7wApYchyDyPegctlGe
 fHCWTY5Pk46BgA41IosKeCYLophoBlfVR9mFk3L5/XCVrtcrxYP8j8PxEtVvhiQYFBxV
 pad+GeTnzfjNHNv4XxKqH2aq31t5cINKwNrgyi1z5syRThyubqpMAPTz+UcYC7NDQR2J
 qZMUpAECakLM/f99VmVPDmEr5it+9kmMdHhxQaM6y28tmXTG6kYL706Kh4wzs4qXikIP 2w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38yxscjsk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:07:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A30x0a014837;
        Thu, 10 Jun 2021 03:07:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3030.oracle.com with ESMTP id 38yyac6fqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 03:07:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pg4ZguuP+lF6QLp8ul+/npK7fo87yXYj7sHRm5GhPwpQZ/eLcmUO7fhPhTGdUb7EY3K1T3PYvG7LJX35DnKD3DwcBgzdjP7G+xM2yhkOv4biR6Aj1i+05uHka4nAM0ME3tna1wyeIU8rV2U7MjeeenXg7+JGm8/j3UujSqyQ27ZIRQnM3uqkckxB6CXIY5BP+2PbChYkDqjbxwJu0n+fRfRqXzUYg4g5bMUIXITsUp37wVX8X37K9gI5TUFJmoL1nJJYLGIH2rN+0OwNhmiJdpk7TcZiO0HHlS5SvfPJejAWEX5T3v5KYa3AVvaIZ7USyFR1w/1NTrffpdQ5g/VxMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kh25ldvxh1jht5+9V3bciieUMloh34sXaJEYkNLlE0Y=;
 b=U5wLnHoB8UFHr0QVwBsgOttSSqROtcY3fR0WplbDnq6UPSs35LCYc33ulpR1W3ilOFoKlK5CY65sdzBfP3Xn3Uc6HFBJirmS4psKeOVH7q/1Nv9c4Kgg2A3zaG3g0kOUekM6UhbAZT7BF6nBu21iIBIVFv5rkuXgsDX1FbT84Lw3RyaxeyeXxyxsjWesdU7fMWFY5fqaznsVvUNm3hFt0AwzOJWDZxKDeKLa0wMoI8JK0U2ZJ+mdbfN36Atgtqd5scHSxvniT/QyOb5i1bftB1Xb4ZHBYbSCt50TL6Y/GRyoYoFLPFFzI5VZrP1YsKBEmY5m43a0OusCayYM8SU6Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kh25ldvxh1jht5+9V3bciieUMloh34sXaJEYkNLlE0Y=;
 b=iHa7mCp30GwEoAOwMv8EWAvxomDy126WYlg9PADGOj8Bs3lEzAMgzpkgK1eiz9oNcnBRCo3EiMIpVqX+El+uxDXys80QjhGjc4povz4fPSFoBwgl+o+LrSyVz4OykTY2LbuaC/A1XUAvm5RF2+RtVLr0MG+/TTTGHUw0TUEZnMo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5467.namprd10.prod.outlook.com (2603:10b6:510:d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21; Thu, 10 Jun
 2021 03:07:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 03:07:13 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     mrangankar@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: qedi: Fix host removal with running sessions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yymh0yw.fsf@ca-mkp.ca.oracle.com>
References: <20210609192709.5094-1-michael.christie@oracle.com>
Date:   Wed, 09 Jun 2021 23:07:10 -0400
In-Reply-To: <20210609192709.5094-1-michael.christie@oracle.com> (Mike
        Christie's message of "Wed, 9 Jun 2021 14:27:09 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR01CA0035.prod.exchangelabs.com (2603:10b6:a02:80::48)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR01CA0035.prod.exchangelabs.com (2603:10b6:a02:80::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 03:07:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71991999-3a98-40e2-69c2-08d92bbcd829
X-MS-TrafficTypeDiagnostic: PH0PR10MB5467:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB546724DF98452F63673739A88E359@PH0PR10MB5467.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3awvW1MsyXsHbqisDa3T7TcIwzmeihdT+KILPJKcyQcJaoGsp8cowZC6EA2bcFA00tsNhImDv3rn+1f1MWzDX4YiIsDuCfKPcBilQbSFw17O/Zlfsno7YsivuXNwm1oAdNw5rPpqDMAwzpSCXBkkqi7xkrAhkqJJ/2cTJWvnBdNGeWcqMBcy09E4TPstDBldmowrrJDN60OMOev9E046aScovs/9N2bhiFCop8/Vuv17nIM3PiSqZoByEOZgUdrw8fQitF4Pn4tvsWxymcKZMxNWCEATs0IN9yubrZ5krc+F2ejgwH99rOzscXnbk5BK/kBH4Z+qisc4yG5hy4hYHmekLPwHLz0Thdf+/WtDiYJcQrmpnqJcFdHpc2jn6F+g22MVRcB3x1+/E5PfYd9iLb6hUDo1eu16Jh+n2ZnjQF8qCvr08XHqA0qOpMUFKVOioPWWRnF6kEZdXBQLYNREAPnsD779vQCnST0pDpBjdEy62Z+o9S6+yoFuysu5it9jZbxWw65xo1JNXps7wp9WSPusbGIC2xAIAWyz7R1VQvVLvRHfEg3iRn8xHEeQoQdyRTS6EREu37MzKIXpDyh1RFcsZmqJ1IE7TbLUtXf0GAXVXmw7OeZIltnFW47GET1GXH339a3oxjS4+m6tBP7EQPERyDAyiAmYikuj0ipYtbE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(39860400002)(366004)(346002)(6636002)(316002)(66946007)(52116002)(7696005)(2906002)(5660300002)(36916002)(26005)(38350700002)(16526019)(558084003)(83380400001)(66476007)(66556008)(8676002)(8936002)(38100700002)(86362001)(4326008)(956004)(6862004)(55016002)(478600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tom5ZjT5c5bxYhenpHwlsTlM2kbomdrrDx1oUeFrFRWsy9muGGEk58UNBGCJ?=
 =?us-ascii?Q?c1Y6vdZMPricD9TOpc0Oy/djfkZ2yl/0Nil41pfkhCaZn8R7WNwe8Cij5J9X?=
 =?us-ascii?Q?zCXfVsJ7of/7+4zVK9u8KrM4EKpPGQ++MGva5a/sJwFKWOprTzF8POlUs0bD?=
 =?us-ascii?Q?PJUU+0CNwF1krOdBJirbL2L9X9aCgdyPl5r5v82KPscIz2BxPxlFxE8FwI06?=
 =?us-ascii?Q?JVxAYp0SZf8K2p67Xp2SlVEI22YPIEvJyfhdgxGD50l9TiqlVHf4p+u4vubr?=
 =?us-ascii?Q?Yhe9m7RE3El2qv61E8Y8eYCBxOzWeLkcgxq6XrRh903infn+DrFh8d8Q4Yg3?=
 =?us-ascii?Q?osTjFfYve3s4JME48mYkDxwGV/cHcvSPI4Iwxk7j3x2tq9l88raph2agUruq?=
 =?us-ascii?Q?dUfnXBS8+gM2sgzIIeJCLd6PRMeEer0bBP/58j1sphM++zLifZIgWjvCDurE?=
 =?us-ascii?Q?wj4CRRlhkAwBKIEg41IKvnuqRCVklyul4WpW3VXcU7FgJ6Y2z7NvK2obT78w?=
 =?us-ascii?Q?P+DsrakAKMrJadbgbQglmrNVH6DNf5XjrWVU3cu46muL9HUP1DK0eefR8G0p?=
 =?us-ascii?Q?dgevAXV8xL/pI/q8MI0wuQg+7qMtUjgvzUBdI6gzjZONIOxgurbrbohtR3xu?=
 =?us-ascii?Q?qdupwU4awHilfDTAX0TyHa3/TL7Hbrq/z0tV7ycx99LbLrCosGRn/szPZMa7?=
 =?us-ascii?Q?fjgzIpH/bgkmDSIPkM6XhyTAI7bq9spA8eG9CJjUtn0juwD9Ttq8eieogZ/F?=
 =?us-ascii?Q?80G5v0l5XCjGbaITWb3HiIODuVZi8fXkzN5HTxdUUtRQNmw/iJT4sHnFtOxV?=
 =?us-ascii?Q?/0Vs3NPT4WwPK/ajez+2i9rYrJvUeaRI/xM0Tbwwil7kOz8QZCqX+NEUa+SI?=
 =?us-ascii?Q?D9sChCkQn209MLK+IhGA86XXMdyjGB7rcpgKH0mGSc29j6jirFrIEqIJvXj4?=
 =?us-ascii?Q?6pB3DU90BaBz5d1tTBvokHt0TtzVZxVNzpAGj1ZBzdIwfyIlgKv6DSFJnsLD?=
 =?us-ascii?Q?ApicLIfV4FQDftcUqdEficlVCi6zyKTb71pXYwhakQlqNRcUtleHO1ldpoRF?=
 =?us-ascii?Q?ddc2rhVyRJ5UxveeeOSv5ZeHI2x2FOPaYFjNiWnZLL+fh0gVSJD8tQHoB6vW?=
 =?us-ascii?Q?63XPtxozFQL+gAgy16DV0VYOUGEsZ3DouNILfLpk3smDtpNWjylwbBDm/KN9?=
 =?us-ascii?Q?8M1vC6bejLZ/uTGEw03t9+VGjiTGP3tG24a2TpfiFbVFvvVon8oqtuox6fob?=
 =?us-ascii?Q?A5PxH5mjc9kjdoPm+gLQsa4mb398r4e7mNDC6OcJYpy9J43kJ5t5sgo3WMCL?=
 =?us-ascii?Q?84Nqwin9+pJh9fHH7IO70SIA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71991999-3a98-40e2-69c2-08d92bbcd829
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 03:07:13.1717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LfNmMeNNb69I4IpXKvRJQKvR3MUHp90+i+oIqe0NsVImp+Ah10KGAxt11cT23EeP4zpieOjxLQakglw+KST4/VxkAEVDAeuaZAQF/l23jmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5467
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100018
X-Proofpoint-ORIG-GUID: d1TMmqPd1xEDUAqzEGcd3FKsvK3QLpch
X-Proofpoint-GUID: d1TMmqPd1xEDUAqzEGcd3FKsvK3QLpch
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> qedi_clear_session_ctx could race with the in-kernel or userspace
> driven recovery/removal and we could access a NULL conn or do a double
> free.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
