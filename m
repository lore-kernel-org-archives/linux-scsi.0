Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECA1211278;
	Wed, 15 Jan 2025 11:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938917; cv=none; b=I9lMhXABR9hbv6D4cI10h07t15qjvLrTDJE2NF7DQJQG8BT2zHrffdAmBqutVrBEfMMFoy8FZRLmnOUji08NIaptyz+LkL+y1Zgfah8a2fMNuU2SYvFzfO1/hcQtfhxJbbY6qLWYh4ueBb43KI4jj1czTDfzs88gcbm5cZnHsF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938917; c=relaxed/simple;
	bh=974TDXUHOBVFKY2F5tfLtJ0FCo3GXEgTurSFpXhqq6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lB1mu0B3VJCyLq8lT9QK7ezMjcIKm12J3HtCyOgCm9dQokKH72umpXiwxyZSHrtqjFl6Nug2XWKiqYfkHkm+Cg98/5B0JoJGb7NFnVHMTT2L0oq1s5PyMC17rhTwsxnWcetk9tW4whVgBF+YK7YhA7RmSPYivrxKa2tU1ODT6E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vA25lrqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vA25lrqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC8DC4CEE4;
	Wed, 15 Jan 2025 11:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938917;
	bh=974TDXUHOBVFKY2F5tfLtJ0FCo3GXEgTurSFpXhqq6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vA25lrqd8tooHjD4e9PXQYKeKHL+cKizhZMJal7HXlq7BYJmWsb+TuVh7JgexjVZ0
	 jdhTdDgQl/P41a8VWi7Un5oBPdhF04S/kv+EBHZMXh+VT+skiH1tj5dgWZbHERZD0/
	 cUgqVtTX1ctQXLD+udC3udy26RUMguhtZFZWjcaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Stas <daniil.stas@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Chris Healy <cphealy@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/129] hwmon: (drivetemp) Fix driver producing garbage data when SCSI errors occur
Date: Wed, 15 Jan 2025 11:38:11 +0100
Message-ID: <20250115103558.972203687@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Stas <daniil.stas@posteo.net>

[ Upstream commit 82163d63ae7a4c36142cd252388737205bb7e4b9 ]

scsi_execute_cmd() function can return both negative (linux codes) and
positive (scsi_cmnd result field) error codes.

Currently the driver just passes error codes of scsi_execute_cmd() to
hwmon core, which is incorrect because hwmon only checks for negative
error codes. This leads to hwmon reporting uninitialized data to
userspace in case of SCSI errors (for example if the disk drive was
disconnected).

This patch checks scsi_execute_cmd() output and returns -EIO if it's
error code is positive.

Fixes: 5b46903d8bf37 ("hwmon: Driver for disk and solid state drives with temperature sensors")
Signed-off-by: Daniil Stas <daniil.stas@posteo.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Cc: linux-hwmon@vger.kernel.org
Link: https://lore.kernel.org/r/20250105213618.531691-1-daniil.stas@posteo.net
[groeck: Avoid inline variable declaration for portability]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/drivetemp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 6bdd21aa005a..2a4ec55ddb47 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -165,6 +165,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 {
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
 	enum req_op op;
+	int err;
 
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 	scsi_cmd[0] = ATA_16;
@@ -192,8 +193,11 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 	scsi_cmd[12] = lba_high;
 	scsi_cmd[14] = ata_command;
 
-	return scsi_execute_cmd(st->sdev, scsi_cmd, op, st->smartdata,
-				ATA_SECT_SIZE, HZ, 5, NULL);
+	err = scsi_execute_cmd(st->sdev, scsi_cmd, op, st->smartdata,
+			       ATA_SECT_SIZE, HZ, 5, NULL);
+	if (err > 0)
+		err = -EIO;
+	return err;
 }
 
 static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
-- 
2.39.5



