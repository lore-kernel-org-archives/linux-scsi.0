Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794854036;
	b=5MSpjSxwa5MQUh9SSX4QToi8EjdI6U+gK0rb02mV1ieafkIoVzGZpi0gWjX0NNIgGsrE
	 hxe0rW8cR/o34QAikq34CxQI0GsqBY8oMvOKC0ltzNbzPaYBBubz0yVKMAspARcsjUriO
	 7o3lXtWl1BeWFbeSB/+B1BKa4kclUiAz5g6Gfy0E9eUQe6pN4bupl5KapSa16JoAe3MnK
	 S6UJBQr36kfmO3A4f0Q3UonKoxkk7zulW1iARvRrX8a0/uhL28O7wsIYHI63RZvopu7mQ
	 sr18AxW5HXcSW1+Lx6q9mi00Aoqn+8j2WYxOqsC5ZJ3K1Vwqg9b1bWtokrliqeqOBdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794854036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:X-Developer-Signature:X-Developer-Key:
	 Content-Transfer-Encoding;
	bh=YRgj47b35x/+SyCcGwJ53uCmdGrePRErRLNrwRoUQkM=;
	b=tJOQAAC2jryk6Fw7+OPY2EbV0KLvBlfIDKdqnGfOLpW8/PEmIKUJpuvG/FAHVEdI9ixR
	 YdkeasGaIw4j9bPK2hlG0gh3toAfHU8zPuiMBXUOKMxjcYsG2zwfepo7U3a+mXoT6xHCU
	 6WuOZAeOPArLPJAWj1GFPqzyU0BIQqma8pWAcPe6qpmYCouecqK36AngHRwODVUQEh1qm
	 WQw2eYvJAaJ6YbO8tGADzetixWwNwO+qWDGt83XaeAbbRylMzVxkKqj/CNLbuS60zNQGb
	 3y8bkn3Bx8PGOiyaGTN7U64LTeUyhbz4jVEwgQMMH87d/1SX2wkh8kSP4gRdJbxZqVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LBJaKuSv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764F0606A31C;
	Mon, 16 Nov 2026 18:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LBJaKuSv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4831F000C4;
	Mon, 16 Nov 2026 18:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794854036;
	bh=YRgj47b35x/+SyCcGwJ53uCmdGrePRErRLNrwRoUQkM=;
	h=From:To:Cc:Subject:Date;
	b=LBJaKuSv8VBdMJK/wMdAuKZ0d+/AZ2VJH2i/DWj34JnYQhp9kvFStabrWuIUKBSAS
	 rU+BhmFZdms7t/GwLcaJ2x0HvWK1XZyfG6c1q/o6Qnpu4F7bRjr9228uZWqPhwXXYb
	 qsKMiXOuu/CtQn+HriSrsLBvKLi6PI5XvmDaohPtXoB5zkOdneFxl/GXW1s2l/K3Ai
	 PxSdBygm8I5q47aKzimoJBDq1Xa8Q4NB4lZR9wdDKednl02BaCoS0kpqzHWvG+BpNC
	 7vh+QasQZvmN+R98neFiF0uh5RhygFFZPIYyAhKv2AeCND+cNYh/vL3/QQgDTxOhGV
	 xIIFY7kskjMEA==
From: Niklas Cassel <cassel@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	stable@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: scsi_ioctl: require write access for the depopulation commands
Date: Mon, 16 Nov 2026 19:31:40 +0100
Message-ID: <20261116183139.2878673-2-cassel@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2420; i=cassel@kernel.org; h=from:subject; bh=16l8bxU8D/eff5z9kePQvEBuLtLs4LG1gfMxVT2Pg/8=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGLJ++3C/D7H8JLpAsnS++4HniYyWgvJHxSbusZtTU7XzZ p3R5MdvOkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjARbRuGvyL+Im7KkjM+bX52 J3rOhh8lOXtjD+4ylTr4auZyv9bbW68z/BW6671Qe5v+okWq196FakTFhstMOzkr0qrgjq1343Y TXV4A
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

scsi_cmd_allowed() lets anybody who can open a SCSI device, even
read-only, send any SERVICE ACTION IN(16) command. Besides READ
CAPACITY(16) and the other read-only service actions, that opcode also
carries the storage element depopulation commands of SBC-4: REMOVE
ELEMENT AND TRUNCATE, RESTORE ELEMENTS AND REBUILD and REMOVE ELEMENT
AND MODIFY ZONES. These change the capacity of the device, and after
REMOVE ELEMENT AND TRUNCATE the contents of the user data area may have
no relation to what they were before.

SCSI devices that support depopulation execute these commands directly,
and libata translates them to the equivalent ATA commands, so a user
with read-only access to the device node can truncate the device through
SG_IO, SCSI_IOCTL_SEND_COMMAND or bsg.

Treat these service actions like FORMAT UNIT and ERASE, which also
destroy data, and only allow them if the device is opened for writing.
The other SERVICE ACTION IN(16) service actions remain allowed for
everybody who can open the device.

Cc: stable@vger.kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
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

