From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 35282] BUG() in 2.6.38.6
Date: Sun, 22 May 2011 00:30:50 +0400
Message-ID: <1306009851.12379.16.camel@mulgrave.site>
References: <bug-35282-11613@https.bugzilla.kernel.org/>
	 <201105191944.p4JJiVVm029690@demeter1.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50249 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440Ab1EUUa6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2011 16:30:58 -0400
In-Reply-To: <201105191944.p4JJiVVm029690@demeter1.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Thu, 2011-05-19 at 19:44 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> --- Comment #2 from Fabio Coatti <fabio.coatti@gmail.com>  2011-05-19 19:44:30 ---
> Thanks for your answer :)
> 
> Just tried (patch applied, compiled with make mrproper beforehand), but the
> result is pretty much the same.
> Interesting enough, If I reboot after using 2.6.38.5 for a while, the first
> boot on .6 is successful; following boots fails as shown so I guess that some
> hardware status can have a role into this, even if I don't know what happens.
> Here you can find the last capture with netconsole, with patch applied. (btw,
> how I can 100% sure to have applied it properly, besides checking the kernel
> date?)

Well, the first patch was just a guess.  It looks like another queue
guard problem.  However, I think this one is that the code thinks a dead
queue isn't stopped.  Could you try this patch instead?

Thanks,

James

---

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2ad95fa..8166845 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -473,7 +473,9 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 }
 
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
-#define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
+#define blk_queue_stopped(q)	\
+		(test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags) || \
+		 test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags))
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)


