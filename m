From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on
 Hyper-V
Date: Wed, 30 Mar 2016 06:39:27 +0000
Message-ID: <CY1PR03MB2137B1A20DCF41CFF13B2FECA0980@CY1PR03MB2137.namprd03.prod.outlook.com>
References: <1457819568-6586-1-git-send-email-kys@microsoft.com>
 <20160315134009.GA3595@infradead.org>
 <SN2PR03MB21423A42522A21C145896431A0890@SN2PR03MB2142.namprd03.prod.outlook.com>
 <yq1twk7e8nl.fsf@sermon.lab.mkp.net>
 <SN2PR03MB21425F84DAC997491DD4C2ACA0890@SN2PR03MB2142.namprd03.prod.outlook.com>
 <yq14mc6dpbu.fsf@sermon.lab.mkp.net>
 <1458169666.4793.62.camel@HansenPartnership.com>
 <SN2PR03MB2142B8D8C2B1831522F6EB1AA08A0@SN2PR03MB2142.namprd03.prod.outlook.com>
 <1458171653.4793.68.camel@HansenPartnership.com>
 <SN2PR03MB2142C30620CAC6F633AAFB52A08B0@SN2PR03MB2142.namprd03.prod.outlook.com>
 <1458340866.2892.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1458340866.2892.7.camel@HansenPartnership.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Friday, March 18, 2016 3:41 PM
> To: KY Srinivasan <kys@microsoft.com>; Martin K. Petersen
> <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@infradead.org>; gregkh@linuxfoundation.org;
> linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> hare@suse.de
> Subject: Re: [PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on
> Hyper-V
> 
> On Thu, 2016-03-17 at 00:01 +0000, KY Srinivasan wrote:
> > The only attributes I would be interested are:
> > 1) node name
> > 2) port name
> >
> > Ideally, if this can show under /sys/class/fc_host/hostx/port_name
> > and node_name,
> > it will be ideal since all user scripts can work.
> 
> OK, like this?
> 
> From 7af7c428e7e04ddcc87fda12d6571e3dff8ae024 Mon Sep 17 00:00:00
> 2001
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Fri, 18 Mar 2016 15:35:45 -0700
> Subject: scsi_transport_fc: introduce lightweight class for virtualization
>  systems
> 
> The FC transport class is very heavily tilted towards helping things
> which operate a fabric (as it should be).  However, there seems to be
> a need for a lightweight version for use in virtual systems that
> simply want to show pass through FC information without making any use
> of the heavyweight functions.  This is an attempt to give them what
> they want: the lightweight class has no vports or rports and only two
> host attributes.  Essentially, it's designed for the HV storvsc
> driver, but if other virtualizataion systems have similar problems, we
> can add more attributes.
> 
> Signed-off-by: James Bottomley <jejb@linux.vnet.ibm.com>
> ---
>  drivers/scsi/scsi_transport_fc.c | 94
> ++++++++++++++++++++++++++++++++++++++++
>  include/scsi/scsi_transport_fc.h |  3 ++
>  2 files changed, 97 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 8a88226..a9fcb4d 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -351,6 +351,27 @@ struct fc_internal {
> 
>  #define to_fc_internal(tmpl)	container_of(tmpl, struct fc_internal, t)
> 
> +#define FC_LW_HOST_NUM_ATTRS 	2
> +struct fc_lw_internal {
> +	struct scsi_transport_template t;
> +	struct fc_function_template *f;
> +
> +	/*
> +	 * For attributes : each object has :
> +	 *   An array of the actual attributes structures
> +	 *   An array of null-terminated pointers to the attribute
> +	 *     structures - used for mid-layer interaction.
> +	 *
> +	 * The attribute containers for the starget and host are are
> +	 * part of the midlayer. As the remote port is specific to the
> +	 * fc transport, we must provide the attribute container.
> +	 */
> +	struct device_attribute
> private_host_attrs[FC_LW_HOST_NUM_ATTRS];
> +	struct device_attribute *host_attrs[FC_LW_HOST_NUM_ATTRS + 1];
> +};
> +
> +#define to_fc_lw_internal(tmpl)	container_of(tmpl, struct
> fc_lw_internal, t)
> +
>  static int fc_target_setup(struct transport_container *tc, struct device *dev,
>  			   struct device *cdev)
>  {
> @@ -472,6 +493,12 @@ static int fc_host_remove(struct transport_container
> *tc, struct device *dev,
>  	return 0;
>  }
> 
> +static DECLARE_TRANSPORT_CLASS(fc_lw_host_class,
> +			       "fc_host",
> +			       NULL,
> +			       NULL,
> +			       NULL);
> +
>  static DECLARE_TRANSPORT_CLASS(fc_host_class,
>  			       "fc_host",
>  			       fc_host_setup,
> @@ -1968,6 +1995,25 @@ static int fc_host_match(struct
> attribute_container *cont,
>  	return &i->t.host_attrs.ac == cont;
>  }
> 
> +static int fc_lw_host_match(struct attribute_container *cont,
> +			  struct device *dev)
> +{
> +	struct Scsi_Host *shost;
> +	struct fc_lw_internal *i;
> +
> +	if (!scsi_is_host_device(dev))
> +		return 0;
> +
> +	shost = dev_to_shost(dev);
> +	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
> +	    != &fc_lw_host_class.class)
> +		return 0;
> +
> +	i = to_fc_lw_internal(shost->transportt);
> +
> +	return &i->t.host_attrs.ac == cont;
> +}
> +
>  static int fc_target_match(struct attribute_container *cont,
>  			    struct device *dev)
>  {
> @@ -2171,6 +2217,54 @@ static int fc_it_nexus_response(struct Scsi_Host
> *shost, u64 nexus, int result)
>  	return i->f->it_nexus_response(shost, nexus, result);
>  }
> 
> +/**
> + * fc_attach_lw_transport - light weight attach function
> + * @ft:		function template for optional attributes
> + *
> + * This attach function is to be used only for virtual FC emulators
> + * which do not have a physical fabric underneath them and thus only
> + * need a few attributes and no helper functions
> + */
> +struct scsi_transport_template *
> +fc_lw_attach_transport(struct fc_function_template *ft)
> +{
> +	int count;
> +	struct fc_lw_internal *i = kzalloc(sizeof(struct fc_lw_internal),
> +					   GFP_KERNEL);
> +
> +	if (unlikely(!i))
> +		return NULL;
> +
> +	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
> +	i->t.host_attrs.ac.class = &fc_lw_host_class.class;
> +	i->t.host_attrs.ac.match = fc_lw_host_match;
> +	i->t.host_size = sizeof(struct fc_host_attrs);
> +	transport_container_register(&i->t.host_attrs);
> +
> +	i->f = ft;
> +
> +	count = 0;
> +	SETUP_HOST_ATTRIBUTE_RD(node_name);
> +	SETUP_HOST_ATTRIBUTE_RD(port_name);
> +
> +	BUG_ON(count > FC_HOST_NUM_ATTRS);
> +
> +	i->host_attrs[count] = NULL;
> +
> +	return &i->t;
> +}
> +EXPORT_SYMBOL(fc_lw_attach_transport);
> +
> +void fc_lw_release_transport(struct scsi_transport_template *t)
> +{
> +	struct fc_lw_internal *i = to_fc_lw_internal(t);
> +
> +	transport_container_unregister(&i->t.host_attrs);
> +
> +	kfree(i);
> +}
> +EXPORT_SYMBOL(fc_lw_release_transport);
> +
>  struct scsi_transport_template *
>  fc_attach_transport(struct fc_function_template *ft)
>  {
> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> index 784bc2c..b0a9a64 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -835,6 +835,9 @@ fc_vport_set_state(struct fc_vport *vport, enum
> fc_vport_state new_state)
>  	vport->vport_state = new_state;
>  }
> 
> +struct scsi_transport_template *fc_lw_attach_transport(
> +			struct fc_function_template *);
> +void fc_lw_release_transport(struct scsi_transport_template *);
>  struct scsi_transport_template *fc_attach_transport(
>  			struct fc_function_template *);
>  void fc_release_transport(struct scsi_transport_template *);
> --
> 2.6.2

James,

It was great talking to you this afternoon. Is this what you had in mind:

drivers/scsi/scsi_transport_fc.c |  133 ++++++++++++++++++++++++++++++++++++--
 include/scsi/scsi_transport_fc.h |    3 +
 2 files changed, 130 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 24eaaf6..b8cadd2 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -351,6 +351,27 @@ struct fc_internal {
 
 #define to_fc_internal(tmpl)	container_of(tmpl, struct fc_internal, t)
 
+#define FC_LW_HOST_NUM_ATTRS 	2
+struct fc_lw_internal {
+	struct scsi_transport_template t;
+	struct fc_function_template *f;
+
+	/*
+	 * For attributes : each object has :
+	 *   An array of the actual attributes structures
+	 *   An array of null-terminated pointers to the attribute
+	 *     structures - used for mid-layer interaction.
+	 *
+	 * The attribute containers for the starget and host are are
+	 * part of the midlayer. As the remote port is specific to the
+	 * fc transport, we must provide the attribute container.
+	 */
+	struct device_attribute private_host_attrs[FC_LW_HOST_NUM_ATTRS];
+	struct device_attribute *host_attrs[FC_LW_HOST_NUM_ATTRS + 1];
+};
+
+#define to_fc_lw_internal(tmpl)	container_of(tmpl, struct fc_lw_internal, t)
+
 static int fc_target_setup(struct transport_container *tc, struct device *dev,
 			   struct device *cdev)
 {
@@ -472,6 +493,12 @@ static int fc_host_remove(struct transport_container *tc, struct device *dev,
 	return 0;
 }
 
+static DECLARE_TRANSPORT_CLASS(fc_lw_host_class,
+			       "fc_host",
+			       NULL,
+			       NULL,
+			       NULL);
+
 static DECLARE_TRANSPORT_CLASS(fc_host_class,
 			       "fc_host",
 			       fc_host_setup,
@@ -654,11 +681,20 @@ send_vendor_fail:
 EXPORT_SYMBOL(fc_host_post_vendor_event);
 
 
+static bool transport_inited;
+static bool lw_transport_inited;
 
-static __init int fc_transport_init(void)
+static int fc_transport_init(bool lw_transport)
 {
 	int error;
+	bool inited = cmpxchg(&transport_inited, transport_inited, true);
 
+	/*
+	 * If transport has already been inited, just return.
+	 */
+	if (inited)
+		return 0;
+	
 	atomic_set(&fc_event_seq, 0);
 
 	error = transport_class_register(&fc_host_class);
@@ -670,9 +706,15 @@ static __init int fc_transport_init(void)
 	error = transport_class_register(&fc_rport_class);
 	if (error)
 		goto unreg_vport_class;
-	error = transport_class_register(&fc_transport_class);
+	if (lw_transport)
+		error = transport_class_register(&fc_lw_host_class);
+	else 
+		error = transport_class_register(&fc_transport_class);
 	if (error)
 		goto unreg_rport_class;
+
+	if (lw_transport)
+		 lw_transport_inited = true;
 	return 0;
 
 unreg_rport_class:
@@ -686,8 +728,12 @@ unreg_host_class:
 
 static void __exit fc_transport_exit(void)
 {
-	transport_class_unregister(&fc_transport_class);
+	if (lw_transport_inited)
+		transport_class_unregister(&fc_lw_host_class);
+	else
+		transport_class_unregister(&fc_transport_class);
 	transport_class_unregister(&fc_rport_class);
+	if (lw_transport_inited)
 	transport_class_unregister(&fc_host_class);
 	transport_class_unregister(&fc_vport_class);
 }
@@ -1968,6 +2014,25 @@ static int fc_host_match(struct attribute_container *cont,
 	return &i->t.host_attrs.ac == cont;
 }
 
+static int fc_lw_host_match(struct attribute_container *cont,
+			  struct device *dev)
+{
+	struct Scsi_Host *shost;
+	struct fc_lw_internal *i;
+
+	if (!scsi_is_host_device(dev))
+		return 0;
+
+	shost = dev_to_shost(dev);
+	if (!shost->transportt  || shost->transportt->host_attrs.ac.class
+	    != &fc_lw_host_class.class)
+		return 0;
+
+	i = to_fc_lw_internal(shost->transportt);
+
+	return &i->t.host_attrs.ac == cont;
+}
+
 static int fc_target_match(struct attribute_container *cont,
 			    struct device *dev)
 {
@@ -2171,13 +2236,70 @@ static int fc_it_nexus_response(struct Scsi_Host *shost, u64 nexus, int result)
 	return i->f->it_nexus_response(shost, nexus, result);
 }
 
+/**
+ * fc_attach_lw_transport - light weight attach function
+ * @ft:		function template for optional attributes
+ *
+ * This attach function is to be used only for virtual FC emulators
+ * which do not have a physical fabric underneath them and thus only
+ * need a few attributes and no helper functions
+ */
+struct scsi_transport_template *
+fc_lw_attach_transport(struct fc_function_template *ft)
+{
+	int count;
+	struct fc_lw_internal *i;
+
+	if (fc_transport_init(true))
+		return NULL;
+
+	i = kzalloc(sizeof(struct fc_lw_internal),
+		    GFP_KERNEL);
+
+	if (unlikely(!i))
+		return NULL;
+
+	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
+	i->t.host_attrs.ac.class = &fc_lw_host_class.class;
+	i->t.host_attrs.ac.match = fc_lw_host_match;
+	i->t.host_size = sizeof(struct fc_host_attrs);
+	transport_container_register(&i->t.host_attrs);
+
+	i->f = ft;
+
+	count = 0;
+	SETUP_HOST_ATTRIBUTE_RD(node_name);
+	SETUP_HOST_ATTRIBUTE_RD(port_name);
+
+	BUG_ON(count > FC_HOST_NUM_ATTRS);
+
+	i->host_attrs[count] = NULL;
+
+	return &i->t;
+}
+EXPORT_SYMBOL(fc_lw_attach_transport);
+
+void fc_lw_release_transport(struct scsi_transport_template *t)
+{
+	struct fc_lw_internal *i = to_fc_lw_internal(t);
+
+	transport_container_unregister(&i->t.host_attrs);
+
+	kfree(i);
+}
+EXPORT_SYMBOL(fc_lw_release_transport);
+
 struct scsi_transport_template *
 fc_attach_transport(struct fc_function_template *ft)
 {
 	int count;
-	struct fc_internal *i = kzalloc(sizeof(struct fc_internal),
-					GFP_KERNEL);
+	struct fc_internal *i;
+
+	if (fc_transport_init(false))
+		return NULL;
 
+	i = kzalloc(sizeof(struct fc_internal),
+			   GFP_KERNEL);
 	if (unlikely(!i))
 		return NULL;
 
@@ -4148,5 +4270,4 @@ MODULE_AUTHOR("James Smart");
 MODULE_DESCRIPTION("FC Transport Attributes");
 MODULE_LICENSE("GPL");
 
-module_init(fc_transport_init);
 module_exit(fc_transport_exit);
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 784bc2c..b0a9a64 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -835,6 +835,9 @@ fc_vport_set_state(struct fc_vport *vport, enum fc_vport_state new_state)
 	vport->vport_state = new_state;
 }
 
+struct scsi_transport_template *fc_lw_attach_transport(
+			struct fc_function_template *);
+void fc_lw_release_transport(struct scsi_transport_template *);
 struct scsi_transport_template *fc_attach_transport(
 			struct fc_function_template *);
 void fc_release_transport(struct scsi_transport_template *);
-- 
1.7.4.1
