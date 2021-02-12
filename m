Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A4DC4332D
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C80764EA6
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhBLTJI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 14:09:08 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35222 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbhBLTJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 14:09:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJ3xcK026612;
        Fri, 12 Feb 2021 19:08:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=MOnBJrSZ2W2l2+t5jHvVLfUCPxNHZhrQIo2eQ620oE0=;
 b=xkIziFD4rqgRKiEdu7Iefh9jl57AuA1y/KX3eAdg3ie4mC90dAO3uCB5jSW3MPlsRWMG
 GNj1OUxjMQKWbI6LhOp2Icu9lIuLc2Uw7ptIB8sRYlH5FEteGAJK7kvD0sKlr9zdp+Nc
 bp02qNKK98OvlRPQUVfdXg2ZU+MIGKRex6WDlT6wpukuDAih8Yc6usqpPgVcIWrkaPKq
 P/4a7wvDmAe0VC2wwFcFOkCOdY5ZNTtfTtD/gMmK0+jzT2TXCOS+0F3ZI3rvPSZ3EabM
 aJJudANIpf7YHLpVE8BB3t3JD4p9DwmMU0yM7M5OEKuf0ndhu3fHkz/rhlU6AbxZp45b 5Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36hkrnc920-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:08:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJ5DbI034464;
        Fri, 12 Feb 2021 19:08:15 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2052.outbound.protection.outlook.com [104.47.38.52])
        by userp3030.oracle.com with ESMTP id 36j521v95m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:08:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNbVNPj0xNlEc3SFX1yrPsP55QDAu1U33UruHgiEFCiZtOdc9ltZvByXApcDaaWpkv1epVmJTpCjgXL3hDVvtSiqVheX9DpX+lxQ+rTY2pJneWQeEG3uqZq4Hg3JtESw3Q/QC7FnQtkoguiEVSXC5DlPLCc+t4J5oD2NFZha5guVtRf5wsYVt4/lmYQKcXXLTmGUF5tgBHLZ91bikHbQJKcACtZyKPNQFnj0q4YWDM5bTlmH+zo2g7Flh7798O/KHbPtLEZiZpy78VK/qiNnM3t3GNbPtAoeDIf1ESPtSo03O2uddLdaOOfaLCUIH3kFJyMwLoyDTha+Zy6i2OITLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOnBJrSZ2W2l2+t5jHvVLfUCPxNHZhrQIo2eQ620oE0=;
 b=aq/a9ZpcUNGkPePWEXovnEJbRTB4V3yeRWxMo49eFSkKAPjLxaZFZp2LZJaIkKdcCwWqOA7Ba7AmEvVSkGkpBnvUEBGmq0h+Qb0pJ2LM4Hceq31jQAycah1tRXw+wqlz6El/fprKfnirBb2s/1+aHtsHzHsJEGSEw9ZDaay/uClVD0q3KzyEcV5UIybXAVhYmma6AwXy7I7P+uNjoybe3zMJQkVB980zv8i8Vt14V9XmxsVZW+EoDWHgjdOImhagqts0sZIScFJng1iDTO4GJlDYFkJmd/xy8BbUYPyfqkQvnRTa/iUYEFwXyS6gATX0wtRxoz6QdrPy60vgFnYgKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOnBJrSZ2W2l2+t5jHvVLfUCPxNHZhrQIo2eQ620oE0=;
 b=nM9fNTLpiGmRCZzbdtfEa3zkWpYMw2kq35K0xqpR8IKXh2jbFWQoN6wZjy0XNt2usRKFDdraoq415mW7lEXsduC9eDNV9rjLmaPAH0N8vxCUT38RNffofwR1jbPJXlZJZTRTlPtH4Mx9wCdwACZPhj1xl65gGXtV+hbKWFje84g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4682.namprd10.prod.outlook.com (2603:10b6:806:110::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 12 Feb
 2021 19:08:12 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48%5]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 19:08:12 +0000
Subject: Re: [PATCH 02/25] target: drop kref_get_unless_zero in
 target_get_sess_cmd
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210212072642.17520-1-michael.christie@oracle.com>
 <20210212072642.17520-3-michael.christie@oracle.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <92923650-00e4-b3c8-9a01-fd7c081b6711@oracle.com>
Date:   Fri, 12 Feb 2021 13:08:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <20210212072642.17520-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0601CA0023.namprd06.prod.outlook.com
 (2603:10b6:803:2f::33) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.20] (70.114.128.235) by SN4PR0601CA0023.namprd06.prod.outlook.com (2603:10b6:803:2f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 19:08:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ed53f6d-3b40-45f0-f309-08d8cf898aeb
X-MS-TrafficTypeDiagnostic: SA2PR10MB4682:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4682DE5D5952D54CCCCEA1E4E68B9@SA2PR10MB4682.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5dC9GhSh35IMQWpdm3qAfwbz1O97oE6qWgNtidWpGGhKCaovxLC0OUtrF2oB7pcoDV4+PA3HXVqKgTx0Q1UFK/xOH0x4p4uA+wJqcPVtHeoT+t2kHFW3T7Mn+MIi9fyGuxs/lvZaI3cj8eurJTdv3I3NxT9ydY6oJdij4qfNdsX4i7YXaZLsBlx7H8IoBT3n2sn/NbJecRH84UY/jrfSnXcLpRCrmrbaZCXH6CHRT/N46KSUcnaVaQuv9qY28KwH0gPn/8Slu+pSSvuaUrOjPAVBpb+sGJzNpHAp+1/IrkBlSbH1tpww3RtL6Z/x1afzZLSguOuWM7hm68m37jf+2FTZOHlaRO6hs88w8UuO1ws8FkYaURBhlIwZ4P9cjiy55HomdNVKFeT2YMLjNnf+SdKoB8VvrXBkDLPqNPa+PirJJXRi757Khlts/P0UlP72uVau1w0eik14ZysdJ8vO+UVXtvgnTJy/ToyIhAFIBvOmfN9pgDZdfAodRLH55LrhNbfpQ44wIkNBpCFtRmdyKykHVckaQLidHMepnWBE8o1UtbxE5vpXr/4Km5OTHIRfLVwnS2q+cXm5TDX8LSowsmeRE5bcwYSZFbvIiHu49+8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(39860400002)(396003)(346002)(86362001)(956004)(478600001)(2616005)(31696002)(8936002)(2906002)(8676002)(36756003)(5660300002)(36916002)(66476007)(31686004)(66556008)(44832011)(83380400001)(6486002)(186003)(16526019)(66946007)(53546011)(316002)(16576012)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WjBqZXhwbEIraUJiYjRDYmN5bUpjZmNoUm9lUTNIeHJSbUJzR3F6VmRLTWE1?=
 =?utf-8?B?UU1mU1UwWUJocG50dml5NUl1YUxURk9zbDVXOUVYM2x3Rk1uT0JsNTM4Yy9U?=
 =?utf-8?B?eENMLytwbTNkbUJrYkM4TlFwZ0FjVnB6dE1FVDgveWdUcE9BMEFWRWlReXJx?=
 =?utf-8?B?cDlwZUFhWGhYODhoNloxbHBjTGVYbnh0ZFZXb3diMXJnVjlReXloV21yVFA1?=
 =?utf-8?B?eXFITFIvRDBydGN6UW1DRmJWWUt0Vm1hTHViSmZSMlFudmRwL08xcDExdmhq?=
 =?utf-8?B?UkZ1b0s3WXdna0MyRlU4QWZYQko4TlhlRXY3MmhGVFUzVW90c0s1RFdqWk91?=
 =?utf-8?B?eUdCblE5N0pwVnprSTBmNEl4eE50NzZqbTdZeCtKamNmYlpTb29CcVhHbk9C?=
 =?utf-8?B?MWZ0K3p6ZHBTcE5tTGFYQ0dsRUdCc3Z4QXVGdTZHZm1nRnFLS2lqazlUQmg1?=
 =?utf-8?B?OXZ4ZjFCUE9EaHRSWVlzSVlHQVhBOXBGZERPd0lOLzVEOWZ0eWVXTGpNY25x?=
 =?utf-8?B?a2x0OFpKUVJyMFpmRFNVTVg4TTZ0UEhUc2RSVUtYZVEzZHh3ZEZUM3FVYmVL?=
 =?utf-8?B?RmNoQytJbUdGUkYybFZ2SHFWcTJPRkxmdTJyWEpNdkhYSGNoR0I1NFFmRElS?=
 =?utf-8?B?cllBalYrQnArSWlNSW0xbit6eDNiWGg5ZXozNWxFVThPbVp2TUF3QXMwOEZh?=
 =?utf-8?B?YysxcHlzYjBjalE0dUIyQy9KR0E4Vm1SeDBDWkozaUJSR1FqWVpuaE9rcVQ3?=
 =?utf-8?B?UU1TeW12Ly9SS0pFWERyMDlURGZZU0ZNUHN1bDVmK2pLbWZLWDBienlqWHJP?=
 =?utf-8?B?ZFRtTnhUN2M2eTh6d1M2TWNDRFZXRGhNVDdxVzl6TnhkSFk1TkJ0blRpREZt?=
 =?utf-8?B?VTV3TzI0eWJEeEY2eFJNazZYR2c4b0VwSlhQaEJzRkRDMkxKQ0RRTW9Zd1ht?=
 =?utf-8?B?YlRkR01uWTF0UVY1d0xpd1dvV1p1ek8vZWdVUnN0cVdEMGowK1d1WEd4ZnRY?=
 =?utf-8?B?bDFrUHUwSkhaeU9CWnRyV29VS1Q3Mm04WG0venBLSzZqSzBlT0NmTEUyZ1V4?=
 =?utf-8?B?MDYrTDJ1NEIzVDFPTksxUFdkOGNZL0Y0YnN0a0Rva3VNQ29LSUJqQ1RydjVD?=
 =?utf-8?B?a1dBVWdxa3NFR3hNMWZoTSs2Lytqdm14bU02VHJSQlhlSG1vc2d2LzZjWGli?=
 =?utf-8?B?SzVuNnljbnZWd0gyam9sMEJSWU9BaEREOGNDUGpkV1dHQUptYUlId1BlYll1?=
 =?utf-8?B?dGxldEVWSFRLbytJR0RSeFN5QXppaTZwanhLOG5WLzVYNFQyZnd4bGNHZjJm?=
 =?utf-8?B?bE80MTlLR1c2cWhsODgrRnIxSGM0ZVpJQ0lJOTNJODRUQWN3TkhUb294MlBC?=
 =?utf-8?B?TEN6bjh2c3VLRjVtUGRKdlJYTDllRC9qN09SRjd5Rk9Wc0hiN1VucGx3QjFy?=
 =?utf-8?B?b3dLT1Z3NlNaeUlhNTFvaEEyalZ5c1lHWmFRZTZjQWtqb0RzaVFCS1BuZzF6?=
 =?utf-8?B?eEJaU0dRenBWNFVFbHo2WTlHcXRVdkpHUWcvaG1mN3F2RzF0R2tISEJ0bStQ?=
 =?utf-8?B?SktMeDRoWnZPNHh4YlRBdU96a0YzWEdLOXRyelJwNm1UbDFuaUNjQWZtWVFk?=
 =?utf-8?B?TVZpSC9rMXVTbUo2N3hMYTVwNVhCalk4WlRQdlBkODQzQ1FYd0lUbEdYRlV1?=
 =?utf-8?B?L2NQQjdMcFRWd1VwS0lMcEN1OVNVYmJLU0J5ZXhuU3RMVDhaUDlENEFiWVlz?=
 =?utf-8?Q?TTChYAnisUhdvM6/q+Bk/gpRu379Gaj/A8qsXdO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ed53f6d-3b40-45f0-f309-08d8cf898aeb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 19:08:12.2522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XWGsRMcx9BM9e4WL9TVbbHgK1xzAgYIu+fmliXKHow2li8YkD0LmztTp4KPPr2vnpObX5O2rzEQthlxwAotah8fuVyTL4aPnLHn6cUY8oKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4682
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120140
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/12/21 1:26 AM, Mike Christie wrote:
> The kref_get_unless_zero use in target_get_sess_cmd was added
> in:
> 
> commit 1b4c59b7a1d0 ("target: fix potential race window in
> target_sess_cmd_list_waiting()")'
> 
> but it does not seem to do anything.
> 
> I think the original patch might have thought we could have added the
> cmd to the sess_wait_list and then target_wait_for_sess_cmds could
> do a put before target_get_sess_cmd did it's get. That wouldn't
> happen because we do the get first then grab the sess lock and put
> it on the list.
> 
> It's also not needed now, because the sess_cmd_list does not exist
> anymore and we instead wait on the session cmd_count.
> 
> The other problem with the patch is that several
> target_submit_cmd_map_sgls/ target_submit_cmd callers do not handle the
> error case properly if it were to ever happen. These drivers think
> they have their normal refcount on the cmd and in many cases do a
> transport_generic_free_cmd plus target_put_sess_cmd so they would
> have fired off the refcount WARN/BUGs.
> 
> So this patch just changes the kref_get_unless_zero to kref_get.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/target/target_core_transport.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 5c4adde96d5e..b5427e26187b 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2775,9 +2775,7 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
>   	 * invocations before se_cmd descriptor release.
>   	 */
>   	if (ack_kref) {
> -		if (!kref_get_unless_zero(&se_cmd->cmd_kref))
> -			return -EINVAL;
> -
> +		kref_get(&se_cmd->cmd_kref);
>   		se_cmd->se_cmd_flags |= SCF_ACK_KREF;
>   	}
>   
> 

Looks Good.

Reviewed-by: Himanshu Madhani  <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                               Oracle Linux Engineering
