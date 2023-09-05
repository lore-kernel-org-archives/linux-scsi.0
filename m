Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95291CA0FF3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 16:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbjIEQF6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354098AbjIEJhS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 05:37:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913721A7
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 02:37:15 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3853OhKb028176;
        Tue, 5 Sep 2023 09:37:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=KD4GlmHLffS/EZAT43eQ3sNY0UBXpcfFpViuVi9BdR4=;
 b=qZT+Bfs7zMkc3QGcAW9XvEqguGGNx7QHVnMnTpZIkn9T7MiYALsLX7PMSiBH7QLK2HtH
 Lx+Bxo/Q+IwUaNhQxBMVq4oP7BOyc3fmAUzFTsBzCtClW1xC+E/+4s/119SuYGm6Xz6Z
 Y4goAqwt/pVKSBQ5HyvXEtb+XF8jJcPN7lFEftB/EyCfCaGl3fs5aI52BG0RaPYuDDKC
 Ns5nnJjt6knTotQ2dwmZ0UNbzhlfsUpX0WAkb5lHeIL8exN1yaZpLXi0qZCOXBobdbjx
 OemQn0oV8FXIWELxvo+IZifgmIUeo3XNgb9+qqRaBqD7omCq3nSPXQKYlx4EaNuDYLKT cQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3suuybmxys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 09:37:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3857RTre006604;
        Tue, 5 Sep 2023 09:37:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug50ybu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 09:37:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ehr+hxKZtr/z/LpUXDrQfnUFbfli8qYU6aNofC7qa4q0z8jODvCHvXK7+EWeFxS2htVHVUDWozG12uP5hRQ+1DshOhj+pOLIh+0FxWPWHXvwW+xSmxQ2BxQlGP2OX56p14/cYQxQ+gAzrtCeM+OSShDnfbjWAkRywA8IBLZ0sljsqZZKzPU3pYnY2f9u3CO6Bmtl+N2xW/9KSeRQxXYaR2Z8zkX6HaENxqNiVZPRLn7lTciy85dizNhIH/q7mBgxT5nW90H1YgO2WIYTjR2AHSk3mgA5m/OAqqpyB+Cm8s/XyMNocebtGQylKjKU/LxclTqttAbor0dwEKr42RLMtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KD4GlmHLffS/EZAT43eQ3sNY0UBXpcfFpViuVi9BdR4=;
 b=BOYz7Ar4nYkxn4T8TmCbFBYGeLiVfof3P2eWfY4DIimpAGp90XG0kUBhLH2sfaviXg7IXv/XTgQwi/p34FgWcQ1V6eQ/poIuevGj8IrGZyxGak60jHmw3vcV8WiqTiKUSJBw/7Kdo34ouMZblFIrtJFkO8CkEqYIZxTgoK5h6BvPt3pzYDOuk3TjvzQ1a/wCRPJirxEPiNUf72rkxTVn+iXjFyrEfWqlvoMRtiNJ0ZJmnTpo39++r0dVL3spTkiLOwDz1ZRSB8V47gfzeb/lJpqPRLLGBNjIuCZMC9fOCXD4n8PRzM1217L/YXCwVNEAbWthBfmllSq2REMVb25dTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KD4GlmHLffS/EZAT43eQ3sNY0UBXpcfFpViuVi9BdR4=;
 b=wwKfeveqMisT1EiJ0bM5bBfUWaaAXZzTIlBygvmKZU6k0SIlQttn9JqCaT7AeZSLkMhXt/KjS/5FxNnxz3MEGXLVppOKAMLo3GwHZti901dAfgBfKTiioABhijQRVGYjmndGue60/QUDhwcfFmMusG/75aRRhptPYEYo7mgFVEM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB7163.namprd10.prod.outlook.com (2603:10b6:610:127::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 09:37:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 09:37:10 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: Re: [PATCH] qla2xxx: use raw_smp_processor_id instead of
 smp_processor_id
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1il8pkll7.fsf@ca-mkp.ca.oracle.com>
References: <20230831112146.32595-1-njavali@marvell.com>
        <20230831112146.32595-2-njavali@marvell.com>
Date:   Tue, 05 Sep 2023 05:37:08 -0400
In-Reply-To: <20230831112146.32595-2-njavali@marvell.com> (Nilesh Javali's
        message of "Thu, 31 Aug 2023 16:51:46 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0131.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB7163:EE_
X-MS-Office365-Filtering-Correlation-Id: a0feeba0-f726-4e51-dde8-08dbadf3adc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cXam3r6XEnN2cz6KKwET42x4UWl6+ohYpH7NURjLb3ZwEiVEiMGfxhqmpf3DgPOLybVUxydoP21XoyJpj4hay5DQDo25tFLYMJ0bZvQSH7FkALK2y+aR2I1IgdmA84rr4VVjBjhDimt68JsXz/itJGFzo80whB6BYn0BxtftYMpYNI88kgQCt1eOBac5vD6/W/FrcrNEd/eIVXsv9dumhGZTb6lmIJIDxMPaIMqZHbhgtM6hU4JNVIX00d42WxJbgAK1/1OImVYkysus8H8WFa0T/d5RFVakgFUGoaf7pwqbj4msWcTARDkvNgOFkNNbH+DLCQfdNJkOMVMQlqFAd6TDOaurATOiCta37bMjjPrnY/TVU1cORs7/Blb2uL8c6y/fgkNieKHDbLLIE1x2d4a8Z7xXR6MMvQylc+wIQ7C1cB3/xivkGtc47T9OnBRGxipZ9Ysp/vPGjj1OGbbWQ4blRc1cUKH+s9f9uPLrQOSiCmoBwOkid/10urg5XKYuwdlxbp4qLcbv65By/qqByGeGLvB7MrNqxoO4drTdsmvqkhNstlhkAW1U3JybsB1N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199024)(186009)(1800799009)(2906002)(54906003)(66556008)(66476007)(66946007)(4326008)(558084003)(6916009)(41300700001)(316002)(8676002)(8936002)(5660300002)(6486002)(6506007)(86362001)(26005)(6512007)(38100700002)(36916002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WBz6ddGok2Kzl1H69wrAZRrvpFZxxR2suh7XhbMTh8thK/nvoUw8I26cJrD+?=
 =?us-ascii?Q?mpsNmv/hCDZ+rgdnqM1DE3kZfQGnweiq2gc4VWOj4VPogBpJ96uJr5p5WonS?=
 =?us-ascii?Q?C5DMtAUmVh9iL2FSvOfeVCDqtM0uYjFHT+fJm00TdUzkaV5AtBnus70hrnWd?=
 =?us-ascii?Q?gY4xY1ilPPppjg+6aWHTDrXS9cpZuNGOS8miz/Czrgz+/0PjhIczsSRZelxm?=
 =?us-ascii?Q?heF2tY+oW5o28BqVDNPdP1AjJl8L5TykGuMToBymV2QZnrTxIz8+IK5rbCX9?=
 =?us-ascii?Q?zsorci+YNRQLzeZnZ9V+TENV5DBsuWZ9z6Sub6+L21Vq3MYxBAozVbdWY/jS?=
 =?us-ascii?Q?P5/gPOoD2s9qBbcUh8xOBpeDj0pDgp1Sv4OMQV6kG97yLz5gnSNOqDv+UmXZ?=
 =?us-ascii?Q?WnH6bcWss//Ijy3I0U1lf3jEy4ayX++A/z0QYQVyw2Y1LNdm0zMpe+i9dLvk?=
 =?us-ascii?Q?jU9SZ2E73fdwEvapF5pJs93x+/HKb2aIPm4aSHKLVqTo/+doQOQ9OfDqao+W?=
 =?us-ascii?Q?N6sBV41MZC959rJQR0Satwoym60K7BGqSXttIBHOFJVeXlgovU5CK0O9yR6j?=
 =?us-ascii?Q?M6BGzhbb3hfZ4Gnc1L4N6bJ51JPVT8WRHHNhQHhmgZEttvrJsWYx90/G2oPM?=
 =?us-ascii?Q?8qwVhjSNR18jhBMO8OXKFORmHwElKB39wIDCXf+wZtxR197y650AJ+0ys1q3?=
 =?us-ascii?Q?eofvV+ysio+7GHLN3ufDnclFUeIlrd+Xu7qqhQT0YSmBoJmB1fw6CwVsxe+n?=
 =?us-ascii?Q?8sPc6FDxEPt+qdLjWhNN4V7Odr3A2janRN1JquvVjWOi0IHGHwu+dj450M3L?=
 =?us-ascii?Q?bK6toEO0fwjLgYh6qteROHpoaNublwnQ0s7hZ90E//czRoCVjwBuu9O9sD76?=
 =?us-ascii?Q?Shu06kPjayLegwW/+TKNJKebx8gVy7WSaAvv2ylpv/R0gJuxOR05eoHp5eLy?=
 =?us-ascii?Q?R1WYG2MzTahNynwRrkRtjork4emWls3u3v9gAKrTJDTz3jFXtkLGx7Px8XP6?=
 =?us-ascii?Q?uCau/3qdIj3Qw7eFW8z5sMyZWwru/H7m2Z2/hPFmFmiEqVnsDBiGvoSQwgKG?=
 =?us-ascii?Q?da2gWGSHwZ5l6/WTNzsbYW9d+B9XRwdaLtrWyoR1KMTpNNOxbsXOOVJ8/iwU?=
 =?us-ascii?Q?4iML3AI9L7OMiqllE3+CA9gT/maxIMRCCm1Akwgl/+MoAo3ZRT8jt7/i0qjt?=
 =?us-ascii?Q?sucyGEuSmCadXFTph/u3r6/02F+AY35i1vIG3mE4J4oRQKHJVD6wh92bb74s?=
 =?us-ascii?Q?rjsgV6fMudgJWTlDrhB+kTb9lZykDOgpkP16rTPh2Nk+87ZcwgEN73PBTrBf?=
 =?us-ascii?Q?UwR/kbrYiAcMaCc2GO3JbY5FnjXIMQX+EveHN7S8XL1Y4/quvNAEoPOB8Ebl?=
 =?us-ascii?Q?I5fZbFPDArFnGP2hetshJzuoDXLmmzOpfzw15fYi/t4WEZYUexyE3I+vpKpx?=
 =?us-ascii?Q?w6E68mDQ60wlUvF0FM9ETVNnOj/3FnW8A6WZ1VDDi4n4pztO2wWUKVBZlpzc?=
 =?us-ascii?Q?dYyyj2OXWXuMgiZ5uSrKK+ZZLMjAPDrYlDoSfkMcuysilPDXYhjCyeKV3S/h?=
 =?us-ascii?Q?Ew9d9X3dX2cPYp/0mN6OUn+SIQsFlvfnMlZSmPkN5naxxUhh3QCW1AUqA6l+?=
 =?us-ascii?Q?iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2u9IbY6xbnzg4wIqQQqd0Vg5Cij8dbvYvpcARhfZB0HX/7GW3iVFoxD1vNpAHXx049mpuI/pm/GhyoCes3i1jRKSSe+WYfBcsgekMOUHnpbcfr4V8rR7OBDfBS1+DlsZ5six66DgRBJfCip0qgj1DNwCY0Gaje78jrX9wRrhrPmyf4cyC8EG9JY1P2QOZBwtbPGJJyv+hA+QWJf/m6vUS1AYRpP2H1A6pSKY5zzAjkWV50AsuMwPvfUwFsgSTNXdqzzBoDuMUyJftJXZ3Ig8HTe6mduT/tWTZtH30h75DPeLGePCzcSTvj9r0otzMy7dVWCLB5I19ZZk20sSm8SZro0vfehPeAzafRavAxGF+SSfCnKKm6dd9ga/iCzpwK84my4prcotjSbbQIbQd+tnEQ8IKf8+fVzsgR5q1RqSTSwmDAFphfL0fgKLq6I/oxNR0MmE6HcI1b44pPYaA+QNr1DN1hHpyP/N27OGvBZ1U8XodNsErE47bF+t6J/QLGS9c7HqoSMiG8wNs3ndopZKLxZcAn9NZtNZBYQTg4gz/MJMgU2h1hdqABisbSNPK9JBcaUj3NGuytryAVTy+hwPT6Lmj0y/iMoYXrr2FzMruCYbYgb+94yUHTDZxYsufAVgHLvjG9O6ItPkt61vTVd5/jbkhsNtyhAx1lxCccogwFHoxYG9lAcsrWFqq/gFOTYDcHbUkcXoc06pSU8TVfeqsJ18gq7KVTyornU3GB7GfvxAf9yJJEryvboGOYi/5bBtPeb17z/08mGYu3/hPTH/s1PgiRkDsJHn+ZKVIPfLlmA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0feeba0-f726-4e51-dde8-08dbadf3adc3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 09:37:10.8361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bvPWDDuQJrDEHGXvvQ3IgZVi5YfjnnUAl2fQHr6pMLuWO8GAT5R0kLPQLVHL/5F/WgMFz9f1KXKWOp6wWpz1QiSKH0Fl4ZAxvcc3ecGZ8tU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7163
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_07,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=628
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050085
X-Proofpoint-GUID: eObhBZ81Kb2L1oMjMS1S7I-LTGoZ0E0-
X-Proofpoint-ORIG-GUID: eObhBZ81Kb2L1oMjMS1S7I-LTGoZ0E0-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Use raw_smp_processor_id instead of smp_processor_id. Also use
> queue_work across the driver instead of queue_work_on thus avoiding
> usage of smp_processor_id when CONFIG_DEBUG_PREEMPT is enabled.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
