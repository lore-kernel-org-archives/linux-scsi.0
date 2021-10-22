Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD7EC43217
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 15:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59BE360FBF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 15:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhJVP4x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 11:56:53 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:43118 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233268AbhJVP4w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 11:56:52 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MF627R027916;
        Fri, 22 Oct 2021 15:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=A9zBQ2QxeBgH+QoCMJgaPSxPgvu8Ckq/XDKDwS4N+HA=;
 b=mqES9rK6jfb46D8W4JiOEhV8i5Y5CR5YW2vrExcIk6YOtSf7vml10PjzabTSMKfCaIgq
 /RcDB4BrfK0AN0vqAufrkpGVGv7SqoP7XQBqb+3bjvY8rC3RP64fB8Lg8UqXqY4PbVlB
 gAppYKkuIc9nhMHpgh1Qb5tRV1ASwBrGWqIiE7Ghi91U+jSL+XnWHf79LhjL4johlzmT
 PBu7hgLFol8qr/RRnomiPb6lewMqph7HIelt86hg1+aRZ7kyApTcL/41ZZVaFb1k3g6R
 Il1BS6ZsQD0vuUHXHRLfnC9mwmCUhLyjTfV3BZfrnzaqohwzV1OjsfY1DZor+sgyk+FZ Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3buta8a15q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 15:54:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19MFpJBE063185;
        Fri, 22 Oct 2021 15:54:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3020.oracle.com with ESMTP id 3bqpjatg93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 15:54:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjfTeMv59Z0Nr5vwnThzHmft/3ZxMWYvE+F8n8qfbqU7kxvBrOdBdmc9jBi1lPPPpu4GfZGOOKG7V5c13jSxhMgRN+wBHejKgLu1DHo9xFjbYFSDhbcTeSKCXs3IOkaBA1bkHEHiwepDGCsL+jnOO0bKubs6uoPuin6EUs1LtfsSNcooV4nCjSrynxnlV/bOcT+btFge2CSphWX5ACoKLmHPCYiadVKJ9ALIfnYc6wdBe7WM7IbdZaCbsn+1xDrGvg0ajmsb4XVhrJS1HFvNIoGEH3ANj3NyGyoWjWbdIf9lKa2droEq9eduOFf400deUqF841OsLXIbiBQHc8VYlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9zBQ2QxeBgH+QoCMJgaPSxPgvu8Ckq/XDKDwS4N+HA=;
 b=UsXioelFCJos6W3w4+fIS1J1G6COCQMlwBoYtVISC8KmfuqEiOt94gmGtSgOGptWJSsL9m3dBS3BpvhQZSqh9Cib27zU66WumMH7DVxWD/s+p3i+Cw4Wz9TDUkVXgka/f/XgzMa2zy5+0zV9Nzo2u7cmHKYWVpzdSEfaL21+dBHhuAhJMSIEo7oCMh9jXN7ch4b3hn1pucN9zs3+Z0PvPvHI6z+4aYAroegvs6+o9skjsZX8thlnAzBedGUxUXe2oxXzznOi4P8SKLSwnLEEabiklTk1yza/CLBaQw/x9rv64Y9xSZ/71Rt4a5KlCMbkGmUd7vOnrlHHaBxx3lrW6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9zBQ2QxeBgH+QoCMJgaPSxPgvu8Ckq/XDKDwS4N+HA=;
 b=DeBOVWplo28qsmpFsZSZkzOS7A97Rtc9LcSRDZqPQ1WVZ/B5plgWq2G33hmd74myIbhQwiVkqkvUVjcYwTnPhxSOXNa5K/vYwsEEli9lEzj+/ANFOQRELgc36PmWUfKONah4tuIt1r1Jc98a0YECXfTxLK+IgpfFBs7m2MTLRGs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR10MB1385.namprd10.prod.outlook.com (2603:10b6:3:f::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Fri, 22 Oct 2021 15:54:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 15:54:26 +0000
Message-ID: <2f8a975a-e01a-5671-7c3a-3b19c8564cb3@oracle.com>
Date:   Fri, 22 Oct 2021 10:54:24 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH V3 00/11] vhost: multiple worker support
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org,
        Christian Brauner <christian.brauner@ubuntu.com>
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022054625-mutt-send-email-mst@kernel.org>
From:   michael.christie@oracle.com
In-Reply-To: <20211022054625-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR19CA0012.namprd19.prod.outlook.com
 (2603:10b6:3:151::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.7] (73.88.28.6) by DM5PR19CA0012.namprd19.prod.outlook.com (2603:10b6:3:151::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 15:54:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f74c42c-deec-4a25-e6bc-08d9957439bf
X-MS-TrafficTypeDiagnostic: DM5PR10MB1385:
X-Microsoft-Antispam-PRVS: <DM5PR10MB13855C1485D0E2F995AC63F7F1809@DM5PR10MB1385.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZIY7JemwpihzTQUEJtT9G82hBYzTQhD+9IuaSbGqrnHhocJpH8h5zcjN6WS77tcmo+7YC17DC0ZaGakQWJiM1so+P7pfneK4vWMRHDos+nhy+kDIAWtt3S9nNsdQIPzXPP7o9PKI0X7Z3atQJtqpEtSwGHjZ9a5ktkfeyPq/bRhC9G6S2naw0woP4iPBU2FGejYrCWs1Pe2iIKtfMrMhlhPYHUaKCIzvw2AdtYKGYIzl3razOpv5lI9KUzAxLkry6S4GOBo3ETxnafpuNuDsxX0T3BuPYfgUSIlhVe/FnA3B5TVO/EGOD1iz+HJfk6yp4RK8Qe2CKGIIXrvL+Ua0Fql4jakIxqKCMklRthUPq4NTrkjETHwkA/BrFuHFKERAA2G8TI/Q0mhbO32xreY+G3QF3TRZoRCdYhkckqUhXnyChFn34s0XCaXlwomAwUO5zoxG8W23urWyNJ3tlRKaZqm91julEIpDHurucdn+h0O9ov0zvKIyI7FBb3H05P5L985PE56tsV5GtCJPS+D4yuV+gg0JzvCz2U2kXL0gxCUktcAq7cUHP3feAkrmZZrY1XOgn01tqGV+XWKyJ5n8UkxKhDqWow+XF9o2aQbiLlnrSrV+ya8/m3MulnWp4uGyo+H/GtJ1WWn5Vq5ojzkqHuwlMUqeSKtW9Ex8xwnaocS+hTQKiXx9rVDPN0Ol2VQbcHFIPlrOIOEmWIwL3KpihSVXYgto/LWW/s5yCf5I3GQq8M29vlAmTnazHBaUiedznMsnDeYmjh7mR+qf1Mn5yZQgckgyZa11RoSZox6Tn4Km9N387jMXbvgQp6jesRq6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66946007)(956004)(26005)(66476007)(53546011)(186003)(966005)(8936002)(508600001)(8676002)(4326008)(9686003)(2616005)(38100700002)(6486002)(86362001)(83380400001)(5660300002)(2906002)(36756003)(316002)(31686004)(16576012)(6916009)(31696002)(6706004)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1ZzejNDdDhtbkxVRG13TGRxVE16cGtleFducG9KZC9tZExHYmI3MmRkeTdq?=
 =?utf-8?B?T0RaazJLVTB6bklNODlZUm5Cd3ZNa3RFdkhnYkFPVmFHc1B3K0FLYTdXZ0th?=
 =?utf-8?B?S1A2Vmw0czFYNlRES21OTU5XU3JPenRaMmRqa2J1cElFcUNWQnczSzhPZjhI?=
 =?utf-8?B?ckR6YVZJT3d1cDRGK1NBOGN1Mlk3M2lZcU5TWEhsdEVtK1d1RUEwcm1nREpQ?=
 =?utf-8?B?aXJKT0ZLU1RNVUQ3M3NZYVZqWnZjK0VNc2J4WjRlbGRRZ3E3M0ZUbHNEc1Iz?=
 =?utf-8?B?QWx5SHlQeFBxZ0o3ZC9IZitWYVRIbm44SlYrV1F3bEdoOTlQc1Z0RWNLZjRD?=
 =?utf-8?B?Mjl3QjVkQUZhOGZ6WVhEQ2wrTGI0bTFVYVViOE81NjJqNElqQmdHUGNEY0dW?=
 =?utf-8?B?MkVFM25uNUFpeDhUU2xOZVVuQUdYM0ZCcUJqcnIvWkpVYTU4c0dxWEhURmkr?=
 =?utf-8?B?eERtZjkzdDlRcjhvZVdkbVBab2p4SEZqblI1eDNiZjN6Mnh2WkoyejNtYmNH?=
 =?utf-8?B?bWZ0NUsrdmJFMlF6OWpJUkF1eEdLWUhMSjFvNWx3QkhhQ01MaHVEYWNDMzRm?=
 =?utf-8?B?OENsOXNRdUlLOHYzZDcvYlV5SkY5VTdJMGdMa1RzSTNPN1RLRjVGMGhYWUpN?=
 =?utf-8?B?VENoWEdVM1lxeUJGQTFWck9sbThtQWpuTlA0S3hiRUNzVFF1SXVjTEdWSVE3?=
 =?utf-8?B?L1NXMXYvZy9WN1lLWTRhaGNZWGN5WTYzbWt1eXhGeEFnVXNBcmoxb1Z1Rmtv?=
 =?utf-8?B?RlpqNG50MWdWbmRqL1psVVhueVFKeWNsRVdPQjVSdjg4NlJCVUV2Q0RDSi9B?=
 =?utf-8?B?eGx6VlNnQm14cnBTYU9JOVNxc3ZETGxjNVM3d3YxeklyZGRwc3Q3TENoUWpM?=
 =?utf-8?B?Tzd1aXZXZ2VUV1ZmMmp2V0xtNkxCdllBUUJtVUI1YVV1L2NwQXNkWXAwNnB4?=
 =?utf-8?B?OUhKZWg4dTM3ZVN1OVhGdE5yZ2xxdlFneWg4Y0hGbGMvWWwxMUVHQzhGRkV2?=
 =?utf-8?B?WEpOODVOaUR6UlZkSlJQMDlObDdCOTk0OEMwWlVZZEMwWWpmenBpRnpMWXFL?=
 =?utf-8?B?Q0p0SS9zT1BpbUVmOUFhY1Q2MHJ3ZTJFbUM4VTN3SEprQWVTZkxCUWd4MC9k?=
 =?utf-8?B?YlRJa1E3M3ZTRnErV1JkWmwvazR3V1BNNEFRQitEZlNmaDc1YUV2bFA5RlU4?=
 =?utf-8?B?YVN3b1J2Q3E1NWN3dlExTDZMUTJ5cW9hRDhtM2kvYnhIa0lDYlhLNktVNUVF?=
 =?utf-8?B?SE00UlRUUzBBSjUvUC83QmQ1eW1CNTJ4a0NhMVFSamdmaHB4QTVtWHRGeDlr?=
 =?utf-8?B?VzNwS1pxWTBDU0JtenQxc2xLUUp2V0l4UFNyTkhydXFyNzZ5K3gzaW1iTlpz?=
 =?utf-8?B?bGdiZVNIMy9RR0xWVUZ6Q2VNSnNab25RaU5QbmpIVEdCLytSMzlEN3VqVzdn?=
 =?utf-8?B?WDVDNkJJM2R0TmY0RmduekJqeUlvbDdsNmFDeklleXVNZnlTNXYxUmROSzdX?=
 =?utf-8?B?cDAxSkdVdDJHRGtkazdRWGhaNmI4VHFpeFp4RElzMmlPbUtqQzVGTjNYaFJq?=
 =?utf-8?B?NjJYaEo5ckhtNlRQQTh2NUJTSzFTWUtoRTFYWlVJNkxQUHl3YzZZcHY1MWp2?=
 =?utf-8?B?bVJsUXFNMnZTQ0wyU0JDQjJLcjd2UjNKOEE0NXVtaGdpbXhsZEcyODJtMUtR?=
 =?utf-8?B?RjVwYWZraUNKZ0c4UnljV1lJeHJSM003ejlDVkk3VzlIWkVqS3dWN280MHpH?=
 =?utf-8?B?MjVRZkVRMlVDK0FITE5uaTBiQjVPaldNL0VWT0NDdlpnckQ2Ry9kYzk1RTNR?=
 =?utf-8?B?OThlb0UvNHdZNDJxNm1Gb2oyZDY1ZmZYSC85T25GZFFNd0hvTE9mNHA4WmdP?=
 =?utf-8?B?TGljeUxLTGYwTkUwekdGZ2FyMTNhMFZVdElLVlNKcHR2RTNtNThjNk9aRk5T?=
 =?utf-8?Q?pswlFPOi4rLzNl+/KqCDTP5G+Ydb20JK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f74c42c-deec-4a25-e6bc-08d9957439bf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 15:54:26.8887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: michael.christie@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1385
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10145 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220091
X-Proofpoint-GUID: 4LgFhKMjsMLiRepV3Nk1H1QPt0eoantB
X-Proofpoint-ORIG-GUID: 4LgFhKMjsMLiRepV3Nk1H1QPt0eoantB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ccing Christian for the kernel worker API merging stuff.

On 10/22/21 4:48 AM, Michael S. Tsirkin wrote:
> On Fri, Oct 22, 2021 at 12:18:59AM -0500, Mike Christie wrote:
>> The following patches apply over linus's tree and this patchset
>>
>> https://urldefense.com/v3/__https://lore.kernel.org/all/20211007214448.6282-1-michael.christie@oracle.com/__;!!ACWV5N9M2RV99hQ!aqbE06mycEW-AMIj5avlBMDSvg2FONlNdYHr8PcNKdvl5FeO4QLCxCOyaVg8g8C2_Kp5$ 
>>
>> which allows us to check the vhost owner thread's RLIMITs:
> 
> 
> Unfortunately that patchset in turn triggers kbuild warnings.

Yeah, that's the Jens/Paul issue I mentioned. I have to remove the
old create_io_thread code and resolve issues with their trees. Paul's
tree has a conflict with Jens and then my patch has a issue with Paul's
patches.

So Christian and I thought we would re-push the patchset through
Christian after that has settled in 5.16-rc1 and then shoot for 5.17
so it has time to bake in next.


> I was hoping you would address them, I don't think
> merging that patchset before kbuild issues are addressed
> is possible.
> 
> It also doesn't have lots of acks, I'm a bit apprehensive
> of merging core changes like this through the vhost tree.

Ok. Just to make sure we are on the same page. Christian was going to
push the kernel worker API changes.

> Try to CC more widely/ping people?
