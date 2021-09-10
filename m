Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA9EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 16:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A368611AD
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 16:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhIJQvs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 12:51:48 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:40384 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229466AbhIJQvr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Sep 2021 12:51:47 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18AGfmvR007212;
        Fri, 10 Sep 2021 16:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=9Kw5dAwIbecg1wGXmVcQ4y/Ao6NfUldCjGZeG8CmcMo=;
 b=BHnrVf03ghmrKZjVe2asmGK/xwzO1FgcRWxBiOT9mh1DkycUPdfukyZLclKSKo74xZW0
 F6iFtaSlJIK5FS+JUKdqd/rkDvQbmw1yTdDWkGJ+v/egayNKWx1llaw0xyFurDxuh/gH
 TPJTChiGcFaif66XJZQsgQ7Gzb1BtSGcgsOUsKjnFCRxvbaka2a+WOcWbrH7Dj7eGYmO
 Rw2knwlp6f1NNkxtWpMzNEEXwt877u3/mdKnAf8Sqh9fb/fcXBOD/7eILF7g0D0nPXO/
 nBywymGdkB9/pTJ9wIvhx4MRK91fk68EghFtAZrbG5PtCJWxLhHpqNrzZGnNDBeyIZV4 IA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=9Kw5dAwIbecg1wGXmVcQ4y/Ao6NfUldCjGZeG8CmcMo=;
 b=KefzY44TQonMAyq10piK+gD+biZVSs8xELFpLOOjVjtTCOuuIaHV5YAz24GKiOy/4vHW
 X3JaYI2ktiq8pbDfs6oW7yoRmOmuWDazzpo4+g/OVT1NMYg5L0QR4HZHP/sL44SLnQJv
 ZdtbbCIN9tdsbImPi+LbjC8zlIVzrdI3LlDG16SqjgNZtNf13Df8si7kIlSmLfskyuZz
 MkAMablKxeOhSHySrpu4sESMMI+Xm+p6GZaMME7kQRoWws9GO58SMWoQ9X0RPvR/e4pB
 /nKzWW+kV2zKgzcYzWPU73OsHOGW3pLFYOoULjDNeA5pkWpQOc3fsvc3D1vvptmi2/H/ Fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ayttbjhbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 16:50:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18AGoK2P080951;
        Fri, 10 Sep 2021 16:50:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 3aytgesxa9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Sep 2021 16:50:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZexsAxTslBsnUKmujxqyD2WUpfNiYaItvwlZ2Bey5WNUKS55W/yjbVBL2mqnnDzpCO5gKYN7dlqelxOAr5FI6ofv47FtQ6m0V5klUBd0vXynXdEeWMxJgzl64bPjbUxxQpG9lT+cIHobazivue/zLlYKAdZKLjMB0C99nPhAWqeS2xH6dsxvYxwu8kPvZqPAop2SnX4pAkbbnGlpRh8q5th5OZ7/SCJPAQSkRCers7CkNJU1rLNdFsiNmtWBvHEl+4vXbdLHXI15m1kNQ3vBJ2WLp0oPjzJ5c2ubpJiGL2iO6u5t9TOBKXiS2KGp0soVkSircKLQJ3tMqhhxdx8FqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9Kw5dAwIbecg1wGXmVcQ4y/Ao6NfUldCjGZeG8CmcMo=;
 b=j47KhhMLk/phu0Mm2btFAddk3gzZzNQu2BvMdYG47xM2SVkIMZIG2NjdtSnu+I/79esI6yNPMx7MWVtZYnJEt1JjXI7ntBTos85RqvH9f8NmQ/eGCPxSeKl/HA8Nlnt2M7BkNSwjLUJwjaOe/PLeYQJvE433NlElqpfilOMItYF9FzAdAaqdtheZwaqWscCuDSo/ifTij9zgiqFj90FhcIqvJo4bgvv+H6PIAfvcrbbp0RyoCRTYHxKXRp3MdUA2+BRhUaWx2TBLGc7b08LmA09Fjb/YJQrUAFae4LwxCni3qtcRmDnBntKJFZ6LhjiLE+nzRgcNbKrlqQYXVXDGPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Kw5dAwIbecg1wGXmVcQ4y/Ao6NfUldCjGZeG8CmcMo=;
 b=ytlPJqD0Pbq1eX2sEo1n2cgLSelR0KUXfqjBjy5/Frqkb3ZYkr0z5pKKkp27sHoEsVFZB9+jXo7BTB3sFIM/FNCVkHmEUWVbrTUiCxOxU40y+Yk7UMd5fgbaVkl3JKzjU9lPwQoghtLS6xhFS0pbFh7K0ml9SG4kKCwxo7WpLEM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 16:50:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:50:10 +0000
To:     Johan Hovold <johan@kernel.org>
Cc:     Zenghui Yu <yuzenghui@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk,
        martin.petersen@oracle.com, hch@lst.de, gregkh@linuxfoundation.org,
        wanghaibin.wang@huawei.com
Subject: Re: [PATCH] scsi: bsg: Fix device unregistration
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dfo2x6z.fsf@ca-mkp.ca.oracle.com>
References: <20210909034608.1435-1-yuzenghui@huawei.com>
        <YTtTU4+DZEb4WRkR@hovoldconsulting.com>
Date:   Fri, 10 Sep 2021 12:50:07 -0400
In-Reply-To: <YTtTU4+DZEb4WRkR@hovoldconsulting.com> (Johan Hovold's message
        of "Fri, 10 Sep 2021 14:45:07 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0084.namprd12.prod.outlook.com
 (2603:10b6:802:21::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.32) by SN1PR12CA0084.namprd12.prod.outlook.com (2603:10b6:802:21::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Fri, 10 Sep 2021 16:50:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9799f8b3-1a68-447b-4eba-08d9747b0cff
X-MS-TrafficTypeDiagnostic: PH0PR10MB4551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4551C3E6DBC3977012C2205F8ED69@PH0PR10MB4551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vNk78HNPO+7LOyAwqFIDOWAsNwmFD5DmbZzTdzC12HcgcL1oCs8dcqXZNkj7GzfRpOvkJEliYVXiNf+1cHUmX4Pk6u278hOBdmf9roHgjHmXMa13s1fpMSCfBr+MScUoZHBFrG1fqXfetQ0xjNrXEquNT6nTbcb4M1s2KzyGmy08mw6/+p4+S31cwfjd9TCrL2FRxCmz4amw2NFcel5p9jAkEfRrs8mXdV+wsSn5DVlv+bEKTI4cANfw0t83W9/zpKFoV2XygDSivNfRcXTIWA3MBWn5/Z6eOD/Oy7ezpxDZRg9xdgCSZQRERBwa8QAnQVJodkOwJriePyXjPIfUNhuJwFvsXVJot3hQAP8fdqpUc/6OE2TUzXHnddzB4RIH9EZII16WEBz/K89LsaRoC0M2OCmnM0cD7HIe4aHNyCyMZROixP3sF5SenDX/zMsoVIY1om1dI5ldhmlyImaO6GXRbby387DM0W1bU35lhwf5yVkrFyIjWQwtJqS8ImwphTwYkIDPnhrnjNbp9zmobD7QCBeIHZtWZKgbecCNl2KKNTy+g2zT4Yy9YsOTTRyrK9jya88ypnd0w6LQHdYn9Qgn2lRJ4GID2YP377s8TEVG1UBh2T/sMCVBS51RWXKJxxdJMUtUKY23hiR8DEgW3L03a91cmvt7ya8qbv4P+p6ZLPdrIp/UTHeFFoTzNi+r7RnUFFc5QEnoEtAmCii/Vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(39860400002)(346002)(55016002)(6916009)(7696005)(52116002)(186003)(5660300002)(956004)(4326008)(36916002)(38100700002)(38350700002)(558084003)(66946007)(66556008)(66476007)(316002)(2906002)(478600001)(86362001)(26005)(7416002)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0DQ0Xf0Dhy162pvVGubHMicvCyb9leCIJAWu89KI7EEZDe+eMh3Y1xo2AFi9?=
 =?us-ascii?Q?mwh5jnN126F/N2MKlkHNZhvYONtlYpWO9goSnjhuWKQyogl3v8Zp89fFLCBv?=
 =?us-ascii?Q?rnAPtprki8dzilwY4q1qRT1jYktyEnuFgNQaidPC08Nllac8cGNRG4Z+Ct9g?=
 =?us-ascii?Q?KhLJe6B2Z23lR37vEhL5PrUTJoEhwSdNaoIobIrjYC1QSky+cBZPLzMfM/N7?=
 =?us-ascii?Q?p758yRbJmgKxdsvROa7B4sYYzljyFqjtVnwD5iKtF0nIIw39gDLLUMlIDrl+?=
 =?us-ascii?Q?9vckGH5mAioxJ8KGoVFAqNjER9RwjobYYZikvZ1jOS3Z9jf3DHErh75Pjan6?=
 =?us-ascii?Q?NBEilyIR0r/QhAnc7vzzgvoOyTpczIVHXX6NOLJB4eerP8FW9W56Ke0HUHUj?=
 =?us-ascii?Q?s42tQMgWouR9y/yMlNzMcG9uI/NmmXaArNEQfuvMKVox2xHfiCTRRQfDxIut?=
 =?us-ascii?Q?Cvl9zHYONhl8mUooLndMuLdOO96h5Mm3/m9kMwLSSE/hVCm/I47eTBhoDrSx?=
 =?us-ascii?Q?hD2lL6+/OoYgNzHyfRfcjOqOdSVLw80mjK9AQnJhxV8pFhj6VXYFDWUj/Nlo?=
 =?us-ascii?Q?o5YF6fiYAryZdDBcXAGnu2/hWw+PtqW/aFUvX8er4pgYIf8DpPmIBH56ko6q?=
 =?us-ascii?Q?2BHrS/+/4GPojQ05hZuA3PgunobRQYm34Wz4Km9Kof7AC7JrZnM7W/U3jz/6?=
 =?us-ascii?Q?2buCPqqHEYtTQn/IbKOmEb3y/O5b27a+Rs2PSTe192yusxMuF0iIJ1RCtWp0?=
 =?us-ascii?Q?OJ8yF8cUUiFgKRut/duiGSeW4fVTrlXIkeRShfLxb/o2CT7Wy5R/+m+5JDJO?=
 =?us-ascii?Q?lBZRRiY/NdrKSQ1LpRBf9HsRYePfS1GxlmnW/itEaBwHhF0vRkIrutO+bOdZ?=
 =?us-ascii?Q?C4oqjCcz8ZWZNpbkF7Of+MJzzLzcMrBHGUD9b7kTTLdsmHI5mglwyMX7wB0O?=
 =?us-ascii?Q?JjzHZ0H+CPgg9BAZRxLi4z3a0XJW0ZHXKqSqi4V/8lgRMSP5GkhSRx9HTJRF?=
 =?us-ascii?Q?zxK27ey5HdxeT3nB5fCQ6vZgK4JzGI5WdjV96HGpHzohpkewwUPQ9FnStauQ?=
 =?us-ascii?Q?2ct6fwA5znzgL2FBX1K7FSAbUKJjXTP9tWYOfnTrcRZpPyWgffUrPiJOkWAb?=
 =?us-ascii?Q?J6o/Q7r9VRYPTfnBWGhsisrl4a4uwT8P/py0m/YUhNT/z8wvC1A8p7+Ce+ZB?=
 =?us-ascii?Q?Y8zs++Tat2wSlIIjy/4ZK6qd5udZDy36McxkCZbA5hv2eSjom3LYsqooijaz?=
 =?us-ascii?Q?+nLGnPMXpNTDN9r4ehESronyZpIBHWylRrVe/PlV+nuvosiO8/tTwxk9SgCt?=
 =?us-ascii?Q?PFQCtLPF1e9BdPcyIgpcUyl0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9799f8b3-1a68-447b-4eba-08d9747b0cff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:50:09.9295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4PBFLGpLrAfTC7cbRGqujLTXb18OexMEK+YhxQewS4ucmMvR5AEHvrBkEQiZTEpWFopgw2GL3hDGegGNfH+5Ty4kjpYrvPf3vXQnSGgnZQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10103 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=847 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109100098
X-Proofpoint-GUID: kjYQ2arHO3ko0jwrG0tiNoTbPxiol7Vl
X-Proofpoint-ORIG-GUID: kjYQ2arHO3ko0jwrG0tiNoTbPxiol7Vl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Johan,

> Martin, can this still be dropped from the scsi tree or does it need to
> be fixed incrementally?

I dropped it.

Zenghui: Please fix.

-- 
Martin K. Petersen	Oracle Linux Engineering
