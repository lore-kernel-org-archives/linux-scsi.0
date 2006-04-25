From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sas transport sysfs write attributes bug fix
Date: Tue, 25 Apr 2006 18:57:27 -0500
Message-ID: <1146009448.3529.65.camel@mulgrave.il.steeleye.com>
References: <20060425233528.GA9238@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:5096 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932211AbWDYX5b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Apr 2006 19:57:31 -0400
In-Reply-To: <20060425233528.GA9238@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-04-25 at 17:35 -0600, Eric Moore wrote:
> The SAS Transport Layers SySFS write attributes were recently broke when
> SETUP_OPTIONAL_PORT_ATTRIBUTE_WRONLY was added.  This fix's the following
> write attributes:
> 
> 	/sys/class/sas_phy/phy-0:0/hard_reset
> 	/sys/class/sas_phy/phy-0:0/link_reset
> 
> Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

Heh, that's a bit of a screw up in the templates (cut and paste error, I
think), but isn't this the simpler fix?

James

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 8b6d65e..40bef6c 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -974,10 +974,9 @@ static int sas_user_scan(struct Scsi_Hos
  * Setup / Teardown code
  */
 
-#define SETUP_TEMPLATE(attrb, field, perm, test)				\
+#define SETUP_TEMPLATE(attrb, field, perm, test)			\
 	i->private_##attrb[count] = class_device_attr_##field;		\
 	i->private_##attrb[count].attr.mode = perm;			\
-	i->private_##attrb[count].store = NULL;				\
 	i->attrb[count] = &i->private_##attrb[count];			\
 	if (test)							\
 		count++


> 
> diff -uarN b/drivers/scsi/scsi_transport_sas.c a/drivers/scsi/scsi_transport_sas.c
> --- b/drivers/scsi/scsi_transport_sas.c	2006-04-20 17:23:04.000000000 -0600
> +++ a/drivers/scsi/scsi_transport_sas.c	2006-04-25 17:13:21.000000000 -0600
> @@ -982,6 +982,13 @@
>  	if (test)							\
>  		count++
>  
> +#define SETUP_TEMPLATE_WRONLY(attrb, field, perm, test)				\
> +	i->private_##attrb[count] = class_device_attr_##field;		\
> +	i->private_##attrb[count].attr.mode = perm;			\
> +	i->private_##attrb[count].show = NULL;				\
> +	i->attrb[count] = &i->private_##attrb[count];			\
> +	if (test)							\
> +		count++
>  
>  #define SETUP_RPORT_ATTRIBUTE(field) 					\
>  	SETUP_TEMPLATE(rphy_attrs, field, S_IRUGO, 1)
> @@ -996,10 +1003,10 @@
>  	SETUP_TEMPLATE(phy_attrs, field, S_IRUGO, i->f->func)
>  
>  #define SETUP_PORT_ATTRIBUTE_WRONLY(field)				\
> -	SETUP_TEMPLATE(phy_attrs, field, S_IWUGO, 1)
> +	SETUP_TEMPLATE_WRONLY(phy_attrs, field, S_IWUGO, 1)
>  
>  #define SETUP_OPTIONAL_PORT_ATTRIBUTE_WRONLY(field, func)		\
> -	SETUP_TEMPLATE(phy_attrs, field, S_IWUGO, i->f->func)
> +	SETUP_TEMPLATE_WRONLY(phy_attrs, field, S_IWUGO, i->f->func)
>  
>  #define SETUP_END_DEV_ATTRIBUTE(field)					\
>  	SETUP_TEMPLATE(end_dev_attrs, field, S_IRUGO, 1)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

