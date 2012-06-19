From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 0/7] uas: various fixes, add error handling.
Date: Tue, 19 Jun 2012 09:54:47 +0200
Message-ID: <1340092494-18876-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab2FSHy5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jun 2012 03:54:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>

  Hi,

This patch series improves usb attached scsi support.  It reverts two
bogus fixes which just trade one bug for another, then it fixes the
issues properly.

Any use-after-free issues, leading to horrific "BUG kmalloc-192 (Not
tainted): Poison overwritten" messages and sometimes kernel panics are
gone.

The last patch adds task management support and winds it up in the scsi
error handling callbacks.

Could test it only in non-streams mode, so some additional testing with
usb3 gear would be great.  Reviews are very welcome too.

cheers,
  Gerd

Gerd Hoffmann (7):
  Revert "usb/uas: make sure data urb is gone if we receive status
    before that"
  Revert "usb/uas: one only one status URB/host on stream-less
    connection"
  uas: fix sense urb handling
  uas: keep track of command state, finish scsi cmd when really done.
  uas: improve error handling
  uas: track urbs, kill inflight urbs on disconnect.
  uas: task mgmt & error handling

 drivers/usb/storage/uas.c |  422 ++++++++++++++++++++++++++------------------
 include/linux/usb/uas.h   |   40 +++++
 2 files changed, 289 insertions(+), 173 deletions(-)

