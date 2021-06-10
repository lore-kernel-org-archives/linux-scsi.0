Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6DCC48BDF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 14:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26C57613CB
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 14:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhFJOe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 10:34:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42222 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhFJOe4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 10:34:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15AEP1un007555;
        Thu, 10 Jun 2021 14:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=C/GquIx61qCPUHufmmpWNUwXM2cbBFwZ7YQMEOo5+Gc=;
 b=SqZYE273rq2w99CEoTvwUpmS53AXfBdPpWW1gercVF0GthlJbzcVhaem49DOkkIwVpe9
 oDrrRptY2jF+iCJ2Wvn418szwqpuuhBy62YvPxgRngTmS+pqnJftJe+BDVan23DicTHb
 1j6N32+6eFbYm4Xo+xyGVSEBtacTrvDxr8/7NTBvuj6DuR33fPeGaVG9mUv56PQKdwHL
 JI5otFvCJ2NUU6dT8+i1iy8s+mM6sGPMDSHDisJU7Od0erVg1M7BsD7DTtExGUjy4x21
 o2vAnNNUNaSI/THSVpnDOoXBuZo1lkhdU9cf1XOTUenKvgRlGf0fCAIkKnH1h1gvpoYm Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3914qutq5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 14:32:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15AER8Df043299;
        Thu, 10 Jun 2021 14:32:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3020.oracle.com with ESMTP id 3922wyg9nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 14:32:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QIMPkCaoW/shSomQqqJQPRMqH1wtkMlm0JucpsfwNrtLKJqiIpaKtFqMWYWJHFOeHuENAPrQcKFljCfCShBtChALxqq/aC6y+1Vj4+EaE1KHP9jXQLJSibZkqAAGgIb3Z9//dofN/jK76SBoYgmvxCxro5ATR95/WhwbQ91i+kzW2+GtrF+3HN6XyNXKf3mJ30Z3rVMLZHd8dGhmkdnisAd4ql1P7xFNY0/haKtxXSMdT4ew9whaJGdw17Ht5HKOwEqQO1q+9KTXXSEUc3hs1wIDxeTarpNoW4CTWeiTKkHliVkCAJINAlNF5NkgdBcT9ssRj7CY55TvVpruSx6MvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/GquIx61qCPUHufmmpWNUwXM2cbBFwZ7YQMEOo5+Gc=;
 b=jJVrL2hYsUqciyaffNmPf3oVZb9kDYrvEzgnFRxRHwNromB6ve/vbXFLoymjlzX/LsIhzvWPVlJAGIXkkLvVkByb90cZ80iNufstOQSkiAUt3Mr3QZLPSE8ljVZQltnEJgo1WaygWHmyVa5mkHK3k6v0n1V8Inb/ZYjYUBGSvQw8wkDIqJXaQTdDq5kzBjlpQOPiNIXfQlyyrJltfYrb86bINGq8BS9em/7dO/dE+7FdY6rHNS480e8mCs0Jx+aTHf0OSSkN4AwpMFIWCH5Hi1EouzhBaLUyrwJJU14D/wU7Mh74fQtbhCOqhJuWmx3yUqyFR6Tonf5gB87OKPD3eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/GquIx61qCPUHufmmpWNUwXM2cbBFwZ7YQMEOo5+Gc=;
 b=zhZ1g+xJgbrqSgZl2hQ/8yITwcXgrvbwDiOKD+iuCj4uqk+JO7nfMGFttYDvGtMSOC8ZEeOXHglXQEYQnXwyTw8H7sFus0J25jopY5WqmYUlGzaDj+kbu/L9FqGb3c0IL1bmK7O5J4pGUmzFvtrUbAn3BsUOGLPJJ7WWVT06qIo=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4602.namprd10.prod.outlook.com (2603:10b6:806:f8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 14:32:15 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4219.021; Thu, 10 Jun 2021
 14:32:15 +0000
Subject: Re: [PATCH -next v2] scsi: qla2xxx: Use list_move_tail instead of
 list_del/list_add_tail in qla_target.c
To:     Baokun Li <libaokun1@huawei.com>, linux-kernel@vger.kernel.org,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     weiyongjun1@huawei.com, yuehaibing@huawei.com,
        yangjihong1@huawei.com, yukuai3@huawei.com,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
References: <20210609072321.1356896-1-libaokun1@huawei.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <df7ef907-815a-868d-006b-515c3bceeed8@oracle.com>
Date:   Thu, 10 Jun 2021 09:32:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210609072321.1356896-1-libaokun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2606:b400:8004:44::12]
X-ClientProxiedBy: BYAPR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::31) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:2001:91:8000::cda] (2606:b400:8004:44::12) by BYAPR05CA0090.namprd05.prod.outlook.com (2603:10b6:a03:e0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Thu, 10 Jun 2021 14:32:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 077b7705-fd64-4ef1-836f-08d92c1c8b0f
X-MS-TrafficTypeDiagnostic: SA2PR10MB4602:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4602DBA4D8BD0F7BC7714716E6359@SA2PR10MB4602.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 19OGKvGb8xmHHZR4M7FIX+bR7dEpF/n/PYTVd3Pbfo/9On02BruHQunz+oiUNyFPZPSTBiFAiVgoiVa6T3bFq1fdwY1HcBGqLdzONQQTGX1PQDEhdW71CWisA6yN+HJv4EFlmbHKAAWOci9kDwvkZh3fhplGVzYpgxN+qxrKg0rg28c7QiUQ8Szoxivbn87WBKwQtpDQjv1JqczDf1nkdzx+ArRjm/LPBferURYX5KcR64uqBC5HNE3Pg8Nl2eCemStqDmkpyv7vFhUH62mZy0CXaNmCqH41u1+Q1cYOBXcTby+eAJjse0kEPj3C5ULVktNO/JL6dvlKea1IfHQlVkEetqIrs/z/nXKEoCDqmv473JwvbrkRnZ/rOkIM31bxTZHfm761AmPwqMViZOqU0tKPKmGxs0/d2n8Hleqm+oJzaeOXn3SHJQDhdUdeQOCY3RazoS6y0JmitcUIjGM96eIydV63/1mUxtUaHNdCAcws2ewvQFZRIULRm1gq0CJj71PuVQXHcUIToT+GhyvzoxWJG0TmRdde/s8eRWZBxKeYoIKPhBP9sTzipGfy+2/XqoUtcbWkXoHNolCJhRL4SJ9Lpo1eDInFFvseUhYyxF9fk1Usp64uK2FvZ9H7fFDxOn2EdePpT5VcfVXgZXqiTvH3+mFAo6OdiTtTvCRjaP8plgzo/2+O8XLzmp0mHWjI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(376002)(136003)(396003)(2906002)(316002)(110136005)(53546011)(38100700002)(5660300002)(36756003)(86362001)(44832011)(478600001)(6486002)(7416002)(31686004)(8936002)(8676002)(186003)(6636002)(4326008)(16526019)(36916002)(66556008)(2616005)(31696002)(66476007)(83380400001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2J0YVNjczNRSWJqNFEwWnllTUZZSG5VVHNrL0RyZWR3UDcvcEhQRmVLNXJq?=
 =?utf-8?B?VnpydFJESWUxeVIzY1A5R1YvRVUrN3FVRUdtdHExNU5pUkZ5YUkvK2tyM2d4?=
 =?utf-8?B?NmNtSXFYZUdYRVZHT0Nub0IwUXR4VnBLbmpnVDdjbjVZRWh3alNabjlRbXVy?=
 =?utf-8?B?QUhxaEM4aXErYmdTV2wwMGtVK2tIaktnalRRMUtvbzNNcytHek1mNUVteDZO?=
 =?utf-8?B?eldRRXRiaW0veHhFU0J3NGIrdHloTFA0ZWJoWFdKZW5JYTF1YTU3cGJxS1ZR?=
 =?utf-8?B?cU9hSTE4akJ3V0hET0xheWwxRlpUVTNPc0RLWUwydWRWZlIxS3Erby9WVVVM?=
 =?utf-8?B?eWcrakFKTzdsT2FFdHJZazZhaktXOC90dlJLYk1YbDl0SFlieEdUZkU4TmVy?=
 =?utf-8?B?WWJsUDZJUlJud3QrUTl5SnZhL2dpYm1MWWJHN2hMZTNFWUkybVpRcVBLQWpQ?=
 =?utf-8?B?YlhoYVp0VXBMSmhoRUU4N2ViUlB5azhKYW5qN3NyTVE5ZWNaZ1pLZ2w2SVlM?=
 =?utf-8?B?WndYT1MzR24rNS9ZK1N4UVgxNmdqbzJNczl2WXV6N00zRFlGODBxT2NuUW9G?=
 =?utf-8?B?N3BMQW1jWm5kbThwakVRd1Uvb0NhV0VVVDB2NW9UaUlFMEVXMWpXdUFtMk9l?=
 =?utf-8?B?YzVJRXFzVmVUREFuQU44UXo3bjRwZER2M1ptSzZKOHdJZjdSa2U5YldIWmJK?=
 =?utf-8?B?eEd4TGovb1hqSnBxZGt1ZmN6MHVLRjVXVmJOUUI5L1VFVHY3cStJTVlKOUoy?=
 =?utf-8?B?RmpwYmQ3SlpwQ0NzVHc0Q1lreTlUUVl3RmRhNTMyNnJQU25lZ1R6YmtHQllr?=
 =?utf-8?B?VkRvY0hkdmRXT2VOWjc5a2ZCam9GS2NOekZybkkyZmxtNDZ1dFBqYVJUSytD?=
 =?utf-8?B?dkcwelF0aVQ2QjR0L0hxZ1g0cDFCcWZNd0taMG5vWDh5WTNaa2t4YWFoYnN5?=
 =?utf-8?B?MGlUNkIrdFlLNFJDZ2ltTkQ0aTFibk5na3JuekZyK2xHQUlrUjNkbTBGZjY2?=
 =?utf-8?B?b3EzajhadHU5NGJxa2tBY0xoQW5wMG4vNEEzeUp3SmNJN29CbFdDVTRrY1Ji?=
 =?utf-8?B?dDRyRER1UXk3dFF4NitwdnJmSWZDdzZtVWphTnpCSzc1WU1zb1U4Mm1kYU55?=
 =?utf-8?B?dGVzU1VFazFqTUdiS1FqZTFuZ1lsRWVIQVgzSnAyWTRzV0tkV0NwaE5OWnVx?=
 =?utf-8?B?SGgrcVB2U3R2L3g0SUwvODdkSlMxWERZTXdweFBwMVZDaWx1ckRLSEw4TEVP?=
 =?utf-8?B?eUJJVlpuZVNjNC81M1JjYmVuV3RLTFhjQ1FBNmJ2TmZrU050eFZjdVhOaFl2?=
 =?utf-8?B?cWtySDlUQlBOaENxUTJnb3NJbTgwMmFpYnl4ZERqL3YyZDZZYVY2NUtBU3kv?=
 =?utf-8?B?TE1odnlZT2VCb1Z6ZTJXZUNTWnkzaXlzNU9lR1lHMFFTZE1oWXU3dWhHNHZj?=
 =?utf-8?B?YVFkazdZVHdONVlGbm1YajdrYXJpVUUzOXJuRjNIQ0VRdENQMjB0eXMvOENj?=
 =?utf-8?B?bEN3OVVhNlRXbXpJZkhMUUlMbFlYQk1OSUJmSTZwbE16MEJuMVVUQ1ZMbTdk?=
 =?utf-8?B?d045V3pKUUExOUlXaXh4a0JjWGNWN0R0Mmdua0F4UHdzaW9HRlo4eEZNSDlU?=
 =?utf-8?B?VnRnMGQvdVpUOFVvNmxpczFsZUNURkdBWllWeDE1TE5aQnR2c2d4NkJGVnpG?=
 =?utf-8?B?Mjg5bVNVNndQbzhHUmZkeGxtOWNCTTNoS1luQ2JoZUZpZnVPdEZnQkpXWGJ5?=
 =?utf-8?B?ZTFKaUt1L092Mjg1YXFHQnRkcEVKQUw4ejB6NXZNTUsySjl4cHhQSVlMYTZq?=
 =?utf-8?B?VXE2TEErcnNaNi9yTWFqdz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 077b7705-fd64-4ef1-836f-08d92c1c8b0f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 14:32:15.5034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RPOm9+SXwTAIFgPuR7zr1Jk/j8WS4DVnV9Vvbq0lKRtMgVngTU+xxATYZrqgkdiA/48xF0J0bt2GMC2N5FkcGY2ZVGXresZpdd8l0cBarwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4602
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10011 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100093
X-Proofpoint-ORIG-GUID: ioLiT_Jgk1GnfR2RA0mE6Y-kUt71ClFi
X-Proofpoint-GUID: ioLiT_Jgk1GnfR2RA0mE6Y-kUt71ClFi
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10011 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100093
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/9/21 2:23 AM, Baokun Li wrote:
> Using list_move_tail() instead of list_del() + list_add_tail() in qla_target.c.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
> V1->V2:
> 	CC mailist
> 
>   drivers/scsi/qla2xxx/qla_target.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 12a6848ade43..eb47140a899f 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -5481,8 +5481,7 @@ qlt_free_qfull_cmds(struct qla_qpair *qpair)
>   			    "%s: Unexpected cmd in QFull list %p\n", __func__,
>   			    cmd);
>   
> -		list_del(&cmd->cmd_list);
> -		list_add_tail(&cmd->cmd_list, &free_list);
> +		list_move_tail(&cmd->cmd_list, &free_list);
>   
>   		/* piggy back on hardware_lock for protection */
>   		vha->hw->tgt.num_qfull_cmds_alloc--;
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
