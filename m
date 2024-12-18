Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4726F4A23;
	Wed, 18 Dec 2024 00:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480475; cv=none; b=azIAM8R2XO3NSEblZ1yjhH5awjzaJsB3Kx0Ygi+E6jzzi6hPhfVzgGXNQ1P5TMZOYyL29BqBZW2OHYlLACjmtKWMh8FDUp7XqpKBph9E7De/cJTtSfEP2LQWex2KToQcnW3NdmLl2P4QnE1sMA8uBmlkn206ikQ6cgIV+moAKlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480475; c=relaxed/simple;
	bh=+vGwqR0HI5ehYZ3CgfKT287DgeFWrca+Wx0ZlLLLoUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O+jlfY6uF+vP0oPTyhoAcZfsGDVIQE73x+zXN2tPkxxZTWbkmctVtljWCR63LNzYrc3Zt9KKvChtbRsaDD9efqVNHLGPlqUcwm6y7qfUWy2ox18Om4ZhIyO70fL0EjE7BkpvyAs0fsu+EUkHiI6INtX1g4vqtv+EfFnK98eqOJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ER3DB6F3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ER3DB6F3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=xzBErjAy6OgdY84qzUG5uVolg/Q9mu2T51bY/+GQVTQ=; b=ER3DB6F3Hnp8HnqJ1sPLVpHxOf
	kU0DrNj5EWVG3R/HWapSTY+UIHB68UZBaMtReEay2rRuejrc7mJnV8gmuCq8a6lJlGyN6MwQDD4d2
	4WxUbtoIhnXkA5oa4Ydnxue8eHYEDZimZBHxz7D+V4nSMd660S9b0SGVUDAZ/Wr2P17uUbCDZsuUg
	D1geeJl6nmFUkHXHiMQIzmQ+Ka+Fi845itNRWxh3L+nNYIe8KckDFDJgITSpvDr0eChDZW7D1+4my
	44BXiol/Vg+VmQPLe2aWTcM8i/wWcg+3HRwB0a/mC78l60kgVbsdUGLzuj5wvPhwojNZMT0ddKa8T
	HYAnPtTw==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tNhbT-0000000FAsD-3JFd;
	Wed, 18 Dec 2024 00:07:51 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Subject: [PATCH] scsi: driver-api documentation: change what is added to docbook
Date: Tue, 17 Dec 2024 16:07:48 -0800
Message-ID: <20241218000748.932850-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For scsi_devinfo.c, use :export: so that exported symbols are put into
the docbook. Drop :internal: -- they aren't needed in the docbook.

For scsi_proc.c, drop :internal:. This will cause all documented private
(as is already done) and exported symbols to be added to the docbook.

For scsi_scan.c, switch from :internal: to :export: so that exported
symbols are put into the generated docbook.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/driver-api/scsi.rst |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-next-20241212.orig/Documentation/driver-api/scsi.rst
+++ linux-next-20241212/Documentation/driver-api/scsi.rst
@@ -126,7 +126,7 @@ Manage scsi_dev_info_list, which tracks
 devices.
 
 .. kernel-doc:: drivers/scsi/scsi_devinfo.c
-   :internal:
+   :export:
 
 drivers/scsi/scsi_ioctl.c
 ~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -162,7 +162,6 @@ statistics and to pass information direc
 plumbing to manage /proc/scsi/\*
 
 .. kernel-doc:: drivers/scsi/scsi_proc.c
-   :internal:
 
 drivers/scsi/scsi_netlink.c
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -193,7 +192,7 @@ else, sequentially scan LUNs up until so
 is seen that cannot have a device attached to it.
 
 .. kernel-doc:: drivers/scsi/scsi_scan.c
-   :internal:
+   :export:
 
 drivers/scsi/scsi_sysctl.c
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
