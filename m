Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85FC425CFE
	for <linux-scsi@vger.kernel.org>; Wed,  6 May 2026 14:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778076104; cv=none; b=Y82m70s/bJbsQBymEtLgHnCmChCbVSS1nnX3Pnd7b8mzL2OMQqJKrWXu3QAys6ts257+JMs52QbrRfabiblgvBWbeh81l5Z7Kf0dn5zLoATjQzwdPUxo5yBDsHtIp4JkEm0H4o0H/fLpyHw7h71o4khwhWSGg/g3Np6UAgtP5Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778076104; c=relaxed/simple;
	bh=+ArQr9GNdilrhB4Xk/tQY/NzlKzAJGVxfekZ92FhyZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RAMa7R2kvUBG2g5gy1SoRurC/IfiLh852nzTOWMg2h+JMdo/dUhmq1xWKIr2by/moxeo3kGEEVE6QBp0Lreczx22HK0hg2iwEqx1zkYZEhr7YCL8FnepSZhaAmfFNEv3Zvl+xc14lhDH9/bWqZ9ZtlapvTCB/a3IYPXz6YVv2Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=dNM7GBnW; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="dNM7GBnW"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 5F71024210C
	for <linux-scsi@vger.kernel.org>; Wed,  6 May 2026 16:01:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1778076100; bh=m7iamh68HDju4KrVafHXRucmQE/LUIXeKv32qW1CU2o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=dNM7GBnWhonoayZecipSMrJTrB1B8ftvK0irh9oY8DY05jAsqgg1PKylRs2DuMbid
	 jWHM90W7ErEw5UM9LJf/COS6GbL6qdcQy1U1sRsciu/USYKhi+Gd1WGnE1lpfo4GrQ
	 1U7DduCRJRvJWBkLMeDKJsXI66GUEz4IkngJ/68719dhDb5p/3a5FASMci8MBxBJ/j
	 I6LcWVcxeq8C6EsHG9szbvCNs4KNP5dE00Qe3fr+BgUkcpKFYFulWYkYWMbAd2iEkx
	 VR+IzweAQ4AT6m2JZDAom3bri8G+tExLeV15nMQBxjCH7ftd73vTktBfUDwXQ2jv7a
	 WMFBFdoQJQtZA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4g9cW72tRgz9rxL;
	Wed,  6 May 2026 16:01:39 +0200 (CEST)
From: Mateusz Nowicki <mateusz.nowicki@posteo.net>
To: don.brace@microchip.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] scsi: smartpqi: fix PCIe hot reset recovery
Date: Wed, 06 May 2026 14:01:40 +0000
Message-ID: <cover.1778075755.git.mateusz.nowicki@posteo.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A PCIe bus reset (e.g. "echo 1 > /sys/bus/pci/devices/<bdf>/reset") on a
controller without FLR support leaves the HPE SR932i-p Gen10+ unusable
until reboot: smartpqi registers no pci_error_handlers, so the driver
is not notified, firmware reverts to SIS mode, and all queue mappings
are dropped while the driver still drives PQI.

Patch 1 adds .reset_prepare / .reset_done reusing
pqi_ofa_ctrl_quiesce() / _unquiesce() / pqi_ctrl_init_resume().

Patch 2 raises SIS_CTRL_READY_RESUME_TIMEOUT_SECS from 90s to 180s,
matching the cold-boot path; without this patch 1 fails at the SIS
ready check because firmware boot after reset takes ~125s on the
SR932i-p Gen10+.

Tested on HPE SR932i-p Gen10+ against Linus' master at 74fe02ce122a.

Note: the From: header is my Posteo address because my employer's SMTP
is unavailable for external mailing lists.  The Signed-off-by carries
the Microchip attribution.

Mateusz Nowicki (2):
  scsi: smartpqi: add pci_error_handlers for bus reset recovery
  scsi: smartpqi: increase SIS ctrl ready resume timeout to 180s

 drivers/scsi/smartpqi/smartpqi_init.c | 47 +++++++++++++++++++++++++++
 drivers/scsi/smartpqi/smartpqi_sis.c  |  2 +-
 2 files changed, 48 insertions(+), 1 deletion(-)

--
2.43.0

