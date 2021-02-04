Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD08C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 03:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5B4764F67
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 03:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbhBDDAH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 22:00:07 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35894 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbhBDDAC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 22:00:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1142t571113047;
        Thu, 4 Feb 2021 02:59:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=+YJQpuTPdESeIPEA9kq75+t1aViKEg5pNJ9YPOUlWLM=;
 b=QB6NLpOw4ukquawbeIATKfRrE6atHzR1WwG9bCWBWyWrcaRx69Mh7T1dNldRiWb2h4qy
 Doy1zjt1stDvbxlheWwAuR2OWLeaWBNjlaSThrRvESznWbIofN7c/kAcnnG56/6KYXOM
 1ITjlfQXbzBLuEoFrA8VYIKaYf73bSph4l4o9PrGbs81uieZ3tWDbbpnU7fbWYABQDuH
 c2i0ygwQDLF4l6lVAhRl/YfRxyQ/nT2WP8Mq/6//Tfa0uNtlO5Q7PcQE15Z0I2niSc7o
 0SlNGu05NndZ/c3PLB+HIfWNqgZFppfUXgp3L3LSpL2MxJuSJvcq/VCwBRifWjnheTUU 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36cxvr5wpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 02:59:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1142sdVg158931;
        Thu, 4 Feb 2021 02:59:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3030.oracle.com with ESMTP id 36dhd0pwgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 02:59:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1fcZaCSjhKxy45y+H4AHWqK9r9wpkNO2pMNNBfdjbzsiZdVdSU69VwBz4ovCr86QNzTcmD1zaxBrkwR9+nZUVZSJ/z4UOCR8zSnxIjsTyg1GtuHjwe75QAG4vmaaiA2bDFMcFMdlyXoCC/qVWE9htT5yzRcUT+qtmTOP2l1Y2HWnOjeKk5OtLJEXeYzQIadDzgtFP06P2Gen793coPAvE4KmNNahmXFknmcT+qYg/3QfvV8/vld1ybfWxUQwVUrs+9mbe8ptmWdR0Yzxrz/iCLP/LhkWooZjZgV4mgAPFRekAckSVXR7ooXqb9EM4AYjPASJhlF61HWmU+BaFCzPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YJQpuTPdESeIPEA9kq75+t1aViKEg5pNJ9YPOUlWLM=;
 b=hjsmZQ+mqck72AAywky9QT8m7MGo4sPHdZTkn0FwP2wBvdzk3ZqSj27t1bK2SQSwQD01fCdNAPRJBGdY/CtVExOPOxuxS9Gy6obHFmMmBiHQnol85+kF963wZS6CLepcEeiI/VlAc404vMqlaQWPF7sw27b5AqHjOtwUluIiFYkJ2hXFZvdZMC/G19BFKs1ul0eAFu8843/bpUY3AOskjS4eWq7gR76497I+QIIc0lECTS+PVneKysbaMl7AibJxklkKCyWYsCzLErjsI3pJm03KVUA9DcWN3EUvPR/nHoAikDlE5y22V2jazSMXW4kDHaQQfBC6FvVCL8RSA9GrFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YJQpuTPdESeIPEA9kq75+t1aViKEg5pNJ9YPOUlWLM=;
 b=msaMWZ+P11jrDiCbA7C0vnlTtIZ0F0a2kzqS1rAgYE6+foEEdTxaI5LP3y2Sd4qyD5mgV8zRglptTtwx3weBpvNEtr4xFG+yvLTPUBgMChwDxCk7BbHi1CJ+X56YSWrOmzH9RlW/FmR4KMkyU/SmRBxUVszVWT/Nfz1GuAd7Rc0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 4 Feb
 2021 02:59:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3825.020; Thu, 4 Feb 2021
 02:59:09 +0000
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V7 00/13] blk-mq/scsi: tracking device queue depth via
 sbitmap
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2g4v933.fsf@ca-mkp.ca.oracle.com>
References: <20210122023317.687987-1-ming.lei@redhat.com>
        <yq1a6sr1v87.fsf@ca-mkp.ca.oracle.com> <20210131115245.GA1979183@T590>
        <yq1im7bwiif.fsf@ca-mkp.ca.oracle.com> <20210203111402.GA1065845@T590>
Date:   Wed, 03 Feb 2021 21:59:05 -0500
In-Reply-To: <20210203111402.GA1065845@T590> (Ming Lei's message of "Wed, 3
        Feb 2021 19:14:02 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BN0PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:408:ee::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BN0PR04CA0022.namprd04.prod.outlook.com (2603:10b6:408:ee::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Thu, 4 Feb 2021 02:59:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 413600aa-6031-43de-7381-08d8c8b8d7f4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46154309DAF1AF0D8B4311998EB39@PH0PR10MB4615.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3jSjbv42ueaMZmzN2PPGVYX8XzAkyYtaMa/RDeSbUP+AbTFwLMWv1ffaTuBDdGFpmwuuqU9zPG4Rbskrx1CJaxvxHgrDzj006RPhS2DKeVTPUkChKiEbEhVo/xnjBZfrxCVEROAU+88dXcst+IZTgXByCQ5AJ+wew7GsKYE7dvPMVFYB7NgyEIfyKlkfKfCPSyL93vqGYe2Sq5BVZovcpA8r50Uw7kOOCQ6K2DicrjCZPIz+HHaazSuIazXeR1HPhqli2Bgzn/lNPIiy7P9EiUQzR+yZohBsyAZDQLzVWIiybC/pxEmobOCz8k4NjeBdY9q8w8R4jg0LLN6kYrZmuDHOQN59pDTSvh1pyVa8NyngYT9LodeNDx9nixktwy86WpXPHCwv/+5tztMvWIzutsqQVPce0inmDz53S0foYJp0JCIEwfYMH/wDg/54roFiT5S8h2uAVaTZWfNYCmNj6qRwYnlruPVSZvwn1kM2hjwPH7kNWwtsV2phx6cBoWrbiZHU4or+d44CSbfcwPGqKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(366004)(39860400002)(376002)(4326008)(54906003)(8676002)(52116002)(2906002)(7696005)(66946007)(316002)(86362001)(6916009)(6666004)(8936002)(36916002)(16526019)(478600001)(956004)(5660300002)(558084003)(26005)(66556008)(55016002)(66476007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CGZi7bKrQEPu2eN0LGr/ZxdHhXoWRARrjzbmJ9TZAUgUv7YqUbe3Wep392MZ?=
 =?us-ascii?Q?YKvhoQ14JB+Z1rqY7IpJHbruU3fuNc9vXSWGgrGCFn3K3OeLqcqjZUy526QA?=
 =?us-ascii?Q?DtqvJlw6nNhtNC90ScXBs/EiNNVIxUFb2b1ouVG5cgUEm2WZV7dQRTXcavc+?=
 =?us-ascii?Q?MiCICin6gFEPJeXkkF/RnENvfqcJmfizWctxhJvagGbZ77OFxp0rfcmeWt0r?=
 =?us-ascii?Q?VsRbvaUOPrK4MQGrmp03iZ1AEbU1h/Zz8XP8StheQh/7ibwpoPoy2GwcYDZT?=
 =?us-ascii?Q?QjG3pXBSZ3AVB8pym2m8ucd54yj5hVCY0wo8Pm9cVxLIVOpMyCrM+0Yd7qMz?=
 =?us-ascii?Q?Y3Y4XMOg0fN9SYPt9JDK1dHzmNe4rxyCeNZNACbbZR0Cy39u+lh4exBEHj19?=
 =?us-ascii?Q?gkdFhAYOfbbLpIS30fQ9KDE6bYJ5NxB05Ond4xzscyfcHd53qeT2IS1FPYUY?=
 =?us-ascii?Q?+5RhzVxL2B8c2+X7a+s5vp18UzrIWeNX90aFnxZi5R7SjJ7LlmyGKzttXUtV?=
 =?us-ascii?Q?PjdcxsLDnPtuuCDC45hMbqePjzKDbvjSsIkOLL7laVAPn6ksnVwmwzUBwixi?=
 =?us-ascii?Q?lK7B0n3E5ZOJgsytPRQ+3v2tHkUjmwqp3uxb9Gwnqs42y+gDRN4OlOtFOiUp?=
 =?us-ascii?Q?KqWHuH4X+j0NgxCVojIe56kDAQnIP4XZtCpeecb8hmBEpDI1fcwTxPRSlxuK?=
 =?us-ascii?Q?QlErEd+wzuZImU2nTE2L6c13IOFN5BKLPQs7pKweqhPk0eLbhU8d4dM1qzJS?=
 =?us-ascii?Q?PymXVkXST+wmxA2VnKv7VEyIJjsHkqM0rXWnuWJrGv7ZwLTebXh3DBcr+MaQ?=
 =?us-ascii?Q?rmd39ohz7TtIk3MJfxVmyaFDpOuazq8FOBn5ogaFQ0T45ztifEHpYtfvsgpM?=
 =?us-ascii?Q?tWTX/JPAndcQVpgVwWBhMO3JRfN5CdP0tSfZl28f+P6MPmcX7LbiPEs7Suf+?=
 =?us-ascii?Q?2nGV0gGVzk0ONZisoxOQA1BapqEBC4yvxRjsBp9C8sNWlW6489tcuC27Sy5Q?=
 =?us-ascii?Q?tKYriDBITBPqumiQdvla5Yz+LCGKGAp4Bi1vyOXoqJviswZh9A8z7mQJAjf1?=
 =?us-ascii?Q?5D659emsNB+F+OrKcVk352dk4pFaIbXj76yAqk4ngsuG3TYnAi+vIz1OKZQC?=
 =?us-ascii?Q?zbKg6jFRv0QBHrPVIS+BnNvCmJEIgRSzbQH6f8CDUJNK9LRd2FeYBJHYmRHR?=
 =?us-ascii?Q?WPivDFUdOt7ClKJlWIqivj0Sp0RsiQo0dHlOIvQhA80xVKK05uY7JL27eAEL?=
 =?us-ascii?Q?7ki64mX1qXXjJv5rOvxN4fzwOQzuTkwhUkseKSANyVHTcvWNwo5tL4BuZV+H?=
 =?us-ascii?Q?OYVmZH1QHc1Zl8GICfv++2Wt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 413600aa-6031-43de-7381-08d8c8b8d7f4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 02:59:09.6659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jg2t6s+OSOn5gIW1dx2sbjsmho6YkFutg5J9TBuLN8s9pGnvYrMmAMEuPeM66s+zJ20q/8DXh9vLI6HOZB5RobFJczJgT+s+LZQQJGKjqBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4615
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=966 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040018
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Ming,

> I think the following patch should fix the issue, care to give a test?

It appears to work my main system. Will try the rest of my test setup
tomorrow.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
