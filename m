Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D8CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 16:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BA016112F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 16:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhJVQPN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 12:15:13 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22866 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231453AbhJVQPM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 12:15:12 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MF3gS4007707;
        Fri, 22 Oct 2021 16:12:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=a5/ZacTirh5C6OtfIPh9v/5b4XQV4PjCVjCrrLkzz8o=;
 b=K6Kem1+mKKLmEXJySm3tG/EIz5kpS0H4trEI3DDwwe8IGjLytjWrDyJyPsDZJrGS5vzq
 zX3CWTXxcLGcy3NQCX1aJIWB46mKtmJrsnZQG9pCqLErBLh5IV/w4O0LJiJ49QMYYJOC
 BJ3k3NR5YXYhFsPtKk8wgC0sINuwKEKTixj2rtSpOy6u0xDrZYQv38tPCa5AkX5DyD/W
 G8+VFSlCLImU8ORMMh+ZNUUHNdxdg1XNHHm8zkBMbgJSphQ26cljvQDddy1jqeiZXKqH
 w9lfOpJS2dEMo+z3MyCWOeeGPnI+nqMyMlnd9BChOB2AxCMIAaCPeDRAtm9LTJuQjqxI 7Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bunf9b21n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 16:12:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19MG5jAr072098;
        Fri, 22 Oct 2021 16:12:50 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3030.oracle.com with ESMTP id 3bqkv40x12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 16:12:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCdx7jphsM/O3ZLcYUF4Ultef+C50mHijW3+ck6EjjmWJCgOW6Pz7nqakN9r41anKYTR0wLDnoJ92+Ua8LK/rcS1gT799Wsy4tm8lylvcgjBTTqwjB/Lm4LyIVVGmd9e5XHwc+3YGfjybItE78gUPfW0ezC41IbBLJIhA3geEu2alCUIQfAtfiYDAuHlAoGRtOlRfTsV7TuzIjlrAnvy/Nl5YiJS7j8gbeuDUmdoMNfo+g3ckRVTt5YDZ2ud8i8XgQ5MZBLLaIf7chQEvS/zqv5r871GXyicTKmPUnM/EUqggC/ZX6+aNloqD7YlwaFYWcyGCAKVWRjplhckv6Z/2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a5/ZacTirh5C6OtfIPh9v/5b4XQV4PjCVjCrrLkzz8o=;
 b=CkKtU2ZuLlWu4iFRFsnbtMxkUpZVm+kAElJaAben2e+EfKkeKDCs8g4vwLXPq7z7lO2lrxI33K8tD/aQ1M4yTAMxAvo0JUQvfeJPHVvS7Rsbst+L9r53tSGeX8NU+96Rc7rzNGOINtjz59gFL1Eddx2EWU/ZraQIY+72UlgYxzre7KeJSiptZ0aPVpIj5cC8GbqgqeU1eOpM9WeBMNqyHfIqZ9WYFgWHG9LrrlWj7qHAI01VXt1hnfMuCJfQkgXq6OAYLr8YGQvZ7SUCXFcSCIoJi+n3dPGqYJpVp4Cd9gvee8mIWwzXHn+iXJMFJbxsMtr0Wp1d7tsjdCBj8Ur/Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5/ZacTirh5C6OtfIPh9v/5b4XQV4PjCVjCrrLkzz8o=;
 b=viYxp1+cpd+v6KEyzHp9v53ZjtWxcSHpZrq76AcT7hNReaKd4Mkf+xIpmxfFNM37VhUGgpZDe74ci8hYyt+ggCyjMoDEXezkmHl96WB9rTqVUokgLNyj1b4SjikxFeHQUMItseWeHsi8w9Wb8Whivf7qgeiT6Ua/ZuU7bU3bTf0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3225.namprd10.prod.outlook.com (2603:10b6:5:1a2::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Fri, 22 Oct 2021 16:12:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 16:12:46 +0000
Message-ID: <94289c36-431a-513f-9b52-b55225f6b89d@oracle.com>
Date:   Fri, 22 Oct 2021 11:12:43 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com>
 <20211022064359-mutt-send-email-mst@kernel.org>
From:   michael.christie@oracle.com
In-Reply-To: <20211022064359-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:3:d4::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.7] (73.88.28.6) by DM5PR05CA0019.namprd05.prod.outlook.com (2603:10b6:3:d4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend Transport; Fri, 22 Oct 2021 16:12:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9b6526b-518d-410b-2ddc-08d99576c8ce
X-MS-TrafficTypeDiagnostic: DM6PR10MB3225:
X-Microsoft-Antispam-PRVS: <DM6PR10MB3225FCACC0B28DE0AA23238DF1809@DM6PR10MB3225.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MJ7Yb2buFXrkjGW4GxUjvTtW2N/E4ky6qu0k+SzxhJC8NpMPqob4xviwkNPEZxRwnALIB5g0trwhCrtHBT8td8AatYao2/DYvs72cPf3u9Rd2CeZJ4ahnZ/Tof6hkNkNBylS0PLPzV1Rvk1zCUA5AluNzX32UMn1Wjk13CDXnHG47jVEX5rOyhFuqWxkqFW8zpYvdke26UwwjZiOcBYIN9tXwUctLZySGsvQRQh7Zp4DyMWtHb+FuYW1ZzLxBBGZnPlbmIiYnp5R5Sme2prXXA2w+fACS7WEVJ+KtjvhonK+2I+lp3S4MaloaWvUVud31C3nPQ41R9kJkvzaZkeyP614fPrAXJ75PgoHJxruZpMXCr89d9bDt3hFE2eyH83W1OkuIkCHSE5PDBNXL+rHc3b4vqr9d+GLEVf7zhcsOK9MoICvlNAZiAYRQKvhe/d+UajJA/kX5Jp0M/PQeBSXzU+MKCTALRq57urKfkJcH4OFsU+slNSdy8biBuLNCgUVm7PjekQOIrdAJdcVhGFG9+QzK9dx/46j5uYJijOGbk0sj/+64HXBUcjzU8YOxQZLw8lSNoTzAnJjSf3gIvPR6OczSS/rJTH0oGC3ZtOsKCaxgV+Zgta4kiTxc3UHcnOSr0UAEk8FmOrms1zPDXTsbZZOQbOXlwmSYtWOkE50yqw+D7MrBxiTlVEyqMyKbEWJA/aAKzohbSDvwAJxGykWHiJp5laqsaMRMA+8yk3CDylvVeuFL5cmQluBWroaU+O9KD5eMHApqATQIWIfkfpfCyx2Tci3i/F+/Alw8bMSQWUa2gheky53+8zOA/xd3MVN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(8936002)(31686004)(6916009)(2906002)(2616005)(16576012)(83380400001)(66556008)(66476007)(508600001)(86362001)(66946007)(4326008)(6706004)(31696002)(956004)(6486002)(53546011)(5660300002)(36756003)(186003)(9686003)(316002)(8676002)(26005)(38100700002)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEJreTFwQ3FMc2dHRG5OTGYveGVpM05oZWh0NFB5Ymt3T2hLZ09tdjhlUFdS?=
 =?utf-8?B?dE1kblVmb2cxWU1NYU82NHUxQWRIUmxOYVZRdHZXMzRiOHdpeitDRHlsOThS?=
 =?utf-8?B?OGJOUXF1b3N6MkxibzU3VkpYcm1aRVZvWFZjVTF5eDRyc1FBOXRWT3pZbmRX?=
 =?utf-8?B?QkY1TnZmNC8zNCtPNmhKTFZoc3VCQ2tKcnVWOVpOa1oyemJVNnVCcjJnS21u?=
 =?utf-8?B?a2I0QmQ0M0lKei9sSldBM3h4VWJiMTBjY1FGNWpuUE5PVDZzOFJZMnhjMk5V?=
 =?utf-8?B?NEJqVm9iU214UDdoUDZPZGVqd1E2d3FPM3NQSXlkSyt2cWtzWXFLeHk3cVZM?=
 =?utf-8?B?N3U4cldUNVpEaUxwWWJNRlN5dmNJaTU1SGRGVTV5Q3BISzJ1RU01MkhPTlFQ?=
 =?utf-8?B?UzUrNDhEekpmOCt5alZKb2E5VTJCaEE0d1NFZkN2VGJhOHJtRy9QS29Od0Rx?=
 =?utf-8?B?T1lZcXR6aTFFTU94NGtySzlQM29UaE9MVU9jQlU4d1BIOTd4R21tdGpHMHkv?=
 =?utf-8?B?dklkYWgzemk1dmpZRm9pQUtWTVdNVnhQWkkrM0tjY0ltSk1TODBLendZUDVI?=
 =?utf-8?B?MjZTRDZNRDZzSkh4VlFkZTg5dVNkU29xWisrOSszVWwzTndwdWVQOWpNeXhz?=
 =?utf-8?B?bnZSaThSNW5WTFFUU2g1TVFveFpQU290eXNHSGk0Vlp6bGsrVzgvRVlucnFY?=
 =?utf-8?B?MXVvRXI5ZDZxdlUwOUdBNnpoeWNPOXNJR0ZLcnVVWXRNaXVxc3VVZEVLRzFW?=
 =?utf-8?B?WDlETDVWVWFyT3B1cVo3SURiYmFVNjVBclNERC9lbThoK1lxN2xhOVhVeHFj?=
 =?utf-8?B?cUYrYWNjYUpIRWh4bW5KMzhYdC9KOTJTN21WOVg3NU9CVW9mV0YzNk43MXhF?=
 =?utf-8?B?R2M1ekVoVlZZbGJ6SzFYSCtaVituNmljREpUc1V5enQvakZYT2xnNU4vMlJ6?=
 =?utf-8?B?RGplMFBCaDlacFBhOC9lMGlydDdJS0Uxd2dsSXpmdjFNZFZtWFlFSysxaVB5?=
 =?utf-8?B?RkRpbFBtd1ZnZHRjT2xYeFNkMGRXU045OWRyT3BRZzdKMDh1SEoxTGp2WDlt?=
 =?utf-8?B?bVBYVlpZbGtiVzJkaVd5Y3ptMEoyQVhBUlVWckVKdE5qc0pmWFRsS3V5TmJK?=
 =?utf-8?B?MkVFVzBmOVR3L3ZDS1NPVkh2YVJZeENOTDByUXpFdEVSbE9FQkw2THJBN3Qz?=
 =?utf-8?B?OXk2N2xzSFRPYkcwUE9abGNTQWQ0MGRYYkxPTlNIUVQ2M0lyU1kzK1VTT3FQ?=
 =?utf-8?B?VlZxdUNURjZGN2U4aGVXdms4T2tVUUZBRUpDc1NkNFJ4Q1BNRXBEMktERmNq?=
 =?utf-8?B?TUhXY3l2MWtHa09qN2diOFVMbjFqZ09vakxPOWxTdjFhZUZsRFEwcm9iVjFU?=
 =?utf-8?B?blV3enhLcFZFL2RlT2tFODBSZUhOaXZOaUlVOEQ2RWpjTkxVT2tXcHhmZjdQ?=
 =?utf-8?B?dGF3TFMrV0RqUlBoRWFqN0RGMVBrWTA0MnZlV3h6WVZxRVlRYldGaldlRXlI?=
 =?utf-8?B?VXNWenMzTk9Cek9JYUt4YXN5M0hVN0dJQktEY0F3cDd2ZVA0MU81L0J4dU43?=
 =?utf-8?B?dUltMnRrM0x1blZoQlNSYjhJSWNGSDVFeitXSUtvRXJkT0RVTU14WW5yVE9M?=
 =?utf-8?B?ZStPTEJ5UEZlbkhHVlhZb2w2T052SThubGVPY0FPNjJtUzZLVFU4c2JXY2RE?=
 =?utf-8?B?cytpb1NGRVF0U1cvVzBnQlhkMEU3T25scUxqVFJDUWlZS2pSOGRncU13MWtz?=
 =?utf-8?B?ZkwyK0xVeFdraU9jSm43L1lTZTVKSG1ncGl1TUowb3RuUVB5cTMyNW40emI5?=
 =?utf-8?B?cWtCTHNqL2ZycEcwT3dDd2w1L0xTdkFoS3daSWUwTW5WRDQvQmtJQm9SK2d1?=
 =?utf-8?B?d1ZuenpPZzBwdURsT2FFTml2K1hiZTZMQ0p6bkZoeEw5Y3ZFZWFYZHlqVDJp?=
 =?utf-8?Q?stoRW7Iz/rQVV+G85jXvO7T4HumBad0/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b6526b-518d-410b-2ddc-08d99576c8ce
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 16:12:45.9149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: michael.christie@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3225
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10145 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220093
X-Proofpoint-GUID: TXRLHMjnTcy0TcdKAr0lcKfpif3jclip
X-Proofpoint-ORIG-GUID: TXRLHMjnTcy0TcdKAr0lcKfpif3jclip
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/22/21 5:47 AM, Michael S. Tsirkin wrote:
>> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
>> index c998860d7bbc..e5c0669430e5 100644
>> --- a/include/uapi/linux/vhost.h
>> +++ b/include/uapi/linux/vhost.h
>> @@ -70,6 +70,17 @@
>>  #define VHOST_VRING_BIG_ENDIAN 1
>>  #define VHOST_SET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x13, struct vhost_vring_state)
>>  #define VHOST_GET_VRING_ENDIAN _IOW(VHOST_VIRTIO, 0x14, struct vhost_vring_state)
>> +/* By default, a device gets one vhost_worker created during VHOST_SET_OWNER
>> + * that its virtqueues share. This allows userspace to create a vhost_worker
>> + * and map a virtqueue to it or map a virtqueue to an existing worker.
>> + *
>> + * If pid > 0 and it matches an existing vhost_worker thread it will be bound
>> + * to the vq. If pid is VHOST_VRING_NEW_WORKER, then a new worker will be
>> + * created and bound to the vq.
>> + *
>> + * This must be called after VHOST_SET_OWNER and before the vq is active.
>> + */
> 
> A couple of things here:
> it's probably a good idea not to make it match pid exactly,
> if for no other reason than I'm not sure we want to
> commit this being a pid. Let's just call it an id?

Ok.

> And maybe byteswap it or xor with some value
> just to make sure userspace does not begin abusing it anyway.
> 
> Also, interaction with pid namespace is unclear to me.
> Can you document what happens here?

This current patchset only allows the vhost_dev owner to
create/bind workers for devices it owns, so namespace don't come
into play. If a thread from another namespace tried to create/bind
a worker we would hit the owner checks in vhost_dev_ioctl which is
done before vhost_vring_ioctl normally (for vdpa we hit the use_worker
check and fail there).

However, with the kernel worker API changes the worker threads will
now be in the vhost dev owner's namespace and not the kthreadd/default
one, so in the future we are covered if we want to do something more
advanced. For example, I've seen people working on an API to export the
worker pids:

https://lore.kernel.org/netdev/20210507154332.hiblsd6ot5wzwkdj@steredhat/T/

and in the future for interfaces that export that info we could restrict
access to root or users from the same namespace or I guess add interfaces
to allow different namespaces to see the workers and share them.


> No need to fix funky things like moving the fd between
> pid namespaces while also creating/destroying workers, but let's
> document it's not supported.

Ok. I'll add a comment.
