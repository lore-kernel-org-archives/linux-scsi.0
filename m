Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D298EC43334
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 02:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237065AbiFVCC7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 22:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbiFVCC5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 22:02:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA59B62ED
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2022 19:02:56 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25M0Imhv017645;
        Wed, 22 Jun 2022 02:02:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=UU/RiUaaZ0QYpS3lFJHuTl7NeW6UcKQKU+4NCYvspAY=;
 b=ABXJNrawjpQbxxeP0ZeBHcUhGM3SYDN1ZC8P+gzwy3MYjZKblUkdlRRjc4FTZHhi1I6N
 Hy9bKK3zXqD320vtjrn87/osR1k7k1qotL/ILrbN1SrlevlGD+h7jVgDVpqSmnIo8GiJ
 rehEeK2/DDS9DfGl7/R/jR9iItp7aznrAIbbe8zdkF1kJmR1rZ8M1Q2RgzccV/zhWSDZ
 FTG+wZo4sbosjKyKInxHdbvMtS++IsURYtLGzKWrZz8m+Cx5H+ZYki29m8ie1wOLLSMv
 nu8njWkMrilaj4oALZ2scv+gmOCOgEHB19S/a2FQMB/gDbBstN1ODCBVvSxJPAC1c/0W Pw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs78ty5gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 02:02:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25M1uYYl014263;
        Wed, 22 Jun 2022 02:02:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9ussnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 02:02:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVUF5z/aI2UCT3SZqSk6NbFfuhFnckRVaXbVCfsjLNnbTOBRB6jUeZ+ibXN/DoNebV/jPeOt7bXOZnJiZkNZY6MHkBX/OkCMQtQ+2ZYH3qqp/ivIsE3305O9tSpGvFRyuyaZmbsNl+RRKM1sbV53MD0gIj+KCnrrav9N2VG6O+fjF6vdtGNNhf9gNAVUq11ZICgmWvIe9DCsvDqy6eQNOoTJCqd39/FzwQKaOUQwrIhSicwDh1Dz5GI5pYdnweXFRV+IoRZm1OfRkS7SHauOxvhtYfcV/tentQjR6Jej15K4UfaC8+s5007ha1CUiMVgemESDA5WZFMYOxY3TOF+aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UU/RiUaaZ0QYpS3lFJHuTl7NeW6UcKQKU+4NCYvspAY=;
 b=DTMVVyERrjyhuXxkROIl0jTNIcvwduuNZjikNMhuE0FAqMIdZ2GBef8J+Pf7D/IW0uRwJL3KIXLBQsll/TY56kNb8k3zPANldEuOWY3DFNhHQFywBrsaFLb/fLOTql4zHryZ9od0n7Bfvbe8JL9dBV/UKQGqt12uYIpRrvaJfcJ020Pt1HImksa9iuheCkdarAN6kl3ety+/RukQJdbrbiSrof5KRrDiaGNikrXOUMPsmDdEp4VzRMfqGtMIGvRMGtyBNGnubF4+hCWcAqgWLovGEABVEH8U3njbgVXu3nua7hJomxD30IewmV5ri478e8UyRfMkqD7jub+GS5XkqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UU/RiUaaZ0QYpS3lFJHuTl7NeW6UcKQKU+4NCYvspAY=;
 b=amTUIPfn3JqazX+mTBp7BsSA2QUM8cT6S25Lpms6xbN/nDLmr2Yg0wfijQL81tqPLvZEAh4wKPnHHuskNNV1zmE1nkPaZvRINkjJol+ZomRNusEuDS9C4iXFRt76mDkUd5Q+kPhkUAVwKdlD25nHI39BAztEai/zXeLJe160604=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN6PR1001MB2291.namprd10.prod.outlook.com (2603:10b6:405:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Wed, 22 Jun
 2022 02:02:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 02:02:25 +0000
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/2] scsi: add BLIST_RETRY_SCAN to ignore errors during
 scanning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yktjw77.fsf@ca-mkp.ca.oracle.com>
References: <20220615164149.3092-1-mwilck@suse.com>
        <20220615164149.3092-2-mwilck@suse.com>
Date:   Tue, 21 Jun 2022 22:02:21 -0400
In-Reply-To: <20220615164149.3092-2-mwilck@suse.com> (mwilck@suse.com's
        message of "Wed, 15 Jun 2022 18:41:48 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0057.namprd07.prod.outlook.com
 (2603:10b6:a03:60::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecc3c7a9-cdac-41cb-fc93-08da53f340c7
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2291:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1001MB229185B43E5797D042E54AC68EB29@BN6PR1001MB2291.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: di3N8h/Ob6SYjIV7FrOpbgu4fUx7e3Du/hRHDasvd6NTbfNsqC+3GA7qxK1uDotbfZ8eSqIeJ7t9l47ZcLNFz/q8ndEtQ5MJNQLeGd3HmudHMYKoAwrYCA0XjC81R4f6lHyq/8Oyez2HiYZ+Tv2J0TJAuziiUV/KBWuf9j1zPwOFYdPZelbG1jAeA7dotqYpRcWD+pCl5Yu3AfkTMfFeB9oGCEmJXbKtVk7O5uEmiaz6JPwOOpO+jPd2oV5umwiZBI2rGTJ7PE2VYswwhSp11+19EEhbxT6ZSWJ5x05rm6FJl12YBpiw2H+HrhMpLq/gVv9jy1YwXbknbQeiQydcZN9bfuqTBkuKl6L1sJceL7LIKhrXTLt2IlYMTh8rGCwZrat0C5M7784owZcAQXu6mm36aMJHvzYLhuqvLL48rof3WZrLq6w8k4mS183Nou/RsR2OIUnmRZxfNSDFcB2QSlUtFwdRgllgmPMadTuIjUICXGXHLXU4hiIrOUnLWT63d5hiAdG/6XZhf7YqpIZKDnFPCwu7+kMwlzzrgr3uEse5DVLJBhhS0jTbAhEjvnwh4SH4PC6IWvAgJWjy/MBAbROK401Qg/Nf+pNY9PRkN0XB9CciRon/ox2X7I7/2O5OXneq9U/dkZARXN6BO7ipQ0GVq92bwdBQBIZT3PQWsY7zqrCPqzKOqkNKQtYC8unwlCJeURhcyNfdEJiQqOtQXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(376002)(136003)(39860400002)(6666004)(2906002)(316002)(6506007)(36916002)(66476007)(5660300002)(52116002)(4326008)(66556008)(66946007)(8676002)(478600001)(86362001)(4744005)(8936002)(6486002)(6512007)(26005)(6916009)(54906003)(41300700001)(186003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GFPIrEkxfC2YnXdpfA6XSAbwJiAPwE8WERVyD7g9J6cSk//yRF11hpGx+vvs?=
 =?us-ascii?Q?DYvBbsz0mziMBWYXh/i24y1jr6XUSyyeXZ4Zq21LJc0yf36U6BUtCzau2S+q?=
 =?us-ascii?Q?2dtgJb9Hovw7P5H6DtE4kcQsjfHFvIkZqeeEiD8cSLPyr9F5ornQd7E7Afu+?=
 =?us-ascii?Q?NzYXNY6Qntw6woBShPYRufAkuPBwRLaZdFMODKsSTUv9SpAMT1xb50Jb7h1f?=
 =?us-ascii?Q?VvwO4S+N1QXeZtr0NF62obr2+6h9EhXI/XAYUTd0funMO+uhtn6ekUiaq1BY?=
 =?us-ascii?Q?Le/PrjGlywvhFmJabYOdJtWlJyATMogdV27oNvbCSsDjVRa3SMy2zNAjckmd?=
 =?us-ascii?Q?wQj74OJ+y4OJMHmtbDbwygdvckRIF6qBgwqKQTRXnyc5VjoKRQM+2BFE8OIr?=
 =?us-ascii?Q?Jp+4b/21GLcsEXJLMWHuk8veUcwMZtrAGfGwGeNJvZefbeIi32q/XOMgE+Dh?=
 =?us-ascii?Q?OmRQ/klQdr8dkCnWSU6afJB8VMBCVUW+dM4sUiSmldQExN+80LGtL2TriquS?=
 =?us-ascii?Q?k09di+fxLrFp83WttUuEIaat9Ne2LdOuiitt+KGF3Fpdowwgaa6hLD/ltrfx?=
 =?us-ascii?Q?gDyYE7w/+GPcV1LfdYwb4T0kRdBtCptL/maMeiAOxtJW/JwSTY/AIEMsnmw/?=
 =?us-ascii?Q?L1Ns9V/gFj2IWLSZ8Saj+k3GZkVEIiyIBrSgnOV7N6yI4E8VOxrgHgA1KsdK?=
 =?us-ascii?Q?dqvLWqD68o7fYURyy2D5smbC9tFiDL+T4RHCebi/kQK1sJ7ubAWQP5PPQNLV?=
 =?us-ascii?Q?/U+CVJO1TZJUzZrc+i8kutrcAQF9KQ/NkpFItUf7YrTwBptv00NE+U4i14mg?=
 =?us-ascii?Q?bj0qlNFgAVKMPieYqR5TmgoNpFKzf70JGCg2oL8Z3pKL2lRWg2rmdzCa51sT?=
 =?us-ascii?Q?4Vyroa+mubYqg0ki7sSn41Mu5mdKzRUbbgIWMl+DQ24mO7ff1cPkm8a4SrAc?=
 =?us-ascii?Q?hnPS3j1DjUWVHYgRsJLx/4xfaqjM1R1Pxj8wngoTbVZv1CEMJNcJj6g8OZTX?=
 =?us-ascii?Q?SKI3bGmQOeVh//9VPCVMgTwjE75g3Fb83N2xPTzOjsyCUvWu8GTZzGsHdvym?=
 =?us-ascii?Q?EsXDTmExqLAgJUy/p0BZvDpaTavAcSvCvmkXRCFhxRYAvjxaPzrwoY21EDPG?=
 =?us-ascii?Q?ZehtpfOoa+QRW0Z6nvwVeJW1Gm5VR2U8w+UeztP8UGwMmm0rPukGCbAXrYH8?=
 =?us-ascii?Q?6vjA07VxdLSR3RcsCntPUy/gTbREWVEAcla2ERxP4soTY5VTMTEry9/MViJj?=
 =?us-ascii?Q?Qb9XL4B2sE79aq0OufryJ152KvBdUSrkUvM77LW/4bstx9S5I9vdL3QKN0yA?=
 =?us-ascii?Q?tffCJvj2Kao93veKNuIUwB/yEpyvGu+borCkqQcz/kW3qYrxvNQDmEn3p0kh?=
 =?us-ascii?Q?t0gePZ9FcnBLoMXPYma69ezRgqyFK/bu4woA111XeLNuzu1uwhlDTVIfuQrx?=
 =?us-ascii?Q?kGAb5QXw3HZ3wGEVczHoOY7Fjvecrb03GiYnEZFXm3gVwnjc3bkcIjT6Kp80?=
 =?us-ascii?Q?B+57NFahTDzov4BKi6TEeyA/HYBwleE61v4aZvxN8jdQn3hKiY6+r21YSEOS?=
 =?us-ascii?Q?6k2JFgYy6WCw3MZfuYUZNXTnbr27L1CwDpV46HGVtA9WxsBmHMwDhnNtGJ53?=
 =?us-ascii?Q?ablFeGuDeuldaIq1N+qiapZzf2YWX+FJaM9rRJQzi/1a/a4RM3oBZ4qjzjR5?=
 =?us-ascii?Q?MRwnNaWRw3HvL4tbDuXda26sdXLMGspWonLRvlb1USzTuJ57dY8080WjulfR?=
 =?us-ascii?Q?O0vMi4Gzl9SBabp4nxYE0OTevePJANU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecc3c7a9-cdac-41cb-fc93-08da53f340c7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 02:02:25.7071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H2bs6T1vHhvWGJ53pH8au26r6UGP8bdYYkaSE+U7Ht4K4fI/0Dr99MX+qpH54vrevfDdEyEUt9KoTHrVjPCL9pBKyWRVm1fmmveTQhaErjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2291
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-21_11:2022-06-21,2022-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=948 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206220008
X-Proofpoint-GUID: f6NkwSwj3qXJcsAsuUbfEQjU3cU5cTto
X-Proofpoint-ORIG-GUID: f6NkwSwj3qXJcsAsuUbfEQjU3cU5cTto
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> @@ -1531,9 +1536,10 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
>  				    " allowed by the host adapter\n", lun);
>  		} else {
>  			int res;
> +			blist_flags_t bflags = BLIST_RETRY_SCAN;

I'm not a big fan of using the bflag as carrier of "I was reported and
therefore must exist".

Also: Why isn't patch #2 sufficient?

-- 
Martin K. Petersen	Oracle Linux Engineering
