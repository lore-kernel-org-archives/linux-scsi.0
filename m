From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 0/2] scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k
Date: Mon,  5 Oct 2015 11:26:38 +0200
Message-ID: <1444037200-14684-1-git-send-email-linux@rasmusvillemoes.dk>
References: <20151004080217.GA22816@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151004080217.GA22816@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-Id: linux-scsi@vger.kernel.org

This reduces the impact of choosing CONFIG_SCSI_CONSTANTS by about 8KB.

2dd951ecd511 ("scsi: Conditionally compile in constants.c") updated
the Kconfig help text from 12KB to 75KB. The 12K predated git so was
certainly outdated. But I'm not sure where the 75K comes from; using
size(1) on a defconfig (with/without this config option) vmlinux shows
a difference of about 47K, and 39K after these patches are applied. In
any case, I've left the Kconfig text alone, since I'm not sure I'm
counting the same way the 75K was computed (I'm fairly certain of the
8K delta, however).

Tested with a trivial module calling scsi_extd_sense_format with a few
random known codes and comparing the result to the expected value.

Rasmus Villemoes (2):
  scsi: move Additional Sense Codes to separate file
  scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k

 drivers/scsi/constants.c   | 860 ++-------------------------------------------
 drivers/scsi/sense_codes.h | 835 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 857 insertions(+), 838 deletions(-)
 create mode 100644 drivers/scsi/sense_codes.h

-- 
2.1.3
