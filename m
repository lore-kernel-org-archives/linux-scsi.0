Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB7E200CD;
	Fri,  7 Feb 2025 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738890023; cv=none; b=A9LQQS7i9kHCDFD6ozYWrsNI8fJHHCugkGSAqQeFW8digNqbudUVOGas0WQzZlPMn9WeW7PC9qmuT1QjtvJj48XqfvLPbZx5g0ZI+uHhIJYu7NEb+2E12Ms6NhPtivRxPiM/mXqpw6opRunfJ67OezJiP1fcvVbUmxa8clntJ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738890023; c=relaxed/simple;
	bh=hodZU7GQjZAKYVi5akVklCZ+GiDLGTui0BikdPpJ14c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b+2sxc93zUda0cuZsX9CZH/c99nqKvagXKRFn7kZ6GTNclb3rwjPkd/bBcfWTvXTWNxaGPY6U0KqzdWYpZIDQ15V7r6Ax4qwcGfQM4oML2cxopNtDaX365qoss3CENr/E9CmGZkEgOvMOmBiul4ya4wi8myV4lc7CEsAw1zmfqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uSjQsoxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uSjQsoxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F79C4CEE4;
	Fri,  7 Feb 2025 01:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738890023;
	bh=hodZU7GQjZAKYVi5akVklCZ+GiDLGTui0BikdPpJ14c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSjQsoxW2kEoxwAcBMQ5Dnraq+NRXXUoLUs62pDQLDqR4+p3Bi6W+3CqLBWRC6c9R
	 kY8ER2vmVCYIk9CKMM1yZGFk6KTsZEb3tgn/NrUq4BUzMCjGo9FRCnOvICB1GGgcqq
	 NxFkypG/5UG2m5nThQp3TTcl9ESJ30lbJuZN28vIIT/gkb74rpfGHMB8UlmfqwMu3b
	 8ws/ZshiZEMqP+a9yDP//NTb58yS2M6fEOO1p7pS/SpCzs81ysJx8uiDESEveR+snd
	 fPUb4VnlBhqo6QukXnWUyfyvt6x6/z0LO1ubGjBwGtSEP6aoh+gM/I456MIYbz0Wjx
	 ao7M4jGOe7siA==
From: Kees Cook <kees@kernel.org>
To: Andy Shevchenko <andy@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
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
	MPT-FusionLinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-hardening@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-nilfs@vger.kernel.org
Subject: [PATCH 04/10] scsi: qla2xxx: Mark device strings as nonstring
Date: Thu,  6 Feb 2025 17:00:13 -0800
Message-Id: <20250207010022.749952-4-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250207005832.work.324-kees@kernel.org>
References: <20250207005832.work.324-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1092; i=kees@kernel.org; h=from:subject; bh=hodZU7GQjZAKYVi5akVklCZ+GiDLGTui0BikdPpJ14c=; b=owGbwMvMwCVmps19z/KJym7G02pJDOlLoxX0n158JD5V/Wf9u85oySd+7YwSZzfd4/8o6MSa5 v0/21Wso5SFQYyLQVZMkSXIzj3OxeNte7j7XEWYOaxMIEMYuDgFYCIdbxn+WTpdNvdlnCl1/8r6 HWvu/mIKO9Hga5TImPXcgWvm/56jkxgZ1k7mnOV4Unuq2IfQXzH7zbltci8t9s6895ejwOPq7LT tLAA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In preparation for memtostr*() checking that its source is marked as
nonstring, annotate the device strings accordingly.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/qla2xxx/qla_mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 4f63aff333db..3a2bd953a976 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -282,8 +282,8 @@ struct register_host_info {
 #define QLAFX00_TGT_NODE_LIST_SIZE (sizeof(uint32_t) * 32)
 
 struct config_info_data {
-	uint8_t		model_num[16];
-	uint8_t		model_description[80];
+	uint8_t		model_num[16] __nonstring;
+	uint8_t		model_description[80] __nonstring;
 	uint8_t		reserved0[160];
 	uint8_t		symbolic_name[64];
 	uint8_t		serial_num[32];
-- 
2.34.1

