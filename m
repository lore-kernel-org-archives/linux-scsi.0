Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4347E23ABB9
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 06:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769495397; cv=none; b=s5UOylH0BGm7+XPrPgHu1rdnhNCzIgdxCBtt6idLxQrXwHWg39Hyl5kohX/IrhXBDC5Icrt5O8FJ4XtkY2apYXxTZBG0PIf87Eg7KEXaMfbd26DQj0X4CTOUDnj2guLcdfJBEwGDdbElGQfT0HXEAorSej9Ik9h/ImBks6eev0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769495397; c=relaxed/simple;
	bh=REGvoMe4/iaB0cUO+ZJk+D0sX2fa9JlPvYErbzmFubk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VtQ1WCWeYBz3DydmHnCuPNTKp2R1A5M+QuMipENvbJjNzX45jeln2dKMnuroZYXvmS4y8L91JewmwWUX6ODrSMGydRqGmd5P3QkVqM6zPVWUFBpb//r/NyX4lSb1+Tre5dJh2EwVzpRxZdQCD/sZqmK+1YYq136seeHOOdU3YMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f0b8r58FQzYQtjF
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 14:29:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D856C40576
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 14:29:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXxfVZW3hpL_QVFQ--.16598S4;
	Tue, 27 Jan 2026 14:29:51 +0800 (CST)
From: Yang Erkun <yangerkun@huawei.com>
To: bvanassche@acm.org,
	dgilbert@interlog.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: yangerkun@huawei.com,
	yangerkun@huaweicloud.com
Subject: [PATCH v2 0/3] scsi: sg: minor bugfix and cleanup
Date: Tue, 27 Jan 2026 14:20:41 +0800
Message-Id: <20260127062044.3034148-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXxfVZW3hpL_QVFQ--.16598S4
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYC7kC6x804xWl14x267AKxVW8JVW5JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r
	4UJVWxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0aVACjI8F5VA0
	II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY64kExVAvwVAq07x20xyl4c
	8EcI0Ec7CjxVAaw2AFwI0_JF0_Jw1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UplksU
	UUUU=
Sender: yangerkun@huaweicloud.com
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

v1->v2:
update commit message as suggested by Bart

Yang Erkun (3):
  scsi: sg: Fix sysctl sg-big-buff register during sg_init
  scsi: sg: Resolve soft lockup issue when opening /dev/sgX
  scsi: sg: Remove deprecated sg-big-buff

 drivers/scsi/sg.c | 88 ++++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 50 deletions(-)

-- 
2.39.2

