From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/5 v2] firewire: fw-sbp2: let SCSI shutdown commands through
	before logout
Date: Mon, 18 Jun 2007 18:46:49 +0200 (CEST)
Message-ID: <tkrat.301a907417598815@s5r6.in-berlin.de>
References: <tkrat.b43f5b2b920f45c6@s5r6.in-berlin.de>
	<tkrat.86a8cf28dc784b39@s5r6.in-berlin.de>
	<1182180417.7928.13.camel@hinata.boston.redhat.com>
	<4676B3FD.9010604@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <4676B3FD.9010604@s5r6.in-berlin.de>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This affects of course only the "soft shutdown" case, e.g. "modprobe -r
firewire-sbp2", while it doesn't matter for hot unplug.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Update:
  - Do it much simpler without scsi_remove_device.
  - Omit the unrelated sbp2_sysfs_ieee1394_id_show hunks.
    They will come back later when multi-LU support is implemented.

 drivers/firewire/fw-sbp2.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -520,17 +520,15 @@ static int sbp2_agent_reset(struct fw_un
 static void sbp2_reconnect(struct work_struct *work);
 static struct scsi_host_template scsi_driver_template;
 
-static void
-release_sbp2_device(struct kref *kref)
+static void release_sbp2_device(struct kref *kref)
 {
 	struct sbp2_device *sd = container_of(kref, struct sbp2_device, kref);
 	struct Scsi_Host *host =
 		container_of((void *)sd, struct Scsi_Host, hostdata[0]);
 
+	scsi_remove_host(host);
 	sbp2_send_management_orb(sd->unit, sd->node_id, sd->generation,
 				 SBP2_LOGOUT_REQUEST, sd->login_id, NULL);
-
-	scsi_remove_host(host);
 	fw_core_remove_address_handler(&sd->address_handler);
 	fw_notify("removed sbp2 unit %s\n", sd->unit->device.bus_id);
 	put_device(&sd->unit->device);

-- 
Stefan Richter
-=====-=-=== -==- =--=-
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
