Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BA1C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CAC2222BA
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:21:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QYcsHmGF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgKBQVx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:21:53 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37496 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgKBQVx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:21:53 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A2GJTTo110610;
        Mon, 2 Nov 2020 16:21:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=OzHLW0aKYKHM4iLF2/fpp6qlzP5WhLo6+5qk6Sw0U7A=;
 b=QYcsHmGFC4vMZQ7dpPxuJkwniedaIBkyWFCy7ZxwagX3GYofNQ03BukLsrx+8VF72Psi
 KeBEbCcSuqAPtyMX47fzDJ0MlP7QKFSCpWrAxaJ1vIpCew1/S0xyj6Fc4mFzfJtOut8y
 fVEfeWfccZtiR2oFl6YONL8TrI0eRUw3ALxV1VCOEe7jATQ6tkiblX30jKt64GXYUNn6
 nTUy9bdyJXUYkYEMZMlmUgLTFsYlTxhrmEX7BRgamgtC7akjjI36rGcO3Xp3qbQHvWSV
 m+RLEn9ec4DJjcLWpyetfq0aKKgjzYlMbrG6HyA2DQKBGVvncSwGE/c10Lw9+cyhm1Zw kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34hhb1vv3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 02 Nov 2020 16:21:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A2GB0Zs057895;
        Mon, 2 Nov 2020 16:19:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34jf46r4yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Nov 2020 16:19:48 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A2GJjhq009743;
        Mon, 2 Nov 2020 16:19:45 GMT
Received: from [10.154.171.115] (/10.154.171.115)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Nov 2020 08:19:44 -0800
Subject: Re: [PATCH 07/17] vhost scsi: support delayed IO vq creation
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        target-devel@vger.kernel.org, stefanha@redhat.com,
        pbonzini@redhat.com
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
 <9e97ea2a-bc57-d4aa-4711-35dba20b3b9e@redhat.com>
 <49c2fc29-348c-06db-4823-392f7476d318@oracle.com>
 <20201030044402-mutt-send-email-mst@kernel.org>
 <688e46b6-77f1-1629-0c93-e3a27d582da5@redhat.com>
 <cf74844c-bfa6-e66c-fc3a-07dfd7af3092@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <4add5334-e345-f7f1-4fe7-2fb66d86ae34@oracle.com>
Date:   Mon, 2 Nov 2020 10:19:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <cf74844c-bfa6-e66c-fc3a-07dfd7af3092@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020126
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/20 12:49 AM, Jason Wang wrote:
> 
> On 2020/11/2 下午2:36, Jason Wang wrote:
>>>
>>> The need to share event/control vqs between devices is a problem though,
>>> and sending lots of ioctls on things like reset is also not that 
>>> elegant.
>>> Jason, did you have a good solution in mind?
>>
>>
>> Nope, I'm not familiar with SCSI so I don't even know sharing evt/cvq 
>> is possible. Consider VHOST_SCSI_MAX_VQ is already 128 per device. 
>> Mike's proposal seems to be better.

Hey, which proposal are you saying was best?

1. Add on to the current scsi mq design where we are doing a single 
device and multiple vqs already. So basically just fix what we have and 
add in patches 12 - 16 to do a thread per VQ?

2. The proposal I stated to hack up over the weekend to try and support 
the current design and then add in support for your multiple device 
single vq design:

http://archive.lwn.net:8080/linux-scsi/292879d9-915d-8587-0678-8677a800c613@oracle.com/

>>
>> Thanks 
> 
> 
> Btw, it looks to me vhost_scsi_do_evt_work() has the assumption of iovec 
> layout which needs to be fixed.

I wanted to be clear, because I thought you meant #1, but this comment 
seems like it would only be for #2.
