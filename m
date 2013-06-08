From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Per session tag pooling WIP using lib/tags
Date: Sat,  8 Jun 2013 02:42:15 +0000
Message-ID: <1370659338-23841-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57536 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3FHCzs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jun 2013 22:55:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks.

Here is an initial series for adding target descriptor pre-allocation
support based upon Kent's excellent per-cpu struct tag_pool library code.

It allows fabric drivers to avoid fast path memory allocation/free
overhead up to the number of registered struct tag_pool tags known at
se_session creation time, similar to how blk-mq currently works using
hw tag resource pre-allocation of struct request and friends.

Thus far vhost/scsi has been updated to use se_sess->sess_tag_pool,
and patches doing similar fabric driver pre-allocation conversions
are currently a WIP..

Also given lib/tags is not upstream just yet, Kent's patch is included
here for review context.

Thank you,

--nab

Kent Overstreet (1):
  Percpu tag allocator

Nicholas Bellinger (2):
  target: Add transport_init_session_tagpool using per-cpu command map
  vhost/scsi: Convert to generic tag_alloc + tag_free command map

 drivers/target/target_core_transport.c |   33 +++++++
 drivers/vhost/scsi.c                   |   31 ++++---
 include/linux/tags.h                   |   38 +++++++
 include/target/target_core_base.h      |    5 +
 include/target/target_core_fabric.h    |    1 +
 lib/Kconfig                            |    4 +
 lib/Makefile                           |    5 +-
 lib/tags.c                             |  166 ++++++++++++++++++++++++++++++++
 8 files changed, 269 insertions(+), 14 deletions(-)
 create mode 100644 include/linux/tags.h
 create mode 100644 lib/tags.c

-- 
1.7.2.5

