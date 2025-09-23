Received: from jupiter.guys.cyano.uk (jupiter.guys.cyano.uk [45.63.120.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD2127F011;
	Tue, 23 Sep 2025 12:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.63.120.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758631969; cv=none; b=UOMiyW1lwpjOObR16FMHWPeLGGUVMkgPb765HsIhgpti15AENWBiwNs5zBzenUmNs/1HUMVmEbmdPUQNnwqJO/JD91184KYjyP5WVbJs/4UVSHcg8EGnWwo6CPbiHjqvh9baatwSPdYb6wYAXQYyXsDRa69DucC5fcdpb9iXHi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758631969; c=relaxed/simple;
	bh=FxSKMAWONu8RXtlelGYTmFDuVbfVvZOHM/cZna+C8Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Qib6l4Owcgsck4gog501oHOvlgV2KrkHUpSxEMFWQDpA0pYclhtsLYPyBwkJd05RN3ayXTt5gX8k1yHE7P+Q380gPyidazeh7hiLElsM1CZ82RlV6mnpuF9JHFHE8Y0xMlHTZuZ1Z/XyY1Cy0QsE0MSAVnWsFYrMWEcDyjwc508=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyano.uk; spf=pass smtp.mailfrom=cyano.uk; dkim=pass (2048-bit key) header.d=cyano.uk header.i=@cyano.uk header.b=XQfaYc0e; arc=none smtp.client-ip=45.63.120.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyano.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyano.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyano.uk header.i=@cyano.uk header.b="XQfaYc0e"
From: Xinhui Yang <cyan@cyano.uk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyano.uk; s=dkim;
	t=1758631965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QkisuwnGiq2E0pYTkw2w2kg4gpWBc06v7n3M6QAtZFU=;
	b=XQfaYc0eEJiq9BApajLESnCVrNJ6n29vd6Zqd5vsP7vEA9CvBkkqG+Xz8qP2raR9De3HVg
	hKnqaNoJyQCDsFxkrKsg+fdRyHuglfEATEWlPXYdrRwJ9R74VLPc7Nqu38MacWmW6/QYux
	KYflcCuGzHcWDquKvZnvmZNcrN7AqTKge2SpMJbwAkVUwJHpxGpgoBgjn/2PtEOFYiiiym
	C1P99sahQqrQnWUKVB1bXrEqWE89vuXAb1+NdEL7EAeKuXiGlZDUX6pivmA3cYy09PMLQD
	BdtKq8aHku4mWOe+/iCRUmSQsq0wc9viq8DUYwJ7H00bb96mTJCo//Qk3eNWeg==
Authentication-Results: jupiter.guys.cyano.uk;
	auth=pass smtp.mailfrom=cyan@cyano.uk
To: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org,
	Mingcong Bai <jeffbai@aosc.io>,
	Kexy Biscuit <kexybiscuit@aosc.io>,
	Xinhui Yang <cyan@cyano.uk>,
	Oliver Neukum <oliver@neukum.org>,
	Ali Akcaagac <aliakc@web.de>,
	Jamie Lenehan <lenehan@twibble.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 0/2] dc395x: fix compiler warnings and improve formatting of the macros
Date: Tue, 23 Sep 2025 20:52:23 +0800
Message-ID: <20250923125226.1883391-1-cyan@cyano.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: /

This series of patches clears the compiler warnings for the dc395x
driver. 

The first patch introduces a new macro that casts the value returned by
a read operation to void, since some values returned by some specific
read operations (which just simply clears the FIFO buffer or resets the
interrupt status) can be ignored. Creating a new macro that casts the
return value to void to fix the warning.

During the fix, checkpatch.pl complained about missing whitespace
between macro arguments and missing parentheses around complex
expressions. To align with the changes in the first patch, the
formatting of macros above and below the introduced macro are also
fixed.

Since in Patch v2 [1] Bart pointed out that such change can't be made
to the stable tree, the patch is splitted to two parts.

---
Changes since v2 [1]:
- Split the patch into two parts, the first one fixes the warning, and
  the second one improves the formatting of the surrounding macros.
- Make the description of the formatting changes more clear.

Changes since v1 [2]:
- Add Cc: tag to include this patch to the stable tree.
- Add additional description about the formatting changes.

[1]: https://lore.kernel.org/linux-scsi/20250922152609.827311-1-cyan@cyano.uk/
[2]: https://lore.kernel.org/linux-scsi/20250922143619.824129-1-cyan@cyano.uk/

---
Xinhui Yang (2):
  scsi: dc395x: correctly discard the return value in certain reads
  scsi: dc395x: improve code formatting for the macros

 drivers/scsi/dc395x.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

-- 
2.51.0

