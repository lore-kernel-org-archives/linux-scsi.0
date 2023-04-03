Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42707C7619A
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 01:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjDCBHj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 21:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjDCBHh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 21:07:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC5D9ED7
        for <linux-scsi@vger.kernel.org>; Sun,  2 Apr 2023 18:07:37 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 332KdnQg015935;
        Mon, 3 Apr 2023 01:07:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=WxeLKuIRMmseUiV5nvF1ynavjSaDQTvnC2l86yhxGxA=;
 b=1Ox3YskxBDk1WZLfzVi5ZsOQI5SSX8/bX7bXdJXbGwYuW+5XV7s3qBt2xo8z5SKJuIiP
 CTurei9NiofYUyQX4Z5cd1ZEJhNtFwhZr77N91So8zYlAJ9conVOKdvd40u+Ag3v1id+
 l90kXenIq6klaPxxAw5mtR8ysBMAlzDTJfSpqun90oJWpbTi4f3fIB4rdc3kHnwEaosU
 x764SaymbRd71PBlkPsNO7yOjCYBzqpwKh5eV6ZfxCIuTFtL5odm7aPEtRPbNofRJ2Or
 CkVp5/AYortnDTV+cCDQ2cGxhDYH+xFtKt8aRC9Vsl0Igs08gC3JYGnV7msFHkDoWdco nQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbhbt03m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 01:07:35 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 332LnvPE038319;
        Mon, 3 Apr 2023 01:07:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptjpkbj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 01:07:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8u0D/8Y+uHgKYM7gT+7tv8RjG9MWRIPofZXft/q9mBxP6/86eEfrkIflHKHsO1x7vWFDOToQELaGIUE2HUJKOYbX+F3oIOAzptPI/Zfi52Wgb0Dd30/wGCEbjEJ4Iq0CxTqACgr6Yt8gVEwut6bEo6PR3eohC7SV4n2LWHAe3NEe1ZXPmkkSoOeE3MRNj1J+cH8ESfePobDp7Iynss1Z2pNOsCjM4QuzAbrf5Ze9yyfHOthVChH0qmZjqHWkZH5o101TiXfs93YzuZ97dDwvLzZCn1Lg4NQNirDbLfNzAp/9VCZ/wNfHXwPPGV28gKaSisMVEbKhPx9gFEaG+x66g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxeLKuIRMmseUiV5nvF1ynavjSaDQTvnC2l86yhxGxA=;
 b=fB2B2vX8JrKoZhLm9Cr4T4KsxZ7TZr06ktw+lFgsRbsm2e1ccENMnwFn0JeqSNo3hlWVMS+9hplOzVtoMCEz2LR0Cge5lmvlGy/bjsotCSI8TF3EmoTACM5RxRwlP9YesqkkhztUlrDGjvM/pKQ2Ms9lryenNJkeXsTIkzm2GfEUYJEtVHX+0jvTBwCKyRGL2wCxYBA1rTjH/YrW5KIQ76NxY5/hI0GuuK2sWA6alfMgzE2FqOVW5OpAK1RYtw+RSfoLfrwjVn4KG5HGRMweOZE9VQrA1TACHlIM2Pn+gFURBxzaMtxWMyPurDmFURLDmfQzgaxmmXN9KXQo/v3liQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxeLKuIRMmseUiV5nvF1ynavjSaDQTvnC2l86yhxGxA=;
 b=x7ugVGFZ5+5MlJy7wnnDNzaP6ZNt9nKn3yy8j+fINep5+8JX6IyHWPYoMmv32AbgGi7niD4af2PJCHP5RRK05hm8EMH9VaHlZhetJPO0K168g0OhPiAO3P78196nFV+M1shr5padgdCEb4FbTQRnctPE/YW/egC6nAme1NJvcP0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5829.namprd10.prod.outlook.com (2603:10b6:510:126::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Mon, 3 Apr
 2023 01:07:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98%6]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 01:07:32 +0000
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH] mpt3sas: Remove logging BIOS version in the kernel log
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lej9ydw3.fsf@ca-mkp.ca.oracle.com>
References: <20230322092713.6961-1-ranjan.kumar@broadcom.com>
        <yq18rflirlv.fsf@ca-mkp.ca.oracle.com>
        <CAFdVvOzP5v6LO5RbK+=7gPmOX_Lv5MO1viWMUCbusNcc3pe=GA@mail.gmail.com>
Date:   Sun, 02 Apr 2023 21:07:26 -0400
In-Reply-To: <CAFdVvOzP5v6LO5RbK+=7gPmOX_Lv5MO1viWMUCbusNcc3pe=GA@mail.gmail.com>
        (Sathya Prakash Veerichetty's message of "Mon, 27 Mar 2023 10:57:22
        -0600")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0071.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: 101d03e3-4858-4308-39c5-08db33dfcdbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IfI1+SuBENelqpG/KbxFC7IyO5xBoDqbMY7tyr2TPqIITeFtzjul/LDKaeWKYK8rjIOXwlNTWMkre4+X2pQyqjqt3ZB1sBV+HwXdSdmga2lSVZN3xo64fHdX+lkJRL5gaVYSCjzgzTSjAdiYaU49f+tOzhsZQTsfIu/s24k5OZG851UxB5ZS5Pcmvn5t9XVe5y/To5gAP2kSek1SF86Nsx8hoUMUCUgi1PSimcH5I9WBR59pMf64kcv+aNnChZJ6BrTgzYX0Ep7taf3U3LZzZ5cnq08A327b7jwyTAoTT01uQb9/V8QpFePZuZAHdecpgUSexCtWkCNq30oK9cDW7v+y8fcLYBrfg7EFnHGtkalUOFWgFBIRehdRIR+Hg6JvjjbPYExluu8HmTUqat6JZRe7wIWSjX3hP/ugB18PUbx5Pj8nhvbPSWN7tqjyd+xnKTyMehQPvktLo8GGvw2M2gH0WsN/fUgkaPC3Z0AxoYB0U1az/5HmtJcGDNbJR8IhDr9jatgINsWZpJ1lUay8YrEJbjjQEOU4EH5ZzVnEACgA+DVYYrMVcNE3VodrBETLEbA6kkUwQLtj2N/L5snU9zn8LUzyq537vfI1P5jPRpg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(6506007)(6512007)(26005)(186003)(36916002)(6666004)(86362001)(41300700001)(6486002)(54906003)(478600001)(316002)(6916009)(4326008)(66556008)(66946007)(66476007)(38100700002)(2906002)(4744005)(5660300002)(8936002)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G4H89sjBYX87WbDlgvfKTNjSog1bjt0rYdqKy4+vmlecCOvF4wgosqhPBghc?=
 =?us-ascii?Q?MpENc6mgUVCPoBXQ8mMRaVkJpkUlXPiZy5X8MDIim1fABm3CGTrHf35O3QbG?=
 =?us-ascii?Q?GrErEosz1bqqvVUnYeFIHxpnwe9G1nOSgLSYlOeI+1HnBo+FTOjneB/5nfgK?=
 =?us-ascii?Q?e2BzHWhXRcJgUZKcCNpX0RW2wW/GLno27Axp6G3dI0hR9yzOk/V6vNE+U4CX?=
 =?us-ascii?Q?iCKHRJOwQHcPjFiMq+ylXlgd2hw1pr+PAuglV+V1VZ0Qj4Wb2Du8osUsjEPz?=
 =?us-ascii?Q?vjEdQlqttV5d3KC16UIL0wUqwoSWTmOxYe6nvGlq6d2soo7/YL9BByhVPgZt?=
 =?us-ascii?Q?7Vo0gsRXHnRjvQWD73DpIjBXtnQKKbebNn4J5BFnla4mENrZKzRMid/yiDPf?=
 =?us-ascii?Q?3ZLKCEOQOkQ3WwKeXuPeiPk3vAhtOhoX6MT4ASb92ynrDXfqehd4+zMpkURz?=
 =?us-ascii?Q?4r65lJTmnJMxGPuL/DdLzMBpWILzECHXECn5PHjTV4GyYQs1lm+y9BNv78Ja?=
 =?us-ascii?Q?r4T1KIxd0ULSY4w4w1ecj5jQc4J73/bSLSsxFQL8yllU1TZE6SkOBX2IOFQC?=
 =?us-ascii?Q?nxvWmxptUcy3MugVdkV598EIKaCvMEKBmD6Ox9md91kP0V5WbVLRDWWxLx/S?=
 =?us-ascii?Q?YXY8iK1HWPF6V1gbJCuzqpFuM8cJInBRjgvKBXZtkauzGFoepZkWrb86ZigS?=
 =?us-ascii?Q?T0YXpMhtSCFe2kE/dAn2Sac3PxVYLr7xuPpy3Y7rwbvcQOffmj3a9RRx17AP?=
 =?us-ascii?Q?lq0cjFXt7aR26L95W2p3IFd/cWXN7KUn7s3uStcAMh/iv3x5llSq1YDSBe69?=
 =?us-ascii?Q?/IdRh4COHN1KARLOHNKfRvpZyGeTk1xMUI0bCiLuwswFtx89q7DI13UerSq7?=
 =?us-ascii?Q?7FxSyemC9TDYYwho8u1U0RPHmxEe+tYTgw8fLrzwDVLU2wIed1BFWegQOxsF?=
 =?us-ascii?Q?fyW1fMEW70z49kSLfdwf8E8YwujZvNNWODDxY/4iaUDmR9B32UAfNZ+g3vtI?=
 =?us-ascii?Q?7xYBsQPLaKPRE8rb2TZQuX29T6Qt/v8SdoQc7Um+0QeBUZ8ufjWc3yt4YCm8?=
 =?us-ascii?Q?+IT+MOq4iUkCl4uSCH2j7daIlHAfTXqj0e89X9aMnMdKQxPUrczw/XyA4zDe?=
 =?us-ascii?Q?qeWGNPSb2jOe3sDI4OWJ0FCT+yYFphRiO+NRhAZCbDaJXvkdtLQ80ZUlAmmb?=
 =?us-ascii?Q?K4RoZqfTiGCf2frHDgex2GLI5blbzzf6CiyamyBJVG+ATkGrExnwS8jTqlzc?=
 =?us-ascii?Q?Wn0yb7unmJdO6J8e1uA/Yln//6KeUwMuHRnhYnK0965wWsp2dOBtUb5hbVSL?=
 =?us-ascii?Q?9cZHRSZCKRF8hdMhk4huXddRqOIN0NXHqi55QW/C5GSnOMKPBZEBxm3GNYAI?=
 =?us-ascii?Q?vJ+GP1Q2y/Qy4yC177zU9clpyOudw+4GukDPdCyDs2NBC/BtRCTNg045F4qb?=
 =?us-ascii?Q?5KcU24xX6fhb+8v1SyEhxqBFhpx/D/IWOES8L0nB+JtB8HZWFQVBeEgdAYaq?=
 =?us-ascii?Q?Cy73iGl1YpN/13xCokR2q0vXdpxaSGoJHsMRT/ixBdpyg9naSXA9QFMiMFul?=
 =?us-ascii?Q?8MyGYzhpLCiQCrfNPKWpkttGoKI3NCemv7MWdJ55Y/kdxVM/LkdcVb4qpmAQ?=
 =?us-ascii?Q?4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dDG/VR6M80r69/xftH/7H1MbtMjYGNDpT3XJAkO66HDK+b9Js8SWGBJNvBwLG2hk3duTM13kjUOAQlCqLilF14nVzdLBSI/x5N5CDl+Z5McxmMMMCMkDOWB2D4uvWKn4FlIItUGGsAdHK5thVbL2EN3oveL01fvugr/1Ve0Klx4xnlVUoJ1Ybm+D3+Jdw/k9paPJk704WFrRwc04PJiGFk3G6aWpToyfCsRPMbTqJuPJz9yjIqB0I2hkUJ25UefU3esIn29Y5gzhrFqz/G6pNw9l6GYyVcEZ0HN7fpNuPCOh+fC9OuHp+0d5QnjcNSMcKFYw1n6T/prOKMH0LuwGYY5Wv6Ff/O4q7ZBdAasZU1w0otXdtXrcNA6gB/Xu2aVPjNzbFlr21fS7GwVXEGz+56Qww9RbFI7XPygjhsy0BC6xo3mUUDwMMYr8UtSSyI7xYNwWGm2/+A4FOzChq/uGtuYXmCf/CYKPUAPmv1foGUG6jD29iVSrYq2FRd6ZdltCTDA41ROVZv0M7VM7pmm78DGp6xzbtxRl3jdBqCpes433lvslFSrS8pO1g8OUH5lTGS/HYKeNv/sCC8wsTyBV1qvYhJpiAYpO6hWfcfTwNV4JgoYFk3vHQGUh5kL/4Jfq+HHb+FiXnV92yuwUw0hkt3dAX/qcW8T9R2b4jute4Z4iCLpldHbLEiGAXp5ZUTazWDfjKijquWTh8ObsrihiEhGTHr0/uHgA6oToBcz3rAz1RiPPuNVGcssSTuDo2RVWVknAO8i/ZT+jGlvAcXUw8KN/+1S5AWA6GxoHXWIRP1c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 101d03e3-4858-4308-39c5-08db33dfcdbb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 01:07:32.7429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 80YyM2TZZTRtLHx1Cf//XwlyB63gQZYJ8Rp8leHtoavlLMpFONAEtUCNAkVn5YOT0J3rILW5kDnQUgQPlxh5YZlIcLb0qXpIT6pNfAkROWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5829
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=996 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030006
X-Proofpoint-GUID: yNGJMt-lfNEK3p2WRiC504JpcFuuLbs_
X-Proofpoint-ORIG-GUID: yNGJMt-lfNEK3p2WRiC504JpcFuuLbs_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sathya,

> The only proper way to print UEFI Boot Services Driver version and
> legacy x86 OpROM version is to upload those image headers from flash
> and retrieve the version, various generation of the controllers have
> various type of image headers hence a good amount of code needs to be
> added to the driver to display them properly and associated feature
> maintenance, so we thought it is better to push that to applications
> space

OK. As long as the firmware version is printed, I guess we can live
without the legacy BIOS.

-- 
Martin K. Petersen	Oracle Linux Engineering
