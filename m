From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] fc_transport: (update on top of) Add an API to allow an
	LLD to create vports
Date: Fri, 18 Jul 2008 10:52:18 -0400
Message-ID: <1216392738.5831.4.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42249 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbYGROwV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jul 2008 10:52:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: seokmann.ju@qlogic.com

Andrew,

Sorry for not commenting sooner on the RFC.  The reorg is fine, but
I have a couple of comments.

Re: scsi_fc_transport.txt
  Add a function prototype for fc_vport_terminate similar to what's
  done for fc_vport_create

Re: fc_vport_create
  I recommend we pass the channel number in fc_vport_create rather
  than fixing it at zero.

  Also, ids->vport_type should be set to FC_PORTTYPE_NPIV prior to
  calling fc_vport_create. The comment is also meaningless.

I've appended a patch for the above.

-- james s


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 Documentation/scsi/scsi_fc_transport.txt |    2 ++
 drivers/scsi/scsi_transport_fc.c         |    9 +++++----
 include/scsi/scsi_transport_fc.h         |    2 +-
 3 files changed, 8 insertions(+), 5 deletions(-)


diff -upNr a/Documentation/scsi/scsi_fc_transport.txt b/Documentation/scsi/scsi_fc_transport.txt
--- a/Documentation/scsi/scsi_fc_transport.txt	2008-07-18 10:17:57.000000000 -0400
+++ b/Documentation/scsi/scsi_fc_transport.txt	2008-07-18 10:18:38.000000000 -0400
@@ -468,6 +468,8 @@ fc_vport_create(struct Scsi_Host *shost,
  * Notes:
  *      This routine assumes no locks are held on entry.
  */
+int
+fc_vport_terminate(struct fc_vport *vport)
 
 
 Credits
diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2008-07-18 10:17:57.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2008-07-18 10:36:20.000000000 -0400
@@ -3209,6 +3209,7 @@ delete_vport:
 /**
  * fc_vport_create - Admin App or LLDD requests creation of a vport
  * @shost:	scsi host the virtual port is connected to.
+ * @channel:	channel on shost port connected to.
  * @ids:	The world wide names, FC4 port roles, etc for
  *              the virtual port.
  *
@@ -3216,14 +3217,14 @@ delete_vport:
  *	This routine assumes no locks are held on entry.
  */
 struct fc_vport *
-fc_vport_create(struct Scsi_Host *shost, struct fc_vport_identifiers *ids)
+fc_vport_create(struct Scsi_Host *shost, int channel,
+	struct fc_vport_identifiers *ids)
 {
 	int stat;
 	struct fc_vport *vport;
 
-	/* We only create vports here. */
-	ids->vport_type = FC_PORTTYPE_NPIV;
-	stat = fc_vport_setup(shost, 0, &shost->shost_gendev, ids, &vport);
+	stat = fc_vport_setup(shost, channel, &shost->shost_gendev,
+		 ids, &vport);
 	return stat ? NULL : vport;
 }
 EXPORT_SYMBOL(fc_vport_create);
diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2008-07-18 10:17:57.000000000 -0400
+++ b/include/scsi/scsi_transport_fc.h	2008-07-18 10:32:25.000000000 -0400
@@ -751,7 +751,7 @@ void fc_host_post_vendor_event(struct Sc
 	 *   be sure to read the Vendor Type and ID formatting requirements
 	 *   specified in scsi_netlink.h
 	 */
-struct fc_vport *fc_vport_create(struct Scsi_Host *shost,
+struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
 


