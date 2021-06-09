Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627A4C48BD1
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 21:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4167A613EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 21:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhFIVGC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 17:06:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39992 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhFIVGB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 17:06:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159L1Vt2036917;
        Wed, 9 Jun 2021 21:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=E3mGRTTVSE/Fit/sA0Srs8TmI5Br6VKXrdzW4kLj1WE=;
 b=wqXTjaCS1sYKPwzuirXFQ2lz5eDczloljFpYF3debiDrRMDCDbCVNsPEFIKi5YoDDJ0w
 AM4Tf3CqSzEoks1lNdBWaP2SmqvVQDFH8+BECADMx4udg4zlagvLVRp9R2M1kyyY3PzV
 CRMRTqugzarcHbyXkaYMDbC25vd/Wf1lo+f7lUsFCrIoh57eYatTsU8Xukl4p0xQg19D
 zLKJpn0eOto68vb/JJSd37tBwUkfHDXeo5ugr/iGlqnLmDcD+1ps4hOuBZBcztZzmgKf
 XhZOdSVvKY2Slh+KnQ1AR7RH9WJM1ntmD42ZHM0U92hvvaIWobIjp9esMfnCKub3tCq1 6g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3900psa9mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 21:04:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 159L0egc156166;
        Wed, 9 Jun 2021 21:04:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3020.oracle.com with ESMTP id 3922ww641g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 21:04:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iURLcWJE6ceZP/egiuqSApurrwOVh7Ku45F8lfTNrFis6soZBl5PwVyFmGPNcpU449yQDWBggo/bnhvQLh46bOxIWxjnJ30+yqFry9NA6qoMMX+zCtaEEF9GVFrFCIhghUptWIKaAG4lkg+GOK6Jwi/I0y1LCK5LJWAsXsOYHWhKYFIGg8N84E7c7jwRgUCWVA2lkGE+nfxnQzt6o+puAwsKx8S3/4QDJJo5Uez0jXY6hB5mQ8CfyTlpEHZats84nn4FJMqgoOZ7ovu1p1ljfZh8TAMApEzShB3YxQRF9O+ZT9uqEQ4J1gZ1CSzCvJqo1lQlU4MEaMn4jAtk4iz5fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3mGRTTVSE/Fit/sA0Srs8TmI5Br6VKXrdzW4kLj1WE=;
 b=l+hAbRV9mdKiGP8L/2hkwUYtM6PcxY/dbaH3PQV+lkg/mf36PSGdlMaAe2wx+5vGQXjGAEKonA7RUesb3J7p/6MnIeGHwyy3rsjxFQHYi/5RgzLV60D2PmlHnu+We++azIfDyGW8Gf8mZL6v4Arh593DLzihdzSKFJkPu0NSbzik2YegC69fwFXNHPi40cz958OL7xd5TSvB0jiBaczKF/sfriYway/n8ts+Vj0Ol7vt4Ujzy4JAxYwTI2yLzPDfsuAQyIQwhgeR0+gmywJfTty9vXgMa+/xm0M/EaBYPMJIALx1YmCk6CN1ew+dhRNMEFN4sJlGyWypJASJYsIy6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3mGRTTVSE/Fit/sA0Srs8TmI5Br6VKXrdzW4kLj1WE=;
 b=cHhb3mAdLiPMaF2vvSAMGmCAkrnmnHFC1s6QMB2tGCkqy6+ZNVwP5SDfuHRQaz4eBkOw6N5MUurA0gAJRl5f32LpRn3Ls3zGsAC7yiOVGHM36Kxbksi6vAQLecGhQrSFeTpKMPxc/mbGOp+MznksQYTD5HmN6aIGYTsOcZvoxu4=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3623.namprd10.prod.outlook.com (2603:10b6:a03:11b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Wed, 9 Jun
 2021 21:03:58 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 21:03:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
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
Message-ID: <6882ef4d-8382-5b0d-272e-779e6fa9e7da@oracle.com>
Date:   Wed, 9 Jun 2021 16:03:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YL45CfpHyzSEcAJv@stefanha-x1.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR2001CA0001.namprd20.prod.outlook.com
 (2603:10b6:4:16::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR2001CA0001.namprd20.prod.outlook.com (2603:10b6:4:16::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 21:03:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7af07be-b682-407f-1347-08d92b8a192d
X-MS-TrafficTypeDiagnostic: BYAPR10MB3623:
X-Microsoft-Antispam-PRVS: <BYAPR10MB362380B675AD83F267091785F1369@BYAPR10MB3623.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iMP8vFustuE9ylLJdCFfFaOAbgRc040QJxkvCP0WgISHpg2hsuY8nCZXTj1Y3/dkjdxlsbLWUBliraRqOQGthX7qhgJTDt2H/Ee4zPqprv67EWmm9EB5nmltD1XzprpZCyAektWzbXekieORLqT7oBVN8gjzPU6yMbtvRxSn+EzlxgInKD8kobBB/xIALe/sBRE2c9p80+Dqq/EJjt+SlEdQKyj5ldVsheU1Kkg0hdG41NzW2mHNug3TZxjV2TH9V7xYP0tUa76nGgqTZ8qok8hn93ZUm38RUYAFFXVt5om666l7V5irQRfADoUkf1/K7D7P5vMCT0yBBEvKbHTjvS5qQy9KUK0PVgtKOo1w1E0zQXoLPpYQCLyn6bvJSyD0Z2Fcq1c0NZfQrl2BUQoKlMZKTEniuflIDaR5ea3aWbvuthofpee22ohbPaz1VxsCLaRMSD7O+OOSwrDcK8XTgNKZB98r6W7TO2wUMZrA9+0dkmo2M/DovWQihhq0QGmaLJZIl+UXwr/RyCsHhwahZ+xLyC/dh5Tr3//gAujVbvZSv9IvQSn9mxQR/zsRdNx0iOj+4FWki8J32nvHnovPbSHX0MAt7+jDC3S6MIBuRRY/WbvyTPRdiqsTFlzfXIuAMJRB5xm/Rt2F7YmBQwzEpo9c/xa24QELfliwXgvAymgmPPDs2cuJlUvFY9O+epiYC16bEIhd/kjFMqym1u89Mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(346002)(376002)(366004)(86362001)(36756003)(4326008)(186003)(2906002)(316002)(66556008)(66476007)(8936002)(53546011)(956004)(83380400001)(66946007)(478600001)(38100700002)(16526019)(5660300002)(26005)(6916009)(6706004)(6486002)(8676002)(31686004)(2616005)(31696002)(16576012)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?53OWhTFmZTZ35yElvsiciAnowg3Lg1z9wPHZDCQgNkPZZWGjsZxS17g8?=
 =?Windows-1252?Q?0g06/usfQIbRYXylbJHPk9Qeyzlx4hsY5L3e7H9Uwp1l98b6sCzg0YNR?=
 =?Windows-1252?Q?whS1zJ24dr8UJHzKSamg+bv3mFpVV2OUwtOsvZHXWXjOR3MXCN1g7DDW?=
 =?Windows-1252?Q?6RJVXnso0xNIBO0hwEWxwmv+NiMotnfjVGgeXyqXeLlsteGRhPUUycoV?=
 =?Windows-1252?Q?dL9Sc/FNsDPW4S12bHVjurKDxis/2I7IfG2WyfTN6hehqHscJBFhEQ18?=
 =?Windows-1252?Q?cOY2HwSKC/u4CTI0ARZGJe0Gbt9byf7ODpG9XbFzz3v+6sNJAfIpsq2t?=
 =?Windows-1252?Q?YZ6b3Iswq6aewx2CYTd5QxKi95kV9jAfcK5+Y78nG/b69z6dEP2926+j?=
 =?Windows-1252?Q?ZctGdgsgzminQY1e+1pqUWuuYTNnr2N5Tsoq/SJLFQ6rKrr9dBs8peUP?=
 =?Windows-1252?Q?fwQZhFt2Dz7UYN8g48TCk/10lvgXlVnMNlbSrj1YGWDm21LbN/3lW9Tc?=
 =?Windows-1252?Q?nJTr+7VX499RxAcObrsmwpUrKk19ThIIXDFy8FuRSNJLbmZJRCsh9Js6?=
 =?Windows-1252?Q?TxCdiyJJ7scvpNLdRcatpjNQOp3SJ8Ja3PQknUCT/IQoIT0NwXg5/h3/?=
 =?Windows-1252?Q?281n3Vi05GmoTTEF5i84cjdApDZbsfmGalG5S38N4dzfZiwpsOUfinXR?=
 =?Windows-1252?Q?FBBKXeVFnuHjgq6zMa8WnT21CIbX1J1AXwqltTr3JuntLHDrpR3YYIcK?=
 =?Windows-1252?Q?MXGOOS09JRtcT08jiR6jx4pebD3h7cftXg/4nMAg3S0SsR+wO5rakVP5?=
 =?Windows-1252?Q?VRcOquw6Fb2ZdHlvNBVh0F3t+kAgQ0zLGcd+J4qaWykNaLDyrA7YkNxk?=
 =?Windows-1252?Q?o+a4kwKGjMnL+AVIIIWn55OuD2d/cw4Z7C/p+EdKPhb03lVGLFoxJ/We?=
 =?Windows-1252?Q?pv2+MSWsGQsXXIdLMVyfN0GcMKWpN65YGMX5GWzoXKLwwczR/+NoeHJQ?=
 =?Windows-1252?Q?LRC3nX7vQpmk16blbnknA6Z7bz6tE01n90vOsOhuazxjb0syMb+OQNXH?=
 =?Windows-1252?Q?EGD32UET8jxPHfblBGVIU9bfT/hOVb9Cm9mdWBbdjIIVpoBJhCFGspdh?=
 =?Windows-1252?Q?I30hN3B+7OKP4t1NcNWfi2v5zPxk/j9K03IoIPvAZWgqrs/PLizCFrhe?=
 =?Windows-1252?Q?MV93V2LagjKCq21yjb1LIHkuAU/W768X45zT9/jryQg++jmLflb7pSG/?=
 =?Windows-1252?Q?V1QpiFoQ6FDf7BL3QVRPqCntX16dqU0/sE0I2Za4QswjrUUF0U29y8F3?=
 =?Windows-1252?Q?ZlnsRYd757+Uvd7fK5vzgoHwdZ2kt7T8skHgrScbv2lcDB663Ey/HUEM?=
 =?Windows-1252?Q?gmS2ZMypYXFC95WrvPG6GYdEFhm4x/MIfLjWMa8sHbkAxqTU2niF/s4x?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7af07be-b682-407f-1347-08d92b8a192d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 21:03:58.0769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +fNO1eRGPKl1UQAobD4AlJ4S54kyhHcWWZwq8+F3vhntfok+p8TQQi0P2XLDd5cRAmgagw7EysA2O9aUm3j71xG6uD2AiwPtCCV4yw5FP4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3623
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090110
X-Proofpoint-GUID: xJZb8NUog_bgYkjKIO2HOBfsW0L1stVN
X-Proofpoint-ORIG-GUID: xJZb8NUog_bgYkjKIO2HOBfsW0L1stVN
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090110
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/21 10:19 AM, Stefan Hajnoczi wrote:
> My concern is that threads should probably accounted against
> RLIMIT_NPROC and max_threads rather than something indirect like 128 *
> RLIMIT_NOFILE (a userspace process can only have RLIMIT_NOFILE
> vhost-user file descriptors open).
> 

Ah ok, I see what you want I think.

Ok, I think the options are:

0. Nothing. Just use existing indirect/RLIMIT_NOFILE.

1. Do something like io_uring's create_io_thread/copy_process. If we call
copy_process from the vhost ioctl context, then the userspace process that
did the ioctl will have it's processes count incremented and checked against
its rlimit.

The drawbacks:
- This gets a little more complicated than just calling copy_process though.
We end up duplicating a lot of the kthread API.
- We have to deal with new error cases like the parent exiting early.
- I think all devs sharing a worker have to have the same owner. kthread_use_mm
and kthread_unuse_mm to switch between mm's for differrent owner's devs seem to
be causing lots of errors. I'm still looking into this one though.

2.  It's not really what you want, but for unbound work io_uring has a check for
RLIMIT_NPROC in the io_uring code. It does:

wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
					task_rlimit(current, RLIMIT_NPROC);

then does:

if (!ret && acct->nr_workers < acct->max_workers) {

Drawbacks:
In vhost.c, we could do something similar. It would make sure that vhost.c does
not create more worker threads than the rlimit value, but we wouldn't be
incrementing the userspace process's process count. The userspace process could
then create RLIMIT_NPROC threads and vhost.c could also create RLIMIT_NPROC
threads, so we end up with 2 * RLIMIT_NPROC threads.

3. Change the kthread and copy_process code so we can pass in the thread
(or it's creds or some struct that has the values that need to be check) that
needs to be checked and updated.

Drawback:
This might be considered too ugly for how special case vhost is. For example, we
need checks/code like the io_thread/PF_IO_WORKER code in copy_process for io_uring.
I can see how added that for io_uring because it affects so many users, but I can
see how vhost is not special enough.







