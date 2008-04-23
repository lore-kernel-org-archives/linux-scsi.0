From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 0/5] block large commands support continue
Date: Wed, 23 Apr 2008 17:50:42 +0300
Message-ID: <480F4CC2.7070804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Pete Wyckoff <pw@osc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


The support for large commands was dropped from the for-2.6.26 branch
and will probably not get accepted into next kernel.

I have tried to take all comments from Jens and Bart. and incorporate
it into a new patchset. This is basically Tomo's patchset but with
proposed changes.

They are based on current linux-block/master. They will probably conflict with
latest patch sent by Tomo for the blk_get_request(). Once those patches
get accepted at some git tree, (Where will that be?), I will rebase these
on top of them. Please CC me of any progress.

[PATCH 1/5] block: no need to initialize rq->cmd
  This is 2 of Tomo's patches squashed together as they are
  small and do the same. Tomo is this OK?

[PATCH 2/5] block: replace sizeof(rq->cmd) with BLK_MAX_CDB
  Tomos patch rebased to here

[PATCH 3/5] block: Export rq_init, rename to blk_init_rq
[PATCH 4/5] block: Use new blk_init_rq
  These patches are basically what Jens and Bart has suggested, that with
  a small code change to blk-core.c we can memset at rq_init() and only set
  none zero members. We can also export that initializer and use it all over
  the ide tree where ever requests don't come from a request queue. (OK also
  at scsi_error.c)

[PATCH 5/5] block: add large command support
  Now that all initialization goes through one place Tomos large command support
  is trivial.

Bart. This is mostly ide changes, so please if you can test it. I do not have
any legacy IDE devices here at the office, it is all new sata stuff.

I hope we can put this, and later the scsi stuff, on some tree that can be tested
at -mm and hopefully be ready for 2.6.27

Thanks
Boaz
