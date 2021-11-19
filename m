Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A9EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 03:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A540E61A55
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 03:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbhKSDTU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 22:19:20 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46166 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232894AbhKSDTT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 22:19:19 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2rQMp000706;
        Fri, 19 Nov 2021 03:16:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PtKF73vM5DztYs0wsA5TZDxYQn1h6DLSXGvLlJZppF4=;
 b=KjCDP8PxiU3cqinEpybYudo/jHdH70tA7kyeTA4mVuSypJ4uqHbzVJrx23/AF+Ng2Pe7
 6r5YMMDQmU4/HFazb6kAVj5aSrEg2B/ZaxtR7q0dYahU3ZIrXGhHReIp7XN3mplHRY/z
 5vtkydUMj7XSKChSZADVK4SWDpCcGg+nIBsjASCG7iiAAO3qC9CG79/A1HC1IZvhqPEV
 HnJGpwUmyQofhvBg7gxU/233WCcPH62bO90isHaHC0cgI97Wcr6WRzX7ZepO8dFI+2i1
 3wz9yMxbiCcfUJ5KNc8enAPVU7FVfv8gi00Um79mMm9IVI4KrewatBLjk54o23QQ6ZZk UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd205mdce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 03:16:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ3ALG1158243;
        Fri, 19 Nov 2021 03:16:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 3ca2g1ka2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 03:16:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOoB1/DXN+KBd8oPAaru2VpKjTzMVsel9Mbo7kh9mX0OtdE28KxANDGp7QxkwJY8u8D5b24foTWGdJrnIHkqSSAFc62wZIR3SOGhvrFq29EK4bj1fCgcPbj4lnItCZrjMJxlXb3QbVAfIv6jb6uUxpMPIlDOOfDVuBrqhWdI+Jz/XG1lvBf5zjLeusKp0pq/fpK8vEOyhrKoLAASF3N+pU8h+IUDmxI4kc/FOWcYFxL5C0tE+bAHdIuDo46snIvmEQdm3g+UsmV3HA2FFdI951BBLs8veDFSVXES7J4h3vKqxXAWgHe3qkUsk4w2//I7WfVXXg9fABZLByur8q9dxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtKF73vM5DztYs0wsA5TZDxYQn1h6DLSXGvLlJZppF4=;
 b=TqHJkORRRCaCCU28J/TTJcGsaoPunuZHJWuKDQTCckbjqhGinpIlcdOFPZNrRtHwqT3t6bQv8jMdvNUyw1fLfgxU//7kfAs2GikgOi6izhLViwWJuCcCMAgTSec06zQLSRA0ZyebXQLHEvVKXQupbMy8/aB+eHoWnvH+FXBiLx4uuU2jXGJZ6QWz65p+vQMqx5JnIoWzwPbGiS3JMq6UaW9Jot7Kw72ZI2RDE5Lk0J0UWfD8mEf2SsHNwakeTd9H/i2SrsWsvVVxB/WvG4hYuVGZ3IJQ6DVdjDRIsaLDuO69zHIka2AWIOcoX0f4A2SleC+b4zbcWjwVhu4gNFaWAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtKF73vM5DztYs0wsA5TZDxYQn1h6DLSXGvLlJZppF4=;
 b=l4YwRepHRd9M793lFJaH6cuGNc8juAAFf/OxGHucytZbeF+SDCdjAAoz6TPFIPXBmXY6+4jdX4KgrhI85KhtyRf9lNKTAWVYDC45lE3fE1HcE2OYfqdUQmyfEHnnm3OOpf0NWhfXscOUhUgBTNW/gPGObmwgqHGh2ndCTLj3eec=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4695.namprd10.prod.outlook.com (2603:10b6:510:3f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Fri, 19 Nov
 2021 03:16:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 03:16:10 +0000
To:     brookxu <brookxu.cn@gmail.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: core: use eh_timeout to timeout start_unit
 command
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfvs6djn.fsf@ca-mkp.ca.oracle.com>
References: <1636507412-21678-1-git-send-email-brookxu.cn@gmail.com>
Date:   Thu, 18 Nov 2021 22:16:07 -0500
In-Reply-To: <1636507412-21678-1-git-send-email-brookxu.cn@gmail.com>
        (brookxu's message of "Wed, 10 Nov 2021 09:23:32 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.14) by SJ0PR03CA0015.namprd03.prod.outlook.com (2603:10b6:a03:33a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Fri, 19 Nov 2021 03:16:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b89b45ab-acb0-4b08-9bea-08d9ab0aef08
X-MS-TrafficTypeDiagnostic: PH0PR10MB4695:
X-Microsoft-Antispam-PRVS: <PH0PR10MB4695CCCC4CD1E4CE1439A7F38E9C9@PH0PR10MB4695.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9MsIdyd3gzO6HR1b93EuHcz3brhAcgqlyGRJPy5wBRjcvk0e14dks54KXn6kbaGFg0ILBipLjcMrANBxs16afmESpOP6KEmk3ZAnKgfcEcQ3JNEVA5+1l1DzPbD8Kbi4xIdVDxS3YTgj98WVpnqJL5TY5Pue9Opu6tlZGkYuFUIuIXzx8O1atjCiKKGVwPymYIS0MyDAj4dpB3aJjZeRT/1NdPFojiYfv5qmBF9L5pMa/tGXeoojy6DByrNgmNdPYhIrPfdXALalcTzDQx8UuC7ITLPDvBgADa7wafVltGzo9KVPnRB317fqHOgbUEZ7wIsZ/l5RHGE279hYS3yHv7HYfzrGfxlHFhUtpfywKy3/K+JmI169VXffLzEbH2uxvGTxNxJI4gevWhaji9eqTTgM5r6fn4156o3JEriTMW77zD0L1rdwwqUJcslhG4nKgq6amcTD5mrO9oduEabjFrDIn9v/p/fr37ca9k3vKJqMbK25zaIJX6rTT9g3RWkA4WROizYjsa/dca5QbAtk/KrN25Rt3gfVMx7U3knMSA6op0KrQCtVteuEn/MQflm8h3yxbXD2rT2mrbO5zgQ5tQ7YQpqJmrmvpIUmJgiAa+1rPON04i/41U2Qwd+9FOqotgb5PO4GtOMUgTD9xbgi/4m696Xw4+Bg2caOacHAad2pgceHH9VGeJ6watnw+6Vlxdq/6l4MnOHCZUrvbCWYNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(6916009)(2906002)(55016002)(8676002)(66556008)(66476007)(66946007)(956004)(5660300002)(316002)(8936002)(36916002)(7696005)(52116002)(558084003)(186003)(38100700002)(86362001)(508600001)(26005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OhXU75HkxIYR8tR13ztPbOoz8W9rTsrBwTHs4ZwCa1ocfu0G4gl39U8jYyrq?=
 =?us-ascii?Q?/KuWnQQb7fabzCugKkC93OxjD9WvQeBUzWeWP7FTAn/O8sIFitKDEMfeblfv?=
 =?us-ascii?Q?joK//Wq1B+Ko/bK2DkgmfWVX4r77N2bZ9DY7Ll1xf7oT17h9QlNWeCXHTI2e?=
 =?us-ascii?Q?nyA4yu7ECmx4uaAFLobz7bcDe8WcZEaqTgPvjYwB1VWOCOCagw/mzfTWimF/?=
 =?us-ascii?Q?K6cfqa4k7NFxDtBkCHdj/FgAsWNRnw2GYldAcXSjjTrxef8OYtZKFQJ9lk2t?=
 =?us-ascii?Q?/NHzKCD1CY6VUbBwU0FXkFK0uA+E/7inOQLvoDIhqXIw7d4rfZLLrkQyb5tc?=
 =?us-ascii?Q?yg0L3d38CMg5B23nc9ZgRzZL3J6WZPMiTQ4/ZvEd/EN2basd1afPON8kAbsM?=
 =?us-ascii?Q?1yNhvRDvELMOvM9+EacYfl9a8ZXWAtI8ITu4pZe8nJeSm22xO2ankyaKQVZJ?=
 =?us-ascii?Q?xXWuQc+XQmPMZak38JegD3JK3DnCTBlAKvKRXWoMIY1luM7yvAp4UmcST2ye?=
 =?us-ascii?Q?bEBZf2sqQiEy7uJYmnLud5i+Xtd6+TiS9rpRUfVKgR2hSoXUJqDNhJA0w0hH?=
 =?us-ascii?Q?ANs223eznlC5Cp04gTVxEpgsvpaKmnIBtigPVVTr/6+HEq7PzJnmuHKnSlxt?=
 =?us-ascii?Q?1wVhIsJPuW/Pxvr89b7V9Pyho7ZrNlaavJCznKXG/RONj8SHJ6R2YEkt9wbJ?=
 =?us-ascii?Q?PZyMx8cBr7IVl7US3zSSkWc+FX3aRG2/f75ArBHwR467EwE9HEI1JYyXKJjI?=
 =?us-ascii?Q?m0jo+EvmJKuIbtfNJThdj1gkaHksY6hJCNmOe9DA0/I0ccziCXGvjSrRUx7b?=
 =?us-ascii?Q?e9oOWa2q6TIYkDigulJLM9Byvpw836t8q6lVx5UPlFst16+t2BV4srZd/rP1?=
 =?us-ascii?Q?YOLsXmfKp7dgfxFdPJNYsDelSLSrh/PWB0ZkNR3KpzXB8efsaSnPdT5zIA1W?=
 =?us-ascii?Q?/woocDozA6XinKRoc7poGRjht8If7nKbKgqiIPq1B0ZfGHovPWolxkLARKVv?=
 =?us-ascii?Q?LFhwmZXwkkMLxXSLHxaKdTqHreuhn28gaTEt9Bn1bVquJnkaD/c2n4/V3mBx?=
 =?us-ascii?Q?F9Q1Dp96gl7raLMq4gXRbzQBIKpt4i21drH/yDkiYerp1pNb8T0DYp+GYF2v?=
 =?us-ascii?Q?ZwP4fApMeNRFd0yWfqgFnqmIgC/7Up2dpIpAUN7Idozpd61xp0cxUSZQy1iF?=
 =?us-ascii?Q?rzgIAub3hneb4hBIku8QsxyqIsvn/2xDOanUZ5igpvRYJtFfJ8V1smJo5dsW?=
 =?us-ascii?Q?GNDmN3i6LE+70Jy5/aiC5OEIAgK1kFp/Q4DyTueMupg0j1I9+/DXr144HvmU?=
 =?us-ascii?Q?O5aXFDXZ5MZGZw6cTYb5mHRwLXzQtJac5BnLlgOoFLcuJXm1diWhKQvP54m7?=
 =?us-ascii?Q?ntp3213Bi6jU0JNtz9/l0wHNIYkRPH4eK58UUFkC7f0649iXpYxO7/z3/BbK?=
 =?us-ascii?Q?StvwhOentj5WuX3Sfyfig1dD2QCcZFakw5BJJeW5FxHsWypVE1Go83XiP86i?=
 =?us-ascii?Q?LV4onEw1Izp9EEWjTWcrEMTRndTq2SLCZ2LH4mz2NwPka5ZQ/uHDwtcyxPcr?=
 =?us-ascii?Q?gLp6VEb1UXZjM6sdxPhWZep3FG8fJwV/D7eD/1GSaNztPGaDxnxhJgcBxjjD?=
 =?us-ascii?Q?4LXVCS491ICQiG8e7D9DW/8CkS4xMCyIAoJgXCLemCD2GKHUmbkyBiarpenD?=
 =?us-ascii?Q?Z9LRbg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b89b45ab-acb0-4b08-9bea-08d9ab0aef08
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 03:16:09.9649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BbcTskiF6jmad7rkkBg3t1z9/ZAu0It2QZQKBPnzgJb6gpvhLfj/p/yqdxK6i5zjlUCMxU3FFFVbg6cUnRZ+0vJdrTOLveRHXXRt52lpzkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4695
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10172 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190014
X-Proofpoint-ORIG-GUID: COPC7Tha9h5LZ0YlzrfOlbYw0rVMEBp1
X-Proofpoint-GUID: COPC7Tha9h5LZ0YlzrfOlbYw0rVMEBp1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> In some abnormal scenarios, STU may timeout. The recovery time of 30
> seconds is relatively large. Now we need to modify rq_timeout to
> adjust STU timeout value, but it will affect the actual IO.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
