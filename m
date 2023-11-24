Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mFFtnsM5"
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AC9D5A;
	Fri, 24 Nov 2023 01:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700816995; x=1732352995;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QYDq6Z5tWNEhZ/J5NePC3bRbFwseCQaqr4/k79zRT+I=;
  b=mFFtnsM5WrosV8S5HFysiMce0CybzIRKWfVqR+R1EaJ8RLYPv57i1vPq
   Tk1iknXmx0PqOPk4ZBYxLQPeU6bjmi/CKKAE1FaKAbsHs7+SOSMtvyGTm
   S35YzVGCtbAn2H+NgR/JY1ZxTtAyBQUBpJRyJJin+n0FXLn5y/MZGEQKW
   3+i3dDLACIDEH1GJyYPaVL6Eh7xKN4beZnP0EXU5tLsH9g5p9LntvNY3V
   iYjpY3h/vbJ9IwxH5CjbWT8qHBLAtVzGVdduvxl+sbEtgjfKMXjzmGq6K
   T9RxboqHsPGo5PGKBUsMz0eOYQyeKE3Ipz1PALXVhkJchmyG/hAM/96co
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="478603449"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="478603449"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2023 01:09:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="15911569"
Received: from mvlasov-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.220.89])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2023 01:09:52 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 4/6] scsi: lpfc: Use PCI_HEADER_TYPE_MFD instead of literal
Date: Fri, 24 Nov 2023 11:09:16 +0200
Message-Id: <20231124090919.23687-4-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231124090919.23687-1-ilpo.jarvinen@linux.intel.com>
References: <20231124090919.23687-1-ilpo.jarvinen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Replace literal 0x80 with PCI_HEADER_TYPE_MFD.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9386e7b44750..4ac6afd3c2fe 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4875,7 +4875,7 @@ void lpfc_reset_barrier(struct lpfc_hba *phba)
 	lockdep_assert_held(&phba->hbalock);
 
 	pci_read_config_byte(phba->pcidev, PCI_HEADER_TYPE, &hdrtype);
-	if (hdrtype != 0x80 ||
+	if (hdrtype != PCI_HEADER_TYPE_MFD ||
 	    (FC_JEDEC_ID(phba->vpd.rev.biuRev) != HELIOS_JEDEC_ID &&
 	     FC_JEDEC_ID(phba->vpd.rev.biuRev) != THOR_JEDEC_ID))
 		return;
-- 
2.30.2

