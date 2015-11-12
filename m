From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Thu, 12 Nov 2015 14:03:03 +0200
Message-ID: <56447FF7.40600@dev.mellanox.co.il>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38284 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbbKLMDH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2015 07:03:07 -0500
Received: by wmec201 with SMTP id c201so88089511wme.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2015 04:03:06 -0800 (PST)
In-Reply-To: <1447304741-6594-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mchristi@redhat.com, linux-scsi@vger.kernel.org
Cc: Guilherme Piccoli <gpiccoli@linux.vnet.ibm.com>, Or Gerlitz <ogerlitz@mellanox.com>, shlomopongratz@gmail.com


> The bug is caused by this patch:
>
> 659743b02c411075b26601725947b21df0bb29c8
>
> which allowed the task lists to be manipulated under different locks
> in the xmit and completion path.
>
> To fix the oops this patch just reverts that patch. It also reverts
> these 2 patches for regressions that were also a result of that patch:

Whoa now Mike, this is a major change. Can we take a step back and think
about this for a second?

My understanding is that the kfifo circular buffer design allows a
writer (e.g. the producer) and a reader (e.g. the consumer) to avoid
extra locking when accessing the kfifo buffer.

 From include/linux/kfifo.h:
/*
  * Note about locking : There is no locking required until only * one 
reader
  * and one writer is using the fifo and no kfifo_reset() will be * called
  *  kfifo_reset_out() can be safely used, until it will be only called
  * in the reader thread.
  *  For multiple writer and one reader there is only a need to lock the 
writer.
  * And vice versa for only one writer and multiple reader there is only 
a need
  * to lock the reader.
  */

The patch by Shlomo, implements the locking policy documented above:
- multiple readers: multiple threads entering queuecommand reading the
   kfifo (kfifo_out) are mutually excluded by the frwd_lock.
- multiple writers: completion contexts writing to the kfifo (kfifo_in)
   are mutually excluded by the back_lock.

Can you provide a more detailed analysis of why is this list corruption
triggered? What scenario was not honoring the locking policy?
This code has been running reliably in our labs for a long time now
(both iser and tcp).

Going back to a single lock restores the contention point between
queuecommand and complete_pdu.


P.S.
While we're on the subject, I'd like to see block tags replace the
kfifo for iscsi tasks. It's difficult because sw and offload drivers
map hosts/sessions differently. It can be done if we move the tasks to
the iscsi_host and have a reserved (unique) task tags for the session
login/logout/nop_in/nop_out. With this we won't need locks around our
tasks arrays.

Sagi.
