From: Douglas Gilbert <dougg@torque.net>
Subject: Re: illegal context for sleeping ... rmmod ide-cd + ide-scsi
Date: Mon, 05 May 2003 21:51:04 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB65028.8080402@torque.net>
References: <3EB62347.8020109@torque.net> <20030505020104.0abc66ba.akpm@digeo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:55564 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262150AbTEELgC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 07:36:02 -0400
In-Reply-To: <20030505020104.0abc66ba.akpm@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

Andrew Morton wrote:
> Douglas Gilbert <dougg@torque.net> wrote:
> 
>>In lk 2.5.69 (and in 68) both the ide-cd and ide-scsi
>>modules generate a "sleeping function called from illegal
>>context" stack trace when removed.
>>
>>After "rmmod ide-cd" this appears:
>>  Debug: sleeping function called from illegal context
>>         at include/asm/semaphore.h:119
>>  Call Trace:
>>   [<c011dcec>] __might_sleep+0x5c/0x70
> 
> 
> ide_unregister_subdriver() does spin_lock_irqsave(&ide_lock), then
> calls auto_remove_settings(), which does down(&ide_setting_sem);
> 
> A simple fix might be:

Andrew,
Thanks. That patch clears the reported problem.

Doug Gilbert

