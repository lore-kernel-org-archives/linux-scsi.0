Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193ECC47083
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F302961396
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhFBD1r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 23:27:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33826 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbhFBD1r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 23:27:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1523O5Zl013679;
        Wed, 2 Jun 2021 03:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Hxdc48bq2Kx34uuXkOpDeOLRdSNq31f6HjWr1Yh54So=;
 b=rPzvR+BaK9j49xDbxXNRv/EutFfFwoy1BgVVCqyWfUk5k0y7sYUE/eizY/7oiQpTbLnS
 03XdmbkitI9OzbXdps7Cxi59C8FE8kDRqGUtPOWboeO3JXxl4PfHhY3Ed5q9TGhKrcs+
 xk2PdxEGYnhZ+ln3xDeWt8cjhT9BKsSKvN1BqTjXdkH4UALUC+NNRyZD2/kVGdGPReyv
 2BDXL8CxhuioEUCOndirrbAaZdH7DVoSH4wndg/Rv45TJyqNmN/6iQ5EZUyC8O3JK8i5
 9zb3ik5fNo6jDdTglLzklhc6xuXklR6fenJ0Q7ERCsB7MjDsr8YROfsLh0Z8EpBBKyTY +g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38ud1sf84n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 03:25:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15239tAB179238;
        Wed, 2 Jun 2021 03:25:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by userp3030.oracle.com with ESMTP id 38uaqwvuev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 03:25:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dq6Y84aOI20dDc9IKLYzWiqsLgL4fWTTTyjWEN5E4eABiw/f6csQ5j6Tm586visF5m/K2D4fVq13nINSotu2eDM46FZHpyNrY7UfS82g2/kS6xz6A2dMLntdf7HIuJA4Mofp+U4rIgnpgtgx1Lj67J5Uwwk4cUrBqU7CiijroBlWWY4lS1yIPb5vW0x8B8v0E8bspdtOzQHi5TAZQ5eA6U1Wb0deG9BFq2jG+iehK+3bCnOSwxnjGlz7INOj5bX2WU6k/Lfccu8naAR8aIWtPNz0VJxAWEHX2Y6st0JUlQiJL48jiOFN9VciWI+YLjxCineQJrIE4r3g31kkCq2dLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hxdc48bq2Kx34uuXkOpDeOLRdSNq31f6HjWr1Yh54So=;
 b=CQNZrhMpRg4gRrNzz4HtOPZkJEF7KOB5nP7DlOFCms5GaqFQHb+cOsypWYKKOw+YFTdCV+rP6PLZY89V/zwI9Xe6HhwN1Qqe9AEjfd+VzuOhjRBroVHAPTc98PnvGYgs7QsWHeYD5ryid66Z9vVDdm60ECOIXNV32yrSK5p5OL28rC+HChe8WuWIY3ii2ftaZNEpap/cyYdNPin3oLGYwso2z+sLavgjxkzpUGluzf0ScBZKxF0d4eCj/m8NK6l/1J416C4WFo7Mr5RZhUj8gRoOxfNsgqrtv2hOs/iYlBSLPykC+EIfnEjHbnlC2rfhOtM+eE2CoJmVZITnABwWIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hxdc48bq2Kx34uuXkOpDeOLRdSNq31f6HjWr1Yh54So=;
 b=pJUgH2CqF6lUWY9qEaCOkXx0hYByfBzQ3trV+tErp1dSdOEmAv43hsAPjUe6HD7kUXadtrCDl/uncRi8OId/g4BvTapvc6GTvVWte/D4CeVOA+hMWxqoZXL4QWeZbRHBJqJsBGQOJLB5QmA0GDMxI6iOXi2U1AinA8RBmtA+YVg=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 03:25:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 03:25:38 +0000
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Hannes Reinecke <hare@suse.de>,
        Khalid Aziz <khalid.aziz@oracle.com>,
        Khalid Aziz <khalid@gonehiking.org>
Subject: Re: [PATCH] SCSI: FlashPoint: rename si_flags field
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmx5osm0.fsf@ca-mkp.ca.oracle.com>
References: <20210529234857.6870-1-rdunlap@infradead.org>
Date:   Tue, 01 Jun 2021 23:25:35 -0400
In-Reply-To: <20210529234857.6870-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Sat, 29 May 2021 16:48:57 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0149.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0149.namprd05.prod.outlook.com (2603:10b6:a03:33d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend Transport; Wed, 2 Jun 2021 03:25:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 635b6a49-1e0b-4a77-bb28-08d9257617a9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4472:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44726A15967D79751F92163B8E3D9@PH0PR10MB4472.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V6ZQGh/9RVSS9EiQMqicqNUv420H8VUJn3v729Ev99Gtpy7T4ZC4taBcK/2FyuS3XPz/9UUL+KIx0A4iiiBJVuJRrI8JKid0RSr/c8H2RfJxESrNIxstBsQppRr2KEtRIwsK4YfEyJdUayDlQd88ZKHiCS1+7OHRN6D2TGE71Y/dMvHXcvo5yx1dnXEzCAsgBWivq/bFITiDWKSAxQ7jR33YRaATJDXx4TTf6RRHZD2Y6xMh3o5Jrm1kHDxiJ+QPfAHwH6dr/rwzlkCo01g5TFwnTCRHYYbNi879PliHzpOu5bSyAvMktifzW0hkXcANqYbHOeSr+ZfAgLNnBg2WwWbHrlAEkH8Ss8+gdZfz/xBMKczCq7LrKaCWgJzIrF/8Lv/pT67kQdZxoD0A07d/eTbZJm9V8Mcp75dhSvfHWt5ew4o02Cdm3gtY3KJwFDRHSZcbQl9HnVDlR4h8eUcaWBAmPujfdjy95PnBB2NWraz/jLVbB7hwYb2MxLwSMEkfwmIa03l7K5APIVPRKlztohnAwkAaaQyOUPZlWhkBic39buSEOq6HL32za1eyqhcWzrK24cW6jJ06BnT+hrNguJHK6OctSUEiF7aLV845fKU+yV0lsgMLpgDdHV5dYQ2nshCQOQrd3q+lM9bfGXM62y8mI07IKKe9+HsoMKYCmBE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(376002)(136003)(39860400002)(55016002)(16526019)(26005)(478600001)(8676002)(4744005)(186003)(36916002)(6916009)(2906002)(956004)(7696005)(52116002)(86362001)(5660300002)(4326008)(66946007)(66476007)(66556008)(54906003)(8936002)(316002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?it9ldvzsS8shYhKicWmSi7/Z47SiKsUoxZZvFv9yUjUPG2Z9vB+937lc2aLR?=
 =?us-ascii?Q?o8YynP6JB/BnnyuuSK8qE81T7uOkeGufikOuBmScfoGUemq7oOOu4PXamh/F?=
 =?us-ascii?Q?4eOZJJ42qF76e0hPo0eetgNfH2XEyDiO+/vN55WPkShhtxW97jPaeqRfmuD4?=
 =?us-ascii?Q?P7f7O9Zh78KQGwIXkQlrByT9wyK4svTmYWEI1inD3xEuN1i8RqpIGwlON+Xj?=
 =?us-ascii?Q?C/LSLizy7or48OcV8ZnshgaxkGTa1rltX6EK0w3cx4qcc9G1FKg5T57qm0Dh?=
 =?us-ascii?Q?rDDmpCGePNKk8Mg1RgCfjjsOt2xXZwcyrpcV4o5/5ErzJy5Mn4Ou/paTvMdV?=
 =?us-ascii?Q?ucjY2PJI6dOPmK09PIj1Ik96Ll7B4AHix2jSCMUQ5TBu4L3Pp/JUTpQWd8Rm?=
 =?us-ascii?Q?FEb8SwScw2oAbgZ2M/KGpinapy6GmAHi4GHx/tAkGtaWiiuQwnNFHooAWpRE?=
 =?us-ascii?Q?OpM/KdOW7ojPsXfaOfCX7dKoKHZENqOL2S5qiqUzN/0DDwU4UfP4ZBXHiwlK?=
 =?us-ascii?Q?QkRoSiYe4sb6XA8Ub3i7TojsJ2mnywwtg6u/k4YuWy9dEeG8ESyaylRkXnvF?=
 =?us-ascii?Q?yNRfLvPZCrKYdZ7QY2ylSidj4ZVfkub6ZdzEEvNTG2M6viOgAK5GaLwz7UER?=
 =?us-ascii?Q?b56Y28035ew8j4Bj5mO453Go06B/7z6g8ZALnJeTRPQ71Gr1bp9O/fq45fQ/?=
 =?us-ascii?Q?tGQdcz1cjWIV3lg2ZD6NlJdrlQTKwhooCcrtOMjIvkg6Ql9bZoiU1EjG3ZY5?=
 =?us-ascii?Q?W0cFU447Qjyt/vqY9Hp34SNTpq1FJwIv/+9XxUnm+vJrQliUfexHpLtAApop?=
 =?us-ascii?Q?Sb3kE9KFbusyUrv9dmHUvLB/jGruN9dZKzOi9tigZmJ8CB7Jf+MwnhMazMNH?=
 =?us-ascii?Q?x0wCSU+PQ3JIbVHRWEFIxmItj0KkN/MU1p6QsL4o+AeH7qjfl4Gb+1pfnBg0?=
 =?us-ascii?Q?/Ryucwjd6YgpfHuwVgqfiVmtJ0rN2u3CsGHkvFUEzjvXB12zPSUFDMmiUgca?=
 =?us-ascii?Q?HIImJLzCDaLcOkHHuq+tYoOsotoWHeQcJKxB2IDoT1vNmftcBA9ztUfvTUDP?=
 =?us-ascii?Q?S8ptMgJ5ZY6eeKkrxzjQsNExUgtfdTUzaiwqXOYSbpTsyHnzmngg9Wr8lyrl?=
 =?us-ascii?Q?4vehhy6oEwQVAYimiYTBkFLjvf8XQ9aM6wWb4IyFAcAU1FrXRnsouKlYfjTo?=
 =?us-ascii?Q?XAf+U6h26lbAK4QxK969MbZTSP0Jw287NeeF0La6xfXJeDZpbMRsTLX6Z2L1?=
 =?us-ascii?Q?1dR4VNdx2NWBXxe63QHReIu483MHmWE6FnUis0U786YUsCltFicpxqUNp708?=
 =?us-ascii?Q?wldo7UV642dDiVk80jM7C+CY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 635b6a49-1e0b-4a77-bb28-08d9257617a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 03:25:38.3949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEIIQvK+TAx4QyNQ3HLPGuARbNYiMJDVYSt6f4qM0gDkQWd94UOF5P5PaLCwbzB8kpUbokicM4RB1IV/CX8YCNcBuDJ7EVm+kipNRl/Wvpk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=959 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020018
X-Proofpoint-ORIG-GUID: HcxJ1PZPRA1OKyapFxTUWqFlOebsgYPP
X-Proofpoint-GUID: HcxJ1PZPRA1OKyapFxTUWqFlOebsgYPP
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1011 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Randy,

> The BusLogic driver has build errors on ia64 due to a name collision
> (in the #included FlashPoint.c file).  Rename the struct field in
> struct sccb_mgr_info from si_flags to si_mflags (manager flags) to
> mend the build.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
