Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E9F195FE8;
	Sat, 26 Apr 2025 00:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745627325; cv=none; b=VedUD6CmC0h1BR/z8NvSB+5cS8rzSEPRKSJ9qqZATPXx4H8Cx1tikUS+oUjnHDZsnk1TV5OBQegvEEbYcQioNTwts+xIwNqa7TKG9LW9vPc9kSMDJ3+MoQd7fYntor6P6l6hX2P9Jw4bI9bPiUQUEtx/s7qvV5EgeemrPkDBVr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745627325; c=relaxed/simple;
	bh=qVL6+OeT+QqtZBPwSfTpScoMcCLCzuOUEEkiIXS1aXE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GVm7X01pnZQ+gfoOcXVvnOUbR3tVtrO8PiYj0D9ypjNrSM354SaEzZSeXERIAwk/4EbA/h3ebPYO6kazwc1CT/no1ELfoTRuzODo3tgyaTltcTLPOpINXqoJryekpw5DHEJUlaZgozVWlUCvsa9Y7cMZQDGXYJETuAR77fNW4Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Af5qnEuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Af5qnEuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F016C4CEE4;
	Sat, 26 Apr 2025 00:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745627324;
	bh=qVL6+OeT+QqtZBPwSfTpScoMcCLCzuOUEEkiIXS1aXE=;
	h=Date:From:To:Cc:Subject:From;
	b=Af5qnEuftPrIBkc6UH1ws6Es/6AfLRvupANuHQkVnYbF7i+Sg8FdhiwkcT+CMNJFy
	 AxsoIR8zc8SHZyWUIHih1BchHGuBMl2RXyCuS4hFZlUIqvgnsJyAYjjj97cLLYDHjv
	 6SpYH7q7fzwBIdKa4uxp6Mn3RIDC8+U1plnYz188keGJdLImO/+F331azTwwKxD7Xw
	 mLuMsDgA6u1vcXJislbno+g4GUSYl4lAjZnoIyTqOrRaV4EWqqdwx8O6cZd6D/CSHx
	 vMIReQ0pBV8SGyBQLSU9wp7n9PrIYfpQ+OSyfaxEaJVAHbn9bI1o7vwDbKLz00Jox9
	 4absD56v1ErhQ==
Date: Fri, 25 Apr 2025 18:28:35 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: sd: Avoid -Wflex-array-member-not-at-end warning
Message-ID: <aAwos0mLxneG9R_t@kspp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Use the `DEFINE_RAW_FLEX()` helper for on-stack definitions of
a flexible structure where the size of the flexible-array member
is known at compile-time, and refactor the rest of the code,
accordingly.

Also, there is no need to use the DECLARE_FLEX_ARRAY() helper.
Replace it with a regular flexible-array member declaration
instead.

So, with these changes, fix the following warning:

drivers/scsi/sd.c:3195:50: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/sd.c         | 13 +++++--------
 include/scsi/scsi_proto.h |  2 +-
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 950d8c9fb884..aa15b1085235 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3191,10 +3191,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 static bool sd_is_perm_stream(struct scsi_disk *sdkp, unsigned int stream_id)
 {
 	u8 cdb[16] = { SERVICE_ACTION_IN_16, SAI_GET_STREAM_STATUS };
-	struct {
-		struct scsi_stream_status_header h;
-		struct scsi_stream_status s;
-	} buf;
+	DEFINE_RAW_FLEX(struct scsi_stream_status_header, buf, stream_status, 1);
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
 	const struct scsi_exec_args exec_args = {
@@ -3203,9 +3200,9 @@ static bool sd_is_perm_stream(struct scsi_disk *sdkp, unsigned int stream_id)
 	int res;
 
 	put_unaligned_be16(stream_id, &cdb[4]);
-	put_unaligned_be32(sizeof(buf), &cdb[10]);
+	put_unaligned_be32(__struct_size(buf), &cdb[10]);
 
-	res = scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, &buf, sizeof(buf),
+	res = scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, buf, __struct_size(buf),
 			       SD_TIMEOUT, sdkp->max_retries, &exec_args);
 	if (res < 0)
 		return false;
@@ -3213,9 +3210,9 @@ static bool sd_is_perm_stream(struct scsi_disk *sdkp, unsigned int stream_id)
 		sd_print_sense_hdr(sdkp, &sshdr);
 	if (res)
 		return false;
-	if (get_unaligned_be32(&buf.h.len) < sizeof(struct scsi_stream_status))
+	if (get_unaligned_be32(&buf->len) < sizeof(struct scsi_stream_status))
 		return false;
-	return buf.h.stream_status[0].perm;
+	return buf->stream_status[0].perm;
 }
 
 static void sd_read_io_hints(struct scsi_disk *sdkp, unsigned char *buffer)
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index aeca37816506..0ae7adc8a5db 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -349,7 +349,7 @@ struct scsi_stream_status_header {
 	__be32 len;	/* length in bytes of stream_status[] array. */
 	u16 reserved;
 	__be16 number_of_open_streams;
-	DECLARE_FLEX_ARRAY(struct scsi_stream_status, stream_status);
+	struct scsi_stream_status stream_status[];
 };
 
 static_assert(sizeof(struct scsi_stream_status_header) == 8);
-- 
2.43.0

