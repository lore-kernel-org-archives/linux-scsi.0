Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1266E92706
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Oct 2023 14:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbjJEOqE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238629AbjJEOno (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2023 10:43:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DDF6988
        for <linux-scsi@vger.kernel.org>; Thu,  5 Oct 2023 07:20:37 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394NcgXQ014834;
        Thu, 5 Oct 2023 11:14:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=SSslIO51cqS2Sa48dwmLQUt6y5RHVNeeHnYZLq4W0/o=;
 b=n1rNhEhBQ0oLfxsP7cGdfa7a+PC2cJbWmkb8wlDbKJ57pk74V2zBhyGfg+nzEn3NC+fh
 X4Q7rGW1zjnk+nmI0sgo+kfhHsbzjdIFm/vIYwJdHrhSo78uX778QXOYhbBlsb7siPOQ
 nOGzrIUUYQoUyB2g8xupLn7WkkvtWYKie3mrf4hFlBsmgOm3geRbr+XrhaMw/TpeMAsr
 oyDSgV16FtppDP0//RIQ+NBiQ5HUufGh5ry70nKznV7nO3fSlYjLcOsXGdxQ3HADwU4+
 iIucRxzS4IRS/wMvR9ZOcTZrayqXZfPPCjTafM5K9NRUqL0iqxGoBP8CdXOpe0XVHsJ2 vA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tec7vh5hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Oct 2023 11:14:57 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 395AqBeL003056;
        Thu, 5 Oct 2023 11:14:56 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea48xce8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Oct 2023 11:14:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7sW5Vl8MKhv26vNcFdsKsLHGH+WXdcVNZJ9oyCfqVjbnr2bwtqr/U6tVf5UJ9rKZO7qIU4K4Vs3UXwSAfQkC+JRSTsUvAyoVwXUHVmZPA8L5zKl11QkSKQYEJwVLvxkUZVnc6eLZBEHr4HiHQTvR+MldRGGeH1NFvABtwvLslAvG3zv86A075ZHj3SWPalLmKzdvk6r0YBC/SrxHV9S5zjyxWzDyZX20/KZf93Urw/749aZdt5TC/GNANd+jO6M22xu0EJvJMCXoE4KWnvy+7/xby8cyb/qfcIXaKoCWZGblGNog5jrE/tdCqshlj7wXp7SWegWpxphG2ljNhrypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSslIO51cqS2Sa48dwmLQUt6y5RHVNeeHnYZLq4W0/o=;
 b=IUpbvpzHOd09b+mtHd+VnB+buxcnI6I18etAvjiTCp4fyCL+FWSDiziPq9+5MBJHE4uKOsm1tyuYvsOQnWvj/XY0WPW408n8X8tgKn110DnYIiiIqvEIqpVPP2GL8xvrSmGFhCBdwjXR7OtuZnX2cf36SOchOlNHUBa6OcKxEdDjojpb1Z+vl2vxGNlHkZAr9xl7WJUJN80VxFuUzkN4Bb0O4Fsz5SnWursLbL9D9pEWTrHo4p0Ek32yzwP2K0RAYDYKdvgvZ3v9lJU6j9YaUjIzOwAl6fN8pNk8+BQ2B8qpePxBk9ZJ+luGCSHZqI/YDb07i0F6rooaR82tzHejaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSslIO51cqS2Sa48dwmLQUt6y5RHVNeeHnYZLq4W0/o=;
 b=oQwh/Pl6HGlFcg7kcP6iyW6N/rJUYz/dM1gtjxnqQUD/NqQvaiNRGVCRiHaZhjuBdBvjxGxxgJz+Pha6P3p9hy1RWCn+YITCPZR2wM83JbwYJTe/xvmN9AwN/DVfalrAcH7AxGPUoOVpU+MrdDex1UX4Zsyw4yT2yOJK6S/Hvvw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO1PR10MB4595.namprd10.prod.outlook.com (2603:10b6:303:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.25; Thu, 5 Oct
 2023 11:14:53 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6838.033; Thu, 5 Oct 2023
 11:14:53 +0000
Message-ID: <a41ad7ae-0d27-af58-a91a-836724eb476e@oracle.com>
Date:   Thu, 5 Oct 2023 12:14:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/7] scsi: Use Scsi_Host as argument for
 eh_host_reset_handler
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <20231002155915.109359-2-hare@suse.de>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231002155915.109359-2-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR07CA0030.eurprd07.prod.outlook.com
 (2603:10a6:205:1::43) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO1PR10MB4595:EE_
X-MS-Office365-Filtering-Correlation-Id: 714f0cc8-17a8-4125-33b5-08dbc5944c74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hoK9ETsdjC8gGnfHle5poLEx6P842tPffcxcV1LOueR2DvxqaJJfbI8L8cFFrxn+xjtqTUWHvyOqAihzesusTstUavThQBKr4mtUrn49O2VAkvlXONaKGNd3WQ14/FgxpZNImn9+FwIoXlXR/b6KTdfKjwQpn3z9znfA9PTdyujkoMWvbAIH11oDeIKVDtYY8EtkYrwsix1fLKW2Bqlp/Jgim45N1a0f1gxmXiJH6JsUbF2rmWxJYhPARjOWvp9Bw/YeL0wmxmwyB5VY6AkGWhdQD3+H9i61xsBdGkx+HlxN3UiyyIRtaIyGSbbufXFbh9+u/x7Tj84OgE4HaikzXLyM66hYQd6i5a/uJazfoh0DQSZcuD4yGp1PQT9As8XaFUXbamr9dP8p7usFxrbXEDq2KJ7isqR48idvn40zz3bP94tZHrMrEKHhJFi2LEjE5P/FfOMN17Bz+igl7e9DKV9niBdegyTQsH8DmtAPyjziHGDfVygJwBXX8tDyzagET0bgaIsxEFmHY+P1qx3LdUkIHtmdqnG0D/w2ECWdavdz43yBwB+QIfVZO8F2DBcG2gJ+O2NfyB0v0WwSD2z+79Mn9dfTfKok4sC6smKATIYOP9sFG7wb/RVCJQdWAzIJRFz3n18Pd7LwL2zVxxEbGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(346002)(396003)(366004)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(6666004)(6486002)(6512007)(6506007)(36916002)(478600001)(26005)(2616005)(83380400001)(2906002)(30864003)(6636002)(316002)(54906003)(110136005)(66476007)(66556008)(66946007)(8676002)(8936002)(4326008)(5660300002)(41300700001)(36756003)(38100700002)(86362001)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXVBckJVUUJlb1hJKzB5cUxRZ2ZCRGZFS25Jbkd5Mi9LZGpReHlkRzE2dUFP?=
 =?utf-8?B?WFAvREN4Z21FU2RuNWp5bnhDdThVL1lESDZHYktMSXMrNW1hV1l2WkoxREt1?=
 =?utf-8?B?MXpoRzFlVm14ZThmZUpRNGloY0hKanQwTkYzcjBZb29YMjN1U3U2aVI5TURG?=
 =?utf-8?B?NWR3UlVkR1BZb3VTdXErdGMwTG1qeG0wMGtEZENCelV6UXg3NE9xV05WNHBC?=
 =?utf-8?B?d1FSL2JYZmhOTno2RlVjeW1NQVRpdWdVVExCYmJINGE4bWNOWUU2YXVnNmRU?=
 =?utf-8?B?K1REYkpXSWpGUE1rMkxNSnkyeDBwdUhoM25FRFZLQkVjK3VZTXBoRDFleGY1?=
 =?utf-8?B?TWIvV3NERS9pZlpJOC85QnZEUUVlK3RXTXZDRUE1bHRGMEpUcG0veGhvbWwx?=
 =?utf-8?B?c1FoSjV2eElXRldjY0hSZmVPQ3o1bUlDYWNVUGpOdXBXMHI5SDFMYUFvMmJV?=
 =?utf-8?B?OHdUYTQvS1paNzF1bytYZTVLTjc1NVZnVFZxRWY4L3h0MkM5cjMzVjJVbU9i?=
 =?utf-8?B?WjBaTGVYbTdzVXNnd25ndTZnN0dqWjdkYkIxaFlhWHh4ZHkzYVI3TG9BQ3o2?=
 =?utf-8?B?eDZxWXlZRGExR2tlVzgzcnFjVkpsUGRKRnNkUmo2VkRwREZNeGw2ZkYwUS9M?=
 =?utf-8?B?N1NUNnlHdkVGeVUreEFMUTlwNjBDdDJkMmlCbzVrOGZHdHFLeW1tYTlNclFZ?=
 =?utf-8?B?Mml2U3RZWGVXU3B0ZjJnOUt4aFczZkQydm9sQTJQZlozZk5MUUdrcXR5bWJP?=
 =?utf-8?B?cG1iWU5YQkxnYm5nQmc2aU1SamsvdmZwZXplMHhlQWdqZnlLSkN6WnBjZThk?=
 =?utf-8?B?RmhJZFpQWm1pK1dvVVV2bVRHdDdMcVZ3NG1mcWgzRzNwUzhTWm80c29mSlZv?=
 =?utf-8?B?a2NrT2Z0aWg3ck5MZHdjRUJFWHVJWE1yY0xVQU5vcVowQlJtaFJTWjVPY0xF?=
 =?utf-8?B?aGdxdVkxSmwrdkRZOXUrR3AvZHZ1ZlpYSlNXMzc5S2lYSC9yOXNONkNSUXp0?=
 =?utf-8?B?UVlyUUVrYWp3ekhMQ2s3WjIwTVA5eWFVcmtFdnBtRzU0bFMvdXR3TU1reXp4?=
 =?utf-8?B?TlZISnVUdGxuMGp4VytHdFowNHl1SzdpMHJoUjNUNnhmd2JGNWZYUGZQOEhk?=
 =?utf-8?B?VVhhRzAvWmVhbDdzRHd4NU9hc0duc29vOFNadUNuRlNSV1RMWlE5UEtrTS94?=
 =?utf-8?B?cjVQWUFNSDJ0WWxXZFpBNE53WEFlWURmRkZkUTBpWVJ0aENnOG1hWGg0engv?=
 =?utf-8?B?bzhjMnM4R09uY1Rpa1VUMHoyR1YxcFhVRXIvcHpRZk5HNzMyMVN5M2w1bEZQ?=
 =?utf-8?B?bW83SDRwcG1zSXMxdmJRSVR5eisyWGdWbGtXZVVBVERCb0hEUFdnMm1tdUN5?=
 =?utf-8?B?NkJpTGMrYlp5MjJaZ0UxU1JwUkRMSWFCemR0V3VkU3VraC8wYzJjSFZmVm1X?=
 =?utf-8?B?N1lMWDZCSDM0S3dSSDUzVzFxU0VlNG0zYzM2RDdHVXNmc1VWK2tnemlZNk5S?=
 =?utf-8?B?cU9rWjZuV3V5UDFMZTFrUVpvbnNpeGEreE80UXlLMW5CS3ZwQWNpMkpJM1dh?=
 =?utf-8?B?R05pU095QldOcGJoYzZWWkg0amlsL1JVeGhrcUlhVEdSTWIzUk5pWmpXS3cv?=
 =?utf-8?B?NHdVeWFoWjlBR1lVWXJYMXZ2ak1xbUJqK1hQdjI3OWdHQUM5YzhzcCs0YTBY?=
 =?utf-8?B?YWVMckdaZm1XMUZ6OFJ4d1QrYzVwTmI3K1NQVlpxaThJWmVOSUdodHpReUhi?=
 =?utf-8?B?RTNCY3hIQlJ5NWloMGgxL2h3WlNyeVNyM0p0RGdtcGpZSkcvK2N1U0MrelVP?=
 =?utf-8?B?RndFVnBsdEUxL0IvNWdCTlpyVFExSzR6YllkeW5rSGdtZTVLLy8ySHZIQjhB?=
 =?utf-8?B?Q3laaHRUNFdaVkhraGtKcGhINWZJUHQzbHNJL0pkcUlBdmVwODc0Z0FyMmp3?=
 =?utf-8?B?bGQ3UXdRS0hWVW41KzVFSlNjSHpzWnJPNm5EZ3VhUXlHUmxsajdmUVRvb2c4?=
 =?utf-8?B?emd3UUhRd09VamRsQXAvQ1cyUkxUR2ZxaWkvQ0ZhVjBWWGR4ditDY1dRUDVH?=
 =?utf-8?B?T3hhNVhhb1VlbVdYRDhiVGhrbTlUQjFNOWFjc0d5dm96eC9INEFKV3A3bjln?=
 =?utf-8?Q?hFTHNPTZkLxUafTSW5lEiH0op?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UkaLi/2XdsDHHy5J1tpS36dKA4bwm1aBLLS/FHTG2NU7DxmvwDzkKBXet0QtcyEWPcVU/+1DWznHNshHyo+LOPWiRun/tA6tkDFyVylEARFRW9SLOjrWm83HTMrCu0hCkeWkK5khPL4w4DHMM4RUgMW7YKhSnhPyeVJcEea8iP1Y0eyq0fnaVJGfUUIAT4ykW8mFz1qAcpp6OxJoF/tlc0ySwVaqdaBZLGJwubt4+1/rIV39HVoPVi4A/Q1RgUOaccoNNK96rKnZ+h2rCVOFHy1KKXv/OeuPcGuE4oH/iBtlw1Ri5+Ik5RsfW1Bct0pekdpYx3WsRAXpsw7Rnl2cs7nv4vUbAFqh/3AT8MhI7kYy5Esmk1MO0AxSooQEa/WgB/h3HZj9sk684UacgCNdsByXS/OiarRB8oPwLDRW8V75leF5TnjewmB4+pVLj4urQzFHd2f31GiA/PXGDn1MiWUxxqDlvBxDV5xRPQBu8VUUOxQ+pDA0gXAuFotm9yy8KNsP2TUGHAZoxkM5R9RT97GhXuFUs3/y7J7Ip77FpRlWgV+CupE+qqFLOuO6GyCQZLOS72LlB4cljhHr33C1v9aCm7S3BLXR7uGV4q5XcqOhIdQBj2R0hp1WGkVNVeM1XbXVXxSey797by7tgxL2FPd2LMipVnJ3CiF8J8QUdv+vJ1eG25g0eM3Q+hYt2rEOQZDfdluPHlg7xmwpaVuUiQwob0gfGForFv4rTOWZKMHY6SVXKjmb3w7Bf+uafYnI3I0mmJRJWrGl+3bPCjgopoRWxa6wqIQSFC0O4pdtXMSzgQsQ6o9IKFYXpUbFaRILRK3oggUoUZk6su5FhhaghALkGASI3v9bTnKGptKJzJU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 714f0cc8-17a8-4125-33b5-08dbc5944c74
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2023 11:14:53.3681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEXxXRk+cD4nwE3EhgkmuOZzR0xA7Tgv5a91S7s6OK+CYcyx5AmDKRZaUdQHKIa28i1EWErCnayQr1e/4bRJ9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-05_08,2023-10-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310050087
X-Proofpoint-ORIG-GUID: I63NbRr9cxsuRU8PXYiDnjJU9D_PdYjy
X-Proofpoint-GUID: I63NbRr9cxsuRU8PXYiDnjJU9D_PdYjy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>   
>   Higher-severity actions are taken only when lower-severity actions
>   cannot recover some of failed scmds.  Also, note that failure of the
> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> index 022198c51350..85b1384ba4fd 100644
> --- a/Documentation/scsi/scsi_mid_low_api.rst
> +++ b/Documentation/scsi/scsi_mid_low_api.rst
> @@ -777,7 +777,7 @@ Details::
>   
>       /**
>       *      eh_host_reset_handler - reset host (host bus adapter)
> -    *      @scp: SCSI host that contains this device should be reset
> +    *      @shp: SCSI host that contains this device should be reset

Which device are we referring to here? The current comment does not even 
make sense to me as it is being passed a scsi_cmnd

>       *
>       *      Returns SUCCESS if command aborted else FAILED
>       *
> @@ -794,7 +794,7 @@ Details::
>       *
>       *      Optionally defined in: LLD
>       **/
> -	int eh_host_reset_handler(struct scsi_cmnd * scp)
> +	int eh_host_reset_handler(struct Scsi_Host * shp)
>   
>   

...

>   
> -static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
> +static int zfcp_scsi_eh_host_reset_handler(struct Scsi_Host *host)
>   {
> -	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
> -	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
> +	struct zfcp_adapter *adapter = (struct zfcp_adapter *)host->hostdata[0]; >   	int ret = SUCCESS, fc_ret;
>   
>   	if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE)) {
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index f925f8664c2c..f0efdfcdac44 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -1717,18 +1717,19 @@ static int twa_scsi_biosparam(struct scsi_device *sdev, struct block_device *bde
>   } /* End twa_scsi_biosparam() */
>   
>   /* This is the new scsi eh reset function */
> -static int twa_scsi_eh_reset(struct scsi_cmnd *SCpnt)
> +static int twa_scsi_eh_reset(struct Scsi_Host *shost)
>   {
>   	TW_Device_Extension *tw_dev = NULL;
>   	int retval = FAILED;
>   
> -	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
> +	tw_dev = (TW_Device_Extension *)shost->hostdata;
>   
>   	tw_dev->num_resets++;
>   
> -	sdev_printk(KERN_WARNING, SCpnt->device,
> -		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
> -		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
> +	shost_printk(KERN_WARNING, shost,
> +		     "WARNING: (0x%02X:0x%04X): "
> +		     "Command timed out, resetting card.\n",
> +		     TW_DRIVER, 0x2c);
>   
>   	/* Make sure we are not issuing an ioctl or resetting from ioctl */
>   	mutex_lock(&tw_dev->ioctl_lock);
> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> index 55989eaa2d9f..80885200ba52 100644
> --- a/drivers/scsi/3w-sas.c
> +++ b/drivers/scsi/3w-sas.c
> @@ -1423,18 +1423,19 @@ static int twl_scsi_biosparam(struct scsi_device *sdev, struct block_device *bde
>   } /* End twl_scsi_biosparam() */
>   
>   /* This is the new scsi eh reset function */
> -static int twl_scsi_eh_reset(struct scsi_cmnd *SCpnt)
> +static int twl_scsi_eh_reset(struct Scsi_Host *shost)
>   {
>   	TW_Device_Extension *tw_dev = NULL;
>   	int retval = FAILED;
>   
> -	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
> +	tw_dev = (TW_Device_Extension *)shost->hostdata;
>   
>   	tw_dev->num_resets++;
>   
> -	sdev_printk(KERN_WARNING, SCpnt->device,
> -		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
> -		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
> +	shost_printk(KERN_WARNING, shost,
> +		     "WARNING: (0x%02X:0x%04X): "
> +		     "Command timed out, resetting card.\n",

nit: I think that these lines can be united to make grepping easier. 
This comment applies elsewhere.

...

> diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> index 9503996c6325..2a88e1c6ffda 100644
> --- a/drivers/scsi/aha1542.c
> +++ b/drivers/scsi/aha1542.c
> @@ -914,15 +914,14 @@ static int aha1542_dev_reset(struct scsi_cmnd *cmd)
>   	aha1542_outb(sh->io_port, CMD_START_SCSI);
>   	spin_unlock_irqrestore(sh->host_lock, flags);
>   
> -	scmd_printk(KERN_WARNING, cmd,
> +	sdev_printk(KERN_WARNING, sdev,

I'm not sure if this is a related change

>   		"Trying device reset for target\n");
>   
>   	return SUCCESS;
>   }

...

>   static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 97816a0e6240..355fec046220 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -2640,9 +2640,9 @@ static int esp_eh_bus_reset_handler(struct scsi_cmnd *cmd)
>   }
>   
>   /* All bets are off, reset the entire device.  */
> -static int esp_eh_host_reset_handler(struct scsi_cmnd *cmd)
> +static int esp_eh_host_reset_handler(struct Scsi_Host *shost)
>   {
> -	struct esp *esp = shost_priv(cmd->device->host);
> +	struct esp *esp = shost_priv(shost);

Why are we not just using shost_priv() everywhere (instead of 
shost->hostdata[])? It would save all the casting to the driver host 
structure also.

>   	unsigned long flags;
>   
>   	spin_lock_irqsave(esp->host->host_lock, flags);
> diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
> index 504c4e0c5d17..347fb668bf29 100644
> --- a/drivers/scsi/fdomain.c
> +++ b/drivers/scsi/fdomain.c
> @@ -456,9 +456,8 @@ static int fdomain_abort(struct scsi_cmnd *cmd)
>   	return SUCCESS;
>   }
>   
> -static int fdomain_host_reset(struct scsi_cmnd *cmd)
> +static int fdomain_host_reset(struct Scsi_Host *sh)
>   {
> -	struct Scsi_Host *sh = cmd->device->host;
>   	struct fdomain *fd = shost_priv(sh);
>   	unsigned long flags;
>   
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index 8ffcafb4687f..2e2b49ba8cdf 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -347,7 +347,7 @@ void fnic_update_mac_locked(struct fnic *, u8 *new);
>   int fnic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
>   int fnic_abort_cmd(struct scsi_cmnd *);
>   int fnic_device_reset(struct scsi_cmnd *);
> -int fnic_host_reset(struct scsi_cmnd *);
> +int fnic_host_reset(struct Scsi_Host *);
>   int fnic_reset(struct Scsi_Host *);
>   void fnic_scsi_cleanup(struct fc_lport *);
>   void fnic_scsi_abort_io(struct fc_lport *);
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 25af91081baf..324058bd594d 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -2448,11 +2448,10 @@ int fnic_reset(struct Scsi_Host *shost)
>    * host is offlined by SCSI.
>    *
>    */
> -int fnic_host_reset(struct scsi_cmnd *sc)
> +int fnic_host_reset(struct Scsi_Host *shost)
>   {
>   	int ret;
>   	unsigned long wait_host_tmo;
> -	struct Scsi_Host *shost = sc->device->host;
>   	struct fc_lport *lp = shost_priv(shost);
>   	struct fnic *fnic = lport_priv(lp);
>   	unsigned long flags;
> diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
> index f5334ccbf2ca..cc9ed9e6c666 100644
> --- a/drivers/scsi/hptiop.c
> +++ b/drivers/scsi/hptiop.c
> @@ -1088,12 +1088,12 @@ static int hptiop_reset_hba(struct hptiop_hba *hba)
>   	return 0;
>   }
>

...
>   	scb_t		*scb;
> @@ -2525,7 +2525,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
>   	int		i;
>   	uioc_t		*kioc;
>   
> -	adapter		= SCP2ADAPTER(scp);
> +	adapter		= (adapter_t *)SCSIHOST2ADAP(shost);

SCSIHOST2ADAP is a re-definition of shost_priv() really (so it can be 
removed)


..
*/
>   
>   	/* Complete pending commands */
>   	handle_reset(ms);
> -	
> +

we seem to have double blank line now, I'm not sure

>   	spin_unlock_irqrestore(ms->host->host_lock, flags);
>   	return SUCCESS;
>   }
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 040031eb0c12..d52412870b54 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -4010,15 +4010,15 @@ static inline void mpi3mr_setup_divert_ws(struct mpi3mr_ioc *mrioc,
>   
...

>   
>   /* */
> diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
> index 310d0b6586a6..59893db166c9 100644
> --- a/drivers/scsi/pcmcia/qlogic_stub.c
> +++ b/drivers/scsi/pcmcia/qlogic_stub.c
> @@ -270,8 +270,8 @@ static int qlogic_resume(struct pcmcia_device *link)
>   		outb(0x24, link->resource[0]->start + 0x9);
>   		outb(0x04, link->resource[0]->start + 0xd);
>   	}
> -	/* Ugggglllyyyy!!! */
> -	qlogicfas408_host_reset(NULL);

I had a quick check of qlogicfas408_host_reset(), and it does not even 
seem safe to pass NULL as the arg (which was a Scsi_cmd) as it is 
dereferenced there. Has this ever worked?

> +
> +	qlogicfas408_host_reset(info->host);
>   
>   	return 0;
>   }
> diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
> index 278c78d066c4..1c5415ede9b2 100644
> --- a/drivers/scsi/pcmcia/sym53c500_cs.c
> +++ b/drivers/scsi/pcmcia/sym53c500_cs.c
> @@ -583,14 +583,14 @@ static int SYM53C500_queue_lck(struct scsi_cmnd *SCpnt)
>   static DEF_SCSI_QCMD(SYM53C500_queue)


..
>   		return FAILED;
>   	}
> diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
> index 3e065d5fc80c..008e908e3aff 100644
> --- a/drivers/scsi/qlogicfas408.c
> +++ b/drivers/scsi/qlogicfas408.c
> @@ -525,20 +525,18 @@ int qlogicfas408_abort(struct scsi_cmnd *cmd)
>   
>   /*
>    *	Reset SCSI bus
> - *	FIXME: This function is invoked with cmd = NULL directly by
> - *	the PCMCIA qlogic_stub code. This wants fixing

This seems to answer my question, above. I am still not sure if this is 
the proper approach, since we don't know it works properly now (instead 
of just crashing).

>    */
>   
> -int qlogicfas408_host_reset(struct scsi_cmnd *cmd)
> +int qlogicfas408_host_reset(struct Scsi_Host *host)
>   {
> -	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
> +	struct qlogicfas408_priv *priv = get_priv_by_host(host);
>   	unsigned long flags;
>   
>   	priv->qabort = 2;
>   
> -	spin_lock_irqsave(cmd->device->host->host_lock, flags);
> +	spin_lock_irqsave(host->host_lock, flags);
>   	ql_zap(priv);
> -	spin_unlock_irqrestore(cmd->device->host->host_lock, flags);
> +	spin_unlock_irqrestore(host->host_lock, flags);
>   
>   	return SUCCESS;

...

>   
> -static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
> +static int scsi_debug_host_reset(struct Scsi_Host *shost)
>   {
>   	struct sdebug_host_info *sdbg_host;
>   	struct sdebug_dev_info *devip;
> @@ -5379,9 +5379,11 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
>   
>   	++num_host_resets;
>   	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
> -		sdev_printk(KERN_INFO, SCpnt->device, "%s\n", __func__);
> +		shost_printk(KERN_INFO, shost, "%s\n", __func__);
>   	mutex_lock(&sdebug_host_list_mutex);
>   	list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
> +		if (sdbg_host->shost != shost)
> +			continue;

This seems to be a change in behaviour, but the current behaviour is 
quite odd to begin with. I mean, the current code never uses SCpnt to 
decide which devip to set SDEBUG_UA_BUS_RESET for, so I don't know why 
we do it now partially per shost.

>   		list_for_each_entry(devip, &sdbg_host->dev_info_list,
>   				    dev_list) {
>   			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
> @@ -5391,7 +5393,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
>   	mutex_unlock(&sdebug_host_list_mutex);
>   	stop_all_queued();
>   	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
> -		sdev_printk(KERN_INFO, SCpnt->device,
> +		shost_printk(KERN_INFO, shost,
>   			    "%s: %d device(s) found\n", __func__, k);

Again, I am not sure about this...

>   	return SUCCESS;
>   }
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index c67cdcdc3ba8..f022bb1c3e4a 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -881,7 +881,7 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
>   	if (!hostt->eh_host_reset_handler)
>   		return FAILED;
>   
> -	rtn = hostt->eh_host_reset_handler(scmd);
> +	rtn = hostt->eh_host_reset_handler(host);
>   
>   	if (rtn == SUCCESS) {
>   		if (!hostt->skip_settle_delay)
> diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
> index 0b7411624bcf..27acc50bd1a5 100644
> --- a/drivers/scsi/snic/snic.h
> +++ b/drivers/scsi/snic/snic.h
> @@ -365,8 +365,7 @@ extern const struct attribute_group *snic_host_groups[];
>   int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
>   int snic_abort_cmd(struct scsi_cmnd *);

...

>   
> +/*
> + * SCSI Error handling calls driver's eh_host_reset if all prior
> + * error handling levels return FAILED.
> + *
> + * Host Reset is the highest level of error recovery. If this fails, then
> + * host is offlined by SCSI.

"is offlined by SCSI" sounds odd. Do you mean "SCSI core"?

> + */
>   int
> -snic_reset(struct Scsi_Host *shost)
> +snic_host_reset(struct Scsi_Host *shost)
>   {
>   	struct snic *snic = shost_priv(shost);
>   	enum snic_state sv_state;
> @@ -2297,34 +2304,6 @@ snic_reset(struct Scsi_Host *shost)
>   	ret = SUCCESS;
>   
>   reset_end:
> -	return ret;
> -} /* end of snic_reset */
> -
> -/*
> - * SCSI Error handling calls driver's eh_host_reset if all prior
> - * error handling levels return FAILED.
> - *
> - * Host Reset is the highest level of error recovery. If this fails, then
> - * host is offlined by SCSI.
> - */
> -int
> -snic_host_reset(struct scsi_cmnd *sc)
> -{
> -	struct Scsi_Host *shost = sc->device->host;
> -	u32 start_time  = jiffies;
> -	int ret;
> -
> -	SNIC_SCSI_DBG(shost,
> -		      "host reset:sc %p sc_cmd 0x%x req %p tag %d flags 0x%llx\n",
> -		      sc, sc->cmnd[0], scsi_cmd_to_rq(sc),
> -		      snic_cmd_tag(sc), CMD_FLAGS(sc));
> -
> -	ret = snic_reset(shost);
> -
> -	SNIC_TRC(shost->host_no, snic_cmd_tag(sc), (ulong) sc,
> -		 jiffies_to_msecs(jiffies - start_time),
> -		 0, SNIC_TRC_CMD(sc), SNIC_TRC_CMD_STATE_FLAGS(sc));
> -
>   	return ret;
>   } /* end of snic_host_reset */
>   
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index 8ffb75be99bc..5e5ecea265ad 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -1438,14 +1438,13 @@ static int stex_do_reset(struct st_hba *hba)
>   	return -1;
>   }
>   
> -static int stex_reset(struct scsi_cmnd *cmd)
> +static int stex_reset(struct Scsi_Host *shost)
>   {
>   	struct st_hba *hba;
>   
> -	hba = (struct st_hba *) &cmd->device->host->hostdata[0];
> +	hba = (struct st_hba *) &shost->hostdata[0];

Again, can shost_priv() be used for all of these?

>   
> -	shost_printk(KERN_INFO, cmd->device->host,
> -		     "resetting host\n");
> +	shost_printk(KERN_INFO, shost, "resetting host\n");
>   
>   	return stex_do_reset(hba) ? FAILED : SUCCESS;
>   }
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index a95936b18f69..7a71d0526f6d 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1624,9 +1624,9 @@ static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
>   	return 0;


