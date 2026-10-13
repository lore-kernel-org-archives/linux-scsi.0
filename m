Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D1C3DDB03
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 23:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791849188; cv=none; b=Q6vy/FjOP0sTnKsTEHcqbNazgM2KFUAiIv3kP67ff1rnYzo4nEFzDpFlKFNr0ETJM/uFIapkpxbt23n48pnxBhcGHrFVZ6B4MvTsc/DVD3gExv3nikjWHZBQvUj+THt0cROUfFdpqFDh8Qf7jDadf3I8c6W1e/lf+72HYEzYHLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791849188; c=relaxed/simple;
	bh=YXziDMRfKeg9I927ddqmPSoNHctTveDjWR82uSp74kc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Qc4gQ5ui528GMzOibkB4a+msV38UwShnSL+kVqHhIPWGJ4yh9K2Hd1o3QaYJNiTjGtRdPfBQMw53r0h7XUE5uAolNeQ0/z+koYW1YWlLu6G9qzLf/ATYduO5NfiEn8oVZSradtpE2Fe5CPMJco07oYi96Jq9cg7sPAJOaM4RUvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OyoqNDB+; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OyoqNDB+"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3115c4451c8so2488237eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 16:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791849186; x=1792453986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AVGn1G3b0bwj3QPcyUG23lJBdQUMQdXFctIvFOnw/8Q=;
        b=OyoqNDB+fkhNeEyUaQbt7xLLm5W/nk1jo9du8Qtj5/mV+9a3z+Xvl+6wsO6KuG19MV
         9Pnzre9HXmQP2k1XUI/Wl0yl1nqQ0JYnneE6Pp2s8EgB/6ZyEsKMaFDj9mo0sF3N70/m
         4fOvWFZ9gfdbeNgANhXoCP4jbbwpUasCCkw/XdB9BFiLjzH2i3SWqYAekN51ukZxY+cD
         uuJTH/h6WPeSawEXV5+MFJ4UYWXc7sf6wc7HmjGcexM3sPpz+ORYrvwflL4/wQp0YLGA
         OJjwGntHhdYbSRtk6J5jktwxzMf95tJt9D8OOfZVxK1UjAJ4tHxdUmmD6Q4YCHYcMqLi
         D+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791849186; x=1792453986;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AVGn1G3b0bwj3QPcyUG23lJBdQUMQdXFctIvFOnw/8Q=;
        b=rUsjkfJP1nUgVkB0xXbiBtjT7MVCJiwYXA5/HLf7b20UVQxbHDP9TmG1IVi0w+IL8b
         JFVKUKJ1VzYGxt8fNrHJJfJNg8nVF8EjaxBxF46wpvdU3Kqfgz5MRZURrMBixTi6uEBx
         nMW9KPOJssRy9ggsLiYlYqnmEfSjW84hsOGT6p+7xr50L2pbsV4lal8V2bZ9krAqLV29
         vgOc6rk8V3Hp4NNxOFja2KlclnyFCPhrUbpg+uOpOJLPC3OuNrO19UFAhrT4XKbatPcW
         dnYEcdqI7DeNBnUFTf7jPKbszYbXgJXOg2Kf+OGCVt/DRqTDeSNiTHH8DHx3q7yBp1lw
         lm8w==
X-Gm-Message-State: AFq9FYK/P6kxXhja1FX2kxTdQ4Uee+UNY1PaD/FdonlwBbjTCK0hzOxp
	+BIQCKPqez1SwRs3I6j5QWAN0js9af0X8WI/2lcoEQrZVjKLl7Y8469XnCtYo1Sc
X-Gm-Gg: AYBFou39bDyxVM9VbDerr346sEddURacx3y3ppl8EfzKYRu46RcZudL2ztHUFeQxhH5
	gJXd0gQ/7xcaHQyYGOVLbZQps8+vMyvNxRwiwIFATNVMMPCiaIsJG/2S/7y2IJKlT9sTdHzYnt3
	P870xTGk1c1ZEcTZxc9081OwWjkGEp+LtJaRFz8PlJluIPnpAfG5R6sALAvdu/WbGeTeas/1DA4
	Ly6CLisGJU96cdWs4IUxQv0EMU6CVjhz/pHaOJx+8YzC2KmzJNLPHMPOVQJmh502V4kSD94BwyN
	Wuy1DI0PMA07N3G7YoDEfGlXep9/6O4D8LHqfC96UML2Q8kgqSN0BAss2pLMUAdprr7d+SMiB0q
	EPy08zCBXdfTcSxMxHkPN226EK1cbf3LP8fg9PdH/Ntudxmhcsc02Xlbf1Xr3snSFw0Z/OGl0xN
	aTQjFYkX8tapqv5UMFyV8iJM8oRQXGoEGs/KkL0q++z20DpyIuY/nktF965nAZTIGrPwOHVyg9i
	y02zfS/+DhYkVEhIYg0H97PZ7DM2AZNcBNpkbEZx+3w2kQr6+6KxY6Grw==
X-Received: by 2002:a05:7301:4242:b0:35a:7f06:7836 with SMTP id 5a478bee46e88-35a7f067cf0mr5400812eec.8.1791849185548;
        Mon, 12 Oct 2026 16:53:05 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b29c2f861sm15137264eec.11.2026.10.12.16.53.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 16:53:04 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: jsmart833426@gmail.com,
	paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v6 0/8] lpfc: Update lpfc to revision 15.0.0.1
Date: Mon, 12 Oct 2026 17:16:40 -0700
Message-Id: <20261013001648.62289-1-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set contains important bug fixes related to cleanup
handling in both normal and error paths, and refactoring of
duplicate code.

The patches were cut against Martin's 7.4/scsi-queue tree.

Nigel Kirkland (8):
  lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
  lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not
    set
  lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted
    cmd
  lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
  lpfc: Rework I/O flush ordering when unloading driver
  lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
  lpfc: Update correct ndlp refcnt when rejecting an unsolicited PLOGI
  lpfc: Update lpfc version to 15.0.0.1

Changes since v5:
  - Two patches have been dropped from the set pending analysis of
    sashiko feedback. The patches will be resubmitted in a future
    patch set after additional testing.
  - Updated patch 4 to address sashiko comment.

Changes since v4:
  - 4 patches have been dropped from the set for review of sashiko
    comment and soak testing of any necessary changes. The patches
    will be resubmitted in a future patch set.
  - Updated patch 6 to address sashiko comments.


 drivers/scsi/lpfc/lpfc_ct.c        |  2 -
 drivers/scsi/lpfc/lpfc_els.c       | 80 ++++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  7 +++
 drivers/scsi/lpfc/lpfc_init.c      | 16 +++++-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 30 ++++++++++-
 drivers/scsi/lpfc/lpfc_sli.c       |  8 ++-
 drivers/scsi/lpfc/lpfc_version.h   |  2 +-
 7 files changed, 111 insertions(+), 34 deletions(-)

-- 
2.38.0

