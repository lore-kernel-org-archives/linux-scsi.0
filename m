Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE16FC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 22:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C60214F1
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 22:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ee4xmnPp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgJ2WVQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 18:21:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:32774 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2WVQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 18:21:16 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TMGkvo044550;
        Thu, 29 Oct 2020 22:21:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=L4EC6wxl67K6Aocna8t+Vpj6CqjMLTykieP0eFECKUY=;
 b=ee4xmnPppAfXcJFr7vvFgFro7TCjKL1eM+CKMLdHs8BLB4e3J7qgmUDAq62hT3iuAjYF
 3GfL49zQQxxHTgpBsqBIxzS1Gr9zjI5T9ibUNctnKd7+ETFRQJrtliFl1G9c9mamhjlX
 I/Gb2ck0eK2zUklNNkiYEyOA8Gz2mna53nshSFckbFR5oXsuGvxaJmWCzglLPUsBwjjs
 mwyUsTwjITpgNjhTfKhFy92maxjSdHT5m3KzXOaLx55JLJ5xae3aXwbwd9I+pNUHMSIf
 Y4jwKYEJvc5VOyHtG8taTMNbb6693vqzVYwUuVLs8+rE1fu8iFBDR/9B9HfikenFmbD5 xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34c9sb7fn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 22:21:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TMFSRI146954;
        Thu, 29 Oct 2020 22:19:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34cx700d70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 22:19:10 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TMJ9Ub032069;
        Thu, 29 Oct 2020 22:19:09 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 15:19:08 -0700
Subject: Re: [PATCH 00/17 V3] vhost: fix scsi cmd handling and cgroup support
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <20201029174719-mutt-send-email-mst@kernel.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <c95612d5-104a-f8f5-d335-bd20e74e9ecc@oracle.com>
Date:   Thu, 29 Oct 2020 17:19:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201029174719-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/29/20 4:47 PM, Michael S. Tsirkin wrote:
> On Wed, Oct 21, 2020 at 07:34:46PM -0500, Mike Christie wrote:
>> In-Reply-To:
>>
>> The following patches were made over Michael's vhost branch here:
>>
>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost__;!!GqivPVa7Brio!ORlQVwL5FxDLtNmvh5l9nLqhQJOO6UexX4vl-NrAhagQG9dAGFNFCPXoSNU8rW75g3OH$
>>
>> They fix a couple issues with vhost-scsi when we hit the 256 cmd limit
>> that result in the guest getting IO errors, add LUN reset support so
>> devices are not offlined during transient errors, allow us to manage
>> vhost scsi IO with cgroups, and imrpove IOPs up to 2X.
>>
>> The following patches are a follow up to this post:
>> https://urldefense.com/v3/__https://patchwork.kernel.org/project/target-devel/cover/1600712588-9514-1-git-send-email-michael.christie@oracle.com/__;!!GqivPVa7Brio!ORlQVwL5FxDLtNmvh5l9nLqhQJOO6UexX4vl-NrAhagQG9dAGFNFCPXoSNU8rXJWM8fh$
>> which originally was fixing how vhost-scsi handled cmds so we would
>> not get IO errors when sending more than 256 cmds.
>>
>> In that patchset I needed to detect if a vq was in use and for this
>> patch:
>> https://urldefense.com/v3/__https://patchwork.kernel.org/project/target-devel/patch/1600712588-9514-3-git-send-email-michael.christie@oracle.com/__;!!GqivPVa7Brio!ORlQVwL5FxDLtNmvh5l9nLqhQJOO6UexX4vl-NrAhagQG9dAGFNFCPXoSNU8rbRNqMbK$
>> It was suggested to add support for VHOST_RING_ENABLE. While doing
>> that though I hit a couple problems:
>>
>> 1. The patches moved how vhost-scsi allocated cmds from per lio
>> session to per vhost vq. To support both VHOST_RING_ENABLE and
>> where userspace didn't support it, I would have to keep around the
>> old per session/device cmd allocator/completion and then also maintain
>> the new code. Or, I would still have to use this patch
>> patchwork.kernel.org/cover/11790763/ for the compat case so there
>> adding the new ioctl would not help much.
>>
>> 2. For vhost-scsi I also wanted to prevent where we allocate iovecs
>> for 128 vqs even though we normally use a couple. To do this, I needed
>> something similar to #1, but the problem is that the VHOST_RING_ENABLE
>> call would come too late.
>>
>> To try and balance #1 and #2, these patches just allow vhost-scsi
>> to setup a vq when userspace starts to config it. This allows the
>> driver to only fully setup (we still waste some memory to support older
>> setups but do not have to preallocate everything like before) what
>> is used plus I do not need to maintain 2 code paths.
> 
> 
> OK, so could we get a patchset with just bugfixes for this release
> please? > And features should go into next one ...

Yeah, that sounds good.

Just to make sure I am on the same page as you and Jason about what 
patches are features vs fixes/cleanups. I'm thinking patches 1 - 11 are 
to resend in the fixes patchset?

0. Patches 1 - 2 are adding helpers I use later.

1. Patches 3 - 8 are related to fixing IO errors due to the VM sending 
virtqueue_size/cmd_per_lun commands but vhost-scsi having 256 hard coded.

Patch:

[PATCH 08/17] vhost scsi: alloc cmds per vq instead of session

is what fixes the issue in vhost-scsi so we allocate enough resource to 
match what the VM is going to send us, but is built on patches 3 - 7 
which allow vhost-scsi to know which vqs to allocate cmd resrouces for.

[PATCH 03/17] vhost net: use goto error handling in open
[PATCH 04/17] vhost: prep vhost_dev_init users to handle failures
[PATCH 05/17] vhost: move vq iovec allocation to dev init time
[PATCH 06/17] vhost: support delayed vq creation
[PATCH 07/17] vhost scsi: support delayed IO vq creation

2. Patch 9 fixes a race where we signal userspace the cmd is done before 
we were done with it. We can then get IO errors if the VM sends a new IO 
before we free up the old cmd.


3. Patch 10 adds LUN reset support. Currently, if the real/backing 
device hits a temp issue, the VM's scsi/block layer cmd timer might fire 
and send a reset. We don't implement this, so we just fail. The VM's 
device goes offline and the app in the VM gets IO errors.

4. Patch 11 removes extra flush calls.


Patches 12 - 17 are adding support for the thread per VQ which is a perf 
feature so resend them separately when we figure what is best.
