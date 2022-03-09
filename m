Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB235C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 03:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbiCIDgW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 22:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiCIDgV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 22:36:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F64A145D
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 19:35:22 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228M8xRg028061;
        Wed, 9 Mar 2022 03:35:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=CEuh8bMsBpZq6+Z6qiUoRliFouXNJI7M/hTV5J/hSAs=;
 b=Td/2z91tpgRo+r5j4EJUuI5ecn3s7Aru5yNVV52z0XEH1cZrX05RqsATId4MMxO2tR3N
 JQdTT0n8uN1pneV4qTKT2060m2Wit5IMYfftq5FtI6Bu4RjToFWbFfqMGqCw9kQWZWQB
 Ac4BQ2/4bcUFZ4GbHPfa8isMX06FfObWNTYiyLlWTaXhdECuLJYUgThcx5E7J5v040Hp
 8AvEFvHth7ap60pMP0DQwcObjkKxjmrT/O1DfXdz8a3li9ZlmUOPgoc+lKXAQVaqCdVu
 hH7VjL78ircsbRd3A3OPRg8/BTQX+bjODtxUUwXHURKfHNwLexX09YaE8Fw0JaBx+9WI ZA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2guhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:35:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2293Z999011283;
        Wed, 9 Mar 2022 03:35:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by userp3020.oracle.com with ESMTP id 3envvm4deb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 03:35:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aV9E215cE3/gUZIZGHJL0DmMycQEuGL4dIHeRxO0J2BpKWImU6A+jmrR/Tkk1OmP6PKdmCa8+1oz1wLxkTmf7H6phjIVSm7ObgJAfJXz9XJYDBr6buWZf5Ib3Wau5UAhYo0F6jm8vM1w5EGTQ/ry4KH0GoJqSLLSiU3mGIkQApdzETphjTRm5Gmhf7Lq36bHricq8bzEI54rvbw0CSg4O2taoiwbcTnBtiIJLj2qvO/+jqqkkbqdkFQjHsB1xpGIBsV0TX9nKa2GJ0+9jj1Bi+2SIe1i+Lvn6tcpE2N8zPxt8F2UcFuk6pWJi81CqVYL/CNUSnuVEyEPeflP0qGB3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEuh8bMsBpZq6+Z6qiUoRliFouXNJI7M/hTV5J/hSAs=;
 b=IcgFdIl7yqp1qUbX2gEJsv2aQluXzWf7BwkkGB8Mxb+HxXjrGCxT+S37sxxHP1MyqJbd6jdwjH9bmF4h2BEBk0X5qi/Jk6kq1qCGV1wSL7Ulpq8DHxwbT3aw+z493eUl7J5X8W3533ox1BsGE15ANIO9xQa5IwBm3Ds6y+qG49yjv1w6K07M3W6uTPTKuUvQNN2iKAnxlsU8MX3ZWfhpbK61qfeWeExImPM/uVsEN/6OP6xgYGpOzfRGyrpDP3YpcU8iuPJpOMcvoQ3dGGiy+lfx8m/WwaBbY02Ks1AWxGXj8gejapnbo7ZJcx002FRj047KjLuQx+It2f+6orBbCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEuh8bMsBpZq6+Z6qiUoRliFouXNJI7M/hTV5J/hSAs=;
 b=AZQxxBHZqCB1UMr+vo6Dvq4M4NHaI+0d7lN5xLHRSGJ5O6/pgE9aQXmMuYRlZu3VfWGa202xrkU8Dp7Y6Q2kT4+r7zdbVGvgZuFbT0tQg8p0dcJGdJkHOue+Y3kmtKcBZgaBW6DCPBGD2pwpxrawpbKqU6itc1G+fsh+W9Dvx4I=
Received: from SA2PR10MB4763.namprd10.prod.outlook.com (2603:10b6:806:117::19)
 by DM6PR10MB3259.namprd10.prod.outlook.com (2603:10b6:5:1a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Wed, 9 Mar
 2022 03:35:17 +0000
Received: from SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604]) by SA2PR10MB4763.namprd10.prod.outlook.com
 ([fe80::a045:e293:518:7604%3]) with mapi id 15.20.5038.026; Wed, 9 Mar 2022
 03:35:17 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH] mpt3sas: Remove scsi_dma_map errors messages
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnh3kdcm.fsf@ca-mkp.ca.oracle.com>
References: <20220303140203.12642-1-sreekanth.reddy@broadcom.com>
Date:   Tue, 08 Mar 2022 22:35:15 -0500
In-Reply-To: <20220303140203.12642-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Thu, 3 Mar 2022 19:32:03 +0530")
Content-Type: text/plain
X-ClientProxiedBy: DM5PR13CA0053.namprd13.prod.outlook.com
 (2603:10b6:3:117::15) To SA2PR10MB4763.namprd10.prod.outlook.com
 (2603:10b6:806:117::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2caaa9e-7427-4c52-38fd-08da017dd477
X-MS-TrafficTypeDiagnostic: DM6PR10MB3259:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB32591C56A800A7C774A0E33C8E0A9@DM6PR10MB3259.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Elc0mC/d3V90S9BsDePLYOFfdKgtFb537kRQSnaIoTdQNiVSsGTAS0fxSWoWNKZAj6F7Zn34+7Y6zzyU3iaL/UlMUN5w2apfjwM2OQnkeMAxDzT6wauW/k8Q4TtqW7slIXY9Uofp8/SsFx1J6Ec2fgQvxIzs4wN0B0o9Ye7y2QF7AB38O0H9vGWwe8S1YSRxCbrdIpnD7E5KhM+U/uX/2+P+CFmxrXLAqcgZNof52ZZPy5vTZbsC+/FMYPA3lYxT5cvzsof16VHJ+cv/rHPouGaY0tnHcgvw2tlBkGc0fZKCz21S6VM5N9L4UNVevsSHoSOW/1cfCZJQj/EcJZoHiOwFjXguxMPK+WYetKUKs/3U8DrmCsr/MaplwDpH+l/FzamKagNg1qzu8yvr1RfmStWW28uwkr5TbnUFr2dkQBivfIVh2+Whm6bPh3BpPVUsW0p0NfVePKo+Vg3cejbTRruWKGCqYj1Y7NDXfEspDCcZHQlqTBJzXYVWNwThuBGtssIOA8+QAIZUG7caYaCu3tsZxu3JAIefwW9xZdjnd//GuaUJhCK+EFI19LgQGeLOm0zr2s9wdylxaUwj4Xr8TkXpR4vayzGywkk37NZ+x0ay0orG/uNu8k8NoA51SOgOcWEnCAb2hZ4CQd3xeA1dGaTMq1hzdPeXtNELKPS1SJ39Qu6/j9ZPZnvs/GAishkQqQ2nCPVLvsupTpr7NpxDjuM15B1gI+jd6NZtFttsMg0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4763.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(2906002)(508600001)(107886003)(316002)(5660300002)(83380400001)(6506007)(8936002)(86362001)(6512007)(36916002)(52116002)(6916009)(4744005)(38350700002)(38100700002)(6486002)(15650500001)(8676002)(66476007)(66556008)(4326008)(66946007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WeITFF+QmdoRWld69RPLc5jbuufu24lLaRnAqfhJwTkGUitOf6hBmiJo8MBO?=
 =?us-ascii?Q?nCSQEGb/r0aBjVrerm1JQhhtcXm8SPR9lkPhzZY1HNDeKj727O9ZZJZTj5SK?=
 =?us-ascii?Q?K20/Nf4k/xgcdYVAwPaf97Yw5yzSiHkSdfYU5hXD5zqspnyxVVzXGogE4qS5?=
 =?us-ascii?Q?Iv0W9s4SO2vVFyU7w8rDFpb62wHYHFfio/6bRyDWxRuPN0pwmVU0wFZ0x/GA?=
 =?us-ascii?Q?KzKjx8Oh4kkoHGVCgdNk2JZ/yMQq+5l0ZS63RceJcDkpphsmXU2gBQ5QE38E?=
 =?us-ascii?Q?uBOKidsEpnTzmPo/snDOMfBwz14QH41Jk+V4gOL8GkusafZfSk8yPw78Fz9O?=
 =?us-ascii?Q?ceL17iRrb8kKHT19n+QRfGwmpMvPprAzmJVXbjrjQt/DNRpgtlQRaeNooxdS?=
 =?us-ascii?Q?M1+F1J3owuOnBNPFt1FKvEnbO0w58Zv8NC67RFg/EPu8aG7ECD5kFtIrT3IM?=
 =?us-ascii?Q?I0AiXkNZ95z4gGpRFRtA315apJbZPfp4V4w9sluMRwa4yCUrHQmL4benbmk3?=
 =?us-ascii?Q?GubPTRPgru0Fc0lROq0FeSM3yVuFUuCnNWWqSZRCkoiONgMr2tKTiYD+xpY1?=
 =?us-ascii?Q?OvrU8Sfo393aMDPESFszydMQUWu7V42WNKsSxnZ4J7I6phAGuN4o2tFu+/hl?=
 =?us-ascii?Q?hvH43wxA3QO/hI425jSYnoSnfUVwPIKH6tKpbhPnVAavvGpNVVZOa4eVd95k?=
 =?us-ascii?Q?wZb4CkGOv7YDB/s7rEDoXmxfoglPdlVv9iJ4qzkGmgkQNM2Fai9feWbvPFeH?=
 =?us-ascii?Q?PCYK6Fpl/K46fg6jrwUTpagDXBRuAo92wV9x/Snvhs6rvueC7LKH6TnuIrnn?=
 =?us-ascii?Q?hMOaO1qwo0MOdA/e6D8MQdR7aKiEPGv56IFi6G/kAa9S3jNxFUbaVCdjQiGD?=
 =?us-ascii?Q?TvNQ70yUvLevYz3fmuava1SjGDQDDd/GFh/9McB51YwVAWKM6Zs4DaBWftf0?=
 =?us-ascii?Q?i5sGpKXrSHdQu1yI+8V3Apq5Liy3/Hg+vcIejkF6FZbMs5/ONhpajFIXz75O?=
 =?us-ascii?Q?FueOpOYeM4AjUUMD8f6wPND8hbgBU7tj6CKzQ0b/dYQ6MFeI2zr2dl8bMHWY?=
 =?us-ascii?Q?AVDBavdpDVly96SoLSiMevGTpIhpDQbTqNowfoupQcBqDhXD6wHL6aT2FKIU?=
 =?us-ascii?Q?XvZw+nd0LDpYdg+y3E0NrxHm9G0c83AalXWDRwuGEnFX0ZnVYMOl8hyphe5z?=
 =?us-ascii?Q?M/GdPLh04RDcMmX1QEa++wlT/ziStOtWPC5CF12+X2WQMPVxCbveg4H3frqE?=
 =?us-ascii?Q?TzKN4uU25e39LuQ/8u2jt6qgfwUcabMNJwNL2YyIrdJZgqdUFmh9jGaMOYKf?=
 =?us-ascii?Q?yHJIqHz82Nu+UcFVvlSBckaqvSHyCAvJwYJUG+pmq7cIu8UcSV9x+Iy83Qc8?=
 =?us-ascii?Q?d/utnFhL5fnowP7VntdhbOVVS/BjBWUukwDLHg7S13j4GKkIR9dVMeyosSCw?=
 =?us-ascii?Q?Dm7Lw2s4H9+IzYLbETB6wHjYTssfNvO/OUnaOBSHizcaLBFjkUTSFCB1U4hw?=
 =?us-ascii?Q?NlWR3bRGChe6bA9zq1LFW2B9OhpxEFyXPebyapMgX6Z8Olxh8HFwnlDQq4x7?=
 =?us-ascii?Q?fi1mT3F+9lBa0s41jbwWcJ+1fHn2oJ+2yvDOLDEHZvIclj3HVPPHqG7Y1ujp?=
 =?us-ascii?Q?KGDt/PVUjp4EWh0UC0LUPVDreo+a5j1jbGUz047dPWlIo112Ph32ZP4v8DBN?=
 =?us-ascii?Q?KMvbqGyYHjKnUBIerMWsnyDGh98=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2caaa9e-7427-4c52-38fd-08da017dd477
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4763.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 03:35:17.4406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ZLVoV0whlDcOUt/ozbnaXoH1Td0yECsCaZDeZHbwWuJp0aLOVdFBEmZEKl7kBv1J0ZOc3CUe0ndGvv7uah2EcjfzwCYu4UMxSf2nZbnKNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3259
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280 signatures=690848
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=790 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203090019
X-Proofpoint-ORIG-GUID: GL9enRjMxq9WuUzIIDRyjya4Bq6kNyym
X-Proofpoint-GUID: GL9enRjMxq9WuUzIIDRyjya4Bq6kNyym
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> When scsi_dma_map() fails by returning a sges_left value less than
> zero, the amount of logging can be extremely high.  In a recent
> end-user environment, 1200 messages per second were being sent to the
> log buffer.  This eventually overwhelmed the system and it
> stalled. Also these error messages are not needed and hence removing
> them.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
