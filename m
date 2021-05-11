Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCADC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC35361494
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhEKD1F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:27:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41664 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhEKD1A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 23:27:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3EXAi073578;
        Tue, 11 May 2021 03:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=G8JOhfijIOJHQcuAUbKO5iK17rSvEX8z/GVNbFA9YKc=;
 b=Z9UCvwHft2CZNBbnb4SGVIEosRM4jQaETFiLMQ5n5N9owqpnoGEcHlFRWZX6AKHES8Hf
 ynL5LolAGp6c5uNvJtGhw2mnL7swWcoTXwKZZQM7Bk0FCS6zLil3ihLZGR7HH/wswwZP
 9MLXc7McV2bXfMYxb/82ykiCNxnN24UrJMw5FheepYLH7j5A5IUPnB5QcZnfSnNI+8j8
 B1KV4XtR/ljLtvYilWtouj9YUlAOxvPX2z2a27M8dk8CodjqvLIhyTeWKlc6dDm+q6So
 9TrQPDvFtHHfn/wu3x7/8tGdTWs0NFy6asnMjGpCj0jDybb+BP15a3EfHbojiTUWmZZo 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38djkmd7ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3Fo0d103027;
        Tue, 11 May 2021 03:25:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3030.oracle.com with ESMTP id 38e5pwfpd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTu5Vr1ZDiH2NAsR1+JRFWfYZ7MFqpjuUYdfqY+tLrtj/9ltw821q8SCi/flUL4K1Lr9mekQE4l4TBYwJsNGrWZN0KqMd0aYsqCtroZ7aiKsKVk9BEWNh0GkaPczZB9vV5eFDJ//HznJKVXgLLt/uMyDE+XHhTg5N2KXIOqrs6GXkiLY6NS12UyNkOaxQDfEfeT0IuzqDjhrGsbrqx38ElVcWBLS499mFdy/E03N6fBqgArqLvZasNq15T3rCH8CMI5tg0zMzi9K+anT3QxBlfZz+yvGfjycyc+3be1s7XprPq1MBExhzTgCjPaKsdXXEJ2+eBKuYHPRELLG/4Q8MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8JOhfijIOJHQcuAUbKO5iK17rSvEX8z/GVNbFA9YKc=;
 b=Y9a3iDa899kpMPJkOZZey+HDcvG7+pifX/4TPtucUsRr/zhCtfQrYfR/aSIB0nvjHW3sdtyv07e3A6y5rLvniIPfnts314jSjMzFDnKc6EDx/oa3FVomftKAeNrO/RMWUOEtZBDYUwt/SY37TG/g9Ub29xgi+4fYZ9z9ZwWtfCabt8L1rJgZmRhPJRnnwpVgCpx3OkLDPB0V+TKPQVelQk6j7iHS2iQB2Myr4JiQ8IESpJN8ljcJ0zBC5xmI77FkFByDJYGu1fJkBk5FzSyN2D/td3Jh4pOzpKxAxg31f2xm+zki8u62m97LXWDvJ/HUMZ8ymXAfiVkyGTUhMiHX0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8JOhfijIOJHQcuAUbKO5iK17rSvEX8z/GVNbFA9YKc=;
 b=UwAq6twGYBYQCq9YvmYa9bNbNGwHyjWIs4Tkpf2WTZm7rpCF3kyxDiFrRreN6/7qPOM21RUvbwqk89GkSaQ8CbxJz1vtQde0Yl3HHSofycyC3l1wkjgJK4DgHwVp++/0nf3TxPq+jpHIH7xuh0MIHA8nigi8vmLtAvW1IQvb8BM=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 03:25:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 03:25:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Shixin Liu <liushixin2@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH -next] scsi: megaraid_sas: Use DEFINE_SPINLOCK() for spinlock
Date:   Mon, 10 May 2021 23:25:29 -0400
Message-Id: <162070348783.27567.1752194103384653343.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329094532.4165147-1-liushixin2@huawei.com>
References: <20210329094532.4165147-1-liushixin2@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 03:25:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ce8cce0-e132-4ed3-d7bb-08d9142c76c1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44087F10F559CD135F3EECA08E539@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b39K2Sk0vlCqiDL3FBp1zsu/w3rV54vocqL63JWOJH1XHVhw3UYhAPCIBf8p/sAJ9FOI48e0fC0kGmDMLmn5PI5BnVFekR48mHWEfKeK3n7DE9czPHSjYZc/pTQ2H1gDGUawB0aJnPMsedO4kEKzc20j7bNN4/bZbJCmhZSXuXDMY3ZmJJYeDffVV+gV0/jGNYUcIPSHYjqVuIxUTZ2j27cLhQeRBRZa0Ks2w5gBIVeplBl/XcnPnR0Y8jDhebHyLKj+V7L+VdgTiTHMqnQWyp02PRJRmW4fbp9Zd6xFV8OLZPPfQ5zEuOhRyH3FmA6k7dCYu9mZDpYToy90DoJwBNW//Dm+vrLzvdkSL/TGiJIPPDClATUIr0vfG4Ty+SokJuOV98NrwJLm+K6c6F0xjxUhR+De4wwz2ZkeMmA18FdxdtHBIIbM98c7VqeskxsuTk1eKTvWojpRlPO/wbKHYJHbm1joXSozr/YVZ4yEVxl6gKDjeNltfv8PQxTDCkDYvxtuE4IaAZ7RZClZX9G0KP8DklzcEgkifCq568AKW8LF9BtPm06kIpkG/K3++hfLTFTyz4ablu/nIrbz62LTdUgqQKJyHoalIp0nXVHEljdygfDlXujUFaH7uM8C+Ysd8hLbqmMpoJoznu9Sbs8kP0jra+PzvYZKvLnS1OEIHAXHyEHRIqbn9CQ1S+dFUmvvVTBX3A9RX56l+3+S/uUlj66p39QiOQtnSGABbh3WScU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(66556008)(6486002)(5660300002)(66476007)(16526019)(110136005)(2616005)(38350700002)(38100700002)(6666004)(478600001)(186003)(66946007)(36756003)(2906002)(4744005)(83380400001)(956004)(103116003)(26005)(4326008)(316002)(966005)(8936002)(8676002)(86362001)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NVR5TUY2bW4vVmxDTE9SWE5Jd2ttVGpPeGZ5dnlwaGpQaXV4RWV3SUZlcU40?=
 =?utf-8?B?K3ljbmpWdkc3OXREZndtTWNxSUNLemF5M1JaUWV3aU1mZUVFSGNaUkdOT3Q3?=
 =?utf-8?B?a2hYU1NMS2RuQTJEYys2QjlLYWd1MVBTRDV5alM5cDhlZ0RTMjFZejFUeHNH?=
 =?utf-8?B?Sm5sNjF2UFNZMXFacFUzYzFVWWI2bDBGcWJ3bGlCbVZBNENxMFk0S1FFRUtB?=
 =?utf-8?B?UEdHQndHdEdzMGFqcDVOQ1p2VmtVNk9GRmwxZ1c0YzZ5clg4NGtjOURTU0Fk?=
 =?utf-8?B?Y0g5OEdvQ3VsS3lYSnhyRVE3Z2diRE16YTdETk95WjZOTkdoQlY3TVZ1Y0RN?=
 =?utf-8?B?V2pHQm5yTFB4dkhweGowRXh0M0duRytxL205N3hUaE50a2NyWjFXWmNsejYv?=
 =?utf-8?B?WWQ1RzFSS0J1M0hCekVHMFloaGhnNzA3bWk0U1A2YnlTbjJXRmNxU1VKNWYr?=
 =?utf-8?B?UXd6Ykhpbi9lK3FRMWVWRUVtOTFxWGd3TmtGdWcwbWNIbytCajJOeEpJaGR6?=
 =?utf-8?B?R0tKRHUzbzAvcTZ3SDhKSHpNekZMRWVpMkF6VmRWUEVGZTYwZ1J5bVBOZkpX?=
 =?utf-8?B?TUlxQWFubGhnaFN5WE5DZTFYcy9pektDRGRTdWlaN1g2UUZESWo3SjJ1ek9p?=
 =?utf-8?B?aElYeE9oMUpESW5XaDZ6U25WZXN0OFp0eVE4WUpxSUU3Q0lzcHJjT2N2c1hV?=
 =?utf-8?B?R2Z4N1dzSmZTV2hIdlVuc0lrekJENlZKZ2U3SEYrVGNRWjF3VW94TUlGWTAz?=
 =?utf-8?B?RHhYZWo1QVJIdnJMY1laTlZ0a1U5MWxtS0tlVUJqa0xvZTR6Q0VQbXZnUXBJ?=
 =?utf-8?B?RkV0K0pPMlB5OXROQ1ovR1BqT2VrSll5TCtNMzBrWCtNdFBLSTBiSVpqKy9t?=
 =?utf-8?B?QitzZ21WRG5UejZVamt1dy9BVmdMMm9wa2NRSjJMTXdQY1orUUpPdURWeVhq?=
 =?utf-8?B?ckFJbXU1SzlYYW5yUlpyTk54bTM2ZTlLb0tVaHJKK2RDelk3TkdTVjVIdVBZ?=
 =?utf-8?B?dTB3Si95OXowdEY0b3Q5UkQrWHRlNEVDSFo1OXFaVFYyVWJYOCtGYWVkeFZ4?=
 =?utf-8?B?QjRFTU1iWXdyaTBicFNpdWVQQ3VXdkc5dVo3R1Rkb2pOVWZkaGhSejBjRXZN?=
 =?utf-8?B?T2dzMlRNNDB3azl1Ujc1RmlQVkFQellhV1E2SFZ2ZlhENTJDbnlNRkpvbFh5?=
 =?utf-8?B?cWtKWUxuWXdSa0M4a1NjY3UwQzhnSllzMHQ5WkJLcUpGNHROaFdVNTlwTk9B?=
 =?utf-8?B?THd4aDRFRlBHbU5COHJXcks2SDBveTd2YnBXRVRyK3hhMVhZV25XQndhVVhw?=
 =?utf-8?B?S0d2L0hxdDFDd014bitWaWdieTdDWmw5eHp6Ly91QlcxblcveXNRNTBqd2F5?=
 =?utf-8?B?RDcvVitieTRuMUNIL1QzR1VYMzN1MkFBYWRpalRyUGtzRjJOcFJYT3Bwdkx4?=
 =?utf-8?B?eS9WNjNSMTg3YWpJbUFxRVR5c0U2NEVmS3h3YzRRV0V4dE5qdU9HWnBBK0Q2?=
 =?utf-8?B?TW5FbXJXdmdkWXczSzFRMWJSVXNXL3d5MkFTZXdZeUZlUzVyN05PSmV1WDVE?=
 =?utf-8?B?Nkh6NlVLVG9DekpTVnVSTUMyN3Zzbjc3S2JhZ0dCalZuR0o1RGY5ODBFNHZ2?=
 =?utf-8?B?cll4a2RXb1ZFSDlDN3hDckZVLzNSZGx5d1FpbithVTltWVNTdTV4M2g5cVAr?=
 =?utf-8?B?T3RyNmpUQ1VVNlhKK2J4ZmY5c1cwVWxWbENyTnBXbWRmSlJ5d1VSMDhsbkw1?=
 =?utf-8?Q?dFwto1NLieLZ8qFspITKVUshVzA+8rNxDto1UUg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ce8cce0-e132-4ed3-d7bb-08d9142c76c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 03:25:45.4670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: krOAr6gpnb2vcaTZDKaaA48j9tv4ZSLkkExsmr0KIioPBfF2ZBDvXaZnGmZ5Ccp1/LlVIe51TjJQQz6sH09a9CpvGJXifliJK0Y7D8S0sxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
X-Proofpoint-GUID: V-bBSyh-if0PCUr8sHxUqLM5aEyTo3gC
X-Proofpoint-ORIG-GUID: V-bBSyh-if0PCUr8sHxUqLM5aEyTo3gC
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 29 Mar 2021 17:45:32 +0800, Shixin Liu wrote:

> spinlock can be initialized automatically with DEFINE_SPINLOCK()
> rather than explicitly calling spin_lock_init().

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: megaraid_sas: Use DEFINE_SPINLOCK() for spinlock
      https://git.kernel.org/mkp/scsi/c/311e87b70913

-- 
Martin K. Petersen	Oracle Linux Engineering
