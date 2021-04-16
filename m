Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED1EC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81528610FB
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbhDPCsf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:48:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37464 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbhDPCsf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:48:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2iuDa044259;
        Fri, 16 Apr 2021 02:48:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=b7IMOJpq+Yddi8mZnnX/jU4siuBldzSzZiGsktuZBE0=;
 b=seOyRf+RMz5MkUP+8Ay0YZvAGucrXyo5EggxPcNEflxy3/+rXKoHm0NTKkvQcUI4eGbK
 MlZ00kx+33haRjq1WAyudS35EDtuPvjgWB5s001f1tmnF9QWj31hyCygQoxhNb4iPXQj
 HcfnoK64r3AGRRdFepTN++IkWESFqa9SVT0xRgeQyRix9R5ZzWz0k5vGVe98EHDC8RTU
 Y/i98Z/CwmqGUOcqsJQspq2mJLVkJhBpeUR+aYEsd/zd3Onypz4aqoTqq9/pznMtMF3f
 eT8YMENyNS1L+4wngEr1ZlfasfVYE+kAULbCFO8J1LIZJqFWMCMrb+eNmXhfPrzlLnAY wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37u3ymqpfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:48:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2kXU8145797;
        Fri, 16 Apr 2021 02:48:00 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by userp3030.oracle.com with ESMTP id 37uny1xaq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:48:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJ2aEn5KANeeq9HNdTVsBNkZRGnV+6tU31MDoQOOTG1jSgQhiPHzZgSpkQ57t5nKU0IvbdxmLIRMR8SKh2qe1RW+jDa/Ds5DcYIaRByLoYlcMLV1Z7mm4x0Gmtn4WWBVzfNxh28hqlMczseAIw24TdEsVyes20zEkvJnyun3B6I/kO04nw0Q2+fWyUzsLXHYPOtP/KD+WiEzTsDGsHZj3RcVuojc7AQC3PJqZ5smpJVWKVnK8mdyOQCgrzq+SAZ3FKWSNhMJLDNjEMjQpoyyCCDDfDVthdsJJULUuuRxQqpaah4UvvY/nXV/j2wIhSHlA4LNS/ada0fxoVcopkeolA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7IMOJpq+Yddi8mZnnX/jU4siuBldzSzZiGsktuZBE0=;
 b=ULlW7U770pqKTnc/AjZMiI+Re0Om/r5DrXv3WCIT2GHh6ORp/akevAdvPCWwNcmEGrhwDIeGoXHs6hylTAiR/UljwqcOR6suI7kk8UajpRMkEPNIpP5yd3irnL+rlLMIPY4PwaMg0fp893f/y3a2kTlEAHmyCgnRoNRfX9ynMJP6IGn8xra1bEvxLmmC+nb/3aGhy8XKb0J3xa7D0haPNmLF3QT9WbciZqJN1lzxZ9gcrslvgWyFQ2VfFvZHlocc/WT+NM1TUXbdZFPqWg+5XCalfbINmhVpS8PC2kRIJIHyi2h6fsv0HDhXPf8q6SF8J2DuhqaDQXT61bvLXqURsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7IMOJpq+Yddi8mZnnX/jU4siuBldzSzZiGsktuZBE0=;
 b=aXnGdHffMneM2iznXcIoQCj4tSDlc6lanWlBbPTJ/hA0MECvbO3xbvfug1EbcnBKk8T0tOWuH3tBKIyfR+kIPNdLpqI+fSZwFfPNkpaJYLLf8D6J1J7hEYOQ/fBuJEFnoelrmqlExNuyEYxiq16k8mv1UTvaRxtSo7aDOiK9zUk=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4710.namprd10.prod.outlook.com (2603:10b6:510:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:47:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:47:58 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 00/20] SCSI patches for kernel v5.13
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im4nymgf.fsf@ca-mkp.ca.oracle.com>
References: <20210415220826.29438-1-bvanassche@acm.org>
Date:   Thu, 15 Apr 2021 22:47:55 -0400
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 15 Apr 2021 15:08:06 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR10CA0019.namprd10.prod.outlook.com
 (2603:10b6:806:a7::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR10CA0019.namprd10.prod.outlook.com (2603:10b6:806:a7::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:47:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 563bfc82-07b6-41a9-feca-08d900820b31
X-MS-TrafficTypeDiagnostic: PH0PR10MB4710:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4710444D55B74BA8B557E9288E4C9@PH0PR10MB4710.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N6GucAlbYby8YRY57u9uBsLgyHkiVgIt9GZFIdB333x7Wy+KO5o6Jqn0oCpw7so0ny8cPHZXdjE4OtVsg585EyfkuC9UdPoFf3YxRw3Ln0kB1WZ0fCGT89BPYschoxetxzTJy/ACJV1mx6Q5tBpG/QoL0xZsowSCYD6glGfAUbo4u7Gsqrb/+uIDQ9Azz/0L/ACCQTK0hWBXhef0pmif/kvd6GvwVepZ/mHYTnIGvJx0X1Gdnt8SR9TPAdWjG8WFPOXLRBenGuRlgt3T6ZqMrwUb9L3YKRl4BHNMIuzcsM1ilV5DOu7NjEmgukbvZRMrdQVbVoQ+EbsGYizyLiUfOibSbTo6v/HL2v0KkChV5uYmh3ZCua4LqRPq9I8DDIfNnc6Oac2321VdYGzFfCsSHyOlrDZ7rkChyWjGHhE5fpPaTTouaxzSxK+SZQZTrvxLmJ7s11n4E7gMPJxjL50ycgvMXC7HGjX3h231TIXJkLjen7o/VulbieOyd3spRdTrMd7Zf04TlvJaYQCLVagv8Htll58Iqj5v0Xl8UyhemLJ+HXg8o0++UbHySaKyvHnC/8UxMkBWJAERXK0P6xTcp+fNbJuWZn7mHAcpixMkTRYSsDvVk7HYtwx3uvP9davBdbjSJmoSkouqQFTNTWkXCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(396003)(346002)(39860400002)(38100700002)(38350700002)(36916002)(86362001)(558084003)(7696005)(54906003)(2906002)(5660300002)(55016002)(52116002)(4326008)(66556008)(83380400001)(186003)(26005)(66946007)(956004)(66476007)(8676002)(8936002)(508600001)(6916009)(16526019)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?c2fnFn4Kr4+v3H/aNxjpmPBfYJwPmDz4R/+eLCsBivoo1wlDjpmMl5/QPgjj?=
 =?us-ascii?Q?WVBy6MHGhdGVFWZnhnE0DkMh5N6g8pufNFw7QU58rBGHQdb3KkkgPo7TC2Gf?=
 =?us-ascii?Q?3ZIKrcBmWdfAvoUyO3v1Nhf2fEuJt7QsJAGxIkz45CyK1qEWHD0XE6afZsla?=
 =?us-ascii?Q?UawkZJL+8y9FEV1MO1Mpuk65t4iwPsc9SmdtBnn/E2BGIGoZDMqOC9QXvzVV?=
 =?us-ascii?Q?vnKO/T2KGD1L301ObkVS8HitWQ6IoCE8g6BTq54cwJVHJGCT2vSuVLGAWAj3?=
 =?us-ascii?Q?DRuSOZC4OF5LTbrwd+RxNsML9V6lsjO+WhFuBG6WiwfscJZ4C1JztF/0Bs6p?=
 =?us-ascii?Q?yhGRko2DFzElx4poSIjuDTYBOuMLH2f6gYWf8GyWELSu++YV/qdcqyAWe6ET?=
 =?us-ascii?Q?bRaV3iGgfx8X9lQtQ+lif+nXLprcj3JOKKlaYKGhy/QgtxhMiCGQWgBLjeVj?=
 =?us-ascii?Q?Re0yq0CcqdSZ5IEACCsY+xOKmmDIqI3sIp+vwd0Rm1SzcX5ZdyNWaLr0iemw?=
 =?us-ascii?Q?+Dq0gUJH3qOIYXoUgS0e3EBk8mugp8E8sKmFcNwjTylkp7igxK+hSvt7rP93?=
 =?us-ascii?Q?pvuOpsEYb3ORNsT2eqET5UhlqQkxJd1p1Bv6JI34c86Zp6MSEkr9OweQmq9K?=
 =?us-ascii?Q?qPNrv18WCFNDUkNzcoclGU/I3BwxQlV7+8r2t/4181Yhmldj11Xmb2Z/Et2U?=
 =?us-ascii?Q?A1/R8Jaq8m8g/Bf688OHMncFL+OXZlneroAQNLvH3CrvrwA8F3Qa4NmTMBa2?=
 =?us-ascii?Q?CruBCaJmlknFZBRTDVV7wqGuRs2d8vvea2XdT2n/qRwRc/D2WdXVWbEldeQw?=
 =?us-ascii?Q?PajRIpCmIXUxZJfAJ13NgisCHMm4rMdLQv/F5eoN1ofjdeZLZzh/T7WjUB3t?=
 =?us-ascii?Q?1astcir8oVwaPVlzIFWFw45G/01c4Ub2AX2iqIS0lx2lz/Omcvv741cUv+tB?=
 =?us-ascii?Q?KVvSZpoNIOdKkgMaFJLjNRDMdWAd3JNM8JBLtsdEpwkhUsJbN2orGPfJMwUF?=
 =?us-ascii?Q?gJEHRa1JqfVaLtdGcUwCkCbyRxUEyVYInBtIQqKKOdbDIemQZ6wX/NCoZmdZ?=
 =?us-ascii?Q?0kNNlYabLmFizbaTtPlUHoyWP6NfuGvfWew14cYe8JRMKLAPHD6XzYnw2ieE?=
 =?us-ascii?Q?b2xuV4xqDKkzeJk0FFmeakhECRO+nXTLmPodEzxv631Kqbqt4/6GL4X0mJ5v?=
 =?us-ascii?Q?D2v5fGGwMygKoS/q0Q1mfDYmksdAl8xosQqeZrZ8P7pPbsgsmkbCgI0/Hb67?=
 =?us-ascii?Q?20jl82mgPT2GqIaitTrWX+3S7zjbHngL6LoQyghRPwqLe7Bul2XrNru3k1Ng?=
 =?us-ascii?Q?L0TkwFf+QViMZ3DRczq1Kb9v?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 563bfc82-07b6-41a9-feca-08d900820b31
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:47:58.4325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kiH2Ns00kY1ucuBxM9GYSvE0VKH4eGUi7uQ/+n1fRRQSIC1qjG/JbaYl5HHpT8VWmKHPoRhxNIEKCGPMjDeUy8V5hy9cIgP8+HG/6YO9p/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4710
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160021
X-Proofpoint-GUID: DRcklhhmxpriHiVVne3RdcPGjJAAlbkx
X-Proofpoint-ORIG-GUID: DRcklhhmxpriHiVVne3RdcPGjJAAlbkx
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series includes the following changes:
> - Modify several source code comments.
> - Rename scsi_softirq_done().
> - Introduce enum scsi_disposition.
> - Address CC=clang W=1 warnings.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
