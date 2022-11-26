Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC4EC43217
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 00:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiKZApI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 19:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiKZApH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 19:45:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C03C22538
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 16:45:06 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ0NY7P027369;
        Sat, 26 Nov 2022 00:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=vag0XBiEIGsIJIDWCI5SVNJywaa+y8z74rF2AKKaIQQ=;
 b=FXYYWFusOeqpw4YhclrvvviIMr9QPUZ9K2gfhUSOYuMXZN+n8CIzZK6U6qJnhgBt3cbw
 x2M+wbh9ap1IQ/X/95SIByzRn8PbSbwEkiGjMRYlE4RKo69VCywdCLggq+bGXNCVkqJT
 VLi4f3bgVMsdafx/4qsNUsgE+puSjWdW2v9zWSTnqe+DqsFeEvifSipiTFRGC02+Rgnb
 EI1TL3FZCUhs+pQUINcurx8+0aomOwjg9BrWEmFBKTgvHgVNrhYijBYpCyDtHcO5ZHlm
 pTpEuqyyAcm1vPDOl/3RgSBNXtpxnlqVG0X0IeCQLoA3+7GbJRH94ZQHRAqR5sRBn80B 7A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m33qk894c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:45:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2APMdgGW015919;
        Sat, 26 Nov 2022 00:34:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnka1u7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:34:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BzoX1nQ3nxGhxTYykk7ItbiqYNdgxCxCa0CKrVh3wBaVDksLav1d77u3fYzOhL2QbyydYdlXt5GjbMZ3x8ZNG2Z1i1JzPabDmS+pNekF47kvCvZMq3PH+bCaCCatfWmODqP5BtLn5rjq1Gyj27nAnzQHCBxrdPbSnuYnZSgzTE7RC+fE7p7nsltjjjhAs7AU24sCcUgTVC4IrFkIuiEQBTKCAUGeUxH5xrDYR8ZhZu6qagqBHo3e4Ly75dk5U2U3Xitbpzv5dz6Vo3mNWEuXpfCj3kSfkrvpIn284dCtGilhQpPmkfpXqRwZ4xtDfreeGvSti0J1mLE/Oor1mHC/GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vag0XBiEIGsIJIDWCI5SVNJywaa+y8z74rF2AKKaIQQ=;
 b=REwTsHVroOzlGxGAZGHuQ7Jb8m2wiPCQrafCPXDooWeu5T/BJW+Qqh3yOnUpGZ6OLlCMNHmeRlXEGYcmUZyY4vnVxlN+7M2asibxoKJqX8BTU+7H/qFnpY6T0bmUD31OYGIB3ybu5CTbVy6wuosqdMUmjw3FNb7ok6p5BgL7JEngMZDOzDtfGn74ic2mWPiUINkbOJARhobnvPVLGF6fHcvBYYXCRU8Z5oCbecv7uTADwAYz/7DnLQKTWWjIRW6XmKfCOhrLbPEt7V3KXSxSolZ2LjthEN5MhV99DIi4UM6vCvvuh+IFkW3ob00W15djQT4ckBGu2KRfvpY0fqOnKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vag0XBiEIGsIJIDWCI5SVNJywaa+y8z74rF2AKKaIQQ=;
 b=Q2lhoRHeNzweSAQ4ibAp3+KiqTij93Lgu0W1m3/2U6qThrK5rypAxnvBydXOFtCZw38x3HpjkihMqVUaendg3hGvtfKNFp/jaAGfvq/kB98EPKgnYIqJGSamvMeF4TfxLfc3yaub6fqDryleX7IJ/fisu0tl2H/ZENnjqL0Vmh8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL3PR10MB6116.namprd10.prod.outlook.com (2603:10b6:208:3bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Sat, 26 Nov
 2022 00:34:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 00:34:12 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Rework how the ALUA driver calls scsi_device_put()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a64epn9i.fsf@ca-mkp.ca.oracle.com>
References: <20221117183626.2656196-1-bvanassche@acm.org>
Date:   Fri, 25 Nov 2022 19:34:10 -0500
In-Reply-To: <20221117183626.2656196-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 17 Nov 2022 10:36:24 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0048.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BL3PR10MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: b06d0e1f-aaa0-4813-d9ac-08dacf45f0d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N3zdH9Oj9Gz1DHiLDj/AU8QJlLbjgj9klfHPKmK0yjAUDtijwcPWYwgiY0ZVDjGM5bLuaSbY94AAPX6mBaTu+puzGtbHjQV7pdI3yOoFXwGNR1o9puJHbm/s/gmjcsPX7CAkqwWeIXUxSdEve97pqG4KKKaHJuEnTT2LrXbEmEpTnK7lFJ1gAC18+/cCkUUs2+Xs/sWvu8FniVTAuhBiQS4YgizNnrCGXOWgrMc57uAVDrhU1l/a/EwQdqcMQxhx+GHtSTnLkE1kjKBJuGMV6KGHf81EXGBkXZMnG2YKwdmiBmNHCSqKsDoesSmdA/koPbN9xBHYR+k+PewVLYTGZDr9e+nDjBsCNCHBj+9VZ08bas3cDSJyzVoEYN7TQNCdIuo3TytCTs2zAQsFhsJuwAdQxwYhF6Zn4870h52mzn/1DYPSbxCMC9EHg0QzQSsYBXJitoidICF6hhHNI15Sut2/LaZe37eKPDTz12aVPrShD0Dpks/PB1YLIqexF7ECHN607XmND1FiutEtmevUB9zd0YLDMrN8yVVvJUJmXDTbHmu/u6eUNBHZn28ux4gTPBfz61WGDNbwsfID2dt+VZqAV2jujds+lhuaAHiZtk4Ae9Nc9R35FgMV7iae3S/gx6dTnXq3Z0VlWFgR/8UHoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(376002)(39860400002)(346002)(451199015)(8676002)(2906002)(86362001)(558084003)(66946007)(66556008)(41300700001)(66476007)(38100700002)(6512007)(8936002)(5660300002)(4326008)(26005)(6916009)(6506007)(316002)(6486002)(186003)(478600001)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NWh96w9oUyuPxd8/uiN3gTk3DBhQraYWIGOIbi1MOr92jwU82Pm43r4ixwWa?=
 =?us-ascii?Q?ovhej4qjqKiXkk2bcmp2426F9Ti1vus4pCOtjzVDceshUfepm0joG9vTfz0b?=
 =?us-ascii?Q?vYm8NJIS3mkqDMRK90mYGhWK78zPq6CB48+1x2YGm4y0s5ZUGUH8q0sYnJ8Y?=
 =?us-ascii?Q?cysjUX8Q0+L/HSvFwhmOXmoSjYa4lgCCz0QhEOhYrqCVcm2TocqOaYOhkQ9M?=
 =?us-ascii?Q?tjzW/K8qc7W7wVOzGatn2/x9hDbz6e14UB+Mz3B1WyfnJkU0FwJN69COGWut?=
 =?us-ascii?Q?YdqWGQMERrimBOpEzcTEMH0bryLlRbci7l6kg+6sv4VfpBUZ3VX9OogInCjU?=
 =?us-ascii?Q?Xq4Jfk8LM0ZKARC7rmPG6RZBIqN+RfvPCgV80aoDXQ4aE5Awa6GcVqodzMiJ?=
 =?us-ascii?Q?hboBmFDBvdPttVzVx95y1SxgOatfEHRsyLjMfZR073sgsJh8b9lKgj1RxGNE?=
 =?us-ascii?Q?veRVYexjUDS8AK23P1+sCf3FYw9qikrYcq7N5EK3/qLgEYwpsyYyHiV+P+br?=
 =?us-ascii?Q?IiHLa28UmNlHlCAHofFU2SbN0rU+Zk7W7UJXsWWCkiJ+qWIelwUCPgDfvTAm?=
 =?us-ascii?Q?xHWwJFrVEmfD1TCNnVeX2CNAbrG1Hcnoy2xpt9JVfTDZtynG9JGSFIIfpu81?=
 =?us-ascii?Q?ijrn4SYpKM36ChIDEOBwb6Y/VDUZQxMHFP9R/ShykNV0UWBU+cpDVQQnD5nn?=
 =?us-ascii?Q?Hcz4Ceszy4dNgWJXOky3OKQDIc9UZ5pfdQMCFP8YNCpGx4jddc++SguKs0a6?=
 =?us-ascii?Q?+lUhkQdzsLT6B7FezF9S1+INn2HHUqnIABkya6uHEGJLnUkbchFGw/MjvdFm?=
 =?us-ascii?Q?exbLod1SfUcgEIrY1umwtt1ICVSPlRmI8oKXPY7Fa8z7nRnYpe5fTmGR7XrP?=
 =?us-ascii?Q?j7AFkUyHLbcnmh0Lp8u9hw8KTOzJiRBxTWVjCtUDUlcYFfCKMBysCNAUEn/6?=
 =?us-ascii?Q?h1al2MxPrO1Boyw7s6YZiC63HbYg2hpL7dmdgHNVJDKu8fhnUimvwtq7Lglf?=
 =?us-ascii?Q?qYOQo+b9C8Kpl6mofRZv3lbkykrXCcSLWi9CsuRmOK6IMtWt0UQ1dt1NXm1p?=
 =?us-ascii?Q?XzGiuIqhsxkLmXDY0lQmlT/kBxz+HloGqD9JN864b9POsIjIFCat6ov05YMO?=
 =?us-ascii?Q?eKJboVMc3T+tIwJ6AZ4DfIGUpx0gdlgGuBC4gcIckfPtURo62fnsosbKbH20?=
 =?us-ascii?Q?NNPkPIwVIR5tSHecNL215yEP7BtrdxGiHdccfCU0YSVZo5r1JF2vrBTGva5K?=
 =?us-ascii?Q?YHNrMDzJ/WCVaZGTTszdVUU0D5kQ6fGUla+K8GAhcT4/jIGA0hb8+gn45GbV?=
 =?us-ascii?Q?SJU19NJ3+B1H59ZFMubbOY8NVRLWBsohmSbXwOvb+1zs89vlpEaWQmGW+h10?=
 =?us-ascii?Q?cNM1C1+lp+7+IlMbUgI5DISr7zes08gZqdiX+Pt66t8KaxCXc+bf4p9SNk+R?=
 =?us-ascii?Q?WIGQP+dnFT+dA8HXl6zNl06CzmP236d6va7clAjU7HsctJSgdxrtw2Xg1UZo?=
 =?us-ascii?Q?7K+07pJxQluv7a3kLVMQ+Zm+VBIqDXDwPBdHvr7zXdEe18GiBEafKqxWw3Fq?=
 =?us-ascii?Q?vrfzdsRN7NhqAbiF+1SXP7AIyaCZqFpodPeGgW3ZYLCUUBq6MaK3PZgUcBQ/?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wL+ZdSjrVI/J2/AKc6GQAut+seblWRJOy1WnA/xh8gBdOn2DsW0jeNz+MhLISUPtjUGCBuQMPFoduRnvIpNfu/blc/Ae01EeuB+sWHU/PprmK9tm5rEhIHWjEjYZAmTaHzVtV5wRi7riZLrKdXI1JBhF9LMqwQHlfqSpYOZizHfxy8OM54w+EbLdrNl+/YhT93I6FfivFU7r6kp3Z9sKQEaJdMXb/XJY9n6KAn+grtjYZf75Yjwqeh1iTfNli080ndLAP0q5XsUHya1zShFSGL9+EpGMgPLu6nhs9NodO+SmNT3iLO+BalWlWIKuMTZ/XimAAjbcAGH7hwC7xTAEhLJYuwil00l9pP7/XpuJgLuZYnkLxGoQ1FKdVyNZtNZoAFEk1Wdk7rEInwHyN3I0K+QlEwvv/E1k2l8b8N6XaoHcqaCQMlwvVrGp1MoY3OnznYJ5u0xkIYWszcuCkmz9uy52KjiylhnIrWpv5/4lv6WD4UuAm2u/XF11h77N35t2HaR8M/EkQ4bYovVd1fRmzUw8F6tbjYRYX/uv8yyH7Dw2yr252cYkmumqO4W5akXEhcDSb20p/FG99VWQUqgczNfDBEm4w70c3CYUQxgVnliI/3EaAKjM9+Ojy9prLIfbbXUvp7s9c4Qo6BlXDaKpM4o6HFn7AjnTePA8dUsddqoW+W8V1POceYjJiIg4El5MJ7yfVw5Cz+ipm8BHZR5K/YL5jKyX1dj11GNf/HOCFSokfho+yqKS0BwAnzRiwUIeX/zxPKOpFgwvVPT6v4G6D0QiOU3M7tsUxG/fECL5F9M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b06d0e1f-aaa0-4813-d9ac-08dacf45f0d0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 00:34:12.7507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EicHU92P/5DzWp2SoFlddAtbjd4DbmgDTLbUaG7sIFUTnhlSEkydt3691GrcKKL5bjmssjHFa857UVQcEYxu4wMc6uY0DGybxi5E2L7ExI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_12,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=734 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260001
X-Proofpoint-GUID: 8c7zH9DkR3RQUClacs0UsvsdiK9V7S5e
X-Proofpoint-ORIG-GUID: 8c7zH9DkR3RQUClacs0UsvsdiK9V7S5e
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series reworks how the SCSI ALUA device handler calls
> scsi_device_put(). Please consider this patch series for the next
> merge window.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
