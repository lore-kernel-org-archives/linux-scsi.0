Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B68DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1DBC2070A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbhA0FiE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:38:04 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36150 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238694AbhA0Ez2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:55:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4jWEU092862;
        Wed, 27 Jan 2021 04:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=q2TxCmoKX3J0R/Z1fYWe88jiVC4Z+XMwuoArc3TgOFU=;
 b=D7j77vIx7t9ptdw+eohnVN6pgpEN4XgBJjC8kdSDKOcVpybp45OMcvIXdxlpbuepzSst
 PFkVVETpcrKfsbTuWW1sXYF+FWCb+Ms+Vr+ywjwBXx7LYFCLeHNsBUicZwKjcQLKJcsQ
 mMn9OVS9SX27LmqXZXK27JHoS9dsNvxGG1Bii4oIRcPT2S6OtmfgH1Ff0iWa3puyKBPP
 6XwEK0psc/ARtaUd03Inq0DEBs6ZH95+qMzVC+2nnxcnlxvy7Yr1J1K2u9lbu27+YxcD
 CNMOt0WfwLtjn0aPaDxm3+NEL2xXBybmO+k5yKXytO1zR+Gs1VNnapU2JeiJPuUrMe5b xQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689aanbas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4p6mE188943;
        Wed, 27 Jan 2021 04:54:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by aserp3030.oracle.com with ESMTP id 368wcnsk28-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6ubbtcUKxWyfaF7aA82Q59wiwR9ejK0mhfVGSEtBeLytpTWwzvGvT7wGys+5FJ1Tatn07XHA4q3E4cYrwvrU7G936qElrv85SMSTqqRym5gXRl30dN9IyELZ3yGmhJvbjia+OeFahyRA8GCadh2teJTZAj/10r1bmzZTiFlPv+mEGX0NxyLd9ibSjYjv5unup4MKIryqvfLHrDfeC7xayzpZXEp+b1dUz8DzRlNA9gId9bcM8WYCtPvevJ6s8B+/u+Uikv2K0lopg1bACo2Kmby0cAtu9LroST3ktzo6i1IbAeyG/Yid8dIj3RaRZ9jIcyjQbuuXLW1S2cXPR/7nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2TxCmoKX3J0R/Z1fYWe88jiVC4Z+XMwuoArc3TgOFU=;
 b=HDzHmdQ5Yr2jkmF7RoHi7SvlE/YCYNT6w173KeWEM1uwyDRlV19jYWkxJQDL70Gay6xtuJUQw7YehCRe8oTUNBOqAJXnm2cIxWRuToLpLk+EYFcXu8MmADa0TjiAHDDGAobHW4GC/NhRZOKu8ZkSNepd4jtj3z3ZXaqgy/QOYN3UI8AwS7T9Vev9Ugs3zOPppsLuyjVIqvAoXv72EZNhOhN/3pEheHqdPae8NpYeRa1iKPWQrzPc07+qyy1MWSue/pu8Jqo5lpamCGOV2G8474ZeBi0Me8U1KDOchO9SXf+kiM/PkI5T+bbW+ZhYunmnmi+T9VqRwVfE1bj29ow2TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2TxCmoKX3J0R/Z1fYWe88jiVC4Z+XMwuoArc3TgOFU=;
 b=D4XmZ5lJcbwQlv4oF/Vwr0nEu/lgBQpCoFDDqHO6yvyQ4OJk7MxRfQhs3lIUDS2j4LEr2/cVad1S3Jma9Kra/gMJeElZv9Y7IB5FRzc75a625pzggMWeJAeBG2HZ1YjlR7WshRthTx3wP0A/L7TVRDf+r0+lRMUgLhuTkfagfTk=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 04:54:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:54:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Yang Li <abaci-bugfix@linux.alibaba.com>, martin.petersen@oracle.c
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, mrangankar@marvell.com,
        linux-scsi@vger.kernel.org, njavali@marvell.com
Subject: Re: [PATCH 1/2] scsi: qla2xxx: remove redundant NULL check
Date:   Tue, 26 Jan 2021 23:54:18 -0500
Message-Id: <161172309265.28139.5732518203779526266.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1611306174-92627-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1611306174-92627-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:54:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b4c5fa2-1607-4fac-9271-08d8c27fa432
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4584F445F2A0D74430CE40948EBB9@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yeTkv8qjnw8CXe8waN5+RUkDLfsVeUaPHNdp0DDD+HE4Bp+ZS724JtDmV8Rpsu231LJEQ/OfSYC6N+DFjjTVNVWPjZSrdtsXmJyNFqo+UKqdeiRFuT7ik+gSoupq9p8BEJruQKJb0Y3NfnC8izId3w6gx7s4siPPBBRdGpRym8UOGUysoAvRYgvXdHPXjeiWHqbGG03/0Grb5Iay68MIYBN9SdFRlIw9VGo7PTg4jYz1ryNtKxYWWO1WFLttyjXndbjmt2du+9+PcYqEsF5mw2Y6Kr+mMc23G2o7w02MkVEX7c+GHdEas9nyic9ibo6iV5wERMHi+tiOeeF/fcS8U07NSZ1plwVZjRpd+YauU9DUApEb1B1+tocG0a9yEUcz/6fMSTFNEMz5FNX9IRObnrb+iR4wR2or1KhULNq/BOjUzatipyvhU5dJpVUFS6MKd61kV6RnykGqd4P4CLE9nQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8676002)(66946007)(103116003)(6666004)(16526019)(4744005)(26005)(86362001)(186003)(36756003)(83380400001)(2906002)(2616005)(8936002)(5660300002)(4326008)(66556008)(66476007)(52116002)(7696005)(478600001)(956004)(966005)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V1ZSd285R2cwU0h6SDlROXlkcmZ0SGNpZFMxUEY5RW9YT0FmYmpvZEJiS0pH?=
 =?utf-8?B?bVBXakRSSlMyUWp5Y0xQQTd5MTFqdnFPSEVVenhQYXhYRURGTWdwYkp2QTdw?=
 =?utf-8?B?clVCZWM0QVg5N1NDK3ZYcGp4QjN4YXJyTHNrRmZtdHE1NVJxM09lYXErcFZX?=
 =?utf-8?B?MmtNdDQ1b1lDeTBxQ1h1dXZZcSttNWQzSDYxQnlwRzZmUkYvN2VMcGgwcWtW?=
 =?utf-8?B?dXJXZEV5Q2g3WGZZRlFJeXpGVHhBd3pEWG5BdkdOK0t2bEtZMlJ6NktSU3VD?=
 =?utf-8?B?SWFQSkdBTDdDamZ5STRJUmE0bTRxbStHTUx0UzRKNFdxeXBzc1ZXSUxkbTNi?=
 =?utf-8?B?VWRlbnd6emsycGRGTHdjQVlvdS9BUGVMaG85SmwwNWdsclB1MEdtMzBnSzZ4?=
 =?utf-8?B?NkJEU1BoTmhBYS91TkVRRG5vTGZFaWdRQWVIYnV1SzZGZVJ1cHVKZjNPWU1r?=
 =?utf-8?B?YVp3aUZ2dUtKdFhPT3dVQ2Y4N3hXYU5LckI5cGNuNXUxOHo2Y2lVQ1hSQWFU?=
 =?utf-8?B?eXB3UE4yRDVySk9VUFUrRndzbTBNdlFTT2xkcWkwdmxDY0pKMWhvYXFScmJT?=
 =?utf-8?B?amRUZTRoL3lSRXJBK0xBMEFaUmZaRlltUXpoWExBb2k4Nk1hWnc2cTZQUFI4?=
 =?utf-8?B?aDhGOENsdUJPU1hLRnRBMk9Bc2ZiSkQzS1I1NEI3eUovN2d3YnlQZkhwV2Zm?=
 =?utf-8?B?K2w4c1M4ZWpPRzc2RVl0ci8weGpDdnlhTVBiNzZFS2w0ZzFLT1RvNVI4SXBl?=
 =?utf-8?B?UUZkZ0l0SXJoaUtkVmhUM2g1QWlwNjBvMk5LWnpaY3BXSStZdGJDZW5DdFpX?=
 =?utf-8?B?SG5JMXp2MEluM05wUnBOQjNDRXBqRnBPYVZaME5LODgzR0dDUFIyZkxvMmJ1?=
 =?utf-8?B?Z1VXTW9zajJJSldKLzcwODBYQ0huZjZobFlLZ29lU1RrRXp3cE4xZG9XL0dh?=
 =?utf-8?B?TDN3WjVkNU42SFlGVXAySm5CeGhrZXJnV2ZqZEEzRDZRQzhtSCs1bmRValhh?=
 =?utf-8?B?Ui9abzhRWGxObXFFUG1OQ2ZIMXp1eDJVL0pNUlBFQWc1UTFEOWRUenY0SzU0?=
 =?utf-8?B?ZGQ4cTltbWF5N0RPM0xzZ3lyMzFrWXJPZE16bVBRZjZHaFR5Z0tpak9Tb1Vo?=
 =?utf-8?B?ZWs2WWxhT2RMQTljeUdlWktDdG9aYjZNRklnY3FocWM2andKZTNBUGdTekEx?=
 =?utf-8?B?T1hteUU5bm5QaW5GNGo0enhPV0IwRTFnS3JJVXFZTWlqMy82bXR4NmVSVHRt?=
 =?utf-8?B?NGpka2gvSDBWUUQwK1dDd3dsV3pISUdDd0UxNEtYTm5saFJ4WDQ0eWZBN3dh?=
 =?utf-8?B?VXRCSGhkb2pDYWgwTlJhdXo2TWNjYmRsK09aSnZEenBucVRxOFZmV2xSUGha?=
 =?utf-8?B?d3E4RUhzSWFSZEhoRmhHYnZmQ1dOZmxnTXU2UHhta2w3Sy9TUkc3MjAwaTBW?=
 =?utf-8?Q?RpVFtnuP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b4c5fa2-1607-4fac-9271-08d8c27fa432
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:54:34.6508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: riPVkOjue2MlVZX/LrGlRbKlYbTbCINETRUl05GcuoFdCYuLZC7TtFGYoY7tdONj15stmZFLZbjXXvO9zxByGzYE9lFIyiJ+krRaJc1lJ14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 22 Jan 2021 17:02:53 +0800, Yang Li wrote:

> Fix below warnings reported by coccicheck:
> ./drivers/scsi/qla2xxx/qla_init.c:3371:2-7: WARNING: NULL check before
> some freeing functions is not needed.
> ./drivers/scsi/qla2xxx/qla_init.c:7855:5-10: WARNING: NULL check before
> some freeing functions is not needed.
> ./drivers/scsi/qla2xxx/qla_init.c:7916:2-7: WARNING: NULL check before
> some freeing functions is not needed.
> ./drivers/scsi/qla2xxx/qla_init.c:8113:4-18: WARNING: NULL check before
> some freeing functions is not needed.
> ./drivers/scsi/qla2xxx/qla_init.c:8174:2-7: WARNING: NULL check before
> some freeing functions is not needed.

Applied to 5.12/scsi-queue, thanks!

[1/2] scsi: qla2xxx: remove redundant NULL check
      https://git.kernel.org/mkp/scsi/c/18c05faf8ab1

-- 
Martin K. Petersen	Oracle Linux Engineering
