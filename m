Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBE14EBAEF;
	Tue,  8 Sep 2026 09:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858258; cv=none; b=TAr3WgmLhRVE9hOtNm4/5GoWyTBKR2M0UURPViklED5zfC3gzo48C3zAtI0W2vN6Xuqcw1YigkVmxesN0fGOnBE5iCbnwfGRJN90H9pHTk1Jnotxg66TgPbX+pku5euoWB2JpXlJcNkODJoILLeMkmyH3qyjk4GjpwV0Rydz5GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858258; c=relaxed/simple;
	bh=ymPr8CpUq+oypIGl6OwkqIGB/iR1jNzt9Eq3c1bwTAo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8kf3sv3RxEsc2vfDWqGgvUaWebOgn6+jpjuFxVSuovBxm+EJglR+jToWJMbopfGPiDd8rQ/AYUAClCpkIlRlDgsr0DMvjdrGrub/XHUk4jV5wLBO4O7kX2VaCUl3KoNjvW7xAy8mOWI0Kkx+QhPH5fkvUMzG7Q4g5ZMg4ZB2Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ItAGkj41; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ItAGkj41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878CB1F00A3A;
	Tue,  8 Sep 2026 09:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858252;
	bh=XGhKpD0TVoCGOSASvfAq0BfFE0GCDweoj2gAQwpWr2g=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ItAGkj41YjhDr8o/iriqvGvFsui7oZ9eNSDlqYE3E/lyW4ueENPr6j+/fxi1Mn3eD
	 RJ1BktdUOPh2OlT7VNU6zyonNZlwpdNgCZ2OsGCchSPb5mqxRvQitciO455nmudr8M
	 t9oSz+VrdkTxF4OUltm2DHkb7TaYuJ4QExOQB0Y9xs/39TN9Puec4yDkoa/jeh4HLu
	 TxLytk39rGqvj4xS9gFFxsoU/Sy7D9Q8zmdaDXsgYmLfV6lJBAg4m/85q5V4bIHb+q
	 DT8Kou/KgNnkAGmNJ66ea6bXzsf8iO3UpQY5EH+vY3cO4n7NddQSrdCJBqPLVzIJDp
	 dtUIqAxSjIHOQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v6 30/40] scsi: ibmvscsi_tgt: use 16-bits defined sense codes
Date: Tue,  8 Sep 2026 18:02:58 +0900
Message-ID: <20260908090308.1085097-31-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the IBM virtual SCSI target driver to use scsi_set_sense_buffer()
and replace all hard-coded additional sense codes and additional sense
code qualifiers with the enum values defined in include/scsi/scsi_sense.h.
This helps with code clarity as the sense codes being processed are easier
to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 61f682800765..e2af90b6da39 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3757,9 +3757,8 @@ static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
 		dev_err(&vscsi->dev, "srp_transfer_data failed: %d\n", rc);
 		se_cmd->scsi_sense_length = 18;
 		memset(se_cmd->sense_buffer, 0, se_cmd->scsi_sense_length);
-		/* Logical Unit Communication Time-out asc/ascq = 0x0801 */
-		scsi_build_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
-					0x08, 0x01);
+		scsi_set_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
+				      LU_COMMUNICATION_TIMEOUT);
 	}
 
 	srp_build_response(vscsi, cmd, &len);
-- 
2.55.0

