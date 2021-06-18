Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED159C2B9F4
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 02:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF26F6135C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 02:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhFRCv1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Jun 2021 22:51:27 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36602 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231147AbhFRCv1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Jun 2021 22:51:27 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I2g2jI007240;
        Fri, 18 Jun 2021 02:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=R1LRhM24XqNWB7jKR15pNmTDJ/XgrHg8fsfkyGcyIsE=;
 b=m9pwFX6/wilfYLggYvE0FhhfEhCR9ZakA71Ivu0w7VwiB4yyP3O2WRv+YLOEvkG8k3Gb
 ejeiwFIf7TwZnC5KSIZNzDA0fi61H4tIpemDG/ukCVu0l3zFwjP/+z/LUokhh9gHe64Z
 PfQPCAnNDMgKwJLyNp293JUCgqod/jStiCyEP8+uQmqsfNvgcMLM0SEB9IdjUxQHZg4p
 lXb+dOct5T9JbeKnLDQvWCmAaDus4FpgrF7SFTe9va5HHRd0v1L7oJoeREEpadPiQhyR
 wjGcg/OXNhLxQMNvyoINbBCxuXuNfzMakYuN2iuyRfBPty/4LfMDV6qlg6ccmWHQp/kU KA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 397jnqub55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 02:49:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15I2iu5p062457;
        Fri, 18 Jun 2021 02:49:12 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by userp3030.oracle.com with ESMTP id 396waqwf6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 02:49:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkBr1n7C7YI95izWn1yk5PfG5btWcJjMgZGUuN+kuV1YyRnFJYxT9vbE1+wEWkLfF+fuqda3ttobGmCpacfPs5Y4hyyb1IQUV4FaA4i68jmdcyW0U7ItEYAlHAcgEcaU14LtN4prrcFYs5IUtZ6C73UrmXpijP/+sQ9JhuSBc6Fdu56kz237+o+ndxIBIDHQwVlol8QMxGLi5iwdf2p0M79YypYFuOkPOugyd9vAy/xsQ4Z6Y5/TOR9xIfAZC5BCpc0XPZ3Wip6s8t8ZOhYW1CE39/mw8pr1XvH7DLRIODAYp0ZbKutRgfvnbloBtgrOKR00RJLQ6YreTMIxTk2oAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1LRhM24XqNWB7jKR15pNmTDJ/XgrHg8fsfkyGcyIsE=;
 b=YpB4deWcIyNzhBAF8N2KjvzuSINNTZ8caF5i37cja8/qu9eHU5PiplbXgh7Ly8hTlwJYyFHv/jjJt3+3sCkiFhWPM04UU4sNR38qc8aMewxXQemiGOaFAF8tk3vYRTLFq1a6S6wikISA7QdnVQbUtzWFlusOFx76PF8PGUAB1KUAX+9oQhzJui5mLEpSg53FbLJbGVeH6HCkYXcIXzsg3vx6z6B/300lu1u8O/ax22P7JNkdN3+YdDaA7lfryA3NuP8HleM8ueXLXg9+srp45rLx3u1Fd1JwX9XAvP9F1TFyEhE/45vgrx3GlVsw6ncEMrGkL9SNbJrdYU91Bh4aAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1LRhM24XqNWB7jKR15pNmTDJ/XgrHg8fsfkyGcyIsE=;
 b=qVWaRBvhpTo+zoqm6hz/YCwqeMwU5NBoGFYenD2mZ4WLZkxk61jP95hEXZt0Cc013G74zQp4YhT1OwSovuhcpMp3M+Tt9Yu7jEVlBTdFM94AU+1oFhMjVA/Cw+/Mzb2bg9ZaS/W++BizCVVRzJGm/dZAjIDZbfAIl895mrSHLaU=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4576.namprd10.prod.outlook.com (2603:10b6:a03:2ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Fri, 18 Jun
 2021 02:49:10 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4219.027; Fri, 18 Jun 2021
 02:49:10 +0000
Subject: Re: [PATCH 7/9] vhost: allow userspace to create workers
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
References: <20210525180600.6349-1-michael.christie@oracle.com>
 <20210525180600.6349-8-michael.christie@oracle.com>
 <YLjnk5GpFaCCOqCU@stefanha-x1.localdomain>
 <0c1aef53-4850-8c46-0706-9b7276716e68@oracle.com>
 <YL45CfpHyzSEcAJv@stefanha-x1.localdomain>
 <6882ef4d-8382-5b0d-272e-779e6fa9e7da@oracle.com>
 <YMHH+das0nmMBbt5@stefanha-x1.localdomain>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <c98dd627-f330-b49c-6716-1caf737c73da@oracle.com>
Date:   Thu, 17 Jun 2021 21:49:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YMHH+das0nmMBbt5@stefanha-x1.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:5:40::14) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR03CA0001.namprd03.prod.outlook.com (2603:10b6:5:40::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Fri, 18 Jun 2021 02:49:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c05cf94b-bd04-4e8b-c0d4-08d93203a5d8
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4576:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4576903E9B1B2AEC7DF03540F10D9@SJ0PR10MB4576.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IT6ZHrGOqsf23xjNQ4ns/icGlUHygW3wmBg5ITXSvh/NFuo+3AAZ7XTmxHAsZdag2GmFhK6sPb8ISymYRVqXFKnTHIhzXVv17a8nIXbDHjIBG19jhP3fRK0ZbMtZaxGMTIwJIPoq6sLq0wKvPPiHvG2QV7vfP/ReCk4Uvs/P9ZvXi7IxQq0AbhWVAKA5L4LpCjJfH56SN+VZnrAuGFWWnF2QZyzo4JPjRaB+cSlszeJbWWRwKOltLAr5Dvqb5lsyyFHUw8TAcGjj8AR07lBpGv/6itI7lHGpbwLkas2NHXq4ecrinajsuhQgM2VI711zpSH5qyAT3hRSCIgMoCF0bOlc2fNqYMW2acSbSaCLJ2UPaaBnOsvUuT0r1VGb6V3qdvUzJXY5GarJuM69ZMZJQ20X3gG4hNIggyCxEAcwXJTSjb9WqBUXfKKolwRs3aBTddE1kOtoUfGzx7+BE0JKFDuz9Eedtn3yASbh4x4Kwc/jeMrkyu1ERhFnkTAdaO3NL4Py52o1QGq3hRNB0JqBpnn7AuIKuUrGAvLA9VTAS7EV8XQaLD+do5hCnb99qb34C8RLCNUPzN0LbeT/6LZvFuSEdODMKEVQzCIxjMwHxWnJiNH4fzLYJuQ63riaBBH4oX/Gy/yzz/9Y59w8XJiKU3EcroxKCvbvvmZ01TcuVowCUUFGqbLnDW9z2/KpVwsNlCluowJBPNMmtdZMyr/xUnybx/pb87byHmW7AR/nfkFOk+iIGe1WaIFw5A1DLz7T0YaGq8mfM7cWGO3gixeVsl37ZSTOes5Uzb+skbJQFvbNPnBv7FKuH/jmSCnitjTo8B61IauT7/dwQdQigLJBDOR9UERF916CV11uMVoQ8ic=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(396003)(39860400002)(36756003)(83380400001)(6706004)(8936002)(53546011)(4326008)(86362001)(6486002)(31696002)(66476007)(38100700002)(6916009)(478600001)(966005)(66946007)(31686004)(66556008)(16526019)(5660300002)(316002)(186003)(16576012)(2616005)(26005)(956004)(2906002)(8676002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?/RbDKXZC0EA2SXN5UzNSnxTGi8ezE011czcZz3PHK/XHmIxQG1fHe5TA?=
 =?Windows-1252?Q?yChro8Ud5afX3jEUoYQiUjwQfn5rpjBoDqdm8Rrk/zKNtpDcaFuX4/yJ?=
 =?Windows-1252?Q?YbpNa5Y+KVwNMg9hMzAs0wSZmjptxwWfp4ZInQTnAkcNET0xDrXREY4Q?=
 =?Windows-1252?Q?VwA8M9tlE0RlKbdX1q1aAkGhOxibG/OUimo2xhcOS9aBEmQ2ERUPMFaD?=
 =?Windows-1252?Q?fsjY27tNOc9a/UVjzW2mMYJpe6BIr/7TVba5NBjdN6nLqeNaiAtdjhzp?=
 =?Windows-1252?Q?X+KDyl75wEPH3W03yDz+Py1R2+kwywTFTu1Xwjy18bZLeknkfyYbabG7?=
 =?Windows-1252?Q?iL6jGSfRxSTbV6U2r9YRvb7rOoEu2DtpYi3CyHQPYyBSiwoE3anZdHgX?=
 =?Windows-1252?Q?ORh5Mh+hgPotE86wqz6dC0O7F03Cu6C4eXjKtN7/v5qPg+CPj7Ybeiqo?=
 =?Windows-1252?Q?J6BnzmxZZrY1uJ2JQbWyFLdx7AlbElchu3YeyJsT4VQz2I9MCxCMUkkq?=
 =?Windows-1252?Q?7lz6lWA7PnYXjJ2D0fiDkCscIlTAM5/P3lUinO+icFEIsmQevwQuOEFy?=
 =?Windows-1252?Q?bSfTEv5utWpuTJBWo1+sb0h2p2Xj/QUJdMKQNm7d/+1WDTnlTClwn1fH?=
 =?Windows-1252?Q?PgawU36A7KTs97CjXBTTQ9GWNOWHRdCFE3rb3qNR7aQAw8BTp0QBxsI7?=
 =?Windows-1252?Q?JinNMhKirSqAWV5hiuABkgmhdlwBzDdPG8kn18m0WrSNc0FeVEItejW2?=
 =?Windows-1252?Q?1cd7cts8d4HuaUykIwWHndMuyV4BvTKdyjFtLS+Ys596W6RU4prGFlWS?=
 =?Windows-1252?Q?5HlYmP1Cs/w8MoWhz3sbC2i6rarlj6HC2tL9sG8qDZpF2RSt/ju8QkdL?=
 =?Windows-1252?Q?//kAraHYwM2eACvJEUKXRwzp3mYOe97cH+ju/eyFlguh5Kc/Buk/0AlO?=
 =?Windows-1252?Q?S035VsPuJtDEoTQIj8ZrG078nLRU6cBwxq7Qzg68H90y87c0XF/8vi/z?=
 =?Windows-1252?Q?krajl2fhii0dlmBcsNgbi/tEBWbjeFN661fn7MfAmIWo2sSVHrd/9ML8?=
 =?Windows-1252?Q?rmLKeWn51Ea4L2LEooyCvGFWXXP+sxLIq0w4ryaIcVfCKCNGYQuNCXdj?=
 =?Windows-1252?Q?TZxjx50seGzrjVz44GV5L0oaWpkswr5YJuTvKU0G858dW8aTXwJmZV8v?=
 =?Windows-1252?Q?hGD+o65DHlYgOO1v/rzdVkkSgy/Fj0uopRAj2o3cyXplmYh9uCmaY8Ax?=
 =?Windows-1252?Q?guJ/48/1lK7mcYARFce5ePbAa5+jQEItgvupPW0zU5YwsEs0r19kGAPf?=
 =?Windows-1252?Q?XZAqbg0V9IdonW0Bc/qXdnlCLPDKhKunuEYSXmfHOuJnNyJVuKaHAQ8y?=
 =?Windows-1252?Q?btwufYXkD/arOxjPSWo0d2IO6q0jTa8+721ghYjT/IxvjHoD8gtE4mKJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c05cf94b-bd04-4e8b-c0d4-08d93203a5d8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 02:49:10.2929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 072cJhFeF3LY3dE7RtGjxdzuhnNwALkAcdWa4BjelGkQG8eUbQUPgu+4Ug1C/BRudigoewBx48ZnSYh4b8H2kV0trpAeB/OW4sudQ6lHNws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4576
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10018 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106180012
X-Proofpoint-GUID: _BolqSAeyCuh0-5KKTERgiCOGHc_wXl0
X-Proofpoint-ORIG-GUID: _BolqSAeyCuh0-5KKTERgiCOGHc_wXl0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/10/21 3:06 AM, Stefan Hajnoczi wrote:
> On Wed, Jun 09, 2021 at 04:03:55PM -0500, Mike Christie wrote:
>> On 6/7/21 10:19 AM, Stefan Hajnoczi wrote:
>>> My concern is that threads should probably accounted against
>>> RLIMIT_NPROC and max_threads rather than something indirect like 128 *
>>> RLIMIT_NOFILE (a userspace process can only have RLIMIT_NOFILE
>>> vhost-user file descriptors open).
>>>
>>
>> Ah ok, I see what you want I think.
>>
>> Ok, I think the options are:
>>
>> 0. Nothing. Just use existing indirect/RLIMIT_NOFILE.
>>
>> 1. Do something like io_uring's create_io_thread/copy_process. If we call
>> copy_process from the vhost ioctl context, then the userspace process that
>> did the ioctl will have it's processes count incremented and checked against
>> its rlimit.
>>
>> The drawbacks:
>> - This gets a little more complicated than just calling copy_process though.
>> We end up duplicating a lot of the kthread API.
>> - We have to deal with new error cases like the parent exiting early.
>> - I think all devs sharing a worker have to have the same owner. kthread_use_mm
>> and kthread_unuse_mm to switch between mm's for differrent owner's devs seem to
>> be causing lots of errors. I'm still looking into this one though.
>>
>> 2.  It's not really what you want, but for unbound work io_uring has a check for
>> RLIMIT_NPROC in the io_uring code. It does:
>>
>> wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
>> 					task_rlimit(current, RLIMIT_NPROC);
>>
>> then does:
>>
>> if (!ret && acct->nr_workers < acct->max_workers) {
>>
>> Drawbacks:
>> In vhost.c, we could do something similar. It would make sure that vhost.c does
>> not create more worker threads than the rlimit value, but we wouldn't be
>> incrementing the userspace process's process count. The userspace process could
>> then create RLIMIT_NPROC threads and vhost.c could also create RLIMIT_NPROC
>> threads, so we end up with 2 * RLIMIT_NPROC threads.
> 
> Yes, in that case we might as well go with Option 0, so I think this
> option can be eliminated.
> 
>> 3. Change the kthread and copy_process code so we can pass in the thread
>> (or it's creds or some struct that has the values that need to be check) that
>> needs to be checked and updated.
>>
>> Drawback:
>> This might be considered too ugly for how special case vhost is. For example, we
>> need checks/code like the io_thread/PF_IO_WORKER code in copy_process for io_uring.
>> I can see how added that for io_uring because it affects so many users, but I can
>> see how vhost is not special enough.
> 
> This seems like the most general solution. If you try it and get
> negative feedback then maybe the maintainers can help suggest how to
> solve this problem :).

Hey, I implemented #3 here:

https://github.com/mikechristie/linux/commit/76f7a555a85147420a22d0163c15259e01e02193

in this patchset:

https://github.com/mikechristie/linux/commits/kthread-node-user

but before I post I wanted to bring up an option 4 someone mentioned to me
offlist.

Again it's io_uring. Check out fs/io_uring.c:__io_account_mem(). For RLIMIT_MEMLOCK
it just does the check and increments the user's counter itself. It's simple like
option 2, and it handles the issue where the process doing the ioctl wasn't having
its RLIMIT_NPROC checked/updated.



