Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2802628E7;
	Wed, 27 Aug 2025 06:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756275060; cv=none; b=Ngex9Iop19msWLYAyCtIZlcxdl5TIZTfg/NBY+R9uLSx0UgiDYxx8T+UpRlOd/dGQRjJhcFQJt3qbdj9kQaEbZcHz+FiSyroi2YKcY7y73xYpL0GbE/Tc55Lo1/sL4coz+TMB0zMs0SFn9X3C5uHIFGBqfBOvascM6RtDLjz0gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756275060; c=relaxed/simple;
	bh=+GN6jtKxkDuSkcNSTpi1Xi9ELLdwSX5uB0MS/o2bNe0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZYDWWqCrh5OA8LdBQubBwk3UJOXJYyDob8r8J2GGV8e7X5sH3/K/wIpHIAxGo+K/krN++a1x49dmB8V/VK+NbMWx1hKLrEohumnCHqkaY64pAQf25ZxjP8Q613QG0Dz6q1LuBG/tVY3ZQJOY54un4wIh61o/FUJVMoLYyIqG6+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aEJzbIXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aEJzbIXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97187C4CEEB;
	Wed, 27 Aug 2025 06:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756275059;
	bh=+GN6jtKxkDuSkcNSTpi1Xi9ELLdwSX5uB0MS/o2bNe0=;
	h=Date:From:To:Cc:Subject:From;
	b=aEJzbIXSNAX5Fe5bBerVT3Ij4GUapE7v79aSjBOuGmQCIB/OT1V1MzmOcpuzhCNqS
	 C11qJjbairy6TcVhdFhM+4T01Ubb8POAdpBwmkAgKNj/XKlRVOt4pdEjgafwT5sxFV
	 0UBdpJutZev0TSEo0ht3FLhy8bnbVEPxObk30CFbC4xRf/ILUmBzu6CGGLWALB1fBG
	 S9tibtlJ26enSAW/DddNBC5qR1gXcNl9/m1EUwZpEi1+aT9gOgEBZF9wJDb+EGxFpC
	 up7V0/P4NUaegaEdkKqKM8N02lW0c3bztoWTsqOHm3sh0awe/k8fjyCE+8DChylybq
	 ZBZDr4or6okOQ==
Date: Wed, 27 Aug 2025 08:10:53 +0200
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Justin Tee <justin.tee@broadcom.com>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2] scsi: fc: Avoid -Wflex-array-member-not-at-end warnings
Message-ID: <aK6hbQLyQlvlySf8@kspp>
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

The above is also done for flexible structures `struct fc_els_rdf` and
`struct fc_els_rdf_resp`

So, with these changes, fix the following warnings:
drivers/scsi/lpfc/lpfc_hw4.h:4936:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/scsi/lpfc/lpfc_hw4.h:4942:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
drivers/scsi/lpfc/lpfc_hw4.h:4947:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Implement the same changes for `struct fc_els_rdf_resp`
 - Fix size calculation in lpfc_issue_els_rdf(). (Justin Tee)

v1:
 - Link: https://lore.kernel.org/linux-hardening/aJtMETERd-geyP1q@kspp/

 include/uapi/scsi/fc/fc_els.h | 58 +++++++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_els.c  |  2 +-
 drivers/scsi/lpfc/lpfc_hw4.h  |  6 ++--
 3 files changed, 43 insertions(+), 23 deletions(-)

diff --git a/include/uapi/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_els.h
index 16782c360de3..019096beb179 100644
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
+	__struct_group(fc_df_desc_fpin_reg_hdr, __hdr, /* no attrs */,
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
@@ -1124,33 +1133,44 @@ struct fc_df_desc_fpin_reg {
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
+	__struct_group(fc_els_rdf_hdr, __hdr, /* no attrs */,
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
  */
 struct fc_els_rdf_resp {
-	struct fc_els_ls_acc	acc_hdr;
-	__be32			desc_list_len;	/* Length of response (in
-						 * bytes). Excludes acc_hdr
-						 * and desc_list_len fields.
-						 */
-	struct fc_els_lsri_desc	lsri;
+	/* New members MUST be added within the __struct_group() macro below. */
+	__struct_group(fc_els_rdf_resp_hdr, __hdr, /* no attrs */,
+		struct fc_els_ls_acc	acc_hdr;
+		__be32			desc_list_len;	/* Length of response (in
+							 * bytes). Excludes acc_hdr
+							 * and desc_list_len fields.
+							 */
+		struct fc_els_lsri_desc	lsri;
+	);
 	struct fc_tlv_desc	desc[];	/* Supported Descriptor list */
 };
-
+_Static_assert(offsetof(struct fc_els_rdf_resp, desc) == sizeof(struct fc_els_rdf_resp_hdr),
+	       "struct member likely outside of __struct_group()");
 
 /*
  * Diagnostic Capability Descriptors for EDC ELS
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index fca81e0c7c2e..432761fb49de 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3762,7 +3762,7 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 	memset(prdf, 0, cmdsize);
 	prdf->rdf.fpin_cmd = ELS_RDF;
 	prdf->rdf.desc_len = cpu_to_be32(sizeof(struct lpfc_els_rdf_req) -
-					 sizeof(struct fc_els_rdf));
+					 sizeof(struct fc_els_rdf_hdr));
 	prdf->reg_d1.reg_desc.desc_tag = cpu_to_be32(ELS_DTAG_FPIN_REGISTER);
 	prdf->reg_d1.reg_desc.desc_len = cpu_to_be32(
 				FC_TLV_DESC_LENGTH_FROM_SZ(prdf->reg_d1));
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index bc709786e6af..a7f7ed86d2b0 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4909,18 +4909,18 @@ struct send_frame_wqe {
 
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
 
 struct lpfc_els_rdf_rsp {
-	struct fc_els_rdf_resp		rdf_resp;  /* hdr up to descriptors */
+	struct fc_els_rdf_resp_hdr	rdf_resp;  /* hdr up to descriptors */
 	struct lpfc_els_rdf_reg_desc	reg_d1;	/* 1st descriptor */
 };
 
-- 
2.43.0

