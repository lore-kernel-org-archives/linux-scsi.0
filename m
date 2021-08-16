Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD41C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78F0460F36
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhHPRLP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 13:11:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2282 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhHPRLB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 13:11:01 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GH69UI019199;
        Mon, 16 Aug 2021 17:10:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=LYkzTCMJk2wblsUJJfW17cPqP7urCx8/fEUeIL56btU=;
 b=Jws1khZdAayd6iEKzKgHJZ5sUekTzoVb40SIJBYj2IWXHz41MRVU9pySa6s0601SQwSk
 Cg0Or+t/JeTJRO7fzdl066wzILRCQHJqj0PX9+P4WJXo49TW96MusHjYR8CLeTz211ns
 9+7OzeQ0TOF2x1nQ6NTwwFbrz+r6JAmyaga/19/cx4KWWtlSIMCtlD6j9Q0CfoGduGc6
 s4itdwbeXdGFVOX8BbH1scQ6nwJ3kY06uRWFzgs/a3iimqA6fWdLuE48cMW3R/TdMj9n
 jm1HwO37Uol83AQISlSrQlA3GeODY7XkHwFgbqo4inOsq1j3cjxAihL2UskZvsCVIELD Kw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=LYkzTCMJk2wblsUJJfW17cPqP7urCx8/fEUeIL56btU=;
 b=CS89/1mD+nmtiPeSoFdRjOZ8vbsk0WvATnuXTJ7usxx881FVvzH/5K/PQ4pCGxkqWZs4
 pMJRphHIagvXdENSy9aMN6aEHNh5WFBiqX8JErUmKIvbq2zaGAdnfdMaIU2cBDOa3h8p
 keTghz2tRjzepeYEzqrYtNzemDMCM9zsavHhc8PqBKqoTcZK3M7IxUNcV7eQpXFXf2oJ
 8pS3TxowpowC1PBzV5LnFvUtr2D/b4ySJjPJG2ecftlHkbYaH7A+pLExZY2z7EoFfFJ8
 ExA04E/ehzLq4+F37EfrbeGHH2nobxMha0vb5NzzCqbC1UlkppdBDAdXcFlozX/WdTeu 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3af1q9artq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:10:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17GH0tKM088376;
        Mon, 16 Aug 2021 17:10:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3030.oracle.com with ESMTP id 3ae2xxjefs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:10:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fG2oVtXdL0UhsE48iFvQF0FpHvmYWjFAbajdkNeHL5p0mLDhE0UMjgL9E1FbxH4r9c/5aAa0zLh1uHqdcQEIMR0GbH+sLtWDTFju1P7q1QOSOQQppui0S18If9x4Ua4lb0/aBV3lSbtmWxBVaRXsPRSoBK3MLZwQWc72CLVGecRes/fEWDK1TIZNJbdDRhBEcmrLa+QA/IfQF+kbt4UZjN+G7mB9pC7VvMZzr1yXqQu5E4qZ0s+9nJQgQ2Ws4bosZryPot/OqYIE5wbpl+8OZOogDsP0TP2GUj2XdgoV4+aq3qxTBG7NIeOCM7c0id9BMO3kOYzq5ujdrboSJa/UhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LYkzTCMJk2wblsUJJfW17cPqP7urCx8/fEUeIL56btU=;
 b=KK/k6YQQRv1tk67vlBEWl/sSD7mRgUyssq4I7aRlzUsTA/PRQKhP1GvTvGUaQGxbowcdn+eRByvDKvRNlhJ1PN51lQjTSKHYP4kbclFKduL4Nb4E0+z0ig7+M+OxqAlwdBRxUzTwX6NYM6ZXKkT62DUleXOxl7HuF0YFO9xOU0BfEyroFzOiIA32rxQkoNozwYSZD6FFASrpiK/z+EYxVt9GUHWbkyydRmrfhH+6hM9L/OFAjbBBJzZZz5xyvLKodJVTfeSXcW+ANOpO5g6epFRLXrvUW/KgfdYwv3ZzEjkC2EOoxfVFtkeQwwDasnFbkqlyFbr/3zrXW0SJqOovOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LYkzTCMJk2wblsUJJfW17cPqP7urCx8/fEUeIL56btU=;
 b=O7h0Sk8Uhq0lxwht8NjciNod3FuZm4KJEHWwnxJV6DmmRGFYgKoX90VgDoAJkugq3jpm6VtHflNFueUSnp6IagAQQtO5/h+clQjfkbWZYfTFL7VHGlTj5ieoja1jpoqd4zYWQklZ00CItafXrVwNnt0FocA90HM9fa0cmY9K2Zg=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4600.namprd10.prod.outlook.com (2603:10b6:510:36::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Mon, 16 Aug
 2021 17:10:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 17:10:24 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s11qqfk.fsf@ca-mkp.ca.oracle.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
Date:   Mon, 16 Aug 2021 13:10:20 -0400
In-Reply-To: <20210812075015.1090959-1-damien.lemoal@wdc.com> (Damien Le
        Moal's message of "Thu, 12 Aug 2021 16:50:10 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0051.namprd02.prod.outlook.com
 (2603:10b6:803:20::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0201CA0051.namprd02.prod.outlook.com (2603:10b6:803:20::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Mon, 16 Aug 2021 17:10:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c67ffe16-75e0-452e-8e81-08d960d8bcbe
X-MS-TrafficTypeDiagnostic: PH0PR10MB4600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46005956289398DD269FBC418EFD9@PH0PR10MB4600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bCnp4mKwtiCSUYRmoe+zx0V68hx/WirUs0ZOByf/7+6jyU+U7yXxzFHYMiHq05b6+sxsKJvbR+B5igK4CNPNU3R1PBO5I76ww2vnR02ze3kUD2a53rNp9aiKBoqN0FRIAGH7ei2t1RsTeXIoO8Hahi7/S7NEE2eJiiTitX50YrOL54mUNewBCCYRI9C5RFjq6U55eWBIwS39xB7pLRhtWDivDRKia9XH76fTDWqZhxPc5V0HXOt4gzVPdnEtpboCsJHn3yIV4K0GlvJfAUJdvNVpwtavsKNN8z6EKhmfgQEjeECwNfm7DUBbjkZ/Ut8k5owLPWikRBxvGMxOlkYDagiTvzIpk4A0Elpc8RzZDkUsdFTDKyoxCRBlnzRAYUIh0S9/lXnrvVp91oLJcb/rjsUFd2fNOamIG6ccGxvCm4R5RiIZUms/brl+xncJ6J0ZiqJmvFFgPRaUIGLXooOfzLe86OzWZ7MxkSDXngqxdefCU9GkTdmYP1COoLEHernTme3F9mtMnA5GDm2eMpdmg0E788ldrFppzCqD5N/DTF2gyPCEkTed7hTxhIy/iQyHFbpiNZ03iY92UU1A9iLqG7Wry05J3J1wR5loxO4Lk/8fbk9V8YIawmoeoLj2+saCfgXwLsGb+u/omAXzigdSYgg7lyPYLCxtXlnt9ZIRvzibFRbld/ZkfKvAUmE4mD+Mx4lU4S27NzKje1meWHEsig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(186003)(26005)(66476007)(38350700002)(55016002)(4326008)(7696005)(316002)(2906002)(6666004)(478600001)(36916002)(52116002)(54906003)(38100700002)(66556008)(66946007)(86362001)(6916009)(83380400001)(5660300002)(956004)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kH2CO+bdFAzQnMLoBFPJm90r6iG+I9pCR/wSAISnsvbPtf7Y99UE2qbnXNLb?=
 =?us-ascii?Q?zTvkQ6Rj/VgFpXfqe7iRMTMVWzBZxoTRF4BKudxEa/YFY+H5vDYc7vv2zbs4?=
 =?us-ascii?Q?ELs1azNJ9HaoBtTVBFAjv/NBz0rb+Q+DtAS42jxi0Douy4Fub6ofw7P+t/SV?=
 =?us-ascii?Q?e/+v65RW9boaOGtQnd1zUlDQ7N6X1gsfgekULQRZ4uvD4Z+lguYL83zh/oPs?=
 =?us-ascii?Q?GKEc5c/Rl2CJVCnh6HxI2C4MH+9UFmWMaGq4DdsnYJubJRvPN4+3ryu+MOTI?=
 =?us-ascii?Q?K58rQWjJpztmJ+VuHzaxNJtLlo4ZD7ulA3V9TLkLlx1PPsf8qXai9m1pUHHE?=
 =?us-ascii?Q?BUtT6TFSe57ZwIXW+EImqyXCuJIADOTTdMLYOHI7Ghty1MHsOTDfjTvh4SRV?=
 =?us-ascii?Q?MlMuW3UXd/uRiKXfwnkldfMDFtDX/BJGp4R7zanOXlfn9sGFGSTJv0ChWNtW?=
 =?us-ascii?Q?iLSkb7PfzRI65p3lpC8pyPy9CnjQUxdzKx+RajW4aJynyPG/XcJfetNKRUuE?=
 =?us-ascii?Q?SllovT7htL/idbFoiXFQddG3rEvIBKVkoxMlTBZ3NKdJiPAPjGVrelB1Wgk0?=
 =?us-ascii?Q?DYDes3xOJESDyBwKXptCOPEMrRKZVo/y9El+8FjGJuaWa+7SY+nVEO9QZ4fO?=
 =?us-ascii?Q?Cepi4oPEMQf1lgznOZFd5rUICsGa3dHnZuZIcPH073G8ov6lBKLEoUyfPF55?=
 =?us-ascii?Q?Y4SBOO05+nD6fYXAUDO8B3PtTVYPExyJrBcR/4N8TlzA/Szys4KWS//7eVEE?=
 =?us-ascii?Q?cHkWs3GcRyZ2K3DY1PC1OJ7PLpdYGQegjs4F2Y2i0z2UC73GVO/iIYy3XVKq?=
 =?us-ascii?Q?zhGqZo+/oURGIvrWk/eicWUh/7dXRui4VHjQICwrxejo5cW6oIkFTRHxt3gA?=
 =?us-ascii?Q?AXXrTSrvShin4z2YkrnesBjX985jBnwpVCzXgOSqbhhrb9qaX0ok9K00YRBc?=
 =?us-ascii?Q?tuY3QSnrdFxx9UsqIC39+E/dssRL0ce9N/FXIvVHaMLzvQQuZ2p0aHPwuTsG?=
 =?us-ascii?Q?IBJNl0xfS6cMoGJxDtBv9EwJP9tmp1jbaRjJi1kxw9Bw5CdLmhm4Argvksx+?=
 =?us-ascii?Q?Qi3zC0xebiK3xiGtcAVtQCdBoFAx8cr20mpDOEwIXskzsPlB0InD6ZHkWhms?=
 =?us-ascii?Q?EZEEUVPHu7YoNkgN0aa64emcJKyeIUVZ6fQHba6BJBv/90JvJh2QNBFTsyOd?=
 =?us-ascii?Q?HNEn0wickoKlQbQrmkIQKGNYMhVZbRnBKrv/R+5YgiEtsOYPGPaOlh/l61YI?=
 =?us-ascii?Q?c6RhwZtFQi8FPdgJ0KOJyCVbBEzyQ21pgrkFcFd/96hGFPTf+D0wTsMC8Ruo?=
 =?us-ascii?Q?fQByUb+sUeq/XHGR+GDHfeJJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c67ffe16-75e0-452e-8e81-08d960d8bcbe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 17:10:24.6627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YQapFtqg0ngHmNVr1CQj5U+EiubWwho1zMNNx6LndpFDCsJ83BrEScmShG6tZB5kiL+tye7qV+ZbtvL7RG6ojGj3u0YT/JodfVCneIfEC9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=674 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160108
X-Proofpoint-GUID: MkQNQrHntQFYL-w0UeSBCYZGidT3U-cu
X-Proofpoint-ORIG-GUID: MkQNQrHntQFYL-w0UeSBCYZGidT3U-cu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Damien!

> Single LUN multi-actuator hard-disks are cappable to seek and execute
> multiple commands in parallel. This capability is exposed to the host
> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).
> Each positioning range describes the contiguous set of LBAs that an
> actuator serves.

I am not a big fan of the Concurrent Positioning Range terminology since
it is very specific to the implementation of multi-actuator disk drives.
With other types of media, "positioning" doesn't any sense. It is
unfortunate that CPR is the term that ended up in a spec that covers a
wide variety of devices and media types.

I also think that the "concurrent positioning" emphasizes the
performance aspect but not so much the fault domain which in many ways
is the more interesting part.

The purpose of exposing this information to the filesystems must be to
encourage them to use it. And therefore I think it is important that the
semantics and information conveyed is applicable outside of the
multi-actuator use case. It would be easy to expose this kind of
information for concatenated LVM devices, etc.

Anyway. I don't really have any objections to the series from an
implementation perspective. I do think "cpr" as you used in patch #2 is
a better name than "crange". But again, I wish we could come up with a
more accurate and less disk actuator centric terminology for the block
layer plumbing.

I would have voted for "fault_domain" but that ignores the performance
aspect. "independent_block_range", maybe? Why is naming always so hard?
:(

-- 
Martin K. Petersen	Oracle Linux Engineering
