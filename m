Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF82ECAAA1
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 01:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiIPBgz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 21:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiIPBgx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 21:36:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A8E4A10F
        for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2022 18:36:52 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FNnCSf020727;
        Fri, 16 Sep 2022 01:36:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=g+8ClxHB+t7VIg7rixaq9cWJv11RG7BmnWAIP5ULlnY=;
 b=2C2lbSsI2BPSq3cvGQYIhezpJC7c8oLeYQmkbk/RuHAMoMqt1m/zY9lSv6YlDFfO/6/t
 WyUZ5SivdeSf1vit0FrFBVD8rV4A093zE2lLHr9bzV0jjLczS+dOqttnoVpOC41ahvaz
 gt7YX/fywdOeJ7+xbT0iE6apnhrYW7nDmMriGzywqYByQudUDVOhRbjJr6JVOoGflGwo
 v2ROwYgPxF1A6KIaNLDrJhsw+/MJ0mQoeKce93ZCRzsvxokalRTMH+bgRBgZWVp7AL7u
 s0tnnygsd03mpe/OC5XC8sPRcwm+SzNfNEhViIKSJjzafQe9vHcSjvt2UDQXTwu0bBqq PA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jm8xc92dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 01:36:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28G0Xmmt019958;
        Fri, 16 Sep 2022 01:36:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jm8xfd76q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Sep 2022 01:36:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ze9nxyiKqvkWJSXN2+WZ/i1pZuuDuarfSXvUmpplVi4yyKrMHbWJ9SIsrFthlC50PeC2ouaCxQUNO4Z2p/fPsLRqgoeucQrzD4z3ln025hzFPy93gcO8+KlKzT51bJJiE4Jj/rX/uF0C9SMrN8UfSvjUWmtuq0C3UTiDXcJ6q5la3Qfgg5ekSNbHgSKhh1nsZw194dlppMaRIa7WJpSlH/FootTwnp5rrKLzrHlT6ytSXipZDOYIfBufpxX2Sk2HHRF5Ib9lhmGzLD2u7RIhL3fbCMRsJ64eysPSYGKDG9H7zw6RzM6A/ymETS+eiiVJdYptNhbsnMIYHZ9ZVoSw6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+8ClxHB+t7VIg7rixaq9cWJv11RG7BmnWAIP5ULlnY=;
 b=MsVT2GCVfKMwjyAyy9SjxA4bOZpiJejUri+UVTdhUgYeindMTHA6ChihOrSg70vCYvKQDoMFDOlCf83cBItntkzRPke4FxF6cVfe05I0vreCk8Iy93ShgD6SlmMGblq7hrAGvxUp33njI3UYk5tSm83A2TsOz69UWZJgJmLlfDEVLwjTRZiuoTXtqnoiN7UF0v6TJiamJwVJtrCEurDXLHwuDQtPrCb8jSReH04bMzCJM2ZCEXw1935gz7mv3oa6qnhtpoghZwu9iAYzX+zMNm2lPSYq1p0GuyhcxWqJROaKH/UJja14HX1jtE7Cm+8xCoNey3wN06ZikvQqeQX7/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+8ClxHB+t7VIg7rixaq9cWJv11RG7BmnWAIP5ULlnY=;
 b=pIuut3Nv7xmCBvv6ctM3ALXweqbJa1b1mSmL4cSM3V0DmRrY5fxu/8W6CNQdmPO31TxKO4qOFh9pl3e+rNXyQaHZOcgkPBqW7kulJuqspUNq+w1wXYB8USVKDgJSStKWRwnAh8kWWJCtUYSc9kLT7HAzdWuQYQOVYXbfc8NXZbM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5681.namprd10.prod.outlook.com (2603:10b6:510:146::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Fri, 16 Sep
 2022 01:36:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 01:36:45 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <jmeneghi@redhat.com>, <guazhang@redhat.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH] qedf: Populate sysfs attributes for vport
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgf02jbn.fsf@ca-mkp.ca.oracle.com>
References: <20220912114803.7644-1-njavali@marvell.com>
Date:   Thu, 15 Sep 2022 21:36:41 -0400
In-Reply-To: <20220912114803.7644-1-njavali@marvell.com> (Nilesh Javali's
        message of "Mon, 12 Sep 2022 04:48:03 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:a03:254::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB5681:EE_
X-MS-Office365-Filtering-Correlation-Id: e8b4225c-42ec-40a7-8293-08da9783e9f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dS2nmFPaN0tOP9Ya1ADJnucTroiydrkVKxtUSgvKDw75r3w9Ehp/o0wofg6ENUbpXGfFMr/ecIAnw10EoqACcunqiTzB2dEzqqlFmp5LeBSE3b2BuQ2QKr5sFyMPVCOPKEQGzqzWNMfbQDpp6CvLF5t/HAqN23Y+aY4OMvjv1EZXD3HSfD7Ybj6VeNnG4D3hPH7uSG/rxW9OO/0yqFSi6YdRdx36yb9MtkXVpQ6ueVdbiOdCrllL6A0yQOMWC2LXQFHEVCs/3QAi/pGsCo/GLJoL877UR/iSMixYjYZqYKqMC6axCPQixvbP7TwAqiNAYAZ45CP4VTLqE+68AETkbjScmBkPftvxC2HCjTZXAKC1uiG/mo1FYdV3s/GP13J5/bnnF/Z+YRHBIs7+ros+rChdGRWLRbHrrXcdej1dmkaCGWKug5n1W+NhHJQdAk8+5EPewHiK+FMImWbfj49UvtX+eX+R29oi6Y0IrrOmmr49jy5P9sGbONpH9I9is5Gn8oMuWs9mN56FvGYLtrx+Y1okzhhgOtOmTgAYPmBvHM1nUM2jDYauMpRWcgN9bBOYYS+sz94Gjj+2Ei6G2sB0qxgGo30dKRB/SSKgq+Uzbugfsj+AcIxhM3mFalXMhvQtKBdNGL+vQnF3Mu4qiEruZuPEtUbAHGOYLSc2KeNeSw45JCV5Sb5rK9cLpuyrApvDwXbqjKhlLV0vCcwcaycjeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199015)(41300700001)(26005)(478600001)(36916002)(66946007)(83380400001)(54906003)(86362001)(6666004)(8936002)(186003)(4326008)(2906002)(558084003)(5660300002)(8676002)(38100700002)(6916009)(6506007)(66556008)(66476007)(6512007)(316002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZW+vbdbcU/xhSG/2NLxqwk+fjlGhSJd6p3R9bkCfCmE/4I3AvQO/N6nPICEN?=
 =?us-ascii?Q?kDoJBpUC/7MH+Z7uWCwm1AFmzlftZT0rIScmEKs3ApX8z3AolfFlQlH1G7vq?=
 =?us-ascii?Q?wg056Je0v7MNkN3faeTG2Rj80msKweoyYmFuPZk64w0LdQmPhEeqXqzJHfNC?=
 =?us-ascii?Q?eVIEONYM2J1Wz3tZfqmvJDZ9KrFnRf0zBSGq/zH4b7rh5krbW6dO5BSt1eBs?=
 =?us-ascii?Q?G5xz1Yp7xJ75PakV8IGc63jPqJcoU4PKRVOOcOb9mrsw+p6pxIH7dme50C8F?=
 =?us-ascii?Q?mEv7ivpOfnJRGYxSTME+eEIkEnGvl82isEEFTlXq6+zP1rNWZs0TcUUKRGrN?=
 =?us-ascii?Q?CJyvNTkQReq0ylxv0p1aVCf4gww5jzq2v5GHuTtO1TFzZJ/wGbkcDD4sq0t2?=
 =?us-ascii?Q?7UX9CrSLqCjJ74kAtUDPU271q3/UMsOqoINtdSWlMqmIOybBIudW7LkBacDG?=
 =?us-ascii?Q?yMxvhFcECmcOWZc2kwHIQojioVuVaL6D3Rh3kGB4KqPlo2X8fBofCNZz+DB0?=
 =?us-ascii?Q?0pl8PkWm2HJD+idx7mDosACCGL+jGwWc9HZ5+2Gzwcmr8Ju2efXf19iVpbdn?=
 =?us-ascii?Q?EZcchQjm60hpc8R3+/TjTGzvjcyEJqKuBkHcWhfVq4RePWBxft7D6KNWg/M7?=
 =?us-ascii?Q?pE9RuEhBZBaBEG7+Ay7FLtAmVmjsmZPU5+dxlYfzi5PKLmz6l3KehnBERp3R?=
 =?us-ascii?Q?eYEQECGb0TwcL/JkViQh0O/y9fD0TG7y73Cu5gdEEKed4NY2g/YwK6VyfTb9?=
 =?us-ascii?Q?GFvaMmMOxf19T+jjEySIAAWjzHI9FVIaQkzJVzic77LoYYVaEqlDZOtiHpNU?=
 =?us-ascii?Q?1HAxDI8NGHY5ux6V4Tl4ldUUG16NdBS76+/f/H9qrxUS49bw0zKY57r159cb?=
 =?us-ascii?Q?efVl6Q0V41GBhdl3KtDrKvJ4H3WD6R/CQik5bj6DFlkh1DI/TwkuJbkhjo1t?=
 =?us-ascii?Q?LLpkOZJQUzeqbIYguoytdiePDiJSFE9fbFOzmM1K1ut1cR1+SkiUR9dbPPzL?=
 =?us-ascii?Q?sqiWlYpNbwlTuP7jpnZSTBvi9bb8Ma+NOz0V1RXgPSEIwO4P/T1g7IMRG5c3?=
 =?us-ascii?Q?8l1oYRhG2uc4y0LGw2blLywys84k1sp4sITqx1OkNHUFvzJvLACgQPXvy5iS?=
 =?us-ascii?Q?ioy2aDVIjREV5EHksFdMi/xOU3vYJu2bDuVPI3w3It1Tzzj9SYkhnTomGlNX?=
 =?us-ascii?Q?N7NkOS+3xk/THS6tPx/i14Mdsfd3ZZjnaRsL4yFgDN/So5qhn/Dfh80eEEYc?=
 =?us-ascii?Q?fFtTaxTFYEOEtrzy4/QGvauhwtZTuTyTfz2bLSoCPNWFJGQR3kcw0hw6IhTz?=
 =?us-ascii?Q?4HlAGWCLMiDve7SRu0e+eRPrjFM+keILHNqYvqLWxJ4wsgHdXSIjTtxOsU4Q?=
 =?us-ascii?Q?tnqOatuKLmDJKL2WvUzJmYkyfa6vqemJ1VlhH6pFCxMbUdOUp3mbrUA3+Lr0?=
 =?us-ascii?Q?6GkV2kkpuP1+KDvkhPZuCMdLjCqhIKBtB1encETD+HUOD30apG6iwH02mTmq?=
 =?us-ascii?Q?1pkcQDtF+zYrKkjRQhb5waArKPFVNOtFPkj0+5ycHGJ4hC25zpqIHplQ/Nqs?=
 =?us-ascii?Q?MwOpaDKZPy9x12yoP5yZ4Nu0Bq6mgK5P8mGiUh8pmOmeWrc6taPcqWIq/ilZ?=
 =?us-ascii?Q?oQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b4225c-42ec-40a7-8293-08da9783e9f5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 01:36:45.0720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m+MXDMu4Ks2SwUVghoN3mziphw1Dxpjsi3BRbZ9wJOo1Fo5hImz+xxyzK1suL9P07/7brBqujhyYPqsCR6YUK79Qz3xhn9SpRqCt/FJnra4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5681
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=919 mlxscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209160009
X-Proofpoint-ORIG-GUID: apMRHQdNJttvXyMBWp6Qr9FkwZAhnKye
X-Proofpoint-GUID: apMRHQdNJttvXyMBWp6Qr9FkwZAhnKye
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Copy speed, supported_speed, frame_size and update port_type for NPIV
> port.

The commit description should explain why this change is needed.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
