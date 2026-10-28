Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217080;
	b=1HRJcBLhi65SFsMk9fGK2wUo9+JVcaO0eY7uuHwVjM2oLLkRP6E+uUGw9lNGQGZsKrsn
	 S9Uc1hC046O8ImVd8UOp60qPOVevGm+QpIfow3PsxuQve0HVgrTLrHaUbmcCqi4xDJwLQ
	 itqT6QhSVngcchwCqc3SWPxJGuHVMaZ2yD1bTN93yAdcRNsfdpmq65yAEaaRLOMXeJ/Ri
	 O2B8Axlgpma/rqz31lxJsf6R40VZTktPSyP7fp44iRzOO2ojS3tKmHHC+YIHg4dsmKvZ5
	 /ib4OqmvPNkJNt8NMQTFKVjyWq60I/8whY4qqDiXaSbmHZRO2+4aoIoq4HMl+Okm5vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i6f0QeEq1H2S/vNkISekiiOHHXnBUKuLQOaQmB90gW8=;
	b=B1Maooa+z99G3CGfPfyaHH4uWQ9Ry+W1X1jhAOM4u+NQgV7v7cFRkKURQcMD9j72OAIw
	 Z+qy9zIsB4r9rWl+J7xB70LvzVlurHvmsnc5BeANiIllr0vkunLWF7ANQiKzVRqh/hm+a
	 /Y/Qw05DDfIspUV9PB/td1p8/BH9PWs2MqnQR2Oy/mGsyY5xgVkdg2P4Ac/H7kz+N1LGs
	 4VM8/pmCRRvSbQ8elleeFsx+79gIE9IkxGsK163S9T5WaXD6ZHuxLVf4lsHuRYIe4DO7O
	 Izl83dBG1jsh8xFxVcKVLUPjvpUVI3gAztYXrVvWQlvxIYnJVZceYyumpti0ynwRkJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cEA3Knjf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0013606A31C;
	Wed, 28 Oct 2026 19:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cEA3Knjf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292521F01825;
	Wed, 28 Oct 2026 19:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217079;
	bh=i6f0QeEq1H2S/vNkISekiiOHHXnBUKuLQOaQmB90gW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEA3Knjfro/xa3uY/aqbHrDvleEL0bjiAqx5XJ0BYGiDcDil+KFVzhTMRNe4a+vjm
	 mEkKvILMoUaI9INn62v7yeVbA7BXapoCjMZWa3DemmJjbmEFp3K7u3jvoWPt0x8yPV
	 5FdNlbWEeQoye4M58+qFUsIDppBgT7Qj0f5LNQ64=
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
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1779/1887] hwmon: (drivetemp) Fix driver producing garbage data when SCSI errors occur
Date: Wed, 28 Oct 2026 18:04:35 +0100
Message-ID: <20261028170539.934442300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Stas <daniil.stas@posteo.net>

commit 82163d63ae7a4c36142cd252388737205bb7e4b9 upstream.

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
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/drivetemp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/drivetemp.c b/drivers/hwmon/drivetemp.c
index 5bac2b0fc7bb6..b3de637a3a1f2 100644
--- a/drivers/hwmon/drivetemp.c
+++ b/drivers/hwmon/drivetemp.c
@@ -165,6 +165,7 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 {
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
 	int data_dir;
+	int err;
 
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 	scsi_cmd[0] = ATA_16;
@@ -192,9 +193,12 @@ static int drivetemp_scsi_command(struct drivetemp_data *st,
 	scsi_cmd[12] = lba_high;
 	scsi_cmd[14] = ata_command;
 
-	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
-				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
-				NULL);
+	err = scsi_execute_req(st->sdev, scsi_cmd, data_dir,
+			       st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
+			       NULL);
+	if (err > 0)
+		err = -EIO;
+	return err;
 }
 
 static int drivetemp_ata_command(struct drivetemp_data *st, u8 feature,
-- 
2.53.0



