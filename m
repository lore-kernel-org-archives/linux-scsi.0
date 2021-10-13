Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C8AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 02:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95B8860041
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 02:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbhJMCfQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 22:35:16 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47328 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233316AbhJMCfO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 22:35:14 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D0Y8wo023376;
        Wed, 13 Oct 2021 02:33:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=f/rIyUHkPfrKoyCPl5AJvUwKlsVOLSMVSKgSldZBkIY=;
 b=Hvqb/vW2BXCdCjrUfS0rMRo8HW/bIe8cECbs/HRrsGJfuQB5c0qw0yhPrQgbZQt3rNM4
 8W6lK8JQieZq7VRvy1wBVN/EgCIRogO8s+TzVjoIiwLdqz3z29BeEHQ/4j6IDA/QcAYV
 9wZSJW7Ik204htkE2CtAyepG/wrWTQ3VnwVfxEs0Fi3jzpQt/LDnqTAGlikueGEKsD80
 MYjh2wddBnaQ/U1ZMF2ueMFBVqqZeq/xog6a6yV687MGPvfpiYSN2tWCzD8WzvPnGxH+
 fNUZ2VjcO61CUG7BaGexCL6w6swHJXMY32B26L9RnZwlw/CkUGW7XvXOvWyzqQEmN3EX +w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bnkbj0um3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 02:33:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19D2UlGt170341;
        Wed, 13 Oct 2021 02:33:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by aserp3020.oracle.com with ESMTP id 3bmae01jk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 02:33:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hymdleALPikqhHabhw5ttCJz+XvfOaeFuifCRyydEH6mSU1kj4skCGh5r/gxq/HjmdMvtoeXflFlsHFui00doZljD3Og7T8Z7lGYXFMbYRNKXctdRTsow4l7sDMeQ+q+n/DnMPmlCoXJmSxtqjfbLkMutBZXFbyZpcIdvXtGWvtI0KzYcg7Rm9gHx8VCmZjMSfluk4/eVtsJq8S4RpkWdLc6VKhwTsQsgKvH6GqSsWS5H/1yJq+Ziv9GiM5fRiduNf69PVI3ncYmy8a0+fPqHd5+GUOJmiZSpmOawcGjfpN2vBUXyIoieSRG4zFiM6w3iyWfr4n9Q3x5cWV0L0/Agw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/rIyUHkPfrKoyCPl5AJvUwKlsVOLSMVSKgSldZBkIY=;
 b=iYDWTMMimgK9DTqk4Knrx7lfa07FtA9MdKrgBRHiNgOZuCnKijMuZBJ8+FqcxcDJafKhl8kKA3jgQlP2QpRBbQ6Vke3/k5uLTv8FCn6rV+0GGbaXK2H8k0jaSlccYB3JryYMClhzcSRq6vR7TSCFFxZgGg8TV6XC0Z8dpn/Sp0VZzhv+l/KyhwthxChTLu1nvVwkKjGU5yi7Uk4l3yGwp1+IWo8rymGQ9Y29Vyc/o45yHdf4SZFN4zoGIMMvva9WVGiljqE9ay+LX8fd6FLFccpDxbtOrm/R1WZbNTez20kQaM3h921hpdYGD7P+Lz5gkxCzqo74Ib4vT7IH8WCrgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/rIyUHkPfrKoyCPl5AJvUwKlsVOLSMVSKgSldZBkIY=;
 b=LDCWq3Bb53NRjYqsMWkx35u50BgmXEm6XLaQGg9cHVK9tUAy+UjZV0CrL8It1zMgehPSu2/1aTdr1wDHgO39QwZQQVMmvDIydkL5yyfHivcZGFuLXq+YsEg9TaVx3VURpURTgzcRu8SuqmJ+Pp0yBS8o7OGiY4nhd6groyQavfg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1422.namprd10.prod.outlook.com (2603:10b6:300:22::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 13 Oct
 2021 02:33:03 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7c3a:acce:d3fc:a654]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7c3a:acce:d3fc:a654%6]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 02:33:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH V4] scsi: core: put LLD module refcnt after SCSI device is released
Date:   Tue, 12 Oct 2021 22:32:59 -0400
Message-Id: <163409236447.9881.10570604238338655540.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008050118.1440686-1-ming.lei@redhat.com>
References: <20211008050118.1440686-1-ming.lei@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::27) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:33b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.10 via Frontend Transport; Wed, 13 Oct 2021 02:33:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7581388e-3d5b-46ea-42b5-08d98df1c80c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB142269D5424FBC9F945796748EB79@MWHPR10MB1422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YpNClnaGHCrXRNiMp9SGU3y37xBztM3KK4Lv7Y2feYAvQ6HXLj7l04wd0s+7AMqlaJPJ6c6XTftcMbXMhnF7FGYTIi/XYwiUED4/mUpEWeU+qHbA7b6VO4qvdAR8cloGcqbeLkZ/aRzgjUbdHq1nLTKXhdfM0jyFr+ibWOeYMTvDEEEQ6WSaZMdTtrxUBMjwlmps5fTMivka5qii1yPRZX9/Hfx9yMGvbfQdlo4O7L8c1fk23bRRI47kJGwLPn1xXIiu/D9d/Jj5B5TvTqrZE3nrsh5IRveLM23Ca7C03wUckIanoqRuQJ0FiTC0aEqD8hAJ8odgaW9c45jfsXPHxiTIW8NpwPwNzWvFM0L4H/LU5vHOA5bz+LNDcyc4AB25k93lpR7Wue78AuePrYKcFr/x6whb57JIL2seQ6ticKmrUf0DRrAEcOzIc/6OVmG6p7CgizC6Mio9e+H5OfHxs60X7p22TeqRr74QKv+JwSaUB0umyZzGCF/aAfDqoKcE/X7kw8Vwp3eXBDMpBOXlaemDNn+16rAc5jLErvcRfXtVfdnSjwxdJuS63aFk6czqgUKZXswy2FArUlEfmqAUi0H9MNWTBQ2e0RkeUb7XKj/2ghUl02JqVtqS6CFhIYMHste+JFA7gq7rJCim1sotIrM51rrxkP8SDApPJJICyWqr7rmb2c2qMEAe2423aV9KxuRw72G5uJSYd5mmja2Kf//YYZ93a2U/Go55gaStPOWe4hgOub8vHZHd7QBDChGmWe51Y5OUn0bNXhyQRY7A2F7bmHiUciYidSNzFqGiKxk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(38350700002)(6916009)(52116002)(7696005)(186003)(966005)(66556008)(38100700002)(54906003)(26005)(4744005)(316002)(36756003)(8676002)(86362001)(66476007)(103116003)(6486002)(4326008)(6666004)(2616005)(508600001)(5660300002)(66946007)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXgyYS9YWHowN1RhN3ZwR04yQkV4MnkzOHFEYVVRRm1ZYTk0NUIyQ2Z1ZTZv?=
 =?utf-8?B?VjJpemxxa25jMVoxWlA2anVtaHV3MUEyaHFTclJtb1dacGQ2TlBpMm9WSW5C?=
 =?utf-8?B?Z2oxTlYyeGo3SjYvTFpFTU5mbWFmWVhEOGpBMW5WTW9lZGpmbS9vLzFPb3Z5?=
 =?utf-8?B?U0ZDdlJmaWRWTnNZUG54WVh6U0FaQTdPYWFaRDVjL05tVG0rR0c5cFZUK2dl?=
 =?utf-8?B?aXRCV2ZjZHpPNjFOMUY5MGJ4QlhvSVBiUFFBUGhRYzRSa0F2VENRNlZFSWZT?=
 =?utf-8?B?dWZCQUoycWxod2ZXeStvV1BSQzJFRVpOcWIrTXozRWhYTUU2TzNSM2pBT3Ux?=
 =?utf-8?B?UjZuTFVZeGNpQ25icXNFSk14UGYrOVA0VlltMkhPT04veTFhaXFWTWdKRmVy?=
 =?utf-8?B?QUVpck9hWk1jcFdaL01Wa2lmbFgrcURIcHdOamxmTzFhUmpnYldyeXdlQWRF?=
 =?utf-8?B?Q1FIRjV3Z1lkbXdjRlc1K25PSG1MTVdQbk5JbUxMVVZrenFTMVd0ajdpaERK?=
 =?utf-8?B?UWh0cjdQMFgwNXk0b1RPOWlHN3JVcnNyK0hNWWd6M29IM1NXdzJBOGxVa2dQ?=
 =?utf-8?B?ckFYa3lsOGdGTUMrOVZyOUdYSDgvYm9hNGtOSXM4QTQ1aFg2ODZHSHczWTdP?=
 =?utf-8?B?dmpFUHRZa3FPRFpQRXN3UlNJSXVFOUNRQU9wd2xLZUVTMDBpejU2OFlDMW42?=
 =?utf-8?B?Z05taERqK05INFIvcUNiaU1OUXk1Qm5Wd20xd0hCNWlZV2Q1SzZLYTBBbUtJ?=
 =?utf-8?B?cVUxOXRndDlNQmFONWJvNzRHcGw4RkV2YzRJL0pTN0ZmVHcycjIvYi8xV3JP?=
 =?utf-8?B?bUxZTC83Nk13SGFkTjZBNGVkNTQrcnJPR2t5R083aW1kemJBMlZIMmh1UGtS?=
 =?utf-8?B?Q1V5bEVpdmVNOEkvSHFXM0hIVjhxVXArdWExeW9ZYVliZ0xjcGVUcUVQY1NZ?=
 =?utf-8?B?NTNKeHhvRmxqb0p0dE5ZYk1oTzJxdC8xbitJeU1RYWtiQ2ZHTTk3V250TDRT?=
 =?utf-8?B?N3ZuUTkzUjVmdXpuSXd2SlZxeGR4VlM0UkJoLy83WGo1YThDZVpUZU11cFp6?=
 =?utf-8?B?L2JrZ205R1VickVkWEZvcWhKZXpnUnZWQWEwdk1QNzNYK0h2ajZrTkVKbE0y?=
 =?utf-8?B?K3lxbnVLTlBnS05XR1RPdWxjeW5hMVRCTHU0aklGT3l5RW80L0VsZnh4YnFn?=
 =?utf-8?B?RWpNdTViMzMrS0VrUHNueDI3WUVENnhkeTRMZlBaTm11ZUhNRjM4bWthVXQw?=
 =?utf-8?B?dHRjb1o0MTgwZlJoVFJZYTErL1Y2RTBmc1pFc1k0UGNGaitLMkRjcW9ZTW01?=
 =?utf-8?B?aEJVdUhaZW1raHpTV29nWnE1U3lqOHhSOGdNNEFBenRBQjlsbUpxR29talNJ?=
 =?utf-8?B?Sll6cVUwQldUSkZxMnlpeWFuM2xLcGdUdVhnVXppVDB6YUt0eFVwSktzR0Q0?=
 =?utf-8?B?R2FDZHFLaUxuTTFZWHFrQWpOSEloVFFBTnBhL0RveitvbnhTUjJEMWprVmhK?=
 =?utf-8?B?dlVwS0tpdnVOa285VWZVK1BXVHRVUXAxTUJ4NzZIeVAwY1l6UTlJMzM1RWdq?=
 =?utf-8?B?QkFXVHRqRVZKZDlRcmNEZzVtQkd4bG1pUHdNLzhwZVpCN2RWbWpiTE5nLy9m?=
 =?utf-8?B?N1lNZWJuUEVCd2NwVkNBME1kOWYydVJTdHJ6NUl5VmtFWEJMTFNtZmVYbnFv?=
 =?utf-8?B?UExQQ3lkcUlVT0dIYlBsMEk0L0xnWHFtYjFoRlJ1SmR6U1dqd2k2cmVEelRH?=
 =?utf-8?Q?efMH+znL2bul35kvbxtRbPF6tHC5JYur6ZzSUYQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7581388e-3d5b-46ea-42b5-08d98df1c80c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 02:33:03.4369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ZIC16Cqdmgh9pRXrBhDrTHQO+lPN0GDFLk0zuwrPl3RoxChKAWg5gpcN2edvJP0nCzMHsq7BvTZzStHUQjXHdi1cX6XYktnLqzeKySwbH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110130013
X-Proofpoint-ORIG-GUID: nLnuYGpSmF5AcyUG_e1j4UxzNX0WFlgv
X-Proofpoint-GUID: nLnuYGpSmF5AcyUG_e1j4UxzNX0WFlgv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 8 Oct 2021 13:01:18 +0800, Ming Lei wrote:

> SCSI host release is triggered when SCSI device is freed, and we have to
> make sure that LLD module won't be unloaded before SCSI host instance is
> released because shost->hostt is required in host release handler.
> 
> So make sure to put LLD module refcnt after SCSI device is released.
> 
> Fix one kernel panic of 'BUG: unable to handle page fault for address'
> reported by Changhui and Yi.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: core: put LLD module refcnt after SCSI device is released
      https://git.kernel.org/mkp/scsi/c/f2b85040acec

-- 
Martin K. Petersen	Oracle Linux Engineering
