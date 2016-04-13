From: Lee Duncan <lduncan@suse.com>
Subject: [PATCHv2 0/2] target: make location of /var/targets configurable
Date: Wed, 13 Apr 2016 13:25:54 -0700
Message-ID: <cover.1460577841.git.lduncan@suse.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, nab@linux-iscsi.org, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, hare@suse.de, agrover@redhat.com, jxm@netiant.com, Lee Duncan <lduncan@suse.com>
List-Id: linux-scsi@vger.kernel.org

These patches make the location of "/var/target" configurable,
though it still defauls to "/var/target".

This "target database directory" can only be changed
after the target_core_mod loads but before any
fabric drivers are loaded, and must be the pathname
of an existing directory.

This configuration is accomplished via the configfs
top-level target attribute "dbroot", i.e. dumping
out "/sys/kernel/config/target/dbroot" will normally
return "/var/target". Writing to this attribute
changes the loation where the kernel looks for the
target database.

The first patch creates this configurable value for
the "dbroot", and the second patch modifies users
of this directory to use this new attribute.

Changes from v1:
 * Only allow changing target DB root before it
   can be used by others
 * Validate that new DB root is a valid directory

Lee Duncan (2):
  target: make target db location configurable
  target: use new "dbroot" target attribute

 drivers/target/target_core_alua.c     |  6 ++---
 drivers/target/target_core_configfs.c | 51 +++++++++++++++++++++++++++++++++++
 drivers/target/target_core_internal.h |  6 +++++
 drivers/target/target_core_pr.c       |  2 +-
 4 files changed, 61 insertions(+), 4 deletions(-)

-- 
2.1.4
