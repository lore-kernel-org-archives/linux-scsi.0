Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDA81ADC69;
	Wed,  9 Apr 2025 11:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744198477; cv=none; b=kh+HXgJUspWnR1SBJGEGS/65aFu8VTRjwfKZNtUYV7XL3haCY2YskA6Ox/i0DI9Ymv98D1pRK1A0zGYn+MPJw8fEhYOqNiAVxODxXcim6yLL33SJV0NPJhG8uyEbP12LPgfj5HTgcvGMPeqccUEJFpm7Ue5BQYLxQyGSKs/F/tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744198477; c=relaxed/simple;
	bh=ldQOuMU1V/wykRweN8hfixQFqEoqp3TUi6IEIIuB9Es=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Gb82hSpq3CXAZEvE004TBZix8kObNfK1kKxqNuP5KxR10Fn+MvkCFfx0XkaF6GNtEGUg5EHSQ+9IvhYMwaFfWudav5A03wwwc1rLY3ocv/uqAkaiECbgvsusk8KqQqrEblHWShoMTxY9wMO7aPOwwAUf6hPfNuKyoTmgnqxOCmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SoKcoMj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SoKcoMj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1795BC4CEE3;
	Wed,  9 Apr 2025 11:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744198476;
	bh=ldQOuMU1V/wykRweN8hfixQFqEoqp3TUi6IEIIuB9Es=;
	h=From:Date:Subject:To:Cc:From;
	b=SoKcoMj4+RZxUYNdTU7IS0QNaB75sRugMkd98ZwP6Kjucc9PmJoX3nvGGrI5x03GZ
	 KC+99ptFvVWr0pQ8/tUo7UXRBm94BXTcdX4TgTW19yZHcau92Y7HefLJHafdCkHbXp
	 g95O+TSCNlxrVrBQFL8PJ2SyP1qa8lMBkyCu5QFBYLUfCYspVf8LuWRQkEJS+9XKxs
	 74yHqQJoHASj0MzhlQ9qNPZYW34U5F1JiJ78s60guCZEJZri6NjI/7TVIqrz3mhkFr
	 V3Tw9ILj7M69qn5AIWvCsPIkhQC0MJi/zSEQq6zTToKWpR0ujn7Z7rfz2spf/b9V3d
	 ylnpxQwYze8pQ==
From: Daniel Wagner <wagi@kernel.org>
Date: Wed, 09 Apr 2025 13:34:22 +0200
Subject: [PATCH] lpfc: use memcpy for bios version
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250409-fix-lpfc-bios-str-v1-1-05dac9e51e13@kernel.org>
X-B4-Tracking: v=1; b=H4sIAD1b9mcC/x2MQQqAIBAAvyJ7bsG0IvtKdChbayEq3Igg/HvSc
 WBmXhCKTAKdeiHSzcLHnqEsFPh13BdCnjOD0abWlXYY+MHtDB4nPgTlimitDs3o5taZALk7I2X
 pf/ZDSh9dGDyRYwAAAA==
X-Change-ID: 20250409-fix-lpfc-bios-str-330f6a9d892f
To: James Smart <james.smart@broadcom.com>, 
 Dick Kennedy <dick.kennedy@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Daniel Wagner <wagi@kernel.org>
X-Mailer: b4 0.14.2

The strlcat with FORTIFY support is triggering a panic because it thinks
the target buffer will overflow although the correct target buffer
size is passed in.

Anyway, instead memset with 0 followed by a strlcat, just use memcpy and
ensure that the resulting buffer is NULL terminated.

BIOSVersion is only used for the lpfc_printf_log which expects a
properly terminated string.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 6574f9e744766d49e245bd648667cc3ffc45289e..a335d34070d3c5fa4778bb1cb0eef797c7194f3b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6003,9 +6003,9 @@ lpfc_sli4_get_ctl_attr(struct lpfc_hba *phba)
 	phba->sli4_hba.flash_id = bf_get(lpfc_cntl_attr_flash_id, cntl_attr);
 	phba->sli4_hba.asic_rev = bf_get(lpfc_cntl_attr_asic_rev, cntl_attr);
 
-	memset(phba->BIOSVersion, 0, sizeof(phba->BIOSVersion));
-	strlcat(phba->BIOSVersion, (char *)cntl_attr->bios_ver_str,
+	memcpy(phba->BIOSVersion, cntl_attr->bios_ver_str,
 		sizeof(phba->BIOSVersion));
+	phba->BIOSVersion[sizeof(phba->BIOSVersion) - 1] = '\0';
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 			"3086 lnk_type:%d, lnk_numb:%d, bios_ver:%s, "

---
base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
change-id: 20250409-fix-lpfc-bios-str-330f6a9d892f

Best regards,
-- 
Daniel Wagner <wagi@kernel.org>

