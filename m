Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28768C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 02:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E34AA23B55
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 02:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbhAWCq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 21:46:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58142 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbhAWCqw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 21:46:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N2k5fe002020;
        Sat, 23 Jan 2021 02:46:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=3Z5pVgs6USoOwWSapD917KxvDc7TXKgVrsT6hHn7S1E=;
 b=Xlr+SdJs9AwhIB9rC+HD/xeWu/Bo/tcx3p3xdF3LQD6dJsJgcvX8yr9ieuD2UxAQF9SE
 hUhLNrtPxGwWFft8gsPAw+RQ4Qm7/n7qoT859LkvOmLoFGCQrgOioAt5FYXNrwpyLX77
 l3DcRUk3J+/u0njvfIUQ0iy9KdGM65me7ru0yVbrFHZXRRzeLst5YFa4FFRYT0uEvzrq
 Gv/kJ3ccSy5bhh3xo0E6AaVZmbMepSYy5oNLqvXVq3fHlj/obMYFWUKUUiBorMVvKRit
 fz+RMx9dD6JxjBIG6W5f7Kl4686eBBJTG6JxK6PBipUGxOW9Yl9V+xyepy+Ftl3O23Px zQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 368b7qg071-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 02:46:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N2aBKV145083;
        Sat, 23 Jan 2021 02:44:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3020.oracle.com with ESMTP id 3668rjdvt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 02:44:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7ueRgd2ZYYNcnot9lIHjxjY9+zL+fqa/ULxCA9QpBGsScwnWLW/YmO9kDtDn4DIdFLMG98kdbNUVJRVC9BGn4MUVHgHm3xHlXg0HU65LDKc5Ve48Yxy9+j1jhR5Nu7jq1TUFN2bBhi3JArCJaDr+fgHnjGzVOLYWBNQETV2ZrppxUflhhPAESw7kynxGvl0n0d3KjSn7P8zLKg7FvdkbI6zSYFMov3+7x8dhRMwhtPqNTcddr0J2WCyDhTEjZrdqbm9xxbebd3JxADQPENTwtqOv+PynbRBtnXwhlqu5Lz5SGXUj8M7zERBgMCmju/9vwsY8aXpCqWKW1SxHlH3nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Z5pVgs6USoOwWSapD917KxvDc7TXKgVrsT6hHn7S1E=;
 b=cC7BYHxj5LNepWXsgI+yC2iXt5ydNllkGjQ7muMuz0QQBbwNeaDAsyLc6USW7xKD1T2PJd4t4ek6/5A8mlClgb5iwXccbTyPyU8E3gOhXP1UOgNCAGzrUloibGpsGJVYzXEtId2LqLzIhSS/UNgO6yX41lZ5adJLRj0j8s+Fas8jCNb1UhDD+1y5vMb9s2B7quWdhKauZ/gGYvEJ9tJdiJG+ElAt7FDmCSrETupRMplLBkGD2tatqYeQC8uCzK77Z6lNTfwrX5NNmtY7J0aH6Y5Mm48M4uvty95iHDlXthbMFwFZdWRxWcSGPjRv76k/d0r8DSREA609JiDeuMlrDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Z5pVgs6USoOwWSapD917KxvDc7TXKgVrsT6hHn7S1E=;
 b=VYPZlLJ7u/6emSWNmS6PiWnURlrCTkevwqy1Heuqmy/YN9HVxcMuLACmoDuK2Y30cEjFwoL9kHqDc04VOzhHplilDjO/qVTA3ZKki2GFaoxWxcZn5p6eEGTKjgzOSFSykBZWKsUeJge0QkcBavWX27RwyladozgoIRH5kO7P/P4=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 02:44:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 02:44:02 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>
Subject: Re: [PATCH v3 3/3] zonefs: use zone write granularity as block size
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7n8bcey.fsf@ca-mkp.ca.oracle.com>
References: <20210122080014.174391-1-damien.lemoal@wdc.com>
        <20210122080014.174391-4-damien.lemoal@wdc.com>
Date:   Fri, 22 Jan 2021 21:44:00 -0500
In-Reply-To: <20210122080014.174391-4-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Fri, 22 Jan 2021 17:00:14 +0900")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR06CA0014.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR06CA0014.namprd06.prod.outlook.com (2603:10b6:a03:d4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Sat, 23 Jan 2021 02:44:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ed103e4-85d9-44e0-e61a-08d8bf48be62
X-MS-TrafficTypeDiagnostic: PH0PR10MB4536:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4536432A072CD4FC4FFB3EC98EBF9@PH0PR10MB4536.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H5atxCXnPbpO/WePFSRnbFo3fFo6uWTOsx+6h3qGQLmV5ZfSNnTVfnWKE+aZX3lhdefgCRWoaYzGP9CEyMdCwkEmzxR3BuLLj6B7tPNJlnIbe7Ap9zSOh1Y5DYgJJABWKiWUT1qOP65DweB4PzlR0gCjiIgZEsUTjO8Ad0j3W17u3AxKyAkGfpgWLvMtPgVD3Ie7Tp+0mg81LuApdeecDDIZxv5qhBLFMsmec5vpGnC91awxfQ8N1civbR7b13VqZZFIWm9KaR87ujk5T/X+AjN4vQLoAhYvRLt7hUsiQkDdaH/BNhM4Fa21y60w8kMQHPRflkTPFVATV/Gi0eiWPnMs6HgOQFiknMlrueuTSuxTMiGLxJRWa/kflWHE7Iz87L3gI85C/lue1d0Xlxmh7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(396003)(366004)(376002)(36916002)(52116002)(2906002)(8676002)(5660300002)(7696005)(956004)(4326008)(4744005)(186003)(16526019)(26005)(6916009)(54906003)(66946007)(66476007)(66556008)(478600001)(8936002)(55016002)(316002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?A8oIW8rMbuwnPA1Md18BPKxyIsk9A/mDoYN/SU7MRSNB1ELmH4S+zKTKObPS?=
 =?us-ascii?Q?oZsuU8XlxHbMY13gsmNf31gXt0a4CsbqvXHsDvWXh636kO/1VTAnBDBS8zzZ?=
 =?us-ascii?Q?2/L+Z9Z9Py3SyFhAl6VF6V3NGV5nkndsljd3UTVYWgqvYnhTIgaVv4VdgG/U?=
 =?us-ascii?Q?tNbxgMaZW9rAotSnNyidexVnOKlMSe19Br/DrttILnjdYW3wDxHlDXa3aETe?=
 =?us-ascii?Q?5fW6tbdsD8kOi11pB3Kg/Ce+/QaWn8K96ycVe00Mbj+BHdnGjcaOq21LBr6s?=
 =?us-ascii?Q?IewpT8vZ8yHMBXRPjq1eitO6J9gdF4pGJ00EptRoBTpGA7dKdfwwen1CgRXf?=
 =?us-ascii?Q?Y2o1wD0RszUKYNBhtRB8TYuGWiT/YCLsxQfB6DB3TLqXFerkXDROm7P7Qp0y?=
 =?us-ascii?Q?wtwQTzphajVcOazxDfZ/WwLLWQIR3OYydyY+Hlo2BKMRxNGGWYHwBzdd6daG?=
 =?us-ascii?Q?SkP/TneCTXlQBZ3luL0DnywRdJ6E4Cmyydcr4VeVX/mRpBulnCVgBXt1XNoD?=
 =?us-ascii?Q?S29ZPBzGR4k59YEqRFlFmwE+H+3Mp3zyEoGwnqxNc8uGgPUlB5wlyiUox4zU?=
 =?us-ascii?Q?aZRV5wPRI6SY06tC5zgDx3AKVCtVheoLkmlIqaRbsQX36+jhtW7f+cUrGjny?=
 =?us-ascii?Q?SoiZvdYCr9Avx15mOdrSsIZm8NGTNP4f4h12px43xC8jNbfAM8vVOh5OI07X?=
 =?us-ascii?Q?lvAeWxvfpd5DYvl8M/FqyhhaxGU3L210u26MGH7MQ0ivW0lCRabA7OdFlZHJ?=
 =?us-ascii?Q?SusklGniKQfb6oIMDBj8i7Zbfqtnn2bWwrLZIBnSCtPZ4haEN1EGvdJbHxdd?=
 =?us-ascii?Q?HpLSl7XkHFiRHTH/ErWK7ycr0OeLXAaZffN4yLDD0f4BFiA++G7lOD7rI/f7?=
 =?us-ascii?Q?oM463X9c1bcV0HpzIohTT+YEQafDop/XDOIvWpXALur3fyU5MZnZJ6S+qNil?=
 =?us-ascii?Q?4S34jMyyBbT5YJ9+7PB+tSpz7s+GrVsZ/wjrGLdINg0wuCMDdA80rsO9slhQ?=
 =?us-ascii?Q?wbUswfsSEUr7DAtAYgMI/5U46a0+mg4wCkFwf8fwDKokJ/emNZQQkYACzswj?=
 =?us-ascii?Q?OChy/xyM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed103e4-85d9-44e0-e61a-08d8bf48be62
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 02:44:02.6574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72UKxEPr1pz68mPyyXilMoMAkcyIOKguhz+F5fcI8wnC3rG0XFP2ZYpHV4OEUfTymMPeSr46j6dfQh+pF6yu1itCfuYvY2XxemvgRyeHvzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230014
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Zoned block devices have different granularity constraints for write
> operations into sequential zones. E.g. ZBC and ZAC devices require
> that writes be aligned to the device physical block size while NVMe
> ZNS devices allow logical block size aligned write operations. To
> correctly handle such difference, use the device zone write
> granularity limit to set the block size of a zonefs volume, thus
> allowing the smallest possible write unit for all zoned device types.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
