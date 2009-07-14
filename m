From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 0/3] cciss rmmod/scan-thread fixes
Date: Tue, 14 Jul 2009 16:02:40 -0600
Message-ID: <20090714220239.22282.44414.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756141AbZGNWCm@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

The following series fixes several problems causing hangs while
rmmoding the cciss driver. In the process of fixing these hangs, I
also reworked the the logical drive scanning kernel thread to use one
thread per driver rather than one thread per controller. I also added
a sysfs attribute to kick off a controller scan.

 .../ABI/testing/sysfs-bus-pci-devices-cciss        |    7 +
 drivers/block/cciss.c                              |  198 ++++++++++++++++++--
 drivers/block/cciss.h                              |    7 +
 3 files changed, 188 insertions(+), 24 deletions(-)

Andrew Patterson (3):
      cciss: remove logical drive sysfs entries during driver cleanup.
      cciss: use only one scan thread
      cciss: kick off logical drive topology rescan through sysfs



-- 
Andrew Patterson
