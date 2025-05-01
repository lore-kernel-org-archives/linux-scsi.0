Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AB21362;
	Thu,  1 May 2025 14:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746110715; cv=none; b=qxjNlWuC3vM0kCdI/XM9cIqnWWIBZ/3eRmxUPozbn/u9HUytNA4hHz6+fzU7tXKiWGG5xSIxZzJOeVSy8T6d0XnncMO6IeRh201wmeaD7Ny9YkwPjdLkrdZ3A9ERtLDJS0la7uKC+2AkkdW0FAvbteL5uhSpOcw2r2DLKIR3d8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746110715; c=relaxed/simple;
	bh=MX70R5qPsfWN7vxQk7uLTqtc2qhE2pX88q+5UFPDCD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mLKHX5VdXegNsX2+2xfrnLzsnFmECymjFmDw0FJk1uGfqIn9lYXrcc9MzYUWxhSyvWev6cjgnHWCRI4HChCeNEOUfaHNW+9bX/1fDcIexPmCvtlUGvNZdFqfSIWNqbavW15xVUCGQnE1zk5boe++E9i4qPA6FlI6gc9KkL4s2G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cT1FwcLr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cT1FwcLr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ScPmgBC8PfQMdSp/4s7cQBxvsXeTUFa41CdsXzvcv/I=; b=cT1FwcLrsesNlO2TAolL/XpPqT
	jzCIxeOn/r3wO2PKVdTCeas0VWT0TM877kShlZ4JxVwZ998C9GmX8IKknFAMVYoIoHif+iFBv7Bbd
	Aog26vcpg99lzCdI8KMVLiQycZUR0KPRJrU9jY6amQH1Ug+g+o9XyKQzqfgKR+Fwvda2e54C83fsH
	sbekSn8d4zztPLX173cxX8EDZ0rkJAydftEDTMfnZXtlwPUhRtY9leHwBIaSx2kC2i7HHg5aW3uwF
	Bpw3ofYVY/xG5RivvwVBZWlKs2Rwj6Mw2dC6xR4bRXwdP8qcZoZjw9uDarT8t/RGiaHusMfqhVSr+
	eHi1fU4w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAVA1-0000000Fzzw-1KWy;
	Thu, 01 May 2025 14:45:13 +0000
Date: Thu, 1 May 2025 07:45:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: sd: Avoid -Wflex-array-member-not-at-end
 warning
Message-ID: <aBOI-cmnvqMjV0yX@infradead.org>
References: <aAwos0mLxneG9R_t@kspp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAwos0mLxneG9R_t@kspp>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Yikes.  This is way to ugly to live.  Just remove the silly flex
array entirely and everyone is better off:

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
