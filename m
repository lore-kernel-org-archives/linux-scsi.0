From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [PATCH 03/10] SCSI: fcoe: convert to use BUS_ATTR_WO
Date: Fri, 21 Dec 2018 07:29:45 -0800
Message-ID: <1545406185.2765.8.camel@linux.ibm.com>
References: <20181221075442.17109-1-gregkh@linuxfoundation.org>
         <20181221075442.17109-4-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181221075442.17109-4-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Cc: Johannes Thumshirn <jth@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[scsi list cc added]
On Fri, 2018-12-21 at 08:54 +0100, Greg Kroah-Hartman wrote:
> We are trying to get rid of BUS_ATTR() and the usage of that in the
> fcoe driver can be trivially converted to use BUS_ATTR_WO(), so use
> that instead.
> 
> At the same time remove a unneeded EXPORT_SYMBOL() marking for the
> sysfs callback function we are renaming, no idea of how that got into
> the tree...

The EXPORT_SYMBOL removal is fine, but

[...]
> --- a/include/scsi/libfcoe.h
> +++ b/include/scsi/libfcoe.h
> @@ -405,10 +405,8 @@ int fcoe_transport_attach(struct fcoe_transport
> *ft);
>  int fcoe_transport_detach(struct fcoe_transport *ft);
> 
>  /* sysfs store handler for ctrl_control interface */
> -ssize_t fcoe_ctlr_create_store(struct bus_type *bus,
> -			       const char *buf, size_t count);
> -ssize_t fcoe_ctlr_destroy_store(struct bus_type *bus,
> -				const char *buf, size_t count);
> +ssize_t ctlr_create_store(struct bus_type *bus, const char *buf,
> size_t count);
> +ssize_t ctlr_destroy_store(struct bus_type *bus, const char *buf,
> size_t count);

You're really damaging our prefix namespace here.  It looks like the
ctlr_ name is a farly recent addition for sysfs (only myra/b) use it in
SCSI but it's inviting symbol clashes.

Since the XXX_ATTR_RO seem to be defined with only local file usage in
mind, I think we need static functions to shim the problem, like below
(provided this is the only instance, because if it isn't, you probably
need a XXX_ATTR_WO_prefix() macro)

James

---

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 5c8310bade61..88e5c26ce381 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -671,8 +671,20 @@ static const struct device_type fcoe_fcf_device_type = {
 	.release = fcoe_fcf_device_release,
 };
 
-static BUS_ATTR(ctlr_create, S_IWUSR, NULL, fcoe_ctlr_create_store);
-static BUS_ATTR(ctlr_destroy, S_IWUSR, NULL, fcoe_ctlr_destroy_store);
+static ssize_t ctlr_create_store(struct bus_type *bus, const char *buf,
+				 size_t count)
+{
+	return fcoe_ctlr_create_store(bus, buf, count);
+}
+
+static ssize_t ctlr_destroy_store(struct bus_type *bus, const char *buf,
+				  size_t count)
+{
+	return fcoe_ctlr_destroy_store(bus, buf, count);
+}
+
+static BUS_ATTR_WO(ctlr_create);
+static BUS_ATTR_WO(ctlr_destroy);
 
 static struct attribute *fcoe_bus_attrs[] = {
 	&bus_attr_ctlr_create.attr,
