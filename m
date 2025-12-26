Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2928C3A1E6F
	for <linux-scsi@vger.kernel.org>; Fri, 26 Dec 2025 03:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766719232; cv=none; b=oPhuk4dv6DZOdLarjSTJK5Tvcd5rhjWgbyRdFuU1Bkd51UolhSeS2h4J1Hiv1DSJp+Kw+J/VyIp2Z/xbbZnowXV6MgBA94bOUC83Y/pk48+sWyOZwkcIz+HbG/XQj94aTfxpkNhyGrrkDvjnE5QvBiDtE7Wc2u6Smn2kaq+iirs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766719232; c=relaxed/simple;
	bh=P6EOYGeujkiUsRpLq6CxUyJKoET1NY2wvVbxD9Xz39I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hN1EN8LP1wHJZE+fNHTxAuaGhiXJk/xhcobahXXLndoadKuaNJq7nw5Eekx/28yZha0RXhh8YAe+7vwqPjq4jrzWSpdN7qysh4zYP8YQjv7Q0zepSmGVTHqxsDQD3dOhjUeDgYxknH6WmsI4ePqWEiIshScpgo6g4Rt4PTjyLWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=UAElTtBY; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="UAElTtBY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=CR
	Bz8T63jtB1mVpjAdu8JZ4ij1n3Y5MaNTv1/ACBUjs=; b=UAElTtBYdQcQmzlNd2
	GjyWU+Af0/RN4hpdDGKFe5hB1j0xKIUjPXFMOb750p0gbXsO7/VixaoQkGwExkBP
	b/R37SrLBibpid48G62fL50PzygvcEwnEpVkRNosEY3mt82DC1BTwQ7IX0LOV1ZF
	X2l7591E1RduRwIAFm3MTsznQ=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wBHbBzx_k1pU_VwCQ--.2S2;
	Fri, 26 Dec 2025 11:20:20 +0800 (CST)
From: ReBeating <rebeating@163.com>
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	ReBeating <rebeating@163.com>
Subject: [PATCH] sbp: potential integer overflow in sbp_make_tpg()
Date: Fri, 26 Dec 2025 11:19:36 +0800
Message-ID: <20251226031936.852-1-rebeating@163.com>
X-Mailer: git-send-email 2.43.0.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHbBzx_k1pU_VwCQ--.2S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF1UWF4xtr18CFW3Ww43trb_yoW8Jw47pF
	4kX3s0yrW7KFWUJw48AF4UXFy5Ww4kKryjyr4xK3y0vay3JF4xXrnrKay2vF15XFyxGa1U
	Kay8Z3WUAw45JaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRoSoLUUUUU=
X-CM-SenderInfo: 5uhevtpwlqwqqrwthudrp/xtbC0hSqu2lN-vS+EAAA3X

The variable tpgt in sbp_make_tpg() is defined as unsigned long and is 
assigned to tpgt->tport_tpgt, which is defined as u16. This may cause an 
integer overflow when tpgt is greater than USHRT_MAX (65535). I 
haven't tried to trigger it myself, but it is possible to trigger it
by calling sbp_make_tpg() with a large value for tpgt.

I modified the type of tpgt to match tpgt->tport_tpgt and adjusted the 
relevant code accordingly.

This patch is similar to commit 59c816c1f24d ("vhost/scsi: potential 
memory corruption").

Signed-off-by: ReBeating <rebeating@163.com>
---
 drivers/target/sbp/sbp_target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 3b89b5a70331..ad03bf7929f8 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1961,12 +1961,12 @@ static struct se_portal_group *sbp_make_tpg(struct se_wwn *wwn,
 		container_of(wwn, struct sbp_tport, tport_wwn);
 
 	struct sbp_tpg *tpg;
-	unsigned long tpgt;
+	u16 tpgt;
 	int ret;
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
-	if (kstrtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)
+	if (kstrtou16(name + 5, 10, &tpgt))
 		return ERR_PTR(-EINVAL);
 
 	if (tport->tpg) {
-- 
2.34.1

