Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5C33B8922;
	Mon,  8 Jun 2026 09:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912550; cv=none; b=jT2q+lEVEWEUz9Xa53uWNFwG65NVq62Oh/x7htPz77ZF5alsVUYrwlw/D1g8r9l2r4Ha8u5qIaICIU8+8NFlq9KnsgjCE5ZcYR7U4TRMtECG7pBkqkLlqwTiNvlUvpf7qO6v47VMNi+Pj5ZkJQES9quYaYKTGOGXqnoB3RRTUkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912550; c=relaxed/simple;
	bh=KMdEgisianD2eNaNrOUJp5NN9qUCvdofgvX6SRjPOm0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YCyh9EIgK8+Dz4LZwE24fPq+fMxQwvx9j9lACq8kW+xCcFu9OTO/cpS655b6qoaWffzvwZmofvStOamFTknHJGBS4ibg81LfIBvBhvUEcITT7KbhDOhFNwjND0VoG4ci61MK0Ap1mTc/SDBuuKbIOUGV+us2NICtirjFhNi0RCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=G5aL5cSG; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="G5aL5cSG"
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWhr-00BS0t-MZ; Mon, 08 Jun 2026 11:55:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
	Subject:Cc:To:From; bh=CC8pkfzlsxzfQemuF1Ye0bG5tTHR3AL4qB3Sf1zoZL0=; b=G5aL5c
	SGMMQg9wGwJ0EIJpVHdAlEa7KOnN/k/5abMjIK3iJ9LubNZZQe4iCAHEKfAwbUjQCAov2TQEbdwGz
	61OgR1KUUgZgnyGpkqzHXYm9ZyJH2ujyduLHHfar0EvA5BsiJzxhV8LqI3rMI8r41Bgssl8D8d4DR
	cn6YTH2WwE8R8upHVyHmKnDNOKQz0pJDVSGyw/xVRRQKzmRcx7ScaL4Xhc6ecoKSAQ72iYuBKBdl8
	+YEwtf1eNoPRwgIge/352MEk6U8SeObcVXX4FdtatROKdyw5epzzHLpd5CUpjbFWkolnn8pBDawvj
	/gNK9z2tnvywyGs6GE1ezBcRfi5w==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1wWWhr-0003ga-6x; Mon, 08 Jun 2026 11:55:43 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wWWhc-00Ag6G-Im;
	Mon, 08 Jun 2026 11:55:28 +0200
From: david.laight.linux@gmail.com
To: Kees Cook <kees@kernel.org>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH next] drivers/scsi/ipr: Use strscpy() to copy strings into arrays
Date: Mon,  8 Jun 2026 10:54:52 +0100
Message-Id: <20260608095523.2606-8-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

Replacing strcpy() with strscpy() ensures that overflow of the target
buffer cannot happen.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
This is one of a group of patches that remove potentially unbounded
strcpy() calls.

They are mostly replaced by strscpy() or, when strlen() has just been
called, with memcpy() (usually including the '\0').

Calls with copy string literals into arrays are left unchanged.
They are safe and easily detected as such.

The changes were made by getting the compiler to detect the calls and
then fixing the code by hand.

Note that all the changes are only compile tested.

Some Makefiles were changed to allow files to contain strcpy().
As well as 'difficult to fix' files, this included 'show' functions
as they really need to use sysfs_emit() or seq_printf().

All the patches are being sent individually to avoid very long cc lists.
Apologies for the terse commit messages and likely unexpected tags.
(There are about 100 patches in total.)

 drivers/scsi/ipr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d207e5e81afe..2282cae97e86 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3034,7 +3034,7 @@ static void ipr_dump_location_data(struct ipr_ioa_cfg *ioa_cfg,
 		sizeof(struct ipr_dump_entry_header);
 	driver_dump->location_entry.hdr.data_type = IPR_DUMP_DATA_TYPE_ASCII;
 	driver_dump->location_entry.hdr.id = IPR_DUMP_LOCATION_ID;
-	strcpy(driver_dump->location_entry.location, dev_name(&ioa_cfg->pdev->dev));
+	strscpy(driver_dump->location_entry.location, dev_name(&ioa_cfg->pdev->dev));
 	driver_dump->hdr.num_entries++;
 }
 
-- 
2.39.5

