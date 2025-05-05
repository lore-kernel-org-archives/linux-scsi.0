Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB53D279351;
	Mon,  5 May 2025 23:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486869; cv=none; b=LLuQZPQXLpPJW7Fg5ZaXdjyydrVDRJnWlm8ASZFlrFYtQCMy2Y21B1nPhwrME6qoFsPfOqMGQxGmULsPkzDfMTrzWwHqJYOqTPEM3+qU72Hb28w8ZlRQ0NyFsjaaD01qS/8Ax8zIMwDLDqmz0WSzQxuSwFIBT7ohi1XStzzuKZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486869; c=relaxed/simple;
	bh=of3eMqWEE8eKPf9UPMc/az9Vx/5h145Vm8Apj9Wf/fw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H/5UEV4b3PiSRiMUjpW4NPK6ghi+JTEooxKKC/M0pDyREam+D8UyM7vdzCrTW2AlodBjjk3qZ3OzabwMNWqzgos4iwwo5hJ11Pu2X6luYry9OshE+1WqrAW5xeJoacPNL0a9YRLciQ1FG8GFOiCdypCEv5MUWyJVPqbqzzDLqcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H4gFzp8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4gFzp8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D99DC4CEED;
	Mon,  5 May 2025 23:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486868;
	bh=of3eMqWEE8eKPf9UPMc/az9Vx/5h145Vm8Apj9Wf/fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4gFzp8lMm9/rAuiaZtC6pw23OHFIxzoDQvV3fAiKBL7jFfnNGqfUs+tuEZIP9ZC0
	 Sx7Sf/KS2bn2c2qR6eRBcs3pAsyR2N8N/wqJL8sXXjqtVeDjRMzdEfkW1SHOvN60Fm
	 o4kWhbzssRqpuOx7aKvp7Qj7vwZVvQB6ow+E7CXkjs6FRS+KeYfB8c/1PkVeSawA5U
	 4QossshNB8cKqHrC6C15daU52qOIP7DxzegtVSxYaHknmLhojQOQKiKig+zhK6hGGA
	 epHeDHjVw4LDa5RJgre5zuUaWtg7Frpn+obNHE6sb46ZCr7dsXfgmW6OZtIUxqXT62
	 I+RAi2112J/hw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 035/153] scsi: st: ERASE does not change tape location
Date: Mon,  5 May 2025 19:11:22 -0400
Message-Id: <20250505231320.2695319-35-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505231320.2695319-1-sashal@kernel.org>
References: <20250505231320.2695319-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.181
Content-Transfer-Encoding: 8bit

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit ad77cebf97bd42c93ab4e3bffd09f2b905c1959a ]

The SCSI ERASE command erases from the current position onwards.  Don't
clear the position variables.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250311112516.5548-3-Kai.Makisara@kolumbus.fi
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index a58cb2171f958..26827e94d5e38 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2884,7 +2884,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.39.5

