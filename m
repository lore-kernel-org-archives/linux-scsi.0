Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D745BC4167B
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 22:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C343E61156
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 22:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbhI0WCM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 18:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237302AbhI0WCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 18:02:07 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0318CC061740;
        Mon, 27 Sep 2021 15:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=22q9vzpl2dXUwK7nVvBTR3mAGKS0Ud2dVafLPYZ1N6w=; b=fXryKHS+1xfUeeje0/B5N9Mwy3
        SOtpojgrG7/3gHC2uHuRHB0SyUsdehgWj0rkMFzKj+VA8nfDWjHavq0W+i6NlraTFwpYxx6MA1gPt
        MKzrzTkKcH5wDk+h5tZsdAsvly/3YxkryIkDJNf8LOFsBuYdheLdM2nerqJ7K4sItN5wW0yaQCqXg
        2mmfe5qQ8kEoCPfkGKW5jnyhwVKNh0saDBYZdPkHw3jcBkYwizVat3A1aYb34Z9i5Vuxoc+SsOPd1
        X4WglY0egjUg85WuYz0mYR6VJUANRu4++6iHZMZKI6VUuGOt+VzcC8/F2Gdv/pNSY0S27yt9qMAHQ
        kK8lXg8Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUyfM-004SUt-Qa; Mon, 27 Sep 2021 22:00:04 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com
Cc:     hch@infradead.org, hare@suse.de, bvanassche@acm.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-mmc@vger.kernel.org,
        dm-devel@redhat.com, nbd@other.debian.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v4 0/6] block: first batch of add_disk() error handling conversions
Date:   Mon, 27 Sep 2021 14:59:52 -0700
Message-Id: <20210927215958.1062466-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is the first set of driver conversions to use the add_disk() error
handling. You can find these changes along with the entire 7th set of
driver conversions on my 20210927-for-axboe-add-disk-error-handling
branch [0].

Changes on this v4 since the last v3:

 - Rebased onto linux-next tag 20210927
 - I drop the patches already merged
 - Fix the scsi/sd, scsi/sr as noted by Ming Lei
 - md: rebased in light of "md: fix a lock order reversal in md_alloc"
 - Adds Reviewed / Acked by tags where appropriate. I didn't keep the
   review by Hannes on the scsi patches as those patches are now
   slightly fixed

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20210927-for-axboe-add-disk-error-handling

Luis Chamberlain (6):
  scsi/sd: add error handling support for add_disk()
  scsi/sr: add error handling support for add_disk()
  md: add error handling support for add_disk()
  dm: add add_disk() error handling
  loop: add error handling support for add_disk()
  nbd: add error handling support for add_disk()

 drivers/block/loop.c | 8 +++++++-
 drivers/block/nbd.c  | 6 +++++-
 drivers/md/dm.c      | 4 +++-
 drivers/md/md.c      | 6 +++++-
 drivers/scsi/sd.c    | 8 +++++++-
 drivers/scsi/sr.c    | 7 ++++++-
 6 files changed, 33 insertions(+), 6 deletions(-)

-- 
2.30.2

