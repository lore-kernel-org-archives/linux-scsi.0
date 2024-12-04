Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192CB22AFFC;
	Wed,  4 Dec 2024 17:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331818; cv=none; b=so+xxpnDGIZUxiZxOd1ynprqqi35n2BBhJWF4JVLYSIsuIaEDXz0QmLJRwwdFbuSvTDWk38YTG2n4gHrZ6xFiWgIXGXCSxCSBl4dyf7epyEk7nwP4/5PfTvqWBLTLXtDTh/GHfXtOy0X5vv+t/a1N5kxKe4rub3oa+fnwjXISFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331818; c=relaxed/simple;
	bh=sMXIAQELAnAIW0VzbUYlRGm/Tlv95nl0Fot/R0/b3Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rZ8Tw9LDbw2YmJUuAUIm9SGQADIOzI/feHAD33UCkZ+jrlttXA83jusouAaHWZF7QkdxXPI/wmNLHY0ZTS71Z6RoNzcQ1kZG6E3XC5+eykOPOyu1zlpqHHeCV5g5dCxm4hb1/cdghmLilflIu4eCn9EfGAgkciV4DQZsrFt/dqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DD3Q1cUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DD3Q1cUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08826C4CECD;
	Wed,  4 Dec 2024 17:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331818;
	bh=sMXIAQELAnAIW0VzbUYlRGm/Tlv95nl0Fot/R0/b3Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DD3Q1cUB0LOWn9VQ8tnHy5J5aAHUofuSpGh104PkKoGJcUvTpQGNt0nfJfivPGf5g
	 KAXp882HQFi8DzUDxP31tjXmOlsxePv0MqWB75Vvgd9pf4pUVxVdX7myopHNajKr4/
	 vapys5PdnO68ZYYxlscBtAS4HcdzZg1u56quHXNpUNuDSDvwkERoXuvPPrEnJ7DwXm
	 NIQH8Pn8+L26XJ6WoHto5rbmpO6/iBZtxZcOH9sV5HGibw+M/rqlTmTo377oaFZ65o
	 qR3SbcSC1MFmDQK03fGbTIFsfwE354eVb1PzGIXqDDIRnCZLBJKw1PET1KWSUBElGX
	 IPBYISfCbwHOA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 4/7] scsi: st: Don't modify unknown block number in MTIOCGET
Date: Wed,  4 Dec 2024 10:52:09 -0500
Message-ID: <20241204155213.2215170-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204155213.2215170-1-sashal@kernel.org>
References: <20241204155213.2215170-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.286
Content-Transfer-Encoding: 8bit

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit 5bb2d6179d1a8039236237e1e94cfbda3be1ed9e ]

Struct mtget field mt_blkno -1 means it is unknown. Don't add anything to
it.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219419#c14
Link: https://lore.kernel.org/r/20241106095723.63254-2-Kai.Makisara@kolumbus.fi
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 2121e44c342f8..4e0737c25fbdf 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3756,7 +3756,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		    ((STp->density << MT_ST_DENSITY_SHIFT) & MT_ST_DENSITY_MASK);
 		mt_status.mt_blkno = STps->drv_block;
 		mt_status.mt_fileno = STps->drv_file;
-		if (STp->block_size != 0) {
+		if (STp->block_size != 0 && mt_status.mt_blkno >= 0) {
 			if (STps->rw == ST_WRITING)
 				mt_status.mt_blkno +=
 				    (STp->buffer)->buffer_bytes / STp->block_size;
-- 
2.43.0

