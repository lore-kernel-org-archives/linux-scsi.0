From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/4] scsi_dh: Make scsi_dh_activate
	asynchronous
Date: Mon, 05 Oct 2009 16:35:26 +0200
Message-ID: <4ACA042E.2000507@suse.de>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
	<4AC9EE1B.7030702@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060309060709000905050009"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AC9EE1B.7030702@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Benoit_Arthur@emc.com, Eddie.Williams@steeleye.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060309060709000905050009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hannes Reinecke wrote:
[ .. ]
> However: The main reason why we're getting flooded with MODE SELECT=20
> commands
> is that the RDAC handler switches _each LUN_, not the entire controller=
.
> Seeing that the controller simply cannot cope with the resulting MODE=20
> SELECT
> flood wouldn't it be more sensible to switch the entire controller here=
?
>=20
> After all, we're trying to address a communication failure between the
> HBA and the controller, not a failure between the controller and the LU=
N.
> And by that reasoning switching individual LUNs is quite pointless as w=
e
> have to switch _all_ LUNs handled by this controller eventually.
>=20
> So I would suggest to first issue a MODE SENSE command to check which L=
UNs
> are currently handled by this controller and then switch those LUNs in
> one go. This way we would be sending quite a few MODE SENSE commands,
> but I was under the impression that those do not have any restriction.
>=20
> I will see to draw up a patch.
>=20
Was easier than I thought. Patch is attached.
Note: Proof of concept only. No warranties.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--------------060309060709000905050009
Content-Type: text/plain;
 name="rdac-transfer-all-luns"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rdac-transfer-all-luns"

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index ec0ad84..6900115 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -42,6 +42,7 @@
 /*
  * Controller modes definitions
  */
+#define RDAC_MODE_TRANSFER_ALL_VISIBLE_LUNS	0x01
 #define RDAC_MODE_TRANSFER_SPECIFIED_LUNS	0x02
 
 /*
@@ -129,6 +130,7 @@ struct rdac_controller {
 	u8			subsys_id[SUBSYS_ID_LEN];
 	u8			slot_id[SLOT_ID_LEN];
 	int			use_ms10;
+	int			transfer_all_luns;
 	struct kref		kref;
 	struct list_head	node; /* list of all controllers */
 	union			{
@@ -253,7 +255,8 @@ static struct request *rdac_failover_get(struct scsi_device *sdev,
 		rdac_pg->subpage_code = 0x1;
 		rdac_pg->page_len[0] = 0x01;
 		rdac_pg->page_len[1] = 0x28;
-		rdac_pg->lun_table[h->lun] = 0x81;
+		if (!h->ctlr->transfer_all_luns)
+			rdac_pg->lun_table[h->lun] = 0x81;
 	} else {
 		struct rdac_pg_legacy *rdac_pg;
 
@@ -263,9 +266,13 @@ static struct request *rdac_failover_get(struct scsi_device *sdev,
 		common = &rdac_pg->common;
 		rdac_pg->page_code = RDAC_PAGE_CODE_REDUNDANT_CONTROLLER;
 		rdac_pg->page_len = 0x68;
-		rdac_pg->lun_table[h->lun] = 0x81;
+		if (!h->ctlr->transfer_all_luns)
+			rdac_pg->lun_table[h->lun] = 0x81;
 	}
-	common->rdac_mode[1] = RDAC_MODE_TRANSFER_SPECIFIED_LUNS;
+	if (h->ctlr->transfer_all_luns)
+		common->rdac_mode[1] = RDAC_MODE_TRANSFER_ALL_VISIBLE_LUNS;
+	else
+		common->rdac_mode[1] = RDAC_MODE_TRANSFER_SPECIFIED_LUNS;
 	common->quiescence_timeout = RDAC_QUIESCENCE_TIME;
 	common->rdac_options = RDAC_FORCED_QUIESENCE;
 
@@ -326,6 +333,7 @@ static struct rdac_controller *get_controller(u8 *subsys_id, u8 *slot_id)
 	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
 	kref_init(&ctlr->kref);
 	ctlr->use_ms10 = -1;
+	ctlr->transfer_all_luns = 1;
 	list_add(&ctlr->node, &ctlr_list);
 done:
 	spin_unlock(&list_lock);

--------------060309060709000905050009
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060309060709000905050009--
