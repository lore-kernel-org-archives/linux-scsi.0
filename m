Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97C8C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 22:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95F6164F7A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 22:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhCKWDk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 17:03:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60454 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhCKWDh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 17:03:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BLwkON063882;
        Thu, 11 Mar 2021 22:03:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2eCXEYQjZ35rdko0Y6kZFd7YGTKyL6bODzYZzBRnvQ0=;
 b=oL+sN9R0zT3oJrpb3/z5mIzcJiAECv5gPZFnt/b1Uw67X/5hCaRpdj3uSbY1aTnSXGGq
 ZJzWtemfVURWDnyLtEwnnb0OjSX67ETCfu2GIq2uTzlnd661lrU11HTb90un5YlwO2D+
 DDWDuxz8GQGTm75QfoZmFl9/nPvfGDsnqno38GX8VZ9I9ZIPT+VYaA8WSPdyjGxftEoF
 XFZNHnYJGKPrL5F7V/BfpWqk8VkOVXj/wOL8mcCVqdiu24cHJOpucAAuBbuEvp48dghJ
 x0m64l3N64cxRcTvaaumTDXHk2IVy0bQQlJvAUxpHPzJ1SQLCxwC5oEgi/0/FauJWuIO RA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3741pmr7gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 22:03:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12BM1YOZ147674;
        Thu, 11 Mar 2021 22:03:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3030.oracle.com with ESMTP id 374kp1ma7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 22:03:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RD5MvzU2JDkvgjBzHmpSz1xS4yu/WTN2YInB7n6txHu5nHpkXwEsVWjkD3vdVCiraxWrEYxfzuS2UZlHGBX6QfePikD4QUkaGRxfd8v2KK6hiqoh+KNYp81bFAgBN/fRWcPN9IFHsA+vV/TKJKGUmqGtx3gr53vYuhvm5GrpMKTaBabUAxxA6DmiCPMMkKRrjTt6ifLS3Y4Z/sU7+lkuEzKIln7rcMUl520WQCFRY60+YYhQlOOTdzgh0XLTwHcuNcWK66l25ymHy1KHLW8KDcyv6WcxHRgun/x8F3IgZ0zzCwMZtfDLQcOgDvnHg5XC2t3d3y8EqO1ass6BhEUXfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2eCXEYQjZ35rdko0Y6kZFd7YGTKyL6bODzYZzBRnvQ0=;
 b=ScDVy8zQG0fCRFsXnR75rXGTPbbSsi59YQ4rzpbCXiTdyTwYqf5Zy3vLDQhsgAgJdpGrGQuNDhawXLIrcKH2finMlrweK2fhi9ETx6Ze+Cn+UKXMI/7s9fQcOQot9od9M41YZAKnaznAMu2uKt8Y7YZh/5cfk9/tBunR+fi2itoR0OAnpozYbJa1hrMyg+r6VMRwqVwrLYsEBclLhjN4T7uxk/LLpJzy5ysYa+rEQWdYNw7XYsSCVNR7mc4UYSJgIk1h5QyJch66TPpcEj0WDW4oaG4zS7TRqGPxX8kcuY/hSJT/J04pbdZeGm82G2Fsm3rW+8HrU8TGUtb4r2zhRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2eCXEYQjZ35rdko0Y6kZFd7YGTKyL6bODzYZzBRnvQ0=;
 b=RfMmK4cHtbN584mlBPUoF0RJ4opuaBPxF94TLKaEUlJ0RUR+Hz3PjZtR+jD6NN0laextOhAEBSyaiIwv0tn+P0bnz+G4IhU4LFcoJEQQ00Rkx7OlV11Teb5Ibh785eKPCuKkqd85L72koZYuUl7/7vTpCYiAGwgjHFyQtW1x3ME=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN8PR10MB3508.namprd10.prod.outlook.com (2603:10b6:408:ae::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 22:03:15 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3912.030; Thu, 11 Mar 2021
 22:03:15 +0000
Subject: Re: [PATCH 14/31] hpsa: use reserved commands
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Don Brace <don.brace@microchip.com>
References: <20210222132405.91369-1-hare@suse.de>
 <20210222132405.91369-15-hare@suse.de>
From:   michael.christie@oracle.com
Message-ID: <f9a6f546-db53-c21d-912e-93b29849a6ef@oracle.com>
Date:   Thu, 11 Mar 2021 16:03:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210222132405.91369-15-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR08CA0004.namprd08.prod.outlook.com
 (2603:10b6:5:80::17) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by DM6PR08CA0004.namprd08.prod.outlook.com (2603:10b6:5:80::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 22:03:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8f057d0-285f-41fe-6bd1-08d8e4d97854
X-MS-TrafficTypeDiagnostic: BN8PR10MB3508:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR10MB3508D6BA5705EA263C5234AEF1909@BN8PR10MB3508.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: db7LtWd6ekJJmgKo9PVTxoT7eghdSqJSQsEl0TU7VOdutRafIWCjhlzvyEHUN8MqrxqvMEX981sLHTL54I/Z5lwS4fDx6U1/IRbet+Dt1SR3aA6vTDN0m/fHZzTmtY4fp1sAGcIYWroD/sFFEWrEMYLBRLiWAwOpelds6roHM/3oXWLr5DheppR6R8Mo6KlNOPS9sRhF/BaX6iIczYroyGa2VQ5So5Q5jjzvBwu/3kbxOd9qzV4FWZJDJ2qJo42mcBFW1ddqsevoRCyTHNgmGmymWyO6VwAGsGSMDy44hhPaUrlXUszVObmKfJt1Has+2A7Zc+kQ3Mr2sjgy0XbTFXg2jbLCbvrSjc7NTWV+HEvsCAx260FpLoZOLzCzWf5hT9QgEF/gdWwawuvt92smH5CEXW3osH11JhJTqrOT1Xj3yeLQ+QIgJFtrIaOqigLJjU+ctXo8uFO+hm3YqemsXw0BrQXE0bgUkrwaXOlzB4fSdXK0hS8ietb34MPu3OTORrZowSbu7NP3WL79+LyR8ByLeWKK3fQ6eViDi9LLpBFeb9CcBlnt8wojl+j/oc9JelRf/OHkQYMwW2PTAo8nQFY8rnTDqNaKK1rxXf5BkB4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(396003)(376002)(346002)(31686004)(2906002)(86362001)(478600001)(6486002)(36756003)(31696002)(26005)(16526019)(66476007)(4326008)(66946007)(186003)(66556008)(5660300002)(2616005)(8676002)(8936002)(6706004)(9686003)(54906003)(16576012)(110136005)(83380400001)(53546011)(316002)(956004)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?KzE4eEkrUGpVWVRmejYzVVFBSnFjVXVWaEVFTEVJbmVtR2k1WVdFRW15WnBj?=
 =?utf-8?B?ajVEa0dQOVA5VXE0UnN0bUhGRHlEU241a3YyR0pZa3V5VG4rM3pSQ2FyM1R0?=
 =?utf-8?B?dFhDblBHT0dleFpPWmRMODJhQkNtS2hlUXJUVUVhQUtGNkw5eFA2TE4vbmJQ?=
 =?utf-8?B?S2NrY254TTJGQXFYMFhXZTJQdm1pT3hVNHB3ZkxONHhYaFR5M1VQN05FZENK?=
 =?utf-8?B?MVhqdlhWOE9ZNE5DVWZ3dlZici9BZzQzUnZBRnY0MDF5c0lPenZ4ZmdOTHJq?=
 =?utf-8?B?KzJNc2E2NXc1NEhxOVlLdVZkTnFlYXF6aXhmQ0paUUJnYTVwOTBDNEsxenVv?=
 =?utf-8?B?dlZZVmhsblpaVk8zRC9CSzQxMzJYT0V4b2I0TVptTjNUWVFKMlhsRmR3bG1h?=
 =?utf-8?B?SkgzMCtIenpvelJNQXNpZXhZcVR5Y1NSc0hnODA2c3NkbVdVdFNidzFCS1ZI?=
 =?utf-8?B?Ti90TWZXRlVhUTBvTkFQS2hDQlVkWVVURlkvbUt3RGhyS1pudkE2VXR6Y29v?=
 =?utf-8?B?dUFxUGtUdmptNG1DZEpmOW5RZHBsUHpvT1RpNThkdnpsWTlyQXgvSE43dUJI?=
 =?utf-8?B?TmRqRjZZU1dheThqdmJNYWtjb2xMb2lydnltNEhIeUZQekdrNHg3VURXbGs4?=
 =?utf-8?B?VXM3YVA1TXVvbzBqWldkZGFVV2tTZk4yZSswME5Vd3FMRldMeCs0VjdqU2RV?=
 =?utf-8?B?TWQwYklvcWh1RHRhcjhyakxtRFJjdnVYU2NwVDVRRmFrSVpEaWpJM2FqRmFR?=
 =?utf-8?B?cEY3VDl3akJhM2ZheEFuZlZCdmE3Njd0RVEyaWJBUVZnejQxd2dPWmw3azJY?=
 =?utf-8?B?NmZKTUpqWXVRWUFpa0NiTzF6OU0rV0ZIdDZlZWdvY1BjUGNGZ1hnSStwSjl4?=
 =?utf-8?B?UDhIMUQ1ZnJkUkc2eVBqdEhKa1RkMjc5UUR2aXp4bW9nZFJLbkZBbVpwMzFy?=
 =?utf-8?B?ZjgwRmhJbnM5N1hFNWIvNnN2cWNxQmg4bG1iVzJlbEFGWk82cFh1RTNhbDhL?=
 =?utf-8?B?M0RzTkxsdG5BbG4zUWhIS0szaERFclFJbEFrcW5CaHNvdE1xZU14bk9RTnlp?=
 =?utf-8?B?N0dlUEd1bTVCSU1iYk5PeE1GNmRaTDl0Sm5pd3MvcXJnbVNrVTU4RnRTYVJW?=
 =?utf-8?B?MmRZN09MR2NKaUdkR0VCYWVMMlkrTG05b1Y5VXYyVEtIekNVZFAwUVdrQXFH?=
 =?utf-8?B?aGl3SG5zVWdoVTZsbjVQQ2J6YkorMmR6eEdzcTYwWTRIcTRzRkhXdy8yam5E?=
 =?utf-8?B?TWtBNmZaL2NHdDYyaHIxcU5DbS9BSk1UVmh4R1JzT21FK3lxakkySzFTVmZs?=
 =?utf-8?B?dkVGS3M2bnJCSmJYaWNqZVpIK0tydTRKTFRvbnFBUEh6aEdiRE13VWV0Z01Y?=
 =?utf-8?B?dXc0MHZHZnowZ3pQT1BmWTRsbTdNb25xM1lUK2FrZTJGMlVqbEZqNXBSRFR4?=
 =?utf-8?B?ajhZQjlGTjN0K0FvMFkrUmlJSEUzbjdnY3U1WHNiUkxHRGVWN25idEdpb2hN?=
 =?utf-8?B?cXIrVUlBQU1VanlIVGlwV0pSUC9qczZ3d2dXN05VZzNabTJVaVVlMm0xUWl6?=
 =?utf-8?B?WDR4K2RPdW9LVUdWMEl5YnFsMEh0eDhSWXVqaVhiTEpOVGZVNU5mWklvTFJ2?=
 =?utf-8?B?UTE3N1JQVS9FM3VwV2tFMWtMemtBci9KR05ka3NhS3ltdm1oZExQWkc1WUV1?=
 =?utf-8?B?ZXd0SG5RNURZVndNamlrenk3Ym1ZaE8zWTlCdnREay9mYnFneVRSM3R0TkN5?=
 =?utf-8?Q?i6O3it45nidElgHjBiSn/B8RuzjtPI9oWvPFvid?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f057d0-285f-41fe-6bd1-08d8e4d97854
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 22:03:15.4177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uA1QB1K+yUZKiCpaOwkDADYTRdC6YtDxE+MKGfeP2XrPvqFQJntSuJxua0UFH/XKCFzfAx9mDY2dLczunabLNeX8RI0aENJVUn8No4bfNm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3508
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110114
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9920 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1011 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103110114
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/21 7:23 AM, Hannes Reinecke wrote:
> -
> -static struct CommandList *cmd_alloc(struct ctlr_info *h)
> +static struct CommandList *cmd_alloc(struct ctlr_info *h, u8 direction)
>  {
> +	struct scsi_cmnd *scmd;
>  	struct CommandList *c;
> -	int refcount, i;
> -	int offset = 0;
> -
> -	/*
> -	 * There is some *extremely* small but non-zero chance that that
> -	 * multiple threads could get in here, and one thread could
> -	 * be scanning through the list of bits looking for a free
> -	 * one, but the free ones are always behind him, and other
> -	 * threads sneak in behind him and eat them before he can
> -	 * get to them, so that while there is always a free one, a
> -	 * very unlucky thread might be starved anyway, never able to
> -	 * beat the other threads.  In reality, this happens so
> -	 * infrequently as to be indistinguishable from never.
> -	 *
> -	 * Note that we start allocating commands before the SCSI host structure
> -	 * is initialized.  Since the search starts at bit zero, this
> -	 * all works, since we have at least one command structure available;
> -	 * however, it means that the structures with the low indexes have to be
> -	 * reserved for driver-initiated requests, while requests from the block
> -	 * layer will use the higher indexes.
> -	 */
> -
> -	for (;;) {
> -		i = find_next_zero_bit(h->cmd_pool_bits,
> -					HPSA_NRESERVED_CMDS,
> -					offset);
> -		if (unlikely(i >= HPSA_NRESERVED_CMDS)) {
> -			offset = 0;
> -			continue;
> -		}
> -		c = h->cmd_pool + i;
> -		refcount = atomic_inc_return(&c->refcount);
> -		if (unlikely(refcount > 1)) {
> -			cmd_free(h, c); /* already in use */
> -			offset = (i + 1) % HPSA_NRESERVED_CMDS;
> -			continue;
> -		}
> -		set_bit(i & (BITS_PER_LONG - 1),
> -			h->cmd_pool_bits + (i / BITS_PER_LONG));
> -		break; /* it's ours now. */
> +	int idx;
> +
> +	scmd = scsi_get_internal_cmd(h->raid_ctrl_sdev,
> +				     (direction & XFER_WRITE) ?
> +				     DMA_TO_DEVICE : DMA_FROM_DEVICE,
> +				     REQ_NOWAIT);
> +	if (!scmd) {
> +		dev_warn(&h->pdev->dev, "failed to allocate reserved cmd\n");
> +		return NULL;

I think in the orig code cmd_alloc would always return a non null pointer.
It looks like we would always just keep looping.

Now, it looks like we could fail from the above code where we return NULL.
I was not sure if it's maybe impossible to hit the "return NULL" becuase we
only call this function when we know there will be a cmd availale. If we
can fail then the cmd_alloc callers should check for NULL now I think.
