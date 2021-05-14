Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53372C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 14:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C6146145E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 14:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhENOBw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 10:01:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbhENOBv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 10:01:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14EE0N03098683;
        Fri, 14 May 2021 14:00:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=szPg5v1FpomrvMkpSTuzSeK7SLUuVZNx596yl2re8/0=;
 b=qsRbs9kLyjPfWyU65vddh4biPvNYqhNPPjoF2sWW+EbV5wAviREwbfHZ9F/HtShC+RGt
 37c9DLZOKagT6lUkFqGHeQKaxoOdQSnqb+tq74O0cXs0ZEsT6A/F1BAbaaP62fs5QHR8
 pQXE4tEofA5wv5OYdZY1mP+gy2yoEE7AaxjodFnRruOG6TPB3UUxeVaFhe3dY8l36q8x
 ELDVJw5FN0meQA4BNW2LubNWCxXy5a3MYRVcv9MIjIm5fejjDkFbgoCjuVu4tVJMXgeA
 1wrrAhEpvHnufKASc8/r45rK4rSAv5rPxCdDuvo+MfrGcICgufHruqPjbGcKKUA49lIq Og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38gpndcdrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 14:00:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14EE03vJ089761;
        Fri, 14 May 2021 14:00:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3030.oracle.com with ESMTP id 38gpq347bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 May 2021 14:00:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAASWyqvA7rFqSnKwZjDXV5rlavgxSODBvQdrzx7hItXIJVhxv0htSd6R3EXRxE2pNpBvYoDKs4J6EUfPsSrMsyZDodTGN08wGik53sYIhbAcOnjZrjv6qbwAAv2vxUwfQ5HqJ3QfcSYCU7xUP1YuignDSRGVqtWDO5L5LOVGCllQWmAfBnpaarHl0yuyhg0xaqWuJe/D9ChwopfURsUWIxX9bi3D3T5WYgnxhQgBm2CQGZzxn5vCJ/ucqhphTApfhLUz0Vb27Kc3EaSQcJmCWfCzzZR6hFK+EzyV7oBUAOQKuFpq6yT1kKyYyP4vtaIRLbr2sWfRrbXVh9DyZq4Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szPg5v1FpomrvMkpSTuzSeK7SLUuVZNx596yl2re8/0=;
 b=chTinBUJCNlRaGmcV02pwPtbkmBC6A6E+QtnzWkG0ET/6a6itOcwAGw+My2TjSaHVpNDlv53ugKK63CWW1JYGS/6IUuKJzMBvdfcSib4ZqFPsg1PvOpLVOz88zrSDeLlTKZwXj5Fzn3F+fZvD7LNJaQ7+niscurjxh9360qK09Ql3J46/hJhZ4UkzZGOzeC6yVvEnywZ3R8XiUXom45eR0eBQDmLpWb2Fd8m09W3nFHqUNT24cmh3vUbIGE/vV567wN3PJIEjzVNizxWa/DNVC0EnUfbt65MX1KKHLBuF65IGRzQLnks4iE3N1nrt+oQAVNBqbO+d8G4AYJaeqZTSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szPg5v1FpomrvMkpSTuzSeK7SLUuVZNx596yl2re8/0=;
 b=GOm1aonTN/wSZnaBHtYc9w/LbrR97a2oRG4z7c++v3eO4tl66hLAYSRsgA3/urQ42SecSa4aKO3zWTgjKEQTj5fsJ2v+jOQyjhfZnIxYF4SvJDCBVubIStGfi4PnwmmvokVUGfOmuZ/nG6BkByr2QeFssOxna+a/r5D7VysWaAw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4538.namprd10.prod.outlook.com (2603:10b6:806:115::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 14:00:14 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.025; Fri, 14 May 2021
 14:00:14 +0000
Subject: Re: [PATCH 1/1] scsi: qla2xxx: Fix error return code in
 qla82xx_write_flash_dword()
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
References: <20210514090952.6715-1-thunder.leizhen@huawei.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <adc45319-21f4-db03-89ae-972ab17b5172@oracle.com>
Date:   Fri, 14 May 2021 09:00:12 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
In-Reply-To: <20210514090952.6715-1-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.143.106]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.54] (70.114.143.106) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Fri, 14 May 2021 14:00:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3762c7b-59ce-4395-e922-08d916e098de
X-MS-TrafficTypeDiagnostic: SA2PR10MB4538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB45386E39F731EC79538218A1E6509@SA2PR10MB4538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aaFNaP3QWYhey3Kuu6lGKKerUNDPrbXzzut15l2AOO1lO8BfPQf1JQxvY3KaSQIwpEDJTqHqHUX4y7Gklpm7CVWbCrlbu3EOPlCZZcQ6Wuxu9drQrtiUdb6nGFBsfTpKFpPwv2HuEhF9u2sBA0ejvE1uRjFBgiBiy2TysuWvzP4qwkISX0L9a0zIem5cfQIjOzVdtjF709EA+af54TzBXucPkcBrG+1Nbet+gn4iNs+/MiLl7cT8bwhU2vDOLABWkgKzWG6G/lH4taeLNY2SBwNm2ohkFrciTGFUeEEaYk+rC72Xz/vswjyIxd6PV8YMY137dLHR5pIwBBKnMJPxFIV4O7jPiDMwGau+oDH4TIHim0cS9xBZTidEEHuEr8u5HXhd1PqvsDdPft354D7pgBaFcSG3NQgtY2kcu5hmBJLuzJyoOhsV9xpzgjTCGO2mBMSXG9UvJ0Du7BKC4lVAFJ9KIUkeIfa976D7QWACDS4xmTeADiXTOulXZdbI9dT3YaDTYpgqeuVyPncl12kyd2MyJClftWAcUBv7xe4c0VMCCiQMnIRkh5K4bddYwCFr85JfoNKLPu/2T9KTEP6cSWMriUDftlqJhM/rO3ydhoNhxB3gEA7sGCE4bTxi/Fu22QT8cUvx+IAjUTMTErKh8NW0RERwvunW1aE7PiXC5MNe2GyRHknifX4NYDwrCXX4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(66476007)(66556008)(66946007)(36756003)(26005)(86362001)(478600001)(31696002)(16526019)(16576012)(316002)(36916002)(83380400001)(2906002)(186003)(2616005)(8676002)(31686004)(6486002)(8936002)(38100700002)(53546011)(110136005)(5660300002)(44832011)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eXQ5c0wzb0JUd09nanFHZS9GR3EzUEhGdXNDUEQzdnhLQWMxWmhVd2tSZE96?=
 =?utf-8?B?WkpKc0thU3ZFOXltbHJlYlRnMUpJWEF4NDFocEUvaFlNeWw1RTFnb0JwYWRF?=
 =?utf-8?B?MWhHVTBqakdSdUN6bVR3VFdtUkhHR0Zjek15dDE2d0xOZDdqRHYxZmFxdXlK?=
 =?utf-8?B?aDVJSWVkcjIxQUVpbVEzbm9weSt5NFgyS2V4cUNwR3FzS2U5WG1TeStvNGwz?=
 =?utf-8?B?RHpNSUhOM2VnbElmVU1YSkE2Y2dDc2xaRGtKRWdNaUtmVHhRVUpmTC84THNr?=
 =?utf-8?B?OTAwaXMyK0FHWDVCUWgyb2oyWktNV2VmMXJQZys5V3BxQ0NCYUJpL0grbmRG?=
 =?utf-8?B?OFY4bWhiYU9kbWV2cko4aUMwVUdreHlNbEZ5azFWY3lUTytEVVhXM0VEMlpV?=
 =?utf-8?B?VDdlWU5yakcxdnM5Z2FWSWRWT0l1TUdYZm41SDVscjhQM3RHdmhxQU1QbU95?=
 =?utf-8?B?MG5vRkJaUFRRTFl3TnAwNjRWNWtCWWtneTU2cjBYVk1hemF5UlpTUHh3b3Q4?=
 =?utf-8?B?RlJ2WS96VERKdWpBR0p1dkxwZU1OY1VnZlNkMGs2ZlpScWxOeTRCOVVxVElx?=
 =?utf-8?B?S1JwMjJyTGhQNTdaKy9HSWVMMFZodG1RbGhBRUQyeVZ6ek93cjYyUE9HUTMv?=
 =?utf-8?B?K3BLa2hueDNpUm1zSUQrbzV2bW9TdWlZVUsrMVpjSmpUczZvWEFXa1EwNkRT?=
 =?utf-8?B?TXo2VldUN1MwZkw3ZkpTK042cXFHMllyRWtDTktLUlZ3YzNKOXBTaWVsRWJ2?=
 =?utf-8?B?UHdIb0NzdFpZR2Z4bWVrekZzOE1kUzhzbjF1ZEprK1JXdklwckQyT2lUTEpM?=
 =?utf-8?B?OHNwUU4xdFk0c29JbzNhTHBBOFZLUjRPNmtwQ0U2WHhpbG9yc3pSRUVCN1dq?=
 =?utf-8?B?cTJhYy9HWGRwUmtPZjMxazc1WW5jUk8wMWZDUnpkV1l5NlJjYVFQYmduVXpU?=
 =?utf-8?B?WTBrUWhRcXJIQ1JjQzNaSEtnMmphblo1R3VrSTVsVHQrcVhHMWh5SzZHQ25o?=
 =?utf-8?B?dHRaSlJnYXFTQSthOWg5M25RVUZLbUhLRDJIbmxHaDM4VnRHcE5sL3VGc3dB?=
 =?utf-8?B?NFZ2NmVockR2NC9FMVBCNFFscXY4WFg2ZGFIUkJLd1VPcEZnc29UNk5zZVJL?=
 =?utf-8?B?RjQ3TVVKOVphY1dONnZYakdvK0owSjhOVzg1K1ZBTVlBeWI4cGJ2K2pLeEFl?=
 =?utf-8?B?ZXR5NGdsRys2Rm91bDcwM1NIUVR0K0M5RllpM1R0T0VGdzFBaWJnaDg0VnMx?=
 =?utf-8?B?ajhQMlY5aHc1VCtaN1pYWlZ2dnhOUUF1czFTcXgvVHRPWHMvdTRXY0ZTYnB2?=
 =?utf-8?B?NXovZlZqMHlYYXFyRjJKRnh4MVJMSzZvZXhveUprMld1OUVhUm1HVExOanQr?=
 =?utf-8?B?ZUVoTExFR200WmxONmlGMis2VXVDNVM1V01sZjBQNW9VRlorTEhrc1RRaVl3?=
 =?utf-8?B?Nm1PZVZhWjBDR25ZZU45TXQ3bG1BVk1KTG40NFZMWEVWckhmWjVTL01vL0sw?=
 =?utf-8?B?Z1pMcjlpRHREQlVCUnhQLzBzS09qclA4WmF4UDhkRU5wazh1YzNNNS9VaFJY?=
 =?utf-8?B?Z254RFJGYkE0YXVxanJiaFBGTVZsdkYvcllxNnpQMDMyelJpUnFiMVNNd21q?=
 =?utf-8?B?VU5qMzU3TnROZFl1L29HaUZuVWFFcHc1dlUyT2VlYzJQTG9ZcEI4MGpqalpY?=
 =?utf-8?B?bll5NU9uY0ZmekEzVTZXam9UQ3lsS2Y1WTFrN2xpbUVOSkxSdDg2TWxQL0xV?=
 =?utf-8?Q?8a6j77omPh7s/xNPmkWVT25OrlLYKepFCl26hq/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3762c7b-59ce-4395-e922-08d916e098de
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 14:00:14.4056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RiyhQfJs1ObIylYXJHS5pWzk74Xx3b03KO5VhzJIiLjn8VogXWG7Ef6YSb7k0WEqNz7NP8XkX5fs1q96q6C525WEi4Cdb5AbDqExKVQe91s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4538
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9983 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105140113
X-Proofpoint-ORIG-GUID: ih6amFNd8owNNlPoRAMfy5__gQCD8BCu
X-Proofpoint-GUID: ih6amFNd8owNNlPoRAMfy5__gQCD8BCu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 clxscore=1011 mlxscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105140112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/14/21 4:09 AM, Zhen Lei wrote:
> Fix to return a negative error code from the error handling case instead
> of 0, as done elsewhere in this function.
> 
> Fixes: a9083016a531 ("[SCSI] qla2xxx: Add ISP82XX support.")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>   drivers/scsi/qla2xxx/qla_nx.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index 0677295957bc5cb..615e44af1ca6043 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -1063,7 +1063,8 @@ qla82xx_write_flash_dword(struct qla_hw_data *ha, uint32_t flashaddr,
>   		return ret;
>   	}
>   
> -	if (qla82xx_flash_set_write_enable(ha))
> +	ret = qla82xx_flash_set_write_enable(ha);
> +	if (ret < 0)
>   		goto done_write;
>   
>   	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_WDATA, data);
> 

Makes sense.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>


-- 
Himanshu Madhani                               Oracle Linux Engineering
