Received: from mail-vs1-f97.google.com (mail-vs1-f97.google.com [209.85.217.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E65489892
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 15:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672611; cv=none; b=jF7L4y7cup+039/Tu22xBFxrx4UkQv4pE0+zUWHmD8zkaDq1XDMEZI07JiSAmAZDlp0WoPEBjtjLZvpQt5UcOTEKa/61kZdHoZRregkf0c+G4TZeooz8n9AwoGSZaz9EXausOoFTi8t7cqIyUHjwqyr2oPHoSn4Cz7iM1FpAs0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672611; c=relaxed/simple;
	bh=pM/u8EMItGVh+Zm5bKp6/cp1T3bYY3D7rVW8GS6cQj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGf62hrwL6uRChKpXlYhm+QBC/QOkk4+LtSG1oP6MtI611HZLz+cDC7cN3bUYkmdiMrRIuGUhsWJY+wKu7bViy5xxz//clVVu8pVpDwbcn13zAjtLWe6DLtXe63JPo+ltOQA0mRMArVmaGpt7CqywUQuXJ3Odos2EKzuznSOAW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=FgZZEeCa; arc=none smtp.client-ip=209.85.217.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FgZZEeCa"
Received: by mail-vs1-f97.google.com with SMTP id ada2fe7eead31-77bf3334d14so2376967137.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672607; x=1788277407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z7FoEiYm8GmVLwFN4kiW7m8ZCoQDrWvKRK1uLx2939c=;
        b=axlnz+fHuG6m9zDI6/Ngpxntq8IMZdJ9ioDA0JowA5YLG2EXfpOSQiVhcMNeulYuj5
         vtsVRKrXku56BH6rgBUNbfTq4FOvZXPa17pS5IaG3sZo/5MDQH7p5TW4ZDyjwot5Cked
         3rli78FRF3RdZhzGtwPBegy+TYGQwcHrUo1p7qaAJJ7G2ajDTtA+m/saApK50tv6DNRi
         zC1I65Xf6vN4jxO3IK5Maw7cOS2m1CcXmInANTAvX4bJG8LxM2ZuLYmmqjg2Jjeb48Eq
         CLG9e8VgSOPoXG2KKsD4ACqB+ElMqQ/PlZQmjOQcCJqFcBKWrr+iU7jlTYGLsdgQTYBT
         xRGA==
X-Gm-Message-State: AFuF++lonhkhpqQBp+pbs2oTiYHQcRcwlEHuNkK/OyOKOSOS3xmUNe10
	KfvNbul6+aOrD7vJNk+Wy3P48/W7bsYk9esARcE7bQoxxCkgU/Qq4vtgGDhCneG4JlLc2b5/CbZ
	MWAOhg4MbWSOTHXNQzwoCsOSv1017jWF3cdnKGpQtIipXi8FbkWaWl7fzc/tY10gkUGmI4mU0Ec
	kWL1qveai5gJHE3aEVkU5ul0xmt8UsKVKQ83KYQhewU1ZQGLrapGDPE8rvuiBNaxsnLan96pLgN
	6bgT+9XeNBNTUy28fbbXBT4
X-Gm-Gg: AR+sD11F3pVoPIG1Sk+I5al353uUyFgydLYYzf97Fc8FZVLR5TX+km8i5+WIaOlIzkS
	oWKNmIRa8y84JPQSc2pb44eYr8zklBXepvX14OwAqQ3Bk/XJbHgC+cvMvnujIT2xuL+yPwrfEm/
	RmLR+r6iUr5Sor1b+8dxZL1UjAqaE0dX/yzYG6jK5atGPNm4kKWLe/zAmXkv0I7XIJfpTbwppIa
	VkSHgt1s05KpAmiTeTrb3/jgY38m5UXchQCEm9VNF+/NTnTagiZETIgZKrpgAe/l69ZMvhHPyYS
	7KyRO9/PdgJ4evymnUoeSeHi2Z86R3ZY21sK7TBkWg9w0F9pnzuNxEHfpaW+eDtbLI4+FW4Xx/v
	C0oucy2sR4aP0IpXgFL0Cj8ICGboOXE/ixCNx6ShWyqvF/ghRt/yCA9Tl9GLwzjIpSrpZQ9Psn0
	wTDhSQMFWgWOe+U3uLIrHi5CZosMcm95fJAX3t5NtXJtk=
X-Received: by 2002:a05:6102:2920:b0:778:7:4699 with SMTP id ada2fe7eead31-77bd249a778mr9469507137.8.1787672607320;
        Tue, 25 Aug 2026 08:43:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-97c8313cb0fsm786268241.0.2026.08.25.08.43.27
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2026 08:43:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e25e4b41cso5830294a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 08:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787672606; x=1788277406; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z7FoEiYm8GmVLwFN4kiW7m8ZCoQDrWvKRK1uLx2939c=;
        b=FgZZEeCaogmFbBd/l//rQAsYuDcH0duclRyjlSgqTZo56Jq37oiUbjm3WUVDDWr4Xm
         m28Z3VFSptVhKkC/3uaWRQdcNNVlnwcp8Q/y3eJIWPGkdViBOe8EIOVPAmnkH0qyESxY
         JC8L7bR23gYKaS5Q6jIAji1+XIHOahhTIDgcc=
X-Received: by 2002:a17:90b:1dce:b0:381:cef1:11ac with SMTP id 98e67ed59e1d1-3966d3e1cfdmr105859a91.10.1787672606194;
        Tue, 25 Aug 2026 08:43:26 -0700 (PDT)
X-Received: by 2002:a17:90b:1dce:b0:381:cef1:11ac with SMTP id 98e67ed59e1d1-3966d3e1cfdmr105692a91.10.1787672605577;
        Tue, 25 Aug 2026 08:43:25 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm63445311eec.23.2026.08.25.08.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:43:25 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	sumit.saxena@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2 01/17] mpi3mr: Fix buffer overflow in BSG passthrough request copy
Date: Wed, 26 Aug 2026 02:33:55 +0530
Message-ID: <20260825210411.301535-2-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The size of an incoming BSG request is checked using a variable that is
narrower than the field it is read from, so large values wrap and pass
the check. The copy that follows then uses the full value and writes
past the request buffer.

Widen the variable and copy only the amount that was checked.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
v2:
 - No changes from v1.
 drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 1353a8ff9c85..8e5d24793efd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2384,7 +2384,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	long rval = -EINVAL;
 	struct mpi3mr_ioc *mrioc = NULL;
 	u8 *mpi_req = NULL, *sense_buff_k = NULL;
-	u8 mpi_msg_size = 0;
+	u32 mpi_msg_size = 0;
 	struct mpi3mr_bsg_packet *bsg_req = NULL;
 	struct mpi3mr_bsg_mptcmd *karg;
 	struct mpi3mr_buf_entry *buf_entries = NULL;
@@ -2538,7 +2538,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 				rval = -EINVAL;
 				goto out;
 			}
-			memcpy(mpi_req, sgl_iter, buf_entries->buf_len);
+			memcpy(mpi_req, sgl_iter, mpi_msg_size);
 			break;
 		default:
 			invalid_be = 1;
-- 
2.52.0

