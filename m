Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424263;
	b=utcqFrnflDo2tG94ql1VpQrzjqe3AStSD7qMiMIrrQnaYoe+cpk3zwAqaH/euL75suRT
	 fhopSIKnnvQ0TkPKG9DnYacPXo2wHziappfTAVjxxiz4JkHrP1M6L8ZeRrJToBuub+/EX
	 wvLaSH5LHkmTrehHdnnxonU7GaF5IfjMN53FgrxJ3ue06FARTMOgtOEDBwzi4R3qoYlDU
	 KocVjBzfv/KOk1hWDvTA8uYzgSlv7Tr6hchX+cRSQIXfE6mqrA2qy4uB/cGCrEt64t75o
	 1JI8TJtviQV/LRG8R+c3S9tqYgnerlXB5/8TL9T7LzOnOsRMG97dr0B/e1v6lbQjc8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hs0P4ybaLBjv7aLmDLNOEUoJ+Z5BkgmRwLyXitJPJLs=;
	b=FMv5ANg8vfKyn3yULLkCPAXRjU/z6SQL91tunxr/KQcX7jIf4qbEQjmAsd0YBpINnN5P
	 8OUFz93ynKYivVpMYn0cfr63AHD4eKDgxKb9MWsIO2tqCRyisqqIj04sKUZit9UVMF6Un
	 2rGecyn3DUKtHuMgQBG+1jj+aWQ/XXzB/sEQDaB73hpwkDY6WXQ/2uvAEiDzjwxa/nLhY
	 aUZWE0vjEPM+4UEtB0CwGPfn26llglpGTD5ecM8RIQH6DtojPwNhOSGzqdUXjTA0B+Xq0
	 ZObcrEC/akEEvGmEvIhqQoy8P/Q/1bXCRCPeFOsukr1e6FXJvzQo8B3QP5vRxcv3p4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kopbvCpH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0253D606A32E;
	Mon, 23 Nov 2026 08:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kopbvCpH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8FD1F00A01;
	Mon, 23 Nov 2026 08:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795424262;
	bh=Hs0P4ybaLBjv7aLmDLNOEUoJ+Z5BkgmRwLyXitJPJLs=;
	h=From:To:Cc:Subject:Date;
	b=kopbvCpHzVHjDaqJHHuJfOP2Z850FnfKz7NaCpm6MTn4jj17F6Jk6f+XFTZg5Up29
	 1z3NN9+cQOmAoDWwQG8jLuz/w6icYovPzseRlSQpV4yznuS51o1rhc7kQQajafxjEM
	 Bq3FPlgHMm8rM0e/kCbvlr4Fmkkk+LKaOCNIAJVw1maTWYbK2HpvPzj3WPW5eVRCDb
	 Y8ICQlOLrlR7AyOVDi2VAaJasMQQzcuaiBZcCEsDPfcyxrIw2RtuSKQEXCrnjPo9Hw
	 PCoQeOl434gEzXQWedj7w2Tvc6/eJFFfAP+J6IIC9pmVHbo+5WYFikcsO3Oi5gFHnN
	 sFhw0og5izGNA==
From: Geert Uytterhoeven <geert@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Kars de Jong <jongk@linux-m68k.org>
Cc: linux-scsi@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-alpha@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] scsi: 53c700: Fix hostdata[] size on 64-bit
Date: Mon, 23 Nov 2026 09:57:35 +0100
Message-ID: <0df0fae8a75e46f2f1613d398c1e137211d924a0.1795423196.git.geert@linux-m68k.org>
X-Mailer: git-send-email 2.43.0
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

From: Geert Uytterhoeven <geert@linux-m68k.org>

NCR_700_detect() allocates four bytes for a single-entry hostdata array,
to store the NCR_700_Host_Parameters pointer.  However, hostdata is an
array of unsigned longs, thus storing a pointer or unsigned long causes
a buffer overflow on 64-bit platforms.

Fixes: 1da177e4c3f41524 ("Linux-2.6.12-rc2")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Compile-tested only.

CONFIG_SCSI_LASI700 is used on PA-RISC 64-bit,
CONFIG_SCSI_SIM710 might be used on Alpha with EISA.
---
 drivers/scsi/53c700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index eb3a69dff1e72642..7236f9bfa0fe302f 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -341,7 +341,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	if(tpnt->proc_name == NULL)
 		tpnt->proc_name = "53c700";
 
-	host = scsi_host_alloc(tpnt, 4);
+	host = scsi_host_alloc(tpnt, sizeof(unsigned long));
 	if (!host)
 		return NULL;
 	memset(hostdata->slots, 0, sizeof(struct NCR_700_command_slot)
-- 
2.43.0

