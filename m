Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECFFC4361B
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3428722AAF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 16:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730984AbgLDQss (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 11:48:48 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:48522 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgLDQsr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 11:48:47 -0500
Date:   Fri, 4 Dec 2020 17:48:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607100485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=3pZ3FTQEhW5VI2xWSqytawbzEkWxvXEDOdIicOWp2ug=;
        b=YoAdKgExfx/yI1cwQ8zVEu8g+HlxLogWsqAX7nzQO4sRPmRojKBSIs7mY1Aq1UQEqo5CxN
        SxuqcJTfX+7F15EDLm5SJ+L8ECNO3Pib0Zpff7Ffa+jlXRSPhJliW1rl+a2RnA6HY07AZk
        PEk3zhkEqMk1U5Tso+xrbdCk625OB7gnVBaVys6oFTJ8c5VWPok7zsD4zJNZsks6YJ8U/4
        zhyUDCemqsCeGviIzmEZ5cx7HOEUGkFhBJxEX+NOcnj+2StGkPp0ve/l1yXj09RBFcRQa6
        sD6i0WFHtroW8z4Le0BnFMIDPaZKod+kpJ3b/BCcP4YKFn/XAgmBObqT4zqXvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607100485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=3pZ3FTQEhW5VI2xWSqytawbzEkWxvXEDOdIicOWp2ug=;
        b=3Nvh9wAazTydhuZmet6IwKKnupnT9mMZW605igPKCY90qqTvbryOz2bnUavlbryIUMnG2C
        dmla0F0sFYjkWUCA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/3] Remove in_interrupt() usage in sr.
Message-ID: <20201204164803.ovwurzs3257em2rp@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before v2.1.62 sr_read_sector() did MODE_SELECT to set the requested sector size,
issued READ_10 and then used MODE_SELECT to select a sector size of 2048 bytes.
This function was used to serve ioctl()'s command CDROMREADMODE2 and CDROMREADRAW
which do not use 2048 bytes as sector size.

In v2.1.62 sr_read_sector() changed to use READ_CD first and fallback to
MODE_SELECT and READ_10 if READ_CD was not supported. Since this version it did
not reset the sector size back to 2048 after the READ_10 opcode and
instead gained a lazy reset in do_sr_request() and sr_release().
It kept the new sector size and only changed if needed. On closing the
device node sr_release() reset the sector size back to its default
value.

In v2.3.16 the ioctl() (CDROMREADMODE2, CDROMREADRAW) were consolidated since
both stacks (SCSI and IDE) did mostly the same thing. For the ioctl handling
the SCSI implementation (doing sr_read_sector()) was removed and the ioctl was
now served based on what the IDE implementation had to offer which was
using cdrom_read_block(). cdrom_read_block() was also updated to use
READ_CD and invoke the ->generic_packeto() callback.
It is worth noting that READ_CD is now mandatory by the software stack.
The old function with the fallback (sr_read_sector()) is only used
sr_is_xa().

In v2.4.0-test2pre2 it is no longer mandatory to support the READ_CD
opcode. A fallback mechanism was added in case the device did not
supported the opcode. The mechanism had a small variance compared to the
one from v2.1.62 and did: MODE_SELECT of the requested sector size,
READ_10 and MODE_SELECT of the _requested_ sector size instead the
previous sector size. To quote a comment from the changelog
area of the file from when the change was introduced:
| -- Fix Video-CD on SCSI drives that don't support READ_CD command. In
| that case switch block size and issue plain READ_10 again, then switch
| back.

but the code did not switch back, the changed sector size remained. The comment
around the code says:
|/* FIXME: switch back again... */

which leaves me puzzled. My interpretation of my archaeological research
is that MODE_SELECT + READ_10 + FIXME was added first as the needed
workaround. Later within the same release the FIXME was addressed by
unfortunately using the wrong sector size, the FIXME comment remained
and the changelog comment was added.

This is what we have today. Lets move on with this background in mind.

The in_interrupt() check in sr_init_command() is a leftover from v2.1.62
change when the delayed sector size reset was used. It remained even
after it was no longer used after v2.3.16. 

The sector size change was introduced back in v2.4.0-test2pre2 for SCSI
devices that lack the READ_CD command but it was implemented
differently. It sends directly a CDB which is not inspected by
sr_packet() so the ->sector_size variable is never updated as it used
to be back at the time when ioctl() was served by `sr'. As a consequence
sr_release() is not resetting the sector size nor does
sr_init_command(). I did not find anything that would allow to update
the sector size at run time (other than a media change).

Side note: sr_init_command() is often invoked indirectly by
__blk_mq_run_hw_queue() which has a WARN_ON_ONCE(in_interrupt()) check
and acquires a rcu_readlock() so sleeping is not allowed and not
detected by in_interrupt().

Sebastian
