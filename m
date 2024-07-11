Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4780E16C86D;
	Thu, 11 Jul 2024 15:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720713523; cv=none; b=lUUwXior2QVuPO75WEIYUpW/3nE+2PB7zbYk5OasisaJxqFSqi5rOTm9gLXmQpHXm/xy+DRBfRQXi6YWR+spiihCok7HPecGkCB9uJ2iJliIkd8ghXACHjLj9tztG3/lKCXRaFf/LRzAVnUMtOaA9v5O4LKTe8OXlqDzY+DH4Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720713523; c=relaxed/simple;
	bh=CunY4G+gqpiRcK7X2LRA61N3HupLiTL49t1l/FRn8AY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JGcO4tfFGnBYngsMq1RLeVPkqE+RNdFxI3x7nK9Z1zYQAOuUppNnppp6zfg+MbhAjs1kGU8WNmeHACHXgWdMrTDorJm9+ziovyS74rvMTkiOlv0GR5a3N2oJHsX+pCRe8/DgvVfqqY30K6wt8jB5Zm/IZ6sBqXYN8vkZDtcieO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Di3y8l6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Di3y8l6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DF1C116B1;
	Thu, 11 Jul 2024 15:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720713523;
	bh=CunY4G+gqpiRcK7X2LRA61N3HupLiTL49t1l/FRn8AY=;
	h=From:To:Cc:Subject:Date:From;
	b=Di3y8l6pG73yYs5g4AcmoAm1QIavPM05KxxMv2jbPTsGpXzlM7hTWR585EH7oLSwu
	 yTWRmoHy8aMxe9KlcsSp304FirLTG833wNHEB/tOUwNn4j+ait+aoR3Kmz0PsEueVm
	 rgjAnD/hO2tN9x5VyE48/ize+iYMg8cGetLN3Q1LcLA7bnYNBKhkQfxAu+M45wBif1
	 uKwDVg2Wm+nxNXu/DV4zcNfpYlLXt/hfAcfHfxE3w+jiURpBqSBcO7wdfpoiPtNVDF
	 SxVb5JeDswnulQueX6jxwSyCR2FJgoz+Y1aHNJEkxkR4B45MeEWcYBdU0bFZrSPnq4
	 kCcPdQnVZ8Psg==
From: Kees Cook <kees@kernel.org>
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Kees Cook <kees@kernel.org>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: megaraid_sas: struct MR_HOST_DEVICE_LIST: Replace 1-element array with flexible array
Date: Thu, 11 Jul 2024 08:58:42 -0700
Message-Id: <20240711155841.work.839-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1957; i=kees@kernel.org; h=from:subject:message-id; bh=CunY4G+gqpiRcK7X2LRA61N3HupLiTL49t1l/FRn8AY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkAExGCg9vY+j99g8f7642ncMXfWXGLWx8hVx2 VF+qBJpZY+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpABMQAKCRCJcvTf3G3A Ju7kD/9OcxKezH9toLXporFk1T8xOboAeH9DgB1gSzzANeN02pGxTaGhwbuARni8ppJb7i3rKIR 9ZzteWJsddpR3eRKm4HzN+JKhtvGLZzPA5PFbY5wRCrRwS31paEBsD57xJE2u8Eehq3reo8Jkbn 2fgzXSHWJq9ldVMOhptW1A5v7I3c5Z0hhlWJ1tHfhVqywAGA2zmFVL4Xw2wMdjSb5AIzUOimWP5 MiAzrmdpi8aZpwTmS8VVNM1gmV5XdCk67foGUUneHoglskyHET0Gpjdv4u0vmpgkSmJaXBugM7W dBe5JZgelTe6nKaE17YYUadkrxi/nB4iZdyEMk32iqJwNzBrJ5p1STtxDh2Buyer1NPMvPOopYf wyVzssCHtFfxciqpzAn1Jsgm/rt/TypMeW2QzoSB7ovKhh7CZfiw4NBFLl7T5vdjAarE5MelHwR 2aUr54LYTp462Z1SnwjEhJmnCRpA3oBHhYlk0rh/eXeXaBj2epeKVBetZRNscrYmABh5mz++hlo UsaGaq9Ak4JnOPoKkQLUI2+7Dby7ANtWpZ5f4+9ormgrx1TupNKOlGUtGM+vC2dRn6R++ns6pc8 mefru6JGEBfFSH6tWRsf4xLgGE5YLddeYlNH4RQlwqLdZ1oBpNUrMqzPNj7QI9GVYoThG7/1Us9 dj2Nn2xyB3UHc
 2g==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
struct MR_HOST_DEVICE_LIST with a modern flexible array.

One binary difference appears in megasas_host_device_list_query():

        struct MR_HOST_DEVICE_LIST *ci;
	...
        ci = instance->host_device_list_buf;
	...
        memset(ci, 0, sizeof(*ci));

The memset() clears only the non-flexible array fields. Looking at the
rest of the function, this appears to be fine: firmware is using this
region to communicate with the kernel, so it likely never made sense to
clear the first MR_HOST_DEVICE_LIST_ENTRY.

Link: https://github.com/KSPP/linux/issues/79 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: megaraidlinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 84cf77c48c0d..088cc40ae866 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -814,12 +814,12 @@ struct MR_HOST_DEVICE_LIST {
 	__le32			size;
 	__le32			count;
 	__le32			reserved[2];
-	struct MR_HOST_DEVICE_LIST_ENTRY	host_device_list[1];
+	struct MR_HOST_DEVICE_LIST_ENTRY	host_device_list[] __counted_by_le(count);
 } __packed;
 
 #define HOST_DEVICE_LIST_SZ (sizeof(struct MR_HOST_DEVICE_LIST) +	       \
 			      (sizeof(struct MR_HOST_DEVICE_LIST_ENTRY) *      \
-			      (MEGASAS_MAX_PD + MAX_LOGICAL_DRIVES_EXT - 1)))
+			      (MEGASAS_MAX_PD + MAX_LOGICAL_DRIVES_EXT)))
 
 
 /*
-- 
2.34.1

