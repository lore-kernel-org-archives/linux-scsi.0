From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [PATCH] pm8001: raise host can queue (take 2)
Date: Wed, 25 Apr 2012 13:02:04 -0400
Message-ID: <E6F01B7B-808E-4EA9-9BC5-BEB7F2C8FA32@xyratex.com>
References: <CE155251DF87469DA8F1A8290EDCF361@usish.com.cn>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: multipart/mixed; boundary="Apple-Mail=_94424F98-F877-4C6E-89B5-2ADCA8854CBD"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex198.xyratex.com ([194.131.166.198]:60241 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756161Ab2DYRCK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Apr 2012 13:02:10 -0400
In-Reply-To: <CE155251DF87469DA8F1A8290EDCF361@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, James Bottomley <JBottomley@parallels.com>, lindar_liu <lindar_liu@usish.com>, =?utf-8?B?5LqO54ix5Y2O?= <crystal_yu@usish.com>, john_gong <john_gong@usish.com>, Jack Wang <jack_wang@usish.com>


--Apple-Mail=_94424F98-F877-4C6E-89B5-2ADCA8854CBD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

This is a followup to a patch provided by Jack Wang on September 21 =
2011.

After increasing the CAN_QUEUE to 510 in pm8001 we discovered some =
performance
degredation from time to time. We needed to increase the MPI queue to
compensate and ensure we never hit that limit. We also needed to double
the margin to support event and administrivial commands that take from
the pool resulting in an occasional largely unproductive command =
completion
with soft error to the caller when the command pool is overloaded =
temporarily.

Signed-off-by: Mark Salyzyn <mark_salyzyn@xyratex.com>

 drivers/scsi/pm8001/pm8001_defs.h |    3 ++-
 drivers/scsi/pm8001/pm8001_hwi.c  |   17 ++++++++++-------
 drivers/scsi/pm8001/pm8001_init.c |   10 +++++-----
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h =
b/drivers/scsi/pm8001/pm8001_defs.h
index 944afad..c3d20c8 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -66,9 +66,10 @@ enum port_type {
=20
 /* driver compile-time configuration */
 #define	PM8001_MAX_CCB		 512	/* max ccbs supported */
+#define PM8001_MPI_QUEUE         1024   /* maximum mpi queue entries */
 #define	PM8001_MAX_INB_NUM	 1
 #define	PM8001_MAX_OUTB_NUM	 1
-#define	PM8001_CAN_QUEUE	 128	/* SCSI Queue depth */
+#define	PM8001_CAN_QUEUE	 508	/* SCSI Queue depth */
=20
 /* unchangeable hardware details */
 #define	PM8001_MAX_PHYS		 8	/* max. possible phys */
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c =
b/drivers/scsi/pm8001/pm8001_hwi.c
index 8477df4..0d6c8b9 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -192,7 +192,7 @@ init_default_table_values(struct pm8001_hba_info =
*pm8001_ha)
 	pm8001_ha->main_cfg_tbl.fatal_err_interrupt		=3D =
0x01;
 	for (i =3D 0; i < qn; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=3D
-			0x00000100 | (0x00000040 << 16) | (0x00<<30);
+			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=3D
 			pm8001_ha->memoryMap.region[IB].phys_addr_hi;
 		pm8001_ha->inbnd_q_tbl[i].lower_base_addr	=3D
@@ -218,7 +218,7 @@ init_default_table_values(struct pm8001_hba_info =
*pm8001_ha)
 	}
 	for (i =3D 0; i < qn; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=3D
-			256 | (64 << 16) | (1<<30);
+			PM8001_MPI_QUEUE | (64 << 16) | (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=3D
 			pm8001_ha->memoryMap.region[OB].phys_addr_hi;
 		pm8001_ha->outbnd_q_tbl[i].lower_base_addr	=3D
@@ -1245,7 +1245,7 @@ static int mpi_msg_free_get(struct =
inbound_queue_table *circularQ,
 	/* Stores the new consumer index */
 	consumer_index =3D pm8001_read_32(circularQ->ci_virt);
 	circularQ->consumer_index =3D cpu_to_le32(consumer_index);
-	if (((circularQ->producer_idx + bcCount) % 256) =3D=3D
+	if (((circularQ->producer_idx + bcCount) % PM8001_MPI_QUEUE) =3D=3D=

 		le32_to_cpu(circularQ->consumer_index)) {
 		*messagePtr =3D NULL;
 		return -1;
@@ -1253,7 +1253,8 @@ static int mpi_msg_free_get(struct =
inbound_queue_table *circularQ,
 	/* get memory IOMB buffer address */
 	offset =3D circularQ->producer_idx * 64;
 	/* increment to next bcCount element */
-	circularQ->producer_idx =3D (circularQ->producer_idx + bcCount) =
% 256;
+	circularQ->producer_idx =3D (circularQ->producer_idx + bcCount)
+				% PM8001_MPI_QUEUE;
 	/* Adds that distance to the base of the region virtual address =
plus
 	the message header size*/
 	msgHeader =3D (struct mpi_msg_hdr *)(circularQ->base_virt	=
+ offset);
@@ -1326,7 +1327,8 @@ static u32 mpi_msg_free_set(struct pm8001_hba_info =
*pm8001_ha, void *pMsg,
 		return 0;
 	}
 	/* free the circular queue buffer elements associated with the =
message*/
-	circularQ->consumer_idx =3D (circularQ->consumer_idx + bc) % =
256;
+	circularQ->consumer_idx =3D (circularQ->consumer_idx + bc)
+				% PM8001_MPI_QUEUE;
 	/* update the CI of outbound queue */
 	pm8001_cw32(pm8001_ha, circularQ->ci_pci_bar, =
circularQ->ci_offset,
 		circularQ->consumer_idx);
@@ -1383,7 +1385,8 @@ static u32 mpi_msg_consume(struct pm8001_hba_info =
*pm8001_ha,
 					circularQ->consumer_idx =3D
 						(circularQ->consumer_idx =
+
 						=
((le32_to_cpu(msgHeader_tmp)
-						>> 24) & 0x1f)) % 256;
+						 >> 24) & 0x1f))
+							% =
PM8001_MPI_QUEUE;
 					msgHeader_tmp =3D 0;
 					pm8001_write_32(msgHeader, 0, =
0);
 					/* update the CI of outbound =
queue */
@@ -1396,7 +1399,7 @@ static u32 mpi_msg_consume(struct pm8001_hba_info =
*pm8001_ha,
 				circularQ->consumer_idx =3D
 					(circularQ->consumer_idx +
 					((le32_to_cpu(msgHeader_tmp) >> =
24) &
-					0x1f)) % 256;
+					0x1f)) % PM8001_MPI_QUEUE;
 				msgHeader_tmp =3D 0;
 				pm8001_write_32(msgHeader, 0, 0);
 				/* update the CI of outbound queue */
diff --git a/drivers/scsi/pm8001/pm8001_init.c =
b/drivers/scsi/pm8001/pm8001_init.c
index 36efaa7..0267c22 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -235,15 +235,15 @@ static int __devinit pm8001_alloc(struct =
pm8001_hba_info *pm8001_ha)
 	pm8001_ha->memoryMap.region[PI].alignment =3D 4;
=20
 	/* MPI Memory region 5 inbound queues */
-	pm8001_ha->memoryMap.region[IB].num_elements =3D 256;
+	pm8001_ha->memoryMap.region[IB].num_elements =3D =
PM8001_MPI_QUEUE;
 	pm8001_ha->memoryMap.region[IB].element_size =3D 64;
-	pm8001_ha->memoryMap.region[IB].total_len =3D 256 * 64;
+	pm8001_ha->memoryMap.region[IB].total_len =3D PM8001_MPI_QUEUE * =
64;
 	pm8001_ha->memoryMap.region[IB].alignment =3D 64;
=20
-	/* MPI Memory region 6 inbound queues */
-	pm8001_ha->memoryMap.region[OB].num_elements =3D 256;
+	/* MPI Memory region 6 outbound queues */
+	pm8001_ha->memoryMap.region[OB].num_elements =3D =
PM8001_MPI_QUEUE;
 	pm8001_ha->memoryMap.region[OB].element_size =3D 64;
-	pm8001_ha->memoryMap.region[OB].total_len =3D 256 * 64;
+	pm8001_ha->memoryMap.region[OB].total_len =3D PM8001_MPI_QUEUE * =
64;
 	pm8001_ha->memoryMap.region[OB].alignment =3D 64;
=20
 	/* Memory region write DMA*/



--Apple-Mail=_94424F98-F877-4C6E-89B5-2ADCA8854CBD
Content-Disposition: attachment;
	filename=mpi-queue-2.patch
Content-Type: application/octet-stream;
	name="mpi-queue-2.patch"
Content-Transfer-Encoding: 7bit

Subject: [PATCH] pm8001: rais host can queue (take 2)

After increasing the CAN_QUEUE to 510 in pm8001 we discovered some performance
degredation from time to time. We needed to increase the MPI queue to
compensate and ensure we never hit that limit. We also needed to double
the margin to support event and administrivial commands that take from
the pool resulting in an occasional largely unproductive command completion
with soft error to the caller when the command pool is overloaded temporarily.

Signed-off-by: Mark Salyzyn <mark_salyzyn@xyratex.com>

 drivers/scsi/pm8001/pm8001_defs.h |    3 ++-
 drivers/scsi/pm8001/pm8001_hwi.c  |   17 ++++++++++-------
 drivers/scsi/pm8001/pm8001_init.c |   10 +++++-----
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index 944afad..c3d20c8 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -66,9 +66,10 @@ enum port_type {
 
 /* driver compile-time configuration */
 #define	PM8001_MAX_CCB		 512	/* max ccbs supported */
+#define PM8001_MPI_QUEUE         1024   /* maximum mpi queue entries */
 #define	PM8001_MAX_INB_NUM	 1
 #define	PM8001_MAX_OUTB_NUM	 1
-#define	PM8001_CAN_QUEUE	 128	/* SCSI Queue depth */
+#define	PM8001_CAN_QUEUE	 508	/* SCSI Queue depth */
 
 /* unchangeable hardware details */
 #define	PM8001_MAX_PHYS		 8	/* max. possible phys */
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 8477df4..0d6c8b9 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -192,7 +192,7 @@ init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.fatal_err_interrupt		= 0x01;
 	for (i = 0; i < qn; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
-			0x00000100 | (0x00000040 << 16) | (0x00<<30);
+			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[IB].phys_addr_hi;
 		pm8001_ha->inbnd_q_tbl[i].lower_base_addr	=
@@ -218,7 +218,7 @@ init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 	}
 	for (i = 0; i < qn; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
-			256 | (64 << 16) | (1<<30);
+			PM8001_MPI_QUEUE | (64 << 16) | (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[OB].phys_addr_hi;
 		pm8001_ha->outbnd_q_tbl[i].lower_base_addr	=
@@ -1245,7 +1245,7 @@ static int mpi_msg_free_get(struct inbound_queue_table *circularQ,
 	/* Stores the new consumer index */
 	consumer_index = pm8001_read_32(circularQ->ci_virt);
 	circularQ->consumer_index = cpu_to_le32(consumer_index);
-	if (((circularQ->producer_idx + bcCount) % 256) ==
+	if (((circularQ->producer_idx + bcCount) % PM8001_MPI_QUEUE) ==
 		le32_to_cpu(circularQ->consumer_index)) {
 		*messagePtr = NULL;
 		return -1;
@@ -1253,7 +1253,8 @@ static int mpi_msg_free_get(struct inbound_queue_table *circularQ,
 	/* get memory IOMB buffer address */
 	offset = circularQ->producer_idx * 64;
 	/* increment to next bcCount element */
-	circularQ->producer_idx = (circularQ->producer_idx + bcCount) % 256;
+	circularQ->producer_idx = (circularQ->producer_idx + bcCount)
+				% PM8001_MPI_QUEUE;
 	/* Adds that distance to the base of the region virtual address plus
 	the message header size*/
 	msgHeader = (struct mpi_msg_hdr *)(circularQ->base_virt	+ offset);
@@ -1326,7 +1327,8 @@ static u32 mpi_msg_free_set(struct pm8001_hba_info *pm8001_ha, void *pMsg,
 		return 0;
 	}
 	/* free the circular queue buffer elements associated with the message*/
-	circularQ->consumer_idx = (circularQ->consumer_idx + bc) % 256;
+	circularQ->consumer_idx = (circularQ->consumer_idx + bc)
+				% PM8001_MPI_QUEUE;
 	/* update the CI of outbound queue */
 	pm8001_cw32(pm8001_ha, circularQ->ci_pci_bar, circularQ->ci_offset,
 		circularQ->consumer_idx);
@@ -1383,7 +1385,8 @@ static u32 mpi_msg_consume(struct pm8001_hba_info *pm8001_ha,
 					circularQ->consumer_idx =
 						(circularQ->consumer_idx +
 						((le32_to_cpu(msgHeader_tmp)
-						>> 24) & 0x1f)) % 256;
+						 >> 24) & 0x1f))
+							% PM8001_MPI_QUEUE;
 					msgHeader_tmp = 0;
 					pm8001_write_32(msgHeader, 0, 0);
 					/* update the CI of outbound queue */
@@ -1396,7 +1399,7 @@ static u32 mpi_msg_consume(struct pm8001_hba_info *pm8001_ha,
 				circularQ->consumer_idx =
 					(circularQ->consumer_idx +
 					((le32_to_cpu(msgHeader_tmp) >> 24) &
-					0x1f)) % 256;
+					0x1f)) % PM8001_MPI_QUEUE;
 				msgHeader_tmp = 0;
 				pm8001_write_32(msgHeader, 0, 0);
 				/* update the CI of outbound queue */
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 36efaa7..0267c22 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -235,15 +235,15 @@ static int __devinit pm8001_alloc(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->memoryMap.region[PI].alignment = 4;
 
 	/* MPI Memory region 5 inbound queues */
-	pm8001_ha->memoryMap.region[IB].num_elements = 256;
+	pm8001_ha->memoryMap.region[IB].num_elements = PM8001_MPI_QUEUE;
 	pm8001_ha->memoryMap.region[IB].element_size = 64;
-	pm8001_ha->memoryMap.region[IB].total_len = 256 * 64;
+	pm8001_ha->memoryMap.region[IB].total_len = PM8001_MPI_QUEUE * 64;
 	pm8001_ha->memoryMap.region[IB].alignment = 64;
 
-	/* MPI Memory region 6 inbound queues */
-	pm8001_ha->memoryMap.region[OB].num_elements = 256;
+	/* MPI Memory region 6 outbound queues */
+	pm8001_ha->memoryMap.region[OB].num_elements = PM8001_MPI_QUEUE;
 	pm8001_ha->memoryMap.region[OB].element_size = 64;
-	pm8001_ha->memoryMap.region[OB].total_len = 256 * 64;
+	pm8001_ha->memoryMap.region[OB].total_len = PM8001_MPI_QUEUE * 64;
 	pm8001_ha->memoryMap.region[OB].alignment = 64;
 
 	/* Memory region write DMA*/

--Apple-Mail=_94424F98-F877-4C6E-89B5-2ADCA8854CBD--
