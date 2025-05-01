Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D9420C014;
	Thu,  1 May 2025 18:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746124772; cv=none; b=l+vajoigE5Mqm1fS5yIerD+hgckgHf6cXoaKs8jr1yMmgkLG4G6Qk/3iNdrPyVj4QF0Ujke8wzuVFT6WiwUw35c2CAJ9eWhIIzx4+8I4zl6AP5c7wtL7SiF24BtqKC8sncsvXlMFHN6++BJZV2ZO9o/Vyehf3vd5woeJ7GtbZWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746124772; c=relaxed/simple;
	bh=kx7mZrBm5ITwOGexgKTDEpgWSzrbQNC876wxBUvOef4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=btUtGXtTSRP0WjMXHCI/VSIw0rPNt8sPfncQmun/4CMGQSmUkoACo7lP2Gst2SIaJVXSVamqBC6BgwxiXNzAony1xCu358uEzMuEI8b0oE1fCeTO8RUi+MxnJQXzMbJpfUjA+rPnp3ube71/l43ESwNpW988GdpU9VveppRR5ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=slSa4vff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="slSa4vff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7B8C4CEE3;
	Thu,  1 May 2025 18:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746124772;
	bh=kx7mZrBm5ITwOGexgKTDEpgWSzrbQNC876wxBUvOef4=;
	h=Date:From:To:Cc:Subject:From;
	b=slSa4vff6aExOuMZ13cCqpVsq05ZKTz5hUtYHWiwYS2ANtKmK97njF29K7rZc5SMo
	 X4rMhiZOk+y7KItKGQZRK9PgEfu6Odwv7l7SAgTIRC12xjto7Ai6fR6cHiYCLo9Y43
	 QCVgFZL/NpbmUjNXXsPUegZWKHa9lGnuvoRsiOYBmxNIOHhNFwj4sJtEyKx456EsAr
	 EdpzWaXPcJC50gTDO7nhuN7IlJWEO6/IusMkstI0DF97zD4o4webKTdU7wwIR7tMeo
	 Q8hMFZuupuo9UOwI+gRgXvCgS/HxlEmUvuFVC7kxnMdcvpTDd78e+VWEwNcXq9IFnW
	 +WQF7uC94T6/w==
Date: Thu, 1 May 2025 12:39:27 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2][next] scsi: sd: Avoid -Wflex-array-member-not-at-end
 warning
Message-ID: <aBO_32OsMj3hsJsv@kspp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Apparently, the flexible-array member in `struct scsi_stream_status_header`
is not actually needed. Remove it along with the related KUnit test.

So, with these changes, fix the following warning:

drivers/scsi/sd.c:3195:50: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Co-developed-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Revome flexible-array member. (Christoph)

v1:
 - Link: https://lore.kernel.org/linux-hardening/aAwos0mLxneG9R_t@kspp/

 drivers/scsi/scsi_proto_test.c | 8 --------
 drivers/scsi/sd.c              | 2 +-
 include/scsi/scsi_proto.h      | 1 -
 3 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_proto_test.c b/drivers/scsi/scsi_proto_test.c
index c093389edabb..2fc5c6523184 100644
--- a/drivers/scsi/scsi_proto_test.c
+++ b/drivers/scsi/scsi_proto_test.c
@@ -30,14 +30,6 @@ static void test_scsi_proto(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, get_unaligned_be16(&ss.s.stream_identifier),
 			0x1234);
 	KUNIT_EXPECT_EQ(test, ss.s.rel_lifetime + 0, 0x3f);
-
-	static const union {
-		struct scsi_stream_status_header h;
-		u8 arr[sizeof(struct scsi_stream_status_header)];
-	} sh = { .arr = { 1, 2, 3, 4, 0, 0, 5, 6 } };
-	KUNIT_EXPECT_EQ(test, get_unaligned_be32(&sh.h.len), 0x1020304);
-	KUNIT_EXPECT_EQ(test, get_unaligned_be16(&sh.h.number_of_open_streams),
-			0x506);
 }
 
 static struct kunit_case scsi_proto_test_cases[] = {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 950d8c9fb884..3f6e87705b62 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3215,7 +3215,7 @@ static bool sd_is_perm_stream(struct scsi_disk *sdkp, unsigned int stream_id)
 		return false;
 	if (get_unaligned_be32(&buf.h.len) < sizeof(struct scsi_stream_status))
 		return false;
-	return buf.h.stream_status[0].perm;
+	return buf.s.perm;
 }
 
 static void sd_read_io_hints(struct scsi_disk *sdkp, unsigned char *buffer)
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index aeca37816506..bc8f2b2226be 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -349,7 +349,6 @@ struct scsi_stream_status_header {
 	__be32 len;	/* length in bytes of stream_status[] array. */
 	u16 reserved;
 	__be16 number_of_open_streams;
-	DECLARE_FLEX_ARRAY(struct scsi_stream_status, stream_status);
 };
 
 static_assert(sizeof(struct scsi_stream_status_header) == 8);
-- 
2.43.0

