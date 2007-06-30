From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update scsi-misc] Make scsi_host_template::proc_name const
 char * instead of char *.
Date: Sat, 30 Jun 2007 10:31:22 +0200 (CEST)
Message-ID: <tkrat.bcd559ac9087987f@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:34331 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbXF3Ibj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jun 2007 04:31:39 -0400
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>

Date: Wed, 9 May 2007 19:23:12 -0400
=46rom: Kristian H=F8gsberg <krh@redhat.com>

Signed-off-by: Kristian H=F8gsberg <krh@redhat.com>

collapsed with fw-sbp2 patch "Drop cast to non-const char * in host
template initialization." from Kristian H=F8gsberg

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    2 +-
 drivers/scsi/scsi_debug.c  |    2 +-
 include/scsi/scsi_host.h   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 6830041..e8f5852 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1111,7 +1111,7 @@ static int sbp2_scsi_abort(struct scsi_cmnd *cmd)
 static struct scsi_host_template scsi_driver_template =3D {
 	.module			=3D THIS_MODULE,
 	.name			=3D "SBP-2 IEEE-1394",
-	.proc_name		=3D (char *)sbp2_driver_name,
+	.proc_name		=3D sbp2_driver_name,
 	.queuecommand		=3D sbp2_scsi_queuecommand,
 	.slave_alloc		=3D sbp2_scsi_slave_alloc,
 	.slave_configure	=3D sbp2_scsi_slave_configure,
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4cd9c58..4947dfe 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2875,7 +2875,7 @@ static int __init scsi_debug_init(void)
=20
 	init_all_queued();
=20
-	sdebug_driver_template.proc_name =3D (char *)sdebug_proc_name;
+	sdebug_driver_template.proc_name =3D sdebug_proc_name;
=20
 	host_to_add =3D scsi_debug_add_host;
         scsi_debug_add_host =3D 0;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ba07cf7..3b8a6a8 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -341,7 +341,7 @@ struct scsi_host_template {
 	/*
 	 * Name of proc directory
 	 */
-	char *proc_name;
+	const char *proc_name;
=20
 	/*
 	 * Used to store the procfs directory if a driver implements the
--=20
1.5.1.6


--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D -=3D=3D- =3D=3D=3D=3D-
http://arcgraph.de/sr/

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
