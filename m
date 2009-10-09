From: Hannes Reinecke <hare@suse.de>
Subject: Re: RE: [PATCH 0/4] scsi_dh: Make
	scsi_dh_activate	asynchronous
Date: Fri, 09 Oct 2009 16:55:39 +0200
Message-ID: <4ACF4EEB.6000002@suse.de>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>	<4AC9EE1B.7030702@suse.de>
	<1254785154.15826.18.camel@chandra-ubuntu>	<4ACAFAF5.5000805@suse.de>
	<E463DF2B2E584B4A82673F53D62C2EF474ED90C7@cosmail01.lsi.com>
	<E463DF2B2E584B4A82673F53D62C2EF474ED95C8@cosmail01.lsi.com>
	<4ACF05FF.2030401@suse.de>
	<E463DF2B2E584B4A82673F53D62C2EF474F4317C@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010000030908070307030901"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474F4317C@cosmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, device-mapper development <dm-devel@redhat.com>, "Chauhan,
	Vijay" <Vijay.Chauhan@lsi.com>, "Benoit_Arthur@emc.com" <Benoit_Arthur@emc.com>, "Qi,
	Yanling" <Yanling.Qi@lsi.com>, "Eddie.Williams@steeleye.com" <Eddie.Williams@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010000030908070307030901
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

Moger, Babu wrote:
> Hannes, Thanks again for the response..  Please see the comments below.=
.
> =20
>> Moger, Babu wrote:
>>> 1. Run I/O on both these Luns
>>> 2. Pull the cable connected to controller A.
>>> 3. Failover will happen and Lun 0 will move to controller B. Now both
>> the Luns are on controller B.
>>> 4. Connect the cable back on controller A.
>>> 5. multipath tool will detect the physical Luns on controller A and
>> run the priority test.
>>> 6. It will find that Lun 0 is not on preferred path and will initiate
>> a failback.
>>>    Because it is a controller level failover it will move the Lun 1
>> also to controller A.
>>>    Now both the Luns are on controller A.
>>> 7. Multipath tool will come again and find Lun 1 not on preferred
>> path and initiate failback.
>>>    This will both the Luns to controller B.
>>>    This will continue forever.
>>>
>> Hmm. Yes, correct.
>> After all, the patch I sent was meant to be a proof of concept, not a
>> fully fledged
>> solution. (In fact, I'm quite surprised it worked so well :-)
>>
>> What about modifying the LUN select code to switch all _visible_ LUNs
>> (ie all LUNs which
>> are _not_ on the preferred path) in one go?
>> That way we wouldn't run into this issue.
>=20
> In this case handler should be able to do two tasks.
> 1. move all the Luns when one of the path failed(failover)
> 2. move only the luns which are not there on preferred path(failback).
>=20
> With the current code rdac_activate(struct scsi_device *sdev) we cannot=
 make that decision.
>  There is no information passed from dm layer to know if this command i=
s for task 1(failover) or task 2(failback).=20

Correct, but we don't need to.
We can detect the preferred path bit and use that to make this decision.
When the preferred path bit is not set for this LUN, we're switching _fro=
m_ the preferred path.
So chances are quite good that we're in failover mode and should transfer=
 all LUNs.
When the preferred path bit is set, we're switching _to_ it and we're in =
failback mode.
So we should be transferring this path only; reasoning here is that failb=
ack is
triggered from the daemon and is running asynchronously anyway. So it doe=
sn't really
matter how long this will take.

So something like the attached patch should work.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--------------010000030908070307030901
Content-Type: text/plain;
 name="rdac-failover-all-luns"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rdac-failover-all-luns"

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 0bd33ee..d163cd8 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -42,6 +42,7 @@
 /*
  * Controller modes definitions
  */
+#define RDAC_MODE_TRANSFER_ALL_VISIBLE_LUNS	0x01
 #define RDAC_MODE_TRANSFER_SPECIFIED_LUNS	0x02
 
 /*
@@ -178,6 +179,7 @@ struct rdac_dh_data {
 #define RDAC_LUN_UNOWNED	0
 #define RDAC_LUN_OWNED		1
 #define RDAC_LUN_AVT		2
+#define RDAC_LUN_PREF		4
 	char			lun_state;
 	unsigned char		sense[SCSI_SENSE_BUFFERSIZE];
 	union			{
@@ -192,7 +194,12 @@ static const char *lun_state[] =
 {
 	"unowned",
 	"owned",
-	"owned (AVT mode)",
+	"unowned (AVT)",
+	"owned (AVT)",
+	"unowned (preferred)",
+	"owned (preferred)",
+	"unowned (preferred,AVT)",
+	"owned (preferred,AVT)",
 };
 
 static LIST_HEAD(ctlr_list);
@@ -253,7 +260,8 @@ static struct request *rdac_failover_get(struct scsi_device *sdev,
 		rdac_pg->subpage_code = 0x1;
 		rdac_pg->page_len[0] = 0x01;
 		rdac_pg->page_len[1] = 0x28;
-		rdac_pg->lun_table[h->lun] = 0x81;
+		if (h->lun->state & RDAC_LUN_PREF)
+			rdac_pg->lun_table[h->lun] = 0x81;
 	} else {
 		struct rdac_pg_legacy *rdac_pg;
 
@@ -263,9 +271,16 @@ static struct request *rdac_failover_get(struct scsi_device *sdev,
 		common = &rdac_pg->common;
 		rdac_pg->page_code = RDAC_PAGE_CODE_REDUNDANT_CONTROLLER;
 		rdac_pg->page_len = 0x68;
-		rdac_pg->lun_table[h->lun] = 0x81;
+		if (h->lun_state & RDAC_LUN_PREF)
+			rdac_pg->lun_table[h->lun] = 0x81;
 	}
-	common->rdac_mode[1] = RDAC_MODE_TRANSFER_SPECIFIED_LUNS;
+	if (h->lun_state & RDAC_LUN_PREF)
+		/* Failback mode; swith this LUN only */
+		common->rdac_mode[1] = RDAC_MODE_TRANSFER_SPECIFIED_LUNS;
+	else
+		/* Failover mode; switch all LUNs */
+		common->rdac_mode[1] = RDAC_MODE_TRANSFER_ALL_VISIBLE_LUNS;
+
 	common->quiescence_timeout = RDAC_QUIESCENCE_TIME;
 	common->rdac_options = RDAC_FORCED_QUIESENCE;
 
@@ -326,6 +341,7 @@ static struct rdac_controller *get_controller(u8 *subsys_id, u8 *slot_id)
 	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
 	kref_init(&ctlr->kref);
 	ctlr->use_ms10 = -1;
+	ctlr->transfer_all_luns = 1;
 	list_add(&ctlr->node, &ctlr_list);
 done:
 	spin_unlock(&list_lock);
@@ -391,19 +407,24 @@ static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
 	err = submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry), h);
 	if (err == SCSI_DH_OK) {
 		inqp = &h->inq.c9;
+		if ((inqp->avte_cvp & 0x1) != 0) {
+			/* LUN was owned by the controller */
+			h->lun_state = RDAC_LUN_OWNED;
+		}
 		if ((inqp->avte_cvp >> 7) == 0x1) {
 			/* LUN in AVT mode */
 			sdev_printk(KERN_NOTICE, sdev,
 				    "%s: AVT mode detected\n",
 				    RDAC_NAME);
-			h->lun_state = RDAC_LUN_AVT;
-		} else if ((inqp->avte_cvp & 0x1) != 0) {
-			/* LUN was owned by the controller */
-			h->lun_state = RDAC_LUN_OWNED;
+			h->lun_state |= RDAC_LUN_AVT;
+		}
+		if ((inqp->path_prio && 0xf) == 0x1) {
+			/* LUN access through preferred path */
+			h->lun_state |= RDAC_LUN_PREF;
 		}
 	}
 
-	if (h->lun_state == RDAC_LUN_UNOWNED)
+	if ((h->lun_state & RDAC_LUN_OWNED) == 0)
 		h->state = RDAC_STATE_PASSIVE;
 
 	return err;
@@ -537,7 +558,8 @@ static int rdac_activate(struct scsi_device *sdev)
 		if (err != SCSI_DH_OK)
 			goto done;
 	}
-	if (h->lun_state == RDAC_LUN_UNOWNED)
+	if ((h->lun_state & RDAC_LUN_OWNED) == 0 &&
+	    (h->lun_state & RDAC_LUN_AVT) == 0 )
 		err = send_mode_select(sdev, h);
 done:
 	return err;

--------------010000030908070307030901
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010000030908070307030901--
