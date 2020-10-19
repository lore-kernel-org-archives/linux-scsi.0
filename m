Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F6EC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 18:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 935DC223C7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 18:55:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TrkMEKle"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbgJSSzZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 14:55:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36108 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730021AbgJSSzY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 14:55:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JIt4eF001926;
        Mon, 19 Oct 2020 18:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QxSH2xE/1ErUVZgI4p2L0uQ5f9QK3etfw93nu6Fy/0A=;
 b=TrkMEKle9kiZ2qCepnsFcmQGf3Gx6+xgN+DRCkcZe48E6iY496iubhDbpQxuzMK99Xc/
 nmx8ByDcv/4/PIjmbH8OCPe2vIMc/cQ0WfmeMw4zaeI5UwPkrezUJs/Sf7JZWa3kKoEE
 6yZH0lIQFpRZy9Qv9vtme7v1zjl+NMnOBBMeQvJ7WlOR955EdTnyiogRACF+HeUPwNkA
 Jkc2FcJxpxrNJFob8x8s+RSVryFm4RHNlTbX0bBDL514vwfa8NG0FX5pYm4l9mFsAO46
 TjKrE9N9MuYOrevtAqL5r64Aqi9zx5SCaqXQcoTgvIHzNeA1XPPKoALQ63dr1wEyvcgj 7Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 347p4aqbc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 18:55:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JIsqup073949;
        Mon, 19 Oct 2020 18:55:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 348ahva634-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 18:55:14 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09JItDAk002522;
        Mon, 19 Oct 2020 18:55:13 GMT
Received: from [20.15.0.8] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 11:55:13 -0700
Subject: Re: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        emilne@redhat.com, mkumar@redhat.com
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-6-git-send-email-muneendra.kumar@broadcom.com>
 <5ca752c2-94e1-444a-7755-f48b09b38577@oracle.com>
 <c3d65f732be0b73e4d4ebb742bc754cd@mail.gmail.com>
 <3803E6D0-68D6-407F-80AB-A17E7E0E69E3@oracle.com>
 <CE70AE32-4318-4FB2-AEED-3606DEF59B79@oracle.com>
 <a9b958fb-3c06-c385-f7ce-ce0fc863e64b@suse.de>
 <bf347ae232d73c4a21af6514085a92f2@mail.gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <8c59834c-e46c-fde3-13d7-b60a82452148@oracle.com>
Date:   Mon, 19 Oct 2020 13:55:12 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <bf347ae232d73c4a21af6514085a92f2@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190126
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/20 12:31 PM, Muneendra Kumar M wrote:
> Hi Michael,
> 
> 
>>
>>
>> Oh yeah, to be clear I meant why try to send it on the marginal path
>> when you are setting up the path groups so they are not used and only the
>> optimal paths are used.
>> When the driver/scsi layer fails the IO then the multipath layer will
>> make sure it goes on a optimal path right so you do not have to worry
>> about hitting a cmd timeout and firing off the scsi eh.
>>
>> However, one other question I had though, is are you setting up
>> multipathd so the marginal paths are used if the optimal ones were to
>> fail (like the optimal paths hit a link down, dev_loss_tmo or
>> fast_io_fail fires, etc) or will they be treated like failed paths?
>>
>> So could you end up with 3 groups:
>>
>> 1. Active optimal paths
>> 2. Marginal
>> 3. failed
>>
>> If the paths in 1 move to 3, then does multipathd handle it like a all
>> paths down or does multipathd switch to #2?
>>
>> Actually, marginal path work similar to the ALUA non-optimized state.
>> Yes, the system can sent I/O to it, but it'd be preferable for the I/O to
>> be moved somewhere else.
>> If there is no other path (or no better path), yeah, tough.
> 
>> Hence the answer would be 2)
> 
> 
> [Muneendra]As Hannes mentioned if there are no active paths, the marginal
> paths will be moved to normal and the system will send the io.
What do you mean by normal?

- You don't mean the the fc remote port state will change to online right?

- Do you just mean the the marginal path group will become the active 
group in the dm-multipath layer?
