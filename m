From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: SCSI enclosure black list
Date: Thu, 14 Nov 2002 08:33:49 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021114083349.A23388@eng2.beaverton.ibm.com>
References: <1037225713.16638.85.camel@dell_ss3.pdx.osdl.net> <1037227816.11996.203.camel@irongate.swansea.linux.org.uk> <1037289000.30355.6.camel@markh1.pdx.osdl.net> <1037291446.16000.37.camel@irongate.swansea.linux.org.uk> <1037290824.30367.11.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1037290824.30367.11.camel@markh1.pdx.osdl.net>; from markh@osdl.org on Thu, Nov 14, 2002 at 08:20:24AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Stephen Hemminger <shemminger@osdl.org>, Linus Torvalds <torvalds@transmeta.com>, linux-scsi@vger.kernel.org

On Thu, Nov 14, 2002 at 08:20:24AM -0800, Mark Haverkamp wrote:

>=20
> Wouldn't it still be reasonable to have the enclosure in the blacklis=
t
> since it doesn't seem to handle the report luns command?
> --=20
> Mark Haverkamp <markh@osdl.org>

Mark -

The megaraid driver should be fixed, but can you try out this patch?

I posted for comments, and got nothing back so far.

This patch allows scsi device flags like those in the current scsi_scan=
=2Ec
device_list to be added via the command line or via /proc/scsi/device_i=
nfo.

It also allows a default flag to be set via the command line.

This should allow for the (eventual) removal of the current device_list=
=2E

Example boot command line argument for your case:

scsi_dev_flags=3D"IBM:EXP300   S160"

lilo does not allow multiple spaces in a row (on the boot line, or in
the lilo.conf), so it can't handle the above. I haven't tried grub.

-- Patrick Mansfield

--- 1.57/drivers/scsi/scsi.c	Wed Nov  6 14:53:34 2002
+++ edited/drivers/scsi/scsi.c	Thu Nov 14 08:14:37 2002
@@ -163,6 +163,10 @@
 };
=20
 static char * scsi_null_device_strs =3D "nullnullnullnull";
+static const char * const spaces =3D "                "; /* 16 of them=
 */
+
+static unsigned scsi_default_dev_flags;
+static LIST_HEAD(scsi_dev_info_list);
=20
 /*=20
  * Function prototypes.
@@ -1668,7 +1672,312 @@
 	spin_unlock_irqrestore(&device_request_lock, flags);
 }
=20
+/*
+ * scsi_strcpy_devinfo: called from scsi_dev_info_list_add to copy int=
o
+ * devinfo vendor and model strings.
+ */
+static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length=
,
+				char *from, int compatible)
+{
+	size_t from_length;
+
+	from_length =3D strlen(from);
+	strncpy(to, from, min(to_length, from_length));
+	if (from_length < to_length)
+		if (compatible) {
+			/*
+			 * NUL terminate the string if it is short.
+			 */
+			to[from_length] =3D '\0';
+		} else {
+			/*=20
+			 * space pad the string if it is short.=20
+			 */
+			strncpy(&to[from_length], spaces,
+				to_length - from_length);
+		}
+	if (from_length > to_length)
+		 printk(KERN_WARNING "%s: %s string '%s' is too long\n",
+			__FUNCTION__, name, from);
+}
+
+/**
+ * scsi_dev_info_list_add: add one dev_info list entry.
+ * @vendor:	vendor string
+ * @model:	model (product) string
+ * @strflags:	integer string
+ * @flag:	if strflags NULL, use this flag value
+ *
+ * Description:
+ * 	Create and add one dev_info entry for @vendor, @model, @strflags o=
r
+ * 	@flag. If @compatible, add to the tail of the list, do not space
+ * 	pad, and set devinfo->compatible. The scsi_static_device_list entr=
ies
+ * 	are added with @compatible 1 and @clfags NULL.
+ *
+ * Returns: 0 OK, -error on failure.
+ **/
+static int scsi_dev_info_list_add(int compatible, char *vendor, char *=
model,
+			    char *strflags, int flags)
+{
+	struct scsi_dev_info_list *devinfo;
+
+	devinfo =3D kmalloc(sizeof(*devinfo), GFP_KERNEL);
+	if (!devinfo) {
+		printk(KERN_ERR "%s: no memory\n", __FUNCTION__);
+		return -ENOMEM;
+	}
+
+	scsi_strcpy_devinfo("vendor", devinfo->vendor, sizeof(devinfo->vendor=
),
+			    vendor, compatible);
+	scsi_strcpy_devinfo("model", devinfo->model, sizeof(devinfo->model),
+			    model, compatible);
+
+	if (strflags)
+		devinfo->flags =3D simple_strtoul(strflags, NULL, 0);
+	else
+		devinfo->flags =3D flags;
+
+	devinfo->compatible =3D compatible;
+
+	if (compatible)
+		list_add_tail(&devinfo->dev_info_list, &scsi_dev_info_list);
+	else
+		list_add(&devinfo->dev_info_list, &scsi_dev_info_list);
+
+	return 0;
+}
+
+/**
+ * scsi_dev_info_list_add_str: parse dev_list and add to the
+ * scsi_dev_info_list.
+ * @dev_list:	string of device flags to add
+ *
+ * Description:
+ * 	Parse dev_list, and add entries to the scsi_dev_info_list.
+ * 	dev_list is of the form "vendor:product:flag,vendor:product:flag".
+ * 	dev_list is modified via strsep. Can be called for command line
+ * 	addition, for proc or mabye a sysfs interface.
+ *
+ * Returns: 0 if OK, -error on failure.
+ **/
+static int scsi_dev_info_list_add_str (char *dev_list)
+{
+	char *vendor, *model, *strflags, *next;
+	char *next_check;
+	int res =3D 0;
+
+	next =3D dev_list;
+	if (next && next[0] =3D=3D '"') {
+		/*
+		 * Ignore both the leading and trailing quote.
+		 */
+		next++;
+		next_check =3D ",\"";
+	} else {
+		next_check =3D ",";
+	}
+
+	/*
+	 * For the leading and trailing '"' case, the for loop comes
+	 * through the last time with vendor[0] =3D=3D '\0'.
+	 */
+	for (vendor =3D strsep(&next, ":"); vendor && (vendor[0] !=3D '\0')
+	     && (res =3D=3D 0); vendor =3D strsep(&next, ":")) {
+		strflags =3D NULL;
+		model =3D strsep(&next, ":");
+		if (model)
+			strflags =3D strsep(&next, next_check);
+		if (!model || !strflags) {
+			printk(KERN_ERR "%s: bad dev info string '%s' '%s'"
+			       " '%s'\n", __FUNCTION__, vendor, model,
+			       strflags);
+			res =3D -EINVAL;
+		} else
+			res =3D scsi_dev_info_list_add(0 /* compatible */, vendor,
+						     model, strflags, 0);
+	}
+	return res;
+}
+
+/**
+ * scsi_dev_list_init: set up the dynamic device list.
+ * @dev_list:	string of device flags to add
+ *
+ * Description:
+ * 	Add command line @dev_list entries, then add
+ * 	scsi_static_device_list entries to the scsi device info list.
+ **/
+static void scsi_dev_info_list_init (char *dev_list)
+{
+	int i;
+
+	if (scsi_dev_info_list_add_str(dev_list) =3D=3D -ENOMEM)
+		return;
+	for (i =3D 0; scsi_static_device_list[i].vendor !=3D NULL; i++)
+		if (scsi_dev_info_list_add(1 /* compatibile */,
+			   scsi_static_device_list[i].vendor,
+			   scsi_static_device_list[i].model,
+			   NULL,
+			   scsi_static_device_list[i].flags) =3D=3D -ENOMEM)
+			return;
+}
+
+/**
+ * scsi_dev_info_list_delete: called from scsi.c:exit_scsi to remove
+ * 	the scsi_dev_info_list.
+ **/
+static void scsi_dev_info_list_delete (void)
+{
+	struct list_head *lh, *lh_next;
+	struct scsi_dev_info_list *devinfo;
+
+	list_for_each_safe(lh, lh_next, &scsi_dev_info_list) {
+		devinfo =3D list_entry(lh, struct scsi_dev_info_list,
+				     dev_info_list);
+		kfree(devinfo);
+	}
+}
+
+/**
+ * get_device_flags - get device specific flags from the dynamic devic=
e
+ * list. Called during scan time.
+ * @vendor:	vendor name
+ * @model:	model name
+ *
+ * Description:
+ *     Search the scsi_dev_info_list for an entry matching @vendor and
+ *     @model, if found, return the matching flags value, else return
+ *     scsi_default_dev_flags.
+ **/
+int scsi_get_device_flags(unsigned char *vendor, unsigned char *model)
+{
+	struct scsi_dev_info_list *devinfo;
+
+	list_for_each_entry(devinfo, &scsi_dev_info_list, dev_info_list) {
+		if (devinfo->compatible) {
+			/*
+			 * Behave like the older version of get_device_flags.
+			 */
+			size_t max;
+			/*
+			 * XXX why skip leading spaces? If an odd INQUIRY
+			 * value, that should have been part of the
+			 * scsi_static_device_list[] entry, such as "  FOO"
+			 * rather than "FOO". Since this code is already
+			 * here, and we don't know what device it is
+			 * trying to work with, leave it as-is.
+			 */
+			max =3D 8;	/* max length of vendor */
+			while ((max > 0) && *vendor =3D=3D ' ') {
+				max--;
+				vendor++;
+			}
+			/*
+			 * XXX removing the following strlen() would be
+			 * good, using it means that for a an entry not in
+			 * the list, we scan every byte of every vendor
+			 * listed in scsi_static_device_list[], and never match
+			 * a single one (and still have to compare at
+			 * least the first byte of each vendor).
+			 */
+			if (memcmp(devinfo->vendor, vendor,
+				    min(max, strlen(devinfo->vendor))))
+				continue;
+			/*
+			 * Skip spaces again.
+			 */
+			max =3D 16;	/* max length of model */
+			while ((max > 0) && *model =3D=3D ' ') {
+				max--;
+				model++;
+			}
+			if (memcmp(devinfo->model, model,
+				   min(max, strlen(devinfo->model))))
+				continue;
+			return devinfo->flags;
+		} else {
+			if (!memcmp(devinfo->vendor, vendor,
+				     sizeof(devinfo->vendor)) &&
+			     !memcmp(devinfo->model, model,
+				      sizeof(devinfo->model)))
+				return devinfo->flags;
+		}
+	}
+	return scsi_default_dev_flags;
+}
+
 #ifdef CONFIG_PROC_FS
+/*=20
+ * proc_scsi_dev_info_read: dump the scsi_dev_info_list via
+ * /proc/scsi/device_info
+ */
+static int proc_scsi_dev_info_read(char *buffer, char **start, off_t o=
ffset,
+				   int length)
+{
+	struct scsi_dev_info_list *devinfo;
+	int size, len =3D 0;
+	off_t begin =3D 0;
+	off_t pos =3D 0;
+
+	list_for_each_entry(devinfo, &scsi_dev_info_list, dev_info_list) {
+		size =3D sprintf(buffer + len, "'%.8s' '%.16s' 0x%x\n",
+			       devinfo->vendor, devinfo->model, devinfo->flags);
+		len +=3D size;
+		pos =3D begin + len;
+		if (pos < offset) {
+			len =3D 0;
+			begin =3D pos;
+		}
+		if (pos > offset + length)
+			goto stop_output;
+	}
+
+stop_output:
+	*start =3D buffer + (offset - begin);	/* Start of wanted data */
+	len -=3D (offset - begin);	/* Start slop */
+	if (len > length)
+		len =3D length;	/* Ending slop */
+	return (len);
+}
+
+/*=20
+ * proc_scsi_dev_info_write: allow additions to the scsi_dev_info_list=
 via
+ * /proc.
+ *
+ * Use: echo "vendor:model:flag" > /proc/scsi/device_info
+ *
+ * To add a black/white list entry for vendor and model with an intege=
r
+ * value of flag to the scsi device info list.
+ */
+static int proc_scsi_dev_info_write (struct file * file, const char * =
buf,
+                              unsigned long length, void *data)
+{
+	char *buffer;
+	int err =3D length;
+
+	if (!buf || length>PAGE_SIZE)
+		return -EINVAL;
+	if (!(buffer =3D (char *) __get_free_page(GFP_KERNEL)))
+		return -ENOMEM;
+	if(copy_from_user(buffer, buf, length)) {
+		err =3D-EFAULT;
+		goto out;
+	}
+
+	if (length < PAGE_SIZE)
+		buffer[length] =3D '\0';
+	else if (buffer[PAGE_SIZE-1]) {
+		err =3D -EINVAL;
+		goto out;
+	}
+
+	scsi_dev_info_list_add_str(buffer);
+
+out:
+	free_page((unsigned long) buffer);
+	return err;
+}
+
 static int scsi_proc_info(char *buffer, char **start, off_t offset, in=
t length)
 {
 	Scsi_Device *scd;
@@ -2267,8 +2576,17 @@
 #endif				/* CONFIG_PROC_FS */
=20
 static char *scsihosts;
+static char *scsi_dev_flags;
=20
 MODULE_PARM(scsihosts, "s");
+MODULE_PARM(scsi_dev_flags, "s");
+MODULE_PARM_DESC(scsi_dev_flags,
+	 "Given scsi_dev_flags=3Dvendor:model:flags, add a black/white list"
+	 " entry for vendor and model with an integer value of flags"
+	 " to the scsi device info list");
+MODULE_PARM(scsi_default_dev_flags, "i");
+MODULE_PARM_DESC(scsi_default_dev_flags,
+		 "scsi default device flag integer value");
 MODULE_DESCRIPTION("SCSI core");
 MODULE_LICENSE("GPL");
=20
@@ -2280,6 +2598,30 @@
 }
=20
 __setup("scsihosts=3D", scsi_setup);
+
+int __init setup_scsi_dev_flags(char *str)
+{
+	scsi_dev_flags =3D str;
+	return 1;
+}
+__setup("scsi_dev_flags=3D", setup_scsi_dev_flags);
+
+static int __init setup_scsi_default_dev_flags(char *str)
+{
+	unsigned int tmp;
+	if (get_option(&str, &tmp) =3D=3D 1) {
+		scsi_default_dev_flags =3D tmp;
+		printk(KERN_WARNING "%s %d\n", __FUNCTION__,
+		       scsi_default_dev_flags);
+		return 1;
+	} else {
+		printk(KERN_WARNING "%s: usage scsi_default_dev_flags=3Dintr\n",
+		       __FUNCTION__);
+		return 0;
+	}
+}
+__setup("scsi_default_dev_flags=3D", setup_scsi_default_dev_flags);
+
 #endif
=20
 static void *scsi_pool_alloc(int gfp_mask, void *data)
@@ -2402,12 +2744,24 @@
 		return -ENOMEM;
 	}
 	generic->write_proc =3D proc_scsi_gen_write;
+
+	generic =3D create_proc_info_entry ("scsi/device_info", 0, 0,
+					  proc_scsi_dev_info_read);
+	if (!generic) {
+		printk (KERN_ERR "cannot init /proc/scsi/device_info\n");
+		remove_proc_entry("scsi/scsi", 0);
+		remove_proc_entry("scsi", 0);
+		return -ENOMEM;
+	}
+	generic->write_proc =3D proc_scsi_dev_info_write;
 #endif
=20
         scsi_devfs_handle =3D devfs_mk_dir (NULL, "scsi", NULL);
=20
 	scsi_host_hn_init(scsihosts);
=20
+	scsi_dev_info_list_init(scsi_dev_flags);
+
 	bus_register(&scsi_driverfs_bus_type);
=20
 	/* Where we handle work queued by scsi_done */
@@ -2422,10 +2776,13 @@
=20
         devfs_unregister (scsi_devfs_handle);
=20
+	scsi_dev_info_list_delete();
+
 	scsi_host_hn_release();
=20
 #ifdef CONFIG_PROC_FS
 	/* No, we're not here anymore. Don't show the /proc/scsi files. */
+	remove_proc_entry ("scsi/device_info", 0);
 	remove_proc_entry ("scsi/scsi", 0);
 	remove_proc_entry ("scsi", 0);
 #endif
=3D=3D=3D=3D=3D drivers/scsi/scsi.h 1.35 vs edited =3D=3D=3D=3D=3D
--- 1.35/drivers/scsi/scsi.h	Fri Nov  8 01:57:41 2002
+++ edited/drivers/scsi/scsi.h	Thu Nov 14 08:14:37 2002
@@ -483,6 +483,7 @@
 extern void scsi_detect_device(struct scsi_device *);
 extern int scsi_attach_device(struct scsi_device *);
 extern void scsi_detach_device(struct scsi_device *);
+extern int scsi_get_device_flags(unsigned char *vendor, unsigned char =
*model);
=20
 /*
  * Newer request-based interfaces.
@@ -526,6 +527,29 @@
 extern int print_msg(const unsigned char *);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char=
);
+
+/*
+ * dev_info: for the black/white list in the old scsi_static_device_li=
st
+ */
+struct dev_info {
+	char *vendor;
+	char *model;
+	char *revision;	/* revision known to be bad, unused */
+	unsigned flags;
+};
+
+extern struct dev_info scsi_static_device_list[] __initdata;
+
+/*
+ * scsi_dev_info_list: structure to hold black/white listed devices.
+ */
+struct scsi_dev_info_list {
+	struct list_head dev_info_list;
+	char vendor[8];
+	char model[16];
+	unsigned flags;
+	unsigned compatible; /* for use with scsi_static_device_list entries =
*/
+};
=20
 /*
  *  The scsi_device struct contains what we know about each given scsi
=3D=3D=3D=3D=3D drivers/scsi/scsi_scan.c 1.33 vs edited =3D=3D=3D=3D=3D
--- 1.33/drivers/scsi/scsi_scan.c	Tue Nov  5 09:27:24 2002
+++ edited/drivers/scsi/scsi_scan.c	Thu Nov 14 08:14:37 2002
@@ -54,18 +54,16 @@
 #define BLIST_INQUIRY_36	0x400	/* override additional length field */
 #define BLIST_INQUIRY_58	0x800	/* ... for broken inquiry responses */
=20
-struct dev_info {
-	const char *vendor;
-	const char *model;
-	const char *revision;	/* revision known to be bad, unused */
-	unsigned flags;
-};
-
 /*
- * device_list: devices that require settings that differ from the
- * default, includes black-listed (broken) devices.
+ * scsi_static_device_list: deprecated list of devices that require
+ * settings that differ from the default, includes black-listed (broke=
n)
+ * devices. The entries here are added to the tail of scsi_dev_info_li=
st
+ * via scsi_dev_info_list_init.
+ *
+ * Do not add to this list, use the command line or proc interface to =
add
+ * to the scsi_dev_info_list. This table will eventually go away.
  */
-static struct dev_info device_list[] =3D {
+struct dev_info scsi_static_device_list[] __initdata =3D {
 	/*
 	 * The following devices are known not to tolerate a lun !=3D 0 scan
 	 * for one reason or another. Some will respond to all luns,
@@ -183,6 +181,7 @@
 	{"COMPAQ", "MSA1000", NULL, BLIST_FORCELUN},
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
+	{ NULL, NULL, NULL, 0 },
 };
=20
 #define ALLOC_FAILURE_MSG	KERN_ERR "%s: Allocation failure during" \
@@ -427,62 +426,6 @@
 }
=20
 /**
- * get_device_flags - get device specific flags from the device_list
- * @vendor:	vendor name
- * @model:	model name
- *
- * Description:
- *     Search device_list for an entry matching @vendor and @model, if
- *     found, return the matching flags value, else return 0.
- *     Partial matches count as success - good for @model, but maybe n=
ot
- *     @vendor.
- **/
-static int get_device_flags(unsigned char *vendor, unsigned char *mode=
l)
-{
-	int i;
-	size_t max;
-
-	for (i =3D 0; i < ARRAY_SIZE(device_list); i++) {
-		/*
-		 * XXX why skip leading spaces? If an odd INQUIRY value,
-		 * that should have been part of the device_list[] entry,
-		 * such as "  FOO" rather than "FOO". Since this code is
-		 * already here, and we don't know what device it is
-		 * trying to work with, leave it as-is.
-		 */
-		max =3D 8;	/* max length of vendor */
-		while ((max > 0) && *vendor =3D=3D ' ') {
-			max--;
-			vendor++;
-		}
-		/*
-		 * XXX removing the following strlen() would be good,
-		 * using it means that for a an entry not in the list, we
-		 * scan every byte of every vendor listed in
-		 * device_list[], and never match a single one (and still
-		 * have to compare at least the first byte of each
-		 * vendor).
-		 */
-		if (memcmp(device_list[i].vendor, vendor,
-			    min(max, strlen(device_list[i].vendor))))
-			continue;
-		/*
-		 * Skip spaces again.
-		 */
-		max =3D 16;	/* max length of model */
-		while ((max > 0) && *model =3D=3D ' ') {
-			max--;
-			model++;
-		}
-		if (memcmp(device_list[i].model, model,
-			   min(max, strlen(device_list[i].model))))
-			continue;
-		return device_list[i].flags;
-	}
-	return 0;
-}
-
-/**
  * scsi_initialize_merge_fn() -=C6=A3initialize merge function for a h=
ost
  * @sd:		host descriptor
  */
@@ -1092,12 +1035,12 @@
  * Notes:
  *     If a device returns the same serial number for different LUNs o=
r
  *     even for different LUNs on different devices, special handling =
must
- *     be added to get an id, or a new black list flag must to added a=
nd
- *     used in device_list[] (so we use the default name, or add a way=
 to
- *     prefix the id/name with SCSI_UID_UNKNOWN - and change the defin=
e to
- *     something meaningful like SCSI_UID_NOT_UNIQUE). Complete user l=
evel
- *     scanning would be nice for such devices, so we do not need devi=
ce
- *     specific code in the kernel.
+ *     be added to get an id, or a new black list flag must be added (=
so
+ *     we use the default name, or add a way to prefix the id/name wit=
h
+ *     SCSI_UID_UNKNOWN - and change the define to something meaningfu=
l
+ *     like SCSI_UID_NOT_UNIQUE). Complete user level scanning would b=
e
+ *     nice for such devices, so we do not need device specific code i=
n
+ *     the kernel.
  **/
 static void scsi_load_identifier(Scsi_Device *sdev, Scsi_Request *sreq=
)
 {
@@ -1176,7 +1119,7 @@
  *     If the INQUIRY is successful, sreq->sr_result is zero and: the
  *     INQUIRY data is in @inq_result; the scsi_level and INQUIRY leng=
th
  *     are copied to the Scsi_Device at @sreq->sr_device (sdev);
- *     any device_list flags value is stored in *@bflags.
+ *     any flags value is stored in *@bflags.
  **/
 static void scsi_probe_lun(Scsi_Request *sreq, char *inq_result,
 			   int *bflags)
@@ -1225,7 +1168,7 @@
 	 * argument.
 	 */
 	BUG_ON(bflags =3D=3D NULL);
-	*bflags =3D get_device_flags(&inq_result[8], &inq_result[16]);
+	*bflags =3D scsi_get_device_flags(&inq_result[8], &inq_result[16]);
=20
 	possible_inq_resp_len =3D (unsigned char) inq_result[4] + 5;
 	if (BLIST_INQUIRY_36 & *bflags)
@@ -1306,7 +1249,7 @@
  * @sdevnew:	store the address of the newly allocated Scsi_Device
  * @sreq:	scsi request used when getting an identifier
  * @inq_result:	holds the result of a previous INQUIRY to the LUN
- * @bflags:	flags value from device_list
+ * @bflags:	black/white list flag
  *
  * Description:
  *     Allocate and initialize a Scsi_Device matching sdevscan. Option=
ally
@@ -1608,7 +1551,7 @@
 /**
  * scsi_sequential_lun_scan - sequentially scan a SCSI target
  * @sdevscan:	scan the host, channel, and id of this Scsi_Device
- * @bflags:	flags from device_list for LUN 0
+ * @bflags:	black/white list flag for LUN 0
  * @lun0_res:	result of scanning LUN 0
  *
  * Description:
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
