Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCA1C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 18:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65EB560EBB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 18:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhJVSTw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 14:19:52 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:10104 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231472AbhJVSTv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 14:19:51 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MIGKOQ007680;
        Fri, 22 Oct 2021 18:17:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=gbvQGJzx4hB1NKeaB2+YLQ3vrbC6jhRq9giBY2tn7sg=;
 b=RCuypCDWUz6lg2NGnL69J2Zver6o+vSj6UbixR/bCDdGB4uLasdLN4BvnG0CqX2jNY/C
 thsyyXb8258f73DMtZeBEOWfbfnRQ+/jkGySslMgD2AanYEwry7HhqW/HbkLylRNCjrF
 /AVGBlsWsgJejCyb4tA5xqtrB+s6F5YZr8RERYlORYGURvX1qqA01kewE+kQhEvugSxo
 +fOdF7Y/DNnuBXViu53wctZHGMSL4FfvG+Yk7AHFcBaZn+ZhCQTxyZ01ttE+jZMLxDLW
 7yHKBpbtqGVsHqmww9lL8r/Aje50xtSwuRfFw+GdkeUCSBqEv2Dqv5xbON1k93xgi0UB zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bunf9bkyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 18:17:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19MI71iT153189;
        Fri, 22 Oct 2021 18:17:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3030.oracle.com with ESMTP id 3bqmsmbha6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 18:17:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgauzjKmfxEj+M9XDmErgTtL4S5lpwdooTZWMoe56N2akLurbVoF+A4CccjCqZetvwaCqKeckMWzqZoinrYl13WLO4J2/pA0zJsaOT4Lgoi/jzDY1pL2IvXA/1dDaL9s2au/ZjUro0VKdLtRRO8uljwtVzUu0gybamuxOIgobZ3dwHUJHY3WW+LV0jv+1iJnsHUMcU+uPI1WOKz1ArXarwUElGx2+W4u/5xnvOvF/Jv3KLXHhWMHupzNhNtmTooiDSXjHrmdqrEc9UXqNXW2eJUcAxlAmd/Pfe8qeMNTqzio90ngBDgifJKFNe4f7Np/3OnzfTalBaAbASdGLV4t4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbvQGJzx4hB1NKeaB2+YLQ3vrbC6jhRq9giBY2tn7sg=;
 b=b46EQ3WQzSO6VIa7A5EheB4UoK9XuDSYUuwmghTJ7/TjkgfchdgAr1A447re7GhXTI4Py+DcL1LWU20FxMkMKlHJXO6lqLbjgpoKFd1mg+X5hRorSgSgj9t3ihhN8vi9hiWneVfON7hiJrnyJJWR8uE9uxyMNIiXpSp5s6u8C04F3OkpUx9OupguADmz6guv1Wj7lrtxw9X3RMYIV9zi9WP1SYqmPoLH5T7kTdZxBewpfaotZfoQBAYd4rDPuxYWotYgcP/jB/d2aLbcOas0hli3yUKlZTFsS8Nl9N0qGkCJoVFAxpLpZKY6dXy3zB9NOjaczqeXY8/IVi4qMBZqLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbvQGJzx4hB1NKeaB2+YLQ3vrbC6jhRq9giBY2tn7sg=;
 b=ls45998WMR65Z+xXQU2v0DD16BO2EMZYIRjGhsLqPen/l2SadycGDhRInL+cO5Pi5oXhuvyRZel/328SZuj9WFhovmi33UD39dPU+51t6yQbpzp8CtlcSwfNbugQKx6cdjJXf6sUIJla2g/e9MTkcllw2JvMhOXH1Py73eNZXLI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2587.namprd10.prod.outlook.com (2603:10b6:5:b1::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 18:17:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 18:17:28 +0000
Message-ID: <28250f62-ff38-901f-6014-9e975381d523@oracle.com>
Date:   Fri, 22 Oct 2021 13:17:26 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
Content-Language: en-US
From:   michael.christie@oracle.com
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com>
 <20211022064359-mutt-send-email-mst@kernel.org>
 <94289c36-431a-513f-9b52-b55225f6b89d@oracle.com>
In-Reply-To: <94289c36-431a-513f-9b52-b55225f6b89d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0034.namprd06.prod.outlook.com
 (2603:10b6:5:120::47) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.7] (73.88.28.6) by DM6PR06CA0034.namprd06.prod.outlook.com (2603:10b6:5:120::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 18:17:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b90c647-7294-4c7d-effd-08d99588348a
X-MS-TrafficTypeDiagnostic: DM6PR10MB2587:
X-Microsoft-Antispam-PRVS: <DM6PR10MB25877B053588E4A70EDE649EF1809@DM6PR10MB2587.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FJel5o/JtcuNIcj01PFlqkQorkerxepTVgPhsvFOCuPcCF4ke7QqlIc8YOSnGhjSgMbDMFNdpf3YbACCO6t0Aq2vHZfBCvqbPlD+epHtKSEqw1nLExikjfAH+N3kvDzZ3jKqt5ZeMDejV8McGNRgeE40+Q3GgfiPMht02LWlFoJ2r4H6F5e6a95qjRrZCaGcm317YDeHQIkM0eSFC7ShphVA/JPw+ZJ+TkBpz33M+eK8lucnIBM2ZXoWdayk8LhUD8HFuZin7QOUSyigWCPm7NEt711aNr5HML5mBPsNSbKnWMOff88FBoG9N4UqQkeoUGPWQgD6gmXLEPXMH7H5TsqPK6Jd9PQWuLA+FGrwhw7oHgITX2WKt7n8m6BbXMuL8J503goAaAiefQSWt0OT5rwPZ5kDl+aDXyqA6W/9Zklh+zSie3JT4cwlAJknaeN2twe7wkle0uCGH3RHt4zIZmjk2j7ODQdIS3DtHKMkLWgSKgOxHQAVIKZN/a+95m6MAoeX9TiZDkQqxCl+FVPXfqeurI0P5v/VlRG3PU4ydHst0tQFl7s1eFma2bbz9UqEkvoztM/YDxOJiYBfNGslC9d5FPzlC/VHpRtF2zxLLesfwgrMRiAV4bTxiObImwCVdMFdXMmzyomIFx+FvA+rSywYnPhydkbYqkjaFgIIJJzNTssgfasdff2eq/qifxJQjHkM8aosyYxrztKAylkZQAIUAWcj2C8316d4tP4LpE3DRadrSNYnle61hNfg2o8l2H8Wdc5BSxjP+34eu51OUEXPJfcqXniRq6tMEVVa48V3vhq6bvShfQe+IiPJ7lkV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(31686004)(316002)(16576012)(966005)(5660300002)(53546011)(8936002)(31696002)(8676002)(186003)(6486002)(66946007)(83380400001)(6916009)(36756003)(66476007)(4326008)(6706004)(2906002)(26005)(9686003)(38100700002)(2616005)(66556008)(86362001)(956004)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXp1ZmV2ZkppK3BDM0JvSm1lMUNCN0ZaSXEwVXpTU1BMQUNnMHNzb09yUjRm?=
 =?utf-8?B?cGlVL2JwQzM5Y3hpMWdSRDVIdWo2eVZsVWVpaWRsRk9vU20vUm5MakRnR3ky?=
 =?utf-8?B?Vk5heGJ1QXphZFIva0FhOWZWM1FTdnZhUVdYTm9UOEMyTDRwM0c0aElCU2lM?=
 =?utf-8?B?aFkyRGNja3JCQ20zNTJYQlVISW5ISCtFaFFVSmJWREdHNXRyS1pPNER6UmhQ?=
 =?utf-8?B?VXlSTUJxV1lLaUVjbjBWQUR3U2dNUWZzV254NndFV01CeTBNWERTVGMxNXB0?=
 =?utf-8?B?UEc2M0RCUG1KdXVra1crU05jQThGMmFKYXMwd0ZSTktVUjdmU0hod0p2SEdQ?=
 =?utf-8?B?M0FHL2k0RTVBOXVkS2JvSmpydVAxQkN2cWhPRVdxeXIzQ1FadTY2QTh6VW1U?=
 =?utf-8?B?RktHb0x4TEZtNWtteFBHZVNKUjVsZ3ZpMkEwdnNodTJ3alY2ZlBOV2hqdGRq?=
 =?utf-8?B?RHhJODB3TGtWa2FBVDZMbk9yT0JGL2RtQWl2ZGNwMEljSDRZazcyNHhWTito?=
 =?utf-8?B?UlpMS2hOdDg0NXB1TjIrTTk2cUpQVExwWkt2TG1CR0lPRUZ3anVWUjVJU0dS?=
 =?utf-8?B?eSs1Wm5Sc1h2SnVIUWEwb3dMckJKem5EZTFRZVNVQ0F4VXpHSm82OXBNNHZ4?=
 =?utf-8?B?OHptcUkvY0RmdGxEMnJUVDV5bFh6NEZlb0xKSHNHc1ArNmVuZG5DUFFWNWl0?=
 =?utf-8?B?MXhZdFBJL2U0RFhIZmdEUHcvUlBUNE9VcHp6UEgyQi9hRldlSm9yOHVmWHdI?=
 =?utf-8?B?SmZLRjUrOTZodmZEZlNSV0dWVXQxYnNaNDRDVlVxNWlFNG5vbVJRTjNGWmRt?=
 =?utf-8?B?SlU3SllydjZnSTd6V0lYenpHeHovZVpCUTVJTlZDMGhzbFg5dUhpdVhMcG9w?=
 =?utf-8?B?d3Rzb0szNis3Y2RRcXJlNlVwQVpGdE9iaWpwYzZyZE1oVTVNSG1jL1JNblFn?=
 =?utf-8?B?RkVndExKeStyUjNqTjZmY0pSUlExdlBZM0k1eWcyUHpNditDTDdLanVOR3dN?=
 =?utf-8?B?MUlHbWdwSlZQOGMzbEo4cEZIaGhDOCsrcXA1b3N2STE2Ui9zUU9jY0FOc0t6?=
 =?utf-8?B?Z01rTXllTTY2RmJiTWtudXB4enhWcmlDdmRWaitZSHJiNVB4VXQycUltUVhz?=
 =?utf-8?B?d3VuM0hPbjF1cURVQ2czR2FCL2VPSEl1d0dGdVB3ZFNwNWt3cktvc3p1VkQ3?=
 =?utf-8?B?QVhrOGFCRjlaZjlJemhVRC9ZcDhheWt5WENOMDVvTVBCaFZ4b0dyTkNTK0dm?=
 =?utf-8?B?SmFBY3VscEwrbTdqSEVrK0dCMm9FL205d01LbURSVTBWVUJ1Q0w2Y3d0dHZD?=
 =?utf-8?B?eWhSNHRXQnlPTVROZnZNZjJ3ZURsTm12dnBYUXhDTGlRSTZtbUdpa1o0NnZZ?=
 =?utf-8?B?alpQVmpRZDlVSEJjQXkwSE02djk3NDA3dEo1Z1UrNHByaEZEWGhsRHZVVFlh?=
 =?utf-8?B?elZ2dGc0TlRqMUJCK2dCMTdaZEtNMHhDZnNkeElxRkoyRkswRU5hR1JhaEJt?=
 =?utf-8?B?NnhXV0tLY1hTdHJDd3hCTVUxWHgvOG1RSndHUmRYb092UFNhdTN3K0tkbjh4?=
 =?utf-8?B?YlJNVVhaMzdycWR2VSsxSExnSW5JUVJQTW1sNkRXQmdGb1JuaGNvSExmMkpv?=
 =?utf-8?B?NjZqeDFsSGRaZTJIVnNvOHQvSXg0Rk93MkNHR0FUekMwU2cwMkpBYXVwWlNr?=
 =?utf-8?B?K1F1VExKWkliSXAwUS9mZ0JEM2NKMlJEZmVlY2o1SDJHVlNtRTJXTHFEVXBV?=
 =?utf-8?B?K2ZxVVNaMW12Q3dSbEgyTGZMQTN0NmhTRDJKYUs1L2pOamhidVhiZ3c3SUox?=
 =?utf-8?B?dURlZDl0dXVUZ2ZTS25NYTVnOWVNdnFCTXplMnl5UkJDNnlhd2xiVkFSeUc1?=
 =?utf-8?B?ZGNGdGVMTUMzUlM2RkRaWmRSUzlQaTNHendZV01vMHUxS2pPSUp5VHpHQ2ts?=
 =?utf-8?Q?6eVMo6UIAzUBXLM8bzQWu9F82g9r4b4/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b90c647-7294-4c7d-effd-08d99588348a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 18:17:28.0656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: michael.christie@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2587
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10145 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220105
X-Proofpoint-GUID: LwNzYDXG7meQw0d1sw9YEPFHLp9p-ji6
X-Proofpoint-ORIG-GUID: LwNzYDXG7meQw0d1sw9YEPFHLp9p-ji6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/22/21 11:12 AM, michael.christie@oracle.com wrote:
> On 10/22/21 5:47 AM, Michael S. Tsirkin wrote:
>>> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
>>> index c998860d7bbc..e5c0669430e5 100644
>>> --- a/include/uapi/linux/vhost.h
>>> +++ b/include/uapi/linux/vhost.h
>>> @@ -70,6 +70,17 @@
>>>  #define VHOST_VRING_BIG_ENDIAN 1
>>>  #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
>>>  #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
>>> +/* By default, a device gets one vhost_worker created during VHOST_SET_OWNER
>>> + * that its virtqueues share. This allows userspace to create a vhost_worker
>>> + * and map a virtqueue to it or map a virtqueue to an existing worker.
>>> + *
>>> + * If pid > 0 and it matches an existing vhost_worker thread it will be bound
>>> + * to the vq. If pid is VHOST_VRING_NEW_WORKER, then a new worker will be
>>> + * created and bound to the vq.
>>> + *
>>> + * This must be called after VHOST_SET_OWNER and before the vq is active.
>>> + */
>>
>> A couple of things here:
>> it's probably a good idea not to make it match pid exactly,
>> if for no other reason than I'm not sure we want to
>> commit this being a pid. Let's just call it an id?
> 
> Ok.
> 
>> And maybe byteswap it or xor with some value
>> just to make sure userspace does not begin abusing it anyway.
>>
>> Also, interaction with pid namespace is unclear to me.
>> Can you document what happens here?
> 
> This current patchset only allows the vhost_dev owner to
> create/bind workers for devices it owns, so namespace don't come

I made a mistake here. The patches do restrict VHOST_SET_VRING_WORKER
to the same owner like I wrote. However, it looks like we could have 2
threads with the same mm pointer so vhost_dev_check_owner returns true,
but they could be in different namespaces.

Even though we are not going to pass the pid_t between user/kernel
space, should I add a pid namespace check when I repost the patches?



> into play. If a thread from another namespace tried to create/bind
> a worker we would hit the owner checks in vhost_dev_ioctl which is
> done before vhost_vring_ioctl normally (for vdpa we hit the use_worker
> check and fail there).
> 
> However, with the kernel worker API changes the worker threads will
> now be in the vhost dev owner's namespace and not the kthreadd/default
> one, so in the future we are covered if we want to do something more
> advanced. For example, I've seen people working on an API to export the
> worker pids:
> 
> https://lore.kernel.org/netdev/20210507154332.hiblsd6ot5wzwkdj@steredhat/T/
> 
> and in the future for interfaces that export that info we could restrict
> access to root or users from the same namespace or I guess add interfaces
> to allow different namespaces to see the workers and share them.
> 
> 
>> No need to fix funky things like moving the fd between
>> pid namespaces while also creating/destroying workers, but let's
>> document it's not supported.
> 
> Ok. I'll add a comment.
> 

