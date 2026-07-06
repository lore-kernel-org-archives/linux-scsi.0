Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188F2412288;
	Mon,  6 Jul 2026 08:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783327536; cv=none; b=ilcL8qQpjbk748lv4sMSmv6YmHEpVCIpPh+HTzY+xS9rLn5N5p1PVnC2mkzizi3iq4N6DcC7w3xGPENaEhMCx1c2TiLd3AouphX09skgvJTfprbIrYHsyiNxTAo+J4qM72rNFSLQ9WlnxInzm/phvuRUmc6eOhTzuCSKHTIuNpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783327536; c=relaxed/simple;
	bh=ZZGxb1O94Bi6i3u79KpRqEdMJ5ixMe/mZSNVwTgUZaY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=txejrXkdGqit5gqKPlRXsO/FnPNkI0eTtnyqylYKEQKz4RlE24ey+o0W3SbCq+kYk19BHezxSsWjATea/T7lGVgL1q+GDGXsr6PpZRR2Psl8JdtvEAkcjSR5sisGPU3keYOKZ7W/UaOPxn65cs0RkqUUBTlFJq5VXseMhwaQdW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=VjqRBOwr; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="VjqRBOwr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1783327492;
	bh=l+s69glwv95Mx97n8AVCpWCkd7pwUNeM5WaxeDqmDnc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=VjqRBOwrhdxkjqHNwgIUHQ6Nk3HzQrbF/2/09ZpX0INHHWgfjYOFA7yHmS8hmDv0l
	 s5CwgxwXgDvUcDZEANg2w+Gk62WyG+ZgxjXr9hsgHQljcEs2PkA51IPcVhGerNnWoJ
	 tYVgsZ+FL+YlfgjMC2/tZP6cnrYmiiZ3lUqJ9/A8=
X-QQ-mid: esmtpsz10t1783327487tddb38e16
X-QQ-Originating-IP: 30tTuWHCMXPKrGKfAuAxO044LO4WKwK3uMoE0XRnRh8=
Received: from PEN202512010004 ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 06 Jul 2026 16:44:45 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10804215150923445021
EX-QQ-RecipientCnt: 6
From: raoxu <raoxu@uniontech.com>
To: dgilbert@interlog.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	raoxu@uniontech.com
Subject: [PATCH] scsi: sg: report request-table problems when any status is set
Date: Mon,  6 Jul 2026 16:44:43 +0800
Message-ID: <26BF67F369E2123E+20260706084443.805598-1-raoxu@uniontech.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: Nv1Zs1ssfOILY9YUMo1gwW1HVrQtbo4gAUuQawGkDUEV4zNPHzbRaWov
	+AB8HvN2m8tgPmKCHR65KyOD0YUhdQjPuTz6X+UrQdxcXqzItTBRv3raUcgOq+tSzeiU7DW
	sgdj01tf5LdvCi9bYE7VVc+NaBrS9YaSRGn8PALTp6BIbjdhJ6x3OKCIcP6lmnlTMt2xgNz
	+LgQm5pxAJsKtt8IJR8KBW9UCkd58B/0QtN4dXIPwFky4qDyeGn7PMGfY60+NMIVlwK7aH0
	2r57BOyfkdlJfoGeN90hD9RPxhwu7gNBBD3uNZ5EMZzF5RlvB+7j0F7ToxUmfxJUd4fsKj2
	SXe02d/yj9UWz+flKVwXw6UZVXlXl+SV6PJ64WJnYvTeEBUS4LHkYbtN+fIBL8aGn4Yn+ZH
	XFjvHE6aAZV5y48h1p4pWj0N5vFajO/dmp7KEO8o0Az/5DCQXUnXI5xHU9Ktp28vmA4Iip3
	7rQO1AhTvPLcIk2gT9TkTSZzQCPumMRsASthpnPls1TlXx/9juQQOoy67ti0ZKkST1j0siW
	Yi9/LknNvnmczP3Sqsueu49ANXKxrSSgr1QCgJu+sOffKjE7X6cazh6pma/fpg1UI/PQG3Q
	aKdznH57aMIVexa17Yttw1bVLq5q21aJ3oK4krRL0DQGfyi2XoiWh1jCa80e94ZC1DzK+UC
	5H07luj55KLzvjR+EyBjD663QX+k9xRbDckMG64E9+bsRCG6TICj5mxR3D26sKu3f/8Chp7
	D3ftv3gFcSXZobRiiY0wEgB4s2zqFS/TLKzmyZt7DTac8PyOzqrnhewHkvuX4DV2pwq1xIu
	lYvc13Njgzg3jSenTbno2fQQJPeSPhv0V2meF5pPnjU5QsEA25zBlKqGM0SD+r/Ifu/WY1y
	wvRPurS/+qpxmtR+MHY3cx/XysbhzsHd+YCtov4Zq5jFlgcdqJsWYx3eqMXx8NrLaOH2p2f
	t//uZe4IpOHH0QYoyJxrNssfVoGjEt9I8yr4L7xCLqtzbRBGpAEuAT+YOMYfo131jz3aLCa
	3HJP11WMXW8cXTWjxkLLyivSFawQ8uxqwSuT6ObdpEDifDYPsSqQlEG5mDqpHw+G/OuHJqx
	w==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

From: Xu Rao <raoxu@uniontech.com>

SG_GET_REQUEST_TABLE reports per-request diagnostic state through
sg_req_info::problem. The field is meant to indicate whether there is
an error to report for a completed request.

sg_fill_request_table() currently combines masked_status, host_status
and driver_status with bitwise AND. This only reports a problem when all
three status fields are non-zero at the same time. A normal target check
condition, for example, has masked_status set while host_status and
driver_status may both be zero, so the request is incorrectly reported
as clean.

Use the same condition as sg_new_read(), which sets SG_INFO_CHECK when
any of the three status fields is non-zero.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
---
 drivers/scsi/sg.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 74cd4e8a61c2..5408f002e6c0 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -863,10 +863,9 @@ sg_fill_request_table(Sg_fd *sfp, sg_req_info_t *rinfo)
 		if (val >= SG_MAX_QUEUE)
 			break;
 		rinfo[val].req_state = srp->done + 1;
-		rinfo[val].problem =
-			srp->header.masked_status &
-			srp->header.host_status &
-			srp->header.driver_status;
+		rinfo[val].problem = srp->header.masked_status ||
+					     srp->header.host_status ||
+					     srp->header.driver_status;
 		if (srp->done)
 			rinfo[val].duration =
 				srp->header.duration;
--
2.50.1

