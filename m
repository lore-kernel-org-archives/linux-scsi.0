From: Weongyo Jeong <weongyo.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 0/2] genirq: support multiple IRQ notifier.
Date: Fri, 25 Mar 2016 08:51:51 -0700
Message-ID: <cover.1458920770.git.weongyo.linux@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Weongyo Jeong <weongyo.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Each irq_desc only supports one IRQ affinity notifier at current
implementation so when we try to register another notifier, it silently
unregister previous entry and register new one.

However the problem is that if CONFIG_RFS_ACCEL is set, at current
implementation no way to set additional IRQ affinity notifier for
some NIC cards RFS enabled because it already used for RFS.
With this patch we can register multiple IRQ affinity notifiers.

Weongyo Jeong (2):
  genirq: clean up for irq_set_affinity_notifier().
  genirq: support multiple IRQ notifier.

 drivers/infiniband/hw/qib/qib_iba7322.c | 10 ++--
 drivers/scsi/qla2xxx/qla_isr.c          |  4 +-
 include/linux/interrupt.h               | 13 +++++-
 include/linux/irqdesc.h                 |  2 +-
 kernel/irq/irqdesc.c                    |  1 +
 kernel/irq/manage.c                     | 82 ++++++++++++++++++++++-----------
 lib/cpu_rmap.c                          |  4 +-
 7 files changed, 78 insertions(+), 38 deletions(-)

-- 
2.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
