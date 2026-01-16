Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F522F1FC2;
	Fri, 16 Jan 2026 08:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768551257; cv=none; b=Qig7EaNdQW/6BUcPoxMoIVY2lFKY61D/nm8iv1RK23xvYdOwrEt+Flhsa60ZE+LC0dvGs9ngW6pjVgohDGhqC/m+EGuMV5sCqiLfhBoXT0Tvz0/N3bHumC1oDtSq3X3e9LqJ8D40PgFFOxzxS1W3JFqwnHcqsDxLXk9/Tft6QW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768551257; c=relaxed/simple;
	bh=2eZrDfubXFMgUViM+5QQHkkdicFnc5S2ceEH8GCSr5U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LWePai0We3yFvfazVt+KcT05phKB4cWYRybgqak3lBiDg+mYAuqO5D+Sy9PdlJuXSDKBIJ2oVhnz4etz/wBhmQPgRfc/lpi/62zFOXeN7109urGluh60QjiFOkvT8wjCUw+Ay+lFUwQmASNC36kWTOaAPZmK5pAvzK2zXGXCBBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOKzf8jX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOKzf8jX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBC8C116C6;
	Fri, 16 Jan 2026 08:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768551257;
	bh=2eZrDfubXFMgUViM+5QQHkkdicFnc5S2ceEH8GCSr5U=;
	h=From:To:Cc:Subject:Date:From;
	b=OOKzf8jXSh67YIcPVMj2cEUwGkyf7U4lqgyafcZOQQvgXsmekcJ89fGL6w1gGbK7u
	 pUFNSiS2CsfTNN+aORdcxc6Qque83ExwisJNvnmIvy8cFN+1zZg+2tAZyHR7jx5BEW
	 dtLRmopFmjXZKDvl7zb3/x0z6r/ehRmQu6gMFkmhog40UHOxWvSvwDqCJK3ONCcntT
	 zNdtR3jQHdGmouwvYtMRvmK+22U86SDs499Kq0VUUZatCSZetPQsH8uvSq4muZZvai
	 DmZaaAZbWcTKF3F0I4uVEdO3zYRc+bCUut0nXh91JSMxdWLZCtV9DaZ39ZjEOyZhhW
	 53XR1K29fcNRQ==
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tzungbi@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: core: Correct wrong kfree() usage for `kobj->name`
Date: Fri, 16 Jan 2026 08:13:59 +0000
Message-ID: <20260116081359.353256-1-tzungbi@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`kobj->name` should be freed by kfree_const()[1][2].  Correct it.

[1] https://elixir.bootlin.com/linux/v6.18/source/lib/kasprintf.c#L41
[2] https://elixir.bootlin.com/linux/v6.18/source/lib/kobject.c#L695

Cc: stable@vger.kernel.org
Fixes: b49493f99690 ("Fix a memory leak in scsi_host_dev_release()")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
---
 drivers/scsi/hosts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e047747d4ecf..50ec782cf9f4 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -373,7 +373,7 @@ static void scsi_host_dev_release(struct device *dev)
 		 * name as well as the proc dir structure are leaked.
 		 */
 		scsi_proc_hostdir_rm(shost->hostt);
-		kfree(dev_name(&shost->shost_dev));
+		kfree_const(dev_name(&shost->shost_dev));
 	}
 
 	kfree(shost->shost_data);
-- 
2.52.0.457.g6b5491de43-goog

