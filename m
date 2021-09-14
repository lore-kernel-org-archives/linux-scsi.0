Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA003C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 15:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7E6561163
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 15:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhINPxr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 11:53:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:29928 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231928AbhINPxq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 11:53:46 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18EF4wTg024470;
        Tue, 14 Sep 2021 15:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=zP/HjOj3a8dWBraBlOkFmog0VSB6a9ZcmaC6CigjfaE=;
 b=OcPerv07P4TnAe5IdfaszBLLZxGR+a6MEPM5DyjgD9SWCMVq7MMKYhfaqyQJFjPz4t4e
 Ahi/wqxHj5UW5rfjlaIH8Mb6/+zbJXsFprLKP98OtqrPikPpPQ1AN6BlxCcOyvRImjTY
 he8AUhBBtjPXUgR69hcKzgMGDdjr3K5FgVaL9dUeGLjqrS6iuA1nMCyYpPrEsxENZvtQ
 /4P71TTUGzHsPe3UophmRkOtcWEUxIjdpLLOzCbQ04FYlsourI18FLOYhN6jCjonW/N6
 YXtCv+6svv2Spy9+fEooMbF8BHcf7Dycmznsj3GlzG1buxunUED1DG424NER8jq1geOg AQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zP/HjOj3a8dWBraBlOkFmog0VSB6a9ZcmaC6CigjfaE=;
 b=AhnZt4hcEt+sesxZoJxPvPvIMXm1jKurxpJeVnmT5nESP/+ldCop+D3XiF+uRN17dx8B
 dnZYPj2SzkedSxTG7YVPu+wLyDMW4OKIXTo0YnZN4K8gW24yGqrkvcEjiyzOxOfTcgod
 aKCyD9X7t7xOPNZFPf/WLdKBi2im4auCP2QLPsESVJDUSN1MGQSOEB8FJ4L3X/eg8W96
 aNK+QrZLFHsXgiSRQ/MxjIZuR2+BnYSGXrcQaP/ejVkbi5zldRs+z3RueGOKJr/R8kyX
 M3P1R8OgQ9lx0IaivkEHUVpbUOqBBydKLfRKvSrOoOyH0ODi+tuQFApggzEhhnBcFIZd /Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2pyg9tbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 15:52:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18EFkXcR161171;
        Tue, 14 Sep 2021 15:52:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3030.oracle.com with ESMTP id 3b0jgdaneu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 15:52:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdKKJmVripyM23qPiXOFdw4oVp2wXSWHIxfg2EliD15jyXHfx3HhOEIs6VHwrAkQDnhYzHmZ2TJD/Avafq3PdWI13Ln6zbWASFtnBF7IPZ558XtrW3gR0S++iJUo0r/0gRmp2/rBA52dBAHuVPpodRm3J8coIW0Un7dmtC5pHUhVwxB5+ehAYIMwXVuUlIjX9NkzUro5HbXlGI6qkkWPbbnv0VvbHtF49XijAmHFAyTz3Fz+Y8ls1MMfmST8uizt2V75ogvpvwJXQ4Dh0Gty8XSz0Ekd547jrH9ObPG+5c8TjK3WIlnltRVHespJbZ/DJqZvBO0IhZp2TdYxBh99dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zP/HjOj3a8dWBraBlOkFmog0VSB6a9ZcmaC6CigjfaE=;
 b=Lx8OyAf7lWueT1cXEDI9j7KLBecbpyfWv1hY2QIvBSrk9YYHAsnW3TE58OEqo8qrfiFVWTi2yiFzAZDBjzclKbLovnc0c01hrNcGN/WbaMxMJL1TeYN9fdWvpVK+vPMIEcLqcyui5Wh/IPRPpN0QZEvL2k70EJ5iLwbhjrb2c/t91+GfX8HdkcqeIWZLsFtE8GS+BVFjhwVf2UkdY+0CiDXB2Tnt9QXesHgJKboqSWDB/xdnSJH217Owe/dpfHvgsw9Ua6c0tR2tk7IFI4Idtg8duZEof2CrNFYAqfn4w6pMM23VNpRLgKwBFCon6ffL2eW+vz1fgyhTrSKdgpfg+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zP/HjOj3a8dWBraBlOkFmog0VSB6a9ZcmaC6CigjfaE=;
 b=GOniKxqBdtqxxMCnlgEBJ43wB8npCysKa1AgKDgK1dRqkQccSjMcbH4QwLbkpxZJ4y1vj0wSuoJRtXgsayjCt+Pd3sGNDqnI3YpxB3gpENIkyTgB9yenTmtuiXFhRrMvnRX/HBzaRVPlakwiBIfTyR9CeqTNoiAJarL6MiMvK20=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4757.namprd10.prod.outlook.com (2603:10b6:510:3f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 15:52:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 15:52:25 +0000
To:     wenxiong@linux.vnet.ibm.com
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        brking@linux.vnet.ibm.com, martin.petersen@oracle.com,
        wenxiong@us.ibm.com
Subject: Re: [PATCH V2 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1drxjl4.fsf@ca-mkp.ca.oracle.com>
References: <1631300645-27662-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Date:   Tue, 14 Sep 2021 11:52:22 -0400
In-Reply-To: <1631300645-27662-1-git-send-email-wenxiong@linux.vnet.ibm.com>
        (wenxiong@linux.vnet.ibm.com's message of "Fri, 10 Sep 2021 14:04:05
        -0500")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0062.namprd13.prod.outlook.com
 (2603:10b6:806:23::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.50) by SA9PR13CA0062.namprd13.prod.outlook.com (2603:10b6:806:23::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.9 via Frontend Transport; Tue, 14 Sep 2021 15:52:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72ab5624-32c4-442c-6a24-08d97797a566
X-MS-TrafficTypeDiagnostic: PH0PR10MB4757:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4757FDB24F30FD9AFFA4F99C8EDA9@PH0PR10MB4757.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bPu/qWiFAszMwIy3vT8Ou5gMXQzBLiT4dufDUv42fLTeTzAlTWAff+Q43PvXno1HkrA0tHrKCEZN/94lA5xhLyeSQXgFH91fYFrbH+tGjBfDpBPy7EB6G3kEs+wjqc0DEl8EgqhZ0QRhhOuQZ68OzPS7Z/7/VtMY2Mn71Jt2TgqkTOL1mSYr+zH9fFM8LAoygNpxAzMhrkr4d23dj19lk1IPJFrL2mGpq+Nkk/nrf560oM4Laj1FKP6dbJwrrU0P7WeRjSwGVUzD4zHCGIrbfBQxXyl6tTfHvs55nNrVa0+oE0P5AcuZokAsVoEmN/PK+jXBuhIl+Ay4BJfa8TBsZQWhBR9MVKvcX7gQHtNKMSoIxA94WKNdV2UDRLYYFk4zW2qpJ8pQ/xsQOU8JbYPLf+WfbKC/W+rD015mLVA89zBOJbcDMBFmXiEce+5fPM9Kih+WJcuSLrstSgdpS7VdKrSAflGKyRRVxliqdtbXqTqX/zP3emz3n4LLDmK4OF7QA5+zSnfGhbiDMpyRHVVdbrWO5b+erD2ZA6SeFiMR2/pGGMb/hUCGXF9EK9OLjHzOq/aHtV+L5c221Uh5rwblHppnTMH3ZoV1+yX3bTVZ3fg3hzo5hjDkMWrCL+OYdehkve8imCJqSTXoyHgX8hRofDBfLUHmUely0U/woI8Dqdx1MJaNvrz2mbv0AQi6j+ZbXJTS+L65I1E6ahr5mbRZrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(4326008)(38100700002)(38350700002)(66556008)(6916009)(36916002)(66476007)(186003)(2906002)(66946007)(956004)(478600001)(8936002)(5660300002)(8676002)(86362001)(4744005)(26005)(55016002)(316002)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xPAToYk+cqCNnbOhNK/bunfkAlQp82laKPDijRboow9p/NplXFG+6g9wuIhK?=
 =?us-ascii?Q?XZjWqIMr85Si+10S6AZY5cMAiryc+RJnMDyxcZ8RG9SujSRjE+FIVzkzXoG8?=
 =?us-ascii?Q?FnlIJ9+I8eWwxj6RpnMNYGEWEHxLtp0p8zYC9VsRhurRh0pmAfwygpGUifrE?=
 =?us-ascii?Q?Dl/JBMWzTHWrkevdtiqKxABvKd4jyeljIgs5WmrNsO2k7Hja9+lfl+94dpmq?=
 =?us-ascii?Q?yBtGt4ovetrfPTGfZy8KEWb3coCSgNB1E2awQpJR13id6+WQrwGBZoq7Ph7V?=
 =?us-ascii?Q?SfxNA7XXTpRaCAy2F7yka8LC3w/bKT4UWbxzPniVHE8sQhlp22ONDSNgZ6tx?=
 =?us-ascii?Q?lTeNhvISfhbp3ERDnttulqJzwobDgKeTo9lSGO9rpEDnHHT+MWkdQl+N3mdE?=
 =?us-ascii?Q?rMsgN07Dmy2lgkaKr7MA98ZVeuDMQWkz/Fep7HRit3ct3sacZwsQaSEz/pPn?=
 =?us-ascii?Q?VOLy2c/12cZcv5/9fY6WdCVHsDMT4gFIyQnd3+L3cBEWJucUwnXHniU949xf?=
 =?us-ascii?Q?YJkObOzYk1Y9MtDqK5NqdZGdlEim71qt5tmoapbtixRCGslvUnXmJoCcTQcU?=
 =?us-ascii?Q?oA4nUT7CVVsvIvVg8OpIGGVx1GimPIVz0bIiFZnoL1FzTCjz8NpTPXbfOxBV?=
 =?us-ascii?Q?G2v3APb+FFQ1kHxCISDjoghoNCp/0FJK2Hh0H7rnRaCAL3TJY82OOKTlDNZ3?=
 =?us-ascii?Q?/znJSJdC/QHviW2EtCL+/NIjJ1zBar5/XpyZcy+eJjRZeI4WzorvGny517Qv?=
 =?us-ascii?Q?ly2qA1DIL3GmPPfGwQvHvV7al8Oi0T6YS9Q8GwJhNhVc2qhtLX4x27+gPyWc?=
 =?us-ascii?Q?nBI6chDiFvN48SHmVd9m1KcH6GpebMbo+3nctqn5Q66DNDVz2dHTOxHTr3FK?=
 =?us-ascii?Q?KUW0RH3FNIlFvaK4vrE6i5prSPDUPexXpMlqzJOe3aZlQtN26qY2zXRWsXAy?=
 =?us-ascii?Q?7rKeJ0RiP2FSX/Rgw+KNxR9lww4UFdHJne6AVmkCXLB04s/7l+bV/Zk2uoOb?=
 =?us-ascii?Q?wqMatOmMMi8cPuGeTqo8+L1Jv4qNVzhSYxd860FVOtT7M6Nd5nKJ3HrJz59F?=
 =?us-ascii?Q?mPyH5GO9ABC2lSJfqMC5L2Iv8jO4NOsXEre+KUXPZQmoi4Nun9rqdmTt/fnY?=
 =?us-ascii?Q?V86cCOBKQ0tTkn5YbQnWDhKaIAz3cW6GKZPKd2Kpft6iUqSbuovxazMgxwZR?=
 =?us-ascii?Q?YGNhmdsxZ1D97bN0x8WA3J+EyxUxWJ+9N0D0BPLbxB7xrC+sngjsOpvhCXaB?=
 =?us-ascii?Q?66ZrddOiCINFkcDwO2ZDhVvt9BICmr6FCaTXIiPfEfz8g+XGuE64nB6sqSDN?=
 =?us-ascii?Q?LHwpRazsayriyEVieQT48tRF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ab5624-32c4-442c-6a24-08d97797a566
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 15:52:24.9380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cD66ngAC7TlqqeqOWf+kGaaSui+vl98WTqjUYkPNNW6nXDaKV5ICYPcfXuROgt6qmKh6iQCp+ZyBgjsPhH05DH0XF8LGSa+nu7vchO7P8CA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4757
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140093
X-Proofpoint-GUID: HDSB05q_1t_JKAXdhvRlNvc8zNwlOYlu
X-Proofpoint-ORIG-GUID: HDSB05q_1t_JKAXdhvRlNvc8zNwlOYlu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Wendy,

A few small additional nits...

> From: Wen Xiong <root@ltczz405-lp2.aus.stglabs.ibm.com>

Please make sure your email address is correct.

> Signed-Off-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>

This should be Signed-off-by: and you need a space before your email
address.

> +		ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
> +			bufflen, &sshdr, NULL, SES_TIMEOUT, SES_RETRIES, NULL);

The sense header goes in the field before SES_TIMEOUT:

int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
                 int data_direction, void *buffer, unsigned bufflen,
                 unsigned char *sense, struct scsi_sense_hdr *sshdr,
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                 int timeout, int retries, u64 flags, req_flags_t rq_flags,
                 ^^^^^^^^^^^
                 int *resid)

Thanks!

PS. Bonus points for whoever fixes up the scsi_execute calls to have
less than 10,000 arguments. One would be good. And some sensible input
validation/type checking.

-- 
Martin K. Petersen	Oracle Linux Engineering
