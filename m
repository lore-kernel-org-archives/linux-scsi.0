Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDD5101C6
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2024 06:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710140079; cv=none; b=fXpXuUiXSRb7SynlVmiE+y01cetpZspF6OYX3W7noAKLyynX08d5huxfOH9BWeYhoy1wH2+iJQ0Ia3K6iErfnfMaUCCX37lK5EAcoZlQFmjCKzaEnElKtFwH38qXHa71ocG/nLMehRRDAZrgwtZyTuyVdNyAA6OLgNoHktEjf7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710140079; c=relaxed/simple;
	bh=75VZ4uY/3LdVEp3CcJ2taoalZb4yjw1aG7xG/xgar4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeH/uqQCK8XnBJMFkZQWPv99r7YFqpu2hoJLNud/NFDV8jSqF6HCoPeK7TG8famXKRWEQ8NQjx85fslOGOM6lgQI2NByisTZj+ey/CQsOMWlD5VH5oB43q3SpLRt+80xxTxwd2aqHrJy0CF3A0t9gbQbDHiYr6PQpnHpD5phBFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=ZGTC/hwv; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZGTC/hwv"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1710140078; x=1741676078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=75VZ4uY/3LdVEp3CcJ2taoalZb4yjw1aG7xG/xgar4Q=;
  b=ZGTC/hwvzkLM9+/jVLu1jFXoGVcLuDxDQaHaC+NqmHWkDlf4kLoVoe8j
   RfcB4nG3nsam9ksYJhoXElAGSS4CvVq2ssFLk+eqTCObxLfDCqkVyuMav
   7QX17ip+vYloCeqsu4GIoKgGW+UmTncXoTTad+5ZHc6vDlEe5s6SOi44Z
   l+P5YCDn86EuWHuOHNcWvR+8jp1fQS1shw2hYtm/ym9hOLC7bFQjNneO/
   EZvLV9IFTcWKC8c+NdSf75x2gGMCLR+gPy8SWyz6k8TYpOBtr9e5JVhwZ
   4iEmb8FqdSpGoTZYtJpcUhcHzH//wfi2cWCYKVzCKLwnvXQ6eKxV/lCy4
   Q==;
X-CSE-ConnectionGUID: SbaRYobVQiynejfGLj5SdA==
X-CSE-MsgGUID: Oni2s385QS2kwL7aKAtBsA==
X-IronPort-AV: E=Sophos;i="6.07,115,1708358400"; 
   d="scan'208";a="11270708"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2024 14:54:30 +0800
IronPort-SDR: XojlvIbUIqBueFlLF3mL5wfYTYz87KeUOMjGyReKAggYa1my6SPx5x30QaiGl9ChGYTQ6cv1rr
 fx/oQFyghvHw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Mar 2024 22:57:53 -0700
IronPort-SDR: RFgchh1F2fAGd6KeWFoLbrQk32IGEbJPcxajWEzA5cdDSPSBNyY7vAbV40L7+c7Qq4L+JGIKXS
 SzuuespFfKeg==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2024 23:54:29 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Douglas Gilbert <dgilbert@interlog.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH RFC 2/2] scsi: scsi_debug: Allow dev_size_mb changes through sysfs
Date: Mon, 11 Mar 2024 15:54:27 +0900
Message-ID: <20240311065427.3006023-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240311065427.3006023-1-shinichiro.kawasaki@wdc.com>
References: <20240311065427.3006023-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The parameter dev_size_mb is read-only and can be modified only when
scsi_debug is reloaded. Therefore, loadable scsi_debug is required to
specify the desired dev_size_mb. With the built-in scsi_debug, only the
default dev_size_mb value can be used.

To allow testing with built-in scsi_debug and any dev_size_mb value,
make the parameter writable. To take the required actions at the
parameter writing and change, allow such writing not through the sysfs
module attribute, but through the sysfs driver attribute. The parameter
is stored as a global variable and referred to in many places, then
changes of the value would causes troubles for existing live hosts. To
avoid the troubles, allow the value changes only when there is no host.
Users must remove all hosts to write new dev_size_mb values.

At the parameter write, call scsi_debug_init_size_parameters() to
propagate the dev_size_mb value changes to dependent parameters. Also
erase all stores at dev_size_mb change and recreate the store with the
new dev_size_mb value.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/scsi_debug.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c6b32f07a82c..c93cac831d8e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -558,6 +558,8 @@ static void sdebug_erase_all_stores(bool apart_from_first);
 
 static void sdebug_free_queued_cmd(struct sdebug_queued_cmd *sqcp);
 
+static void scsi_debug_init_size_parameters(void);
+
 /*
  * The following are overflow arrays for cdbs that "hit" the same index in
  * the opcode_info_arr array. The most time sensitive (or commonly used) cdb
@@ -6660,7 +6662,42 @@ static ssize_t dev_size_mb_show(struct device_driver *ddp, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_dev_size_mb);
 }
-static DRIVER_ATTR_RO(dev_size_mb);
+
+static ssize_t dev_size_mb_store(struct device_driver *ddp, const char *buf,
+				 size_t count)
+{
+	bool want_store = sdebug_fake_rw == 0;
+	int n, ret;
+
+	if (sdebug_num_hosts) {
+		pr_err("scsi_debug: Can not change dev_size_mb due to existing hosts\n");
+		return -EINVAL;
+	}
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 1)) {
+		sdebug_dev_size_mb = n;
+
+		/* Propagate dev_size_mb change to other parameters */
+		scsi_debug_init_size_parameters();
+
+		/*
+		 * Erase all stores which may have different size. Initialize
+		 * global variables for the stores and recreate the store.
+		 */
+		sdebug_erase_all_stores(false);
+		sdeb_first_idx = -1;
+		sdeb_most_recent_idx = -1;
+		if (want_store) {
+			ret = sdebug_add_store();
+			if (ret < 0)
+				return ret;
+		}
+		return count;
+	}
+
+	return -EINVAL;
+}
+static DRIVER_ATTR_RW(dev_size_mb);
 
 static ssize_t per_host_store_show(struct device_driver *ddp, char *buf)
 {
-- 
2.43.0

