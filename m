Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C12C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 07:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiBRHqq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 02:46:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiBRHqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 02:46:45 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D7BD8A
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 23:46:27 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21I7LWf3011677;
        Fri, 18 Feb 2022 07:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=R3RUNA4k/PJ74yrpTXY/dMux2GxiHa61ktUXuTduNrw=;
 b=Ml/THLQys5hUAru4ay9I4e2aq6hV9bJx5yzfkUsLMN1U5nVv+Lak92ZPcPfWB3aj20Tw
 6JKtA1pGnUGSjyWhKPLqtaqVeHWcMEAUd8cDTtJIgCEU9J+nFbO8eag5Nr94MTWFzhQt
 BbiXmrIMDPRb9lONGFMNjTLS3bZXpdcB4noqJUxNTohWXNSZSeP6qBJkhdko0T3N3X9O
 BDiEpdNFjjE/p3EVZ8EzHBMv/klBOHi3woxYrYeB4COhOJGlX0JaeSiuQk/GPibXOrC4
 vN51kts3L/wpq1iArAOCfQEjrxjTBj0sAynlIMCrdVO2OHp89wV5Bk1vXvA6exrru4RN Ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8n3e0j5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 07:46:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21I7gNsQ192803;
        Fri, 18 Feb 2022 07:46:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by aserp3020.oracle.com with ESMTP id 3e8nvuvg0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 07:46:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETjVCSkmbjD4HIO5+l3OV4FKWKe4iKjKE8mngtqI9JW9mQqml3j1y9qhoDpdAAojtJxoW67I4az8azA3eODlR3AGwPGcOPb4hNsQe59jZdix5/QadNXP1OPY7wzvPr4W5LA9xkvMWgnFM0FvUsW5a8VU8FSnhxh07hYOVUeyZ6ROVfDPX6SefbNqRVrh6XUS3nRNl/icpzcOAuvDna7HCO+cXRJFs2Ij3pg0EOj4kVTV+xzXZuYYsMxfd/7wvvyGZGKUZi94QHeAsE5YMQ9lYVSR5oiga+w//sVNKDi5brmIZaO7JNLhXex6LefAneQWxw/2r4CWHhr7/4U8r9NpIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3RUNA4k/PJ74yrpTXY/dMux2GxiHa61ktUXuTduNrw=;
 b=R3gwRsx/BiM0C4kWGSUBddtKoKxWr1NTCmyQz/2VMh2NCjcm6Z5NtjQ0jXKEQVBVHIZbvb1+ilTT0/5j3w9b/BpGbaZ75QyOlTit92JJ7GNAGIPGl2cZntUyEmP++cpTFFAGpMX5yaMi3S7vW3y/Bdj34S2rX+HB1LqlvTvqWa8cOrzOCZdXiWsWeJt95YXFD5SwKXFTm7tG4yxNXNRddFG1NYoAJbhxvq7J0BlJSOhmCmdZbi4EVeEXthHuQjJ5w/PYche5Pia+aPL5hTinyaJ/WOehE2gcuPxrFk+6UzYW6fU9WCEBoU449iq+vttAfr9xENqUfRckk5KMvA8hkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3RUNA4k/PJ74yrpTXY/dMux2GxiHa61ktUXuTduNrw=;
 b=KpNGyyqpTe5bJGZ/cZp45802EpFOOb0uND06NlnQuvuXZC7VshGCADP0k49xvFn2Wlr6ILgsNlFFIhP5/OVtRUwykR/fjnA4uTfKgh1Hr40bJdonrDFbYwbOdJMRi9KKXUlODFKlj0RojIlVgEtii6cYAt43oQrkFwrSjhIYDTM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4564.namprd10.prod.outlook.com
 (2603:10b6:303:6f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 07:46:23 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%3]) with mapi id 15.20.4975.019; Fri, 18 Feb 2022
 07:46:22 +0000
Date:   Fri, 18 Feb 2022 10:46:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     gaurav.srivastava@broadcom.com
Cc:     linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>
Subject: [bug report] scsi: lpfc: vmid: Introduce VMID in I/O path
Message-ID: <20220218074613.GA10308@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0168.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::23) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1382b9a8-d391-4213-7947-08d9f2b2c23a
X-MS-TrafficTypeDiagnostic: CO1PR10MB4564:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4564F465C84E69202E7E3F9D8E379@CO1PR10MB4564.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DGwey7QV1qfZCoNJqkU+IK029inrrgSprp00PQQhdFomfzXguFtG4Op4CqNksON5Ozw1YdTsrRc/bYqJrKif35RVskQHF5bBwKsLfkf43zM3srEtBrXJJvfS1lNr+2vBPEYmMv73tUrd6kLEg7uSrGWrKyN5IbNtMEGZt1YSSJFgxIlVXdqFVOSrSqqZ0XYDdixLDr/WFiM4BmsXIcO3IEZZZgDIeS+FVLwe9WaAoZDRaQnb2yIuygUYJl/QdVTvmuV91iGWiz0SFqfskrm3mbuUys61mfh/P8bSHjakhG4MzZaiTobanCL3vGwSNjVKEAdj7ekVBX0DdmSx7nYXovtDBW5hDKczd2yPeYYZ6XwPAgdpFt4tw7m1gve5nwgovk6RC13AyZznf7zH6i0Csb4ai7pnJjZu67umf5Xosu0s9AunEq5zbqB3lu+pKDhMfzsFs6+P9AW5jtacb6NE0y6vMxAJSRQ2ovgkUwGgjjRDU5biXGnq7qKZxmFFlQqwFalCJOItgfYr/93gkjmWlbLf8UeKC/d8qeVmjdKjrY/3yo4K8wyiLrxy0Y+wpLf+Wrot+sbOrobRrMXs34MsNuJcLTUZkqpM95m/wFWbFVD82ArOifd9n3tMM0YdTN5lK915ofHwPveWkXPTumpNBJ93YR76JoNrgFS8CAnyhxahYzC4mtodG32aZtenJbkpWx3JbRKPZBqgI71Tmt5X7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38350700002)(33656002)(8936002)(38100700002)(8676002)(66556008)(4326008)(66476007)(66946007)(33716001)(6506007)(6666004)(86362001)(44832011)(6486002)(316002)(9686003)(2906002)(6512007)(508600001)(26005)(186003)(83380400001)(1076003)(6916009)(5660300002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?waTp+FEdcYXGUL/Dq22choNKEJmwRA64TSoiQr1GJDoR7JzhlB1bnA/XxcEN?=
 =?us-ascii?Q?vQTvC2v+uV4AD0cgaTuFwmXQEw2KmO8/pmpb8yy5VCiTCzV3beNmpxgYk0ON?=
 =?us-ascii?Q?7GMLlfrsr3A2pIf4oL1GKxjrCwlYu4uvDdOo7AGntYRZ8IDdjh6pRrAJ4b6C?=
 =?us-ascii?Q?RXkwI89BeJIK+WSIqlqImHCczpPbumDm2pkJ6pCy14ioweyu8QMpf1/cHlny?=
 =?us-ascii?Q?WsdhmfUk9Z12vEZQyLnCsB5QTsTHcTn7/oAlK1w0C4wv4jB/zIP6QG9G7+92?=
 =?us-ascii?Q?tJZUuyUBGndK7Ml8mqD5dysOhFenBRG1GHeD9n0LsRfPR69F9fbtQkUK8nAQ?=
 =?us-ascii?Q?betJt2Pkk1EiAsKFoKM1Qx5J/XU2/rryg3UF84Qtr8jQUZTYrSxPfmzLGiKD?=
 =?us-ascii?Q?gstCbNhsPoOCq+p9/WiF9DBs0BM62USBenk85uxISBsI1ldaJbIFf7JT0txX?=
 =?us-ascii?Q?2re46YK7HrLMVwULPd+wQK+O35yKEIkKC2nKZIbJ3o2EGmdWcP5uqLtXFkuM?=
 =?us-ascii?Q?5/RwqY92AYbIyuRgpBsTzJozRFldHuLw/8WDbxW1hhGfIVvPIEeWzAaoxaBv?=
 =?us-ascii?Q?rU2kQX7ZHeyVxPk7j3sGiyNd2v3+oO57IitWW/9dS89KLSyvMc4M9UTYypyW?=
 =?us-ascii?Q?Z5TBIjABjyQB6eZYA/a/euj0Sj4VOYxi5L9Qz6zh9j6qMH1NII+w9HzGf98i?=
 =?us-ascii?Q?phkDIa8vM3l1wP9MAzfsusNLzsxuC4PTvt+lZBouaQhleooKEJNl5bd6Guei?=
 =?us-ascii?Q?eXZzUQRgrR4mxgnL7VSNdGJflaWRVMS7/clS+kjEmH1uZpXk6Y16UTKsZdHB?=
 =?us-ascii?Q?ap3dHH+314kNr3sG40wplEpzxlP1rb8ij/LNu+e4YllL2C/6w/LS7TT73hah?=
 =?us-ascii?Q?2h6LffRXdDKU9Km7vt4kNLA92+STBv3Pr5GQe4zoV2om5sSLVP4hfiTr3yH3?=
 =?us-ascii?Q?KfKO6+GSZilhQHN1veTEur0L8UJEFrxbYb4hT7WXqh7PhYymelZWyP4Niq/7?=
 =?us-ascii?Q?tvVcEmKXDiYbkirhER0Yyyp2q9JPzU9pWtKLzbPiuvzNwBpqMC+3RzCxxOCb?=
 =?us-ascii?Q?qUSaawY0+Eovi3Ty9ZbWqtJHCoxFBJ9Ccdp2lmysgTpKCDyOISXjVdnO4p9l?=
 =?us-ascii?Q?8ODwe5W+ePhtrZtGdExF5lS9YeY99hRDGp7KmsjCOGwY3EwBVdK0RNlzJgGp?=
 =?us-ascii?Q?Q1f39+64bomo2PY7d6fBBNNkjr1P/nuhySsZ4HIBhX3EUl1SH5i3murhD4Bu?=
 =?us-ascii?Q?oi06+j6nh78k44spJlJXwJ3J+KUGk0+zCMz+KuJCu745kAeycbcwM78Rl0GF?=
 =?us-ascii?Q?iYPC8gKyk6JhVIuyxTK8KHbQkOTAop7H9BaD9fe5/k/Mm++5UE4HuRDz+E8k?=
 =?us-ascii?Q?5GeiasaHmz1xrAXolZ66CIK/50HIDB3AVGHiYeembBoYA1zos1ZovIN5i6QW?=
 =?us-ascii?Q?E8wwx76jeCXA3QtJSDp2tO6yf6cnRNKRXpUmNavsKgXyI8hGb4hu3gZD5Djz?=
 =?us-ascii?Q?nvTCnDeD0iItMGpH4w9svrMi/y+q/QHpMYBc/EWQtvXJDq7QcvVY69YjYSUH?=
 =?us-ascii?Q?UsxxA29pBcdHtfyAiQa1Sd0HSI4nTsbA3aLLlV2ORZ4d+ltjPEEgGW3BaN31?=
 =?us-ascii?Q?Crjv7NqA0w5LsngKQ9s8Y8wdQchSGb2ORvcINnfCIYI2YlqzP99QbytoC5CQ?=
 =?us-ascii?Q?Y6tnLA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1382b9a8-d391-4213-7947-08d9f2b2c23a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 07:46:22.9004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ij9xMmNSp8QhQ4pQG/208OgQLjBcJHl2VekDMNicnkznww81P8HMYidRgsxurYnt/5gclbS2387c40oNeq/tSqAPlArDNIYEUICyGW23Bsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4564
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10261 signatures=677564
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=853 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180048
X-Proofpoint-ORIG-GUID: _5vD3fjHumpumuKhrHz8nMnF2_Q9-2S2
X-Proofpoint-GUID: _5vD3fjHumpumuKhrHz8nMnF2_Q9-2S2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Gaurav Srivastava,

The patch 33c79741deaf: "scsi: lpfc: vmid: Introduce VMID in I/O
path" from Jun 8, 2021, leads to the following Smatch static checker
warning:

	mm/percpu.c:1949 __alloc_percpu()
	warn: sleeping in atomic context

drivers/scsi/lpfc/lpfc_scsi.c
  5510                        vmp->io_rd_cnt = 0;
  5511                        vmp->io_wr_cnt = 0;
  5512                        vmp->flag = LPFC_VMID_SLOT_USED;
  5513
  5514                        vmp->delete_inactive =
  5515                                vport->vmid_inactivity_timeout ? 1 : 0;
  5516
  5517                        /* if type priority tag, get next available VMID */
  5518                        if (lpfc_vmid_is_type_priority_tag(vport))
  5519                                lpfc_vmid_assign_cs_ctl(vport, vmp);
  5520
  5521                        /* allocate the per cpu variable for holding */
  5522                        /* the last access time stamp only if VMID is enabled */
  5523                        if (!vmp->last_io_time)
  5524                                vmp->last_io_time = __alloc_percpu(sizeof(u64),
                                                          ^^^^^^^^^^^^^^
This allocation sleeps.  A non-sleeping alternative is __alloc_percpu_gfp().

  5525                                                                   __alignof__(struct
  5526                                                                   lpfc_vmid));
  5527                        if (!vmp->last_io_time) {
  5528                                hash_del(&vmp->hnode);
  5529                                vmp->flag = LPFC_VMID_SLOT_FREE;
  5530                                write_unlock(&vport->vmid_lock);
  5531                                return -EIO;
  5532                        }
  5533
  5534                        write_unlock(&vport->vmid_lock);
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We're holding a write lock.

regards,
dan carpenter
