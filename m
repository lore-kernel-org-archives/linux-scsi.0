From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 10 Jun 2014 15:02:56 -0400
Message-ID: <yq1fvjcvb8f.fsf@sermon.lab.mkp.net>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com>
	<1402223228-23768-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402223228-23768-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> (Sagi
	Grimberg's message of "Sun, 8 Jun 2014 13:27:06 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> writes:

+static inline unsigned scsi_prot_length(unsigned data_length,
+					unsigned sector_size)
+{
+	switch (sector_size) {
+	case 512:
+		return (data_length >> 9) * 8;
+	case 1024:
+		return (data_length >> 10) * 8;
+	case 2048:
+		return (data_length >> 11) * 8;
+	case 4096:
+		return (data_length >> 12) * 8;
+	default:
+		return (data_length >> ilog2(sector_size)) * 8;
+	}
+}
+
+static inline unsigned scsi_transfer_length(struct scsi_cmnd *cmd)
+{
+	unsigned data_length;
+
+	if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		data_length = scsi_in(cmd)->length;
+		if (scsi_get_prot_op(cmd) ==  SCSI_PROT_NORMAL ||
+		    scsi_get_prot_op(cmd) ==  SCSI_PROT_READ_INSERT)
+			return data_length;
+	} else {
+		data_length = scsi_out(cmd)->length;
+		if (scsi_get_prot_op(cmd) ==  SCSI_PROT_NORMAL ||
+		    scsi_get_prot_op(cmd) ==  SCSI_PROT_WRITE_STRIP)
+			return data_length;
+	}
+
+	/* Protection information exists on the wire */
+	return data_length + scsi_prot_length(data_length,
+					      cmd->device->sector_size);
+}

Let's do this for 3.16:

static inline unsigned int scsi_transfer_length(struct scsi_cmnd *scmd)
{
        unsigned int xfer_len = blk_rq_bytes(scmd->request);
        unsigned int prot_op = scsi_get_prot_op(scmd);

        switch (prot_op) {
        case SCSI_PROT_NORMAL:
        case SCSI_PROT_WRITE_STRIP:
        case SCSI_PROT_READ_INSERT:
             return xfer_len;
        }

        return xfer_len + (xfer_len >> ilog2(sector_size)) * 8;
}

And then in 3.17 we'll have:

static inline unsigned int scsi_transfer_length(struct scsi_cmnd *scmd)
{
        unsigned int xfer_len = blk_rq_bytes(scmd->request);
 
        if (scsi_prot_flagged(SCSI_PROT_TRANSFER_PI))
           xfer_len += (xfer_len >> ilog2(scsi_prot_interval(scmd))) * 8;

        return xfer_len;
}

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
