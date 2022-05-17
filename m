Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ABB7C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 01:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbiEQB3S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 21:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiEQB3Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 21:29:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251C145ACB
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2022 18:29:15 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKZM1h009873;
        Tue, 17 May 2022 01:28:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=c4I3ThdTjsGl4JU4km/JVZieukSNgOrjhmHTIGGUBAE=;
 b=lpIe68DwkFpqQ1V7P5Y+Pz5z9jHWnoUudfTTJNEdQ5w1H+kBF1ipAaeT/i+/QZjIvh3E
 3xhJ2H9TUKmO24Qa8fl2kMwACMG69baTqHk2m+KztJ9dsuzIuyuVU8ctUgLDSwo3lexs
 zlkez7/XPtBZGVLA6J5LUe6lPV03xI4Arx4W7VW90i6CvnYxv66nW0N87K9A6kEdE3iA
 PcuHhIlgutivoB8OV5EmJVsIGileLLI6RJ+6Ylub3H9vlWLUnp2AvRCfviGTt+NBW5Xo
 5O9hFfGGvKn/azo5jqUcPU3D1Qw5nhwI/dZZeVj7ZZ0F1fyj7vmUXZP+I2pnxwnAQvX0 7A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310mwf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 01:28:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24H1G2Qe017818;
        Tue, 17 May 2022 01:28:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v82qkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 01:28:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhwtVsmgtqMsgfTQqVxXLopP/KiAlpRiOm1zBm503EKSobl0ZFZH7E6naFxOaQSsjtRzkuG73eZdHSfhO5fqL4ZFhZh4gN5EuDfpt1yPJhxZP1mV/4/yBSyKtbDrwn2Q1f1mE/vZFyLscLJZiIq3nk4H6xOuYHGjZ1RlAEt0jBxImhoEtG4SMB1lAPUjqgl3oqZAP+BUjDbaLMlcXdTIbx7gm5uilZsSckkXW0Nfn92gShIdXDQk6hInizFUn1Nz8l+oQtu+c92saCdLDAmbHK3o9aNI+jVR77CZMhLOtZ0X5yjhUHfJRpMdVvwK4Ft0OW2PLNdFnBWcAcZ3mFQrvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c4I3ThdTjsGl4JU4km/JVZieukSNgOrjhmHTIGGUBAE=;
 b=P0MSjFwJuCRKniskDgJB7VJ9KjsGRIGMqIUYuriA2SwSdj8IoJjswlPlh3glGQJ0GkHxpuRWbutImsHQfTy3ZCAuw1aDJBgyynu9v+NLgRw/1BfnO7Mb5F8XjjEG4XcC/PnFq9JnQFRGTM1wCb8E0Av/4c+HiGB62W4vH9DKB2ZRakbo5o17agVPub2n5C/rmK823YY72Hoda+eRAMJjNBZ9IuJK5z3EPt0l4+L/KQyNXHEZCwfR8+aSmDpbD1TEcIuoSzhxd10LfKNiljGoJfIoDPi38D+A4vbrLCV4NgedoQ0IDHljo+lrnrIzIVdK8VUrtjNwpqupS8rQryua7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4I3ThdTjsGl4JU4km/JVZieukSNgOrjhmHTIGGUBAE=;
 b=Gr/91Wf3rMa8F5XBxgBeiXirK1vfc0Yn60boi74DwcI23JQdbKQO/DndFxSRIbGgnXzUbloUzHDCZWO/8d8mpJDDjFGJoD21XBaZtaYrq5njgwcmvH1XTv2bgkWYepoGsXzeOAiH25jmXZG7ObWcJyWbhd/FMg33Vbjbn0IBsik=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5054.namprd10.prod.outlook.com (2603:10b6:5:38e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Tue, 17 May
 2022 01:28:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 01:28:53 +0000
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@suse.de>,
        Javed Hasan <jhasan@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 0/4] scsi: PREEMPT_RT related fixes.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtfhrlrr.fsf@ca-mkp.ca.oracle.com>
References: <20220506105758.283887-1-bigeasy@linutronix.de>
Date:   Mon, 16 May 2022 21:28:51 -0400
In-Reply-To: <20220506105758.283887-1-bigeasy@linutronix.de> (Sebastian
        Andrzej Siewior's message of "Fri, 6 May 2022 12:57:54 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0126.namprd05.prod.outlook.com
 (2603:10b6:803:42::43) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04036798-73f4-47aa-06b6-08da37a49a5c
X-MS-TrafficTypeDiagnostic: DS7PR10MB5054:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5054EBC25D3A3DE198C0E4428ECE9@DS7PR10MB5054.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sYUenDXF4tvvr+KscBLdRpIdeBwp3QaG+UDOgz9FhooBhyZDzgCvLm5AEl9o1/Dtiv0Ed41FVWf/nCRZpzstVy/GPdxZ2+z1JcxYnynVL5X5SaFCKpPVWNSm+tQCRjAVWRS6TuirguGtlcTL+SA8h8Lxow9ckpKhm5Na8LTmu3PMvkGayivI/VJLSuYXUKXf0ljzUcBZSUAO0vcjVSBB7QZ8k4S26+kw4/MfekH0vofoZBCmrXj6N0WRrMemufZT/SMbaWHQZ9eBp5baQz4rP2YYMvH09vDpfZECvRCYMoL0zw28ksIn019Io1p6J54M5U1PeFTKY/s/lmPc9ISyrIZ43G6oG6fm+JT6DT1dX8SKolFk2/l08sQlnzQ/gWKkhZ7/W/jKasEEmzqFdzsu+EgsDwRxZ0T8e7ogJ9gdvgGE0L5SwX/lJFWXsywN/oP/iR1vF0aHGFx3aPhKjZnnvKmYsMRQal07TOtX+EHKSEvbXtHVWkTX4aXtqCAdOPle1t0W/nNVDvYVdkrtkMMZXZNx8pi8vUqi4Qn2RCXKtMQykx8CTlgfZTSgUTey0rHe+RJwTDajtFS8iIM249SX3cLP0VeXD+LLW9WYmNjJLmPaqtM32cIYjAmSY9hw2s3GaYUFjXzjXL4KubbvWRMHEF+vNNC1fQXgRPj+ba0A3HlY2OygKPLEbYgP0D82ttvyqdJ1Z7rOUyObx2mF6fICjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(186003)(508600001)(6916009)(54906003)(316002)(6486002)(26005)(6512007)(36916002)(52116002)(2906002)(38350700002)(38100700002)(66946007)(8676002)(4326008)(66556008)(66476007)(8936002)(5660300002)(4744005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N93fG+Z228yc8xP/CWKhyprFzli9hjnXIdiB0xa4Ybdow7++mJwM432FACdK?=
 =?us-ascii?Q?j2E7uYonfnDgmiKJr0bs7cpi7J2jIsLBhLAI5eQjuI0fJh9PrYRRoYNpNOfQ?=
 =?us-ascii?Q?53ilvs3S1benGi47JmsYMfnGzGQlsx/vmzueM9yCjIqXhX7jgADZE1c7Y+mX?=
 =?us-ascii?Q?ukGeAc6v31yeHTJknBOIq24MrCUQKSQQ0ZziCiGMZalfOuhzY0YkvG67CGzx?=
 =?us-ascii?Q?w//oF3jHmU0srBRSkghn7sgIbVJRvtsSqm5jTIYseiHRDymgbF1sHgiqLZIH?=
 =?us-ascii?Q?S98lKNQTfKerAlUg33ngNdMF8MCs1tldR5OdvU4bdp8/uAC1fRcspuSPMd9M?=
 =?us-ascii?Q?n/sEeyka7VYQqj1u9A2NGuunDnwv/MD4/V0GUc08iOSxfbXfn+O1qGNqLrbL?=
 =?us-ascii?Q?0IRhrsLTJFcpdImHIiVEjqMy5cMq040pN0jjTAOILpKT6AKMa2tiyiUtdsUw?=
 =?us-ascii?Q?vVVkA3r523GxB86/IanjDGz97ymOjQvIX4XB83d4nx0RvBc8IIJ3LDWrEyQq?=
 =?us-ascii?Q?pFJDzKqOwuzPBrS+dloxcln4n/7Bc5RNO+zJqIHhdJ7GmZwYCzcDNn/cR6K+?=
 =?us-ascii?Q?29iNssMb87Y4NLxwa++7SvWJfX3zYx3ALpuHXKGqZX8aRPl3ZrHJ0Hrjusoj?=
 =?us-ascii?Q?ONA41TBK0UKypOv/QA+bHlqIMXjl+Ly4AsxamdxZIrBat80sDg0xroKZmM5r?=
 =?us-ascii?Q?s+JWFUrucxp02+bWNN+KRrJStuhBqKg2hmKrrs1ikp6pfRJRHiFmBJ+ogEXA?=
 =?us-ascii?Q?l6GJbbMIXP8ym4bJLOdcWKzeTQTsjK2Dzt5wR3uZNchAR6ossXiKcLPTRDki?=
 =?us-ascii?Q?upzpDrP3iOiMghfnqbxKwdWqd4Qq41JK+BBKYH/t5xvkEEhoFLcVaXuQPwYp?=
 =?us-ascii?Q?qps9Q588QFccjC50BmUDEbPOLBYQgqtOCss+PB4ExsPoxkuVX9h9RdSoa/cv?=
 =?us-ascii?Q?vx47yziIFAmD2moZaI3z0rHlY8x3Y6x9ld+5MSjG/an8acStQzl5wsUiOUzZ?=
 =?us-ascii?Q?URhbE5Uwv05wddlc1pVGPF8Ni6iIC2hCvkg+b6E4Eyr2NC02jluCDixJG943?=
 =?us-ascii?Q?jsSItEKI1dXR/8G2DxEdKophH+i16CJkJrEtpLQ1OX/CeZr0UjFz8EGu4bKq?=
 =?us-ascii?Q?6jWqokvSio5FTww8laGiNaR4vcaDQAQcstXjvQWtCWboZIOkBW468HtcVrLX?=
 =?us-ascii?Q?C8f1YOvp38Zn1vEhjPlpaF8p159oTd0yu5WFImQ1Mr5kwe/8DzL8TU97Pe3c?=
 =?us-ascii?Q?7msidMS4r1oLj22lAwkf1EvvLs2CI+13FWFAVzr4ygJO7vQ4QvGjJAeOOFaX?=
 =?us-ascii?Q?ZpbuqQPm/9fBrtB8i1k8wkaIfwtx3b0p1RIjzY4QMx0t4aOt74VBfdnBhSSP?=
 =?us-ascii?Q?OUuFeBzeffzX2VISpAh9AwGx3rOzn3oo588KiFvCrhpocdDu43ocubAmecEf?=
 =?us-ascii?Q?kPi1z3nkSjkLlfdKZzUsXVaWlBbcx7WLnRASOqnQWSd42bQc0S078Wot7gPv?=
 =?us-ascii?Q?g/swAS5tk07rwl2BOrfUyu4bP6iRTZKDLQacDTONqPZabtg1d9k1gn+K8q3/?=
 =?us-ascii?Q?4iJ8y7U+LQuSA6zjoyWupnP7SfOUnsl80Wi7SVgSIsbYCFVQ0LvQbBr1qGX8?=
 =?us-ascii?Q?Q6tgdZzV7EA6g8xkDjudTGJq71nkh0yvx1v8UZzFXHpCljzcz4X78ilFj3cx?=
 =?us-ascii?Q?oxBL19RkrS6w5IQssi4FTAbz/adVFud3r4aC0ptdNIaSuwp8aLD31hfaHAbG?=
 =?us-ascii?Q?UBDEDd8gCLa/se4lRjaaD2jc2gPMWRc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04036798-73f4-47aa-06b6-08da37a49a5c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 01:28:53.2420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPoNLvYfiM0PksbKvE8z+5WZ9M9fHXc+pNk3ENyCfAY12uKirMulyz0PoORyyTQOHhI31uN4WyDVrmg5gzoXI90e7Vngdqmcfn57WqAqjww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5054
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_16:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=855 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170005
X-Proofpoint-ORIG-GUID: unLoN0Gw9WAQx9IBuWZRbe4hAc9J0lXo
X-Proofpoint-GUID: unLoN0Gw9WAQx9IBuWZRbe4hAc9J0lXo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sebastian,

> this is what I have in PREEMPT_RT queue for the SCSI stack.  Two of
> these patches have been posted earlier by Davidlohr in another
> series. I then added the statistics change and then I stumbled upon
> another get_cpu() usage in bnx2fc so there are four patches now.  Due
> lack of hardware, the series has been compile tested only.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
