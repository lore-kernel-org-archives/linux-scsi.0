Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B87C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Nov 2023 23:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbjKFXN2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Nov 2023 18:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233228AbjKFXN1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2023 18:13:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EC683
        for <linux-scsi@vger.kernel.org>; Mon,  6 Nov 2023 15:13:24 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6MrlDr027159;
        Mon, 6 Nov 2023 23:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=ShTDrXmbCDoAK/TTGui/NblPhdDYGQ5JV8WfO1WKZbg=;
 b=Owyv/Qb70GutWdr2xQO1dt3naSuyg7vQ+IcRHnxPTO9ZCL5o/xesnCLPVHJTyjbl2sCf
 o8LWG+DYHsQcw9CFvYOMCbwRpCxGYS4F8Njwf1JmKSilfSBXi7pdzcNd9jnRUz36gQM4
 ynUR/Zq8dqBKe271/iPSqi0pbEhSIi5TZRSU+p9USorBUbrOcSmTIL8+J1D9yNbJCeSk
 pqx0L8I2w8jkWWuX5QqL94yYHBhCl+AqrrYkkGlFPrkEi6fIO1FRxDrmAxhPzYf7bS2J
 Ydx8cpPNfgi4IFwh4DzwLKh1et25abxQvpfeQMsWZkm9ysVSQUdUOZUdKuUoyLOQK0e3 WQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5dub4jkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 23:13:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6LuX27026888;
        Mon, 6 Nov 2023 23:13:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd5xejy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 23:13:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRBU+ow14SPjyyFk6EM8z64lWC2QuJGdP1KWgsGHgMggGz2ryY6eqC7lKUkDpM2bT3Frrz2eewjm+3s3IdUpd0Tw/ZEwWYCF8/7eUI1IhC8ZiXOEthyFYm69xDvySuNrLARDoXrmJ1AnRB10S6SPEYDdi8SDDKrDB1ZOQlCPUnUHDWD8fQYPpRl+fZ/mTo/uXuUbm21QgMBPvC6N80ckccP/P3w/J5zK7UsbIT5FBhZwVRRrXNgUsJzvEAF+2PSDeYGv/kcUNKTB6cBW1uxf0ce8pvXXLiv9gBHgw1hOZ2PvQ1WPttlaZdlx//0ni1GEVCnM78dn5khYUYLMhBoTpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ShTDrXmbCDoAK/TTGui/NblPhdDYGQ5JV8WfO1WKZbg=;
 b=iksOEo/+XyFXXjGhwWtsNndXk0rbiGocKZy9pnK9KAdG4T/FtnKMU6Dz7dMKfpUOxe1SzV9XT+KIQfqZN5L+ySfJvRp/irZHW3n3DlkqMnaXpt5xeFOvGxJ7+aTIb+54afE65SoXud9i1rcxYSkKPnZoi1yuXoNNBFmj522Eo+Yw4HN9jCSaORV3nVvINoYsop784jvttWcCoNbLUtRyJv7J4PqfFTXXpp1rSnF/ua+08rvJrMg1RYnkkbzPOP6boXxaT+MpzSVTh5Teeaj89GIsOQvMmng4Sqb0cCsTV/jPd7+LZGL4ic9oxc9Dd3QF/UQ/Zigngwho78/k02pIoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShTDrXmbCDoAK/TTGui/NblPhdDYGQ5JV8WfO1WKZbg=;
 b=Nrj4ZMlDTiJdMKETcy4YAXrwcWTTiJRYoHvmWEY7KIJxf6FK8yvB4mw6W6gH2ubrjLh7/PNqvzott4YL85HCRKBuDoHA5sqObiQweIggUo4YWk1eC63l0fXb7PqPLhE9Zvgx+HbR0V3gT5PyWAYokGdEYNqsMK4xRnVJIbljIBc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BL3PR10MB6161.namprd10.prod.outlook.com (2603:10b6:208:3bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 23:13:11 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 23:13:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 0/1] scsi: Fix sshdr use wrap up
Date:   Mon,  6 Nov 2023 17:13:03 -0600
Message-Id: <20231106231304.5694-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR14CA0053.namprd14.prod.outlook.com
 (2603:10b6:5:18f::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BL3PR10MB6161:EE_
X-MS-Office365-Filtering-Correlation-Id: df94b06f-c212-4f73-2efa-08dbdf1df215
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GbbPUe3r1GdHE3qwPOqnj24APfAVBgx/topJV4MHDetIz4FiowdN2qrc1j4SyWlDYkgSLiC1uLID6PtfpEiNDvGkbmI5zX07ofwJr2lEK8QcErX+RIGNivmShioF13nweW2i3fjXgyx8hDwo8MMbt0n0Xvkyy+20hAGbVCzyYkx51Ca3MwQKMc3Wf1JOrwxYeTQ882U246zDaBvoKfFIsOvbdNf2yjEv/RAxEA5CEQb/Brni1lICc/xLA5gmo7ZiFljP6NM4c2svF/sMMnZ9OrDXz9CNK0BmWw3zi8DZTlb/V4vxq1m/r43CLJpi9nLUMwZ6J0CX9m2rLfZkGtn0HMEzlT6SogyJYvmbISHF5Qb95grJxDuDb3uk072jFFTWVCdH56WWupRjQ8EAkOY6TqpFyUXOx0X3if0+ifh8jlDOSIlOyfiTu1Pv4AFp+OESgExGfoB9N2tQO8+aqhrUAZt63MxZPCghPyQiJxWEgl1X3xPbtYf/A75Jq1DOcUgkNbCyXZJnLZa+UUgh5VFYITc2HwCY/2idTRKIRTLgRkcsJiA80L4H4pfK3tqfBO4y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(376002)(346002)(136003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(2906002)(558084003)(41300700001)(478600001)(316002)(66476007)(66556008)(1076003)(66946007)(38100700002)(8936002)(8676002)(36756003)(86362001)(5660300002)(6486002)(6666004)(2616005)(6506007)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jjoO7l2u2eaKe1qMKF48nIV0XHx901oijyd+C0P/i/RTbb4JvmACg1SCRoBa?=
 =?us-ascii?Q?Xyq5KHi/xRL2ruA09OYJTF8dhcLMlYc/t7ukQSdHnFLh6Hm6GLOPZEbjG+Xx?=
 =?us-ascii?Q?7H9q7dqplK5fDIZE9bUIrK8NXVZ3mPabjJ3W4yGqMFryb3xsMC5BgBHpT2xs?=
 =?us-ascii?Q?p/ZvRl1IbTXW4ZkNHdLnNU9hKEr0p7WNMXTifU9FO4DwoP1OhLHQmlWU2DvR?=
 =?us-ascii?Q?1TKeLKkKxn3xDs/eNSvqNrpA8ZJH25wz7F4+wmZf9pQ9H+picyZZMi+S/I6q?=
 =?us-ascii?Q?DI+dpSsIx3b11QGypQsNcPPT9eHN86Eu7AVsWpYbN8NkNuq7O8skxvEFJxJ2?=
 =?us-ascii?Q?YoFDNOqADyMtP8rgUR+x4c4gQw6XBXN9hsDFS7dORnTrFBLr/Z61Fu2nbHCE?=
 =?us-ascii?Q?xdHCocn9skjnGl6Ig8XeFMAm436++HBRbUeVj6GoNBMKp7D+EvxRwo3NYmov?=
 =?us-ascii?Q?bIGefgwLQGAo94dCO7v5P9WHOV0XEljBvpMtsrAQ1Qysr8+8uwasF2UAaAFL?=
 =?us-ascii?Q?KiPFfbF3PsLPrJzzSurfR7t5dov4ZgbpACOuJavhBtAWRXcNnE7lOKLhUiye?=
 =?us-ascii?Q?f47CsqxAJe9LxuOr8fpQkyqyonysTODrTFer8obAXdWMQ1Ojk0VnK/gwQVsT?=
 =?us-ascii?Q?BHa+OEqByaUQTBAPIiJMgtSod4h1MZinQltXIMJDuDSIq9Of5O3WNLVq1JsI?=
 =?us-ascii?Q?aW0U//yCoU3xBwnz7Er2k+50whVnWqltaYKeV8WBQs14b7G04rH2L4UlN9w3?=
 =?us-ascii?Q?G6ozq5+F6B8HaamNsHGHJWq/rUk8GRPJ0AVGuSsiMP8KKhnWxYZxj266acRr?=
 =?us-ascii?Q?EgphhVnIkEhB2MAlvfLtD2HeM6A5+Kc/P9X94ZKJO10ca/EuZ6EgXq+Y9MFh?=
 =?us-ascii?Q?NKGJFVPkHK8e86PT8+e3F7DeV4RvyPZTwK7H7AkTPAN5KgAnKrtAN2+gVo86?=
 =?us-ascii?Q?l/34Cj+YsBx+kfvOFifWiOpLmzqz/gaD56uXZN1KB1kTyC5xDlF2/iOh+ECB?=
 =?us-ascii?Q?TyjSvZBBgW7L4YmTpYPMD5mE1LE2cYTsCT7FF7viEP1ofgOHJHJsJCXkwl/T?=
 =?us-ascii?Q?zBLvWSCvSX8Gse2ouuPKrEcxlIvRf2rKl/pvHJ40S6PyQfkA7Y1kflcdV6cg?=
 =?us-ascii?Q?fwTnQ99QmKYv7tEgyqNbKsTg0VN49Q2NZDwzVVwZG9qDEoVv4myr2WgHnEVF?=
 =?us-ascii?Q?BJ0371BTbDtrg9ltd82RGB7jFzmEE2MW9YGNTQnYM4jDZbjKEmknZ71PPbjk?=
 =?us-ascii?Q?RecXm5ig+q92YE/2LD9pTn6SWz0EjIJtE3Q+Uf/0gW7nYB9WXmikzwNH/nlA?=
 =?us-ascii?Q?Q419QOaYthLFitryterD5dUuzDmN2t/pz0a+Wcz+FbaeWaHHI+jV/WM0A4Ss?=
 =?us-ascii?Q?v4EV9CtA3Jyg2LUug4TM59wSAbPEEG6q8BTXfT/cdJjlkkpQNsnJbQLpOAom?=
 =?us-ascii?Q?hzipmgRS6TS1vCVTf+OyqeHScIh/s2Raccd/UrSaso4i3kuZ7S0iQGutvtmV?=
 =?us-ascii?Q?LgmjkJR5YOwrrDAR0mwUcweRIaPmf97wKasbVV8LqjCDUTKsU+X+ThkwXTRS?=
 =?us-ascii?Q?ZnMBLahae+eobQlV/tykJwwDWJJKkai9pI5LVUNG/kWDX/oXrHLhR/lI61mT?=
 =?us-ascii?Q?Ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Um645JDCyBddA0AwNvH3PfkXCFzJpD1kAwCFN+YiKzwuUdJJojHRGuwwfI9PCcYJpVaBcqGFZQmODVovXRvDgGIPRTGK7hgqqoOABoln3zo1e4QFHwnCPLTwhvpVO2Csu4CFPtH0u6Pml+GwAW7GBcFPn9E3hlVqNCCFfOSgbownQFa+Uh5112a3liZDmHpXAYlMFwFZDLzCeUOSWgVkAYT3dzB7ztpOaQkx78EBiYhxjPb3P5acnH7QKtYGfxNDE6xpv5sdvitWe/6wBfdFvQt9ltWOIvZ39Ja/2t1s3fBuIjZ4NsR80a3GUJslkvgHpw8n6s/y/epvOXNPf7Q3CDN6jjSkc1DyPw3sPNjNsyREj+GVtMovnPMYLkAvxJjq1JBwVB7h49BoHoVGtSE4r464X4dFjeVPtEs0eljLs6IplyIlTMVmDRJZ2Z0xyNFPLOfi59vKEdyBDL28FfOg2E2ts8XInU3zvIyeaM67VyLdxaExP9hzAbdZloTjbkhULJeMJgt/hZFcKdIiJA429CtvkjHvWSkEmyCBBehBDyRwrah68rTtDrU8gw9JjrA1jC2efYRM7cRsE/Y2USCgR66jU2wOc/DwNKgx8aB4ZvvbKVpaepZ98yJslHpcaatyaPUEJgpvTvPkBTMJmyLVBisheDzc2g7HpSAVKlwmAIqP0Lp5qtGaboxwon0BSlgNVGCrcoZ/sRIAj2QAoqz6lRYdlrjmgIivVA2Moo1qIO6zkoTTFfDtEK1oDXVN1OFGqrbNKSsxlMHBglsKqA0wpNM82Vk9nhBdVjGZUVU9Byln9+bloLJWCklPVSs4LK6xVbr/9JpTs8mwzvomlMoc9HTUHTaBbuM/6NVUzO/rxghHTf76SkJE0t3GdwhrFIE2
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df94b06f-c212-4f73-2efa-08dbdf1df215
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 23:13:11.2805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Vfy/8X7l5qdmvUk/2mTu1Tqpqn2CYf2fSFkkicTbmV3Og9D5E01CccxDOC3Jf+V4HvVBoihwr1PhffFPOYAB9lj/XR02rjTPbKKIK1Qd48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6161
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=752 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060191
X-Proofpoint-GUID: iBdPr3eAngqCAg_TR7K2R6emFHsNxcXa
X-Proofpoint-ORIG-GUID: iBdPr3eAngqCAg_TR7K2R6emFHsNxcXa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch missed the initial cut off because of a conflict with
Linus and Martin's trees.

This patch was made over Linus's current tree which has everything.


