From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2 0/3] scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k
Date: Tue, 24 Nov 2015 10:42:24 +0100
Message-ID: <1448358147-23663-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Julian Calaby <julian.calaby@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
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

v2: prepend patch to unsplit a few string literals for greppability,
leave the NULL sentinel in the .c file in 2/3 (it's removed in 3/3
either way).

Rasmus Villemoes (3):
  scsi: make some Additional Sense strings more grep'able
  scsi: move Additional Sense Codes to separate file
  scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k

 drivers/scsi/constants.c   | 859 ++-------------------------------------------
 drivers/scsi/sense_codes.h | 826 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 847 insertions(+), 838 deletions(-)
 create mode 100644 drivers/scsi/sense_codes.h

-- 
2.6.1
