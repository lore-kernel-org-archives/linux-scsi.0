Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7406F2FFFB5
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 03:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783393450; cv=none; b=obFQKVmT+bfh3uZ5NJaKX4aHH0l2aecP+2WqZrVOMVfqa5EZGUKSqaxLyVEeAqLwEic6xUE6Lo0aP74f0TV/b+X3L7fI+53dCQdYzimphW9+YCm11+4rshp+CZnAKzxBbY550Hmm35nhhHrakQ2QQUnEsd6xBPvg39Qxa2N7Fbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783393450; c=relaxed/simple;
	bh=BAa3ZIK91QlE1gma2GkZmvCfsbjGQy/B+kccbsT1850=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NQtZJW+k1FfOcGI5ChEqs/4P96edyTykgGkJ8bKPmH57D16A670QVE6wnohKayoEuveUE4KKV+POszPqAzGjsgMzU5+nLlzBy9liOw0/wlhvfOibCHJWDKyyPsy1qBlxEuF68TVS4iiFyWz9g3w+9D3YJPO50lw97DJT3dCWc4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=gbxNoX1k; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="gbxNoX1k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=kP
	EC2RJesqDQeZ5pRWsySF5vDDyS8gbOsq6MeqhOrMY=; b=gbxNoX1kjWcFa3rt1v
	RHju2pEpWvOwGVYeQ3Z2UcVq4+m+rsIKuB/CdzFdTGZpFieC/luwb9J/6rzh5D6M
	IG5iG2Ks6InV7kGsghdBkBAImpYEY5hJzmes0dODJIa+n3YROVNUloajIwS7mz/U
	ZV1CwPmpGe8pow0NFJ4hQXuiE=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgD3HB2HbExqrYb5Fw--.30099S2;
	Tue, 07 Jul 2026 11:03:36 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: dlemoal@kernel.org,
	linux-scsi@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v2 0/3] scsi: sd: fix probe error cleanup, special_vec leak and sd_done() sense gate
Date: Tue,  7 Jul 2026 11:03:30 +0800
Message-Id: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgD3HB2HbExqrYb5Fw--.30099S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF45Ar4xGryxuryUJw4fXwb_yoW3ZFc_CF
	WSkayxGr4jqFZ3KFy0kr4YvrZav3yvgr4ruFnYgrW3CryxXrn5GFyY9rW5Xr18XFZYyF1U
	Jr1DZw1rZryIqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8qjg7UUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gnqe2pMbIkssgAA3v

This series fixes three resource-handling bugs in drivers/scsi/sd.c:
sd_probe() error cleanup, special_vec mempool leak on prep failure, and
sd_done() sense handling.

Changes in v2:
- Drop patch 2/4 (probe cleanup refactor through out_put).
- Add Fixes tags per review on patches 2/3 and 3/3.
- Reword the commit message of patch 3/3.

Link: https://lore.kernel.org/all/20260623100159.4018066-1-yangxiuwei@kylinos.cn/

Yang Xiuwei (3):
  scsi: sd: fix error handling in sd_probe() after large pool creation
    failure
  scsi: sd: fix special_vec mempool leak when scsi_alloc_sgtables()
    fails
  scsi: sd: fix sd_done() sense handling condition

 drivers/scsi/sd.c | 55 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 20 deletions(-)

-- 
2.25.1

