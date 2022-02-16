Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD91FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 02:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343644AbiBPCTm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 21:19:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbiBPCTl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 21:19:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB29BBF97D
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2022 18:19:30 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FMYXIm008642;
        Wed, 16 Feb 2022 02:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=aK2qL8uF4glVpYFLdvhBB2fwlBVcforwGcNda67f/ig=;
 b=YdjAankkErK9Cj2ICWtvADIN7Fq3Gv0HTjW/C74r1c5VIUjaVD2UK50pq00zaXctPoZx
 Igz7uBNQxV5CfvvO7smXes1UGNDukpI0zQTyCSyKhlMSCtbXN0O9pqgIBimk+Nrm6oxN
 RGUGQFaY63nxy6jrgKDfoUv5+ajzPEoqu/nkiP+ICWgd1Yf3VI0QhqLuaVOYCEg+Qsgz
 1+mLR+G5vxRTpITfQCrYrZ0BWM1ZfHND9bavcx2rIaNAkFDO4HXqqNWnxLNjHhWUBKsJ
 2eZxCOQf31WnIgEKrwboBKQQv4UMXgeObqadQNDSKVsyTXSAweC/JynDDf2RIF7FSzoz XQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8n3dr9xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 02:19:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21G2C469148703;
        Wed, 16 Feb 2022 02:19:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3020.oracle.com with ESMTP id 3e8nvruf29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 02:19:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AN+Vo8aMYphyj2VTVCJKZEglDJ4UjNjkX0z3H7S0GCnCq03TFYW+5TN6HbpAahW5uGjyjJhIKIYj7CjPB8+RzaQTJ5Th7BwxqWCPUMJnxTKNRIyUs+HYQbpmDZJAhfwbgplHz+vnbzHhtA4k6DZbp6ZixKkxhG40iqLXTuaZ30JQfp8oh6K6ADvKpHVY24aCu1PC7mbGmVxHHYJOfnxNHeGefN3OIwigcH+d6O54cO9sGQ8Hf27S4bi/WCaupCm4Uu1b3dq73xgzIB6yTdu4fkYcb2E0iHRSi56U7iAWtL3RJiJxe+8FkR6uMHBOPHHcjUOIhSGaJDUlxGVeorDzpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aK2qL8uF4glVpYFLdvhBB2fwlBVcforwGcNda67f/ig=;
 b=dPoM028/ViJYSvyRBnxbK3XHDf8nHXbHkP9a1Zec8fOvI5dKF0aoK51HAgDbStKNzzz2VKQWDSDenlWNF69d5/ZAKcXOmQwNEYQGtj45djLY4qmejJxI7OOrlXwDHhIjG3dbImFIuSVyX/mI+UGX8tJdUUHzXSxs3ZfXG35CHM3v8GIbP3qBg0Qm7MQSXA+VMdjLJ9LjEWYOVL4Vg9Oa6xmnhvnEKKc/mWsKJ1o9lqK2txYredx9nvWivt5Unq9H3A9ac1dITj0bZoa3UK9EiceGEP/Ztlv+VTAlJmvQXjH+pLvFkCJSFi2CpiPv0nOgT6iS684BhJqRTGRpDUGMgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aK2qL8uF4glVpYFLdvhBB2fwlBVcforwGcNda67f/ig=;
 b=TiZf3ACmbDeXuM/O2vVTSeK6+LuxbISX7+BDicx1fAfTCbmmNudoehr8VnuSpWGzPXEKL967Rn/bwki/sdvL+zKCVLUE7nkgtJFZ6g99fuNy+Qq75PoEr1otJdRXJYmlCGZwkLUmN0dJHBkcQdnmWTqsmbaQzbIKGJ7dbHTISUA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5322.namprd10.prod.outlook.com (2603:10b6:610:c1::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.17; Wed, 16 Feb 2022 02:19:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3448:8685:9668:b4d5]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3448:8685:9668:b4d5%5]) with mapi id 15.20.4975.019; Wed, 16 Feb 2022
 02:19:19 +0000
Message-ID: <be26ef80-c3cf-713d-2a9f-4fb73cec7e17@oracle.com>
Date:   Tue, 15 Feb 2022 20:19:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: Question about iscsi session block
Content-Language: en-US
To:     Zhengyuan Liu <liuzhengyuang521@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        open-iscsi <open-iscsi@googlegroups.com>, dm-devel@redhat.com,
        lduncan@suse.com, leech@redhat.com
References: <CAOOPZo4uNCicVmoHa2za0=O1_XiBdtBvTuUzqBTeBc3FmDqEJw@mail.gmail.com>
 <828ac69a-fe28-0869-bc1f-7fd106dff0aa@oracle.com>
 <CAOOPZo4Z2x_W7i=Vbnm-SsDgj5PndLVtOz6MqRzQxW-NeBwhRg@mail.gmail.com>
From:   michael.christie@oracle.com
In-Reply-To: <CAOOPZo4Z2x_W7i=Vbnm-SsDgj5PndLVtOz6MqRzQxW-NeBwhRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR19CA0035.namprd19.prod.outlook.com
 (2603:10b6:3:9a::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb68dd89-d2fc-4a6d-8b96-08d9f0f2bd0a
X-MS-TrafficTypeDiagnostic: CH0PR10MB5322:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB53224DFCB870DF2156230D4DF1359@CH0PR10MB5322.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sDJzrtgF4WukRtKICjX2KmBKra+TUlirweZAFnLewC/IkwPZgR3NyndsTEmYcuBP2eFadBij8x9eH9iMV+6LzMVQcEvPiF2XFpXnYnKFzPYi+XRd1Id4a9RqPCHjDFod8ktXC8n+b9NETvLE2Mw/VG6fKuhE/WKrBfZBdczBlEkKH71X8wDUsk2MJVxAqyD9vHxsnR5O8+PzT0/wS9cw8Wi1cjOGskT8zfsCzqt2htRn+OXm4EXPXi6QD3MzbPgqXln59yidAYO+eCchBdOUS2ErUYITgks+HrH8USu+McxKEfgsSKPkFPhC5mpBZoVzUuoFfrAO2xFHiCc7DuF+o1sy+ixckaj8xdHP5fl5Dxgvo56rn92YwpB0BkbwW9m/i9Y2HsvKxtcP/8bs39mluOFVl/5O4rl4hsvD9LFQ8522rU+6MsUWHiuJ5jNTZt19Wf/GJXIO/Z87W3JLMNQlJp73N5FE38a2hhyx8QAYz21NLdXxraFTAQviHgv2tb9l6i7M5RAaybxV4WAmIhSDzHFjii7kjOolzJHoUSsOB6ccbKABjwEpkXtmy3qrVuFsN0VRP3g4mA/2Hg0YyAk8m1/PGsqO+KSFwc0vspkuLZNmdFA0loBi2Q0rxTBvoA71GDKiTGHU67abOvcy2jjWateChwRZOV2RUIMY1UTQUZl7e95+NpWcN39h10DfoqfO6kmIp7YHwnhz7FdiDL3AtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(9686003)(26005)(6512007)(316002)(2906002)(8676002)(186003)(83380400001)(66476007)(66556008)(4326008)(53546011)(6486002)(66946007)(508600001)(31696002)(38100700002)(31686004)(6506007)(8936002)(86362001)(6916009)(2616005)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDN1Mm1JRGpwMjdlOERaOUhkRklDTGJSNE1IRVhlZHd1eFNIOUVZRkZxeVBi?=
 =?utf-8?B?UElNbWdJTzNRckpHUisxK21DYTNvZkZEbGk5ZEMwTEg3TFp0Q1llR1lVV1RB?=
 =?utf-8?B?SXNwSU1TajhRNUU0SzVjblAwWEVxVWw1NnNLQk42Z2tUeU0wUS9ackdjcGRZ?=
 =?utf-8?B?TzNqUmhqL3FUd1VoUURsK2lvNFd0MWdxaXFFNXZiUUtJUHBRaFU3dEYrcGgw?=
 =?utf-8?B?aUdpZVlVSnMweE9KT0hRR0lGS0lQOU0xMjg0UG85M2cxenI1clQyTWhYTXNp?=
 =?utf-8?B?Y3NZcUE3cmxkVmd4M0tiS3I2NmtVNmlURFVqOUxGNXJha0lXdUpoL1dFanR2?=
 =?utf-8?B?L285TmxQSUJ2NmRzRnloRE9Ta1R3VCtmekJJNWhhOThIZ1Z0WGtxaVhUSGI0?=
 =?utf-8?B?NTQybmNYcmpsdlBsNFo4RForNEpRVXdvUmxhZ1IrTyttN3MrTXQ0TEk4Z2Jp?=
 =?utf-8?B?enR2WXpxSmVmQnNRdzJxOVhmMm03QUdiSkNSUUlBL3pXREgrNnJxK2t5dHR6?=
 =?utf-8?B?eGZHY3ErbS8xR1YwSE1jZ1B3OFNBTVdaTUVVT2tSdEZ6WE5XR1NvVmxmWHI3?=
 =?utf-8?B?SFR1ZVZXcE1PdDhnYVpGalp3T1NBT3BWNjVVSXBWMFJZWW9UYXJ1eFdWaGVQ?=
 =?utf-8?B?NVYrOUNCMXdCZ0tvcElxSmRSSXUxSjRYNG9UQTVnNC9GYi9mWHV0ZExBTDlU?=
 =?utf-8?B?ZUpxajgrMndLWWprNitzb1lNVGQxSGpURGlRVlVTYi9LTEc2Z2ZTeVpDYU5O?=
 =?utf-8?B?WTRhRHQzYkx4SDQvSngyMTR3RFJuOE1kRFNEL1RTYzBsdmVaSEQzS1kxN1VL?=
 =?utf-8?B?ZjVWM0w0ZXMwTHVxMU1PekhiY2hpSjBZQk5sNzVrczhITHBHTGk1UjFGVWlW?=
 =?utf-8?B?c0RYMVl2VG1ZQWF1V0dMMEtXOE92cWE5K1ZpeTRjcTEyeHVlK0lvL1lIY1pM?=
 =?utf-8?B?Q2RKSHpMSE5CM1BoVjhYNzdxc096WXVFOHN3QktzeGg1NjhEVWxselNwUDY4?=
 =?utf-8?B?VURPSU8xMWdwUi9DYXVGeFZoTlMzTi9BTlFWaHJYbFZHSDdOdkszdHJWR3hV?=
 =?utf-8?B?SENoQmgxRVd0Rjh5bEQzOFZaRm9aamZuaE1iSUsrQ3VleWhhMnN5V0JTTHpJ?=
 =?utf-8?B?R09rV1hlbU5uWHB1a2ZtN3lnZ0FFWG91bHN6dHlEOXhrTlZoTHB2U1RkNDRK?=
 =?utf-8?B?aUxQT1lIaGNmNGpTU0tEdFh5c040ZDBma2lkQlF2dHpHNEw3ZkdPTlhEMjBE?=
 =?utf-8?B?cjAvVU92SXNabGxRSHRUYmRwTFFzTkVJZnQ4ZUtTVzJ0eGh1MG9hb3EzUWVa?=
 =?utf-8?B?M2U5NkZFeVphNmJDWFV3UXB1M2tnYUJCTy85MnRXWmdBRWN6UGw5QmVzNzE3?=
 =?utf-8?B?enFmTWdSSDZqaUtWRERZa2IyZjQ0T1RCeS9sNWtVWmpXcThWZnM0QWV4OHJG?=
 =?utf-8?B?anh5ek9mWDhmOXdvc0tSaVY3RlpCaUVLY2RJbmcxbEJrYVhSNmp4RDV3cUNa?=
 =?utf-8?B?aC9vL1NCblc2VGpVb28wMlpiK0d6cytFYlg3RU1FRGZyYUwrM1VkaXJvZ01m?=
 =?utf-8?B?Lzd4Mm84VStJTWZMczJsdHd3aTVDL2pGWVFlN1VCZzAyb05PY3hVNW5QVU5k?=
 =?utf-8?B?S1RZL2oxQUlMRXpJMmxZVStVMDhBYVdyNmJTUDl0ZXRWY2ZycTc1MUd5YlIz?=
 =?utf-8?B?QnVlbHBnOGE2YVVpUUxud3psSmJ5UzJkRWlUOHo0NDl1ZTJsWStQOG9yUFFK?=
 =?utf-8?B?UnBkYlZ1T1NPbFMvcHBjSm1HNEJTaGltSndaKzIwcWtFMXVtdkJjMHh3ZEow?=
 =?utf-8?B?dTJjZzRWeGtzNHZaSnNFN0JqUk1id2Fpek45dkF3dnU3cDVHZkZCZkpudVNE?=
 =?utf-8?B?ZDBNNzV4b0IyNUcwb2RsSllqREtjVm9pODJ6VUgwNFFXWm9BaUp0QnAxNVZG?=
 =?utf-8?B?bGRzQWhIQUE3WjlVTi9IMTJJKzljRmg4MjVQN1B2WnNkbXJEc0pDK3FkRGxZ?=
 =?utf-8?B?d1JxeWYvem41Sk5kVWpFMEJTY2VsZS9BSnpZRVFZd2YrWXdjaURiek1Felgz?=
 =?utf-8?B?VGxmSlhPYkpic0t6MnJHQ210S0s4RjRkaCsvZldtNnEzd3RJSnFMY0pNa1Fq?=
 =?utf-8?B?MTkreEF6SHJjam9pNUlFYktpWHBJVExxR3lDRjhZN25NM0VQMkhON005SDlH?=
 =?utf-8?B?VG1SY2xMcDhkakROeWcvNkdLdEd2QkU5aFN2Qkd1L3RvTi92akgyeWd0VE1D?=
 =?utf-8?B?Q3VFbDNONjMzK0ZvWDV4SlFkcHd3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb68dd89-d2fc-4a6d-8b96-08d9f0f2bd0a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 02:19:19.5691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QBOHo5i53lal8JbJhEruAw5SoHr644Kjg3Sfjr9X77L+1YAJC6SwSLBn5ySa4EmzK23EBZpaGgJ5g9I+VEE0iXGHJZEbqaGuBrneheszFOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5322
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10259 signatures=675924
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202160009
X-Proofpoint-ORIG-GUID: LsdzpBh__-iyfHjEaMtO1w_t80xcNXO5
X-Proofpoint-GUID: LsdzpBh__-iyfHjEaMtO1w_t80xcNXO5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/15/22 7:28 PM, Zhengyuan Liu wrote:
> On Wed, Feb 16, 2022 at 12:31 AM Mike Christie
> <michael.christie@oracle.com> wrote:
>>
>> On 2/15/22 9:49 AM, Zhengyuan Liu wrote:
>>> Hi, all
>>>
>>> We have an online server which uses multipath + iscsi to attach storage
>>> from Storage Server. There are two NICs on the server and for each it
>>> carries about 20 iscsi sessions and for each session it includes about 50
>>>  iscsi devices (yes, there are totally about 2*20*50=2000 iscsi block devices
>>>  on the server). The problem is: once a NIC gets faulted, it will take too long
>>> (nearly 80s) for multipath to switch to another good NIC link, because it
>>> needs to block all iscsi devices over that faulted NIC firstly. The callstack is
>>>  shown below:
>>>
>>>     void iscsi_block_session(struct iscsi_cls_session *session)
>>>     {
>>>         queue_work(iscsi_eh_timer_workq, &session->block_work);
>>>     }
>>>
>>>  __iscsi_block_session() -> scsi_target_block() -> target_block() ->
>>>   device_block() ->  scsi_internal_device_block() -> scsi_stop_queue() ->
>>>  blk_mq_quiesce_queue()>synchronize_rcu()
>>>
>>> For all sessions and all devices, it was processed sequentially, and we have
>>> traced that for each synchronize_rcu() call it takes about 80ms, so
>>> the total cost
>>> is about 80s (80ms * 20 * 50). It's so long that the application can't
>>> tolerate and
>>> may interrupt service.
>>>
>>> So my question is that can we optimize the procedure to reduce the time cost on
>>> blocking all iscsi devices?  I'm not sure if it is a good idea to increase the
>>> workqueue's max_active of iscsi_eh_timer_workq to improve concurrency.
>>
>> We need a patch, so the unblock call waits/cancels/flushes the block call or
>> they could be running in parallel.
>>
>> I'll send a patchset later today so you can test it.
> 
> I'm glad to test once you push the patchset.
> 
> Thank you, Mike.

I forgot I did this recently :)

commit 7ce9fc5ecde0d8bd64c29baee6c5e3ce7074ec9a
Author: Mike Christie <michael.christie@oracle.com>
Date:   Tue May 25 13:18:09 2021 -0500

    scsi: iscsi: Flush block work before unblock
    
    We set the max_active iSCSI EH works to 1, so all work is going to execute
    in order by default. However, userspace can now override this in sysfs. If
    max_active > 1, we can end up with the block_work on CPU1 and
    iscsi_unblock_session running the unblock_work on CPU2 and the session and
    target/device state will end up out of sync with each other.
    
    This adds a flush of the block_work in iscsi_unblock_session.


It was merged in 5.14.
