Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEE9C7EE2D
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 15:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjEaPJJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 11:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbjEaPJH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 11:09:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F9898
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 08:08:59 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VERHZR031546;
        Wed, 31 May 2023 15:08:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=JNiwq+BGSkVLWWNlyri5S+Cc1Nbwgyt5jBaDdo+pGdM=;
 b=eECbAAyA3uMWnFbfg/snnu2o2GO9Dl57z38gG7SA6t9cLKNIJ49dSbMcrChU2XdaJFGP
 EKa6NnPXardQBU4sMfvzQVyO4g2g5lBiOGFOCqzoTD0m+cZuuftnKClfU9N/wxlS44Y7
 c+7N1RQWkW+2MX9f5oZ55v17o31PeDyaEu1LGscPHkGDvt97YwTra+B/oEol6yVvrGc1
 L/IeeI3I/pmnATqdJ03T9DYZ5iJt+Z4Zsy+fu+GC99sBmqJ6jZYoJapYn6EQwR/D03Hc
 oGOrp7eXJzGnhZDFLErh5b5nfEZuo9iBhNr691Y9aGbov1FGv9QAAhZ0wlPLnFe9TcHd lA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhj4x3rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 15:08:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VEBCNR000379;
        Wed, 31 May 2023 15:08:34 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8qa7evu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 15:08:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmSnfwxn+bcWjJpT7c78HLUyx+9QfPRtZGaQZ6QE7OYbrl3eZF1ts5BYadXDExRVDV5bIAuMaaejLFTpnQj7fdHM4xFBdU3mcsucYE7ILYwjIdOcKu58Kc8+bKVxUpUsRZol5ncJAJobqZ3jRc2opzM/rLiQTZ14RNEOrJiiebXPxf7iCWGM8J+LnBuzC5BGxzMRaBWP5Fqd0jhPJnaWAUGDufzPu6IjGEHyYllglWz4hlVABuLTRb07R4esOQyuMohYcU+lMqgD4jnXMHA2JFpwXW49AI4ckEj8vMQkfcbdP2U7qX5psAgP/55BRnlzM48d9OWLi+N0ZFEqWP8xYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNiwq+BGSkVLWWNlyri5S+Cc1Nbwgyt5jBaDdo+pGdM=;
 b=l2bTi7TPR2Uvz3eP6gz6+pWxqJiCghZdSvqdH3+7k9LyR45ziWLpLSItBk5VNhqsygwaqrV5RvYWCyp+F5s2SAMRjQ7I0ouH9QAj/ghCOQCZV2YURmk1iu6Hb9il05/j57ox+KIpZ2rnh87xHILL0M2fIWU/u8NVhSsQikD/rNK+kyJcaxkgvIDQivkd9d8wOGl/nW7FsBUPKMQmGzgG8z85blzFaDTJNewT+8HYgWHD1WNAqVWSxxY9V+eIqAf4UevyJ6ROjcW9eFCgeR5wowkBwiTvxq5l5iPJ3CSLO8dijqH47O4AOYEEe/pUzOSFmrrldp4KiHUyGKwS6HplSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNiwq+BGSkVLWWNlyri5S+Cc1Nbwgyt5jBaDdo+pGdM=;
 b=Px8gO8xEoIL4ey0QIW8p8GHV+sb21yAOvPBgbMTV5RsTVUF4w2P3Np18wumW10QyBQ4DOWq+paNHxHf6BM9d9jEla+prdCJEuQClehZvocTZlDpIPjl7hoQXCAgH3PmA1scQSTyMuY9oToCpbNvSRhkMD0n/UrhJ8IvXzKd0cvg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH8PR10MB6359.namprd10.prod.outlook.com (2603:10b6:510:1be::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Wed, 31 May
 2023 15:08:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 15:08:30 +0000
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] scsi: hisi_sas: Convert to platform remove callback
 returning void
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1353ch738.fsf@ca-mkp.ca.oracle.com>
References: <20230518202043.261739-1-u.kleine-koenig@pengutronix.de>
Date:   Wed, 31 May 2023 11:08:25 -0400
In-Reply-To: <20230518202043.261739-1-u.kleine-koenig@pengutronix.de> ("Uwe
        =?utf-8?Q?Kleine-K=C3=B6nig=22's?= message of "Thu, 18 May 2023 22:20:43
 +0200")
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0039.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH8PR10MB6359:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b81a714-5068-4943-21f2-08db61e8e522
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t0gbLiBY1PD9LxewNUuP1/WuAaW6u4kCngOJSjbG3ouRP2LvAqTKRfIounuh68DcYp1WzPYjOnEVn9x/3ESFsV2zb+7EHUVswPMkkZrtbm1chBQ8wGhDQu0aeydlszCX8ieWdSUs0PqOVXm/FJswCjxXX9dRGOYV64GDOBNQh5LcR5hYMwIjKjBQpbOCKwoVyzrNZlOiKFkDLKPcMAaNdWJem+WTf4VrMjAe0tnJw45J23ScwzfJsdlCPZMqeqt/vDd+nrAe5emM3F6qoffamExtxwRaVv0M0EY1rehFxnc9Fu3FdAhm43gcJnbhWfWtgsDuEPUAX/MnSOmqUiEE6NudgddDZi0FH9oQ3//Btsh5gkbWeCEFuSkQo114UzFbPob9fHYv3j3l1arHae+xfDOxcOXTCD7HFzQ89GNfyUUVxZ8kXD1nQTunerd6noJovxv3hBnvfyo5Zw1aW12KpSVomwj4OezHUSjLfhDZJVHvn1inW7cEi2F2tE3I94xljKjirPYJSLhlChVi3RHfDTzWv8Rqff8HKyppA5LSq7De3N4P2DdJowzX3YBUnNL/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199021)(2906002)(4744005)(478600001)(186003)(6512007)(6506007)(26005)(5660300002)(8676002)(8936002)(54906003)(38100700002)(41300700001)(86362001)(36916002)(6486002)(316002)(4326008)(6666004)(66556008)(66946007)(66476007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VDkt0+5Yx/IFS6oGySKxHjRqCo8MBd5mcTlEfAY1CfN3y/8Rdzh4isykF3B6?=
 =?us-ascii?Q?kMLU0rJ88xP+BbVtTlkAj/Gr6UOGn4EPxqSjBeKmy06SWGekHy5gJGcbr0lT?=
 =?us-ascii?Q?NWyhC+2IHqDCwKgIgCpvta+2XFJ/yIBQCjnHyFja4/KVmrZPKQ6XHeqyKRId?=
 =?us-ascii?Q?NGm8n/oueEm9+3bxtoC/bFTOIQrWFt0A+MOghVwGHcOWaJZJIIzQ+7bCI2Vt?=
 =?us-ascii?Q?H8vx+QWaAxS6EeYbroZcVIKLIYMjG2HRgMozGSWi2GC+UFQO0jsu+TEl6cPO?=
 =?us-ascii?Q?Snst+YixTQxkoeZ7kqqEoWpfZc9YKcZuH+cUSR3bQsGwrezEsHHHK+eSAT0k?=
 =?us-ascii?Q?MAkkoaqIIwqRMK390Y9ZCCXSn5b/xVbPeDMg5Pjri6SQDZjdvAJvd2j2aprI?=
 =?us-ascii?Q?dWsxkRgX1k0dJ3ZE7GpyqARVTujjSFcoXRma6kLBbPpiyQXyqf7sMsAHGBTl?=
 =?us-ascii?Q?TmspGdKYkxf/5JzaDH7h6XryuNqvqb+ye/9Y2/eXGysJ6jCLA5vRGEOuThYw?=
 =?us-ascii?Q?oSWgYwwGQB0tgXhXqcJOZQlEqlA1PstAvJnMOojiaT903WZ1c4eUkJ3fqYpt?=
 =?us-ascii?Q?H55AdyX7e5Nb6Pb9x3UVdv5fmUdbkp7xtBZAmqD0cX29z0oZFK+JjBnHhR33?=
 =?us-ascii?Q?6DZXKg0Xqmc/nq3aXOktJ/eAi4w3uOCwelMFjD7b+XQ1oxWZwVpM1ufPrdOD?=
 =?us-ascii?Q?rtlpvXPaxz/0edGWXPrMwmO16l1vWuoWn48C77VcOOGWc///n1RqhdhNPiAn?=
 =?us-ascii?Q?VXE1zyBDv3sGhDr3qyyMPskX03thgRbw0DrFMWqWQgc20xm5V+BL1w87eTYb?=
 =?us-ascii?Q?3vUDWQdglnR+tnJlM2UMlI456FVFTw9emnXyh8zifmKk1gwNMYg+7T/w/qIE?=
 =?us-ascii?Q?H2DrBlyeE2ErKs0eu5XX57hL7N/c096DypuQ5giUaEOnDVTbbXwdeksgssxw?=
 =?us-ascii?Q?/fGl5wVu/DFSLgjT8rcsWk5wS3Ml3MEhWtdQjofJTI9z2hico9Vl8URAUQ8W?=
 =?us-ascii?Q?4M0c5qHszFrvRfl/s1m2jj0j96RCHfBkDuYBKzCOUqbHNBbCpekpi30NIjs9?=
 =?us-ascii?Q?eiU7wgGAKcGBQNWZ6H3EWhETGutCfLV4fNlVP4V2Nx/4jHJCYZd+a1gJCwty?=
 =?us-ascii?Q?W3bI57V1Taht0XjpqjQFNfXL6pW7xgLtoUIaX0URjTBma9MjDuW2Rl8TgJJ2?=
 =?us-ascii?Q?pNxVaC196WwtQHf5hXdh8qehxeWK+H7l/lEhWgLSUyiDUna4ExYukNfgY/qQ?=
 =?us-ascii?Q?iDpfKuJfRxBUjGQ+HMILBc4/LjD3CzwTzM4YzciejIqqvZy9NdF+LWkCrnLb?=
 =?us-ascii?Q?Xrh09zTHdC9pZ0xa/bNxvKh2aUwulzr/7hnlKkQXc2HLece8hYq+5Yg4hToE?=
 =?us-ascii?Q?0IAE1wz4UZpSBZ8G16xtZM0Rm3eLs5C9V0NNHG5O9/fIkaRlbjCoqUgX8yWR?=
 =?us-ascii?Q?eqVHVkvMI0C7nQKoyoFMGkojAuH5bY9QxfympovXUxBoMg0uYiS4+tyvhCGT?=
 =?us-ascii?Q?58JnK6a6zNbCWhe5d0EzzxXFzT95f8w4YaNBue8HyUKQVPlrsvRM9jw2EfVl?=
 =?us-ascii?Q?LS4YB/IprNooWBsoTf1Prc8a+qm1KDU43ymTwcQxskMJ1QxuFKfrMDuNfwUn?=
 =?us-ascii?Q?zQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: QQJ7BgzMDqCjj+ebhcVQBk7mizfa2awhWZ/KLnJ41y/oVoAVZnTpYVH/Exjg2J7Y3JUitf8yGXP1wn5GEh0RfdCT9OFFd/53RzDqQ12e6dMhAV5EpLdTuGwhHAg/LjwH90IjYyzYA02QCG5xIsslxosnW7NaA7w42KxKTHfkvYkH9fZinLDH9ifyl5cMRVPyuBVAH3KwfIG5rCoFJXZStZuqK14gCc2EneI2cAdsb+zNA7MyApE7NzQ8VYtnzjZRSBEH5PUtEXbo5n/tPkv8Cf2sGoAIAeJ6dWFFnpG6/guj8rY7aGIHqlhiIrxVz310mov+zvq3ziSJgZtDRg5lgOAAYt4yWEQvA5RlIAcKFK/JpYA7i0iAhaqJg7aDnzfkBZ+Qfm4lpnRyBvxRJq8RG5zQBXeTP1WqnSZdC++vYmNb9ZiKT2VJWddoqeBs/LFgaA3WlQG1g1Pzj3TfAyRsTS20+ukuJ8s5lniYKkycAffMWaWIy+jc+bQs07eOkexpr0TYRCEnG0IIAxLc1bUrTJ+K0y/9M3unWn9pQSpz7Qs6h46wyuAWTb7aNij3SYBiq0xjwcFKGbCZPS1nCdhssiZthaQBw28qs1NwUdNF4ahp82E0BVEY2htq/QsiIRCNInIBX9FyCf7IGyiaI6jEPgbXhR0YC9ytkzToyz/uITVyJ+ao8O697tsm+lU4Bs+IdQrNavmL9FNRPTp4vMBwKvASnoOVWxTWSHOU2/eAarRrVbFtlnmmqgsfVww0CurfEo620poc00ihSk4Oix0u5yxMCWJt9TJsfRLsbleRkLcMfHyOX09tGV/zGy3BoeoAcIhQDmmTKy7xOcJgOx91SQttq7r8ZEHZyqeVGdz1cuYkwNHyWruPvlZNfW/mVKXp
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b81a714-5068-4943-21f2-08db61e8e522
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:08:30.8894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jvAjv0Mt988cLquuOS5WIuPjCIIGjI1zZCACiYz2GJ64g2BOBjZncNgr1v+l9sHuYNj/ooYcZ4ze++jJvFKqEs0C3f0HsaGXRVYXRlWqrqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6359
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_10,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305310129
X-Proofpoint-GUID: 9B7C4x33hl2k-HYVbJiD8DymmvuP4396
X-Proofpoint-ORIG-GUID: 9B7C4x33hl2k-HYVbJiD8DymmvuP4396
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Uwe,

> The .remove() callback for a platform driver returns an int which
> makes many driver authors wrongly assume it's possible to do error
> handling by returning an error code. However the value returned is
> (mostly) ignored and this typically results in resource leaks. To
> improve here there is a quest to make the remove callback return void.
> In the first step of this quest all drivers are converted to
> .remove_new() which already returns void.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
