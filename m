Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE40246795;
	Fri, 19 Sep 2025 11:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758281078; cv=none; b=ekTdc90ZlLv6Q4/Q28OMdF4z4ML6xJrmn1hJorq9Kr1tsqnIo/QGzDz/lkwC1zdih0brrgTA2KyG9warDATyeH9oZRPZM7DYqLHI8PET8aMbwuuy2wK7E9b18NNt/Mkfs1pp0cZo8nopxd/5wA/g4ezb7jNjGnx2QvIDh4RJibM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758281078; c=relaxed/simple;
	bh=eQh/fnW6AUU5yRkPsxlaV5lCpSBqXst9/XL6eG70HJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VWug5tb1YZPHI1elLvMUkxLrqQ3vpGrnlepfxfm7dUHNA+d7Oq/1LEJIb7pNXIeiRkyiciVDrimMhZZH5X04izKooxIDWWjoipvQzJTvVUs6twoBpSQ/GKv+eU7e8f+JHa71fLwnPPO4CVRt/PjNBU33zFhDVHYf4zSgzOS0EsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uaFH0JtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uaFH0JtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072ECC4CEF0;
	Fri, 19 Sep 2025 11:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758281077;
	bh=eQh/fnW6AUU5yRkPsxlaV5lCpSBqXst9/XL6eG70HJQ=;
	h=Date:From:To:Cc:Subject:From;
	b=uaFH0JtQG0xYTc220Hs1ABxZiz9d0FLWHZs+m0oD86MNGKfXTi7qP9bz9duZimrX0
	 isSDjkeL+A4vt4godEjaLyJZKxSQEo6rDqq+xhJSMty8B2JXbEx30sZyrzD2Cxr87q
	 IZYiqgz+Wb7pH8ZewEAQgRNuWJbGbqPX1l27eYNilzh/4eilrV9PqzvxBjCMA0Jxmw
	 jwf2hHSSZvNy3KuGLnFkTPGINWpZuwSdoh2Z84okQttYsbwTRauYS+0ibs/KTjupVm
	 2VdxTKXD83pI/ZmYmj6GBvuT8I2ff5f2OnSHueGbkJtOks+pocqRSOheXIPxRGjvEQ
	 GNaML1HKWVS0g==
Date: Fri, 19 Sep 2025 13:24:30 +0200
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] scsi: isci: Avoid -Wflex-array-member-not-at-end
 warning
Message-ID: <aM09bpl1xj9KZSZl@kspp>
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

Move the conflicting declaration (which happens to be in a union,
so we're moving the entire union) to the end of the corresponding
structure. Notice that `struct ssp_response_iu` is a flexible
structure, this is a structure that contains a flexible-array member.

With these changes fix the following warning:

drivers/scsi/isci/task.h:92:11: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/isci/task.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/isci/task.h b/drivers/scsi/isci/task.h
index f96633fa6939..d05d09c1263d 100644
--- a/drivers/scsi/isci/task.h
+++ b/drivers/scsi/isci/task.h
@@ -85,15 +85,17 @@ struct isci_tmf {
 
 	struct completion *complete;
 	enum sas_protocol proto;
+	unsigned char lun[8];
+	u16 io_tag;
+	enum isci_tmf_function_codes tmf_code;
+	int status;
+
+	/* Must be last --ends in a flexible-array member. */
 	union {
 		struct ssp_response_iu resp_iu;
 		struct dev_to_host_fis d2h_fis;
 		u8 rsp_buf[SSP_RESP_IU_MAX_SIZE];
 	} resp;
-	unsigned char lun[8];
-	u16 io_tag;
-	enum isci_tmf_function_codes tmf_code;
-	int status;
 };
 
 static inline void isci_print_tmf(struct isci_host *ihost, struct isci_tmf *tmf)
-- 
2.43.0

