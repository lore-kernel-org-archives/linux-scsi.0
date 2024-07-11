Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0AE12D205;
	Thu, 11 Jul 2024 17:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720720257; cv=none; b=Z21wJISvQOtkfSaBAyFIou1wNWwILNwVQLHxEI7ObWQtdVts18u7c1Fke0ZpObXDqggeL/cKTLP5Xq0tBlk12quFGJOq64RcCJyd5igA/coVhXzCxxF7EoWgZUFg6QloqjfQjXBfepSXISR4qAczQpdkXho+bRP0PwmDP4NyM5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720720257; c=relaxed/simple;
	bh=zw3FtwYQQ8rtj5yJV4VfCVdwI6K6bNrTvRLVgyKesao=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OaAEtHHYzFT9GqbUhDjD+VSbfyCA/PZyJ1Xwzw2zZcNu8+i3cjN/cQdvPVgw60BtZx4JZXmvIZDxqoc11go5JxhNX3U2C9vbL5ZEmqyoil9sOU863tEDX5GW5KBTj//YYjpjVYLSZVKqREmItw86Xio81Z8z0PDHAC5NsMOTGEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J7K2AzWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J7K2AzWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C3BC116B1;
	Thu, 11 Jul 2024 17:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720720257;
	bh=zw3FtwYQQ8rtj5yJV4VfCVdwI6K6bNrTvRLVgyKesao=;
	h=From:To:Cc:Subject:Date:From;
	b=J7K2AzWNgwfFTaklSmHUdptKcm8VMzsJz1l05l3cSBdpZt7Bel7py6e9FrG9oKV8G
	 LGQZRTUqb6JDI/GO8hmxMKqy28hO1krhApo8guyTKuhzLTJC+wSZDyWAEEPswsJtpH
	 SKJd3Byi+TBh9idxmgm25VjoigVHU4Io6k+btI6gV/X1PXdgYmrN4KFG5nmuKAoUeJ
	 UOXjM8b10/8S1XpAwIJfqs0oPXgHZeqCaj1gbMtO6M2Xo/LAFJ1M9+BWWeYqrVuh30
	 h65utAsCyDmMmGtlOWdb+vLX9l2BS4SF4guL0370rkMXaPRyeWbITVu7A3ZCQNQS6r
	 Ok/aUmuNSgO/g==
From: Kees Cook <kees@kernel.org>
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: Kees Cook <kees@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: aacraid: struct aac_ciss_phys_luns_resp: Replace 1-element array with flexible array
Date: Thu, 11 Jul 2024 10:50:55 -0700
Message-Id: <20240711175055.work.928-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1636; i=kees@kernel.org; h=from:subject:message-id; bh=zw3FtwYQQ8rtj5yJV4VfCVdwI6K6bNrTvRLVgyKesao=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkBt/7P6HwP5fZjHYrd+TQjHDP6HwDyOaTMlW3 5v2UmYtxmuJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAbfwAKCRCJcvTf3G3A JrZmEACxSg9VUUP6muCtUOlV41Vgh8ItMIdOqk2WCpY67B5Wf2edl//1XYrvX8dl4KfrORV1jK/ hvgAW1LQjIk5Y1SVeSlajpS8Y14li+J+chzKcc2LDsBH7cCB/4cw6OGWIJOvVz+5qAxXvRv2sV8 S8+ijVt3AG7PwZNucuQBRw73SavAtqYswCkhAb2xQB8EYOXbBy8Ap9FleGPOitm8L3MNamA+QQn S0IZ4GS1fuNsCxYhAJ9IL23qbDyVPNWNILA2wDRNofb0WcBLhDGVL4Ui031c2Pb8Qdwfd08LwWx zZWYT+46swVc7qIEkOAq6zF0LyewMNoacesjJkKoOodXr64iEEvODGV6YCFVE14Gdk+PeCcrBqt G09CSAKenKVD+UnTeSmMcco3G9YM5FCcsU6JALTGwl+Q3IuTZjm/2J+cXcLcfs1AwJzQTvQ8EM3 edrdeB6uXeFhK/Gg3BDsmwBx18ubeXYkhWaQNhiVK2jZsp99Jcy7EAeNomscQD92e9hXAbdKhrs L802pD0trm8gJDH6DtHQmUsAJe2L4xAIDFvrjTVFfjwVyG8y+bSUktHPdjJ7R4c1VppIdTG0v2W x8UaDUSn33dXVt/97SyOueXIDvC4IkeIl2fl//u91GkpgkHO6w4zYF2H6jHUW2nlPktQtpl1Srl 7WXx2sEcdmpwY
 jA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
struct aac_ciss_phys_luns_resp with a modern flexible array.

No binary differences are present after this conversion.

Link: https://github.com/KSPP/linux/issues/79 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aacraid/aachba.c  | 2 +-
 drivers/scsi/aacraid/aacraid.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index b22857c6f3f4..497c6dd5df91 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1833,7 +1833,7 @@ static int aac_get_safw_ciss_luns(struct aac_dev *dev)
 	struct aac_ciss_phys_luns_resp *phys_luns;
 
 	datasize = sizeof(struct aac_ciss_phys_luns_resp) +
-		(AAC_MAX_TARGETS - 1) * sizeof(struct _ciss_lun);
+		AAC_MAX_TARGETS * sizeof(struct _ciss_lun);
 	phys_luns = kmalloc(datasize, GFP_KERNEL);
 	if (phys_luns == NULL)
 		goto out;
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 659e393c1033..6f0417f6f8a1 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -322,7 +322,7 @@ struct aac_ciss_phys_luns_resp {
 		u8	level3[2];
 		u8	level2[2];
 		u8	node_ident[16];	/* phys. node identifier */
-	} lun[1];			/* List of phys. devices */
+	} lun[];			/* List of phys. devices */
 };
 
 /*
-- 
2.34.1

