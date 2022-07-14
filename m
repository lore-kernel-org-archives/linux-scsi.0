Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A58C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 03:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiGNDst (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 23:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiGNDsq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 23:48:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB1B5FB9
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 20:48:44 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E032X8009972;
        Thu, 14 Jul 2022 03:48:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=awRbjjSlaBBd8IuFxuUrTb88mF29H9A16gDbv0W374M=;
 b=zLrOFfAXRYuqNuimfh19wvlqCJLTO1GPqjSgehsMv7BAWC2NcCaEywBrNx4xYg5Z207G
 hmLDQxLpfnfHBb1ps/VVtk2MrRf0tFyFViAVEjIIBmeW3bhdcnjB9V4A4vVTMTrzQQ1u
 dPFmofxI02rF9737RkmotftfdzKPg1qQoDCKJXtgJgHcvk3oqGesMYDz6jIQoOxNQ3jy
 XDBbJzS+yDFFMFMY/Ud3mNb6u7XsjUYL+0Tv9qmn8M4OV/zrfUbcKDs5zkCSC06vItHd
 2Ock3ikomQ7adlFaMnRnQIRUven+/Dhbs+zB+9aTaSvesnwqQPfZXBtOLe+sF2GxmgwW MA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71r1bha3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 03:48:43 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E3eFDe013218;
        Thu, 14 Jul 2022 03:48:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h7045rh78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 03:48:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyicTqtR39VJNauOkeDjNegrQTxCV1NzTrKvbAedxhwDDwhw8TVBxe7mcXnCEODylJKEkrkbdTEtr93+2WNpRwZbaCMMlBLs5jtLYrefdc9pkwVrSZESEJoeRUZD6Ptmvk7qoRU8UcdFTGS2uGrAsuXfiZECs36YTjfawPe228ZqKiBOw9JSG9/SvVqjhXqv7jo8lc9NIyIkljh6MB5OF805HfN8KU+evPtStD30Ph+wFWo1Vj2CF3sx2j5YEU75cO+J0E4EqzT1AkbGSjfWXittLyS0OG9XaFdcCQw3ZawtGo4h+wxY84i4/e9Ipw1YgF1KA/JkwcFG0Dw/cAe3EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awRbjjSlaBBd8IuFxuUrTb88mF29H9A16gDbv0W374M=;
 b=Nt3VHoA7kyPPdToRRNUYuXT7HXKd54oY2AMydVVTktqEJeq7fudmFYrkCoDKNMaXTLLNsvlx3+vlYlH55nkQA8KjcZMC/pyz65EPDxf6aoUO4k7CQvdPfN+dCrDgfB32CIeADp1HQwA6VKum2jlAHkjyCIBKVWL9BeabYuPL+KO0abLPM8qCV2QyV/iWXqCMX5lU6h3qSKgBE3Nz/kZfPmqB9EV2kPBAuk20aDeSxgr/1RZD6/FzhkmHf/Rtz2YiCurA2E5Uz4ky7prUxWhqj1JI2ho/QnjjuKteh5h67/47yfboddDqL05eInb/TZQquLN0LTST7r2SUEPXZvKX8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=awRbjjSlaBBd8IuFxuUrTb88mF29H9A16gDbv0W374M=;
 b=oGBAfwvoXQUcIEMm5Vz7ykXBduG4wboYZRBSSutqp2lWcmncg4um9x+AknMScbD5Q46UgJBD/c8tXVaLrBrBU0wJE6ROOrBaijIfpVyjQooQsMlE3FDPpkojoo0ip+4+tyb2hLYp2uhpBFoZmA9wNBDAgwsJZNr8zYV7hY4SGRs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN7PR10MB2465.namprd10.prod.outlook.com (2603:10b6:406:c8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Thu, 14 Jul
 2022 03:48:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 03:48:40 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 0/2] mpi3mr: Add support for Resource Based Metering
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsj4we0i.fsf@ca-mkp.ca.oracle.com>
References: <20220708195020.8323-1-sreekanth.reddy@broadcom.com>
Date:   Wed, 13 Jul 2022 23:48:37 -0400
In-Reply-To: <20220708195020.8323-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Sat, 9 Jul 2022 01:20:18 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0031.namprd13.prod.outlook.com
 (2603:10b6:806:22::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c70e843a-5379-4206-777c-08da654bbdbe
X-MS-TrafficTypeDiagnostic: BN7PR10MB2465:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gpdxu0K4nkvy6OHSwmzku4qmJ18uPu5Pbuyg5DEJ4qUormonqqh0SO4X/oC+bXGDl3wnoeqXsysf0lQN21qzCi38ZkDQhWXgHSVhH+YXKeRwzYHr27XxV6xbMVlz/SDXbzkucO7ZiWF4br+zSbizTbTyH/jWg+xTkfpbAYc0/lT8YGm0p5o/o/giaiOVLZiJtW9qq401VVyfVMm57T8UCk7kGLdPpuRBtiqJLOwOGz2WJrwvN0kkIz1fvVrjO9l5vYd1v1rfP8glESSFQR35ZNYHj2jQYLnG/5wXHmFBqkFdBuuF/LmA+r2y3rTkgOQgBAsoMnFpoB0svbbMctipMHiYREeOkevDZJSoo+Len0vYH9OptEVfTeUPdJotUAO0+o1Y44n/OsOKwpjL3QLu0L3Xtpuwqr2CSyzq34eHsI9hDcHVTW93tSAAGzBJGS63pQEARZ9Mn5sOHZi97aWR6z0jxshEQkEIqCF3qjhfCfzGyZanf1vo4eGqeX8kDSKICTlpjrhVA74C1FTiGUYX5+Ka0cRp3Gs/GrwSD2oKBM95/3l7By2CY3QbZW8EmVNGugblqGtDwuR9UYa+ZNs8i65Wach4IietiYOpMV6SzihC3phh00eoF2oFxpBjZAESD8jesMFuFln02V8pmX8NmoE0SgOy2wC00IWccVQRPKBoIAHE1+AZprRAuVYBRQbT9ShtArGbE8l/c0fibCQ7P+1QVX3QIzIK6xPA1ce/+Lgj6uBCitFIlij4cIQYbaFRx3OTXcSkZtqtFOraNSnk894J3pjWpR3S0SGa4SvmCpq5bW5bOqD7KEGvPDH4xH2V0YUm+YBUWlDnkojtInSiIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(136003)(39860400002)(366004)(346002)(38100700002)(6506007)(6666004)(52116002)(41300700001)(36916002)(86362001)(2906002)(107886003)(38350700002)(6916009)(6486002)(186003)(4326008)(478600001)(26005)(316002)(66946007)(6512007)(4744005)(66556008)(5660300002)(66476007)(8676002)(83380400001)(8936002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PAggu1QkxECoXKRfi7dFYGhyO21Bigen6dqIyV7Hb6QOTAwU7r0LwQacLzJ4?=
 =?us-ascii?Q?CQ0dfGc4jtQn3s0pyBEMXcAz3SGUbetc/wb/T5hbzSh/UJ4blUYe4Q/+qeYK?=
 =?us-ascii?Q?32UzosLhFSXfTV32orO4EWzuGhs9xAtZS5F+kqmE4RgMSHLzdkW6GcZ8riDU?=
 =?us-ascii?Q?HFWq/Ja1CtaxgmnQ0kDXsz2XtvDrfQMu3xssbxME2lL7mWVwK3HtTY/OkUdn?=
 =?us-ascii?Q?BUiWS6hnLXPm5lkyVUZDBH10BnMlW/V/8WlGHd9fLbuW7+1q2ZKmzhRsiT42?=
 =?us-ascii?Q?re4vIyIFKiBKVT9rOAOHQ9rs4Rmc6HW/C3xBKPZQP/iRrK2k5oDYBfHuUXjy?=
 =?us-ascii?Q?a3q1GBWBCNP5tFr1xpTcyQ36lGUD405e4+aYNeaQ6G+wf9YT+GfMfmt+gG+8?=
 =?us-ascii?Q?idAxPEDVOTwlnrKUhME/r7JQY9ESN0vnYTnthv5xbuNkvcpOzkU7k043ZwPf?=
 =?us-ascii?Q?JfRIxTu0w5j8eD5YV+uN+kDKl6YkUHQkE9b8op9OttbA1zIFsZ4hXkN1jhei?=
 =?us-ascii?Q?LwYE0b6NjpeCbmoVpv1HqbPoCNS3bN9pYt+1ovuCSQ/VHFEqVY7IX8ews9s8?=
 =?us-ascii?Q?5YolJp19f3x7FkYPDFn/aIyPwL42e9Hm6eeJ3L7WrRHGHQBrfLUE27DuRdmc?=
 =?us-ascii?Q?izhHRM+ooCrfzHfPYJAccjPokxwQnftQE1Kp6mNl6sk815K+8j5HSKjrwVwI?=
 =?us-ascii?Q?pKvSo1AXw+wtssdEuWpybvyE5sToaUPfTHnPiP0M7JwiFDKNqCHEvYMApp3O?=
 =?us-ascii?Q?JCkrokD+kCAGf3xsEEmKoOTLgr63Ai56ZXfTRJT8aaeVj1snfeivlEdFX04J?=
 =?us-ascii?Q?1XAHc0SwBzu03BbpkNFyqX+dd2ASyEycr4z4Oai6BPNn9f05yspTCPoi61ft?=
 =?us-ascii?Q?fdAfnrgtyuyUUhmElLATC3LdfUQ9rddmSlknPNSTeIhrj5NlTLxhUrNyRDTS?=
 =?us-ascii?Q?jpw7T41w7f6TK2kxbvPE1Yl9PNX6OpoYuvNCrcG6Y8IR6K29379nTB4H31yK?=
 =?us-ascii?Q?wMhCRW1yOpts/GBjBymyojlI+/CeOpwpvAp/15cd7zF7C/2ts5pyh6mvZxsR?=
 =?us-ascii?Q?0axEEKR0SUgpzmbm3mcVGkptx3Dd2iGecdTJeBD30Jo85FEUDDxcI70MQgz9?=
 =?us-ascii?Q?jt3Tb1KQi2SdpSjG96hz5RySp5gp/S94K8x/wYFvBR7ret7EZy6ukGdH8mUg?=
 =?us-ascii?Q?2Q0ljHzBG+HjdMtZku5ZACgOKcFK5m5w6EOr+0B+7jkGSBQZjseufkRPgFw9?=
 =?us-ascii?Q?c9o8s5SLr/nvz3iaMqbS2g5KgPT/2Nh4NVOuH+22vmNWDGUm1gI/INTAq2MG?=
 =?us-ascii?Q?s0hqckR0W0dN5jmtvORXtn5SwJXsU/2jE5JaDVGCQeWw4uUP1KGNjVLSUKlk?=
 =?us-ascii?Q?y02P07kXstK5KHCr7BfNKqYPFIwm2sfRWIRyUXq3wd9De1uD7UwvfylXgl+s?=
 =?us-ascii?Q?yinldgTJSsgTswHL7SsME0ccOZgVa9XQW/gU5zvNa1DJBot6jfVVOSZkovSB?=
 =?us-ascii?Q?V3xjD+hyR4oznAvAYORomlWfnwh5JE4Pgopd97grYpuGTaf2TExbz0+b+rX8?=
 =?us-ascii?Q?OYFyaLXjF4V5gkM7P9Hp8CJaOhMXwKOJS5N236ZQ+/rgEH9eYWneYMhpMNwE?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c70e843a-5379-4206-777c-08da654bbdbe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 03:48:40.8081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EHzFd5vv3JY+pYoPRq0eVX7FYWENc21t6krEOkcxjX96bKXALy3wh/ZJ7bxrZys9gZsX1TB3XPQK120Sy5H6/vqhpYZnhNkgBVfFvPmIVEw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2465
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-14_02:2022-07-13,2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=881
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140015
X-Proofpoint-ORIG-GUID: M2JW9xNQtrBYhLYkb099-VX1hMy2IAgg
X-Proofpoint-GUID: M2JW9xNQtrBYhLYkb099-VX1hMy2IAgg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Enhanced driver to track cumulative pending large data size at the
> controller level and at a throttle group level.  when one of the value
> exceeds a firmware determined value then divert the future selective
> I/O to the firmware.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
