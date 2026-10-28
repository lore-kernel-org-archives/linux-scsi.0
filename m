Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209478;
	b=Oen4RtLsjNqDv2+UzxEz+y9vpuz91gSw/F/gUrhVLJqWDsqHyFtmHA6KA8Ou2pIWOcr1
	 KKgPC+zBc0llPnXEMBJmt0NtuokwUR+xnwtqxc0xU1C1rt853GS09atmSh4NfFUK0DHMi
	 a3UjNhFM+rsewkZNMz56yyszSGUz0XmHbAFdIs4RygYbAX4bAwveg+bULcCTz8CSQoIaz
	 4WPiTJBaW9AQbRU0hzwWHX/9pBghcahFQAEJpye7hM7h7u1Y4M7eJC3N6JsGT/SCfchw2
	 gxaT8Xqg+zctKtmEZGhYef2cQyj447aDqTVXDg1Z6z/ncsU3gAebVtFvwIitiOX1tOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=66yvyzKGWV0Rnaw20Py7KQmgiWDmOfwJtXa0VXFTngk=;
	b=KZGItsOtAfETFVgV+T+zokgL5ouixUI9cG2pbTqMVsXnfLRY+nfikpIo+1UBbmcM2uKu
	 IuQE1chigrBzSgzkPbOXGPszAldXtxRgjfi6U67WT0M0HF6cgal45USPv32vqLqoX5dcr
	 mwuB3SW/URTuZwDx5Ij4/uKMBmOKs0/ynOSlp7BwDBLoxW61EvtES413d5aD5VLbwym12
	 MeWAYGVqtstbrlmgMEbCJndK00HvHrJ3yJ/tlcxUSdlEl78k9nrf6mcgUmHFfAu9oC8KN
	 COewD6F8l9LU7cuV6ekpZhNVrrXeSGpwLq0VVUnEA2kBkuoIHsObZrJFAw+YJJUuLzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3Dj+Vdx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B606E606A321;
	Wed, 28 Oct 2026 17:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3Dj+Vdx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AF91F01828;
	Wed, 28 Oct 2026 17:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209477;
	bh=66yvyzKGWV0Rnaw20Py7KQmgiWDmOfwJtXa0VXFTngk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3Dj+VdxXo+Ts/bq6KRaQd906XkJk40DLCInEnKnWHgRUCUznX4+qvH5EgSksxljR
	 9YJFtIQJe7bjWfroru1/Ji4eZSfk6aWnBJ4FQmpv+9GBX9MVIWCSKXzxEO9bHM53s2
	 6PbnlF8gEiHu/7CGXGqY5CYxsf7YBqtiMKmxRwVE=
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
Subject: [PATCH 5.10 485/516] hwmon: (drivetemp) Fix driver producing garbage data when SCSI errors occur
Date: Wed, 28 Oct 2026 18:00:37 +0100
Message-ID: <20261028170014.967212572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 00303af82a777..098d30e210636 100644
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



