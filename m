From: Maksim Rayskiy <maksim.rayskiy@gmail.com>
Subject: Re: [linux-pm] [RFC] Deferred disk spinup during system resume
Date: Thu, 30 Dec 2010 16:49:29 -0800
Message-ID: <AANLkTikLn7VyB+TJMz=GGTHKSHg+9feQ9bje+KS3pD3k@mail.gmail.com>
References: <AANLkTinOqLOJ7JCpHeQNYUEirqAvkSce+eFDCGkWn3jE@mail.gmail.com>
	<201012302346.07275.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61915 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0LaAta (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Dec 2010 19:49:30 -0500
Received: by iyi12 with SMTP id 12so10100313iyi.19
        for <linux-scsi@vger.kernel.org>; Thu, 30 Dec 2010 16:49:29 -0800 (PST)
In-Reply-To: <201012302346.07275.rjw@sisk.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>

>> When resuming from system suspend, scsi disks are being spun up which
>> takes quite a lot of time (5+ seconds in my case). The spinup is done
>> synchronously, so this time adds up to overall system resume time.
>> Ours is an embedded platform and we are using flash-based rootfs, so
>> there is no immediate need in harddrive after resume. What is much
>> more important for us is to minimize time-to-full-power. To speed up
>> resume, we would like to have an option to defer the spinup or run it
>> in parallel with system resume. I could not find any existing
>> mechanism to do the trick, but I might have missed something.
>>
>> Can anybody comment on this?
>
> Do you use asynchronous suspend/resume?
>

Yes, asynchronous suspend/resume is enabled - it saves about 0.5
second in my case. But resume blocks anyway because disk driver is
waiting on sd_resume() to complete.

I am wondering if we could let the resume proceed while spinup is
going on, just mark the scsi device as quiescent to block any data
transfers.

Maksim.

> Rafael
> --
