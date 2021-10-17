Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4718FC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2709460E97
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241304AbhJQCMW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 22:12:22 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53044 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235321AbhJQCMS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 22:12:18 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19H07HWW003947;
        Sun, 17 Oct 2021 02:09:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=XwnsP/9loBPFlw+VpmJySUlT/bDJuVXNk+ciVXb2R2Q=;
 b=Q2F2+fsXguSsTzsKxtR2wqoajJzBUjm25H7dOJMQzXWQpT9T80M0RJpBWN4VMNIIbZj4
 Q8YHLB+/hqHZLukcSDgiYEVCkTfvQ++RKSUDfV/nNT0/ndN2LMQUz/KlS647hg6fADap
 NFfAlP7ITAPfWEpH76B8SFl/254f1FwaLA+7FusHg9aEIrbHzSijffh3b7V/kP0DxkTp
 1qYSxq/3/6XEADvgIyoya7Z6OfWm1U6q9cM2N6PujShOXlxEl/dMAzE1EMYsJpCOnksU
 0EFT7HvxDLCSehuYJlbk5Ebedsu4LXGHwyUQsbjTYpWrcHVWCbnmPew3anQ2zSqUmSkz rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqj6spxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:09:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H20w3k069646;
        Sun, 17 Oct 2021 02:09:57 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by aserp3020.oracle.com with ESMTP id 3bqpj28744-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:09:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C92mo6NomUD0kCe+OrlYAs55gFzrhtcAK1zyuw05if4EUrxj8rUIRCNaXgi4cuFcwiDusRyz+nk8tcoFstsevtYTKpLyPgkmgf3TN2dk7WOepSnb9X2KGnJlX4tWrrhV7IKl0aTPsdQQyKLV+C5qoi+g8UaNavYvj6F0avQCn0LQG1qz7Us3keLXUofBjZXBCYt1841ksLmxiQosLI8SYy1T+tnbDnLYse43xzfc0nR4pGMUwELKnhW3Dk7u1hX/Q+fwdrrHP0/kImUmZtdAiFv6gBg7BoR+EiutGDX9iRIjRj9N+rKUr0vLzxpKAGwQso6XfXx1gayyN53uHC7I7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwnsP/9loBPFlw+VpmJySUlT/bDJuVXNk+ciVXb2R2Q=;
 b=kMkT5jgBAQCX0NU2T6tJAX6McsuvPinRM0RorwmDT/pJ5VCIEB57nkFC6RnUEuAxsdXYujV+qHvngUj7XVkn7nKIk2xbDQXh6cvPGP+Bd+tokkASKqOxO03RtFpPQs9moAhNIZOGg9iv+vtTn6bS3+d2mHNV3yngIAGOYZEXZ0c4f4P/72MT5iu0Y4OyFt8zeSL0TnH2sgNR3qLIgqx/yyd2qKwxgeOY2Uyz1k65dR/PzbZ1W3sv/dKdBO7g4xDIsXONlcm3AFMDyhWnuaXD5d0ZjLuqbhXoIEoSLiZfFxJfrmbIRaz3SKDduBIAS3yAQt7WRuSKg5pPTaNTuG4tUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwnsP/9loBPFlw+VpmJySUlT/bDJuVXNk+ciVXb2R2Q=;
 b=bwo7TQEy1iGliJS1X4ueP85II2obLzpudP6X1ZxZcY9IqzIO+tdpSsdonLVj2HFaI4SWY9nL1t+2QUYwSOeR4vwx8lrgnt5aJ9EpJ4rDIR6QhZyLxw51dQQb3eXtJZ59qBiymHhROep/+kSoAWgKfe25fCTbVNmIlETCQv9Ue3c=
Authentication-Results: puri.sm; dkim=none (message not signed)
 header.d=none;puri.sm; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4710.namprd10.prod.outlook.com (2603:10b6:510:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Sun, 17 Oct
 2021 02:09:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 02:09:53 +0000
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     bvanassche@acm.org, dgilbert@interlog.com, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com
Subject: Re: [PATCH] scsi: sd: print write through due to no caching mode
 page as warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfx0h065.fsf@ca-mkp.ca.oracle.com>
References: <20211013075050.3870354-1-martin.kepplinger@puri.sm>
Date:   Sat, 16 Oct 2021 22:09:51 -0400
In-Reply-To: <20211013075050.3870354-1-martin.kepplinger@puri.sm> (Martin
        Kepplinger's message of "Wed, 13 Oct 2021 09:50:50 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SJ0PR03CA0027.namprd03.prod.outlook.com (2603:10b6:a03:33a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Sun, 17 Oct 2021 02:09:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 399c155b-026c-47cf-76b2-08d99113358a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4710:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47100C3F093296E3B7A4E7748EBB9@PH0PR10MB4710.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cAOFvdPy27IL9joOso5N5P7Y2pJVBo8VXZad/dltDsv4WyZMrmKKPd6kRzqav9HU838eFaapOI7ywzt087CE5Cho77KvwOfcuaB7iJcfwfvcSCvAnXMVA9CFj1h4ep1Xgp4cU+ehNFTxLL8k0OrhdENZab6p/cwL3rNWS6FbJrpCKphKfb7I3Mq5qooJLHGd7ZDh64M/YHkIb/REczXK0PDg0gqa76XDiGyptJsjbpzh7jSzUfYAPq3rvGZfuBahawANnzu083FcbpHT0iGFsSQSSZQQKNNyXDfbNy3Piaz0Pr1/G2+ziEjwCioKyHx1/dDZHlxn0V5S89QasqP/7VKxQs+prNj8RDwJXKP9BXKQRhcOpRJptpX8x/hTBeREAN3At9XDoyI5eMfoIBYmempUcHER09JGYXLbw395LZ/tA4inz8Zj8il4BKaHs2Mcs/PplY3NndR6gq6RduSh/MeEL6a++MPXRMNu9t/M9LgUMVk3vC9n1DKvln002YlcJKcpoMJn8ioLyoo67QQ6Zma6ml7ue7IoKStOQLRRVa4pF/igcJ+orbqit1nwQJ/fwcKk59u5lTr2Uj1Zooto9qeXqq1GGFxUzqpXpgEG/3EIoTww9WsNpgP/7bZCAfM4gytFGbw5vSczdMs0RqAU7dYjOGsV/3ZAeF5O2f2F3irtpiQY1Udg/g7vbAt6aR6OrZpDlQedvnQeswP2cAxDRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(83380400001)(38100700002)(38350700002)(186003)(86362001)(26005)(508600001)(36916002)(52116002)(7696005)(6916009)(107886003)(2906002)(4326008)(55016002)(8676002)(66476007)(4744005)(8936002)(5660300002)(316002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TGNPvb2GPRLdPSVdgx2UrhDHKrTzn2Wt2XRoG5hq+wxaiL9fF0bcbQHMbUPi?=
 =?us-ascii?Q?1su9M52DQqZ4Z4V4V4R6ecN7nHlMSVKNMiORq1TxHMSmD3NAON6cdOsx6eJp?=
 =?us-ascii?Q?QjxAezXnMbFSzsVwimV7feB4UdawZGtPZTHJDLlNwm48t13HGBQ1xorcXD5h?=
 =?us-ascii?Q?v3jdZ5jzdCoP8xkkd2RrGBoZsSpJHgg6Oouuo7OpV1rF5qCtJtzTYhd6DEbN?=
 =?us-ascii?Q?7TKhUfzeQk7rcVPP0zLQsMzpHYazReI1z05LPvgR3vWMqNG7hUReLeJaL0OI?=
 =?us-ascii?Q?woxF1UG2513c09ddJFBJ7jA3eMkWK65aVBL8NvnCqRBfgykUGRffBgVPoY4Q?=
 =?us-ascii?Q?sKEcx15S1OZwE6DUnbBsO1McZ9xeVE7M+1zgyAVpnz9BSuMWw+Yg73CY/nXw?=
 =?us-ascii?Q?MU0DcMTvVM8PHgyfK5VTxWQ7GNTR0rG/rTRp1vNrPWMY1DHmxIDQzmwlnZ2P?=
 =?us-ascii?Q?u6yiEsUOHM0IHeGg4A7WEoXZGVCUtSSAFpAZ8hTzhR/E4/kfvTzSQsET3AOI?=
 =?us-ascii?Q?JkQlXIUpdG5ae2Mh+8Un+MZXeLEbdfcybF8sZAbR9lRoJ/+sReA6t5orslre?=
 =?us-ascii?Q?zRDEgUf8p7UUM3bSgKOlvYUI813L8YkvNFINgNLbEWfp9xJ+lxO6DIvd1PXU?=
 =?us-ascii?Q?I3EogkBOOVE40OaMjk6viKgwjvCyz4zbcQ5Jf7j5BbkGJ8MG9vMLQLsHHzQj?=
 =?us-ascii?Q?2JiyLEDMA5RJjTz4UlumcFsFt69eb2oryWXfUwiLcwTOfkV5fL1BhgctoLvM?=
 =?us-ascii?Q?O/6XsBCnnZi6fO0UVSw9qSbqul7YffgYs8Zqfv6HwpInLfiv9mp4TiPPlMp4?=
 =?us-ascii?Q?1aSYTJajLQYaq8rpvDjohG82Ylp1EiQq1j+JJCVzUWkIBvtVW6YOPb+UBTld?=
 =?us-ascii?Q?21qstYqjvWEbyAbJxZ2VA+HAd4LxMAs6qJi+6KqdnZPYgzU836jlmIJXSbRO?=
 =?us-ascii?Q?CATecIY1U92coth9UpjVEAuDSNRT4y7hNQzF9o/EnMYveUuITkR3rapD/UlG?=
 =?us-ascii?Q?SV96mN5xLJsjizzlalN98yfoXM7w3b8TgQdJggpGqS6S7D+FU/KvybVtWUV3?=
 =?us-ascii?Q?UUxVCzKVJbdWIF06/ystZv7/1ehzH/bdQzAiuTcwtHuHYf6ZiI3Z/yphEvBV?=
 =?us-ascii?Q?fl/HA8BjR9QI+e4j7U3hgOQXZ9mH5HLNadRlspNvcqu3RUD3PGGMbL3KHeaT?=
 =?us-ascii?Q?c55G4mQzi5jHsRyVJSZ2wrdCID2WDldlk8zQw4iVz3G7kUemDGWCBD0xPr8H?=
 =?us-ascii?Q?oUuDEaX0xvYYrgXrGRdrsfk4BWxplMRwxU9GpzW8QrooHHGSyVy3hJCOs532?=
 =?us-ascii?Q?8TfJ8YZv0oMPbOjOAHbtTnjw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399c155b-026c-47cf-76b2-08d99113358a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:09:53.9194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fc5NB7g4CH4zj8kcqBqhyWmasD+5N90RsrNY75BCi1VEoadbAGRUh6HaQ1gNlJD0bfnrZIrdD9lMWqkOdwP0YKOELQGTNOEaTO5TmcOcD9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4710
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110170012
X-Proofpoint-GUID: _AhTwA6C4ord0zOBveX7Jmv2fWQDRCUA
X-Proofpoint-ORIG-GUID: _AhTwA6C4ord0zOBveX7Jmv2fWQDRCUA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> For SD cardreaders it's extremely common not to find cache on disk.
> The following error messages are thus very common and don't point to a
> real error one could try to fix but rather describe how the disk
> works:

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
