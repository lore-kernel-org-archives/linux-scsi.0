From: Minh Duc Tran <minhduc.tran@avagotech.com>
Subject: Re: problem: connection teardown is always blocked because host is
 busy doing work on other connections
Date: Thu, 18 Jun 2015 23:20:35 -0700
Message-ID: <CADcHQmV-Lt9i64f1Q782_-oKZzXcovq5hqs=JKcgrxKKRxvRWQ@mail.gmail.com>
References: <1434676188-2578-1-git-send-email-minh.tran@avagotech.com>
	<5583B3D4.6040001@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36759 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbbFSGUf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 02:20:35 -0400
Received: by igbiq7 with SMTP id iq7so7604930igb.1
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2015 23:20:35 -0700 (PDT)
In-Reply-To: <5583B3D4.6040001@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, Sony John <sony.john@avagotech.com>

Hi Mike,
I am unaware of your talk with Sony about this issue.  Anyways, I will
leave it for Sony to follow it through.

Thanks.
-Minh

On Thu, Jun 18, 2015 at 11:16 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:
> On 6/18/15, 8:09 PM, Minh Tran wrote:
>>
>> From: Minh Duc Tran <MinhDuc.Tran@avagotech.Com>
>>
>> This blocking is ok if we use software iscsi or iser where each
>> connection has a separate host.  In the case of hw iscsi offload, one
>> host could have hundreds of connections and some connections may have
>> IOs running which makes host->host_busy is always TRUE.  Another
>> problem is the host_lock taken here is disruptive to other
>> connections' EH paths.  Wouldn't using target_busy a better choice
>> here?
>>
>
> Do you talk to John :) I had told him to do that a couple days ago when you
> guys emailed me about this offlist.
>
> However, I think Christoph wants to remove target_busy so you need to think
> of something else. I think you could take the session eh_mutex in the
> libiscsi session and conn teardown functions and rely on refcounting and
> state checks in the eh callouts.
