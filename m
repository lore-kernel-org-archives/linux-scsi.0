Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794918604;
	b=fDjQYm/a/Cml0Hst+SLMOvmBHqVgrxSwC8yMP6yAgMUPwgDLO89UxcBDlVEpw15Wu4gI
	 OtrVTxFv9YaseXKkjSfb+DMt9ibuc5bYDuD7f9O2PkAeIFXtV0ZOmXaN9fqhme6Ie3Jsi
	 O2OpgdrdxzyEyhVR+qGMn4l4x8jzou/Eaiea95eqjBSL74CXCb3TAJmICmk0lzVKFt9tD
	 R2ts14w3vas+b6QXGattxEFcNW+TNgAgr0g8mORxxAWiNk8smkUoeX1AzP6mQHEj+fywI
	 wsi1pg5UlLA4XNAlv08ygKuV5SdjgedMUxAgjCNZZLEcw5JMDMYZB1ekZ4buPtz18CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794918604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:X-Developer-Signature:X-Developer-Key:
	 Content-Transfer-Encoding;
	bh=H7dl4Z0zXU3PtsfJzlRQag9x+xyF/BDC8NJp2gQXUeY=;
	b=ea9FlsGQa6XpWWBzex6x2g9/v4W/h8ty2EI2SMKT8TgnCq4CmoUZGcDnAgc128bJgVnI
	 NF9qQUsp34rZ0mQVKMTYICs5ANfiBBPPz0GjxkOUnB8WoZpXGfrnFDLaCS4VoD6NRvtK/
	 eVyfn+G8B+HLpvj8CQqzfuhFzfzmws7bZmqQ2WILg7JezvX7FwmNijyoODmu1vEltr6ok
	 GwYOJ+l5qvGT4UwEbzBfD1Wspc3v1/wCGRVzI7kw89vSI98n4jwixtBH7T/YS8gi4Wa4q
	 cvHXABxT6YwLIflH37KnEHao0Gu5BZC9u4rsWnMgj4qvIhDTd9LlOHNfp64zhvfeeZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hZt4MFAs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E5B606A333;
	Tue, 17 Nov 2026 12:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hZt4MFAs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1625A1F000CA;
	Tue, 17 Nov 2026 12:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794918604;
	bh=H7dl4Z0zXU3PtsfJzlRQag9x+xyF/BDC8NJp2gQXUeY=;
	h=From:To:Cc:Subject:Date;
	b=hZt4MFAs0ipx329lBHP5U6+IZ9WhIl8v7qWh6XxjqqwLDhwStOClkZ5eOZ1aZn64z
	 mGshbWOpAZEWNV2IwpdWF2wBY3KMt4bHhCUUNUQl7R1E97aTIuchTI95Kz8r6LVw14
	 Mx1w9YSHqviUU0DgKbSPCOZ8UshK0s4vAzBZPi3S8wk8yIQKJ/epu0pRDrYrIWQxli
	 xQgrVxF5SsekTnmpzPnG1dCBIAwJaasaf1xIryqBNYvWJbRTSS7NCcsP/wSS6ZLvHB
	 9q1hWVQYgh4OlZyHdweHi2YcfoGWomWjprnhPa2FsgJtHF8py0lwWMo/Tp5S0nnCST
	 FhgMjCbE4B+iQ==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	stable@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2] scsi: scsi_ioctl: require write access for the depopulation commands
Date: Tue, 17 Nov 2026 13:29:53 +0100
Message-ID: <20261117122952.3451870-2-cassel@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2730; i=cassel@kernel.org; h=from:subject; bh=1/rFBrF7yWrytAReQJlyYYBeH784+pHZ5FXnEcAK9KA=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLL+eBx0vRS4bKe6RansWe3eN3aBywVd76r82hX7aHa/4 9Iws7VuHaUsDGJcDLJiiiy+P1z2F3e7TzmueMcGZg4rE8gQBi5OAZgIdyIjw42tAg1dfkseOStx nl34+YX/bKvDsvNvpWp8PSRqfDrvmBgjw801n2vKf3S3rJnI1s62q10p/6zOf/33UZPu+GZHfJt UwgUA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

scsi_cmd_allowed() lets anybody who can open a SCSI device, even
read-only, send any SERVICE ACTION IN(16) command. Besides READ
CAPACITY(16) and the other read-only service actions, that opcode also
carries the storage element depopulation commands of SBC-4: REMOVE
ELEMENT AND TRUNCATE, RESTORE ELEMENTS AND REBUILD and REMOVE ELEMENT
AND MODIFY ZONES. These change the capacity of the device, and after
REMOVE ELEMENT AND TRUNCATE the data on the device is most likely gone.

SCSI devices that support depopulation execute these commands directly,
and libata translates them to the equivalent ATA commands, so a user
with read-only access to the device node can truncate the device through
SG_IO, SCSI_IOCTL_SEND_COMMAND or bsg.

Treat these service actions like FORMAT UNIT and ERASE, which also
destroy data, and only allow them if the device is opened for writing.
The other SERVICE ACTION IN(16) service actions remain allowed for
everybody who can open the device.

Cc: <stable@vger.kernel.org> # 2a0adbb80a2f: scsi: define depopulation capabilities related service actions
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
Changes in v2:
- Say that the data is most likely gone after REMOVE ELEMENT AND
  TRUNCATE (Damien).
- Mark 2a0adbb80a2f, which added the SAI_* definitions, as a
  prerequisite for the stable backport (Damien).

 drivers/scsi/scsi_ioctl.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index bf049d9cb719..91525103d074 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -300,7 +300,6 @@ bool scsi_cmd_allowed(unsigned char *cmd, bool open_for_write)
 	case GPCMD_VERIFY_10:
 	case VERIFY_16:
 	case REPORT_LUNS:
-	case SERVICE_ACTION_IN_16:
 	case RECEIVE_DIAGNOSTIC:
 	case MAINTENANCE_IN: /* also GPCMD_SEND_KEY, which is a write command */
 	case GPCMD_READ_BUFFER_CAPACITY:
@@ -330,6 +329,21 @@ bool scsi_cmd_allowed(unsigned char *cmd, bool open_for_write)
 	/* ZBC */
 	case ZBC_IN:
 		return true;
+	/*
+	 * The storage element depopulation commands share the opcode of the
+	 * read-only SERVICE ACTION IN(16) commands, but change the capacity
+	 * of the device and may destroy its data, so treat them as writing
+	 * commands.
+	 */
+	case SERVICE_ACTION_IN_16:
+		switch (cmd[1] & 0x1f) {
+		case SAI_REMOVE_ELEMENT_AND_TRUNCATE:
+		case SAI_RESTORE_ELEMENTS_AND_REBUILD:
+		case SAI_REMOVE_ELEMENT_AND_MODIFY_ZONES:
+			return open_for_write;
+		default:
+			return true;
+		}
 	/* Basic writing commands */
 	case WRITE_6:
 	case WRITE_10:
-- 
2.56.1

