Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9DEC77B7F
	for <linux-scsi@archiver.kernel.org>; Sat,  6 May 2023 21:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjEFVxn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 May 2023 17:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjEFVxl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 May 2023 17:53:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79CF1D94A
        for <linux-scsi@vger.kernel.org>; Sat,  6 May 2023 14:53:40 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 346LhWOd032756;
        Sat, 6 May 2023 21:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=uoMguUb8J3A7sq41NJlI5EOZel0UO4sHSiaXilYkTo0=;
 b=nA6StLnXVTmrO2qkhiVebkeBhnnyjluyTEyJXnmFF19CC7h4Rqs+ickms6VA85JXNmp2
 uibKawA8VlJk4qzC/EAG755pMPSjJAsKAT/JtZ5Jf7VIss9PMmVAlV92KtRJE3l+PG5o
 3aztEFEwY4NASiNPPjeSZEu66hJQMFB4/y/sp0TAvNB3Vf5bLGkm8pwa0XHoKnBgDhsc
 hbkeNqNhAAv90+ynmaWeEIPXSgaggtf501P42lKeAepU3p/Ire/r+F0kJvcp1q/HAt2O
 6QSOr4pGmMy//47XyAEbo9Zq9KKFY7PNWA2a2ZbprT0s5QXngTTPvGmy5GlZZS1RpRa8 Sw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qddae0y39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 May 2023 21:53:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 346K3UQf013911;
        Sat, 6 May 2023 21:53:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qddb3ary3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 May 2023 21:53:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJ1r5vkyXbNKFaMBcuvyvhrHll2eV2Kt3Qnk4gwxyNpQnbsYY5goCDshAd4YlcNbVJGG5iUt2ARvk0QbXsHmfcE9uj6x6Lz5YczJ2LYv/2j0Bti9+EVi9WgPNCJwSt5GXwCQhIMeniKeJ271y56/M4BcTg78rORqR3fa/YLBGSMZmr7uAQtbwDbX2Gz6QBk5NqdRNEn/iuch/NibZTJH1d3GYQ0fuQUlEWbiv3N/rS1pWHj8N2EnpbVNywAd5D14I4OFNfAr6L3GZE+n/zXuVua4ykXVWjmUW4N+2qJkIYQxWkx93Whp3pNg1/56Zzq92vzq9NFAV4zp5A7y29Q0ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uoMguUb8J3A7sq41NJlI5EOZel0UO4sHSiaXilYkTo0=;
 b=CxVZ9dCECDtV7h2A+471/177JiSh7m2CRd6qh/Nh5PHwk2YSHUDJidYOblgM6C0EETmv8jXUdgbpdZe3OUXeEMeMgJdtLI4ScY4octtOSqDV2QkDMjMX0/ExwmDEU+qrLsIKn9CRSv6bNSqKNKn0qyAI6melZVCeISJ/a96EFmLUZ9k6Z1zqEUKch6mZRdZuzspShUA3gNTW1rFHA2gjInnZE/CnutUBgg4l6oJ+Pdr9vQbROTKkzxLacw0KbK1DM6SQnKIyWl8/A9WMb0U3aIMttZ9JDXNhmlnO2qT1m1Kod+kGxglKuZHV1q9d5/2g0bpcn0euiVgIacDYhGIExA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoMguUb8J3A7sq41NJlI5EOZel0UO4sHSiaXilYkTo0=;
 b=jG8WyrasNBcvVL1wKT4tbIqELdNffKrjlmFcTf1913IcIE+GREPuyVFZJXRCPEhODOh9AF6HeGj1U6XQYmTH455JfCnGwyey6+5NuVysSLBkLuWJcXFx1S+rTcUYICNdyWwBUG2l+5Oyf4sV/FW4Lt7ct+p+zT4ZCrumxTU9YsE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB6208.namprd10.prod.outlook.com (2603:10b6:8:8d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.30; Sat, 6 May
 2023 21:53:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6363.030; Sat, 6 May 2023
 21:53:35 +0000
To:     Justin Tee <justintee8345@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 0/7] lpfc: Update lpfc to revision 14.2.0.12
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1jzxl3z6d.fsf@ca-mkp.ca.oracle.com>
References: <20230417191558.83100-1-justintee8345@gmail.com>
Date:   Sat, 06 May 2023 17:53:32 -0400
In-Reply-To: <20230417191558.83100-1-justintee8345@gmail.com> (Justin Tee's
        message of "Mon, 17 Apr 2023 12:15:51 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0190.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM4PR10MB6208:EE_
X-MS-Office365-Filtering-Correlation-Id: 30d9425a-e428-4b67-29fa-08db4e7c5752
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D5X477hB5MfcZaOz45RVTXpYcsCA+Q7yFjdVvvof5NuYwu0rM2thaHETEm2PYcRXWV5WViRRfWgWybzMU6xZJn6VLNOyrMV7ImqhVaEWAvC+qSRLh0BHpQQpSV1mipIRIop4gBLjfVpnAqxSBV98s8G3hDQe1y0GgG/ZpmRjYQ2Nl3PfVc0ThPbp6ESV0DU9yrlsCX3nV2yjJVuPkO8O66Y0QmUoHjt2mzGM8XoyqKK8NXx74x8KpEZjcWOtattgfPWENhwtnse/NSAujEIBuAPL0eZO4Z8d9h97KgFgOlAHqoZ9k4j9joMVMpQ9CP6jWLYuKRgG9HBWk0ciUN5p9cDaFI/RMhl58ky8/w0xIIKDSZLUYzxSY228NCuBNhwi84pzFa+uz1nY02vvlq61xWdvo2jfbMxLj4De+Gw0nT6Jp/HuHYW5C+Il+skK+ef6pQOxKQad0orL4qqLVrOTpUABgfCUPgkfEEp/pPUF2E4C0bP6ulhPOFoBfud/YQtYCUrUyAUgnFBGu8DD6PahThemLAYz8PvkkIOg3JyZEQLBUyfLXpDW9iQ68xXbkqUD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(366004)(346002)(39860400002)(451199021)(36916002)(66946007)(66556008)(66476007)(6916009)(4326008)(478600001)(6486002)(316002)(558084003)(86362001)(83380400001)(6512007)(6506007)(26005)(6666004)(8676002)(8936002)(5660300002)(41300700001)(2906002)(15650500001)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?75TWkDp1eFCaYl2xqLen/AmPAPeO0Y7D3vunc+Ul2+jBkOMY/OnM1Pc9VkC1?=
 =?us-ascii?Q?83CTI/0v3DiDRrcPO60/9OVVFGn2LsdwsZhU8NcG2PNr/s5DoNobsn6CcQSg?=
 =?us-ascii?Q?VbOUUmpyOr2TbzpZqL3Quq7aSiO5gTajiBIqE5xsE+iaHlHF66Pnj84N1Lru?=
 =?us-ascii?Q?Qoru6p/JzG2OgcyTwy+oyoTzdMfJkDIUT8JDANgiLkHCH+jvVG/qfQof0Yo7?=
 =?us-ascii?Q?TeXbrYwcpFDiydqcNEC1xCgtOcFAOJrfGW/F0BlOoidnQgDQGbdLBDvKAwVG?=
 =?us-ascii?Q?7bvw5+GeBkyhPpMegny6/qSuQBwZlKo6zOACHoiWu86y0k/tjrpVGjteejE5?=
 =?us-ascii?Q?Sga71gzZeg3WxhT8EI4m7I4ORCiwvDeccAkqfhktU4Lu1v8umK17Iq3fmeVU?=
 =?us-ascii?Q?ESSDpouBZB5zriR1F75QnLuAkicHrt95/AoX/jxygRVzBNUgwkPlMC2SKpM+?=
 =?us-ascii?Q?N9eSdXWirqa+dj7CoGwDPvsM5poWV1BKl60cVu/qmctqXIIX8rlHi6sbUZ6z?=
 =?us-ascii?Q?mWzbRkEpl+9xVwqybDYvadt8zVVk49DFo7QLEAQvzqMYkUEHO2JuJ3Z09iWM?=
 =?us-ascii?Q?PBqxpMPA45+fA6VZz/RHwEX2+dLCGGvGL34vDhv3SZXhjODgWtmsgE/S1FsO?=
 =?us-ascii?Q?qevc1Id5rM0Y6oXbcaB4xAzYA+0dKvA0hmILCd9o3Ufrx8iwjSDkQ+6wiGo7?=
 =?us-ascii?Q?QRrcNgF2rzFY3Pbj0tMM9E+D32EYLuSVr9sbUGWaq0JFoCaetDwFT+2+Bw5X?=
 =?us-ascii?Q?nTuui5nhVim5KjfNmneRXta/p/dtla5WLbkhy1UvJk/CLcVu6BHm8wHBeieL?=
 =?us-ascii?Q?WIBFmNsWLz9RMf57Z7UfeZqwJGrKkuOfSQB3LDQcMINtzsbZljVrqT8OFsXj?=
 =?us-ascii?Q?H34KiSVbR6+ltF9l/Og31vKQf8D4S1haQDTFY/fc1cdCCcrUKNjo6/4AMxRM?=
 =?us-ascii?Q?8ZgmJ6cTwCAPr8sfKfPpusZYaXa5THkQNk01EMH8r3K3caqVBPIPT4lVzv+f?=
 =?us-ascii?Q?MY220okPbqlMK0x0e9bKyj9T2FHHx32EXdfHwPg9O2jEtVZV6jLgBfjsAyDK?=
 =?us-ascii?Q?D78fydOTqOcMa/2dOfQAva/XPFj1Yg5hdhtklv4idGB+iv/YoTA78j/G1LIq?=
 =?us-ascii?Q?vpcWmjlpjqXELGnJpInWTOe2kWBcsV0d60Jk8bGBU3dXqzS+8NPHKsE2wbPj?=
 =?us-ascii?Q?SjkTepl/pj9PbY+eywUSsbEfO6GIVORWWUVHqV0miGDgI8cKXO0CR75Ze4rs?=
 =?us-ascii?Q?mGiCRLZUdQ2S+KtAxsUXe+uPjZVGUq/D5xydo4Tq1ONVIzWHTtTlHwM5heWF?=
 =?us-ascii?Q?fq7HBVgAafpqBFeDMIA42f71JbTBKo+FP0kaNcxP5fW3b3AKGnDPnZ9MZxOM?=
 =?us-ascii?Q?eT0rHKO/JrkjeyqNnVHopKmnUTP25TNSCn8N2avjrtu0Aii69lEeRr4a03YA?=
 =?us-ascii?Q?pUGC/bCP3WUT7vJ/J6P48Mod31fadKX/dmsNApTuFS+sqa5yJ8NYAOHdvcPK?=
 =?us-ascii?Q?Kw8ZoIlg9+oOZ39Zq/QkllBDq0Tbrc3u7RIUEIBhoSgY0/idsPNrFBl3yQVf?=
 =?us-ascii?Q?96/BFdaJJeQLPNwS4bm6BPMayz/SKw2q2x6hhpahW0oKyBSdxGLdjbxavo8c?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: V564p4zx4/MtFp7795J/H0k0NecWIGJ+UpRTj1Wz3r++plEStighumWrNolRs44MtxFmA4P2I1BuBeFbjHnQfKjMAggsfDkfIk9piHx55HnDVEIyf0O1emNZ/P+joYzuBgoqaO0PTKnfs67z9XvhkmdLhLECBCC9vdPO05m2C5W8xxNl/8mTmyiPhR4cQ4Ju3Zlc8CiHqQFH5rYM8jshPl3ZKFUo25KYaBOTyw0k3yjHkYlPtAeTDOmo5rzPqPIIaENPjs+HoQf3zicIOQvAz4BQCpEI1jWwu2KI3iE+6QHZmTQAmSy4yglWV1kOEmLqyBNud4JPKlADQuhcavBPl6+s+Dl26tsBa19jpsVmYrp5rtddqdWn9tV9cvQccVZAEmXElKQZLCeFHJILY6PQoScwvH4bhwtQy3uMUYQC2qdKTzIJrNi/Lvc1CoxpAe26yeXF6h0OXLXkhqMpi4RnaU2QNFCL1X2oSwUCf99XkUaqxtwq9cbwyxQq6b4U+0BdKnPNq5z1AEDwqPkmIRF+oeGXNiV5E7sdsoyNr1R17fSvTvWLIhjrGNYtO8QSmbQ/3/HSCckq7rtuPgcJQn7sYg6xMrumibEByJaZb+hmJs7oahWqWZFCrXG0mgtaFLIFlmvj+/m5za3NI6pZ8PlSXE5M12amcnh1BtkggkE8vInW0TzGqaDC26+iP1AFlLUkmJa3epYtbK2SBjixD2s3b2Ez9/lGDKdR6mPj2Na6Jon7//rYt8Z5frUCTy08slkHGaxAPvf/JzrutJWSA/uMREO60wIu54q3As3DOVJIaT+6TWRmB1Xs4bdGp6Cam7uZ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30d9425a-e428-4b67-29fa-08db4e7c5752
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 21:53:35.3514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HSA6vmKFgHzbMU56VqkE7paM6fwxndiaMfaWCaEF0e7vsrLYlRLyU9edRz5kaYq54eZdUJFuklxroXb5vszpq3+L2Z4emp1P7M1MAR2yshg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-06_14,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=678 adultscore=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305060171
X-Proofpoint-GUID: tiTUqda_G08u7oKo7t5TVFm-hReIZn9K
X-Proofpoint-ORIG-GUID: tiTUqda_G08u7oKo7t5TVFm-hReIZn9K
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Justin,

> Update lpfc to revision 14.2.0.12

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
