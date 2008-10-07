From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] scsi_lib_dma.c : fix bug w/ dma maps on virtual fc ports
Date: Tue, 7 Oct 2008 09:35:18 -0400
Message-ID: <1223386518.3082.9.camel@ogier>
Reply-To: <James.Smart@Emulex.Com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33471 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbYJGNfQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 09:35:16 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m97DZFKV025164
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2008 06:35:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

=EF=BB=BFWhen the updated scsi dma code was introduced recently, it ass=
umed the
physical host/adapter was the parent of the scsi host. Unfortunately,
on FC virtual ports, the parent of the scsi host is the virtual port,
which does not have dma information.

I have updated the dma map routines to use a function that finds the
top-most scsi host, then use the parent of that host.  This is a bit
ugly as every dma request does this walking, to the top of the object
tree.

A different option that was considered was taking the parent dev, then
walking the dev list backward to find the first device with a dma mask,
then using that device.
  Eg:   while (!dev->dma_mask)  dev=3Ddev->parent;

If there is a better solution, please let me know.

-- james s


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 drivers/scsi/scsi_lib_dma.c |   13 +++++++++----
 include/scsi/scsi_host.h    |   21 +++++++++++++++++++++
 2 files changed, 30 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/scsi_lib_dma.c b2/drivers/scsi/scsi_lib_dma.c
--- a/drivers/scsi/scsi_lib_dma.c	2008-09-23 15:12:13.000000000 -0400
+++ b2/drivers/scsi/scsi_lib_dma.c	2008-10-03 12:19:39.000000000 -0400
@@ -23,9 +23,11 @@ int scsi_dma_map(struct scsi_cmnd *cmd)
 	int nseg =3D 0;
=20
 	if (scsi_sg_count(cmd)) {
-		struct device *dev =3D cmd->device->host->shost_gendev.parent;
+		struct Scsi_Host *shost;
=20
-		nseg =3D dma_map_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
+		shost =3D dev_to_phys_shost(&cmd->device->sdev_gendev);
+		nseg =3D dma_map_sg(shost->shost_gendev.parent,
+				  scsi_sglist(cmd), scsi_sg_count(cmd),
 				  cmd->sc_data_direction);
 		if (unlikely(!nseg))
 			return -ENOMEM;
@@ -41,10 +43,13 @@ EXPORT_SYMBOL(scsi_dma_map);
 void scsi_dma_unmap(struct scsi_cmnd *cmd)
 {
 	if (scsi_sg_count(cmd)) {
-		struct device *dev =3D cmd->device->host->shost_gendev.parent;
+		struct Scsi_Host *shost;
=20
-		dma_unmap_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
+		shost =3D dev_to_phys_shost(&cmd->device->sdev_gendev);
+		dma_unmap_sg(shost->shost_gendev.parent,
+			     scsi_sglist(cmd), scsi_sg_count(cmd),
 			     cmd->sc_data_direction);
 	}
 }
 EXPORT_SYMBOL(scsi_dma_unmap);
+
diff -upNr a/include/scsi/scsi_host.h b2/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2008-09-23 15:12:20.000000000 -0400
+++ b2/include/scsi/scsi_host.h	2008-10-03 12:16:46.000000000 -0400
@@ -696,6 +696,10 @@ static inline void *shost_priv(struct Sc
=20
 int scsi_is_host_device(const struct device *);
=20
+/*
+ * walks object list backward, to find the first shost object.
+ * Skips over transport objects that may not be stargets, etc
+ */
 static inline struct Scsi_Host *dev_to_shost(struct device *dev)
 {
 	while (!scsi_is_host_device(dev)) {
@@ -706,6 +710,23 @@ static inline struct Scsi_Host *dev_to_s
 	return container_of(dev, struct Scsi_Host, shost_gendev);
 }
=20
+/*
+ * walks object list backward, to find the top-most shost object.
+ * Skips over transport objects that may be vports, shosts under
vports, etc=20
+ */
+static inline struct Scsi_Host *dev_to_phys_shost(struct device *dev)
+{
+	struct Scsi_Host *shost_new =3D dev_to_shost(dev);
+	struct Scsi_Host *shost =3D shost_new;
+
+	while (shost_new) {
+		shost_new =3D dev_to_shost(shost->shost_gendev.parent);
+		if (shost_new)
+			shost =3D shost_new;
+	}
+	return shost;
+}
+
 static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
 {
 	return shost->shost_state =3D=3D SHOST_RECOVERY ||


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
