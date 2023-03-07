Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E99C64EC4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 02:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjCGCDb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 21:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjCGCDa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 21:03:30 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8281730E8E
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 18:03:27 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326NwvYh026471;
        Tue, 7 Mar 2023 02:02:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=81LUz5FOaBpdacXVvLHpnssquAQp2zPxrCEsntqt55A=;
 b=pnYFjuFxiSzMnLnlnEOPCXmhYZ1LD/etg1Z7auqkT9aExNlvKD9HxdMlZ+MrvVAw6KDr
 74Tx6tIseAhAp5TfsN51QfBwGAFxsFRKfT+DzyhZyagbe+CO1Zcy880+iF4uBnBsJSG+
 MwRxlwT8h+a2m8vGm2OCcz+li9CUC38tQmLPaTK5A+R2mPTcDIN8HscBcf0Lq5KCfPj4
 qz0YE6YmD56IWWZh6CCN4Y9V8a5LDChkE2j5CY0Bjmoo1t5o4vGKhdp++/n0O+ZdqLPt
 tRtsCVhvsE5ghjTy2CSJQlA5C2G7QMEopfa4XctDrBt2ACnpcHGXE//GT0QrcDPpT5ET kA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4180vdcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:02:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 326NxFnj023385;
        Tue, 7 Mar 2023 02:02:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u05k3f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 02:02:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTRRzVb4tydwt4roTnBKxV2qyY8Fk6BsA1q1Hiq7wylDhYPZag3Kz4zSCTXhJOBjx7GrA5jDSmwoC8K7z7pstgn19uO5pipDbJeBoxRZpqVmEvyGZ8BWKvnwOS/brafi/756Qi14sjU68+kh642EWMU+usFSdRA66IJRGQuKrsNl+VRXWwwd5LuLpCGULwf/mEHglx/SR6GM/HwpVhkS2f/QAyaBmuf+iA+N7LRaF7vM0tloXweUGoyLa6xdygUFc5KQ15Wn6oosohPdIBt3Mes5uql+c3izcP02awZWGx9pVdUMpbGpBMl+z7aqwlDbiv2TLGuI9r3/mAdYu3gipQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81LUz5FOaBpdacXVvLHpnssquAQp2zPxrCEsntqt55A=;
 b=bN/kRrWROHawQ9txXslZoZfjSs7GBYLliBtz5eFjWS5JwqUMscsgTFXg9gSp3gn6mZokVTLj1ZYzG0trz2Nzw92JCFlUX/xTTqRoL8J51iGT1Y9JrZtueVhQQfkPv2L5EWabhhSHNeD1yt15+PvYTciwE0iUbsO150/H62Wg41dIvxW/9CtZNnTgdj4pYz7x74X9F1PnkjgpsKrQOi3Xd0xKJyW4hY6ie2cdn0N07KNjaW/Iimvii29oJhMQeJiF95Don7f6GMBWDxwijsyT5u5iyQA4M64n1uvrE6NADqftherTpzOuqBcqANYlwGHz/fx4Q7hy/F9DlhJbm59BDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81LUz5FOaBpdacXVvLHpnssquAQp2zPxrCEsntqt55A=;
 b=nvQCTWiAMkz3PhBrRK8X/nVq+xYBMS/LOqUE8SeX1Ja/C4qRhajKbW92gPFZOi6oCDQ7mpe81nbtrA8/B/y2nw1T8oTS2jGqERvOFPI1mx9YXy/BRzmu7UAlrenESbRBWqqYiWc5cdv8XFjxEqMZtuxcvRWdxgXy+MJZ3rn9uuA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB7098.namprd10.prod.outlook.com (2603:10b6:510:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 02:02:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 02:02:31 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Varun Prakash <varun@chelsio.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Jesper Juhl <jesperjuhl76@gmail.com>
Subject: Re: [PATCH 48/81] scsi: iscsi: Declare SCSI host template const
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15ybdmiam.fsf@ca-mkp.ca.oracle.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
        <20230304003103.2572793-49-bvanassche@acm.org>
        <b89d5cfb-9c24-23e7-2ac5-0176c5a7b16f@oracle.com>
Date:   Mon, 06 Mar 2023 21:02:28 -0500
In-Reply-To: <b89d5cfb-9c24-23e7-2ac5-0176c5a7b16f@oracle.com> (Mike
        Christie's message of "Mon, 6 Mar 2023 11:20:15 -0600")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0086.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: 11f71e22-e28d-48e7-0580-08db1eb0030e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: faROUf2he5f31g6BeTq8SPkQDiuZiAEW93lf7wmkKi9C+oOlWhtpd2L+UG9vnXHsk7LbbGnTFscuH5Mc3dJQv+17sbp3r/DLcQhDPGQNCOn5s2XH336h7/a+Q3CHNY/k6dNfJHkLDQ5jsM8gev6AfDZLsPG+JRNFKXihov5JgkzNWltDnL4KKRiE5ebV+K7b/AvpwgtRLl9Tsnj5fswMD2+7HuAh3XreD9IAT2Ne3F8tomziJGf/FNIOflPmaiyV52qyrzNAYo5BMcqLiF59CEvboevO+KxWX7RenXSqI2bV9HJ5ndiR9cAbUT4iO3EeDZj2nb5QmSjOG5sIOIkCVntI0sEA6KyrDK5QNPtx8Q66E8vFxbLk/hdvz1Nh9PQmIcsDxsFJwUi9AyrVRNIqKOn8uW3ysUNUCjJb7LfptskX8Ez2BK7XIlsAVlGgyBEt9pZ8PQIxroSZpSlpph5HFoZe1h2r8BgVp/q1StmdyEMtNg4WS1dw7pQa5D8mpgfdXYD2cbmLBNDBeNK3+naiO/zUjiHilcgV6fvYZUL0EaBOU8HAsEv3EGcSY+umo1k45HkAmU+gsASh8t8Wfe4Cn5fBPbAm/cjWziGYs8xqC9BX6rTuqWQNC6tbSCUojGFl3fLGfTZeNYBeyqhxJapYnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199018)(4326008)(66946007)(66556008)(41300700001)(8936002)(8676002)(6916009)(66476007)(7416002)(2906002)(5660300002)(86362001)(38100700002)(558084003)(36916002)(6666004)(26005)(6486002)(54906003)(478600001)(316002)(6506007)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Te0tS7HLnYtwcpSGdVW41otv+Of6GlRGwm+xLFo/cYKfKW3eqhkMbESor1uI?=
 =?us-ascii?Q?Gs9BGaBzaCfzg0VMllPjALtjBKbiiYN9yAH3ZPr+d+PGfnPYnC7Asu5UoeZU?=
 =?us-ascii?Q?7D3Yz83DPTXjANH4Hn3xnl8CVTFb8RdTSTwOd5CCYiQoY+xYI9YXZIaJMaNI?=
 =?us-ascii?Q?b0vfCQE3VlxHK3aal3NocQN/qsko11iyuDsNLi/0c7h12i+5YUh2UU1Udftv?=
 =?us-ascii?Q?6nZ4MniPdGt7z/knTKYpyWr/nRKzmkbusBWJBllK/CVPHyVRPsekvQ9aYhTn?=
 =?us-ascii?Q?WIiQhhXo6QPHDqkLrrbwUiXFTGI6t7IhoqLcGSCFIMIDg2QP1JEoXywrr4mu?=
 =?us-ascii?Q?IXBqelhhCgUPyxxptPCLw3sa/ww9bQzTYS4dfpncycnPo9PeSWOanOqZKFyF?=
 =?us-ascii?Q?5eXVKTvBr8qjBWmWH2EQbnWADTJaf5SAl4jA70qRg6FUELzORrY07xRLZDwh?=
 =?us-ascii?Q?rMNrSPWcdJu1mahoKJGCdGda/z9wGXYJm9DUBLGrgPKCjwfB+avcxNa+aqhN?=
 =?us-ascii?Q?goSyQBg2p9lRnQvAdugOnlgLUwHzdq2lCXM7pCj3sjwBZK+DuHwLcwireei6?=
 =?us-ascii?Q?6gRoXg8GnDLrtnM3noT+iLOjV41lgoTLSYrGGsljnuwwMl7dH6Y4xzlllvzI?=
 =?us-ascii?Q?dV7NTxVtAGgkBjUMf1Xs9m8fN7OgzbvZZS2Sg/x7rxorMDoCaQmrPwspxeox?=
 =?us-ascii?Q?/KuGOOouVLbYEPb2iTO00Qo/6H7uGttGDYW0gyDdAMA+damKhY/GEWZLA5mx?=
 =?us-ascii?Q?uSuL1OqFZ/jgA+ck9gY8lbSR9mP0i8Y0SwCsWgYdfNS2evkPmq0pJ2k/Tnpd?=
 =?us-ascii?Q?3R31hGkBHGvbbT12d4BfVSypa3i3SO+jy1a6+opYdIHgGiLx53XSmovZ4oei?=
 =?us-ascii?Q?LLuL6M1E3H7DyHEsIlKufhjX2UacMLPF571syRTk92SvxK5G1pnI3hLK/xWz?=
 =?us-ascii?Q?jSDNrPam5zz4SWy3HC35V0js5GK8zUe68ZwiJVsNP92V9Dm//mQxmvhGq8T5?=
 =?us-ascii?Q?Y5Fv5R/JJrHAfKpTjyl4EDjKPx/eCnD0a7WvNpgGhafWljkCCq9jJHFVytfE?=
 =?us-ascii?Q?0JyOEzVbdYF0ejLYlRxNuHuQ8Aw0J5WPdusLT6lc8MKS1S88Wjo/a7AiPF4T?=
 =?us-ascii?Q?Zo0uyfsYG5Pc8ldAD16mW/WmEUDDGL51ma5qNMWwto2Pqzf1WrEHHA6eHBno?=
 =?us-ascii?Q?uWMBLRO4EYOgQrK0Ai15mFj/n5cTqBVHkYf0oZObG3F9IT8W0mS0x6vpNRvA?=
 =?us-ascii?Q?oLh4eGBO65hl5gS7k1z4BL3Wxp86lfmxrvIA6wov5qWtURkxoCD6vb+o7csG?=
 =?us-ascii?Q?3LBP/z1nxMTeTeZXQDQcHmKssBZVVDr3eSJy8+MyE8HlFgNQwQSBeYKL8RDk?=
 =?us-ascii?Q?KSz+63++Ksk9uPein+IHP9ZzRLC89vxPV4YutLBx9ZjGEW0urwch2HRGJGRy?=
 =?us-ascii?Q?kCAV10lgENQVthxlSE5tAvdrNSjau5bAGYz9qCf/xr3upkBLnJq6Irnlr4Qn?=
 =?us-ascii?Q?hvnD05eHiYa1JmYKBvoT8mNwk5aA+bmHnSDsTRVgXO1faZYmQJpn9Wk2qJKk?=
 =?us-ascii?Q?FN2rSvN2+4rNkwwBtEo5+UAnGYDvyP6DGJV10E1e6zRU2EaWYL/EV19GLBEh?=
 =?us-ascii?Q?OA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?6+2vFGv/i2YjOEDgxK02IJMZN+pLs5zOJQEpTuGQM46n+G88o6W1oBE6HBKR?=
 =?us-ascii?Q?FF2RHme7DkSXl0oE1aHfvZKkAERpbJuju3UkuttN54tN/3qc84j313ePL6OV?=
 =?us-ascii?Q?paxvtSmbjXCUHpsqxYBDtgeDE+ND1KKmUDh3WGXqxq/APj+gS34IBSpr9X2v?=
 =?us-ascii?Q?i3lkmlczon26cHQYBiMuPe5PDjNzVMe+yIZLm8qJmzdZFjXdq6pPzqy5tekR?=
 =?us-ascii?Q?sQVpmJu+snViXXvh/gzx2nmACfCK7bUTmXN4lHFuSvU4R4weX4ah5FLvhIZL?=
 =?us-ascii?Q?NlB176xdgwn1NydU7WO3ZKBLTTfqSBkDIS/ZvZ0EmU/X8gM6uT03wnOdmNcI?=
 =?us-ascii?Q?oUcX2JGs81rK63oL9UeKx6mIp+pgLWB3j9/uvpM3o9EB8+MaHx+J2RxQWG9S?=
 =?us-ascii?Q?b7P59UPK4+5zwEZ8q3XUcayGzM3Yj0OxwHQcolmhtJwL8VbJW2zpIkepfOPY?=
 =?us-ascii?Q?RKY+7IuB+GupqCCNeJ05AyCPhmviI0ZmLZERlqv7kNuksrMbofrN4dAHkOvS?=
 =?us-ascii?Q?Wjv9pU7RY99gW0so8WOwRuzmDiBInhdfyszhs3VXjRVMbExXBU1dHih6ekoC?=
 =?us-ascii?Q?d0mHjCAq20vL4gF4xEsygaGpl1vI0u7tDnDgeHaqBSzNxH9Vus5zI1LmQYY9?=
 =?us-ascii?Q?qOgVnu7sKcKe1/8I/ppILOZAtWdpajYkHugnD8zHjrJLzO7fZQFNnm8WAuUd?=
 =?us-ascii?Q?2giDW6CMmPgXvuzA6WZpkXcj70S+plpO/+lbOqZ+x0mmoZ3NZtB99W9BZPj6?=
 =?us-ascii?Q?rRlQ8TR27Tv30k+MIUwS+ixEZqP+7KyrKXMzX3UK33iiLVeNLUlWo8zK+bHM?=
 =?us-ascii?Q?S/7AK7scxkAeQKA6T173W83Paoz2vYqVAxcGzIFhggHAuv2aRqc6SdNBpKqz?=
 =?us-ascii?Q?VeF6dZ8RPDlrnx95d4rhVidpUudZaV1Q2w8GtVRIWjp9SmdraueA+t1qqVQM?=
 =?us-ascii?Q?Qaari04IZzw8fetVPcGEexaXTDhtgJTLTlbh322soxYwEm4r8qfznajXp8AJ?=
 =?us-ascii?Q?1wXdVjl+sKy9wayz1oR3Plf+f5llldGEGCrI0I6xnQD0y8hUEpH1Knzj9Mwj?=
 =?us-ascii?Q?AlIior7c+o32EMF+Fn9SZNF+K9Dg65Io/NUFQO2pqGrTrgr6I4dNZmahkcNR?=
 =?us-ascii?Q?WGmS94+cKzVa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f71e22-e28d-48e7-0580-08db1eb0030e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 02:02:31.8947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JBqZdsZtA2B+nmP9S0Zyx3GBPKRsaEEmnbKzC9uvtrWNUQ8NkfIYKat14ageFrG1rOCGL5wYzJUp9bo12W1DVY1fACo3/LhaLKYt6MwdQzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7098
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=765
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070016
X-Proofpoint-ORIG-GUID: lXT_3ecB2DikV-PzZgSm0MC7DqLASfxH
X-Proofpoint-GUID: lXT_3ecB2DikV-PzZgSm0MC7DqLASfxH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The isci driver is actually sas and it also looked ok.

Yes.

Bart: Please put isci in a separate patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
