Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1CC1459F7;
	Mon,  5 May 2025 06:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746426178; cv=none; b=bSsZmHWu3HT6F7dG9kgWoamofmH7VE5cy5/JBvwQFjXV6G/SZYag8oWMwEYgkppzpt/HlFhTCatuRO9HjtcLpKJQR0nFft5rdUM12h7E3VpgJKME2uF5LRMkiEruUQgesnZjnOx8Aw2XssqnO2SHrUzUvQepurlpbZ+Q5Uq6y7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746426178; c=relaxed/simple;
	bh=MPUs4KraZc3aeghxZP54Y8ZKgxtKYIoo7VWIRHwCrow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKjtLrsepv8wV2fwGQdoV/1FMqD8JZPGyU04pB6LTDtvmKgg+/J/cEKTEF29rM9fgUeFup2JrbpwzxB2z336v7xZ1u+ECr0qk3mg5gXU6AQuLoPtJIYnmIf5xe8C/TatXqc/cvt3gFa69x5VTrG49uqEhdrD/oN8z+YMDDscdag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QiylwdGt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QiylwdGt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6crzyY4cRgs7sWNOVET6cPYOHzfjUqNaeeku35IfyF4=; b=QiylwdGt65nFPM0JNR3fMaNZuA
	Xt3wXttqIBV3/rty7gejWyvvemGT5SH2vSDn5Qluc7xEDj53AAe9vdBzFp2LafK41wer+kAOwa7lS
	hcQ/AeWxm4afC9iOx/WaIgLg2QiEsXz1QkJ1gdpHzklRuEFe3KuhHliuSnrsTqh0+5uRRvR+EmTHS
	EV+l2EpTFT2Vrn3NB1HsFwRgXT9euCn51TzRMEgI4LdZlhhAojDAr93gj232XyNxadj2mTML7MRjl
	SDoQe6HJaGd80Fz5l2g8xHunE4wLV32VIsy/10lNAelvJebRrI3jjdY2Qnxsmphn7DPNBtq9nkH8u
	L1x+mcFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uBpE6-00000006Vu5-3QMm;
	Mon, 05 May 2025 06:22:54 +0000
Date: Sun, 4 May 2025 23:22:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2][next] scsi: sd: Avoid -Wflex-array-member-not-at-end
 warning
Message-ID: <aBhZPm28c6Yn5KH2@infradead.org>
References: <aBO_32OsMj3hsJsv@kspp>
 <aBRrP8EuNkeAtPC9@infradead.org>
 <33d7a1b3-4bf7-4337-ba82-dbd4b95ad0b8@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33d7a1b3-4bf7-4337-ba82-dbd4b95ad0b8@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, May 03, 2025 at 12:08:23PM -0700, Bart Van Assche wrote:
> On 5/1/25 11:50 PM, Christoph Hellwig wrote:
> > (I still wish we'd kill the stupid struct and this test and just used
> > the simpler and cleaner bitshifting and masking)
> 
> Bit-shifting and masking results in faster code. For slow path code I
> prefer bitfields because this results in much more compact source code.

Despite claims to the contrary bit tests and masking are often a lot
simpler, and you don't need the duplicate struct layouts and tests
verifying that you get them right as it is almost impossible to write
code that only works on LE or BE.  E.g. the patch below would simplify
the stream status quite a bit.  It also fixes the assumption that the
bitfield endianess is the same as the byte endianess, which is not
true in general (although I think it is for all Linux supported
architectures).

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f0eec4708ddd..41ed22f1ad0b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5528,7 +5528,8 @@ static int resp_get_stream_status(struct scsi_cmnd *scp,
 	     offset += 8, stream_id++) {
 		struct scsi_stream_status *stream_status = (void *)arr + offset;
 
-		stream_status->perm = stream_id < PERMANENT_STREAM_COUNT;
+		if (stream_id < PERMANENT_STREAM_COUNT)
+			stream_status->flags |= SCSI_STREAM_STATUS_PERM;
 		put_unaligned_be16(stream_id,
 				   &stream_status->stream_identifier);
 		stream_status->rel_lifetime = stream_id + 1;
diff --git a/drivers/scsi/scsi_proto_test.c b/drivers/scsi/scsi_proto_test.c
index c093389edabb..d61302e7715a 100644
--- a/drivers/scsi/scsi_proto_test.c
+++ b/drivers/scsi/scsi_proto_test.c
@@ -22,15 +22,6 @@ static void test_scsi_proto(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, d.desc.params[0] + 0, 0xe4);
 	KUNIT_EXPECT_EQ(test, d.desc.params[1] + 0, 0xe3);
 
-	static const union {
-		struct scsi_stream_status s;
-		u8 arr[sizeof(struct scsi_stream_status)];
-	} ss = { .arr = { 0x80, 0, 0x12, 0x34, 0x3f } };
-	KUNIT_EXPECT_EQ(test, ss.s.perm + 0, 1);
-	KUNIT_EXPECT_EQ(test, get_unaligned_be16(&ss.s.stream_identifier),
-			0x1234);
-	KUNIT_EXPECT_EQ(test, ss.s.rel_lifetime + 0, 0x3f);
-
 	static const union {
 		struct scsi_stream_status_header h;
 		u8 arr[sizeof(struct scsi_stream_status_header)];
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3f6e87705b62..deb8af152f13 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3215,7 +3215,7 @@ static bool sd_is_perm_stream(struct scsi_disk *sdkp, unsigned int stream_id)
 		return false;
 	if (get_unaligned_be32(&buf.h.len) < sizeof(struct scsi_stream_status))
 		return false;
-	return buf.s.perm;
+	return buf.s.flags & SCSI_STREAM_STATUS_PERM;
 }
 
 static void sd_read_io_hints(struct scsi_disk *sdkp, unsigned char *buffer)
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index f64385cde5b9..88c1d950be54 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -319,26 +319,10 @@ static_assert(sizeof(struct scsi_io_group_descriptor) == 16);
 
 /* SCSI stream status descriptor */
 struct scsi_stream_status {
-#if defined(__BIG_ENDIAN)
-	u8 perm: 1;
-	u8 reserved1: 7;
-#elif defined(__LITTLE_ENDIAN)
-	u8 reserved1: 7;
-	u8 perm: 1;
-#else
-#error
-#endif
-	u8 reserved2;
+	u8 flags;
+#define SCSI_STREAM_STATUS_PERM		(1u << 7)
 	__be16 stream_identifier;
-#if defined(__BIG_ENDIAN)
-	u8 reserved3: 2;
-	u8 rel_lifetime: 6;
-#elif defined(__LITTLE_ENDIAN)
-	u8 rel_lifetime: 6;
-	u8 reserved3: 2;
-#else
-#error
-#endif
+	u8 rel_lifetime;
 	u8 reserved4[3];
 };
 
