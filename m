Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03EC31ED7D;
	Tue, 16 Dec 2025 06:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765864970; cv=none; b=EniKoRLsBnZf8RcllNbnJfnfiJZTL4vK9YWRMVG7rSHc/GrUWVFbh3SAg/nZpRVFWn9qPLYROzC5rHBQIlfThxGFYWRocp/uZuhYtjBDaMGxM17YsvXe4f/I5EI53E+7nZvpy+XjPtaUJ7V9pIvhGvnqJYXeeKLmYF4H4UabEA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765864970; c=relaxed/simple;
	bh=NTag5p1OwLdRWQTEcZqMl0+EEI8hwNbQ1UnmrelULX8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ovMqP3rEGEOe3jveiywfz+2c+7hmJkXNzJfOzzpkS1cfeleeYubijCFpglLYaMRqfzzp8+SO0/bidYjLztJzR2qhTd8WIAFvB03LJzr2NcuTmI3cbcT287wrxSsvkLYYn1cH9SSyAaKJ19kVka3hoLUhIAMkN5j/eL/S83ed/24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=darknavy.com; spf=pass smtp.mailfrom=darknavy.com; dkim=pass (1024-bit key) header.d=darknavy.com header.i=@darknavy.com header.b=gX3/Z5mD; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=darknavy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darknavy.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=darknavy.com header.i=@darknavy.com header.b="gX3/Z5mD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darknavy.com;
	s=litx2311; t=1765864925;
	bh=sfAJjUo1Z7X5qtx9c8xhODUynGVaR9dGyYBf7HTeAvg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=gX3/Z5mDmJdZ6aHK0f4UGcaRp5kGDCVZy//Y2TwVNpG0ekJGNvxc64NBwbq/UrjNs
	 r0WCI0qNpJ6K+TdgdjO60Rt/wWgl9VHX/qH15PJ8AXwsYg5ZW2AKWIH8ohMOR09L6q
	 C7GQllExWrnBUV2bOkB5uATL3lFbBcekA7JK8yK4=
X-QQ-mid: esmtpsz20t1765864919ta8e176f3
X-QQ-Originating-IP: yXwUjgHgjOTee6x1YqVrhfsHcuyTMPPgX0/Aw10PWug=
Received: from localhost.localdomain ( [223.166.168.213])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 16 Dec 2025 14:01:57 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 2682504126983098805
EX-QQ-RecipientCnt: 7
From: Shipei Qu <qu@darknavy.com>
To: Adam Radford <aradford@gmail.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shipei Qu <qu@darknavy.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DARKNAVY <vr@darknavy.com>
Subject: [PATCH v2] scsi: 3w-sas: validate request_id reported by controller
Date: Tue, 16 Dec 2025 14:01:53 +0800
Message-Id: <20251216060156.41320-1-qu@darknavy.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:darknavy.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NfYhHxTlaBDtCuINKghGKxfYUwji1iovcq7w4eNkun1CokO6PckWM7Nq
	AjBZoxPcPKZowgJbXCONbvhRLLRybaKSevdI+TEJrN9MJfj6aymUf+DssKRz6Oz/xfrfFWy
	TqxyPHEes3roov/WcyxDu/y4k4EwYTRpKbfwpllY55alXo9RsMcE9ews7vy+MlqMwAz4ODz
	LBWev0gC2mQ15pM86EWAr/KhiQM1vlTFvL5wNrX9SqCcqP4nrgYvrIUfuzMdX0ffQqYCOOF
	+bzQAiQFe41yDftIgLLa5duogwrJdBec5A+vF9q/IMd6LPuvPaGmS/LncZGrCqQvr7UKcxO
	PYJnFmVLFTo98yUFiMS6WhapkHNxIjs1g9qKva1EgtkkMULS+MU5H0STqbmjPh0r7gJwkEP
	OkAQa9ekhJ2PshMn5uPJ+pqIzBPcFoVgGhchmz6qF5amK98RYYpx3MNQswx0fV4BRQbE2E5
	vghjfnTnH8ihWePZ4q6MysUIwNGnBRNTTsXhfQVv4T5HvFO18Eg9x3CwnNC14fYZvZl/EBP
	AXMH8AA3soZ6V5Vi8jqh4Tm6bQoIINucSP+LZ1FNGvdYt+1Nd4GdpNRAn7defLp/f7IpW0p
	cXzRaSE9+OgrAF8drpt9rdHn+8aP03M1+f01/AoNM/5zIDerNiGRvPJTsPEYY+jj5L0CPx/
	Z8oE+xw0u+fnYV2MTxhEIj4i+i3ywCKjqaOjZg/AbSxylY3vQ5DKrvulKXldSz3Ta2prkVF
	TUAGiaorYxxFQJgxO1NkmAddK3Jv8nQgrMx4mGb77IcJXzvtqM5dMV1L/Btnc9m406imP2m
	tslcQPn+GPGHJzpX9TK9TGZ1lfBU31HIy+rVeX2j0hsfc2Lyog4eqwDyzI1uX2p9DzC0VvM
	dpouO6b76Bt7eZemg0yyEXGso/3PAibXwiZV/23SnuC/aVNUfv89Ti5Bswlfm0OabenG9Ja
	Ii4HLIziqNebYFP7dEsnk4Jrn5ZUOT9DrZkPii2FNqOXCcjlZe7ex09QS
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0

Hi,

resending with a correctly generated diff (the previous email had a malformed
patch header). The content is unchanged: while testing 3w-sas with an emulated
3ware 9750-compatible controller we noticed that the driver trusts the
request_id field reported by the controller in the completion path and uses it
as an index into several TW_Q_LENGTH-sized arrays without validating the range.
A bogus value can lead to out-of-bounds accesses and crashes.

For example, a malicious PCIe/Thunderbolt-attached device that emulates a
3ware controller can return crafted completions and drive the driver out of
bounds in this way. We have a small QEMU-based PoC that reproduces the problem
and can share it if that would be helpful.

This driver is enabled by default in common distributions (e.g. Ubuntu), so a
misbehaving or emulated controller can trigger this on a stock installation.
The same pattern is present in current mainline kernels.

This issue was first reported via security@kernel.org. The kernel security team
replied that, under the usual upstream threat model (only trusted
PCIe/Thunderbolt devices are allowed to bind to such drivers), it should be
treated as a normal robustness bug rather than a security issue, and asked us
to send fixes to the relevant development lists. This email follows that
guidance.

The fix is to reject out-of-range request_id values before indexing the
per-request arrays in the interrupt handler.

Reported-by: DARKNAVY (@DarkNavyOrg) <vr@darknavy.com>
Signed-off-by: Shipei Qu <qu@darknavy.com>
---
 drivers/scsi/3w-sas.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index e319be7d3..4d1c31c04 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1184,6 +1184,15 @@ static irqreturn_t twl_interrupt(int irq, void *dev_instance)
 		} else
 			request_id = TW_RESID_OUT(response);
 
+		if (request_id >= TW_Q_LENGTH) {
+			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x10,
+				  "Received out-of-range request id %u",
+				  request_id);
+			TWL_MASK_INTERRUPTS(tw_dev);
+			/* let the reset / error handling path deal with it */
+			goto twl_interrupt_bail;
+		}
+
 		full_command_packet = tw_dev->command_packet_virt[request_id];
 
 		/* Check for correct state */
-- 
2.45.1
