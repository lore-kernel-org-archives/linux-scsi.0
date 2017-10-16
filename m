From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] linux/types.h: Restore the ability to disable sparse
 endianness checks
Date: Mon, 16 Oct 2017 18:27:52 +0300
Message-ID: <20171016181159-mutt-send-email-mst@kernel.org>
References: <20171006172353.16758-1-bart.vanassche@wdc.com>
 <20171009162008-mutt-send-email-mst@kernel.org>
 <1507561661.2674.3.camel@wdc.com>
 <20171009204139-mutt-send-email-mst@kernel.org>
 <1507653494.2815.27.camel@wdc.com>
 <20171016160316-mutt-send-email-mst@kernel.org>
 <1508162253.2728.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508162253.2728.1.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 16, 2017 at 01:57:35PM +0000, Bart Van Assche wrote:
> On Mon, 2017-10-16 at 16:34 +0300, Michael S. Tsirkin wrote:
> > I don't see how it'll help make things better. OTOH if the specific
> > drivers are tagged in the makefile, they can be gradually moved out to
> > staging or something to help trigger action.
> 
> Do you really want to move drivers like qla2xxx to staging? That driver is
> important to multiple enterprise distro's.
> 
> Bart.

Frankly I'm surprised this one has sparse issues.
Really e.g. drivers/scsi/qla2xxx/qla_nvme.h is new from June 2017.

It's not some ancient piece of code that no one understands so
we are afraid to touch it.

So if you care, why don't you just fix it up?  I suspect it's a question
of just tagging structure fields properly.

Here's a patch fixing up one of the files in that driver.

--->

qla2xxx: make qla_nvme sparse clean

Without looking into what it actually does, just add annotations so
sparse does not complain. Separately, the handle field in cmd_nvme which
isn't tagged as LE should be examined for endian-ness by someone who
understands this hardware.  If it actually needs to be native endian, a
comment explaining why would be a good idea.

Similarly for cur_dsd which seems to mix LE and native data.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index f3710a7..05ab549 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -442,7 +442,7 @@ static int qla2x00_start_nvme_mq(srb_t *sp)
 				req->ring_ptr++;
 			}
 			cont_pkt = (cont_a64_entry_t *)req->ring_ptr;
-			*((uint32_t *)(&cont_pkt->entry_type)) =
+			*((__le32 *)(&cont_pkt->entry_type)) =
 			    cpu_to_le32(CONTINUE_A64_TYPE);
 
 			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
@@ -450,9 +450,9 @@ static int qla2x00_start_nvme_mq(srb_t *sp)
 		}
 
 		sle_dma = sg_dma_address(sg);
-		*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
-		*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
-		*cur_dsd++ = cpu_to_le32(sg_dma_len(sg));
+		*(__le32 __force *)cur_dsd++ = cpu_to_le32(LSD(sle_dma));
+		*(__le32 __force *)cur_dsd++ = cpu_to_le32(MSD(sle_dma));
+		*(__le32 __force *)cur_dsd++ = cpu_to_le32(sg_dma_len(sg));
 		avail_dsds--;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_nvme.h b/drivers/scsi/qla2xxx/qla_nvme.h
index dfe56f2..da58bd1 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.h
+++ b/drivers/scsi/qla2xxx/qla_nvme.h
@@ -39,32 +39,32 @@ struct cmd_nvme {
 	uint8_t entry_status;           /* Entry Status. */
 
 	uint32_t handle;                /* System handle. */
-	uint16_t nport_handle;          /* N_PORT handle. */
-	uint16_t timeout;               /* Command timeout. */
+	__le16 nport_handle;          /* N_PORT handle. */
+	__le16 timeout;               /* Command timeout. */
 
-	uint16_t dseg_count;            /* Data segment count. */
-	uint16_t nvme_rsp_dsd_len;      /* NVMe RSP DSD length */
+	__le16 dseg_count;            /* Data segment count. */
+	__le16 nvme_rsp_dsd_len;      /* NVMe RSP DSD length */
 
 	uint64_t rsvd;
 
-	uint16_t control_flags;         /* Control Flags */
+	__le16 control_flags;         /* Control Flags */
 #define CF_NVME_ENABLE                  BIT_9
 #define CF_DIF_SEG_DESCR_ENABLE         BIT_3
 #define CF_DATA_SEG_DESCR_ENABLE        BIT_2
 #define CF_READ_DATA                    BIT_1
 #define CF_WRITE_DATA                   BIT_0
 
-	uint16_t nvme_cmnd_dseg_len;             /* Data segment length. */
-	uint32_t nvme_cmnd_dseg_address[2];      /* Data segment address. */
-	uint32_t nvme_rsp_dseg_address[2];       /* Data segment address. */
+	__le16 nvme_cmnd_dseg_len;             /* Data segment length. */
+	__le32 nvme_cmnd_dseg_address[2];      /* Data segment address. */
+	__le32 nvme_rsp_dseg_address[2];       /* Data segment address. */
 
-	uint32_t byte_count;            /* Total byte count. */
+	__le32 byte_count;            /* Total byte count. */
 
 	uint8_t port_id[3];             /* PortID of destination port. */
 	uint8_t vp_index;
 
-	uint32_t nvme_data_dseg_address[2];      /* Data segment address. */
-	uint32_t nvme_data_dseg_len;             /* Data segment length. */
+	__le32 nvme_data_dseg_address[2];      /* Data segment address. */
+	__le32 nvme_data_dseg_len;             /* Data segment length. */
 };
 
 #define PT_LS4_REQUEST 0x89	/* Link Service pass-through IOCB (request) */
-- 
MST
