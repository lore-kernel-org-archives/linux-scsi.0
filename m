Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BEDC47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 21:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C4C5613EA
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 21:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhFCVMU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 17:12:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49512 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhFCVMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 17:12:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153L47rm082106;
        Thu, 3 Jun 2021 21:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=EIfUQjTC22qVaqy+9kNv1xWA1FmvhvU/fozDeKAtejo=;
 b=l+epGXGKOdMef5XxzN0znowd4jUF+0xfFTatSfcqvfu9XT1kuh/JhkcLjFx/lbsJ7LFn
 qt11BBDfmR/v3yvnEhgHLB6TSmOOOLaR/BxM3EmNHIKoOf39O6eOGlt4jS/iTX7lZh73
 XxpdkcQqhdInNYBXxrh2sgbgMry7FG9MJ0iDD77L0Ng8YQimdpbQ5uL4O7E3tozkkTKV
 hwwCBR8Yy+oSC00YVdpJWspR1ysBDSpnxeHBDUfs49NgkM0Elqzth3R3DPy228/H+LDk
 V8X9rxW4L9ljyrJoMqsBLp+E6jOHLhuxxBn4T3HkNWlgI1OtsBeWX3kJPp5cNP+JL8Xx Cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38ue8pme9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 21:10:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153LA548045654;
        Thu, 3 Jun 2021 21:10:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 38uaqyn1us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 21:10:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAtDn4G3Dope3aJgnS6Jn/+y41bscv7zItYreNuz7mLPNqEfT23UKFSX6pIvc2vnPRAzY5zzAN9B0aMUyugfz+d4I+5CLHBOpeIB+jxoPc1wyNQCqSsq0p6L3toH8PSDqv5NuZL+eGTThGexAIfAzxErOA+8tTRzMtOwuOj62qZL3wN4956eiQ4VQAGEHQqGqe2Alo6c9yP8pNGrCJt06CUaaj2UHnILOHgjaYJ7XupHEESdexVMvqlWG5vrwxVv+w+WxUuCEDKYv0DdiJqMM/64iA3i+GHpVLr7TBRYmpKjCfGQQt25aH9WiULqqVE8W4PpkhrndKyXX6JCvtJSIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EIfUQjTC22qVaqy+9kNv1xWA1FmvhvU/fozDeKAtejo=;
 b=MklXFhjlMDsJ9vRqVzl3U/xMxeKlhwZTBKJw6aNY98juVYK3Aa2uxWZ2CdwPHZSwaVNpjh8pm2eRY0x7E71BQSBpPBhFyQ4i7YdqRZxFQ0cxTEXgOmYbtbwfdlxE87AYOFC/X40EZUwAGrJTpPYgWDXKHSOjsmlPT5t6YfF+Gr2aCW8TuXCt4O3O+hHRFBL/PDFilZ5lJ/+q1agz7F/FIkr20uVPvy6mcZxcPyAYCRcGNTpZHI+Q3QvOoktaMCacW5jcgEHtOfBKhL7J88899nsq9SsHJDGZml5pkUmWfkSQF+md554xKpT/pf8K5TJL1NxGGgkQavs0IGrQQmNgXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EIfUQjTC22qVaqy+9kNv1xWA1FmvhvU/fozDeKAtejo=;
 b=kpHgwsoxe6eBG61RwmcWX0OQk4SQhaGSRb5FDtStxjWewfU/3rmkvHC5nVVOcwiHHgrBkyNfSmxGu6wt+CRRZii4jIrEWSdn3QjKTM/Q0ihwL+KIaRBjXBr88EzoG2Hf0zRgpS3C+0QCQXAdWBIC44Vk8g65It7TF21/Q/e8jnE=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4779.namprd10.prod.outlook.com (2603:10b6:806:11f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Thu, 3 Jun
 2021 21:10:27 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 21:10:27 +0000
Subject: Re: [PATCH v2 04/10] qla2xxx: Add extraction of auth_els from the
 wire
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-5-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <176f3210-5a19-a1db-fa87-0fbafefb76d1@oracle.com>
Date:   Thu, 3 Jun 2021 16:10:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210531070545.32072-5-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SA0PR13CA0011.namprd13.prod.outlook.com
 (2603:10b6:806:130::16) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.28] (70.114.128.235) by SA0PR13CA0011.namprd13.prod.outlook.com (2603:10b6:806:130::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.11 via Frontend Transport; Thu, 3 Jun 2021 21:10:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a31933e9-de9e-44d5-487d-08d926d40311
X-MS-TrafficTypeDiagnostic: SA2PR10MB4779:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4779F0123B853171B4E24F5AE63C9@SA2PR10MB4779.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SnUfHwb9PWy5tVpgAa3twMjqBQGMJhW+tMKy8nOlEOi1jvk0ZbaHwxFU/EgbZzmdFqnd1vOrUG55dkIVLTv0ZIxnvElh3fiRQyiZRHmtTHj33p7PVxZUYihCG6myXYOEwZX6vgUmcw6qDWPXLyktlT/AEvIpRjquyLbIJ34UJJG/UJmmGa8unK50MTtjJjZN7hzBkY5p9CNsNUUaEpPKgxopPulSXgtI1ecelNFwCQKVZ1EpfuCanh0Jcrb2CSSdb+HIthQZeH5Fcz8M0rqPZgisdG94rtDXco0bsz2B8D6th6SX1I58G8GFRdKZ2QU+bqbJ50QHyqvUjxR/2XyGyavgK2QEH9VSc8jAXGz4PXmo048JJOD+ktUBdxD+aSY62M+Tz8U6d7zLYKjGRXNgtkec1BbWeYzRNmGbVZ0sugD/2rOhG+NyT9ejf8FjHKCZ8VZCjREzC69/NPMhTGKa4hx3PKK9JGE6yDUEXv+eGhPsRQT8jCmJUTx1GTz9hGd/FwdKk7hxKDxmaGuA8nGQOHLReQNJk06lPNn61vSyd41Vxtnbi8iGfcgeB5bxttBE9fbiFyDCvUK2cvEN9EF0xm870fa3kvyU8I1g9+8WH69xTVA1O0qQlTZaJyrqjoCyoc3jdGHWONRAhUqABtDqz8c6KqvAvDqGwjOzx76EJ2UB3U2WIThRrsu7CYqCNB6W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(31696002)(8936002)(30864003)(8676002)(36756003)(478600001)(16576012)(83380400001)(2616005)(44832011)(956004)(38100700002)(5660300002)(66556008)(66946007)(66476007)(2906002)(16526019)(53546011)(4326008)(86362001)(31686004)(186003)(36916002)(6636002)(6486002)(26005)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V2NaeU1vTlRIaUZvUXFIcDJ2OUVCRjVoOEVQeko4UWMrYThWQ3hCZ0VLSzVz?=
 =?utf-8?B?TTh2cGc3R2xEVnI3aGpFdmNtTGp4VW5yNVhXSDQxTi9nTHc1VDNUQVdGRGtL?=
 =?utf-8?B?aFZubjk5ZmFTTTh5NzBMenZmaUNLVHlIUWxpais1VWYrMUE3V2EzTnZ1K0dx?=
 =?utf-8?B?Y2ZJVTNXb2tuSFNiaDBTcEM3ckkySHIwZ2JpL3ZKcXJHeVhyengwUnFiQzk5?=
 =?utf-8?B?bnovRllVaUpHdHhDUmhvYXVDSHZKTmRYVFRJU3hqNU1QRjR4Y2RhMkp3MzNa?=
 =?utf-8?B?Z09jZ3IrTXgvR1AwWjFFZzhJd0ZFM2pOejh6cFQ0U3VRS0hvTmcrWFVpRmE0?=
 =?utf-8?B?bFdyTEg0SUFleHBidWd6V2UwNGh6eU84UW1MU25iMENNRGFQemNKWHVtOEVX?=
 =?utf-8?B?RlV1N1lpRSt6Z01hZmpHaE9QMjFzcm10bUVJbDArN3ZYWHg1REMwandCVlpX?=
 =?utf-8?B?NFhKbnBUVEZ1K0hleDNsZmpqSzJyV1RPemhjZ0lNcU1rNGsxMjhwQ2FqKzZu?=
 =?utf-8?B?aWlLbzF0NlFqalRadjhLb0EzLzJoVHBFRDloU1dJZ0xBUEthbGs2RnFQNWk5?=
 =?utf-8?B?aTI0STFkNW9sK0Q3bUlaRkUwT04yam56cEl5dEt5UGEwbWF6bmlCQVFmK0xO?=
 =?utf-8?B?T1JqZHFPRmlKakk4d1hoR3BxS2lVb0h0TEF6U295VW1NZHNGbThXaTYzb0pH?=
 =?utf-8?B?akdET0Q0eEZhZ3JjWmVCbXNkSFFLdk8ycWZORWNOVWQrbEh0RzZqRTNjYnhy?=
 =?utf-8?B?cy9waVhubXdCeHZiTVFCYzhab3pMcUUrcDdXYlJUVndPSlF6QlBNZ2JDU2Zx?=
 =?utf-8?B?VXpNbXpJT2pzRmZZRU1DOVB3ZWswRDg4azduSG53eVRmbFhuTEpMVUJUTHhw?=
 =?utf-8?B?YnRvSWp2a3hlQ3d4RkJMdGJOU3lhRWI4UFJUWU5WREhBcEsySThRWkpPbTNw?=
 =?utf-8?B?UXhIdHhHUGhvc2FkdjhqYjQ4QjI3aFpTTmFRbVR3UWhUeDY0b1h6QVlnMHp6?=
 =?utf-8?B?emc5VVVkTGlQT25UMkNYcS9GZXdSN051L1dsVUQ4S3hBVkg0bGtqRDFKVUo2?=
 =?utf-8?B?NmdJTWhaaTA1V1J3cHBwUUxqMG1uMldKTzlvQ3dNMWk0VGt0NnFZMUh1aG01?=
 =?utf-8?B?a2o2M0pqbDhQQ1pYOFVVN3FzVTV1TW1qZHlDeUFvM2k1Zy9OVEV0amk4WHgr?=
 =?utf-8?B?bDlpVVNQVHhQa1FYb1FnWXhCYkRXQ1p5dHBuaXA3YldKMUhnTDJKU05taEhR?=
 =?utf-8?B?YTZROWt6MGdZTEE5L3J5aUtyTENpWFoyVjJxeEdobW1pU1liUWFjb1doTzdT?=
 =?utf-8?B?cE4vSWtWNVBiQUJEY1NCaVVuNXM2Kzl3azk3RVhZNGRQaDd5Q292ZWk3RTFS?=
 =?utf-8?B?L3BJVTlPMzJIaWpQUXNJejk4TUVON0NOUURxL2poWWY4RmV5OFlKREVxKzRB?=
 =?utf-8?B?V0ZNdzRqNyt1TmlpaldCMjUwcDFqSGphMWNCVURDUFFUdld2OWY2MGNpLzcr?=
 =?utf-8?B?N1pwSUFhYVUwekNOOFM4dGtXaUlITVFjTDV5cEtlVjhzSU1ZUHFDQ3ozbVBt?=
 =?utf-8?B?cXRqNW5UaEFDeU81OUdsUXArMVN0aGIvTG5SdFRERjV5SGN0VlFDWHFZRHlY?=
 =?utf-8?B?Z0FDQjM2NG8rVWR6RHAxZjgwUzdiVzRwTi9rQk1CR1ZJaDBqVU00TzRsMG1I?=
 =?utf-8?B?NDd6SjRKb0Z1ZnV3RzFxeFY1dEZLNWpaZ3hpN014em1nWUd4MGxnNE5WTWFJ?=
 =?utf-8?Q?uJu9r1LpKHY4bdUz/s/I44na/qcEoOmMh/zzGip?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a31933e9-de9e-44d5-487d-08d926d40311
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 21:10:27.7281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LLVUI5e5YyFwLaU5ybZi4KdjwvSMGC0fL7HDbqwsHOnMYJIH6EJzIppyQfxUkNNgqX0dE9/yyTHuo9PcKi/4k9BxH2s30GtilgpxaMICg9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106030141
X-Proofpoint-GUID: XhxozxjFaQkCvfXiQQsZdJj47ZzAl6fy
X-Proofpoint-ORIG-GUID: XhxozxjFaQkCvfXiQQsZdJj47ZzAl6fy
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/31/21 2:05 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Latest FC adapter from Marvell has the ability to encrypt
> data in flight (EDIF) feature. This feature require an
> application (ex: ipsec, etc) to act as an authenticator.
> 

^^^  I see this paragraph repeated for all 1-9 patches. I would like you 
to clean up and use only changes to the patch in the commit message. 
You can always reference EDIF feature in commit message but don't have 
to copy same test to all 9  patches.

> This patch is a continuation of previous patch where
> authentication messages sent from remote device has arrived.
> Each message is extracted and placed in a buffer for application
> to retrieve. The FC frame header will be stripped leaving
> behind the AUTH ELS payload. It is up to the application
> to strip the AUTH ELS header to get to the actual authentication
> message.
> 
> Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
> Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h    |   2 +-
>   drivers/scsi/qla2xxx/qla_edif.c   | 191 ++++++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_gbl.h    |   7 +-
>   drivers/scsi/qla2xxx/qla_isr.c    | 182 ++++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_os.c     |  11 +-
>   drivers/scsi/qla2xxx/qla_target.c |  36 +++---
>   6 files changed, 404 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 517a4a4c178e..e47a7b3618d6 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3907,7 +3907,6 @@ struct qlt_hw_data {
>   	int num_act_qpairs;
>   #define DEFAULT_NAQP 2
>   	spinlock_t atio_lock ____cacheline_aligned;
> -	struct btree_head32 host_map;
>   };
>   
>   #define MAX_QFULL_CMDS_ALLOC	8192
> @@ -4682,6 +4681,7 @@ struct qla_hw_data {
>   	struct qla_hw_data_stat stat;
>   	pci_error_state_t pci_error_state;
>   	struct dma_pool *purex_dma_pool;
> +	struct btree_head32 host_map;
>   	struct els_reject elsrej;
>   };
>   
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index 4c788f4588ca..df8dff447c6a 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -684,6 +684,44 @@ qla_enode_stop(scsi_qla_host_t *vha)
>    *  returns: enode pointer with buffers
>    *           NULL on error
>    */
> +static struct enode *
> +qla_enode_alloc(scsi_qla_host_t *vha, uint32_t ntype)
> +{
> +	struct enode		*node;
> +	struct purexevent	*purex;
> +
> +	node = kzalloc(RX_ELS_SIZE, GFP_ATOMIC);
> +	if (!node)
> +		return NULL;
> +
> +	purex = &node->u.purexinfo;
> +	purex->msgp = (u8 *)(node + 1);
> +	purex->msgp_len = ELS_MAX_PAYLOAD;
> +
> +	node->dinfo.lstate = LSTATE_OFF;
> +
> +	node->ntype = ntype;
> +	INIT_LIST_HEAD(&node->list);
> +	return node;
> +}
> +
> +/* adds a already alllocated enode to the linked list */
> +static bool
> +qla_enode_add(scsi_qla_host_t *vha, struct enode *ptr)
> +{
> +	unsigned long flags;
> +
> +	ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x9109,
> +	    "%s add enode for type=%x, cnt=%x\n",
> +	    __func__, ptr->ntype, ptr->dinfo.nodecnt);
> +
> +	spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
> +	ptr->dinfo.lstate = LSTATE_ON;
> +	list_add_tail(&ptr->list, &vha->pur_cinfo.head);
> +	spin_unlock_irqrestore(&vha->pur_cinfo.pur_lock, flags);
> +
> +	return true;
> +}
>   
>   static struct enode *
>   qla_enode_find(scsi_qla_host_t *vha, uint32_t ntype, uint32_t p1, uint32_t p2)
> @@ -783,6 +821,32 @@ qla_pur_get_pending(scsi_qla_host_t *vha, fc_port_t *fcport, struct bsg_job *bsg
>   
>   	return 0;
>   }
> +
> +/* it is assume qpair lock is held */
> +static int
> +qla_els_reject_iocb(scsi_qla_host_t *vha, struct qla_qpair *qp,
> +	struct qla_els_pt_arg *a)
> +{
> +	struct els_entry_24xx *els_iocb;
> +
> +	els_iocb = __qla2x00_alloc_iocbs(qp, NULL);
> +	if (!els_iocb) {
> +		ql_log(ql_log_warn, vha, 0x700c,
> +		    "qla2x00_alloc_iocbs failed.\n");
> +		return QLA_FUNCTION_FAILED;
> +	}
> +
> +	qla_els_pt_iocb(vha, els_iocb, a);
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x0183,
> +	    "Sending ELS reject...\n");
> +	ql_dump_buffer(ql_dbg_edif + ql_dbg_verbose, vha, 0x0185,
> +	    vha->hw->elsrej.c, sizeof(*vha->hw->elsrej.c));
> +	/* -- */
> +	wmb();
> +	qla2x00_start_iocbs(vha, qp->req);
> +	return 0;
> +}
>   /* function called when app is stopping */
>   
>   void
> @@ -796,6 +860,133 @@ qla_edb_stop(scsi_qla_host_t *vha)
>   	}
>   }
>   
> +void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
> +{
> +	struct purex_entry_24xx *p = *pkt;
> +	struct enode		*ptr;
> +	int		sid;
> +	u16 totlen;
> +	struct purexevent	*purex;
> +	struct scsi_qla_host *host = NULL;
> +	int rc;
> +	struct fc_port *fcport;
> +	struct qla_els_pt_arg a;
> +	be_id_t beid;
> +
> +	memset(&a, 0, sizeof(a));
> +
> +	a.els_opcode = ELS_AUTH_ELS;
> +	a.nport_handle = p->nport_handle;
> +	a.rx_xchg_address = p->rx_xchg_addr;
> +	a.did.b.domain = p->s_id[2];
> +	a.did.b.area   = p->s_id[1];
> +	a.did.b.al_pa  = p->s_id[0];
> +	a.tx_byte_count = a.tx_len = sizeof(struct fc_els_ls_rjt);
> +	a.tx_addr = vha->hw->elsrej.cdma;
> +	a.vp_idx = vha->vp_idx;
> +	a.control_flags = EPD_ELS_RJT;
> +
> +	sid = p->s_id[0] | (p->s_id[1] << 8) | (p->s_id[2] << 16);
> +	/*
> +	 * ql_dbg(ql_dbg_edif, vha, 0x09108,
> +	 *	  "%s rec'vd sid=0x%x\n", __func__, sid);
> +	 */
> +

Why not use ql_dbg(ql_dbg_edif + ql_dbg_verbose) option.

if this was just for development debugging then remove it rather than 
leaving it commented out.


> +	totlen = (le16_to_cpu(p->frame_size) & 0x0fff) - PURX_ELS_HEADER_SIZE;
> +	if (le16_to_cpu(p->status_flags) & 0x8000) {
> +		totlen = le16_to_cpu(p->trunc_frame_size);
> +		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
> +		__qla_consume_iocb(vha, pkt, rsp);
> +		return;
> +	}
> +
> +	if (totlen > MAX_PAYLOAD) {
> +		ql_dbg(ql_dbg_edif, vha, 0x0910d,
> +		    "%s WARNING: verbose ELS frame received (totlen=%x)\n",
> +		    __func__, totlen);
> +		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
> +		__qla_consume_iocb(vha, pkt, rsp);
> +		return;
> +	}
> +
> +	if (!vha->hw->flags.edif_enabled) {
> +		/* edif support not enabled */
> +		ql_dbg(ql_dbg_edif, vha, 0x910e, "%s edif not enabled\n",
> +		    __func__);
> +		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
> +		__qla_consume_iocb(vha, pkt, rsp);
> +		return;
> +	}
> +
> +	ptr = qla_enode_alloc(vha, N_PUREX);
> +	if (!ptr) {
> +		ql_dbg(ql_dbg_edif, vha, 0x09109,
> +		    "WARNING: enode allloc failed for sid=%x\n",
> +		    sid);
> +		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
> +		__qla_consume_iocb(vha, pkt, rsp);
> +		return;
> +	}
> +
> +	purex = &ptr->u.purexinfo;
> +	purex->pur_info.pur_sid = a.did;
> +	purex->pur_info.pur_pend = 0;
> +	purex->pur_info.pur_bytes_rcvd = totlen;
> +	purex->pur_info.pur_rx_xchg_address = le32_to_cpu(p->rx_xchg_addr);
> +	purex->pur_info.pur_nphdl = le16_to_cpu(p->nport_handle);
> +	purex->pur_info.pur_did.b.domain =  p->d_id[2];
> +	purex->pur_info.pur_did.b.area =  p->d_id[1];
> +	purex->pur_info.pur_did.b.al_pa =  p->d_id[0];
> +	purex->pur_info.vp_idx = p->vp_idx;
> +
> +	rc = __qla_copy_purex_to_buffer(vha, pkt, rsp, purex->msgp,
> +		purex->msgp_len);
> +	if (rc) {
> +		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
> +		qla_enode_free(vha, ptr);
> +		return;
> +	}
> +	/*
> +	 * ql_dump_buffer(ql_dbg_edif, vha, 0x70e0,
> +	 *   purex->msgp, purex->pur_info.pur_bytes_rcvd);
> +	 */

Ditto here.. why not use ql_dump_buffer(ql_dbg_edif + ql_dbg_verbose) 
option. you might want to know buffer content while debugging EDIF issues.

> +	beid.al_pa = purex->pur_info.pur_did.b.al_pa;
> +	beid.area   = purex->pur_info.pur_did.b.area;
> +	beid.domain = purex->pur_info.pur_did.b.domain;
> +	host = qla_find_host_by_d_id(vha, beid);
> +	if (!host) {
> +		ql_log(ql_log_fatal, vha, 0x508b,
> +		    "%s Drop ELS due to unable to find host %06x\n",
> +		    __func__, purex->pur_info.pur_did.b24);
> +
> +		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
> +		qla_enode_free(vha, ptr);
> +		return;
> +	}
> +
> +	fcport = qla2x00_find_fcport_by_pid(host, &purex->pur_info.pur_sid);
> +
> +	if (host->e_dbell.db_flags != EDB_ACTIVE ||
> +	    (fcport && fcport->loop_id == FC_NO_LOOP_ID)) {
> +		ql_dbg(ql_dbg_edif, host, 0x0910c, "%s e_dbell.db_flags =%x %06x\n",
> +		    __func__, host->e_dbell.db_flags,
> +		    fcport ? fcport->d_id.b24 : 0);
> +
> +		qla_els_reject_iocb(host, (*rsp)->qpair, &a);
> +		qla_enode_free(host, ptr);
> +		return;
> +	}
> +
> +	/* add the local enode to the list */
> +	qla_enode_add(host, ptr);
> +
> +	ql_dbg(ql_dbg_edif, host, 0x0910c,
> +	    "%s COMPLETE purex->pur_info.pur_bytes_rcvd =%xh s:%06x -> d:%06x xchg=%xh\n",
> +	    __func__, purex->pur_info.pur_bytes_rcvd,
> +	    purex->pur_info.pur_sid.b24,
> +	    purex->pur_info.pur_did.b24, p->rx_xchg_addr);
> +}
> +
>   static void qla_parse_auth_els_ctl(struct srb *sp)
>   {
>   	struct qla_els_pt_arg *a = &sp->u.bsg_cmd.u.els_arg;
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index 7ff05aa10b2d..a4cb8092e97e 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -582,6 +582,7 @@ qla2xxx_msix_rsp_q_hs(int irq, void *dev_id);
>   fc_port_t *qla2x00_find_fcport_by_loopid(scsi_qla_host_t *, uint16_t);
>   fc_port_t *qla2x00_find_fcport_by_wwpn(scsi_qla_host_t *, u8 *, u8);
>   fc_port_t *qla2x00_find_fcport_by_nportid(scsi_qla_host_t *, port_id_t *, u8);
> +void __qla_consume_iocb(struct scsi_qla_host *vha, void **pkt, struct rsp_que **rsp);
>   
>   /*
>    * Global Function Prototypes in qla_sup.c source file.
> @@ -644,6 +645,8 @@ extern int qla2xxx_get_vpd_field(scsi_qla_host_t *, char *, char *, size_t);
>   
>   extern void qla2xxx_flash_npiv_conf(scsi_qla_host_t *);
>   extern int qla24xx_read_fcp_prio_cfg(scsi_qla_host_t *);
> +int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha, void **pkt,
> +	struct rsp_que **rsp, u8 *buf, u32 buf_len);
>   
>   /*
>    * Global Function Prototypes in qla_dbg.c source file.
> @@ -929,6 +932,7 @@ extern int qla_set_exchoffld_mem_cfg(scsi_qla_host_t *);
>   extern void qlt_handle_abts_recv(struct scsi_qla_host *, struct rsp_que *,
>   	response_t *);
>   
> +struct scsi_qla_host *qla_find_host_by_d_id(struct scsi_qla_host *vha, be_id_t d_id);
>   int qla24xx_async_notify_ack(scsi_qla_host_t *, fc_port_t *,
>   	struct imm_ntfy_from_isp *, int);
>   void qla24xx_do_nack_work(struct scsi_qla_host *, struct qla_work_evt *);
> @@ -941,7 +945,7 @@ extern struct fc_port *qlt_find_sess_invalidate_other(scsi_qla_host_t *,
>   void qla24xx_delete_sess_fn(struct work_struct *);
>   void qlt_unknown_atio_work_fn(struct work_struct *);
>   void qlt_update_host_map(struct scsi_qla_host *, port_id_t);
> -void qlt_remove_target_resources(struct qla_hw_data *);
> +void qla_remove_hostmap(struct qla_hw_data *ha);
>   void qlt_clr_qp_table(struct scsi_qla_host *vha);
>   void qlt_set_mode(struct scsi_qla_host *);
>   int qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode);
> @@ -961,6 +965,7 @@ void qla_edb_stop(scsi_qla_host_t *vha);
>   int32_t qla_edif_app_mgmt(struct bsg_job *bsg_job);
>   void qla_enode_init(scsi_qla_host_t *vha);
>   void qla_enode_stop(scsi_qla_host_t *vha);
> +void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp);
>   void qla_handle_els_plogi_done(scsi_qla_host_t *vha, struct event_arg *ea);
>   
>   #define QLA2XX_HW_ERROR			BIT_0
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index a130a2db2cba..ea7635af03a8 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -169,6 +169,128 @@ qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
>   	dma_free_coherent(&ha->pdev->dev, sizeof(*rsp_els), rsp_els, dma);
>   }
>   
> +/* it is assumed pkt is the head iocb, not the continuation iocb */
> +void __qla_consume_iocb(struct scsi_qla_host *vha,
> +	void **pkt, struct rsp_que **rsp)
> +{
> +	struct rsp_que *rsp_q = *rsp;
> +	response_t *new_pkt;
> +	uint16_t entry_count_remaining;
> +	struct purex_entry_24xx *purex = *pkt;
> +
> +	entry_count_remaining = purex->entry_count;
> +	while (entry_count_remaining > 0) {
> +		new_pkt = rsp_q->ring_ptr;
> +		*pkt = new_pkt;
> +
> +		rsp_q->ring_index++;
> +		if (rsp_q->ring_index == rsp_q->length) {
> +			rsp_q->ring_index = 0;
> +			rsp_q->ring_ptr = rsp_q->ring;
> +		} else {
> +			rsp_q->ring_ptr++;
> +		}
> +
> +		new_pkt->signature = RESPONSE_PROCESSED;
> +		// flush signature

remove this comment.

> +		wmb();
> +		--entry_count_remaining;
> +	}
> +}
> +
> +int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha,
> +	void **pkt, struct rsp_que **rsp, u8 *buf, u32 buf_len)
> +{
> +	struct purex_entry_24xx *purex = *pkt;
> +	struct rsp_que *rsp_q = *rsp;
> +	sts_cont_entry_t *new_pkt;
> +	uint16_t no_bytes = 0, total_bytes = 0, pending_bytes = 0;
> +	uint16_t buffer_copy_offset = 0;
> +	uint16_t entry_count_remaining;
> +	u16 tpad;
> +
> +	entry_count_remaining = purex->entry_count;
> +	total_bytes = (le16_to_cpu(purex->frame_size) & 0x0FFF)
> +		- PURX_ELS_HEADER_SIZE;
> +
> +	/* end of payload may not end in 4bytes boundary.  Need to
> +	 * round up / pad for room to swap, before saving data
> +	 */

fix comment style

> +	tpad = roundup(total_bytes, 4);
> +
> +	if (buf_len < tpad) {
> +		ql_dbg(ql_dbg_async, vha, 0x5084,
> +		    "%s buffer is too small %d < %d\n",
> +		    __func__, buf_len, tpad);
> +		__qla_consume_iocb(vha, pkt, rsp);
> +		return -EIO;
> +	}
> +
> +	pending_bytes = total_bytes = tpad;
> +	no_bytes = (pending_bytes > sizeof(purex->els_frame_payload))  ?
> +	sizeof(purex->els_frame_payload) : pending_bytes;

use proper indentation

> +	memcpy(buf, &purex->els_frame_payload[0], no_bytes);
> +	buffer_copy_offset += no_bytes;
> +	pending_bytes -= no_bytes;
> +	--entry_count_remaining;
> +
> +	((response_t *)purex)->signature = RESPONSE_PROCESSED;
> +	// flush signature

remove or fix style

> +	wmb();
> +
> +	do {
> +		while ((total_bytes > 0) && (entry_count_remaining > 0)) {
> +			new_pkt = (sts_cont_entry_t *)rsp_q->ring_ptr;
> +			*pkt = new_pkt;
> +
> +			if (new_pkt->entry_type != STATUS_CONT_TYPE) {
> +				ql_log(ql_log_warn, vha, 0x507a,
> +				    "Unexpected IOCB type, partial data 0x%x\n",
> +				    buffer_copy_offset);
> +				break;
> +			}
> +
> +			rsp_q->ring_index++;
> +			if (rsp_q->ring_index == rsp_q->length) {
> +				rsp_q->ring_index = 0;
> +				rsp_q->ring_ptr = rsp_q->ring;
> +			} else {
> +				rsp_q->ring_ptr++;
> +			}
> +			no_bytes = (pending_bytes > sizeof(new_pkt->data)) ?
> +			    sizeof(new_pkt->data) : pending_bytes;
> +			if ((buffer_copy_offset + no_bytes) <= total_bytes) {
> +				memcpy((buf + buffer_copy_offset), new_pkt->data,
> +				    no_bytes);
> +				buffer_copy_offset += no_bytes;
> +				pending_bytes -= no_bytes;
> +				--entry_count_remaining;
> +			} else {
> +				ql_log(ql_log_warn, vha, 0x5044,
> +				    "Attempt to copy more that we got, optimizing..%x\n",
> +				    buffer_copy_offset);
> +				memcpy((buf + buffer_copy_offset), new_pkt->data,
> +				    total_bytes - buffer_copy_offset);
> +			}
> +
> +			((response_t *)new_pkt)->signature = RESPONSE_PROCESSED;
> +			// flush signature

ditto here... remove or fix comment style

> +			wmb();
> +		}
> +
> +		if (pending_bytes != 0 || entry_count_remaining != 0) {
> +			ql_log(ql_log_fatal, vha, 0x508b,
> +			    "Dropping partial Data, underrun bytes = 0x%x, entry cnts 0x%x\n",
> +			    total_bytes, entry_count_remaining);
> +			return -EIO;
> +		}
> +	} while (entry_count_remaining > 0);
> +
> +	be32_to_cpu_array((u32 *)buf, (__be32 *)buf, total_bytes >> 2);

need new line here

> +	return 0;
> +}
> +
>   /**
>    * qla2100_intr_handler() - Process interrupts for the ISP2100 and ISP2200.
>    * @irq: interrupt number
> @@ -1727,6 +1849,8 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
>   	srb_t *sp;
>   	uint16_t index;
>   
> +	if (pkt->handle == QLA_SKIP_HANDLE)
> +		return NULL;

need new line here

>   	index = LSW(pkt->handle);
>   	if (index >= req->num_outstanding_cmds) {
>   		ql_log(ql_log_warn, vha, 0x5031,
> @@ -3530,6 +3654,55 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
>   	sp->done(sp, comp_status);
>   }
>   
> +/* check for all continuation iocbs are available. */
> +static int qla_chk_cont_iocb_avail(struct scsi_qla_host *vha,
> +	struct rsp_que *rsp, response_t *pkt)
> +{
> +	int start_pkt_ring_index, end_pkt_ring_index, n_ring_index;
> +	response_t *end_pkt;
> +	int rc = 0;
> +	u32 rsp_q_in;
> +
> +	if (pkt->entry_count == 1)
> +		return rc;
> +
> +	/* ring_index was pre-increment. set it back to current pkt */
> +	if (rsp->ring_index == 0)
> +		start_pkt_ring_index = rsp->length - 1;
> +	else
> +		start_pkt_ring_index = rsp->ring_index - 1;
> +
> +	if ((start_pkt_ring_index + pkt->entry_count) >= rsp->length)
> +		end_pkt_ring_index = start_pkt_ring_index + pkt->entry_count -
> +			rsp->length - 1;
> +	else
> +		end_pkt_ring_index = start_pkt_ring_index + pkt->entry_count - 1;
> +
> +	end_pkt = rsp->ring + end_pkt_ring_index;
> +
> +	//  next pkt = end_pkt + 1

remove debug code

> +	n_ring_index = end_pkt_ring_index + 1;
> +	if (n_ring_index >= rsp->length)
> +		n_ring_index = 0;
> +
> +	rsp_q_in = rsp->qpair->use_shadow_reg ? *rsp->in_ptr :
> +		rd_reg_dword(rsp->rsp_q_in);
> +
> +	/* rsp_q_in is either wrapped or pointing beyond endpkt */
> +	if ((rsp_q_in < start_pkt_ring_index && rsp_q_in < n_ring_index) ||
> +			rsp_q_in >= n_ring_index)
> +		// all IOCBs arrived.
remove comment
> +		rc = 0;
> +	else
> +		rc = -EIO;
> +
> +	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x5091,
> +		"%s - ring %p pkt %p end pkt %p entry count %#x rsp_q_in %d rc %d\n",
> +		__func__, rsp->ring, pkt, end_pkt, pkt->entry_count,
> +		rsp_q_in, rc);

need a new line here

> +	return rc;
> +}
> +
>   /**
>    * qla24xx_process_response_queue() - Process response queue entries.
>    * @vha: SCSI driver HA context
> @@ -3670,6 +3843,15 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
>   						 qla27xx_process_purex_fpin);
>   				break;
>   
> +			case ELS_AUTH_ELS:
> +				if (qla_chk_cont_iocb_avail(vha, rsp, (response_t *)pkt)) {
> +					ql_dbg(ql_dbg_init, vha, 0x5091,
> +					    "Defer processing ELS opcode %#x...\n",
> +					    purex_entry->els_frame_payload[3]);
> +					return;
> +				}
> +				qla24xx_auth_els(vha, (void **)&pkt, &rsp);
> +				break;
>   			default:
>   				ql_log(ql_log_warn, vha, 0x509c,
>   				       "Discarding ELS Request opcode 0x%x\n",
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 5e39977af9ba..6be06b994c43 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3797,7 +3797,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
>   	qla2x00_free_sysfs_attr(base_vha, true);
>   
>   	fc_remove_host(base_vha->host);
> -	qlt_remove_target_resources(ha);
>   
>   	scsi_remove_host(base_vha->host);
>   
> @@ -3974,15 +3973,20 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
>   	struct req_que **req, struct rsp_que **rsp)
>   {
>   	char	name[16];
> +	int rc;
>   
>   	ha->init_cb = dma_alloc_coherent(&ha->pdev->dev, ha->init_cb_size,
>   		&ha->init_cb_dma, GFP_KERNEL);
>   	if (!ha->init_cb)
>   		goto fail;
>   
> -	if (qlt_mem_alloc(ha) < 0)
> +	rc = btree_init32(&ha->host_map);
> +	if (rc)
>   		goto fail_free_init_cb;
>   
> +	if (qlt_mem_alloc(ha) < 0)
> +		goto fail_free_btree;
> +
>   	ha->gid_list = dma_alloc_coherent(&ha->pdev->dev,
>   		qla2x00_gid_list_size(ha), &ha->gid_list_dma, GFP_KERNEL);
>   	if (!ha->gid_list)
> @@ -4386,6 +4390,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
>   	ha->gid_list_dma = 0;
>   fail_free_tgt_mem:
>   	qlt_mem_free(ha);
> +fail_free_btree:
> +	btree_destroy32(&ha->host_map);
>   fail_free_init_cb:
>   	dma_free_coherent(&ha->pdev->dev, ha->init_cb_size, ha->init_cb,
>   	ha->init_cb_dma);
> @@ -4802,6 +4808,7 @@ qla2x00_mem_free(struct qla_hw_data *ha)
>   	ha->dif_bundl_pool = NULL;
>   
>   	qlt_mem_free(ha);
> +	qla_remove_hostmap(ha);
>   
>   	if (ha->init_cb)
>   		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index abf18b88579c..365e64ebef8b 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -197,7 +197,7 @@ struct scsi_qla_host *qla_find_host_by_d_id(struct scsi_qla_host *vha,
>   
>   	key = be_to_port_id(d_id).b24;
>   
> -	host = btree_lookup32(&vha->hw->tgt.host_map, key);
> +	host = btree_lookup32(&vha->hw->host_map, key);
>   	if (!host)
>   		ql_dbg(ql_dbg_tgt_mgt + ql_dbg_verbose, vha, 0xf005,
>   		    "Unable to find host %06x\n", key);
> @@ -6442,15 +6442,15 @@ int qlt_remove_target(struct qla_hw_data *ha, struct scsi_qla_host *vha)
>   	return 0;
>   }
>   
> -void qlt_remove_target_resources(struct qla_hw_data *ha)
> +void qla_remove_hostmap(struct qla_hw_data *ha)
>   {
>   	struct scsi_qla_host *node;
>   	u32 key = 0;
>   
> -	btree_for_each_safe32(&ha->tgt.host_map, key, node)
> -		btree_remove32(&ha->tgt.host_map, key);
> +	btree_for_each_safe32(&ha->host_map, key, node)
> +		btree_remove32(&ha->host_map, key);
>   
> -	btree_destroy32(&ha->tgt.host_map);
> +	btree_destroy32(&ha->host_map);
>   }
>   
>   static void qlt_lport_dump(struct scsi_qla_host *vha, u64 wwpn,
> @@ -7078,8 +7078,7 @@ qlt_modify_vp_config(struct scsi_qla_host *vha,
>   void
>   qlt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
>   {
> -	int rc;
> -
> +	mutex_init(&base_vha->vha_tgt.tgt_mutex);
>   	if (!QLA_TGT_MODE_ENABLED())
>   		return;
>   
> @@ -7092,7 +7091,6 @@ qlt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
>   		ISP_ATIO_Q_OUT(base_vha) = &ha->iobase->isp24.atio_q_out;
>   	}
>   
> -	mutex_init(&base_vha->vha_tgt.tgt_mutex);
>   	mutex_init(&base_vha->vha_tgt.tgt_host_action_mutex);
>   
>   	INIT_LIST_HEAD(&base_vha->unknown_atio_list);
> @@ -7101,11 +7099,6 @@ qlt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
>   
>   	qlt_clear_mode(base_vha);
>   
> -	rc = btree_init32(&ha->tgt.host_map);
> -	if (rc)
> -		ql_log(ql_log_info, base_vha, 0xd03d,
> -		    "Unable to initialize ha->host_map btree\n");
> -
>   	qlt_update_vp_map(base_vha, SET_VP_IDX);
>   }
>   
> @@ -7226,21 +7219,20 @@ qlt_update_vp_map(struct scsi_qla_host *vha, int cmd)
>   	u32 key;
>   	int rc;
>   
> -	if (!QLA_TGT_MODE_ENABLED())
> -		return;
> -
>   	key = vha->d_id.b24;
>   
>   	switch (cmd) {
>   	case SET_VP_IDX:
> +		if (!QLA_TGT_MODE_ENABLED())
> +			return;
>   		vha->hw->tgt.tgt_vp_map[vha->vp_idx].vha = vha;
>   		break;
>   	case SET_AL_PA:
> -		slot = btree_lookup32(&vha->hw->tgt.host_map, key);
> +		slot = btree_lookup32(&vha->hw->host_map, key);
>   		if (!slot) {
>   			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf018,
>   			    "Save vha in host_map %p %06x\n", vha, key);
> -			rc = btree_insert32(&vha->hw->tgt.host_map,
> +			rc = btree_insert32(&vha->hw->host_map,
>   				key, vha, GFP_ATOMIC);
>   			if (rc)
>   				ql_log(ql_log_info, vha, 0xd03e,
> @@ -7250,17 +7242,19 @@ qlt_update_vp_map(struct scsi_qla_host *vha, int cmd)
>   		}
>   		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf019,
>   		    "replace existing vha in host_map %p %06x\n", vha, key);
> -		btree_update32(&vha->hw->tgt.host_map, key, vha);
> +		btree_update32(&vha->hw->host_map, key, vha);
>   		break;
>   	case RESET_VP_IDX:
> +		if (!QLA_TGT_MODE_ENABLED())
> +			return;
>   		vha->hw->tgt.tgt_vp_map[vha->vp_idx].vha = NULL;
>   		break;
>   	case RESET_AL_PA:
>   		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01a,
>   		   "clear vha in host_map %p %06x\n", vha, key);
> -		slot = btree_lookup32(&vha->hw->tgt.host_map, key);
> +		slot = btree_lookup32(&vha->hw->host_map, key);
>   		if (slot)
> -			btree_remove32(&vha->hw->tgt.host_map, key);
> +			btree_remove32(&vha->hw->host_map, key);
>   		vha->d_id.b24 = 0;
>   		break;
>   	}
> 

-- 
Himanshu Madhani                                Oracle Linux Engineering
