Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB20CDB483
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 20:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjJMUxo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 16:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjJMUxk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 16:53:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D0AB7
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2023 13:53:39 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DIEBop017421;
        Fri, 13 Oct 2023 20:53:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Mhltb2qobqGcuLoi77q4JdoTXPvxibgu45hnNIVn9dg=;
 b=SVmX/INWrU/RoQ0JL+Wo6LqjwrD4fSdTg4B7YH6YGseWAb2Kbm51WbHW5HFUjSUo6a7W
 6Bl9B6Q4LVOnkYztvXMxCFA81WXhAfoNlReuVJeodg6pdrUAf7vX7nGD17oKqf9pJ/8Y
 9IyWDqyK6IbsiBrKTwDhNjxzqS4NqjPs0ixjhWA87Z4HuN/LhTspXxDZo8ZH4LtquVpm
 qaoQO00Csbi6yPJHGn9omQpKHlmb/It6B3ASSG1ICGsC25x4zepFAimI5figA4ip0U1U
 CNLESRHq2vXK5lqby+NziaVnIE74ZFe2WoUW+MdtjbeeUQLLt1TRMBp5WmevSb8uXSvx PQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjxxudvqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 20:53:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DKi3Si039137;
        Fri, 13 Oct 2023 20:53:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tpt0uec0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 20:53:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8FbglhXyfYdlaxe4VLmrhAhkfb1/1hqoFjxoaQLn57vQFMFOBj55ckbmAXyWaTpoxN30okhygfs+VySns/1B3Qg8/jSaDlzGc0oF9OI+t2hcTAfaclRPccJh/6IcYwcWARIlE5MqaBSdisViB0bO+qYFU7s/8g6pvLyaSba2zGrkUP+fJ2SdomS7w49TIjvqOFgHMRyXVKxQ2IzgFuFkzS8ZW0Qrpe/SN2Q2snpoTsUZ+7sGCnNR1aHwDmyckot2Ya/QnD/KNe7hb4a6aVrYZwCPpLmExqD2s5M0gXHwxv6jR4PGFp+H8/EwSq0tY82QA2dC37DK3FI8he6zanvhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mhltb2qobqGcuLoi77q4JdoTXPvxibgu45hnNIVn9dg=;
 b=FpbqA2F/GdydU73BDEKLX53ONxLmInb1VZn1M8xvxI5JS/da+JM7u/zeH/1oPfh/QobiIScknQ3mwhGCJAWbrPGNKI3ptT0SFvEvDIrGJnFKMhe6qsEaAM2Dq+/r0bhapi/JJ5+f2XpjsmpWslzTj1KqERQIFHFyo4OuFMXOCLTGuWWg2zSVYmSMji6OKkQ/2nvhYPxRdzt6TZ98qNqJ7Su3SZA/Fi16maXAWA8qpvr8EQz0kuNf8BoKES5HasurUg7fHS2c6R+1TRDPq1mhakdH5s4bm7DBEG6GSzJBblRDCZhGHSmtLdLB924k9Io/FDetZW8/SuGV0JY+hKY35w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mhltb2qobqGcuLoi77q4JdoTXPvxibgu45hnNIVn9dg=;
 b=XyUAlYVt3MSybHNa51+VdEv/XOi76RNNZbg+NvDXKwqVIBjznU77eT2iubUbtzfmVRU8dLtvDYt054fr5TvUHI6wlkBhx0HkiBoafSJ7wDI2oMHFfnC8eU49r+gJxlzZ22Y+zvlvTLTKHnFMHT7JiDRU27ptYktSiEo0AKXgBKY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4888.namprd10.prod.outlook.com (2603:10b6:408:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 20:53:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383%4]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 20:53:18 +0000
To:     Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com
Subject: Re: [PATCH 0/4] megaraid_sas: Driver version update to
 07.727.03.00-rc1
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zg0mjlc9.fsf@ca-mkp.ca.oracle.com>
References: <20231003110021.168862-1-chandrakanth.patil@broadcom.com>
Date:   Fri, 13 Oct 2023 16:53:16 -0400
In-Reply-To: <20231003110021.168862-1-chandrakanth.patil@broadcom.com>
        (Chandrakanth patil's message of "Tue, 3 Oct 2023 16:30:17 +0530")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0039.prod.exchangelabs.com (2603:10b6:208:23f::8)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4888:EE_
X-MS-Office365-Filtering-Correlation-Id: d0afec97-55f0-40b8-84ee-08dbcc2e6d6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4pSK1ZxRkx+LTuj+8imTQiMNXoWmKOvCY6hamjZk6qXYcHfDq/Em8OmrrSMfj0jtSLpeCJBWGSiARQOvtqUILHM6NwQKdRmP7RwpJf/ClSkjxhWJCGcTRnHieEav6gHyaFg98+WtOXDiLAtYXyDiLfglbjNVzmJnjWmnw9NQzHy6xl7uxs23Xz0F4zdaS2BKOKivr8Oz1UuberYvonsorQojK28JQz6n1ZwJoWWy34451FEHn86ObUsU6Q+0+UFXj+b/enNUKg42DCpm1nufK5sAjADnMPBx3Cz/VvAgw715yLy1OWoPbQRCReBJJL2CA+bdsap+6s0n5mQ22WcgDwITlhlvo4tCrgy3uqj/xMng6aDQBqWPkuA8qZ7cIiSsyo6Jnvd8gjIyvDFiXdWOkVufC4YdxGejWiVp0O34LupAAIpsfOw15S7b71ZNIDC5QsbyHDIb2494kX+Fe96JYQeuQPXmhk+cJ0jXtnGsidrKn/BVthqm0VU2Qk350YDKcThl0+QXt+kmUqoi3Er/141ANZvILAqlhbmftHURmHIzdsAr7k6YDzoUg1aFjddI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(346002)(376002)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(6916009)(83380400001)(316002)(8936002)(8676002)(38100700002)(86362001)(558084003)(4326008)(66476007)(66556008)(66946007)(36916002)(2906002)(6506007)(41300700001)(15650500001)(6512007)(6486002)(478600001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i4LjQ3H25TwefXweCBPWSl7Jx9hmi4nFWtiGyk+ZWXMHvdKdxFYm/xun6NXV?=
 =?us-ascii?Q?g1rLvDuX6xPbkMXxs5eVuoN5y9o+jN3fbLbQdTiegzxyAE8tMAgZzwCFJVNU?=
 =?us-ascii?Q?UdebBbQVr0x+eBIsAm6APJRZw6U1u26H7aKD0sULf0JkKGW/10h/KLLmPsvx?=
 =?us-ascii?Q?C9/cZSQoRGK0iMy7XOq8ZVf8GhC8aKHuhGFN2g6DqYplRgkKtT/DJTqfC9CR?=
 =?us-ascii?Q?XcVcneo+kEc9m5XIY5bUKzv966ijEGJLS5P0GAX4ozIA8sU+QorYCSpTsyNb?=
 =?us-ascii?Q?KoHHstZ8lffUYC23stQtGE6vjMVqPgIiLrPexIWK+YAoT1/XabkVGn63OEpp?=
 =?us-ascii?Q?QGMo4hleYV6PboOqKbrnG52rZ77/DjsgGHGRHxDtZ+b4gpss8OJ0IaqYDizY?=
 =?us-ascii?Q?1e9NNIwuEhAuY07xcPsUKdrUYwJSh9vSlIvrnuNwDq+nfHCCr+5KYM0YxCt/?=
 =?us-ascii?Q?1KG+hGB7KiB1C2wJq/7zLW+nVUsFoTJTLiilVKeUBlfNXx57IoS5vXKw5t0X?=
 =?us-ascii?Q?bufbA6oEtovbYVkIFXcDM1CF7ueTUCfNoHrvx1EoN+Cc95A2MZja8621lh5T?=
 =?us-ascii?Q?J93ey58/Ovt9Sa+i2q2TMr7tAHPm9o3PXLuzy5S1huS/5VUq0RpiPe1SRetB?=
 =?us-ascii?Q?e+ihI8vVzqFjsdg3KkL2SlDYliFnuVJD/3HDEldOQwvvwiDHguU6lAHXgEtp?=
 =?us-ascii?Q?RE221ayc7QqEOc7ir/wE4ufVne2djKxvNsAvxVQ7QGbZNyY6NfEO3Drq7xpZ?=
 =?us-ascii?Q?0w8WeGeTQi5LXXKWyQ0I6gmsrPhJ5ibduuOPMzFE/po1lsQcyu7kQDeGRsGf?=
 =?us-ascii?Q?QDltHNQUo7hn6zXrftPcpr3lBAHDMBQ7FUqP+ochcCxPxS1pWFi/7lU3os2d?=
 =?us-ascii?Q?XaLJkWz4MPFCQiL9u2/4PcheVwhx2yyLuB/ClfTtFWOt4HgvGi13EbjMC++T?=
 =?us-ascii?Q?Cw60sMJR4tEwupl/irjke56EfBj3j23VbTLZBYsoBvyTmwXVkmMryI6sKeys?=
 =?us-ascii?Q?M5TIrwCmyQt2xUn/KHBvWot46zMKzAGWhvwMbyZlmyxBTxHC550q4089Cr8o?=
 =?us-ascii?Q?ixhglSGxZAv99G2htisqiLJTyE+9sEoS9BLDKVAtJiv2yRZo3NQ+O67BjJoj?=
 =?us-ascii?Q?MYz+DP96sA0ImShYmz3roE92QY96Z4GQExLWD83zw1QYqhRhucOE2PXV8uD3?=
 =?us-ascii?Q?nDq6CnDaQq6aic5Qkripvy9Q5Ut++fSs1uF/KE99oOt7GPQmGUOei8gLqQmf?=
 =?us-ascii?Q?Eh6FD8x6O3O5XaSKkGBjcSbs1QDgPnLGzxXWDbt0c2/W4n913MGYPIB+IKao?=
 =?us-ascii?Q?pRmSP6iGdtbbb8yGYA7us4c7jtkEFb9Go1UOq8cTSLFp98zmzbttpVf5vbK9?=
 =?us-ascii?Q?pZbtSS0ofV9kWQlG4fOBd2CyNtaCDRfDEwZSgwYKB6lFAucJxX1RHQz14sOz?=
 =?us-ascii?Q?A+T0wb2Ry39sUyrhKPOL7jn6sIeiituylab6+wvUhGHhxYwe4OpJVBWZqoJm?=
 =?us-ascii?Q?SDxP4q18vF8c0e5VMCm3KQI2iVx/BpBPluFGqPeO3x1bKAI5DMyJfb0Qqqly?=
 =?us-ascii?Q?OeX2EKW7EJx93xdpgir1zZ/i4/vmmjwOo2OzbPJe/NoB0ekQlLoOWlU/WqDE?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: BWnwP4nFwSDTNxOQomp2ey20XkvtUmVDuHuWpQnbM+0DIvGsKrHUvKHQbMi+8N+sWYEZZIW+yzyYTZM7mcj6Eyqh3hiqDjXv+1xthGw4vWuwerr1WpZDk7PC28q+RH+HRqobc3bNgRKtD04/OoEoiZb1680kvH1JFWMw3QyPeAIy9lSgnCRvl9E6Cl9RsgY4sIz+z5WxpVR/dbCYodC2QSvXZTMYrpXQkVShUZ3pcMjIpoqu3CCjF5b7JwvIHBpht2wXO/lV7hgVaxmSnhSxePe10O6DofwGtOoHh7POkR+mxs8/++0jzsQC48sbIkv54xu3RWuqS/ztDJzHiZvH91aAYezJrMK6eggYJyTtTyV6m28P9CzrUE9hVZFwsSKirVWozw6p+ac+wTAL+g1iD9QKaXJo9Bvr9OgSeCCUc7Cx64tgYFB0zlxWb3fMlH1Ksw6zNHFCe3eMtHTfAjWrIdcYVOk91mMMJTu91sSIu1EIQzj8fzQvbngCT2D1Dn42t2nX/OyzvG6uJjhs3kTUWYuUpMwS/pN+MrmWckClu+L5y2DnDbMUiNauelF6Pqnpaf5nXO+3WXEpGCHbem9Aw0RKR0mBcYO4v60MCFqONU3K7FSz06O602qpTcBYOFakGkLUl8EbsK6UAO5sxtL3hqpyfHaNDBmyrXV44Ydwvi3LPUbiKwfoTx5ZfW07umbuRmkN6Iv3KV5D8cI6hAJmz+2Coej+3q5fjOnagVT4aqWFwek8HGn7AddA6Brgh9PsmAtSE+z7a/r2DUN5xfxhfmv1n2s/tyn7HhGi8vJrigg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0afec97-55f0-40b8-84ee-08dbcc2e6d6a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 20:53:18.0319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HRm7aAOuYvaeP0DegFdti4AbWcyWVaI8NPhYin+QxNJO7rUx9pSqPFzC3vuTevbJs/eZKw/U51xvkPJEGvH5VWuzevhtvyyVgZxUH9D1QUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4888
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_12,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 spamscore=0 suspectscore=0 mlxlogscore=650 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310130181
X-Proofpoint-GUID: Qoxcvb13WDNJyxmR8CldiNVXlxQTEFQ-
X-Proofpoint-ORIG-GUID: Qoxcvb13WDNJyxmR8CldiNVXlxQTEFQ-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chandrakanth,

> This set of patches includes critical fixes, and updates to the
> maintainer list.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
