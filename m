Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF926C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 22:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjEaWQy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 18:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbjEaWQw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 18:16:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F244137
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 15:16:22 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VKYGEN021983;
        Wed, 31 May 2023 22:16:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=zAIF0UHySEkiu4fIA1sJPj9HR4p157UTlBAcIjJ2X20=;
 b=VHyaSXuOePjJsBWZRLLzWomad36pkYQbTSOQzz5k0hw1XF4acgVSzK6JuO9k4wMDbHWq
 AAvFOY7PNZOaiE3fcAcOpcWzp/6P4iGSx9m8knXkiothcYvMADpAXtXeljae/t+VmlWX
 fSnRlYAeVneDb8ukyjVStW//UMDQIHAwnJhCEV9+YOntEiYjVdR0CATwYeGAIeT6/D9H
 NbnaTXEZCpIGLjZeE15FYr05YVCk9OuvEA4H+o/rPtfsA9v4CGTAJDVPt65hdJzHQqHw
 FBPaNF9YDVXEWjHzXq8kDBvnftagLUu+v6otiIDpdiXp7WpThkB8hyv/UtRKJLI+u+YR Iw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhmjq54d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 22:16:01 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VK9k8g014767;
        Wed, 31 May 2023 22:16:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a6a0yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 22:16:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oj4ghGDTtlI7IC2lHSig39zSPW1lzxCcxt+HlXaiYfRGR9/SR9qMMc+CxTwgya70MAdERBcCZibx8uLVYf1nJpfqtoEuftKdhn4LKzusL8EPazZr9TUcELgE3w9Q1KT1NGTgAQFpi0AHo10e2tlmND8zMtCzjqBJPMmj2OCzp4Jx/w33Bv3H5ewfVS3cfaKHow2nmIgUqRH1wdLOxfGVQI64IvShPHysBJjrSwkXPL0UeExk1eGtcXD7P7SP2b0VgP+OV9L6B80qSCW3T5oYLEjoD/S8GSyGVVlGY7BNOH0uQd6mWI+mR992OuJ3KVBx0XKY30kfIHrrsRG/jGthRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zAIF0UHySEkiu4fIA1sJPj9HR4p157UTlBAcIjJ2X20=;
 b=eNkxUG78R368qUjSdSEajeQOsFYBJXo0dwA/I1V6T3L1A7oBoq4oDCAjg1wsn6LGPnAMJMFuONSbFi+H4894OdI2Cxcblof8IJSSAVZeXBpACo1kMALCM5jXFvytaGRei6+Q8n4uP01FFlTPZz4sFq0n6QXTFC0lpU3Cn0RX7GsZfokZShRkHejEDFzqIORlpqePFCfbMn8qvLBchbm4ledZVQ0hdpC0NXMYyflfaAE6oV93WlGFiS6RAwZNpbOi33gQ24owWRp0RxONE7D46LJ37gvkTg8reO3NV0F9fWs3gGUa8t7B1ItimWTOSi4ZPZz4/+w3WolPz0SqOBc2gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zAIF0UHySEkiu4fIA1sJPj9HR4p157UTlBAcIjJ2X20=;
 b=F505z6D9bIjPOFQYnsBZ8adOsBgNl8eMKJtkzftymHSnwIWOHJvri6mzPN1iPx3BPkljFbsKmAnMefyNDiSFjeqqhObg3a/lqrVl1gAy61c0GP4tL64qnf3TJ3bO3RvpwWKOCrWT4WL4vfCGJT2DgLGrtl1D8HKvL/FTGjlYwYc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB7634.namprd10.prod.outlook.com (2603:10b6:806:38a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 22:15:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 22:15:58 +0000
To:     Justin Tee <justintee8345@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 0/9] lpfc: Update lpfc to revision 14.2.0.13
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17csocflb.fsf@ca-mkp.ca.oracle.com>
References: <20230523183206.7728-1-justintee8345@gmail.com>
Date:   Wed, 31 May 2023 18:15:55 -0400
In-Reply-To: <20230523183206.7728-1-justintee8345@gmail.com> (Justin Tee's
        message of "Tue, 23 May 2023 11:31:57 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB7634:EE_
X-MS-Office365-Filtering-Correlation-Id: de7aa1e5-3919-4084-6fe5-08db62249c27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6OKFWIgDwwFqULwQUNi0dy26VPPY5Yb7lH7Io5X+LGfvaYz3jhQbO+3pVER7vxtRKyzuEfC1uXkja8KrB17vF0Uead83QYGdppe+dsr5mp62HJFQoKu7heD+StmobxzfprYkNLqujoJvp/mfyhYTKoP+eGvCSK1bP0MgxgqaGv9ggXrZo+FpHDufeNTTlolLJCBGIw1bslb22oLxAJYqKK9QQ0/WvP7nysRTZH0TZONmiQrUYYQwIkXzNlSqq4TBAXsCfwGL1lg2EWbnyEqu9Th3+gSch9d73cyViDOdpu+r+VfTqYHgfw+zKNnj3MjJ1qL92eIh7mEHw6eEl9gxfBiR9Cgfc1O6XryWSco+L/rsvfUZVpXhk4bpUOoYOcIs0/PJEs428gD1kkdX9GZhH+bk/zHtJ9uKPElIszZudqLzuZ3cLmt4XxLuNaeO7RSpvClqWzDpxOCCt5gvH2dHWt1KsrOCRExIBVozGl9wYUqHmxxhIP2XWwFTExXwgH99YyQb+kazbfykE4UbfAVnhZBGkyX3hE0k1T3N/Y5kwnrwOfAeYP95ZDOzPkwHDNQQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(396003)(136003)(39860400002)(451199021)(4744005)(2906002)(83380400001)(86362001)(38100700002)(8936002)(8676002)(5660300002)(6916009)(4326008)(316002)(66946007)(66556008)(66476007)(6666004)(41300700001)(6486002)(36916002)(6506007)(26005)(186003)(15650500001)(6512007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v3GsrMocqRZx+2EkNcdDwJlHIGaeUk9s5FNxl9+BonPxF3DpErd/D/AapygB?=
 =?us-ascii?Q?VwWzQFxIJSnqSAS89A2XeJO986tWy55qFFQz62JqH70qXgGRLxS9Iqw4Cn4R?=
 =?us-ascii?Q?fMVDQq/tq1lHbnncSeI5LCmHkC+uhIinbE/lliJC9vep1BmBK/nLk8CqEvDq?=
 =?us-ascii?Q?cLVEAMz0OJVmalo69SbwtmqqCiF2YWB6iRy2KuSG3vGn2IlC7j08WUAy1qvl?=
 =?us-ascii?Q?Gol9y1ZD+hMaga2LUMRXcrysf0NODE5HG9p5dkdQ933UA9eIf08Esa3vYy3g?=
 =?us-ascii?Q?x2AH/fc4emO7+solE08uBRrMRd9FOC8C7W4zVGl9FUZ/HCp+Pc4Sf+aT2jh9?=
 =?us-ascii?Q?G8AXUwN8o2Hbq5zxDRhgQcgVSkeK3sA2nDQZBwT8Yuq7uvt5KDZTug6Cc077?=
 =?us-ascii?Q?jqC6QTm0PW8Mpwbo04mLeHlTG8sagLXx4Y9YKhv8BQLZcJ5xdq81saYvzrIM?=
 =?us-ascii?Q?JFN6Gn6R1GiVqVH+H4y1vcAljruI4zKgN1RLRK3z0Q1v4Uiq3ivbniYnyPRH?=
 =?us-ascii?Q?eTJ409kKxd6tp0cEHm5JVRTieTgzaO6YgUYfqOPht39TIDfSbUFbvSbx4Jqy?=
 =?us-ascii?Q?Fqkzhh284Xr0Hu65HfyUlxR7UbfgOI3JZylcUBfpjI5IawR8gKyGPHBtFNJQ?=
 =?us-ascii?Q?mh/+rjFsjzzow78lwDPf+cVBB+9Ga+8zUIUT8Fq93A8rqeJ/RZvbKM31ig4y?=
 =?us-ascii?Q?wbfqTEnfL2urmXJ5FORVRX+Qn2lvzglrK1tNz5fekADoCbmmlU9/vwqfbjgh?=
 =?us-ascii?Q?A0bs2iuY/YHjTS1SyfZcjMx+YSWeMcB97CfIPOQvONJgumzzpnkxN8WYcPuL?=
 =?us-ascii?Q?xzPBtOEq4v/GvL7jp5S2G50KHujg5+DoQnF85yMocu9N6LUKO1leuRf1G3xY?=
 =?us-ascii?Q?Kxm65mNempLsWqO1jbDxuaic+PTprNpFhpQ3i4oQOwtl/gG2Z7x13+Cw64Li?=
 =?us-ascii?Q?2w0PkfjNxtMMidbNeG10ISObDj5wMOphdDm9Dw0NHLb/oK0YLs+Hc32Qnv/C?=
 =?us-ascii?Q?/9Z6M5FgVAZerMbE/E9CBCyVF/FJVHnV3DAu/5OYwCiNOTQp+cW1obmxYhRa?=
 =?us-ascii?Q?c7VGYz9O+1CVTyiJrjz7URzM0tTAI+Vf8qlagqX+uy50zIky26YBJtQIQPSV?=
 =?us-ascii?Q?EgnbfE1nklKh+NsVVNbvO3ZyMslU//E4YJFmdUGvH97cGwEq2Nz06slUHa01?=
 =?us-ascii?Q?hqdiujLbUnJwdjG6XhnkjJ8pM5wKZlDW7BtMhmhc9MFICJfhf1Bh969g/43G?=
 =?us-ascii?Q?rZTSnmjtslTS2tY6URk5s3zxUDXrk7SSnjW2WbB+2ZL8uYcf425VnvIQsBYb?=
 =?us-ascii?Q?AAAC4xiuTj0Tr19i3D5bVWWnpZjPJWQK1bVcr6III1P77oRLeODMKLuYrqaz?=
 =?us-ascii?Q?+cHyWZKLIRXMTrHP5blRWJUh8fZNKt1NmGFkx2TbL7MKV3MQ0L/Xp6sb6A2k?=
 =?us-ascii?Q?lPACoGwojs6gJD2vDJkVQ4XSJTC6jaj5Ek3WlVVligpVXavCSjPMM7jjhwix?=
 =?us-ascii?Q?LKUnR+nw8soXHynfkj+DfiyQTntqhMwkmH8662dn0tD5zUicgT5O3EQnEIcu?=
 =?us-ascii?Q?PFSa1zMVJEfK4a7elrgsn/i7t+9oH96FYv5aEqg78HJkGukBOrAArpndQ6bg?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Fq//rULyC9A3yD4gFYRLTEyGIC8q0EUJxv0goeN02xkZ5dpEhQjaAdHHCSu46iuvZ4pyrxdZy9/ahmLMW2EHVLcErtSWBDmGK24FpydGVI4rxkWOtNNuScHr311y1qEdkNJWrLbLkix4hh894yhvNSMCt3ZUlmPO3sbB8LFwpEU39YCpu/T/eOmzwZXJLthmpQg1n2OqIV4pwGdapZxhNQVm8AeH4TVGWTPCcXGati4hM6Ztm7HoKKGRm264MVtpltx8W44psoJ7TllZ6NzF5etzu/ZIwNQ0H20cI93gjIacxYVcHox+w7PtTeD+mJO1fgKn90IfpROAQbTrT2NSwzEoSawEZEBwvuvO3KAjaRTEcoUewgB5z8Ln80HczuLCZFxXAoy+4nEwLPBhN3TxecfD389gwlsbgHMIwYa5MU1ADhkjR4CARXMVr01e+HtPKQdigtLkn4emlzCcNCrXn+ecNYahxU5bFLTe8sB2NtSr0czGaTa0+WLl8yomk7KKyGuPBp4GFZNtKYbK+XvP2cyyQFhB+qY37xOqL5L7xr76IgbuVSTcqnJzGfR2RSjzgMMrdZxlcyj20ziy+Irif5yI7McNeqcTQEKvp3Ms1qYu4BGX77Xjret/1AYsMp0UUt07fKOdfkaZktlFmUgnNzK6fffeDlR+/FTIOc/lTZ8zLsuSB6umdDBZyYIvPz868LzzsRSzX9a46x/mltrazztRauwGKPLRQwhYW8RXr0B4EDEn01VZiQ6oJIq4E1YiSaO0THrdScCSyEXXlK1n0NOS2KQOXK7DiZR3sDYaaspaoaJ9Jr2VEPdfZJLsYINS0D6Fv9QEdSO2bh15RNxhbw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de7aa1e5-3919-4084-6fe5-08db62249c27
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 22:15:58.2698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zgNNJLREaH7Nlz9DNs2AQKaMTCxM7DMFiukvXAFCytiIuQ3eRCKxmh4MlVx8k9rhfWL43rbiWDxWab89FZFsobUKv5PxIEZ1Y75Zja184jI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7634
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_16,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=683 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305310187
X-Proofpoint-ORIG-GUID: ZxwLJyMv7gWa102-WV3nSdpWe-ksqXnt
X-Proofpoint-GUID: ZxwLJyMv7gWa102-WV3nSdpWe-ksqXnt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Justin,

> Update lpfc to revision 14.2.0.13
>
> This patch set contains discovery bug fixes, firmware logging
> improvements, clean up of CQ handling, and statistics collection
> enhancements.
>
> The patches were cut against Martin's 6.5/scsi-queue tree.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
