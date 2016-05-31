From: Robert LeBlanc <robert@leblancnet.us>
Subject: Performance degradation on 4.6
Date: Tue, 31 May 2016 17:46:54 -0600
Message-ID: <CAANLjFp28MkaMjWKwXnMGHPCX2S_g_RKOhXqHc9dYVJvMgqvVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33159 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbcEaXqz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2016 19:46:55 -0400
Received: by mail-oi0-f53.google.com with SMTP id k23so3676523oih.0
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2016 16:46:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've been working with iSER trying to maximize performance. I have two
FDR Infiniband cards (three ports total) and I've created multiple
address on the target and configured 12 paths from the initiator. The
iSER target is served up from a RAM disk. With the 4.4 kernel I'm able
to pretty much saturate the links (4.1 million seq 4K read IOPs 15.7
GB/s) using multipathd. With the same configuration on 4.6, I'm only
able to get 3.3 million IOPs or 12.8 GB/s.

Running perf top on the target and initiator, I'm seeing the target is
dominated by

73.89% [kernel] [k] memcpy_rems
 1.35% [kernel] [k] get_page_from_freelist
...

which is the same with 4.4. Perf top on the target has:

13.01% [kernel] [k] copy_user_enhanced_fast_string
 8.48% [kernel] [K] __blk_recalc_re_segments
 5.35% [kernel] [k] native_queued_spin_lock_slowpath
...

I don't recall what the initiator had on 4.4.

Single path performance has increase by about 5% which is nice, but
two path performance is about 50% that of the 4.4 kernel. Three paths
and greater are around 80% the 4.4 performance.

Any ideas on what could have caused the performance issues on 4.6? Is
there some additional information I can provide that would be useful?

Thanks,

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
