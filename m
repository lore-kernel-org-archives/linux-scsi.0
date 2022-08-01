Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8929C00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 23:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiHAX2p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 19:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiHAX2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 19:28:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CE21C90B
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 16:28:42 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271MEBsg026096;
        Mon, 1 Aug 2022 23:28:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=AcTMYghIj3XgANgwhA5ekgql6WyDQ0+MPVuAHQdTHJg=;
 b=mxSFuXopYcqk7YS3gJrUA0UqrDrbVxcCotWd6ZgPMJ0ohIKFYSwzKq2woWUEQVp8Wnej
 LSrdovYibVLaccjobYlO7y2Jr5n70STN/bKcnnoLzbKoFsE6+K3kgq9LkJWVkM3Ts6ss
 KuSGLMhG14t8zr9OaaiH4MWGh9XPNGoq8szIEaEbXwwj7UxT94Uw+LVRMwjlqCrdGdG7
 yUYbPGcK6sUIYhsf3Hl85Z+sf1M17rCqTcY1mTGSOLqnM17N/seUiZXBV6T2inGUvL84
 KSEvm5mrSLzgI95onxvyY6z7pnbbbSROoEfM5y8ZVrzftNgyPQM0IPtdvBqMjgYSSvCA FA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2n81w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 23:28:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271MU7Lu001067;
        Mon, 1 Aug 2022 23:28:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hp57qnqaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 23:28:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NC6W0CHC33gBtFSHDJZZV+LeUVcYNctijjF5TR+qaEyXkscwICRYJ20eYmLUIOsh7f3+cjySZNrTKAohKzEThgba6r8Hgv5O9ABvuCyCS+7vXSszMs4qK/olqAZ0BUb1IJ+VSqvkhn+/PRO8uIm7kdRrD2ocwYxB2aV5+yZg+ZTEJdNBz1jp5igy7IFs9go0XmndSyLa+pfLKjbAwrMiCN+004c6gsCVMeTUTU8BtzXOMmVARYYn9aN/HbKD+kJOrUgRXm3HqPd/EdiL4mSJQWTHwanhvNEYmheJEj+s8i2dX+JFwEEAmFt9MN5sCMeWmUfkDK5nRCQ11n+Mybve/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AcTMYghIj3XgANgwhA5ekgql6WyDQ0+MPVuAHQdTHJg=;
 b=Ix4PEcqXK14qjuRhkF44jjwITYJE0sJ1BSmfsQiHjYliGd5MLwM1cFpqRoBVg4ckyqNXzsjF8+QmT9iDGI1KsbwGA1P+oZTlzdCeog6cyXmIr4nnYzwO4zwc6GYhFoEtNnTWN+oyUVDIqaUwx33R+ZReQLmVKkdNQ6A4RW8rQKqHg2E1fFjJ/mlQ0Dw/1aUg7cAOj/9hGxnTBl/42ObgAnykBj1sMcfnaVljEkp0ZBhdlvff3e0g031KC3oTHIanXwBXuySNk1R36q9ksb6usZkKEkbmvhS9ITblupOGDShu//IZLuKKV+1SiE/xEKnwIuQoeg6lFxW3CYy1i/dSkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AcTMYghIj3XgANgwhA5ekgql6WyDQ0+MPVuAHQdTHJg=;
 b=nXM8uI/kqSyupcNhMcq6XguBaj3w+OFQU6FRAMEHwgapoitBWJ6uRg3ae8X/OMPrOtf5MVH1Hgi8JGAkqOk7zz2xU34mqZ7kkPvolPyVe5ayDbPTXnMhBORRp9p0xVwnxHVUuyj22OPXqJeyrp3vej3RjAS1c7+erK88zXRcTzk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB4962.namprd10.prod.outlook.com (2603:10b6:208:327::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Mon, 1 Aug
 2022 23:28:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 23:28:23 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH v3] scsi: ufs: Increase the maximum data buffer size
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tu6v4k8n.fsf@ca-mkp.ca.oracle.com>
References: <20220726225232.1362251-1-bvanassche@acm.org>
Date:   Mon, 01 Aug 2022 19:28:18 -0400
In-Reply-To: <20220726225232.1362251-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 26 Jul 2022 15:52:21 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA1PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2678aa7-9e19-4613-ae54-08da7415869d
X-MS-TrafficTypeDiagnostic: BLAPR10MB4962:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: azIcLiyfLjj9inlQgS6nBN2Xb8/8917sF+ogk8wrOp8R/xfn6zdpTMaLddUK5RvFyt1eMPM0aPf+b1yuyyyvifX0x+1lFiXBIU/Kc2jVBcH7y7hio4hAW/d9vpAlxDLQVBoqvQbyto2euMsmd4wCxXzAkXInZK7ROtt+Sb75rnGH7n1A99UkMka9M1KDdrMUUrwql9G4oXutOipjX8JwN8LQgH+7j0DBOnfgGOT0ij6hdicZ1Vdx4h76I0RQbY2K6AmTcgvs0qx85E+BB5Da4Uscr8sc6mgJ7gLR+VgWGkTwJi8NArphtJ55spYLaT0hLO/vxIerJo1naLgc1pddwdhRIUqLimChr3KWt/NSzhaw8aS7M+In6Eilf4pYYHxxHvFmJ3N+ynJerJIZ+fl8JRgUEsCB4EiIZNQeEcALX5oPbeUq2NYnXjev9E7NMJNBLpylfLXqEc0X5lgkZ906ZkddODkLMzRvqluwJOmU85BXXrFIymsxT1KL7V/x3eIowJ0vp/zfEJFjc+1NN9UzdKQUW1rEc6NNP0saoKVa/asAX8D9uyev58421XKNzmSjnIJH4YY2kfChHtcpfdp4mg04kVaDT7TKG6YCWG13cQEgutWLf6DW8EkM9z8KuKbgeNjNPHf34awSAg+LAGJqIBwI3wPwV5btbm0CU2Tkiz+hv2Hwg8T3AgO5KMfEgdz1IDX39ucb9ss3aiDGOE6GdejRFT23oKLDRpTJly/1KtVubJ0TLiKvZpK1EYgT3sBOqpoPQo9JmsQEDsiHMBF72469hj8ShZjyMHlppaEQ65Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(346002)(366004)(396003)(39860400002)(186003)(36916002)(2906002)(6666004)(4744005)(52116002)(6506007)(41300700001)(6512007)(26005)(38350700002)(86362001)(4326008)(38100700002)(478600001)(316002)(8676002)(66556008)(54906003)(6486002)(6916009)(66946007)(66476007)(8936002)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fCe1eM1F7L+9CeqZxU1g2+lIg7S8DZYwbBu0SeOnAyLkFDBbpgMD+Z6dtS24?=
 =?us-ascii?Q?Z7uo3KaE2Q6admsSSBqkZDhJeWSuOQGPzOLNizy87EbpwASjZOpnCgHftK8m?=
 =?us-ascii?Q?AFCV5udgaT6HErACJ6JCQxszJe3od9gjnnGEn/3tgkirmkulgf/fQXfzDw0g?=
 =?us-ascii?Q?bMpUo1lispLfGr1f03N7uBf2if5jm1RusR8FdmhW8XfZXYHA+ChyXgZLwFMu?=
 =?us-ascii?Q?/f4vE0OuNGAJZ1fm8IKYx0kF7xWVobND1k+wbaM1jm+Iyi+c510ibZUxN0KD?=
 =?us-ascii?Q?/1gJ2KQX8j/+/3tvDbSziAc0/TI9FaPh4btXZ1HwogwLzVR+YI1AqIQSmJUI?=
 =?us-ascii?Q?RqgkB4mSlsnBR01cF65xwwJDnxVane1ES4xOqps3MPLYyieGEw6gXo6omWj/?=
 =?us-ascii?Q?wAeIKZzVVwf1CL6LI7NVmGyREKp3WJQzHfQequ7UFOcEstGGocCZQYgL5oCs?=
 =?us-ascii?Q?S1wAJ+k7oJYh4dxVzcnvSEl/IsmDZZfRS1e/5ygCuXp8ac6dI668GAAXqos5?=
 =?us-ascii?Q?pfK6I40Gx2a/K1oPyGigfzhiJerdoloJswFNS0mRhOuF/G4AmsOxF/vxQ3d0?=
 =?us-ascii?Q?R6gy5YwK4uvWVt12P1h2GEwhiPYo4woNMlyxWqdPo5UXJEs4kaxdw/5kdyLU?=
 =?us-ascii?Q?5QIYbQhx3cBxQBckVfaXWeTfPcrUkgFMYRci/mbl8PpmmidRhraG9YI2PCLY?=
 =?us-ascii?Q?e7hMQ7vTQeuOLzYOetpKGEZ5DoTvrmK3Vhflx8BCu91RnNkoCALaXFwUVQTz?=
 =?us-ascii?Q?qTHPpG0p88QYyhJIZk6050ZAzbFxnAvNM6bkkIdB2HAAVu0Q+UyRfZx3o/CP?=
 =?us-ascii?Q?9WJgaOHiOkgndcfsN4VleLwo1NTWXO1iJnp6rYqMW02Q2k44s5tM9NcM37g8?=
 =?us-ascii?Q?puagQi7BPnHW6upeyEe2ZwxGqg2gytksfWdTAXZYf5/NlnDBydwRYKuU8u3s?=
 =?us-ascii?Q?IGjgvECHTJtGowaDDb0kylLrhcrGKa8dIM41ozFQ6CSinI2PQqNV0BE4S1y6?=
 =?us-ascii?Q?rbcu2eDJsOWqPWcb8jT1fVyy+nW9zkXUF10gWfnJftyrhNAgXvxMQ51cd7Yh?=
 =?us-ascii?Q?9pFnw7RgrmjDBoIqjSumuFaKrF7qPUJ6scMNWUmhtQbw/p99K76T53rGS1r1?=
 =?us-ascii?Q?fNTDpRWN7YpJKc7hRME78N7bbGhRKBAo8gx+UDA7AMsqo0bFH4zEYwKIr9+L?=
 =?us-ascii?Q?ny0i/FQJKnCQXk5PTdqk2N/xPO0ISBDkh1M/dXStIv9gt9uXYRtbeT0Fhl5e?=
 =?us-ascii?Q?2OGpMH42vxyCfcHqguIqMckieMkGtLZeU0kL0zqBH/wF48QLczJkT0D7W26T?=
 =?us-ascii?Q?ax0sqrCeeEiCK1ri2+lbrVlpzYMiXc4dKGeG6yXclncZYPVtEp3U7R+nQTkm?=
 =?us-ascii?Q?EW/MkGr/Im+CcZl6BEIVCnzYEc8pHSgMZODTKMVVwQWJ/RDLJ3QstZu8WFwT?=
 =?us-ascii?Q?ErpWQx7J4TN8qNrk6iv1sWV9LXNEeW4xJ9eCKdB+4cP1fDkOLwrPB9WlkOGS?=
 =?us-ascii?Q?d1UsZ5clo3aQc17qvOK74FelHJTySmgUUjsBlcIwVMxAvd+bHXf3UPvDOMks?=
 =?us-ascii?Q?KQ1zo4MWAapzJaVL13PokFuN7t8BFh5rUyf4btr5Ai52ZCBW8oqoKQ5KeO7k?=
 =?us-ascii?Q?mw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2678aa7-9e19-4613-ae54-08da7415869d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 23:28:22.9693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xHDN/I5bIguELuFEMFiokvU8oRM5XOAMr2Phy5pnXZUnWHp6VBmA05uS/fYCkVgzyORU1Z2wSep2oMNII7lWyQVNKPY9U1pbHf/+2BoWP6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_11,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=911
 adultscore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010117
X-Proofpoint-ORIG-GUID: KF-5DUYChkylYRntwNNv2YUnYTX74e1C
X-Proofpoint-GUID: KF-5DUYChkylYRntwNNv2YUnYTX74e1C
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Measurements for one particular UFS controller + UFS device show a 25%
> higher read bandwidth if the maximum data buffer size is increased from
> 512 KiB to 1 MiB. Hence increase the maximum size of the data buffer
> associated with a single request from SCSI_DEFAULT_MAX_SECTORS (1024)
> * 512 bytes = 512 KiB to 1 MiB.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
