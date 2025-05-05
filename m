Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E022F73BC;
	Mon,  5 May 2025 23:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487149; cv=none; b=L7L6XJZ/kt4RzIo0U2XX6QkmaMwxLI9omCAwEAwWoeVkLmTUxKwssXZ1nE4XAxd6t484cOm/Lz5+AgRNJlwp3FaJa/3hL1o6h8A4uR06jPRztt//MrxDuRCfnOVP7yLFXggkTsvcGaeB3EGlSYdA+BuxBMpPxRnmAN3UK1IkQb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487149; c=relaxed/simple;
	bh=VyrK+8Ot+v1oAp9CLHvUx60S7dF3xU2GFcyb3xyqnNc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RNv+UnQUi8YOQtDr7b/3U5Q+lNEDbVIVTq9Sf8x32J5KE3F0So69izxCJWsHHSL5DR6TjH2/CznUfsew3kMs3q3EQ6o/h40WyTLPVVLWERsuctUI3GB2hoLFSnrrO4RdWxtVIQ0Ew7CXDiCrMIG9ZAx1XT0zVhC7sQ4NXcIgLXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MwaMM9ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MwaMM9ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD52AC4CEEF;
	Mon,  5 May 2025 23:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746487148;
	bh=VyrK+8Ot+v1oAp9CLHvUx60S7dF3xU2GFcyb3xyqnNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwaMM9ws7j8LMb/mkXj0fbpL+/80L3QEi5gPud+S9YiwsKMRqUlnw8LpcfHBer9j5
	 KcC1dXyHtYkVpDvKBKmiGrVoRLVqjucqrJTMRnAzW/MyWwhPB4bOS4Dd3nKzjki9bi
	 C9+b2ga5QH1Ge5XYcJ+UU2R71YLgVVSSTG9zjeJlU1UhxPx85ICZJudi0k/JvpLoaG
	 usLTq5DD16VU72vEdGlfRp0Q6rJc0Z91NOAfMZWokXE8VZ5k+10oC9jgJD00q34Ypf
	 uHSdhXOdDNjnvMtcNE7oXTj/1Xu8CWj5wbR1ewgonVdf3RVOA4gHW3Zu/MwyeMf3YF
	 t2KpxYfOKTgCQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 025/114] scsi: st: Tighten the page format heuristics with MODE SELECT
Date: Mon,  5 May 2025 19:16:48 -0400
Message-Id: <20250505231817.2697367-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505231817.2697367-1-sashal@kernel.org>
References: <20250505231817.2697367-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.237
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
index 465fe83b49e98..47e59b74c09d2 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3076,7 +3076,9 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
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

