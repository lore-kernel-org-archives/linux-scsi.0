Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E02CA0FFB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 16:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238420AbjIEQGG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354044AbjIEJ1Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 05:27:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E54127
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 02:27:21 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3853PHOk011366;
        Tue, 5 Sep 2023 09:27:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=WcGbv2qnISH7zGME8px4iDWFnmo2uEO0TdZJ62V3aBY=;
 b=KwGwK2VaNQa6s+tmD8sZT+4Em1hfqyBClr+xhm4dwT6F7Iy+rU5J/QlLbSUDSYYq24Ub
 OokJjJV+/CpjrSP+cHV9r/9g0v3Nb69wctiYWsKCidnvdNbglVSi4fhDcdqrBNeq3kUv
 t4AyI+i8f/P6bqow20TUr/CkevAooPthIzOJpcTPh/4nqNTaK/wmTVFTkKzytnOB2Xkk
 UHp+q8qrI3688/6rm218Fo3dG5mUeLIFQtcFn3+/9jeOIXXVnzqaMyMxvk87UFAnfveY
 awSdQLR/jzk6AfoqIqjSI6+aZTHE1hIvOmxo/UaUKEpkkQ472k/7IZtWeu9IQtcAuTBH Wg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3suuu3mv6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 09:27:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3857bnOp029106;
        Tue, 5 Sep 2023 09:27:12 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug4gp3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 09:27:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGigtnFbHHOgdUWw2SKOzwzseLpX4ta4cUTp/6/kl52nQ0Efk+L4ZXfEExsjJh2rerbJ4rItONbF7pHhxrW9kffdqq64jtVx+/D3jDGThNwpVHVQZwublqOmNRi8WTFF3mGA2apt+C8RSH5SSTBN0U5EDHVWcTn4oXt6IMSrv81E7w4tw9s0DUXipmitrmXBCm6+hrzrVi2qUoZhJcS379dEE6F/W3Tb8JMYSNOucMFSEhkV6j9uznfrJiPtCunMf1UClZwasFEdHeFEvIh02KaazUQjtyCwOqCQ1OZHAJ+VCsP3td1m5ALW5iu0dGat+GOHsY87pkEVu02pQtRhyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WcGbv2qnISH7zGME8px4iDWFnmo2uEO0TdZJ62V3aBY=;
 b=kWTvt3v3/r7vfLDHD43TVx0AUFoE9x3KsIwS0SFP3s7xSXGwptGJGEMhPLCB+ALSdZ4qcghfj1ccXww9uzBUVuWUGdHKCvQdxnAclFcSIIVMtJjWb3XAa/qLjDr1Pzf1gybd39VOwI+5o1tqGJoNC3Hbdd48ssOXH4ln1usLnJBL46KumsDpxa+GMc7k0ewr3xZeDoeYAIZKhgK7HrR+e3a5Ab2xzfrjK+kfS6IB7gUO8sUxH94WQtfZQcfmJdFCvK3+KyCVIIldOI5l0hGIrIjsoeRWCrsYIiwPSKtOI07DvHBnNc0mQtcCV+/9/3kGNo338efWTqSzzLzbiakokw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcGbv2qnISH7zGME8px4iDWFnmo2uEO0TdZJ62V3aBY=;
 b=HBp5soE/cBfsG4lRoI3C4ZO4jbv8uI9OU3snWA+mrBh8AjnF2jiZVi1CUiPL+5N2eyKjyWWTkPUFeX5dZlHzBnCfqtF1u4WMazIbNS4PO6U1SBubmuHFyc6y2eatx5gkeo6wZXv8epcvmsoy7BqhfGpPO/5wfERdrVVCVpzJ8D0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4182.namprd10.prod.outlook.com (2603:10b6:610:7a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 09:27:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 09:27:08 +0000
To:     Alex Henrie <alexhenrie24@gmail.com>
Cc:     linux-scsi@vger.kernel.org, linux-parport@lists.infradead.org,
        martin.petersen@oracle.com
Subject: Re: [PATCH] scsi: ppa: Fix accidentally reversed conditions for
 16-bit and 32-bit EPP
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7ihkm1s.fsf@ca-mkp.ca.oracle.com>
References: <20230831051945.515476-1-alexhenrie24@gmail.com>
Date:   Tue, 05 Sep 2023 05:27:02 -0400
In-Reply-To: <20230831051945.515476-1-alexhenrie24@gmail.com> (Alex Henrie's
        message of "Wed, 30 Aug 2023 23:19:42 -0600")
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0057.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH2PR10MB4182:EE_
X-MS-Office365-Filtering-Correlation-Id: f5dff339-0a22-433f-c81e-08dbadf246e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: alI7ACqXE6ng54VAEsx+4+WpGBpN4iFXk9z+k5ol7WhizF4JGy0LmrXpiAUbXkf59H1HOVFF1GRdAjY41VSb8EbUO4z9nK3MMrG7KTs98MVrzw/JnCCrKk4+QJSONOSTUsvwa7AZJ6iw9tSMefRjz44+5XgtKWeWMLQb9uSNxZcG1ELymKS2nkLfiCicMVVkRlBZga0I962jV2PjJByQfapzhVx5XXHpxDFMz1Qnc7E90mjX0p3/AJquC4wsrVLzYwih8Fo65qc8dMqKRElwJYjQ566qVb/sSCzxU9/TyT4Sjs4hLs0qYz3loJHSDAiZm0yK8unM5fMdbf52tNh4D+iIpnRrSyMsx14Mwf2R8f6fwT5MpQNjdJYqHJLxBwotIorZTeiRdOCYb0XTYcwX3ZWy4JdmTK12mK5RdfsYerIt0+fbogUfcojeAcfe1DzSKe0r+UNRfiMl6PV2ecK9uoU5mWawH5PEFEDoBc+GDehDfjDs9YgXzqL8J59unW5bmIXq52gLBcQdpDlb1tEkhOdlrczzNMbGqrstEPhgTmqY5nmEysrAwVbZyP4ycHXL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(376002)(136003)(186009)(451199024)(1800799009)(2906002)(38100700002)(558084003)(86362001)(41300700001)(6512007)(6486002)(6506007)(36916002)(6916009)(316002)(66476007)(66556008)(66946007)(4326008)(8676002)(107886003)(8936002)(478600001)(6666004)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?610j/6SOIRQPngk4r4/pmUPgj77YLdSJ2kM1IwXYXh0Rze7TXwrVISxFfXUs?=
 =?us-ascii?Q?1J+HiEJDGfkpx/uilEDjcJ3Ds/imENHYfb7FFss9rwZNt3TlAvlaKxv5Sv24?=
 =?us-ascii?Q?flzMw7A7i3uKMidcyN6DNsFUdsal5YKgKAVDImWSJ27HiwfQx5vrHfkeFl7e?=
 =?us-ascii?Q?uNouMROCtJxRNfSdHcn48tx2LV+amjxPPEC1CApkHYZP20CUkJyR+5MhjbLQ?=
 =?us-ascii?Q?LklPl9vvUV8QL6vSAF4SCeDZXGDB2i9YK4IjbshzZ6mONEm0ZmGg/gfk98M7?=
 =?us-ascii?Q?HHKnZCW6VMr9pD96llS8L7V0H1RLGiIWDaVac7vSJlIEGoGywoDEwu3qaPi6?=
 =?us-ascii?Q?pwUQdkPqoVZQW6iRVdcFPuE49AxDJlJ96o9khescI83n9huQTLRM5LNLJjMs?=
 =?us-ascii?Q?qFLDI2cg6JLqzaNu/3aZiHffx3rHXmDs4KDlA/eRT8Pu5CE+qbPnjQU8Dcyg?=
 =?us-ascii?Q?LSaZOAAdvRDhUKu4Mrxpf3Du5+eFA76Kcde/M+WcrieIZH7ptm6dFVmiokXg?=
 =?us-ascii?Q?gH76mYHSKJUmNFhfJaPrMo2R+seDcAENeQZuZjDDcbxIQFoYqzHR6jkw+XGO?=
 =?us-ascii?Q?AyadS9bWTyJlhJG7S2zobr7gVS9UvtqPOoZdcQPcrlhzngy3lrq5/MGTs59V?=
 =?us-ascii?Q?PvJ/WT5aWnAcJebVfWP0HmQj10HtiigmX7RCcH5cPnI4nrSbOKdQJtx+smsd?=
 =?us-ascii?Q?aEtHybznnHTp5hiO3KRMYUwCNlqCUxI2OtPEMe2/Y5XjAI/2t9edNhnL0FcG?=
 =?us-ascii?Q?k7Ck+pDdw0vIZAbsIjJmbTbCIn2ihdvdy6b1kBsexGIzM1Rr6s3Gdcs1RG6P?=
 =?us-ascii?Q?3z0A0xNx/nXU7iFBvENLk4+MDA87jo4g4iZ5k9Bblu62vCvGZ2C3iWjTunML?=
 =?us-ascii?Q?zDT0LmJaQ0b+d53wgBUDJqZtLYWyfA+QPvCXCc4Acf/DP9Drn3EzJ1NFp0zB?=
 =?us-ascii?Q?nWbdTjIb/gYJmJf61qNkLG29COs6B3Yb0NKQev66rQbVmPnSI3vVL1YemKZP?=
 =?us-ascii?Q?2Jop37y7p0/p/6Jf3ybHmAnVp23v+gT70CHF9s1XQjXkyYZcAI+icOyqR/Rd?=
 =?us-ascii?Q?90U2XhUU+/dyYcar2+lp54b3vOclngcL3ubLoQw8IeXJyCag2EVLG+bKTQ/+?=
 =?us-ascii?Q?dySb2SviuG0JI7N+QzxQ2Ylp9oum1MGsGscfhpQxLeLAAq52m82HeE8miag/?=
 =?us-ascii?Q?8dqKRKV9g+LSfrasHi6r6cELe6wC9HTnCQdmN2JrJSrIzuN+ULfcI4AFI2M2?=
 =?us-ascii?Q?AiPAH7KA0a3LXrBb33lV4w4ipVnuCxy0YYnpVUTYHHqKcr2gUewoAhNRsYrg?=
 =?us-ascii?Q?tzWApT2NOIWeqRhMLXZrnrmYGJWzM1upcwodNEcp3d6Yrfb3rN8TS10JziQX?=
 =?us-ascii?Q?EQA2GONqZSiOb6G7yiQFAP2KxOP2Ye9h8RCoAqMlQEC8J7DrXOTpEXxELMg2?=
 =?us-ascii?Q?q/kfD+I7Hq44NFd99BOeP6yDIzaOv2AvtAGTuI/YvbRyYJeMc1yzIFUZpCnu?=
 =?us-ascii?Q?X1vwThWYWPYvAu13z/ezux8gMjOk97l09fHETOI7OnADJtNUGDYqMyw7W6yG?=
 =?us-ascii?Q?i6vyqs8uFgU6s+EUr+d2ieZO0WhaluPOOiVjngo5Rm+Yj63+pCyXWsqTX0nO?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rCoIxG+XIsmnZbdM7io50DQ/tAAibd0fg81A8AxRQBbAjUc1Q/zsO/0afByZnhmCcSG8tPC81OffDSODpslLbKK+2SCcpQAeH7VYH8dyKT+jPhkdPpDgKt+Q2AhAxPjwiu6KLD4adRkj1zt1t6foaPRt8cHjujiUiN2GLqTl7GkraKtITFv9uzTGDXUpvPrarJI65rw9bCmzH/nOkP3tjVCtqxbFSJmofVAAGAbzHV1VSbTdfDlKZ/bZUAILn+coEHg4+qkLG2oQYyOnI2dN/jGEPj8KpFVEKhP3F/By/N6SpOypc2KPVhnC7Gdojy4hdxerx0A4vMwRTvPEPZd1yIYS6IWn1n9JKmSqlu+z/ncufI9QyD2fnhcsjEvTvxJ0B7ol4u5FaSEWpdxwLj7udEeLNyOhF+bUU2JeRECjQYxf4Xp623CosKezZHXQQlHPjD4/uk7kGNeBfe7Kb2Y6O91JFqDV1EqaHOZUfrbzJP1pT7Gfu2BgtOlT844NqCo6Iu64Q89w+ioO8VYYk7x4hekWRT/amoNcFOD1UseFofFABuRE0Xj0Kb+pOV1XsE7ow/4p7f7uXnZmQ6WoSzGHddPHLnZr60ZXnjulL+VdUaaVQ8D4N1eLsuxU8Oht+3W3n2J+brgkXScK/CNJZPfeqoCsDGxYnbqX+jQ1Sa77ydA1rmgN3sjHi0Hs8IywGC1rWgwgZutH2wO9nzEjlAuGfGiSpbZgE6mJANL+HcdGFyg30jsSWJROv2SC03sJU2KeRw+HRFFS7b+Hbey/RksqNgJcAMOZsU7lgIYBJ+cVkjZ/RZz/MWpKllr2eS9V9eKWzguhJd7E5p1Kq2lXPZV2Cg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5dff339-0a22-433f-c81e-08dbadf246e4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 09:27:08.7314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RWGoh07Id0snwzpBS8KFyFLJY8jetvxNoAY02h6zcY5cFy2u6t43xtAakNBE51KWLNyZdE9ZIiThd5L5XYHdrP/Yn1ccLEGwKSVkb6Ny71o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4182
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_07,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=702 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050084
X-Proofpoint-ORIG-GUID: skmS08ADGQHJ5pkqqUFCzdKDHYu4yMEO
X-Proofpoint-GUID: skmS08ADGQHJ5pkqqUFCzdKDHYu4yMEO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alex,

> The conditions were correct in the ppa_in function but not in the
> ppa_out function.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
