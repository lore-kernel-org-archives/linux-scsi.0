From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH RFC 0/2] percpu_tags: Prototype implementation
Date: Fri, 18 Jul 2014 12:20:56 +0200
Message-ID: <cover.1405678629.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com, Nicholas Bellinger <nab@daterainc.com>, Kent Overstreet <kmo@daterainc.com>, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hello Gentleman,

This is a development of "percpu_ida" library. I named it
"percpu_tags" to simplify review, since most of "percpu_ida"
code has gone and a diff would not be informative.

While the concept of per-cpu arrays is is preserved, the
implementation is heavily reworked. The main objective is to
improve the "percpu_ida" locking scheme.

Here is the list of major differrences between "percpu_ida" and
"percpu_tags":

* The global freelist has gone. As result, CPUs do not compete
  for the global lock.

* Long-running operatons (scanning thru a cpumask) are executed
  with local interrupts enabled;

* percpu_ida::percpu_max_size limit is eliminated. Instead, the
  limit is determined dynamically. Depending from how many CPUs
  are requesting tags each CPU gets a fair share of the tag space;

* A tag is attempted to return to the CPU it was allocated on. As
  result, it is expected the locality of data associated with the
  tag benefits;

The code is largely raw and untested. The reason I am posting
is the prototype implementation performs 2-3 times faster than
"percpu_ida", so I would like to ensure if it worth going further
with this approach or is there a no-go.

The performance test is not decent, though. I used "fio" random
read against a "null_blk" device sitting on top of "percpu_tags",
which is not exactly how "percpu_ida" is used. This is another
reason I am posting - an advice on how to properly test is very
appreciated.

The source code could be found at
https://github.com/a-gordeev/linux.git	percpu_tags-v0

Thanks!

Cc: linux-scsi@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com
Cc: Nicholas Bellinger <nab@daterainc.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>

Alexander Gordeev (2):
  percpu_tags: Prototype implementation
  percpu_tags: Use percpu_tags instead of percpu_ida

 drivers/scsi/qla2xxx/qla_target.c        |    6 +-
 drivers/target/iscsi/iscsi_target_util.c |    6 +-
 drivers/target/target_core_transport.c   |    4 +-
 drivers/target/tcm_fc/tfc_cmd.c          |    8 +-
 drivers/vhost/scsi.c                     |    6 +-
 include/linux/percpu_tags.h              |   37 ++
 include/target/target_core_base.h        |    4 +-
 lib/Makefile                             |    2 +-
 lib/percpu_tags.c                        |  556 ++++++++++++++++++++++++++++++
 9 files changed, 611 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/percpu_tags.h
 create mode 100644 lib/percpu_tags.c

-- 
1.7.7.6
