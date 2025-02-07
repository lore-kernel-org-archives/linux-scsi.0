Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBAF27442;
	Fri,  7 Feb 2025 01:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738890023; cv=none; b=m0E5tfS6oj7IHSShbTt4Oc3G/yu+nBIzXI5Z8ADM7pOsPq7s/a+NtU7N9riktkZTBI5QUX3KZFnlQr0WOciWZYiXPp2UqEcNqV4lxPgKSu7JvF7RvxBQL5EjZRnxOzphRvBs1EgcEdd3lLqPE7FQ2dzLY99tXz0BX5+PfrovehI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738890023; c=relaxed/simple;
	bh=tN5HoDasgGs57yWRv1TCfAho0gjol32j6KoFqgeXgFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Btu+z+y36O8dgPTPoQgYRINJKuH9E0jdw26ZhP9azlIsAtUIHqyQbhtcdcw43xG5mt2KsC9Q9nXHS2d5l4hvD9QSVcUafJ3UIBTEXOLoLR34XYW9ZJ9XZ+kpMce542HBuPhWQlvNkTrNTiyz5YQor4YP42HAQZmwDkIPYbTYqhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pj4LWa1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pj4LWa1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63DBC4CEDD;
	Fri,  7 Feb 2025 01:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738890022;
	bh=tN5HoDasgGs57yWRv1TCfAho0gjol32j6KoFqgeXgFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pj4LWa1Eap7F2oZPp49MBSTEHcl75OuXc+G9fNce/PSm+Kj5CioqbdpAcasNihaAO
	 7+lBjoo2VJVpOs/mp8uDi++SXwZvWxDf9l15hEJpyTSalXhXkJ9SFhVn8UKdcsZ2R1
	 SsHHsiwSCHBT3RbNW84ZEQOyZoOwy8TABRLSbxeyKChSkXfFsV8iAIqRDzI4xowByA
	 SxwAjQ5A99TGnEsgFLqzHhjQnntG5UAKmLreBUgiyZx55jWW2nagc+Lw9jxcINARgj
	 d3YGNATPFL8B8wmzefd58Xla8AwvsFDzH9JzEK0vxJwqJ3t1+X5XFDkw6bwnNL/gSm
	 rn8z+ZRxRDZNw==
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Tadeusz Struk <tadeusz.struk@linaro.org>,
	kernel test robot <lkp@intel.com>,
	Erick Archer <erick.archer@outlook.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	linux-kernel@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-hardening@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-nilfs@vger.kernel.org
Subject: [PATCH 01/10] scsi: mptfusion: Mark device strings as nonstring
Date: Thu,  6 Feb 2025 17:00:10 -0800
Message-Id: <20250207010022.749952-1-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250207005832.work.324-kees@kernel.org>
References: <20250207005832.work.324-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1366; i=kees@kernel.org; h=from:subject; bh=tN5HoDasgGs57yWRv1TCfAho0gjol32j6KoFqgeXgFQ=; b=owGbwMvMwCVmps19z/KJym7G02pJDOlLo+VlwhV7zqecu3Bw1pVpTwO3P85fNf+ZM8sjl1eHl pqLrXbf2FHKwiDGxSArpsgSZOce5+Lxtj3cfa4izBxWJpAhDFycAjCR89kM/xTXvzi0LvxvpzK7 teLqAuulj9nW/Fva1TyVa/OD4p7+1UaMDLdmrSlZobF8aoahY3+PRmFYz9YCxvxnFe+ZldmDvig p8gIA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for memtostr*() checking that its source is marked as
nonstring, annotate the device strings accordingly.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/message/fusion/mptsas.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index d0549a4daf76..9e3a823ca4eb 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2834,10 +2834,10 @@ struct rep_manu_reply{
 	u8 sas_format:1;
 	u8 reserved1:7;
 	u8 reserved2[3];
-	u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN];
-	u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN];
-	u8 product_rev[SAS_EXPANDER_PRODUCT_REV_LEN];
-	u8 component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN];
+	u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN] __nonstring;
+	u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN] __nonstring;
+	u8 product_rev[SAS_EXPANDER_PRODUCT_REV_LEN] __nonstring;
+	u8 component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN] __nonstring;
 	u16 component_id;
 	u8 component_revision_id;
 	u8 reserved3;
-- 
2.34.1

