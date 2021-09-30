Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33EB5C43219
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 20:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 107B4613A6
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 20:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348294AbhI3Uuv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 16:50:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45814 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344464AbhI3Uuu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 16:50:50 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UJi1oe029885;
        Thu, 30 Sep 2021 20:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=cYxtp+mDaZLmCjLL+3wcHv7n/y1kDmFsUd+j7swUOVo=;
 b=aqv2ypPlsl+ppK+HOQfppGx7tN30DRwlctypkU20YJ9acRnFh00GYj0hUcWcbW9MJ7zo
 +viRzcBsjjstRzL8nUd7tnYAO00TbapnqaUafgyIMUvJQq5TtgIeP15IeY1K+qeHCmi/
 kgAGc4KTnr1utD4IqF7JGNwnQsmmJB6DKaiPTshh+Xqo/vnWDXW1BbhdK6Mk78YDukuJ
 zxfN2gCBoE4sjP8HjnbcrSuOLO6dL4gAxI2y0YbR9jwkayJ9t+2Q4q5S4hdpGqigZKZY
 ZTNnA2cRDIXRpFoieyymtvtzJxKfGyMk04jpIDzY2YAxry2NmDMFknZ0IFB4dw/7dPj3 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bdevvaevq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 20:47:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UKjE6e051941;
        Thu, 30 Sep 2021 20:46:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3030.oracle.com with ESMTP id 3bd5wbqa2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 20:46:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RvpjLVKrPw1peJJuRiy45vDY1RKN1JQdl5Z3E2IBVxwyAFDkyuRKyWz0+nS4c83iLc68wcf0xFqASCu0aPmzK6tsYApIVjjqemB0ElDvrO1HnR/Hz/QTbv82mfSHi6mIBIqgjiNMfY7u3zWroMWuBOUKk//7TH7P6Dy0+WzUMHGbfX28cQg5opNUWATkiTNcYfeRcH/GY3bjyWAQbwbwbqis8XXhHnchLPyA+UmS7iTUHQ1bTNSj+VNSAuB05vN8y+5kBfGEHuj2c4piDcYpA6KUeJ6WXfx3fUHXjj6zsllkU3WH+XGKJpYFhwyomy5DyEDAy+44Kxs3pjBDyUrhiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cYxtp+mDaZLmCjLL+3wcHv7n/y1kDmFsUd+j7swUOVo=;
 b=HFVlXzCU0W7wCJHGFGVo1JF9rSOUlF6XWQmll3MI2PiJQgo+Go///Knqs662RFc9co6sq9YoNn5jKuif8lLJxNpKo3uS+Q5omC5jUR4Wn7egjLfLoI4U7QtYb9q6+a0ZhwsIb5UHA/0uEOw3iTo8QYJWor7nxT0AhECwdBdH5Zy23nuANWhffHB3HxUDbIi0b0vkuDARnDRtQJuZHkyvudwoe4uN4jMPzAFAWDJAuhQXb3vPxGFzEX6k8QPHO4eSqJG6NRr0rhOFR7hrt0p4nEDwO560avOvMScfUC14sspUPQxrv8IU06vxkOUTIrTzIDENltkwdznIBRs3RGOODA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYxtp+mDaZLmCjLL+3wcHv7n/y1kDmFsUd+j7swUOVo=;
 b=r1QFokNFMuBxws6kKykJcUZSz8R+s6qjfgU0dlHroamUcBiS9sN5HCAFaa1FDLfaCZooOy+6XUD83mldndUMKU9wXd/ow7gQ3jO0WVahSCW3EWzRtcDsV3PavrFJrFHGsENrd8GElaik/LBNn42XhhAn05QG2X6TJTkYn+uMnEM=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4912.namprd10.prod.outlook.com (2603:10b6:5:3a1::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.15; Thu, 30 Sep 2021 20:46:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4544.023; Thu, 30 Sep 2021
 20:46:48 +0000
Subject: Re: [PATCH v5 0/7] target: make tpg/enable attribute
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210910084133.17956-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <97486c27-3332-5af6-6d07-065e987fe320@oracle.com>
Date:   Thu, 30 Sep 2021 15:46:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210910084133.17956-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:5:40::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM6PR03CA0018.namprd03.prod.outlook.com (2603:10b6:5:40::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Thu, 30 Sep 2021 20:46:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d46ca020-27bf-4c64-c97c-08d984536bc6
X-MS-TrafficTypeDiagnostic: DS7PR10MB4912:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB491267FAE9581989724C3DC5F1AA9@DS7PR10MB4912.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ooVfz53DHwVeVEJOcmJI670WIHXV0HKB9usLB6G8NQPlPC7+bQl5JoappDC2dbOtkwsW2ki6DfO3sXKN9ACuOyLg1pEMKu+fG2B8H8pUlyS2UInKmyKd/nYb2S6YCzg3K0Q3M/WNTsFe4J0Z3nn70xlkN/z14pwy4wFUmmLNq+TTxi05P4OGf+7iH7gFobStR1eRKPeCoqqmSJsSisZHYWuyjw9nZfaCYFL2pkV669fdzuMAL//P/4rAL9osRH7pq7CXZd2XMLGPy9bSPFwSki7n2VZPFjImZ/gqQlIhb4xv3i6oPg8snPnOfjOM7BhUioBWbpsNxiEgQaU/fyZZl+LVSuB1Pg4Zg0SpoFgEw9iEpFmvLfkJglgb4I5FlUt2THrZNATHYyg/D+TgH4C2hI6nv5tlsPrNmGa6M+mSVlKOoAoWqMf2/ELI5Fp7YOwN+xUGl4QwHYBcJakbxNfBEpXjGs/Kadi4RzZAhyQPwIGxTlSYMXBi0lmhTS7e1lzku0qtlYO8pEqJDpv2ya6+3SstvOtVsLJqi+sGxK2b5OKfFuusKINAvwnBVvqvtUyNpgSaOIi2VXJs6yVDYlO7aU79DamZ9JrxwH+QaKcDp+22+hcCBzU3GhEXX/CpNvBvRtftvR57GlWUMPEZtfXPuDzPPGU9G5RTv8eOM99I55MITzRa32msg6k52zDLzjjIdb1JXnzmqIqeWli7MRA5zMW62JekFA0oe0Q1X2zBrCBK+dcAgsNnNmJf3wY+n53EcJ82A++U1s2ulxfhIbHSkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(2906002)(36756003)(508600001)(38100700002)(6486002)(316002)(16576012)(31696002)(110136005)(54906003)(6706004)(31686004)(8676002)(53546011)(186003)(2616005)(956004)(26005)(86362001)(8936002)(66946007)(4744005)(5660300002)(66476007)(66556008)(4326008)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2NmK3dmeWcvZm1kYzZPU3NNSm51czREczNlM3daWE9jWWdZNWE2bGY2c0tY?=
 =?utf-8?B?c1ErUy9uVFFEMWw3TTF5QTNNbTRUSzF1M0loTEpPZjh4VDFoeFNmQ0t2L0s2?=
 =?utf-8?B?NUw1U1dyaHFTVDR0d2RiLzJJZU9XOGhVeWZMM0EvZXRXei9SMTY0YWhhWGlp?=
 =?utf-8?B?VUZVRGF2eXVjVDc5UHhVT3pDR0oyTjg2QVhBazFlL3MyeTYzRHM2dDRVM3pZ?=
 =?utf-8?B?cGtFYzhzZHBtZWVrOFhBWDZSSXM5YU03bW9rN1hXT1RQMGlFMkxTZm16eUx1?=
 =?utf-8?B?czJySDNQU0ZLZHlvMkc0T0NhM2xSMUdMMk02dld5QkNBdEtBZk5DNXdvaFJh?=
 =?utf-8?B?b2hYYWVGOEFqbjc3cEVBRVgxNTJMVHprL3RZZEdqcXVxcXVtdk1BZ0MycVZo?=
 =?utf-8?B?bU1ubG94QTRRQ2V4dUhZdmd0bEMyUW9ZdWlWWmQzRHMzT0QxUUxnTUNGWklO?=
 =?utf-8?B?TEtKQk9rN0xSdWRYR1VIV3NYUHJ1M1lYejV3M3EzeTlydjEreVdwR0g3cTN6?=
 =?utf-8?B?bGRZdWt5MzJmeWNER1lITG9Wdis4MXhVWlJaK2tLTTdRT2NsVmpwVmt1RHJm?=
 =?utf-8?B?aS9xVFVwN2RLY3RveUtsNXZWaTZya3gwMDV2RTBtdkFXU05Oam5QbjNXTXk4?=
 =?utf-8?B?NHRNbFF4MFdXVjFwbzRLaUt3NzBXRGNyRG04OUtSUmx2Y2hGNWVPRkYrYUp6?=
 =?utf-8?B?OTdkb2xVd3hNdEJNdm9kaXBrbnV5elNCRExobDdhcDhZNDRrekh0VDlLeTE4?=
 =?utf-8?B?Vm9HL1ZhUXBqUnhZMHd0Zi9yTHpTdmZPTE1LMVlYV2w4TVo0RUlNVHp4SHF6?=
 =?utf-8?B?dldySlRQTnhDL1RXY2E0dWZIWmNFYk5iOXR4VTlWYmN3QkErRXdoTVdNM2pm?=
 =?utf-8?B?NFlicDBvVndZTVZ6c1o2ejB1MXFYTFJtbkhxbmt4U21raGN2SnhVc2lRdFZn?=
 =?utf-8?B?WW1XTFp6bzh6cHMwcWFacVk4eUdGTTVvaXpadmJpWkNKSnUxRkZ4Mk1aOUJk?=
 =?utf-8?B?RFI4NkRhUjg0Z29GTTBtS0tMY2FFYUNZTk12Y1JaYzQyWHFtSThJeGxmNEpi?=
 =?utf-8?B?M0dnRGlpUUpMK0ZDQnlBeG11bnpISzNwdTRmZzF0cnpYeTJuZnFwNCtkeXFC?=
 =?utf-8?B?MVVJd241TGdsU0s2c3NqdXI5OWFXWUhlckNoYWkzVDhlUkt6WmFBNTNpR1lv?=
 =?utf-8?B?MkkzemwwemxnaTBwYzUzY3o4SWNMbkVLT1gwK21Vekh4Snd5akN6QXRWWVhU?=
 =?utf-8?B?R3djVCtkUmtvUWZJTVVwMzhrZ1I1UEVyQlNoMC9YeUg3citaMU1HR2hGV3pK?=
 =?utf-8?B?bzM1ODJ4NjQxdENCTHNkQUdYRWhXbEtoelBtQUhnWlNlTHl4ZEZvc1pUSXo0?=
 =?utf-8?B?TVhZMlZsSXZzQUt4djIyMEdTbmlSWUdvTlkvQnVqcmJmQXkrVFh0OC8veHUr?=
 =?utf-8?B?RFkxRGllVTNaOTFFR3JRTEg0MEFOZFMvTkxoQlMrQVFvU0pkK0IwbHpkRU1v?=
 =?utf-8?B?NlNRS0tIT3hwamdGRWhudUFIbWNvM0RYREM1VXkxRjNLNGFZOEZIMGpncDda?=
 =?utf-8?B?TXQ2M3h2MFF6Nlo5eHUyZFZXV0tJeXlhZllZRTdscGZxdXhWUUt5OFd4YWd3?=
 =?utf-8?B?SUhIUDRIblFUZTkrS0o2eWRGSzRZbUlETFJjUmM3bkp0bUdjbFFQYStqRlRz?=
 =?utf-8?B?V3NkcjZGMmgwcU5YbkM3SU14SkpNcEJkdUt6aVgvcXJNYW1xNTdzWFFlYmdC?=
 =?utf-8?Q?1a1UhDAmQcCn8PTVlFs6xZ3TfnA8iRFzQHtFSZu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d46ca020-27bf-4c64-c97c-08d984536bc6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 20:46:48.0655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EDRY+hJc84ERH48WfQNXeMQf6su9JDhi3fplWCokdFiQ4cJHf2emXTY/nh/QO2/lqa+AvDZ6CAAIQ31r5+OlOFrgzbLXzE4kfOeAC9t9R3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4912
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300128
X-Proofpoint-ORIG-GUID: 6pw7ewZzSHdWBTqk_3wWvQeHKWXH7PU0
X-Proofpoint-GUID: 6pw7ewZzSHdWBTqk_3wWvQeHKWXH7PU0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/10/21 3:41 AM, Dmitry Bogdanov wrote:
> Many fabric modules provide their own implementation of enable
> attribute in tpg.
> The change set removes the code duplication and automatically adds
> "enable" attribute for fabric modules that has an implementation of
> fabric_enable_tpg() ops.
> 
> This patchset is intended for scsi-queue.
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
