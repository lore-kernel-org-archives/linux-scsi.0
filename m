Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F88E92711
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Oct 2023 15:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbjJEPkZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Oct 2023 11:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbjJEPjw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2023 11:39:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397C33CE3E
        for <linux-scsi@vger.kernel.org>; Thu,  5 Oct 2023 07:53:45 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 395CCaA8014451;
        Thu, 5 Oct 2023 12:26:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=mYUzN3pooNVWyrsY3RPlwHYQsKDlN/xZiD3xMlBWDTY=;
 b=Lcj8c0bbyqMARG9dXI6wbBmAGGWFuQFk66h/ev2CtMpm/TYXDsbgJA9MW7AoYM1d50t/
 yM5NuG1ArsjxofRXiMsd9qP1x6ukPBuMHaiF0VYsUA5d3TNE7gqlS2OTO16Lq5NmOtV2
 834FT9BAiN/5vsNRcuUfXdEe1behH3mGQhuT9Sr9VWypK/9fg3gAcYyNvQxY/OIFiizu
 SFJve1rsGqwUnJBGqW4BpVbEzAJzrUNEMelFCudbjTxvtlXTD1qVaQutx8KiTEjT08pj
 5xs9qg5mV2SvrNrZ1KczA6n6vXfXJEHWJKdiVu76+/HJsA5BB34jz9CYG3wesmPFe33x RA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea929d9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Oct 2023 12:26:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 395AZP1P033717;
        Thu, 5 Oct 2023 12:26:57 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea497685-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Oct 2023 12:26:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMAdAP+avdrE6hf+aDEjGyl7pIrk8YFgFe6NN8BjLHAUr2iSvRCzJeWGY2I7d7jRB+jh3ZR9tWu+uBDTS3923GzchbIdS9ZWKh6LtNDjooeqt+C9rN3jvuwpDFammRFSpKdKyUUX1LbmFPnqQLTz9l6+VJIV/4vyD9fZLQ3yRCs3XJPSlLYyLvXlfWAi6D7N7cCwTbTDQ/4aiZKv8l3bLFC/5R2D7KJYbVQ6/yA2Y39LW/H6A0WIlqJwH5K4bnNMJmeQ3/ZJjQ/8YGm/OoMBLoXj0tQYvL+JLQG+j9iz9ylOmJZOZSb9xfoyyC4YEb8bcjOrb6RapAP/y407BqaeeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mYUzN3pooNVWyrsY3RPlwHYQsKDlN/xZiD3xMlBWDTY=;
 b=dhJYF1G8RkHcNmQQZ/CiNdeLBg5seGhmndBMHBbQ+AqQCV7Uk0mrnk8pFF4/jI4BO6MWA7FcV8oDChQcpGf3mJ6dgx7JdEJ7Vy26Y3Ek3yeLnvR78zwKNdCA796i/yu5yv5xL7lm1BnzZURXEz79n72dxh15IxZRddxh76L33+nLmnFURFa7gKe2FqJl8ISv14XWImldQ1ZWYqPIGXqanyM7VKEgFFyh/82WXunPxGswd+/6aYM0gJvLbmAIxgLM4GTNTzWDwIDjESl+oRzjLO3cn5qYAdAamIvnl2Ss4WxVmoMBw68VIFobLiPHsJ9Z6EE/X28Sp93bcvPJFyDFkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mYUzN3pooNVWyrsY3RPlwHYQsKDlN/xZiD3xMlBWDTY=;
 b=Lb1yR06sPqdG39WDZkuFg2gV3LJdaU0run/85Hna8NuoEe1zu1cg7YTVVVVdz9ODfTRGO8/HVNOQArQ1UNvqtQ/j83fzfU9kLLeY0xQjw9sOa56odtfAvmdHKvvKtzNgRbLhZpoHgDKc/yKpxJxPJ6y13z88K8ap2eIliJyqXEQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN7PR10MB7047.namprd10.prod.outlook.com (2603:10b6:806:349::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.37; Thu, 5 Oct
 2023 12:26:55 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6838.033; Thu, 5 Oct 2023
 12:26:55 +0000
Message-ID: <27bf95c8-ee43-e92d-d40d-3a7a2251a566@oracle.com>
Date:   Thu, 5 Oct 2023 13:26:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 17/18] pmcraid: select device in
 pmcraid_eh_target_reset_handler()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20231002154328.43718-1-hare@suse.de>
 <20231002154328.43718-18-hare@suse.de>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231002154328.43718-18-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0253.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN7PR10MB7047:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f9df71f-43a2-45c0-2731-08dbc59e5c92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xGIRV1HG2qSxZw9EpfsH8pzqeWh4LUc6ynzEu7NsbKFz0xsmQk313uSoOGXIbN+sl00p3HOAcEoB3NS8HiKnxceCSVSzjCng1qX8d6YKIjYVY5Eh0x1fKdn4Czlpz8gz1e4a0s5Pj+I5q2OSLdsXx19s/fNCeviepXTHH6+dhbKNwVK4OIPKuVvQoCiCOA/t1IJkQrTAslVk6ZWR1rjJMF2pFlLIAIL4CevnUgrYqsdPFA4o2vQTQZq5dQYvJQIfRrVfbqpVIx0kZyO3bJkNQQ30vo7G+CDzVxLZ4KX7oPzMJTwBdAXc7OgRu3dp/Enl3zIZbmm1UwHiVBKmWV+TsWNmLF6U112qKeEzJnR9FxVBcxMrdo4VcIAT+dNFDT4Gb0tiEZ7lTS5hnw50nZxGSKJiOs/y2ttibidrenN9rMB2t/OwCvZwV3dQvv+x+KZYuNlA2Sety0umZYBo26lMv4r6p/XKSRz1WVB3WXGVEuDmW6ZgTe8LjYnd/IyUXn6HDvhAgMc0o3052j8w0YYgwZQ+PHGGCnqOJRa8bR7t7NICKoWPq+2RGEJy2iCfDKM6S7j1I9KsYLuOzeLAzXgGco0Tx8jVFwXLrSbnOH4G3RgH9A+Luh5fh6vn5/vvkHoSAjOw+ViKoGL43UEbdN90bA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(39860400002)(136003)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(31686004)(5660300002)(8676002)(4744005)(2906002)(4326008)(8936002)(41300700001)(66556008)(2616005)(53546011)(316002)(6636002)(66476007)(54906003)(66946007)(110136005)(26005)(36916002)(6666004)(6506007)(36756003)(6512007)(38100700002)(86362001)(31696002)(478600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OU9KaU1LYnlKdHJjditWTy9zRG5TWEdVM25RNFlRQkc4dHNJNTc4ME5HWjdi?=
 =?utf-8?B?UEl2ZXk5d05SK3ljZlBsWVNVT25HdkZkWUc1T2RJWEY0NFZiRzY3bENZZ004?=
 =?utf-8?B?V0xQcHRuT3Era2lzUnpCNE0zR1FVL28wOFU2UXhTQkFjei9STk44d0Q3RWc3?=
 =?utf-8?B?QmtmYWwvTTArUWxYaUVMNlR3cC9tU2RBWU80SzJkcENwL3A2RXQ2YWtMQmRn?=
 =?utf-8?B?bEZIWk9sK2d2bVp0bzNMZXZWSktlUHMycnBmUmtsL3pLb1BhbzhLOHZva1lH?=
 =?utf-8?B?cC9YRnE5bEFLV1FvbE0yb0pHQ0FvWENYazRhQ0pMaHBTYW0wRk1LNDNtVmlR?=
 =?utf-8?B?eEpCRWdhU1o1WU8zMU9yZkNDZDFSbW5USzVtWDRnalQ1RmhmN0RKaVVVbFh4?=
 =?utf-8?B?cnBuSDd0ZWhkL1BiMnh5VDdreWVqQW1rN3FWdXFCbGUwMk1sZ3pOaXRIQUVG?=
 =?utf-8?B?Y1VaZFZ2clI4eXordVFFK0xiTUtsNjMxZDBNaHFGYjE5Qi9GcXFlK3NtRXk5?=
 =?utf-8?B?dWRINXYrRmM3WU4yM3JlMEdTejRQcWRDT0hKNXlvWFdaWG1qRWRtdnlrRkZm?=
 =?utf-8?B?Rk1KZ1IrVXNzN2tvUVZ2TEM3bkYrM0JZZm9QWlZ5bmdBSS9raHcxNFFiYWxJ?=
 =?utf-8?B?ZDMybVlVb25XWTBubnN6dUJVUVp0N1hzbVhlT0I1SG5FMHV0cFhKNDZmbEls?=
 =?utf-8?B?bmNCVmdLT2F6Q1U3TS9EcmppZDRyb3prN0RNb2hqZytyczRjclM2a2dIdmN2?=
 =?utf-8?B?dmlDNVd0RUZEZGRodUFjUmU4elJLT1k5RTNNQTgya1Y5L2hxNkE3Vi9LQ3RG?=
 =?utf-8?B?NmE2SVBKRDR5eUh1ZlRkV3hnb2NZWnV3bEVrakZYRTVpNVcvZFIzYmNDZnY4?=
 =?utf-8?B?YUNGZmlDTUZrbWdHcFBoVkt1VVB6cFNNSnhEdmc3S24rZk1OemZEWHpURktF?=
 =?utf-8?B?UHNPZFBGODN5WXBxSWhZN1RYRkovWXRUQmpYUUlnZVdIZ2d4STFKTi83TURn?=
 =?utf-8?B?VXk0aVE3c1piZy9XZzZmaHZ0UFRnOTRRVlc3eE02YmUyamhjT1lOVlB6MUZM?=
 =?utf-8?B?cTlQb0hib3pBdSt5Y2x3SkF5NUZibXIvekl5Tm9FWEs1MkxWcTJsOHlUUlYx?=
 =?utf-8?B?WjNjekoxMzNVeVRYVFdnbk14Y25CRFNjQXNDNmNWRVZDRkUxdVRQNUZPZXF6?=
 =?utf-8?B?Snp5VitSUlhVektjVEdUaXFveW95OUxlWXZScHRoc3ZGT1VpRThqTDUzcHVM?=
 =?utf-8?B?V1FJN3dMNW1ocHpIZDEvaGhjVjVRdUNTV1dTK3hEakRPbkZkRTNYUFdYQzZO?=
 =?utf-8?B?QW1SNEI0U0toN1puS0svZWxvZXB3RE5FL3NnSGFnT0JsdlVZSXhGYVUvNGFB?=
 =?utf-8?B?elNaazBXQzM0eTkrU0VQVjBDd0xlTE8wdWhvU1p4K05SYlJaVWZZbDA2N0ZY?=
 =?utf-8?B?UlliTjZNOU5zTy9ndTg4eDl0akNpV2p2UHJDWmd0Yk9DeklIOWhtOVhTSzFt?=
 =?utf-8?B?dWNMaTBnRXNhNHRVZk55SzVVNWJlSE02RFVET2FtbWJraFNMcWFiVnJwVEJ3?=
 =?utf-8?B?cm9CNVlINWRkZXpmOUtoWDQ4KyttMDdUVFV4eVE4WC9JRkF3L0NaS09PQW9Y?=
 =?utf-8?B?Q2NENFI1NHBqK2pFN1l3ODNYdk1CUmxZZG9RTEhDTjJjcmNUYUc4UzNZTGh0?=
 =?utf-8?B?aU1EZUs5VFZsYklVNTl0ZkR1N0I4UEVMSFNWS3Z5WTc5NSswWElFclZoZnlI?=
 =?utf-8?B?QUU4MnpoRHgxZXZrWkVpdXlNZkZLdHV4b3RlV1ZJajlJRVFPUzhXdC95RFhB?=
 =?utf-8?B?bFVCaHozWlc5WTFqN0VYRmlxckFsMnRFQlBmaE5vcmpwYUxmNjVWZTFaUGF6?=
 =?utf-8?B?cExLSkUyNE1RUHpzRDg1ZFkwM0pCMFBoeEloN0l5MVVVdVZReU9jQWdCMnZL?=
 =?utf-8?B?TnpoSWRGSS9qUTNVTGN6Zk1yazBFeFNVRjVEdFAxS2JtYlpjQ2ZLVzU5Zklj?=
 =?utf-8?B?cXdaZk0reUFrUjZrOURYbzRZd0FpV0VPaWRDbWhrdWhkdTdaQWpBaUV1Wjhs?=
 =?utf-8?B?L3pKbGQ0dzM0TTRQUGxKWU15WFpiSHVKWll6cXA4ZXNiRUF1Y1lDemJYRzd2?=
 =?utf-8?Q?bAKbWbO9Xb9rWkIuaNcnte0aJ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 73LWNY+IrErQaAZyPhv+RpyyOqaOP5HR5rpkK2AaKedTXIPHMOKBK04k7lUp0xZkZr0HPHQy2cf9WzjaoXhW5IIfMiIwREisP/sEAD22J5YZYDvaqRe0TBwaMMGQ79jB97J97KWx12z779EDeXJ+4F1tg+8bCb30DNYaeOXQYWddKHJ9nKqrW65eT5WLEV8p3DaxFB5o5aZYBMC0+l38PmaOIfx1K3dppgCHeP/R3wNS9eFzPz8NdkHeTwq22PgevRWKfae4qcx7XcyQXmyxCrkJ5cT0vYoPqtsPZ9Q3xEMDjXO7OsPyNfhmsUAjITLGsUT2WrTliBgDekQ6tUS58yai+sX0alUMfYbvMyuB3xQ2wgN6zIsz1JcUutyfnychJAl7c2UwJI1vaB7+CD8n6N3Ivytg++QZRZEX1Z35Ed187stiP0dYKSB5bID8k2EzM3oWnzdLT9ihf3mLuEt8yt11BbFYUKcFP8MPD4iy2df0O/JAuoAzSuwahL99hs9evHLoPGXVRjAfXJ5fR/kaoQoptQtwzdHYd18V9a1B6ug/h+fCWj4piJjBXoYLsFCqEa0wHyvmyVIxfTnQzqDx/lfXdl2f6f7eTzVlwKBozfzoA+PBtpbBI0Np6gmwOf1SfGygmr8lpai0YNX8eazO/1108L+aoTMuvT5Vsmd8x5pytj0kFJtQraKlIU4GsYnW6/Mb9W7X/KQLauUTv983ZklZacjILwmV7b25XNBiofWbt6VHJ4k3XQMpQ9tN3ZiLI7z1VdHWQC7BjsaMpOr4U1MbOlGnFIehAHL9wQoTdIU1OdfGi0X67qUbwgqkjXgy9WwI1fPwvHcIUWlcZmgVeZyCvu89Hd9TH6vOaXqUnFI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f9df71f-43a2-45c0-2731-08dbc59e5c92
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2023 12:26:55.7386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zu8gs4OqjWUdTriNaxG50U993gqmNlrna0eboB3YmbKXc7dnO6YdlYg01W3aVY5NTtxX7UQmJc9j/630O/fo5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-05_08,2023-10-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310050097
X-Proofpoint-GUID: ad7wcAcXvCrj-aRrUaQp7cv_ew8Pat3N
X-Proofpoint-ORIG-GUID: ad7wcAcXvCrj-aRrUaQp7cv_ew8Pat3N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/10/2023 16:43, Hannes Reinecke wrote:
>   static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
>   {
> -	scmd_printk(KERN_INFO, scmd,
> +	struct Scsi_Host *shost = scmd->device->host;
> +	struct scsi_device *scsi_dev = NULL, *tmp;
> +
> +	shost_for_each_device(tmp, shost) {
> +		if ((tmp->channel == scmd->device->channel) &&
> +		    (tmp->id == scmd->device->id)) {
> +			scsi_dev = tmp;
> +			break;

If you break out of the loop, you must call scsi_device_put(sdev) - is 
that missing?

> +		}
> +	}
> +	if (!scsi_dev)
> +		return FAILED;
> +	sdev_printk(KERN_INFO, scsi_dev,
>   		    "Doing target reset due to an I/O command timeout.\n");
> -	return pmcraid_reset_device(scmd->device,

