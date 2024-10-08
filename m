Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEE71DF25D;
	Tue,  8 Oct 2024 13:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394299; cv=none; b=Ut0oLndGSp8yVEKWyjfFnhvKvvd4WHON8ZjtDnargN8hDjgeb8cKF88QtIgCx2KSFHJFCYf4HJrGBq0zcbwMZpqFeGVCDPlFr07+oLCrkOTBrPPLqaQIMP+Lr0XChsjCYHRFwpoNXOX4wxhIEQgfJ0h9Ls1r9iBEFP1oRCuhVd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394299; c=relaxed/simple;
	bh=pchhcscev28Lb9Tm8ayjqw+RLbTGZv7YuwKQdiiyMeY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tdSB4jTqluzBsw3Qvg92ODjc8BK4OzkLw9He73emrJ6ryp+Okorr3uV++aSvTBrynEsy0s+rDKXy7OtozBwCYV+pv4au6fml8FxY9Qyvkpme8GpVq7KBF45p+jLzm2hqhDxXUtotyg79rYbSk8ohPc1dVsj5aWpMfZsUkw3ahfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=qLXFzh51; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=DuRanold; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="qLXFzh51";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="DuRanold"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 32EE1E0018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1728394294; bh=CKT6F4ty/IKEN8AlFOzu72dMdtz8p2k/J2wRmux1lnQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=qLXFzh51loD+IDnL4Rt8iOxoLTA0fjdx3dCMd0w2SdEe91+QdCwR/8XlYBbVUjGUA
	 asotZU54JLRY0KRimzZ3S38qZAEJyIuIBvDxaM8D/J+JezGutafeceKSNqjfHQO7wT
	 QLiKk9BqwIFq4YKSvoLIJR9AW3LsoMjXKF+K9hgVo+oDqMDF+Dpn5iSFk4RNHYJXWn
	 51e4jjPpKoa4vpX8AcT7+t+V+/Gwu60+LS1w+y4RoOSnlx9Q4FikCCaS2Tz0gZs+B6
	 c23skcmtzj3aUojz7JWrAIXffNvY/aHjrwPSBKeRyimj5HHw80WwZkAx80u23p99Y9
	 s1DT94UKQqdfg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1728394294; bh=CKT6F4ty/IKEN8AlFOzu72dMdtz8p2k/J2wRmux1lnQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=DuRanold2zpe3oInYRolXrRXdZnxWTqV6uahmgGzVAJHck4qmzZefLhhqJnxl1Dvq
	 WcGnOh6vrKByNm8jBJMoenJob+7i5y0HKExfPVkeHzPy9KwTNuSWACvoMzcS5tATOc
	 C6w52GzhyNRvaeon6PoMSksa/FV/8LuCkqGnLTULHoY/CK+/ZEVUP1CVg3QZ5cQ0CG
	 DRQpnpL79Wd6W2/rozFA98wc1NKplWs6Iqxihe/uqUbSfrU0WyQMk7wS0VVIKlJhPX
	 vDyKJTJclXFsrKyzfJ6zbKOJuJwkiq1Vu0hEoN9ApOV5yoLjtSvwZwdJbM5tlC/gCo
	 4kHkemuwzdFJg==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <target-devel@vger.kernel.org>
CC: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<bvanassche@acm.org>, <quinn.tran@cavium.com>, <nab@linux-iscsi.org>,
	<himanshu.madhani@cavium.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux@yadro.com>
Subject: [PATCH 2/3] scsi: qla2xxx: make target send correct LOGO
Date: Tue, 8 Oct 2024 16:24:01 +0300
Message-ID: <20241008132402.26164-3-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241008132402.26164-1-a.kovaleva@yadro.com>
References: <20241008132402.26164-1-a.kovaleva@yadro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-10.corp.yadro.com (172.17.11.60) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

Upon removing the ACL from the target, it sends a LOGO command to the
initiator to break the connection. But HBA fills port_name and port_id
of the LOGO command with all zeroes, which is not valid. The initiator
sends a reject for this command, but it is not being processed on the
target, since it assumes LOGO can never fail. This leaves a system in a
state where the initiator thinks it is still logged in to the target and
can send commands to it, but the target ignores all incoming commands
from this initiator.

If, in such a situation, the initiator sends some command (e.g. during a
scan), after not receiving a response for a timeout duration, it sends
ABORT for the command. After a timeout on receiving an ABORT response,
the initiator sends LOGO to the target. Only after that, the initiator
can successfully relogin to the target and restore the connection. In
the end, this whole situation hangs the system for approximately a
minute.

By default, the driver sends a LOGO command to HBA filling only port_id,
expecting HBA to match port_id with the correct port_name from it's
internal table. HBA doesn't do that, instead filling these fields with
all zeroes.

This patch makes the driver send a LOGO command to HBA with port_name
and port_id in the I/O PARMETER fields. HBA then copies these values to
corresponding fields in the LOGO command frame.

Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 0b41e8a06602..90026fca14dc 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2486,6 +2486,17 @@ qla24xx_logout_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->port_id[1] = sp->fcport->d_id.b.area;
 	logio->port_id[2] = sp->fcport->d_id.b.domain;
 	logio->vp_index = sp->vha->vp_idx;
+	logio->io_parameter[0] = cpu_to_le32(sp->vha->d_id.b.al_pa |
+				 sp->vha->d_id.b.area << 8 |
+				 sp->vha->d_id.b.domain << 16);
+	logio->io_parameter[1] = cpu_to_le32(sp->vha->port_name[3] |
+				 sp->vha->port_name[2] << 8 |
+				 sp->vha->port_name[1] << 16 |
+				 sp->vha->port_name[0] << 24);
+	logio->io_parameter[2] = cpu_to_le32(sp->vha->port_name[7] |
+				 sp->vha->port_name[6] << 8 |
+				 sp->vha->port_name[5] << 16 |
+				 sp->vha->port_name[4] << 24);
 }
 
 static void
-- 
2.40.1

