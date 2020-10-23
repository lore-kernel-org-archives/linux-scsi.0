Return-Path: <SRS0=1+Eg=D6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B5EC4363A
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 16:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F4DF21D47
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 16:24:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k7Qn8TDe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751444AbgJWQYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Oct 2020 12:24:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36062 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751438AbgJWQYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2020 12:24:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NGAR5V007277;
        Fri, 23 Oct 2020 16:24:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+lZ0B0U5fs6uXd4BfKe6kP2DafANBuTpVAZ62ckWqoM=;
 b=k7Qn8TDeAmT/brDz/8HcuHuORQLlSwwDme+dVHOxrUo3oUDYZGkb7KOIV0c2PJuHpkpi
 rTskW0z+RC2IwgGHHLbYpVKztWSe/hQJ22lYGP43Z59+O5NSlPklBau3EG+JoxJumslF
 FlvOH7oxPsUtxBi80ODRvowVFlilgdzhQtloU8Kf3yhaIEzb54XVwq5kT/yqtp4clcKA
 51OXtb1jwm8UjRbQyKBFsSAYulSx93IhcX7vV/9NEgHfrOV9QO/LOxBNuyPG2y5GUgLv
 qzrJKHKNx+tuG5cUFDt9GbwH3aKjxpv9WOQ4TmSbYKey8ZISkd9qn+qTBkPHjfd9xvUq Fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34ak16vbs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 23 Oct 2020 16:24:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09NGB7E8035757;
        Fri, 23 Oct 2020 16:22:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 348aj1510p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Oct 2020 16:22:50 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09NGMn6S005238;
        Fri, 23 Oct 2020 16:22:49 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Oct 2020 09:22:48 -0700
Subject: Re: [PATCH 00/16 V2] vhost: fix scsi cmd handling and IOPs
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
 <20201023114539-mutt-send-email-mst@kernel.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <b1323161-c712-bcf4-91bb-e1c9b20dacac@oracle.com>
Date:   Fri, 23 Oct 2020 11:22:47 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201023114539-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010230107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/20 10:46 AM, Michael S. Tsirkin wrote:
> On Wed, Oct 07, 2020 at 03:54:45PM -0500, Mike Christie wrote:
>> The following patches were made over Michael's vhost branch here:
>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost__;!!GqivPVa7Brio!IVNw3V-uPEJyaYcHGpZrPo_0vnAuPXchguJJZG5qCapOYzR8bOwuFyTZf49rMcokFOMG$
>>   
>> The patches also apply to Linus's or Martin's trees if you apply
>> https://urldefense.com/v3/__https://patchwork.kernel.org/patch/11790681/__;!!GqivPVa7Brio!IVNw3V-uPEJyaYcHGpZrPo_0vnAuPXchguJJZG5qCapOYzR8bOwuFyTZf49rMfl3id0D$
>> which was merged into mst's tree already.
>>
>> The following patches are a follow up to this post:
>> https://urldefense.com/v3/__https://patchwork.kernel.org/cover/11790763/__;!!GqivPVa7Brio!IVNw3V-uPEJyaYcHGpZrPo_0vnAuPXchguJJZG5qCapOYzR8bOwuFyTZf49rMWyfBwDA$
>> which originally was fixing how vhost-scsi handled cmds so we would
>> not get IO errors when sending more than 256 cmds.
>>
>> In that patchset I needed to detect if a vq was in use and for this
>> patch:
>> https://urldefense.com/v3/__https://patchwork.kernel.org/patch/11790685/__;!!GqivPVa7Brio!IVNw3V-uPEJyaYcHGpZrPo_0vnAuPXchguJJZG5qCapOYzR8bOwuFyTZf49rMWWcMjJi$
>> it was suggested to add support for VHOST_RING_ENABLE. While doing
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
>>
>> Note that in this posting I am also including additional patches
>> that create multiple vhost worker threads, because I wanted to see
>> if people felt that maybe to support that and for this enablement
>> issue we want a completely a new ioctl.
>>
>>
>> V2:
>> - fix use before set cpu var errors
>> - drop vhost_vq_is_setup
>> - include patches to do a worker thread per scsi IO vq
> 
> Stefan, Paolo, Jason any input?
> 

Just a FYI there is a updated version of this patchset here:

https://patchwork.kernel.org/project/target-devel/list/?series=368487
