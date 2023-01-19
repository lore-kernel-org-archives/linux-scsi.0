Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89276C38159
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 00:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjASArv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 19:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjASArq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 19:47:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3B2613DD
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2023 16:47:43 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ILnKnv006895;
        Thu, 19 Jan 2023 00:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=QgAW7DZ/hwaEeNTGxO1HFZxtbPGWzPeMOLRJn52B29M=;
 b=hYluGXJij9Nat0G3ZawPL0+D6YUN0BSxpaW6s8UUBUTuVCaJTsvGzj0jrwNirfge2Xrf
 J3GmyfEivsZfnqD7sGdOGAOTThSXnoRcmIcGWNvn6Am1S8YFWfRYmJdzxK0bBRbNytKp
 Xdsm9rQLBHNbhDk/UzlaPULY0kbG0/T17ZNXoVeZ5KNMBeqcraiA//0mfW/JsxffEcbu
 kIB4bwpXPreoyeAhz8ZVaMl7B9C0XUyxQ4qDvpQm5hE0Z2vzLBPRZGXGwOOlQxwKf2ix
 cr1QgEmBA9KTzycQlA5Rh9NFfuCGNZLZOKrySXKSuCNnapNHlE/rwCsAYl8SedkLxOfF hg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n40mdgf3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 00:47:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30IMk2wS039695;
        Thu, 19 Jan 2023 00:47:36 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n6r2tq062-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 00:47:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZl45HXWd2f335XoFS0qIZxQBVlFNGZ2jKnWgg3Oo+CenikR6mPPSRec8SSzZT1NUz9b4AX9V1eyZNxaGdI0rc5/t/njRBrDfSzWUz65zBkaa3PvRMU7EfjBuiuqQn8WUV/Hmf2dDhMYUtn2xSgGJa94jVqThuFQtDFSW+qwiXoiGzysegbvE50lY8UUg/+uEiHgvKSZUMtAipVHLH33nOzFkbfsp5XTNWuZoqQffc/DdizteuWXPsXOIUz2K1loCsi0pTE3LGr1q4+WfbmIppBH3x2wpej1w09QDnt+LfDvM3vLYdg3wpd+XegAZnuKWz/UoRcpaYvjB1a0UgLXwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QgAW7DZ/hwaEeNTGxO1HFZxtbPGWzPeMOLRJn52B29M=;
 b=WmPn4HcQYSh5laakpDWhKKAPDgDT1O58J2WFbTrdRUifV2YGF/zfbpq/HE4wvVKfCM6lMEPYqA/CIBeNwFoWpFslUSzDvCeHwO44i1OjG2QZWxWvJuU0VxkuoT0gbchp7h1FDkv9opbijAye60F19+L2JR28YNbPWmPRanL5SH2oeDpgRtv/yWcr/MwIA9fpZ9NlzaUgBt4SJs+YFv9G2JbzC8XrmpsKgoMSKcEV6FbI0sCaIJXGm+Ic/smvTJbMfuGWIUzMGrh+lgHbRrqV/JUkG6FGxMjLwJXxiDNOM3iVgUonEvG8yKPlz0MB8M+qBbH0VO2mgHpBwkBiZjyh3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QgAW7DZ/hwaEeNTGxO1HFZxtbPGWzPeMOLRJn52B29M=;
 b=x+zxbwo/mnv4CgCySNH8i+kaVPfIgFSFIooNwSe8+Lkm05lfuS/dkVWYD1MfEvvz7jaXzp7sjzTUJdSh0GF/huvUArELqWLnUc2MpXV9KDo0jkI5dLqarz/YCW71uRcYtLNWJVsGBxInJcsAUKUuCztdsE1sxRoKgs+7i6F849Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4267.namprd10.prod.outlook.com (2603:10b6:5:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 00:47:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6002.013; Thu, 19 Jan 2023
 00:47:34 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] scsi: device_handler: alua: Remove a might_sleep()
 annotation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a62fnyeh.fsf@ca-mkp.ca.oracle.com>
References: <20230118180557.1212577-1-bvanassche@acm.org>
Date:   Wed, 18 Jan 2023 19:47:32 -0500
In-Reply-To: <20230118180557.1212577-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 18 Jan 2023 10:05:57 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SA9P221CA0020.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4267:EE_
X-MS-Office365-Filtering-Correlation-Id: 468878f4-9a1e-4274-1eb7-08daf9b6c133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5EJRFKDTqMA7cuyxXMdJKdiQQDB4NQooKsVVxaZwHGxT8OYd6le2VQV+fLRbDrTh9AK56J78UiVKsA2CHEAN1ndOBPuZBm6hT6LtZ9ht8qoT6PlTFKvODisCOSb3M7Qe/qJmowphRL57ahbRV8G1OHOD/78YNr88ybl6DDa2LrybFkTy9vx4HZXEQ9d2RekVEPmLu0buGSk2xm3yovvP3yuOQAxYohveTpCtp+HJ5Bk4khNdOieJnIwoF85q/oog/uO15i9S/Y4ySfdKUd+k7bHwHQPtyzpw1I5Ksyf94rZ4ZsidJCeZzRLvHnzLH6ZShgo3AvNjWv2vAqjXGs1TplmxvN9+j6Wibq8Qa+tBLWYqzfZNd7/26Lmcyl2UVkpVm6B/u/O2orsmZQmougyjdf/ysO+UMW5W3v1aknUBPfTvU1UgmEXNOKA4SNqe6BTS5xT/cnwRVhEVNGTxuGGAKLqWkrFWBjESrRaLLLy2lTNWVpv1VSM0xdhhHSK/MTo8ZHim9pvgwqLdzQASyrA8+AAmsWR+RjpSi7RXZuaP+RwfWufF/qsndvXyjwmN6lU9H8UiTwx3HbIbef+mx/enuHiUcctGDJG4TKxi4FYvw5t/0+T+/CN8srCddQ3Li83wIWfZDAzpCdExS45RAG0vww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199015)(38100700002)(86362001)(36916002)(6506007)(186003)(6512007)(478600001)(26005)(6486002)(4744005)(8936002)(5660300002)(2906002)(41300700001)(66946007)(8676002)(6916009)(4326008)(54906003)(66476007)(66556008)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vrv2fJUA0+cuutbPSv4OcQrSN8QgLbVitQWYbcLXMdrc795AMOvPXW+ylgU2?=
 =?us-ascii?Q?8uESAk0loXWrm3k6UpJqCUjSzAnGwK5ZkqICu0z1d974bdxRc+5RcHHfSJt7?=
 =?us-ascii?Q?mEeA4YRGiEfe+HZW3q7/b/MIAjDKz4jQs0ICTD6ioe2bjhKvQ+BBvIDOrg0k?=
 =?us-ascii?Q?XafxkvfOC6X7wgXo5izPYh04aK2npN2uxnLxIHcTnDxiVyUh9ncbhvt0i+61?=
 =?us-ascii?Q?4UHLbPpd4SRGY0unkDOyWIyy8XH1bmuhJ3z7QagrKIIc28IIJB/CcY8wP9Mu?=
 =?us-ascii?Q?gc7p6FEy4DzZKM+Oi3WrTn/1FUj/dcrEaALVyyy6rqced5HwRFxayys9YCOe?=
 =?us-ascii?Q?cCBEx55RUeNfTv3cJF1/3QPypgk0+PdsDR3jAWOqS86XlX3ZZiLnxQt7gyUx?=
 =?us-ascii?Q?4eL39T4jy/0EOa6NQT4F+sp2lW1Uk+vXHLp/nGxkCf1l/T9VY8vdQjr4O47X?=
 =?us-ascii?Q?oS+1W5lz5NbPhSec6rZSVKPEYwPFpI7+vdTkUs8TZct6fhfqKNsLVviygbhd?=
 =?us-ascii?Q?YV33Fu6qRrw+AvZvrhR/rlIlOqBWsLllV+JZ6uuVUOCIjITs4MXvt1y3q1Hg?=
 =?us-ascii?Q?GMddZhwy49sX6GNtHZE7KXLXI5xWPGbl3wB4I4dMQUUzfed+Vc54EoTNUr5C?=
 =?us-ascii?Q?zFyL1vvcULmpsXiYn1OOlLbSLYZLL7diE6WNL6S+4wiaDDBdTgO5TKSuSpGW?=
 =?us-ascii?Q?CeB9ORpbJO+AGb6HuttL2XCLa2EaUnhayEeMIlVeTtKzwmNnGjxdxPip9X19?=
 =?us-ascii?Q?tOMh6AuTJBU2ILQvwOHH//eSa8sZxAgisR/L7eT49ZTPJy+lv6bO8hM7p6m4?=
 =?us-ascii?Q?0A9wL/addPvkAMS+awDojNyep/RHiJl5NAv7R385S4v7FgkDUkTAVc8Qjwgv?=
 =?us-ascii?Q?RzGuhINq39Ws35DcpzMsNIUCqglYl6R8fyiBe7D8odjZaBwjWyQjE6nfYTx/?=
 =?us-ascii?Q?HYr+acEBDFreZUn6GE2ep/8f6sGV8KYJl7o71l4Z9155XNWZJlLg6KIeI2tI?=
 =?us-ascii?Q?5dl06g8x32rwqIJvJlVhLj8jmJrz65eQMi/mI1w79HEzX4rMD5RmDVvLQtOW?=
 =?us-ascii?Q?LpQkm8OBktpPEl2FcmZe4x33F3gOA8Nsm5qN1ccJ5jw6KpNAPwxzAPzILc1V?=
 =?us-ascii?Q?3cG+uDUaTFuFlsDaJR8Nf2kcdBahEkaSCYcQ9cZlNJ63ypg45/wU0itDDvQq?=
 =?us-ascii?Q?SrqleNqce4wPtJHb8zJme0uC67Vgqtq05CRI6izmdgtjGKMzSyAEuqwOVNY+?=
 =?us-ascii?Q?Y2TKYsXWgL1GRBr5qvfDKAWnh0RQrGV+fxZ0p9LuKUC1bZ7vBmADiwqrhbUb?=
 =?us-ascii?Q?WlV4wiHwKQXSMzl5hzhZRXoMyhsXbMG5L0AI6wIYo9eA9HpPh6GlOmJSHTSR?=
 =?us-ascii?Q?HP+xqnrFmfINB1/cSv2iDfYrmiGPULOcicTx9jubdvkcNNXtCe48Sjdr3YL/?=
 =?us-ascii?Q?XJGzaBujplYAFUjTEhZ1MhguXFV5LNYKn+D7DLdPuiRmV90UOETzdGwLSIrx?=
 =?us-ascii?Q?cpoSIEuJ+3tOu+q5FmlzVomIWJdr1zJ7axRZeg8x/bhrrNx3Iv1uakLOiSNe?=
 =?us-ascii?Q?OWe9OeLxinwc+zK+cNiLbv0+p7Gas1feWGFHU4R5QIEjQ6TJ0Tc/5DHIVnk9?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: PaXVdLgZzgcUKiLiopQAsiuVd+5wI2f+zFULMraCsOYrq3aylbHkM3nG4jUTHDC/5ZDcCblZoADfmedmUS+VW7zUllk6RvfHQIOalVmM02xq0y8GWGBJr8cpvbk9RlsMbx1OPLcdrVFapvra+YTNQ1nN4vH9+q/XNF9aeWzWEzyr02kfjLnBIL2MPCiF0hJnYbHlXqs54nmHolStcpcpy+YJk+ly/yWmTnbGJkXc8tvduUZhFi60L0BD8TdSFj2UMBgyUN/4PdrR1vIkFtjy+lbgYB9iogDt1cpAsDKwG2RpILDrFQVe2rQOZuBkTYhFttdt+ZL7W/lmeSQ/z184dWOoTG7ssr9bcVoF70jaG4NkGEP8bQ48wst6hNibcXSykFwCS9lYh+OfGgkcNpKDrRETPgaFTxM1GlD3qfbOA4dhkRqsH6BD3Ue9tnS1AGhrykG9qMCMdnAdCzWT25K3+wrPp9jomfk0ibsA2EYjOwgP7wLztQ2j94j1IVwWdiNvGrpyQHVpZVCF5fFwPDNxFvm7Xm5llKOhLS9sJsS+l8WHi4LejOvHFrUU6Y/T1P24otXHGiWHq/4iRNFMq2diAqRHdfW+5TzmK7RmNfw9AgfsL90MzV/0nmQkYThO6kTayXp2jyz/qdr3BfTT9oYbrvbWx1pKr2IGGuo7P2zJFZj3k5+M0P0Z5u5d1nDnuRry3SqauNh3tDJm+ib3UjkB5Yd57DUEzfx4gZ00M11KiZLXFwej+nETT3lbvAdNbedpjGbFVQjvUSOFzNWu2fpjndPM6IKA/OvIGeqS/DuUOrFRIkNIuo3olIRtLLu3xsknC3R/DVcKlXYcxoYJcbWLG7PfCpt+Msy1JE/LDGxqRvg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 468878f4-9a1e-4274-1eb7-08daf9b6c133
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 00:47:34.8775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wRM4Owq2trgCxS58Tcaq9KVsSTxtGol1otKdInIDldj452JQPuPiSIMBu4vetmYDHQKfdm5JDvlqB12lmkgUy2O9g0vj5kHfeF7vO5GiN+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4267
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190001
X-Proofpoint-ORIG-GUID: UWfqqLuKjAUKp8l9MN7KoqSLK1d-R_dy
X-Proofpoint-GUID: UWfqqLuKjAUKp8l9MN7KoqSLK1d-R_dy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> The might_sleep() annotation in alua_rtpg_queue() is not correct since
> the command completion code may call this function from atomic
> context.  Calling alua_rtpg_queue() from atomic context in the command
> completion path is fine since request submitters must hold an sdev
> reference until command execution has completed. This patch fixes the
> following kernel complaint:

Applied to 6.2/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
