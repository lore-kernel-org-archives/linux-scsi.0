Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FFF1FBC91
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 18:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590825; cv=none; b=hksKoy2SWu509XVRuHVo46BX9Wp4tJKO1FS7fDH0G4IPXvb+iiF8zxKENiuz4bv4jCZ1KbT1Bp1yqMqxfWSBAIA4PHzg1+2pgZFGf8TnpyqEBButoQXEAvuK88TETHuNkFOsQ25bPdSTBglr5ZOQdXKN+qKp5VmqPt/guxpijrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590825; c=relaxed/simple;
	bh=ZrTSzKx4GpuadY2GmRsG8Io4R+dmUy4YqX8fWgHp+k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiFGN5kN5wIHa8gALXwajdTY89TFBXmMehjH2iVmqqHMCqHLnZIpS+4FtvYnC6UateNE4ygzxFmPui7u+UvxVseVcU2yGrcpLGQ65w5ynoS8K7wnCuM1PNePuhvZyeLn7vGrX+r3q0/3l5L+hUsGediBLEEhcF/0AKlj+yOjVG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FVsxBO4V; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FVsxBO4V"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cwMtX5lX1zlgqyM;
	Mon, 27 Oct 2025 18:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761590819; x=1764182820; bh=LHaqY
	LAIJY7keO9DnL4vu9Z/FmerXaz5HkTCxeUkmJo=; b=FVsxBO4Vs6AE/sARrwzSl
	C0lp4pssZkhbAEIp/CKLj3hUnbh4InMrKy37tw788eQLjQUJ/LRaq2K/mBglxaWM
	yGi4Bht/K7TapYDvXGY5xe3MNmma8RFJxFZ/5Py8FoWclLbGaVwmUMH/yleC42jv
	gMfPUDd4RmXxj/SWjQUlHbIKmnQvMz+QNhDFLvHib9OO0Gi5CxphOxYRUrKFcG12
	jovbKLfcXLuM9SLmJRcXiXGQI2UWwsMSnsPn62gw4qDZebv+O/ZzDMydTIFYvBff
	V1mH3aqPXj7QnVbqKmEno/fMDH+GbZISTVkLb+1cbZLmjOgqBmXUrdTvtggvkrWN
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EiSfQQbGdwhL; Mon, 27 Oct 2025 18:46:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cwMtV1Vh1zlgrtT;
	Mon, 27 Oct 2025 18:46:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/2] scsi: target: Simplify target_lu_gp_members_show()
Date: Mon, 27 Oct 2025 11:46:39 -0700
Message-ID: <20251027184639.3501254-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.838.g19442a804e-goog
In-Reply-To: <20251027184639.3501254-1-bvanassche@acm.org>
References: <20251027184639.3501254-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Remove the stack buffer 'buf'. This patch does not modify the output
produced by target_lu_gp_members_show().

An example of the output that is produced with this patch applied:

$ cat /sys/kernel/config/target/core/alua/lu_gps/default_lu_gp/members
fileio_0/vdev0
fileio_1/vdev1
iblock_0/vdev2
$ od -c /sys/kernel/config/target/core/alua/lu_gps/default_lu_gp/members
0000000   f   i   l   e   i   o   _   0   /   v   d   e   v   0  \n   f
0000020   i   l   e   i   o   _   1   /   v   d   e   v   1  \n   i   b
0000040   l   o   c   k   _   0   /   v   d   e   v   2  \n
0000055

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_configfs.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
index 1bd28482e7cb..3887825412e9 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2758,32 +2758,24 @@ static ssize_t target_lu_gp_lu_gp_id_store(struct=
 config_item *item,
 static ssize_t target_lu_gp_members_show(struct config_item *item, char =
*page)
 {
 	struct t10_alua_lu_gp *lu_gp =3D to_lu_gp(item);
-	struct se_device *dev;
-	struct se_hba *hba;
 	struct t10_alua_lu_gp_member *lu_gp_mem;
-	ssize_t len =3D 0, cur_len;
-	unsigned char buf[LU_GROUP_NAME_BUF] =3D { };
+	const char *const end =3D page + PAGE_SIZE;
+	char *cur =3D page;
=20
 	spin_lock(&lu_gp->lu_gp_lock);
 	list_for_each_entry(lu_gp_mem, &lu_gp->lu_gp_mem_list, lu_gp_mem_list) =
{
-		dev =3D lu_gp_mem->lu_gp_mem_dev;
-		hba =3D dev->se_hba;
+		struct se_device *dev =3D lu_gp_mem->lu_gp_mem_dev;
+		struct se_hba *hba =3D dev->se_hba;
=20
-		cur_len =3D snprintf(buf, LU_GROUP_NAME_BUF, "%s/%s\n",
+		cur +=3D scnprintf(cur, end - cur, "%s/%s\n",
 			config_item_name(&hba->hba_group.cg_item),
 			config_item_name(&dev->dev_group.cg_item));
-
-		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
-			pr_warn("Ran out of lu_gp_show_attr"
-				"_members buffer\n");
+		if (WARN_ON_ONCE(cur >=3D end))
 			break;
-		}
-		memcpy(page+len, buf, cur_len);
-		len +=3D cur_len;
 	}
 	spin_unlock(&lu_gp->lu_gp_lock);
=20
-	return len;
+	return cur - page;
 }
=20
 CONFIGFS_ATTR(target_lu_gp_, lu_gp_id);
