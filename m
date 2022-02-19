Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98812C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Feb 2022 22:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiBSWSO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 17:18:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiBSWSN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 17:18:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B005E55495
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 14:17:52 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21JCZbrD007199;
        Sat, 19 Feb 2022 22:15:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Ah57wOUiybWCF4BOBjDdHM47YC7849Dh0lvoa0NR5Fk=;
 b=imrhBoIle6f6H8KhOr3feMHfjXxg2gzNpUy8DP/+Mdxu7k6u9r8++a1j1+HAFvFq4wkb
 BD6RzLCr47wYNFLucrbdt5t/zCC+LJhG/e80UZ8j1q2zaYEAb2kFDSDGQSlxgqZiHsZa
 Pgvp6e+ZHS+AlGbDlHEv5zAgF9R3x3wRe8XoIr9QuViB8S9GQ0wUIZAPagR9cxbp8/QF
 dfnid4ZBnhK01P5u0BfNEYRkQb24FjAKC+jnuUytVrdYiGI9UkCDvxiTXmUII7SAmh2X
 U/WgxbsMqcl7lZfEWV8KYTRTO4uSl4c4uD0WkZ9I0ME2spn5ITn4CGDA1fryKMXZpuQg iQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eas3v0y0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 22:15:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21JMAJgX156081;
        Sat, 19 Feb 2022 22:15:25 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by aserp3020.oracle.com with ESMTP id 3eb47x5h06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 22:15:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OTiPl8bKp4XirX9amsTD7wPGXPIaV6LHgLGsbdT0HVu1IcdNaoa6R3SzUpSpsyv/cCY1r4W25k4TZcTsl575JGPsU+aaLzDRHRhlno7yp6lE8V+mQCc8jDfTDmtOc4lYEdRnYKoNgclhfhjZlNBy0z9NZS3flZGZ0FPXBsTHlW2xu3N8frmjwPmcyskFTLkQOWr3Jviee17r8XoDkywBhLpuSmIOuA7eDm9B6qzbMVbhhxwEKVMYYbIztGqWhdU3hZwBTTptZChxGMKVxT3sZcYQeZXoMXd94buc5ojhloswNAoijCATsl6KUCQcj9+l0ICT+w+WzQwze4F9YXt9WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ah57wOUiybWCF4BOBjDdHM47YC7849Dh0lvoa0NR5Fk=;
 b=C0aCw+b5191wC5ojlhO25I34783au7AdB8Wn8Fe/ut+jF/VZWa9as8JtXqfo9vY9u9zOASBbm9Pxht8MseiXZJV0NEn13upuXgPRwCNsOjbuEpu0221yKcfOHS+BaVieNo56SVtvQ47HoscM5BA4zukDTWeL9fwl67qk81SfIps6YwKLGj5J5mbFt72xAmo1GLgAS7+TbkDThuzk4xRQmBuDLJ8coEMW8nb8bsGjNtuBMTyq4z5rUOJYfmRdoNU4Kk00pm1itEQl2yfAx8+rQmEsUteX3/EneytDMkZanP0LmRr+Yd4wydAn/Ubl1zIaeueN2zx5RLZZAi05ZJY26g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ah57wOUiybWCF4BOBjDdHM47YC7849Dh0lvoa0NR5Fk=;
 b=dzIRzleJ5S4W/9ztIDGp0bgvHJauGtz1ewHWFL11rGfw1/P25d77ZZv25IJI9Je8w5WPMZaPy2+eZglN6Tf/594c/6kBgmnPtjprd7ttqrSxZbMA/ljvlqIj+76FazRO0V4c5z4zeB32RtBPx5g3CAevySCKmDAyc5BN15fi+R8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY4PR10MB1381.namprd10.prod.outlook.com (2603:10b6:903:29::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sat, 19 Feb
 2022 22:15:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593%5]) with mapi id 15.20.4995.026; Sat, 19 Feb 2022
 22:15:23 +0000
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] qla2xxx: Use named initializers for port_[d]state_str
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1iltah5ap.fsf@ca-mkp.ca.oracle.com>
References: <AS8PR10MB495215841EB25C16DBC0CB409D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Date:   Sat, 19 Feb 2022 17:15:21 -0500
In-Reply-To: <AS8PR10MB495215841EB25C16DBC0CB409D349@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
        (Chesnokov Gleb's message of "Tue, 15 Feb 2022 17:13:53 +0000")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0036.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::49) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17d6105e-3cf7-4114-05b1-08d9f3f552e5
X-MS-TrafficTypeDiagnostic: CY4PR10MB1381:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB13815F6BBADF9F658036CD898E389@CY4PR10MB1381.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1cS0O4MvJLC7TmolLHtsy/QSCrmb4Enquq+R1fOsGMdMBLR1KhIFsYqK2DtdquY/m2bWvo6tS7yFEnMUbuOxwpECQ3IFZ2OrwsH6Fg7X2UicGIK2tQ8/LgHebE/S8kzjAi9cijAvAOdAWPXv0s5EhNVXmd5lGgqV8Wnv48tif1C3EL3CkBwMRdYEwnRYiMRcgv/VdITa82zc+NbUqaySeJKYHS4PD5YOTp01/EGn8AI1SK3RSunVU1tNKh7ryc204AM9AY2tz9osxJG4chFEtBzknvakiM0/mYjTquhtJArNcUg2fZ1HmKA3dImzduJkGqHpBPTy9V3ccdCBBtNKr6Koi167zC3YTuxh3aFHo9ML2g8SfMaQ2ujLqKxIwVkbzfS339WM6WYyzzlcFpgUBpqRlukK+Lk7v65HZIyCYQ31UqMRyBSTyD2X4wlcPIvxCXZ5vajOswjrYgi/agdYJxM15M/OTmoslFU1gGwkXDElMfs3fpPwtsTBOn5pyO8C+o+TpN6VxU0joWIa3YOB6StdyyoB+fssNPEd4tBPDf928zTtUXziyKge8v8vH0fbxYNvj4yuQ+U73I6FTfzvx3ysTs3GrAV5TaUu+yNYW2dpugjqnY9oPJbL4Pf3bnMjsn7UAxjCQo06IXqaGrLs+LZIgvivW9L5c9+XW89bM9lm8tgIU48fceJXWUUfGPf3tae7At7Wb38TgR0HMl2J2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38100700002)(558084003)(86362001)(2906002)(38350700002)(5660300002)(6512007)(186003)(26005)(508600001)(36916002)(52116002)(6916009)(6506007)(316002)(66556008)(66476007)(66946007)(8676002)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?agUXsFknpHAFlzEW8ltTi6zTsj9ETnk3TGmxVS4FnPgl9PP9MQUK1nCHIfcT?=
 =?us-ascii?Q?e3gToSH0qGk63coKjmXhOVUrL2Txl5pD4u9p8G7CafS5ekHD9mfIaUlzz1Sy?=
 =?us-ascii?Q?8LMoaxk/E2dTooj+BX6Cyp3AoL6H1BMzOWoylyHKP3NNgVSBM5BDwxctm9Ox?=
 =?us-ascii?Q?gI6SvSd5/G/SivjbZReuNqhZw564oql81f3jheDZQPR48YBhd+3TWbH8kMMH?=
 =?us-ascii?Q?2yUasxWajbSSC7lPNJe2OtzE/uvc23xmEO75z+qV/J1+0gUuRYUfi7mKTWIA?=
 =?us-ascii?Q?DeD+VfminwQ/DzOXdL8aUjEjkX8Re96z237iOQUWa57FH53ZZgdoMPqBGEi2?=
 =?us-ascii?Q?0e4Bn9R/bcbxvOulwZ9qn0yl1BSvFWv7MPPB2j5a2gzBs1y22SrIVUfBl4YH?=
 =?us-ascii?Q?3SSdMH0AIjT1+30OtcUToxZqfxYleHY/+1YdXYP1XwT/qcDGJaHSoe7MiQo4?=
 =?us-ascii?Q?DSmcmSS69Aw1zYIRUlw3pQtcPTOyBwyhnYPK0v+Vtu/XWyPgWHm/PRuHQJhE?=
 =?us-ascii?Q?xVMzKf+SGcUtiOzXtcbMDs+TnlwbCCtqiaPno6uCVhnY9XoiW0Bn1VyoOnh6?=
 =?us-ascii?Q?jPXCYozVzah+mQTwdJwO6oGx8UFv9mzClKyTS/RILKta2zT0gQSwv1t06K4m?=
 =?us-ascii?Q?iMalOk4kHfNt+SSBhI1NBh0VOtZzwR4DEqKyZgucOsYJBamAnTYzZUDQkGnM?=
 =?us-ascii?Q?7jWxQSDol505n3F0+MKk7NhFUHV3iFh74uSWnyWhH54ZnixNx5IUyEWZPfPY?=
 =?us-ascii?Q?UUySdiKuVLN4xj9bU05CaczvofZzlVSwKQcJUyzh2JpGUhMOveB9wBUbIf4E?=
 =?us-ascii?Q?PhBC7+WQs2Hs/99DnpcAL0UMnIK4GOeR79Vg30bLEX74ZtRqzaRnARHcjjl8?=
 =?us-ascii?Q?3F2eDiZZfbmwxwCShX+WCjvbA7SmBA4+RNUrunmWoRGr7FTO7i6iLZ8MWI54?=
 =?us-ascii?Q?ZkFy7tgjpGNsf0n1MIQsdPFma3UtcxY0/ivFfTuDuVst/QB3sBS3GiY4uetz?=
 =?us-ascii?Q?5JSO5lzfiA0lWGsr1XgV7wmtJa1aaAZSBsrMrcg0FZNAbJQ++qi28ZZs43Mh?=
 =?us-ascii?Q?m+zlGuWylNPJCIuJpWWQ1q4ruYZUvngtMDbSooAVXUUnjckDV0uxLHoS6f/X?=
 =?us-ascii?Q?myzT/98T/B80/JTVs4BTTOSxs1K2hjGL0C/m5l0vBQ7hd9uJsNR+LVYidOoX?=
 =?us-ascii?Q?RHfF0jV6GfivSHPceMRTM6SF27Dvme12D/V6BEnhF0z6ryDd34iCvsjXBgp8?=
 =?us-ascii?Q?bGmgPR1h9vh309jJ8GwxxO3zZTWawqftGH56SSQj9CvcBM5TdEtdTe3PQ8up?=
 =?us-ascii?Q?LRz6sCOkXfOzXQvnEkDGhiyPPpN+AkqT6G7iJqL8pUoiTNYTJ5Bqz5GfzVgp?=
 =?us-ascii?Q?M3SBo7t2/F4mTNtwATEn6xnuUxFTq2WpcwAzuyzJ5IoyMDORGe/BAvVmvame?=
 =?us-ascii?Q?mKX98v9AsFb50Qea0NTHW4lqJGm+yaFjftkr4Iu+ZkPIQ6PcAm0yPFMLLL+w?=
 =?us-ascii?Q?HrEmKUt2M1EtpsZ3NgcD8UDKpOaKGvwnKHq44QkgOVkeKGn/FlnRXQC4Shc4?=
 =?us-ascii?Q?fAab4GcN3amtlPlaeUSA0J5qM5FwyCOBIAuBy9AQ8fysYBlIXOcZg4IPPyks?=
 =?us-ascii?Q?1FKZtIOnUDqYe7P5g5MCw1jAc1yw9wxRob+vG4xT3TPJINoSsaT5P3cIygdl?=
 =?us-ascii?Q?4xAD1g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d6105e-3cf7-4114-05b1-08d9f3f552e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 22:15:23.4631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1tzZcCoA8qCTk3VhOjBT6Z2ow8lj/LSF1D83X/AJwHrIYt6LTXk8DTVhmnQHKNxcmEKoJLyOGtWI5JRHmrF142cP0T0dlpbuF6PzVDltnW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1381
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10263 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202190143
X-Proofpoint-GUID: tx1Eh3xcyVZrcLMz0c-E6i9OsB987MBI
X-Proofpoint-ORIG-GUID: tx1Eh3xcyVZrcLMz0c-E6i9OsB987MBI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Make port_state_str and port_dstate_str a little more readable and
> maintainable by using named initializers.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
