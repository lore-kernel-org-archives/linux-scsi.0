From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/9] iscsi: set netns for iscsi_tcp hosts
Date: Tue, 31 Oct 2017 15:41:00 -0700
Message-ID: <20171031224104.17735-6-cleech@redhat.com>
References: <20171031224104.17735-1-cleech@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCYMVIPVXQMBBIPY4PHQKGQE3425J4Y-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20171031224104.17735-1-cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This lets iscsi_tcp operate in multiple namespaces.  It uses current
during session creation to find the net namespace, but it might be
better to manage to pass it along from the iscsi netlink socket.

Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/iscsi_tcp.c            | 7 +++++++
 drivers/scsi/scsi_transport_iscsi.c | 7 ++++++-
 include/scsi/scsi_transport_iscsi.h | 1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4d934d6c3e13..b368c94c884b 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -957,6 +957,11 @@ static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
+static struct net *iscsi_sw_tcp_netns(struct Scsi_Host *shost)
+{
+	return current->nsproxy->net_ns;
+}
+
 static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.module			= THIS_MODULE,
 	.name			= "iSCSI Initiator over TCP/IP",
@@ -1013,6 +1018,8 @@ static struct iscsi_transport iscsi_sw_tcp_transport = {
 	.alloc_pdu		= iscsi_sw_tcp_pdu_alloc,
 	/* recovery */
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
+	/* net namespace */
+	.get_netns		= iscsi_sw_tcp_netns,
 };
 
 static int __init iscsi_sw_tcp_init(void)
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 1fc5878b1a8c..2ec10f6ac3a2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1600,11 +1600,16 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct iscsi_cls_host *ihost = shost->shost_data;
+	struct iscsi_internal *priv = to_iscsi_internal(shost->transportt);
+	struct iscsi_transport *transport = priv->iscsi_transport;
 
 	memset(ihost, 0, sizeof(*ihost));
 	atomic_set(&ihost->nr_scans, 0);
 	mutex_init(&ihost->mutex);
-	ihost->netns = &init_net;
+	if (transport->get_netns)
+		ihost->netns = transport->get_netns(shost);
+	else
+		ihost->netns = &init_net;
 
 	iscsi_bsg_host_add(shost, ihost);
 	/* ignore any bsg add error - we just can't do sgio */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8c8191dfdc21..3c4cd4779f72 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -168,6 +168,7 @@ struct iscsi_transport {
 	int (*logout_flashnode_sid) (struct iscsi_cls_session *cls_sess);
 	int (*get_host_stats) (struct Scsi_Host *shost, char *buf, int len);
 	u8 (*check_protection)(struct iscsi_task *task, sector_t *sector);
+	struct net *(*get_netns)(struct Scsi_Host *shost);
 };
 
 /*
-- 
2.9.5

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
