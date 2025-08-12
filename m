Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41522D46A2;
	Tue, 12 Aug 2025 14:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755008022; cv=none; b=pqURJBLi4eT/vujxaP9Dkj1xipO5GzSyew4Uu0VNEZt66lAAtEZm+Hk+fxAkhm66HH6tzormxkAs08QAnipUK4TTVTGU7CAbQnyiaFRTcVcF7etktPy01hs8TLGzm0gRw74hQnshZmYTefMyzxnEkudr90sc7DZZJc4ZZB2FIJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755008022; c=relaxed/simple;
	bh=/E8ODUHv0/aKECOWNenhubhKtwKSn9HS1K3Gi+YJTHg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=etvaaH8mCAES4HJn1/vDNDdXG0NllDIVcds6//Y09aUkK+71zsSYWWVMuYs21pncov6Bc2//aAclNU/TvddatAagXHW6BjjCU8g9b0xufbHqmnk3Qhx83xc0hfNQhxSVnP7Z6je5YBrJccL20x4PgzZLZO5jnd074n4lnwV1jkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1zqQJXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1zqQJXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C986C4CEF0;
	Tue, 12 Aug 2025 14:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755008022;
	bh=/E8ODUHv0/aKECOWNenhubhKtwKSn9HS1K3Gi+YJTHg=;
	h=Date:From:To:Cc:Subject:From;
	b=A1zqQJXAFSATCRyyy3JRw5dP4oLOwgvcEkzCttMl5hen7T5lTWM7/0Sfr0COfPdM8
	 RBFdNpbHF3vbiLYmoYQBHLVrIBDzebuXxCDOM9w/JFCmSUAu6vr7/mx0xK6/Skiz3J
	 rBB99Z0LT2JDgozPwMaIOxyfiw82qGlbukVyUpTgsdXpweGVRGBg0JqkL4vDpsIbTl
	 2ECEaUgtIYp8hW2aCnd12vZ7g6GyXnc49cd3FpnKQoVjDkAVRykw/z0Ac549qIkMKh
	 nIGbkpEJwg3rxXaL+At2p+PJrYlsjAy9ffSuUaKwtwmjvm9EowmjzODiT2QaPmMPix
	 ROwCDX+lDo1CQ==
Date: Tue, 12 Aug 2025 23:13:37 +0900
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: fc: Avoid -Wflex-array-member-not-at-end warnings
Message-ID: <aJtMETERd-geyP1q@kspp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-Wflex-array-member-not-at-end has been introduced in GCC-14, and we
are getting ready to enable it, globally.

So, in order to avoid ending up with a flexible-array member in the
middle of multiple other structs, we use the `__struct_group()`
helper to create a new tagged `struct fc_df_desc_fpin_reg_hdr`.
This structure groups together all the members of the flexible
`struct fc_df_desc_fpin_reg` except the flexible array.

As a result, the array is effectively separated from the rest of the
members without modifying the memory layout of the flexible structure.
We then change the type of the middle struct members currently causing
trouble from `struct fc_df_desc_fpin_reg` to `struct
fc_df_desc_fpin_reg_hdr`.

We also want to ensure that in case new members need to be added to the
flexible structure, they are always included within the newly created
tagged struct. For this, we use `_Static_assert()`. This ensures that
the memory layout for both the flexible structure and the new tagged
struct is the same after any changes.

This approach avoids having to implement `struct fc_df_desc_fpin_reg_hdr`
as a completely separate structure, thus preventing having to maintain
two independent but basically identical structures, closing the door
to potential bugs in the future.

The above is also done for flexible `struct fc_els_rdf`.

So, with these changes, fix the following warnings:
drivers/scsi/lpfc/lpfc_hw4.h:4936:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/scsi/lpfc/lpfc_hw4.h:4942:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/scsi/lpfc/lpfc_hw4.h:4947:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hw4.h  |  4 ++--
 include/uapi/scsi/fc/fc_els.h | 40 ++++++++++++++++++++++++-----------
 2 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index dcd7204d4eec..e319858c88ba 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4909,13 +4909,13 @@ struct send_frame_wqe {
 
 #define ELS_RDF_REG_TAG_CNT		4
 struct lpfc_els_rdf_reg_desc {
-	struct fc_df_desc_fpin_reg	reg_desc;	/* descriptor header */
+	struct fc_df_desc_fpin_reg_hdr	reg_desc;	/* descriptor header */
 	__be32				desc_tags[ELS_RDF_REG_TAG_CNT];
 							/* tags in reg_desc */
 };
 
 struct lpfc_els_rdf_req {
-	struct fc_els_rdf		rdf;	   /* hdr up to descriptors */
+	struct fc_els_rdf_hdr		rdf;	   /* hdr up to descriptors */
 	struct lpfc_els_rdf_reg_desc	reg_d1;	/* 1st descriptor */
 };
 
diff --git a/include/uapi/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_els.h
index 16782c360de3..81b9f87943f4 100644
--- a/include/uapi/scsi/fc/fc_els.h
+++ b/include/uapi/scsi/fc/fc_els.h
@@ -11,6 +11,12 @@
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
+#ifdef __KERNEL__
+#include <linux/stddef.h>	/* for offsetof */
+#else
+#include <stddef.h>		/* for offsetof */
+#endif
+
 /*
  * Fibre Channel Switch - Enhanced Link Services definitions.
  * From T11 FC-LS Rev 1.2 June 7, 2005.
@@ -1109,12 +1115,15 @@ struct fc_els_fpin {
 
 /* Diagnostic Function Descriptor - FPIN Registration */
 struct fc_df_desc_fpin_reg {
-	__be32		desc_tag;	/* FPIN Registration (0x00030001) */
-	__be32		desc_len;	/* Length of Descriptor (in bytes).
-					 * Size of descriptor excluding
-					 * desc_tag and desc_len fields.
-					 */
-	__be32		count;		/* Number of desc_tags elements */
+	/* New members MUST be added within the __struct_group() macro below. */
+	__struct_group(fc_df_desc_fpin_reg_hdr, hdr, /* no attrs */,
+		__be32		desc_tag; /* FPIN Registration (0x00030001) */
+		__be32		desc_len; /* Length of Descriptor (in bytes).
+					   * Size of descriptor excluding
+					   * desc_tag and desc_len fields.
+					   */
+		__be32		count;	  /* Number of desc_tags elements */
+	);
 	__be32		desc_tags[];	/* Array of Descriptor Tags.
 					 * Each tag indicates a function
 					 * supported by the N_Port (request)
@@ -1124,19 +1133,26 @@ struct fc_df_desc_fpin_reg {
 					 * See ELS_FN_DTAG_xxx for tag values.
 					 */
 };
+_Static_assert(offsetof(struct fc_df_desc_fpin_reg, desc_tags) == sizeof(struct fc_df_desc_fpin_reg_hdr),
+	      "struct member likely outside of __struct_group()");
 
 /*
  * ELS_RDF - Register Diagnostic Functions
  */
 struct fc_els_rdf {
-	__u8		fpin_cmd;	/* command (0x19) */
-	__u8		fpin_zero[3];	/* specified as zero - part of cmd */
-	__be32		desc_len;	/* Length of Descriptor List (in bytes).
-					 * Size of ELS excluding fpin_cmd,
-					 * fpin_zero and desc_len fields.
-					 */
+	/* New members MUST be added within the __struct_group() macro below. */
+	__struct_group(fc_els_rdf_hdr, hdr, /* no attrs */,
+		__u8		fpin_cmd;	/* command (0x19) */
+		__u8		fpin_zero[3];	/* specified as zero - part of cmd */
+		__be32		desc_len;	/* Length of Descriptor List (in bytes).
+						 * Size of ELS excluding fpin_cmd,
+						 * fpin_zero and desc_len fields.
+						 */
+	);
 	struct fc_tlv_desc	desc[];	/* Descriptor list */
 };
+_Static_assert(offsetof(struct fc_els_rdf, desc) == sizeof(struct fc_els_rdf_hdr),
+	       "struct member likely outside of __struct_group()");
 
 /*
  * ELS RDF LS_ACC Response.
-- 
2.43.0

