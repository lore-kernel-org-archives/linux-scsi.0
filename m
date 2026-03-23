Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA4827B327;
	Mon, 23 Mar 2026 10:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774260034; cv=none; b=JvKVYZXvh9PlhPgejk1YzPokQr/+rXSjnHN07vNk4BJis5gmEhUE5vKw+guNDlRZ9D7/zfjpqxxM1mPieOVJsC+8w9/tlCS3ucU6NcyfMiP2LXLYlwPFSq/qKvY84HbOd+vIaWiIAcn5uffNaNps+4brXu6diU42BUWPB8feXEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774260034; c=relaxed/simple;
	bh=kjAqZ2MjoSDxKr1NFlFE2uHvQeAJfxfblr9ZrMa2V58=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XsUr4I4xW089NIVBrhCLQ0F2Yx6Ba0fgtEktP9aimaY/gWv1AGj/JQPAcV5r2DYlkdJIlZR5jq4ZoqNtQkEBjoKT0/ULjp1bLETSuY97LlzqiUfDoySypoIdTz6GloGtQehvJTMwsGvaZYTo7k8PiHou6raQ7HlpNjJPdSewD/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uen+Enn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uen+Enn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7E5C4CEF7;
	Mon, 23 Mar 2026 10:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774260034;
	bh=kjAqZ2MjoSDxKr1NFlFE2uHvQeAJfxfblr9ZrMa2V58=;
	h=From:To:Cc:Subject:Date:From;
	b=uen+Enn2wtPcnaF3KVr2PMZzAPX1Ff2/HUyoNG7VE52qRF9w6rOLWdR8g99TDa4c0
	 fXyb/yQ9i2WSCremcPDPH2NmJC0N5OMt8SrnquG0W1mVQ7pOMtW4Pv1QG9Ha4YHjXM
	 jl16tCGDMjh0K/QpnxxYyX77ghki4YPBk2/01Sh2wycC3zSLl19qjyHlOH9cSrKwh2
	 nNOQBXPtsfqna46LoTjpEwAcxWlSLqcUlZ4X/G++eixIjR+Ilcz0DjW4ip1uxkTqvI
	 0bwRESd8GMxvS5gTN0+ZfZ86C6nkxlFcJ2yUE43qTyMFNDVkWJnCtA3s2B6x/+qT1k
	 T9sJcHcQkRvnA==
From: Arnd Bergmann <arnd@kernel.org>
To: Bradley Grove <linuxdrivers@attotech.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH] scsi: esas2r: fix __printf annotation on esas2r_log_master()
Date: Mon, 23 Mar 2026 10:57:39 +0100
Message-Id: <20260323100027.1975646-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

clang-22 started warning about functions that take printf format strings:

drivers/scsi/esas2r/esas2r_log.c:160:50: error: diagnostic behavior may be improved by adding the 'format(printf, 3, 0)' attribute to the declaration of 'esas2r_log_master' [-Werror,-Wmissing-format-attribute]
  121 |                 retval = vsnprintf(buffer, buflen, format, args);
      |                                                                ^
drivers/scsi/esas2r/esas2r_log.c:121:12: note: 'esas2r_log_master' declared here
  121 | static int esas2r_log_master(const long level,
      |            ^

The warning already got silenced for gcc but not clang in the past.
Rather than modify that hack to turn it off for both, just add the
attribute as suggested and remove the pragma again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/esas2r/esas2r_log.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_log.c b/drivers/scsi/esas2r/esas2r_log.c
index d6c87a0bae09..46f489b2263c 100644
--- a/drivers/scsi/esas2r/esas2r_log.c
+++ b/drivers/scsi/esas2r/esas2r_log.c
@@ -101,11 +101,6 @@ static const char *translate_esas2r_event_level_to_kernel(const long level)
 	}
 }
 
-#pragma GCC diagnostic push
-#ifndef __clang__
-#pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
-#endif
-
 /*
  * the master logging function.  this function will format the message as
  * outlined by the formatting string, the input device information and the
@@ -118,10 +113,9 @@ static const char *translate_esas2r_event_level_to_kernel(const long level)
  *
  * @return 0 on success, or -1 if an error occurred.
  */
-static int esas2r_log_master(const long level,
-			     const struct device *dev,
-			     const char *format,
-			     va_list args)
+static __printf(3, 0)
+int esas2r_log_master(const long level, const struct device *dev,
+		      const char *format, va_list args)
 {
 	if (level <= event_log_level) {
 		unsigned long flags = 0;
@@ -175,8 +169,6 @@ static int esas2r_log_master(const long level,
 	return 0;
 }
 
-#pragma GCC diagnostic pop
-
 /*
  * formats and logs a message to the system log.
  *
-- 
2.39.5

