Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDEF3659FB;
	Sat, 15 Aug 2026 13:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786800295; cv=none; b=aeDN/FhsbPE12tEkORowdptP2Uq4+q6iuVw9YtqkjfbDfHHiTJW3bwryuI2bVmot1agTj5pfoarqnRybNbTkIiOdvaL71Ch/DVkFKTVOX4JBvM61GOtHMbV+rTRt5pWN58kOt1Bg9ITNtgHi2FNhfstwLDTZ84vT5E4huJPxK4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786800295; c=relaxed/simple;
	bh=2yTkFgPvpVZTAIpT7PD399MhPhKh2LgfyzNpAFr/pFw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=k9P3fiSp6G60wfbTIhtyi5QWDcgu8wbqfS/y/4I0+AVnRjLzEFvnAj4VzTB4bZbCePBWoi6EPEWH7MqdXFJDuMXYmsEKGaZ1J0WlcmJJRr2qfa+h0FezNYluvuIjac+YkG9WOPWOFFjlKSg4K9RHgKuidqtwHVySoPpRAmDF3Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-05 (Coremail) with SMTP id zQCowAC36EKTaIBqmPbQBQ--.59162S2;
	Sat, 15 Aug 2026 21:24:36 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Don Brace <don.brace@microchip.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: hpsa: validate active path before indexing enclosure arrays
Date: Sat, 15 Aug 2026 21:21:06 +0800
Message-ID: <20260815132434.27982-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAC36EKTaIBqmPbQBQ--.59162S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kry5Zw48JF1UCryfAr48Xrb_yoW8Wry5pF
	W0gFyUAw1kKa13GFW7Aa1UWFy3u3Z5CrWUu3WSy3y8uFnxu348Za1rKr1UXF95JrZ5Gry7
	t39rtay8GFyUWaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

hpsa_get_enclosure_info() uses the firmware-provided active path
number as an index into the eight-entry box and phys_connector arrays.
The index is not checked before the array write and connector copy.

Reject enclosure information with an out-of-range active path before
updating those per-path arrays.

Fixes: cca8f13b4fda ("hpsa: Add box and bay information for enclosure devices")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
Changes since v1: https://lore.kernel.org/all/20260704010943.16707-1-pengpeng@iscas.ac.cn/
- rebase on current hpsa sources
- validate the firmware path number against the destination arrays before
  either access

This revision was not built or tested on Smart Array hardware.

 drivers/scsi/hpsa.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8edad1830abe..5725fd9a6aaa 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3505,6 +3505,14 @@ static void hpsa_get_enclosure_info(struct ctlr_info *h,
 		goto out;
 	}
 
+	if (id_phys->active_path_number >= ARRAY_SIZE(encl_dev->box)) {
+		dev_warn(&h->pdev->dev,
+			 "%s: invalid active path %u for bdi[0x%x]\n",
+			 __func__, id_phys->active_path_number, bmic_device_index);
+		rc = -1;
+		goto out;
+	}
+
 	encl_dev->box[id_phys->active_path_number] = bssbp->phys_box_on_port;
 	memcpy(&encl_dev->phys_connector[id_phys->active_path_number],
 		bssbp->phys_connector, sizeof(bssbp->phys_connector));
-- 
2.50.1 (Apple Git-155)

