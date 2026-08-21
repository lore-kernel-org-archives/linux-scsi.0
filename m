Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DBC3EC817;
	Fri, 21 Aug 2026 05:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787289112; cv=none; b=A8kZ+0h+SglnOWzHYwqUCigiVdsSpnJ5zvD3LqTxpaY8gThBgMmag7yqeUbvp9/8z5bq9SFAZKPJRvBAdTK+5dZX1SP2QIq50omOz2LKOG8JMjpDS9Sv7rto6AOZfvFb8z8MuNK6P+0fv2O5hY8H3WGxKmga7yhcghAV17Jmuek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787289112; c=relaxed/simple;
	bh=UAX5N13KlfmntXvQjRFIOqOFVKy3G0NN/NBSfRCzVSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsFIcZFlso9xmP4M0wV8Z6CaJ7PtXIGvLjdWOt1fKjpq0Db8tlsOxPkHhHHL8fjvPIcA8Q+taZXXl7jINIMP9X/sagk+np+7fCu/mE59yPEifCF/6ySbbD+afR3x8GceMoIUpde9XuBFSWB6Uri//rOPXrIci+55w35zJRJQJIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DzS+O2jQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DzS+O2jQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=n7DpWwA+NCBNmgT7vq5LEgLOtEBfW+xwH1ozmmozY5M=; b=DzS+O2jQR58f5u5IqSillyxQoL
	ECUYyuMb6DpLvqyX+E47nXBeEBzO/xJyAZ+XWWLnkmN04XQoVJMbgqZZ2ANnRK/EOYL2D8iwNVbQx
	dH4ITQ7bYMufPXNApIIrr2URWg4+GpsVsIM2tl2dQzShluQ4YmHs3CFHFlyhGVoyQphJBoIfyDEF+
	mvK9gTM9zK9nL6Vfh/DfJjXwePdiXu4lItfoIlp5woSExNAqwoUpjrzbLQxAcOSrD4ZUGyMxavVyO
	13wvDia4z0gcSKZvZVAKUuxvamt8nimjN6/WuwMCKDz36iZj/q4neuCegbQqZj6ZBl8Q57Cpbj1ok
	bCfoCLKg==;
Received: from [46.255.74.83] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxHXf-0000000CYBE-0ugF;
	Fri, 21 Aug 2026 05:11:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/5] common: add a _sysfs_block_integrity_path helper
Date: Fri, 21 Aug 2026 07:11:27 +0200
Message-ID: <20260821051133.1817670-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260821051133.1817670-1-hch@lst.de>
References: <20260821051133.1817670-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper function to find the sysfs integrity directory for a given
block device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/common/rc b/common/rc
index 02bdb31a76a6..61a899da3bd7 100644
--- a/common/rc
+++ b/common/rc
@@ -5257,6 +5257,31 @@ _sysfs_queue_path()
 	fi
 }
 
+# Get the sysfs block device integrity/ path for a block device, handling
+# partitions correctly.
+_sysfs_block_integrity_path()
+{
+	local dev parent
+	dev=$(_short_dev "$1")
+
+	# For partitions, integrity details are in the parent device's sysfs dir
+	if [ -e "/sys/class/block/$dev/partition" ]; then
+		parent=$(basename "$(readlink -f /sys/class/block/$dev/..)")
+	else
+		parent="$dev"
+	fi
+
+	local integrity_path="/sys/block/$parent/integrity"
+
+	# Verify the path exists before returning
+	if [ -e "$integrity_path" ]; then
+		echo "$integrity_path"
+		return 0
+	fi
+
+	return 1
+}
+
 # Get the minimum block size of a file.  Usually this is the
 # minimum fs block size, but some filesystems (ocfs2) do block
 # mappings in larger units.
-- 
2.53.0

