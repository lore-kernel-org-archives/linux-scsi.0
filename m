Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C997C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Oct 2022 09:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJAJpK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Oct 2022 05:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiJAJpI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2022 05:45:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09BA2CCA4
        for <linux-scsi@vger.kernel.org>; Sat,  1 Oct 2022 02:45:05 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2919bHRP019298;
        Sat, 1 Oct 2022 09:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=PS1uWJ8X/8AnxXpIZIgERqsqg7qYrDjkmGrbxJWUyyE=;
 b=Y2DT8asKYD3dYgUoP1aEGzqXNeDWetHWZ673gvaHTc1w9KSwwEKWZO5xR8j9Xn4XknQZ
 fvvG9vLvlFZb+DMRhojvWpmApiZBz7tw2H8xKKstoXSYK0F79BAdNLBmk6yKOWfhJV69
 p1pw1NTN0DzSEJMhjiiN8lPk8+b3taqYKk/MJYi/lRFZvkDhNGwuC5R5Lo60GwgxZrV3
 EC/8ZDGUThE1eUirRt61mQNow5WpNQBvWxfc/zZ4RwoXiPaO9DZiESUDuntjpsm+deF6
 QTvsWHgnG3wjjfQ0rfGA+7leh5UsTd3tPIh2Rrd3dWsR7lEpQl7O04Bv59sHpCIwzM68 Og== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc51rgff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:45:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2919NnNj016481;
        Sat, 1 Oct 2022 09:45:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc01wydv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:45:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JiTMpVcvU7daBT0mwjJdF0pGfF6sXr1LcUqoRT9REArAGy2l0khtng89m8zzmMfnPhixOdSnV9vJXR9AfuReN+qssqf1XRrksgr8KRtIJX0b3mQCBB2RiZEwNUnwpV0HWbVZBPI2qMuXpD8njG1BDMQNoPxGSxWInBaNv/dfA9qCuFbOY6gbvFTmWv1pWjZGo22djleAMzMEtwrVwKk3dCDpfDBscGv67vUD/zeSYoEG5T/j085tdtAH7tYZ49zE6iuIvLYiM2JvcI+C0V0AdwOYn3kPhbo5j9GBG5wE+RLYEfANjzrQnG7BTK/3H2WBEKbx0584csbbfFQ7C2h4WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PS1uWJ8X/8AnxXpIZIgERqsqg7qYrDjkmGrbxJWUyyE=;
 b=ltOlr2nY0dhur6zuwtehx0uw8PT1FsuqtDgXuuMEzyl2dBQmKE9mkflo5GCK0+rkAZP4XLcFIvpP/iLpuLpVZ1iJ9aogMpAjyDUFAdJ3/8vzPh9sgI4n6FsWTDR1AtNDcs2x3F4gV5kkqlILDfAPp1+HYupSdOtieVhAg4hsm7sRafcUvp4wldfHnmutJwbycDPgLYrdS0kqDEYxg83TDXf1QHOsTdDUauCw/x4McpUMjFo3P/WKch8S+BUX0OpnidPqVBdps/dyWWUK1o1p+1bwPfMopbZM3em7HZkLrPLjjzY6u0bYju+QMubouaJWIQkVR+RgGgBkbT/gXsdKLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PS1uWJ8X/8AnxXpIZIgERqsqg7qYrDjkmGrbxJWUyyE=;
 b=U51a7ZsPxHK2acsp71Wjcveq4EZHvsiyrUlhle/CBmvic6WCW1P1hzEav6Q3RkQFoCDbVfYZIKzaA6S4lWt43mq8Rba/Xftj8JbKgElDddnne7aBAAXXXSZdPNdAQwNtp0AYjnEOWyZpUFB5NatC6MG4m1VQMUYe+BkKKnvNopU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB6616.namprd10.prod.outlook.com (2603:10b6:806:2b6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:45:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%6]) with mapi id 15.20.5676.023; Sat, 1 Oct 2022
 09:45:00 +0000
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/7] scsi: Convert snprintf() to scnprintf()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wn9jkhsk.fsf@ca-mkp.ca.oracle.com>
References: <YzHyC191CIXZSfc5@fedora>
        <ea00dcab-e4f6-f672-e754-9ddec67da83d@acm.org>
        <YzROGS934MbKlwxQ@octinomon>
Date:   Sat, 01 Oct 2022 05:44:58 -0400
In-Reply-To: <YzROGS934MbKlwxQ@octinomon> (Jules Irenge's message of "Wed, 28
        Sep 2022 14:37:29 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:806:f2::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB6616:EE_
X-MS-Office365-Filtering-Correlation-Id: bceafc87-1590-4945-77b3-08daa3919bc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6C9WU/yd9pT8G9Y4NB3lCsaQJyjVBSZyG1G6d4YcO9n5WHa8dSm2J0w5O9z1K/CT+xt3XBgpWZTcvLznQxDl0n7zCQfGImMqz/JeotAwlrtoyKMeqQfj53DwlaqPy7rff+0JXKa3QuH8ewuGactTBDyT4XBU9L1oFaNGHugdNJTLaaU0iD0J8x4yteBYdU8cY2CID7RJUFzkjPibPndyuBA1y770Zfnmdss72R/SpU9Pu055BZhzreYZ1He5FMorBGy0JeqL4Thc/+wX9cjeahAtTaUM16LDsm4H/cnUuck6Cy5XHO32P/ebGnH8rEUj0xCEoNTp6o7ulpx9HEZ56QfZ2YMm82Gtas97NKlB2IGQRPY/1BrtsXyqf4yrlzGdgcHSlJkAjTueS/OwP9GKTe8guQ5PE0zH3g53OUyYYWYCk/XOWv9pZHYgxfA0CthMswE4/miH+nQOQkhEcfQWzccjHv6gVyeN7kl7f1zMi85I5evdnHhRdV2v6qxPX6nvCrNnthCjPW88lCuQKmbebf/n3CyQyzT8uTcpzikjzgiZTNJM0ORdEHWZAdCrEf68rRTh7SPT39GofAARGjOpf4nDpaMkt906j0hOpoS4SWg6SaK0WTopLqyj+APmQqmp840sXiT+ihN2BNWHps2Okh+9dnGvdLhLivbdR+WxITpbklNPRQUhFipBhsmbfbTPtJ58QdTOtzoU04ud0PrKCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199015)(6486002)(6916009)(478600001)(316002)(41300700001)(8676002)(66946007)(66556008)(66476007)(5660300002)(83380400001)(4326008)(36916002)(38100700002)(6506007)(8936002)(4744005)(6512007)(186003)(2906002)(26005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oghf6tVT9wTxodQOEIHXP3TcVzgPtj2ESkHtsIxhMixKPeJbZ/x2M8exGOLb?=
 =?us-ascii?Q?2NPVynnIrQyYTDnvnAHfQQ51nfnHaajsIwocW2WXjV8A839USxXOCT2rbqZ0?=
 =?us-ascii?Q?5FhCY9EFGIW1nzm1EeptrFUQu4aGyAKDSKoJJx0qJvi0czzYRAIuA1w7Ulqq?=
 =?us-ascii?Q?m6sa+RH57FOUUAh+gRb30Z+5wqKCyzi2oDS/G13iMKBtGDhKpNBusqXBkoe9?=
 =?us-ascii?Q?OpXGNn7bPEJTJnUnpRgAE6I2r/c981soy4e/wHCvLAahvm+ZWe7atbfCyq5c?=
 =?us-ascii?Q?DIasei0prsXIGd5Iyj+gq7xkke25wtK2EsRlSJ+OeoqNgT4X8/N6PF+5lfER?=
 =?us-ascii?Q?FT3dRJ8Ia3ngMTS6vfMLwJ1fsIuV/LC4x8CHhsB9SY8hSKTcszfXJa4PIlj7?=
 =?us-ascii?Q?sTKfibEaAZch/v6+75Ogn2mVGjynDR208pL+FcE1ED638UfXk0T521Dg7/Kd?=
 =?us-ascii?Q?05tp8KbiiX3bZKoS2YXxC0Tr0LjiAcGYspjro+Vvp7+9lAgGs4NO6XzHasrp?=
 =?us-ascii?Q?Wr7h6AG3U5kU6iaMunBG4Df/lhj02dQOWxBniLuPlFz1MzSNMeAJV2qVlZPm?=
 =?us-ascii?Q?FIMjMxokECS1wjtoFd3OcB02VnLm6IN4zTTAyre9MB8r5qvHenNyPKXDAEgT?=
 =?us-ascii?Q?Gx88yDzzsjhhJvpWKTfyKuzPgXSWWb3j0RrWuATbdNjUNE1eWi/Lh9L9hlCL?=
 =?us-ascii?Q?3ndp3VTk1r3lyzD/9a5L6TlpKPXPg46oYE/zwuEROxQuLStzrIL8SuT5ojEf?=
 =?us-ascii?Q?hg8VyevbwMQ+IUJMi0dsFgCjyZm/JhT4DB7zm7FZTP7pBNoUY3EhLPUjHxQh?=
 =?us-ascii?Q?bJYAxXr9YUtQLQg2sgcIiYv4KratSywI/MlKgcS2GITpDKUpSvzRKoAXrRfg?=
 =?us-ascii?Q?yeowTWpRdZetmcxUotnm4UmgxJPI68F9aXdlgfz7cXh3b2bxVjUFtp0m7vvk?=
 =?us-ascii?Q?zyoxPZ/7IaE4WCOFtHFoAkIsnqK8XUCB21dtpQbvK1/vRM9BMMB+UYU8gtIc?=
 =?us-ascii?Q?huPn1tVv/fiE0+o8oYWdQCDPmfjeLNfzI53KAhcN92++4HtryRoxRLtZSz4a?=
 =?us-ascii?Q?FCcGZaCvavTN2s/hg1jHy0MkUjkTL2pVKS+Nwtg+1pihZfJeR6JRKB4EX6yd?=
 =?us-ascii?Q?HdIFzmAfVDLG9Neq3r2nNvL4eNFtGAGZlXguA/y9toiKwckBBk753ZgXqmLq?=
 =?us-ascii?Q?9/VWgvDIcwOl8WExfAG8x0TA0gekVXn060aH3JAOfOJtSxp1obH9fn81flmN?=
 =?us-ascii?Q?k7+ZgA39HpQqZtwYHI9K14C763R5gIvwRnL08x4x21BnVMoPotEFahJUVHL2?=
 =?us-ascii?Q?bQOr4ykfT7gA+m75pJDUbq0qRjOKTfNEyRIZgj9KK6fn8Oh56Y8hXDmCbKAd?=
 =?us-ascii?Q?OVQGtuIkbh6vFNgiwAcT6/NuIS5MDDd/KdZGL7bGfgXPkz+LMpz4+UPioIFu?=
 =?us-ascii?Q?hYgKf/BnkpAJq5jZc56bKhiF0ePggWQiySb9W85B2m+wVe4wODr75vDCgEDd?=
 =?us-ascii?Q?JqMfV4kXCbvH+p5+/XVMuvtQyNqe7Dtz73PWWmmNBU+ziomzMznMV2C9PVPj?=
 =?us-ascii?Q?gqBhBwB3aFmWHyNb9L6/yqGN9GDofiO/dnARf7RHoDzbSLpxFrcFphvTwyxO?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bceafc87-1590-4945-77b3-08daa3919bc8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:45:00.7100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: afGqB6iOzO9f3Hb3PAY7mmAcB7VLMv55kkUV94RmRs8RQZl09ZqdPQJQ8/9Sk65mWxkfZe4vcWzpZaFrFyDTfmbdFcKCdUCDlRK/NmGHQ7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-01_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=875
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210010061
X-Proofpoint-GUID: jfNjHq8u_bGysq2Ojx8Wg05jXcnubHpj
X-Proofpoint-ORIG-GUID: jfNjHq8u_bGysq2Ojx8Wg05jXcnubHpj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jules,

> sysfs_emit() is preferred here.  If I have the blessing of the
> maintainer, I will go ahead and send a second version with those
> changes.

I'll consider a sysfs_emit() patch. However, I truly wish the code
checkers would limit their warnings to places were overflows are
actually possible.

-- 
Martin K. Petersen	Oracle Linux Engineering
