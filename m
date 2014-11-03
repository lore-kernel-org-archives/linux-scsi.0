From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: bisected regression: qla2xxx endianness on sparc64
Date: Mon, 3 Nov 2014 23:26:38 +0100
Message-ID: <CAMuHMdVoVjCyJAWiKePXzfx8WyXoFd8CwwAk8DM8jxcOHC1Mnw@mail.gmail.com>
References: <alpine.DEB.2.03.1411022004230.3979@cyber.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:37201 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaKCW0k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2014 17:26:40 -0500
In-Reply-To: <alpine.DEB.2.03.1411022004230.3979@cyber.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Joe Carnuccio <joe.carnuccio@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Christoph Hellwig <hch@lst.de>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Sun, Nov 2, 2014 at 7:10 PM, Meelis Roos <mroos@linux.ee> wrote:
> Between 3.17 and 3.18-rc2, qla2xxx is broken on my sparc64 machines. It
> fails to boot (hangs in firmware rings init).
>
> This is the result of bisect:
>
> 98aee70d19a7e3203649fa2078464e4f402a0ad8 is the first bad commit
> commit 98aee70d19a7e3203649fa2078464e4f402a0ad8
> Author: Joe Carnuccio <joe.carnuccio@qlogic.com>
> Date:   Thu Sep 25 05:16:38 2014 -0400
>
>     qla2xxx: Add endianizer to max_payload_size modifier.
>
>     Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
>     Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> :040000 040000 041c1a26dc2a7988900acc982e3bd65d3cf7e751
> 9700d09c3226fc352d44352f22b84f1be632d324 M  s
>
> This may not be the only problem - when bisecting, I also came to commits
> that got past this step but hang after about 165 seconds of uptime while
> running userspace startup scripts. But let that be another issue at the
> moment.

Switching from uint16_t to __le16 but _removing_ cpu_to_le16() operations
looks indeed very fishy.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
