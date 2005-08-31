From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/3] Generalize WWN to u64 interger conversions.
Date: Wed, 31 Aug 2005 15:18:35 -0700
Message-ID: <20050831221835.GI11577@plap.qlogic.org>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com> <20050827020950.27275.51550.sendpatchset@plap.qlogic.com> <20050827104053.GA21026@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:9161 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S964945AbVHaWSk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 18:18:40 -0400
Content-Disposition: inline
In-Reply-To: <20050827104053.GA21026@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, "Smart, James" <James.Smart@emulex.com>

> > --- a/drivers/scsi/qla2xxx/qla_attr.c
> > +++ b/drivers/scsi/qla2xxx/qla_attr.c
> > @@ -345,6 +345,15 @@ struct class_device_attribute *qla2x00_h
> >  
> >  /* Host attributes. */
> >  
> > +static u64
> > +wwn_to_u64(uint8_t *wwn)
> > +{
> > +	return (u64)wwn[0] << 56 | (u64)wwn[1] << 48 |
> > +	    (u64)wwn[2] << 40 | (u64)wwn[3] << 32 |
> > +	    (u64)wwn[4] << 24 | (u64)wwn[5] << 16 |
> > +	    (u64)wwn[6] <<  8 | (u64)wwn[7];
> > +}
> 
> Shouldn't this go into the transport class?  Could probably be an inline
> aswell.

Ok, how about this generic patchset:

1) add helper function to transport class
2) add support to qla2xxx
3) add support to lpfc -- I'll let James S. decide on
   whether the union {} changes to lpfc_name are acceptable

---

Generalize WWN to u64 interger conversions.

On some platforms the hard-casting of 8 byte node_name and
port_name arrays to an u64 would cause unaligned-access
warnings.  Generalize the conversions with a transport
helper function which performs consistent shifting of WWN
bytes.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -439,4 +439,12 @@ int fc_remote_port_block(struct fc_rport
 void fc_remote_port_unblock(struct fc_rport *rport);
 int scsi_is_fc_rport(const struct device *);
 
+static inline u64 wwn_to_u64(u8 *wwn)
+{
+	return (u64)wwn[0] << 56 | (u64)wwn[1] << 48 |
+	    (u64)wwn[2] << 40 | (u64)wwn[3] << 32 |
+	    (u64)wwn[4] << 24 | (u64)wwn[5] << 16 |
+	    (u64)wwn[6] <<  8 | (u64)wwn[7];
+}
+
 #endif /* SCSI_TRANSPORT_FC_H */
