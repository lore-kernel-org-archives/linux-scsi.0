Received: from jupiter.guys.cyano.uk (jupiter.guys.cyano.uk [45.63.120.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B88C1E5201;
	Wed, 24 Sep 2025 05:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.63.120.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758693460; cv=none; b=Anx73uhOGvGgmHMaOPIzEc6Vnma7Yj1nM+EdslMNfnnbGsgniAQIHhmT6m76861lED3+ODsN4FIurkZw+utyUKHSiXRCwg2ywrtWEEUZzeNe3ZG/O55DDHZ/irJ3RwWrufzJON21IAXucO0St3H+JUmlbvk212+i8srrVsIdvzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758693460; c=relaxed/simple;
	bh=gWtaD8J/MmBzlfSJfuf9O1PVbCH067bQX5NwH2uFFUc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Vf8fhgaNyy+Rn1D2tzqSb2p8uzoLvfrVSW9d7B+XT31gAhWx03eYtaYdo7IvmOFtW24dcxdwBVDCaQ9ndnCBUPwF4qkwi9973Yw1TkOjz1LNZuWX7YjVx2Z3+K4CZCVRuH/TR765BLhLWaWGuCTe5KKPG1L0pbV62q2lql3KJPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyano.uk; spf=pass smtp.mailfrom=cyano.uk; dkim=pass (2048-bit key) header.d=cyano.uk header.i=@cyano.uk header.b=Khj/wg8z; arc=none smtp.client-ip=45.63.120.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyano.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyano.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyano.uk header.i=@cyano.uk header.b="Khj/wg8z"
From: Xinhui Yang <cyan@cyano.uk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyano.uk; s=dkim;
	t=1758693450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vELpMf9fZyufUspIux90dzw4JTMd+gKytB4HMgzT97g=;
	b=Khj/wg8zzsCfp3fjMbMAroHbiKE2MFj0Yr6s/WFXtXWj/q20P4zMXG3JWcGXT+nnNoRGYR
	b+IMbsw9bCI3h3Kf6yRXw616z4I3im4EIcpyQ1IVezu6zV1RyLAkGWpqrVxaEQ9Lb730vZ
	hA5IOWJhb3rsARpImVVmiqbJsMuQXTJGWuKpvayJW/o5ssh602AKFK14xEY+ErAU2wmNxv
	MmDStMNnyDVbTlDir7J/1PxY0HIXSDh/2eiGw2wwcs+T4jWOQz3/hJNxAaKj7p+vxWMLMY
	J+9WDmkDWQ3XRArhkU5y00Yw2lwDoBOIdtZNKbGEAHo4RmQnXzSLxsts2mU9ZQ==
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
Subject: [PATCH v4 0/2] dc395x: fix compiler warnings and improve formatting of the macros
Date: Wed, 24 Sep 2025 13:56:25 +0800
Message-ID: <20250924055628.1929177-1-cyan@cyano.uk>
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

During the fix, checkpatch.pl complained about missing white space
between macro arguments and missing parentheses around complex
expressions. To align with the changes in the first patch, the
formatting of macros above and below the introduced macro are also
fixed.

Since in Patch v2 [2] Bart pointed out that such change can't be made
to the stable tree, the patch is split to two parts.

---
Changes since v3 [1]:
- Undo some mistakes in the patch 2 of the patch v2 where extra
  parentheses are added around function calls.
- Remove the unnecessary casts from the inb(), inw() and inl() calls,
  so that extra parentheses are no longer required. They are now returns
  the type it was being casted to, as James pointed out.

Changes since v2 [2]:
- Split the patch into two parts, the first one fixes the warning, and
  the second one improves the formatting of the surrounding macros.
- Make the description of the formatting changes more clear.

Changes since v1 [3]:
- Add Cc: tag to include this patch to the stable tree.
- Add additional description about the formatting changes.

[1]: https://lore.kernel.org/linux-scsi/20250923125226.1883391-1-cyan@cyano.uk/
[2]: https://lore.kernel.org/linux-scsi/20250922152609.827311-1-cyan@cyano.uk/
[3]: https://lore.kernel.org/linux-scsi/20250922143619.824129-1-cyan@cyano.uk/

---
Xinhui Yang (2):
  scsi: dc395x: correctly discard the return value in certain reads
  scsi: dc395x: improve code formatting for the macros

 drivers/scsi/dc395x.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

---
Xinhui Yang (2):
  scsi: dc395x: correctly discard the return value in certain reads
  scsi: dc395x: improve code formatting for the macros

 drivers/scsi/dc395x.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

-- 
2.51.0

