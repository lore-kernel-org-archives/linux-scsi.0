From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 9/10] mpt2sas: Enable TLR for SSP TAPE drives (Added
 SAS Transport APIs)
Date: Mon, 18 Jan 2010 10:14:51 -0600
Message-ID: <1263831291.2773.54.camel@mulgrave.site>
References: <20091216132620.GJ31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab0ARQPA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2010 11:15:00 -0500
In-Reply-To: <20091216132620.GJ31161@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Wed, 2009-12-16 at 18:56 +0530, Kashyap, Desai wrote:
> Added tlr_enabled bit in sas_device structure, which will have boolean
> value 0 for disabled and 1 for enabled.
> 
> As suggested by James B, I have added sas_tlr_supported(),sas_enable_tlr(),
> sas_disable_tlr() functions at SAS transport layer so that any other
> Low layer driver can use those APIs.
> 
> SAS transport API sas_tlr_supported() will send vpd page 0x90,
> to check the TLR support. If TLR is supported for end device, MPT2SAS driver
> will enable the TLR bit in the SCSI_IO for every request. If there is a
> response with MPI2_SCSITASKMGMT_RSP_INVALID_FRAME, the driver will turn off
> the TLR logic.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@xxxxxxx>
> Reviewed-by: Eric Moore <Eric.moore@xxxxxxx>

What's with the xxxx?  I've got better things to do than fix up
changelog signoffs.

> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index fd47cb1..41b8eab 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -358,6 +358,61 @@ void sas_remove_host(struct Scsi_Host *shost)
>  }
>  EXPORT_SYMBOL(sas_remove_host);
>  
> +/**
> + * sas_tlr_supported - checking TLR bit in vpd 0x90
> + * @sdev: scsi device struct
> + *
> + * Check Transport Layer Retries are supported or not.
> + * If vpd page 0x90 is present, TRL is supported.
> + *
> + */
> +unsigned int
> +sas_tlr_supported(struct scsi_device *sdev)
> +{
> +	char *buffer;
> +
> +	buffer = scsi_get_vpd_page(sdev, 0x90);
> +	if (buffer == NULL)
> +		return 0;
> +
> +	kfree(buffer);
> +	return 1;

This can't be right.  TLR supported is the lowest bit of the 8th byte of
the port entry ... you can't condition this on whether the protocol page
exists or not.

> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 68d185c..7c1361b 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -112,6 +112,7 @@ struct scsi_device {
>  				 * scsi_devinfo.[hc]. For now used only to
>  				 * pass settings from slave_alloc to scsi
>  				 * core. */
> +	unsigned tlr_enabled:1;	/* set tlr flags */

And this is wrong:  the tlr is SAS specific, it belongs in the end
device flags like all the other SAS specific entries.

We also need to expose it to the user in case they want to change the
flag.

How about separating the two patches and doing this for the transport
class?  If it looks OK, I'll add it to the patch sequence and alter this
commit.

James

---
diff --git a/drivers/scsi/scsi_sas_internal.h b/drivers/scsi/scsi_sas_internal.h
index 998cb5b..6266a5d 100644
--- a/drivers/scsi/scsi_sas_internal.h
+++ b/drivers/scsi/scsi_sas_internal.h
@@ -5,7 +5,7 @@
 #define SAS_PHY_ATTRS		17
 #define SAS_PORT_ATTRS		1
 #define SAS_RPORT_ATTRS		7
-#define SAS_END_DEV_ATTRS	3
+#define SAS_END_DEV_ATTRS	5
 #define SAS_EXPANDER_ATTRS	7
 
 struct sas_internal {
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index f27e52d..8b30675 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -155,6 +155,17 @@ static struct {
 sas_bitfield_name_search(linkspeed, sas_linkspeed_names)
 sas_bitfield_name_set(linkspeed, sas_linkspeed_names)
 
+static struct sas_end_device *sas_sdev_to_rdev(struct scsi_device *sdev)
+{
+	struct sas_rphy *rphy = target_to_rphy(sdev->sdev_target);
+	struct sas_end_device *rdev;
+
+	BUG_ON(rphy->identify.device_type != SAS_END_DEVICE);
+
+	rdev = rphy_to_end_device(rphy);
+	return rdev;
+}
+
 static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
 			    struct sas_rphy *rphy)
 {
@@ -358,6 +369,78 @@ void sas_remove_host(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(sas_remove_host);
 
+/**
+ * sas_tlr_supported - checking TLR bit in vpd 0x90
+ * @sdev: scsi device struct
+ *
+ * Check Transport Layer Retries are supported or not.
+ * If vpd page 0x90 is present, TRL is supported.
+ *
+ */
+unsigned int
+sas_tlr_supported(struct scsi_device *sdev)
+{
+	const int vpd_len = 32;
+	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
+	char *buffer = kzalloc(vpd_len, GFP_KERNEL);
+	int ret = 0;
+
+	if (scsi_get_vpd_page(sdev, 0x90, buffer, vpd_len))
+		goto out;
+
+	/*
+	 * Magic numbers: the VPD Protocol page (0x90)
+	 * has a 4 byte header and then one entry per device port
+	 * the TLR bit is at offset 8 on each port entry
+	 * if we take the first port, that's at total offset 12
+	 */
+	ret = buffer[12] & 0x01;
+
+ out:
+	kfree(buffer);
+	rdev->tlr_supported = ret;
+	return ret;
+
+}
+EXPORT_SYMBOL(sas_tlr_supported);
+
+/**
+ * sas_disable_tlr - setting TLR flags
+ * @sdev: scsi device struct
+ *
+ * Seting tlr_enabled flag to 0.
+ *
+ */
+void
+sas_disable_tlr(struct scsi_device *sdev)
+{
+	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
+
+	rdev->tlr_enabled = 0;
+}
+EXPORT_SYMBOL(sas_disable_tlr);
+
+/**
+ * sas_enable_tlr - setting TLR flags
+ * @sdev: scsi device struct
+ *
+ * Seting tlr_enabled flag 1.
+ *
+ */
+void sas_enable_tlr(struct scsi_device *sdev)
+{
+	unsigned int tlr_supported = 0;
+	tlr_supported  = sas_tlr_supported(sdev);
+
+	if (tlr_supported) {
+		struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
+
+		rdev->tlr_enabled = 1;
+	}
+
+	return;
+}
+EXPORT_SYMBOL(sas_enable_tlr);
 
 /*
  * SAS Phy attributes
@@ -1146,15 +1229,10 @@ sas_rphy_simple_attr(identify.phy_identifier, phy_identifier, "%d\n", u8);
 int sas_read_port_mode_page(struct scsi_device *sdev)
 {
 	char *buffer = kzalloc(BUF_SIZE, GFP_KERNEL), *msdata;
-	struct sas_rphy *rphy = target_to_rphy(sdev->sdev_target);
-	struct sas_end_device *rdev;
+	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
 	struct scsi_mode_data mode_data;
 	int res, error;
 
-	BUG_ON(rphy->identify.device_type != SAS_END_DEVICE);
-
-	rdev = rphy_to_end_device(rphy);
-
 	if (!buffer)
 		return -ENOMEM;
 
@@ -1207,6 +1285,10 @@ sas_end_dev_simple_attr(I_T_nexus_loss_timeout, I_T_nexus_loss_timeout,
 			"%d\n", int);
 sas_end_dev_simple_attr(initiator_response_timeout, initiator_response_timeout,
 			"%d\n", int);
+sas_end_dev_simple_attr(tlr_supported, tlr_supported,
+			"%d\n", int);
+sas_end_dev_simple_attr(tlr_enabled, tlr_enabled,
+			"%d\n", int);
 
 static DECLARE_TRANSPORT_CLASS(sas_expander_class,
 			       "sas_expander", NULL, NULL, NULL);
@@ -1733,6 +1815,8 @@ sas_attach_transport(struct sas_function_template *ft)
 	SETUP_END_DEV_ATTRIBUTE(end_dev_ready_led_meaning);
 	SETUP_END_DEV_ATTRIBUTE(end_dev_I_T_nexus_loss_timeout);
 	SETUP_END_DEV_ATTRIBUTE(end_dev_initiator_response_timeout);
+	SETUP_END_DEV_ATTRIBUTE(end_dev_tlr_supported);
+	SETUP_END_DEV_ATTRIBUTE(end_dev_tlr_enabled);
 	i->end_dev_attrs[count] = NULL;
 
 	count = 0;
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 61ad359..2988fcf 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -107,6 +107,8 @@ struct sas_end_device {
 	struct sas_rphy		rphy;
 	/* flags */
 	unsigned		ready_led_meaning:1;
+	unsigned		tlr_supported:1;
+	unsigned		tlr_enabled:1;
 	/* parameters */
 	u16			I_T_nexus_loss_timeout;
 	u16			initiator_response_timeout;
@@ -181,6 +183,10 @@ extern int sas_phy_add(struct sas_phy *);
 extern void sas_phy_delete(struct sas_phy *);
 extern int scsi_is_sas_phy(const struct device *);
 
+unsigned int sas_tlr_supported(struct scsi_device *);
+void sas_disable_tlr(struct scsi_device *);
+void sas_enable_tlr(struct scsi_device *);
+
 extern struct sas_rphy *sas_end_device_alloc(struct sas_port *);
 extern struct sas_rphy *sas_expander_alloc(struct sas_port *, enum sas_device_type);
 void sas_rphy_free(struct sas_rphy *);


