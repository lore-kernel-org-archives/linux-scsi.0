From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH][REPOST] scsi_lib_dma.c : fix bug w/ dma on virtual fc ports
Date: Tue, 7 Oct 2008 10:35:50 -0400
Message-ID: <1223390150.5930.8.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:40186 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYJGOfk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 10:35:40 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m97EZd0Y001896
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2008 07:35:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Updated for James B' comments... Also looked for other references. =20

=EF=BB=BF=EF=BB=BFWhen the updated scsi dma code was introduced recentl=
y, it assumed
the physical host/adapter was the parent of the scsi host.
Unfortunately, on FC virtual ports, the parent of the scsi host is
the virtual port, which does not have dma information.

I have updated the dma routines to use a function that finds the
first non-scsi object. A non-scsi object is defined to be an object
that has a non-NULL type (assumes all transport objects have NULL
types) or a non-scsi_host type.

-- james s



 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 drivers/scsi/scsi_lib.c     |    2 +-
 drivers/scsi/scsi_lib_dma.c |    7 +++++--
 include/scsi/scsi_host.h    |   15 +++++++++++++++
 3 files changed, 21 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	2008-09-23 15:12:13.000000000 -0400
+++ b/drivers/scsi/scsi_lib.c	2008-10-07 10:27:53.000000000 -0400
@@ -1631,7 +1631,7 @@ struct request_queue *__scsi_alloc_queue
 					 request_fn_proc *request_fn)
 {
 	struct request_queue *q;
-	struct device *dev =3D shost->shost_gendev.parent;
+	struct device *dev =3D dev_to_nonscsi_dev(shost->shost_gendev.parent)=
;
=20
 	q =3D blk_init_queue(request_fn, NULL);
 	if (!q)
diff -upNr a/drivers/scsi/scsi_lib_dma.c b/drivers/scsi/scsi_lib_dma.c
--- a/drivers/scsi/scsi_lib_dma.c	2008-09-23 15:12:13.000000000 -0400
+++ b/drivers/scsi/scsi_lib_dma.c	2008-10-07 10:13:40.000000000 -0400
@@ -23,7 +23,8 @@ int scsi_dma_map(struct scsi_cmnd *cmd)
 	int nseg =3D 0;
=20
 	if (scsi_sg_count(cmd)) {
-		struct device *dev =3D cmd->device->host->shost_gendev.parent;
+		struct device *dev =3D dev_to_nonscsi_dev(
+					cmd->device->host->shost_gendev.parent);
=20
 		nseg =3D dma_map_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
 				  cmd->sc_data_direction);
@@ -41,10 +42,12 @@ EXPORT_SYMBOL(scsi_dma_map);
 void scsi_dma_unmap(struct scsi_cmnd *cmd)
 {
 	if (scsi_sg_count(cmd)) {
-		struct device *dev =3D cmd->device->host->shost_gendev.parent;
+		struct device *dev =3D dev_to_nonscsi_dev(
+					cmd->device->host->shost_gendev.parent);
=20
 		dma_unmap_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
 			     cmd->sc_data_direction);
 	}
 }
 EXPORT_SYMBOL(scsi_dma_unmap);
+
diff -upNr a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2008-09-23 15:12:20.000000000 -0400
+++ b/include/scsi/scsi_host.h	2008-10-07 10:09:55.000000000 -0400
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
@@ -706,6 +710,17 @@ static inline struct Scsi_Host *dev_to_s
 	return container_of(dev, struct Scsi_Host, shost_gendev);
 }
=20
+/*
+ * walks object list backward, to find the first non-scsi object
+ * Skips over transport objects that may be vports, shosts under vport=
s, etc=20
+ */
+static inline struct device *dev_to_nonscsi_dev(struct device *dev)
+{
+	while (dev->type =3D=3D NULL || scsi_is_host_device(dev))
+		dev =3D dev->parent;
+	return dev;
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
