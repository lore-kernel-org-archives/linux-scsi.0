Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC82C2DCB5B;
	Mon,  5 May 2025 23:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486867; cv=none; b=bSvRSmdLhFeOP6rhBKzEQruZjiM0yLtdCV3JkuFi9QMV7FrHN6FDYWYUAedbRNEamZMdG/lYKrlYUGAX/cS8ALrG8RZp0DsZ8ZOb813XJdDpIwPt4V9bgmlgdtJMUFHf+Xt5K03ZnWYpfFJfmohO7Kwl2uWiA69+8vBcycBcd08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486867; c=relaxed/simple;
	bh=PWS+1bFodNmkSAAB6LVMwD6M284xDtT5oJZUiuXRCEY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mlf36UWQcU3YxhgoytDOim8PpGkT3gTHoIdYptXC4Fx/bkGF8YjjV0Sd7oL0PLHN8+o6RsXXQX4mF7vLzuO+QmnXe+e7uY9G24ZVN3urUcg+zyKXTj0gVK5jXVnyUhMcOVuMlv1iXRVrrB4XdSMnWOhdCasXZm8OOnCa1IGXbJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbeYxbrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbeYxbrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DC8C4CEEE;
	Mon,  5 May 2025 23:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486867;
	bh=PWS+1bFodNmkSAAB6LVMwD6M284xDtT5oJZUiuXRCEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbeYxbrBfQ2fFcvYpWUppPeDBY1OK7ceszRLhqo4vbs8g+OhgGEo4U4rtfFGz5IfQ
	 T+4WzvOmgQI1iDLD6t18WqlPhVq2KpBrrKh851FSSR9MOL+amFN3OHpi7KPohBKQ9m
	 EM7I89NIZ6c5J62xuGPo2wmDs9aPtb7aNqLoNjTnIIAqgow5tNswg9P3J+ub3qOfjU
	 HoXEefhE/uMpYtJ/IyjMnTU7KpHkd7iBtPeEi+IUdzcTqu+lTroyH8H4/oOlMAcw64
	 Az5oq9gKdahXetMm0sVOlfTEnRjyZoWByPaLJf5bWcMfaX39htEVwbqSiBtR0Tm1vr
	 c/fYSFXsMaeYA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 034/153] scsi: st: Tighten the page format heuristics with MODE SELECT
Date: Mon,  5 May 2025 19:11:21 -0400
Message-Id: <20250505231320.2695319-34-sashal@kernel.org>
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

[ Upstream commit 8db816c6f176321e42254badd5c1a8df8bfcfdb4 ]

In the days when SCSI-2 was emerging, some drives did claim SCSI-2 but did
not correctly implement it. The st driver first tries MODE SELECT with the
page format bit set to set the block descriptor.  If not successful, the
non-page format is tried.

The test only tests the sense code and this triggers also from illegal
parameter in the parameter list. The test is limited to "old" devices and
made more strict to remove false alarms.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250311112516.5548-4-Kai.Makisara@kolumbus.fi
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 956b3b9c5aad5..a58cb2171f958 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3071,7 +3071,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			   cmd_in == MTSETDRVBUFFER ||
 			   cmd_in == SET_DENS_AND_BLK) {
 			if (cmdstatp->sense_hdr.sense_key == ILLEGAL_REQUEST &&
-			    !(STp->use_pf & PF_TESTED)) {
+				cmdstatp->sense_hdr.asc == 0x24 &&
+				(STp->device)->scsi_level <= SCSI_2 &&
+				!(STp->use_pf & PF_TESTED)) {
 				/* Try the other possible state of Page Format if not
 				   already tried */
 				STp->use_pf = (STp->use_pf ^ USE_PF) | PF_TESTED;
-- 
2.39.5

