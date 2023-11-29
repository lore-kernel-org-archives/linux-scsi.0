Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED78C210E2
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 16:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CiifQz5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E684C433C9;
	Wed, 29 Nov 2023 16:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701277117;
	bh=TD8HdJRqayfG1gI4lBUHfilG6MKifdvps7YI2WGPLHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiifQz5umjmuq1dTVo5vGDVHDx4Mjp2l0RXlCC3y6YPaa69jxitqFA6XV8zSOcunx
	 STm8Q0ta2J/0U96WmV6I5YoavehVl1F5/8PixdEmh9Riswjq5oHo6Hu74UdM/zEe4n
	 WDAZmbHYGKE/XMjgZrpjCoo+Lgvwf42+GDrUmLhnzcYTeJvHc5Tws6ihUa34CEufbL
	 NzmR7ekPm4JVGn1cKYBF6xdsprXl4J59Z+MhrRcwnwKWoHD36E8zuJkvZo5DPL8RNC
	 98OSShXIVsWy6O4RPw0FZdkt/PZXNzPPWYL22q5DOlF3micOh4SJnOute4bBpl84ZZ
	 DnUxkWcYBLwWg==
From: hare@kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] libfc: Fixup timeout error in fc_fcp_rec_error()
Date: Wed, 29 Nov 2023 17:58:31 +0100
Message-Id: <20231129165832.224100-3-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231129165832.224100-1-hare@kernel.org>
References: <20231129165832.224100-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hannes Reinecke <hare@suse.de>

We should set the status to FC_TIMED_OUT when a timeout error is
passed to fc_fcp_rec_error().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/libfc/fc_fcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 3f189cedf6db..05be0810b5e3 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1676,7 +1676,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 			fc_fcp_rec(fsp);
 		else
-			fc_fcp_recovery(fsp, FC_ERROR);
+			fc_fcp_recovery(fsp, FC_TIMED_OUT);
 		break;
 	}
 	fc_fcp_unlock_pkt(fsp);
-- 
2.35.3

