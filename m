Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7FDECAAD1
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 04:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiIAEZS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 00:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiIAEZQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 00:25:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C4C53D25
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 21:25:15 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VNml8s028365;
        Thu, 1 Sep 2022 04:25:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ESIi9D5/fqQVJRCwv+lLlDzeWwRzP0W/gsoCyZWRvew=;
 b=Mq4CFzxR/IVzGjJw5v7ZdlpgjFyi4+6dXNGHyJMQIGAvvHzyoLOrUarzuzRvkMRjZzCN
 SD4b7BMkVP3IvmMbNX6lCzk7ftX/PwYap4ugJEVnA3/YmVEo0AExK3hNWbfNGfM5tqwG
 /pWFo9F7fg6wmQK5SELtN33U6QIwPmpnCzSlx1S11ZcSw4evzjfeTHtM5u6Ln3hQtLAG
 ++HlMYW5TvMSunbhCpDY9X00uNAYunGnpJoWsyS9Vyt0VJmD/oLXlbbFRqSFkJHRva+k
 L8H2SC+WfBq3BsV5OVaIlB7X6z980QpN1V8YBPEshdJOavik9XAhrPhnN4VPL3+SXxhr gQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7a22axm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 04:25:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2813UVjj022060;
        Thu, 1 Sep 2022 04:25:09 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q5s0u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 04:25:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nol4hG9gCJ6xwYTdMBSn4bKl12OpTaxPAanxUprshE9/B3A5IyT4Oo4TMrY+h4Re9HQqnJpQmYB6lWskILUxA9lCHIEkj8KimByAEks6YuhLlKYVBIinAg6CQSxxWkBTu03G3r3n37x6T4iDouQNB5f+uaDdvO0c1kMg5glCJLP5lm4Jz97OPhECuZROq8tTb4Ci91SQGcUsAtTlrqd/8leyVKbpazDtz8qH+kLRGffzv7xpn5gKm28s3LAfckImoL7B6Ew4Cu10Sbf9P9KO+c/rJVTlSuFmr1m13k0XWemorbI0wCvch2njn7iS1FTA6zPviQbvCY4SwMv2nWen/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESIi9D5/fqQVJRCwv+lLlDzeWwRzP0W/gsoCyZWRvew=;
 b=AxKGpfzTOq5CPpragiHh6jNNhxNECJTdem9a/VEztpgIC2RyoyREe4iF3ILxkMVrVUqnQ4JRaP9SoIC7MOsJa+sF+Uh6jqZA98nHe7L8Hj2JAvmNR8ZwEHKTDwAirXSOqyLf6TSGP6agedefa9704u0+wbTi2Htc7YnX4Kkretyn8VGUQDn9Jh0RLRUJUlMF/zSxu8NJ7/lNEHbSz5KVrGkwyRWEEl6ZTTR2YMJqFPt0qbybOJ09iKe4R3crEHuAzebFApZORwsPzk789yHyEq7Erogx9Af7vIjJv0A9FuvqBSB59DDHWK1rElBOZEw8flYinwnHFC4MJjDSn3gQGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESIi9D5/fqQVJRCwv+lLlDzeWwRzP0W/gsoCyZWRvew=;
 b=q4clCTs71hpDEv5BPwQXE4J1hnyWC3/knP3xGYue7bsbxE76TS3kA2IW3dI4u91MDboblAEs4abOBdPWFUJNmxHpXkjNyfILCEW3bVZD4yd9EASg0pk+8MRjZJcps7zoeMzLOVLVXFRjXKWOkyeEOF7gci/sO2k4Y78wzfQ9qrQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4489.namprd10.prod.outlook.com (2603:10b6:806:11a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 04:25:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 04:25:06 +0000
To:     Mauricio Faria de Oliveira <mfo@canonical.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RESEND] scsi: qla2xxx: log message "skipping
 scsi_scan_host()" as informational
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rn3n2ln.fsf@ca-mkp.ca.oracle.com>
References: <20220825120159.275051-1-mfo@canonical.com>
Date:   Thu, 01 Sep 2022 00:25:04 -0400
In-Reply-To: <20220825120159.275051-1-mfo@canonical.com> (Mauricio Faria de
        Oliveira's message of "Thu, 25 Aug 2022 09:01:59 -0300")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR18CA0009.namprd18.prod.outlook.com
 (2603:10b6:5:15b::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c322157-6b11-47a8-6c1b-08da8bd1f2fc
X-MS-TrafficTypeDiagnostic: SA2PR10MB4489:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gpKDa0Oac0wI0+z/cf73E7rlDIvu5ocYNziZO0VMBqYAHXJUFyveRlHu2TncnF5zyROx4LekVuRBkGXXdQnZRSBD1GMtjtETbwGwwDJDleFor+p2b/dJFF1u4q6YBYlc2AA7P5MVz4hMRT331mSk0LTdlUD+xYCK9NwfQ/BxDnClCerVuIUp6lmzgMdqX73/90VKGRBssEVsBbp1d+dDgLl4AmA9lohxntNYpq7qreiSvPNrX/1Wa+unBIq3PiQCErkR0NH7ZLlWj4230/GkxH/leDhgujCIQyEvEszKvD63UKPNweiozrWcX8H/clQOiolpqkxusY45MRRdfq2H2V0FcUyMYNk6toVo55wG23iqXfJYQTWueVZwcc9UixHhxEFdHFeT8HufExkhye5WNG0zpaLOAAbGoWgrVi+Xzkx098Zriw6Eo58GY9IaDBjoR+9MFSCp9IWykEeCH500rnIP/A7eMpJryc/LBbLyxvW5BZB7clKtBl4qUAr9WycZ1Fom7SQOpaIYZdVZxBL18GBKu4HiYI9JjmgAzhs1nUCwTFGgTgiCZrQyWAZY4QtbgatAPQkDqsjFH8Mxsj1P71nP7WZlmGRYc+STHPspiyDCcQYJCQzmFi7MmsarRBXADZ7jjkqbhWLuP8xEVXMnSAasD0yC1LRdjSrzK2UBqaCUSvpZHZMtiX6iFytqkw8ipWcLkP4XD54X2PeS6wE9He5v7vVHVxpI/7A8OL4TqGl6SFfiuVf0BO1xBPuTuj3Dz9LtYtzpS/jp26k4fEAPPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(39860400002)(136003)(366004)(396003)(8676002)(4326008)(6512007)(478600001)(66946007)(66556008)(66476007)(83380400001)(6486002)(26005)(41300700001)(8936002)(558084003)(5660300002)(54906003)(6916009)(316002)(2906002)(6506007)(36916002)(186003)(38350700002)(15650500001)(38100700002)(52116002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+kL1Ne8NUJv61Zg8a5EEOFpHIwuaSPf7SBkt9cojUNrH3XJbVB7Xg1rNqvdC?=
 =?us-ascii?Q?+rJDLYLprthbbHVmzIr5todap3QEfC2lsweQvIx6sGXm6KHybtEWDwlmYwla?=
 =?us-ascii?Q?uYcPlfs0zmOfEiri6siHoxF2nd2XBcSEqilWb7Xn4iBYcKwGqc9iqvKpX/JR?=
 =?us-ascii?Q?4yYtzZuxasLIeDvpbWBwCBQon0fXVp1ToCyR2VqjQLajvVHK6ZBXuW70OI0b?=
 =?us-ascii?Q?Pp8sZMcHs8g//iAgESyVyrcRxS/JHUR5DHiRXdoxc7XUhQBoMWKvLu6b2Izd?=
 =?us-ascii?Q?VDGrE3yhehwgeA5NiLyJRxvqIMpdAWhQL7ouH9yuKYYhHvnmZRA/5RH6sDsW?=
 =?us-ascii?Q?jgfFjhA8NkM43qCNkXzQZiLp68quPoOK0jljEJxjum/DJcNL6925chWflwvc?=
 =?us-ascii?Q?SnWIbPEU5odqhYuupMYIuZhhdZn4k9M0enX/6sRVw9WAa1MEujEmnN1HXFZq?=
 =?us-ascii?Q?TGrzaCJcXohaRl2IiORxPxoi4jATH+v/+ppaAHLskENSQsPPk9Bq9QQhT9CB?=
 =?us-ascii?Q?rH0z6J4hbu8S/hVqEqiA7a7OqQHf2Z0EeOpix0LHsDTfQV2DCu9W6vdmgUjZ?=
 =?us-ascii?Q?GAxQCjBynA/gGfoixEzKxAmUwO0fcAtNJ0X2s0FCcmq9cwhFEhCgf1M2Nmt/?=
 =?us-ascii?Q?UdyQlWB3tn+3WObZMENzBiX+fKRoLSmACmH8trCh5lCr9eXISe1yJ6DdDRyc?=
 =?us-ascii?Q?iEWz12nGxXvSFx5nvN1/rKQ6zgMuAxuAhy8v9HHhtWbGth68TjNWiYvHf1rw?=
 =?us-ascii?Q?mjTYq+PdDwwn0ErQhjCe1XiCI4B5MD4bJbWsxpJg/P4mbjyOmDd2aVJqBFQN?=
 =?us-ascii?Q?VFjzoJEJ4fcwT7R3M4iXVeXlZiLZVCI/w3ocLA5Iqt8tjcK7/IO+XBWpWZv2?=
 =?us-ascii?Q?2ySU3Ua9DJ43k/JmCxrWJKcPKuPOqXerdTQa1cQAUXPPXUjQk7aLcSGb+Hns?=
 =?us-ascii?Q?50Ix19wgmYQU6ji4gDK+m8JR5so6jN3/lrcxLUoX0qDZcvJUTOjoEOAAu/yF?=
 =?us-ascii?Q?CBVXIX+IE1HFLmXUK6jMI61L3D8YDfz6qHe1P3b3F3/MgTYPv4LOWW/TcZd0?=
 =?us-ascii?Q?QG8/KhQNW2m+VU45oelazeODEDMcZZN/WkpMJ3EenfpC0qkiznXFtIjUHaXL?=
 =?us-ascii?Q?BjMCg0eVv2kQ5f2MIFMeDYwFv37YhE14n0ybY5Qy6f3Er49hWjxRMfHoOWh+?=
 =?us-ascii?Q?LcJ4mREVhymEv1D4DIxD13OkRJLjeqZhKcKB/yocjqhBitVGkxjVZSPcxRLn?=
 =?us-ascii?Q?QG9gPsHLSq492Tn7DiGEzXOHms+Uyr1ZatBFnbpvJD385agoo/BLelSxDoMY?=
 =?us-ascii?Q?50iAWuwSLTatDZlcZdLc5m3OInIRc6HTvrReTurJGD5/EAQGqG3Jx6JA5gx1?=
 =?us-ascii?Q?UugxJgofvJCJy9WYZeCFd4hzWKIrAsiV/gOwvPt+bs/K70hD8hYePbHX5RoF?=
 =?us-ascii?Q?8eSvyocQ7vTBwd92R86nrlSMWjsdK2VL/MPC7mKBuXXFWWjSj9abkf0PiTBv?=
 =?us-ascii?Q?OG9Juk/9f9uQdGwa67KGTqUWenC6ROG3E8SjtusimnEvLTJWcnUXXOO9Q66C?=
 =?us-ascii?Q?+3Wnal7zG8Nkt/qHgPPeg692EPJd0I+DN1/q+FniUu08nNlJBz6lGNq95BDW?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c322157-6b11-47a8-6c1b-08da8bd1f2fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 04:25:06.9277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Te0Q9m6/KwHRSWKdqgQO96S+9DeleHH+zr5+lhABS/D2pJo74IUiMtXN00h/75ZagxzEU75cLfux8Gim1l8IZYiaEzX3ix2znKFjOwT42jw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4489
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=973 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010020
X-Proofpoint-GUID: l48Mq21I3btzBxTTOkMHKvWFkL8oNGOF
X-Proofpoint-ORIG-GUID: l48Mq21I3btzBxTTOkMHKvWFkL8oNGOF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mauricio,

> This message is helpful to troubleshoot missing LUNs/SAN boot errors.
> It'd be nice to log it by default instead of only enabled with debug.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
