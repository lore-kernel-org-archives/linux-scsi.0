From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH,RESEND] scsi: use __uX types for headers exported to user
 space
Date: Thu, 07 Jan 2010 16:39:36 +0200
Message-ID: <4B45F228.7080506__47707.0466070019$1262879486$gmane$org@panasas.com>
References: <1262874005-25089-1-git-send-email-jacmet@sunsite.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:61558 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752558Ab0AGOjl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2010 09:39:41 -0500
In-Reply-To: <1262874005-25089-1-git-send-email-jacmet@sunsite.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: James.Bottomley@suse.de, james.smart@emulex.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org

On 01/07/2010 04:20 PM, Peter Korsgaard wrote:
> Commit 9e4f5e29 (FC Pass Thru support) exported a number of header fi=
les
> in include/scsi to user space, but didn't change the uX types to the
> userspace-compatible __uX types. Without that you'll get compile erro=
rs
> when including them - E.G.:
>=20
> /tmp/include/scsi/scsi.h:145: error: expected specifier-qualifier-lis=
t
> before =E2=80=98u8=E2=80=99
>=20
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
> ---
>  No feedback since 27/11, resending.
>=20
>  include/scsi/scsi.h         |    8 ++++----
>  include/scsi/scsi_netlink.h |   20 ++++++++++----------
>  2 files changed, 14 insertions(+), 14 deletions(-)
>=20
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 8b4deca..ec3053e 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -149,10 +149,10 @@ struct scsi_cmnd;
> =20
>  /* defined in T10 SCSI Primary Commands-2 (SPC2) */
>  struct scsi_varlen_cdb_hdr {
> -	u8 opcode;        /* opcode always =3D=3D VARIABLE_LENGTH_CMD */
> -	u8 control;
> -	u8 misc[5];
> -	u8 additional_cdb_length;         /* total cdb length - 8 */
> +	__u8 opcode;        /* opcode always =3D=3D VARIABLE_LENGTH_CMD */
> +	__u8 control;
> +	__u8 misc[5];
> +	__u8 additional_cdb_length;         /* total cdb length - 8 */
>  	__be16 service_action;
>  	/* service specific data follows */
>  };

This is not the only thing broken here. Perhaps something like:
---
git diff --stat -p -M include/scsi/scsi.h
 include/scsi/scsi.h |   90 ++++++++++++++++++++++++++-----------------=
--------
 1 files changed, 46 insertions(+), 44 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8b4deca..05e8c13 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -10,33 +10,6 @@
=20
 #include <linux/types.h>
=20
-struct scsi_cmnd;
-
-/*
- * The maximum number of SG segments that we will put inside a
- * scatterlist (unless chaining is used). Should ideally fit inside a
- * single page, to avoid a higher order allocation.  We could define t=
his
- * to SG_MAX_SINGLE_ALLOC to pack correctly at the highest order.  The
- * minimum value is 32
- */
-#define SCSI_MAX_SG_SEGMENTS	128
-
-/*
- * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. Thi=
s limit
- * is totally arbitrary, a setting of 2048 will get you at least 8mb i=
os.
- */
-#ifdef ARCH_HAS_SG_CHAIN
-#define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
-#else
-#define SCSI_MAX_SG_CHAIN_SEGMENTS	SCSI_MAX_SG_SEGMENTS
-#endif
-
-/*
- * Special value for scanning to specify scanning or rescanning of all
- * possible channels, (target) ids, or luns on a given shost.
- */
-#define SCAN_WILD_CARD	~0
-
 /*
  *      SCSI opcodes
  */
@@ -149,10 +122,10 @@ struct scsi_cmnd;
=20
 /* defined in T10 SCSI Primary Commands-2 (SPC2) */
 struct scsi_varlen_cdb_hdr {
-	u8 opcode;        /* opcode always =3D=3D VARIABLE_LENGTH_CMD */
-	u8 control;
-	u8 misc[5];
-	u8 additional_cdb_length;         /* total cdb length - 8 */
+	__u8 opcode;        /* opcode always =3D=3D VARIABLE_LENGTH_CMD */
+	__u8 control;
+	__u8 misc[5];
+	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
 };
@@ -163,16 +136,6 @@ scsi_varlen_cdb_length(const void *hdr)
 	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8=
;
 }
=20
-extern const unsigned char scsi_command_size_tbl[8];
-#define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7=
]
-
-static inline unsigned
-scsi_command_size(const unsigned char *cmnd)
-{
-	return (cmnd[0] =3D=3D VARIABLE_LENGTH_CMD) ?
-		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
-}
-
 /*
  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
  *  T10/1561-D Revision 4 Draft dated 7th November 2002.
@@ -288,9 +251,6 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_UNSPEC =3D 0xf, /* No specific protocol */
 };
=20
-/* Returns a human-readable name for the device */
-extern const char * scsi_device_type(unsigned type);
-
 /*
  * standard mode-select header prepended to all mode-select commands
  */
@@ -515,4 +475,46 @@ static inline __u32 scsi_to_u32(__u8 *ptr)
 	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
 }
=20
+#ifdef __KERNEL__
+
+/*
+ * The maximum number of SG segments that we will put inside a
+ * scatterlist (unless chaining is used). Should ideally fit inside a
+ * single page, to avoid a higher order allocation.  We could define t=
his
+ * to SG_MAX_SINGLE_ALLOC to pack correctly at the highest order.  The
+ * minimum value is 32
+ */
+#define SCSI_MAX_SG_SEGMENTS	128
+
+/*
+ * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. Thi=
s limit
+ * is totally arbitrary, a setting of 2048 will get you at least 8mb i=
os.
+ */
+#ifdef ARCH_HAS_SG_CHAIN
+#define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
+#else
+#define SCSI_MAX_SG_CHAIN_SEGMENTS	SCSI_MAX_SG_SEGMENTS
+#endif
+
+/*
+ * Special value for scanning to specify scanning or rescanning of all
+ * possible channels, (target) ids, or luns on a given shost.
+ */
+#define SCAN_WILD_CARD	~0
+
+extern const unsigned char scsi_command_size_tbl[8];
+#define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7=
]
+
+static inline unsigned
+scsi_command_size(const unsigned char *cmnd)
+{
+	return (cmnd[0] =3D=3D VARIABLE_LENGTH_CMD) ?
+		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
+}
+
+/* Returns a human-readable name for the device */
+extern const char * scsi_device_type(unsigned type);
+
+#endif /* __KERNEL__ */
+
 #endif /* _SCSI_SCSI_H */


> diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.=
h
> index 536752c..7445c46 100644
> --- a/include/scsi/scsi_netlink.h
> +++ b/include/scsi/scsi_netlink.h
> @@ -105,8 +105,8 @@ struct scsi_nl_host_vendor_msg {
>   *    PCI :  ID data is the 16 bit PCI Registered Vendor ID
>   */
>  #define SCSI_NL_VID_TYPE_SHIFT		56
> -#define SCSI_NL_VID_TYPE_MASK		((u64)0xFF << SCSI_NL_VID_TYPE_SHIFT)
> -#define SCSI_NL_VID_TYPE_PCI		((u64)0x01 << SCSI_NL_VID_TYPE_SHIFT)
> +#define SCSI_NL_VID_TYPE_MASK		((__u64)0xFF << SCSI_NL_VID_TYPE_SHIF=
T)
> +#define SCSI_NL_VID_TYPE_PCI		((__u64)0x01 << SCSI_NL_VID_TYPE_SHIFT=
)
>  #define SCSI_NL_VID_ID_MASK		(~ SCSI_NL_VID_TYPE_MASK)
> =20
> =20
> @@ -125,21 +125,21 @@ struct scsi_nl_host_vendor_msg {

No, from here on down it's in an #ifdef __KERNEL__
Please remove this hunk

>  #include <scsi/scsi_host.h>
> =20
>  /* Exported Kernel Interfaces */
> -int scsi_nl_add_transport(u8 tport,
> +int scsi_nl_add_transport(__u8 tport,
>  	 int (*msg_handler)(struct sk_buff *),
>  	void (*event_handler)(struct notifier_block *, unsigned long, void =
*));
> -void scsi_nl_remove_transport(u8 tport);
> +void scsi_nl_remove_transport(__u8 tport);
> =20
> -int scsi_nl_add_driver(u64 vendor_id, struct scsi_host_template *hos=
tt,
> +int scsi_nl_add_driver(__u64 vendor_id, struct scsi_host_template *h=
ostt,
>  	int (*nlmsg_handler)(struct Scsi_Host *shost, void *payload,
> -				 u32 len, u32 pid),
> +				 __u32 len, __u32 pid),
>  	void (*nlevt_handler)(struct notifier_block *nb,
>  				 unsigned long event, void *notify_ptr));
> -void scsi_nl_remove_driver(u64 vendor_id);
> +void scsi_nl_remove_driver(__u64 vendor_id);
> =20
> -void scsi_nl_send_transport_msg(u32 pid, struct scsi_nl_hdr *hdr);
> -int scsi_nl_send_vendor_msg(u32 pid, unsigned short host_no, u64 ven=
dor_id,
> -			 char *data_buf, u32 data_len);
> +void scsi_nl_send_transport_msg(__u32 pid, struct scsi_nl_hdr *hdr);
> +int scsi_nl_send_vendor_msg(__u32 pid, unsigned short host_no, __u64=
 vendor_id,
> +			 char *data_buf, __u32 data_len);
> =20
>  #endif /* __KERNEL__ */
> =20

Boaz
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
