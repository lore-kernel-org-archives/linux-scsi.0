From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 0/2] target: make location of /var/target configurable
Date: Thu, 31 Mar 2016 11:05:28 -0700
Message-ID: <cover.1459278305.git.lduncan@suse.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: nab@linux-iscsi.org, hch@infradead.org, lkml@vger.kernel.org, hare@suse.com, Lee Duncan <lduncan@suse.com>
List-Id: linux-scsi@vger.kernel.org

These patches make the location of "/var/target" configurable,
though it still defauls to "/var/target".

This configuration is accomplished via the configfs
top-level target attribute "dbroot", i.e. dumping
out "/sys/kernel/config/target/dbroot" will normally
return "/var/target". Writing to this attribute
changes the loation where the kernel looks for the
target database.

** NOTE/QUESTION: no sanity checks are done on the path passed in,
   but it seems like *some* should be done. At least checking that
   it's an abosolute path (i.e. starts with '/')? Opinions?

Lee Duncan (2):
  Make target db location /var/targets configurable.
  Use the new "dbroot" configfs target attribute.

 drivers/target/target_core_alua.c     |  6 +++---
 drivers/target/target_core_configfs.c | 31 +++++++++++++++++++++++++++++++
 drivers/target/target_core_internal.h |  6 ++++++
 drivers/target/target_core_pr.c       |  2 +-
 4 files changed, 41 insertions(+), 4 deletions(-)

-- 
2.1.4
