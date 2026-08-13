Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA88E361969
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 07:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786604980; cv=none; b=MvA/uq9b6a3dX/N+IH6NN5ssSzmo/CmGhUIcNiBFQka1gYHh4GyZ1154l650cTZTr5XIarJDF58cki9E8/xOCHwCO5REBTWXM2jmyScN0+HJv01BfobyouiPPi9HRW82TYOQR8erEoI5JDLAjEJkzG4Qq+rQZI1sC+j895ZFq1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786604980; c=relaxed/simple;
	bh=ajlICF5UKF3zQ8HymZznpcIpyBV/7FAyjz382zjD7S8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lfk9e72ZRL7Z9ihdCDgRtjkisSigXDJUob0d60DzbBpzk0f9BI0BwmQcnXxP9KLis07jBamjiYj2EwlbloWoinpjNKZHs5BtE4NIcPZpuIu9HVvA74hSmWz1H1FSwDfCZQik+uI4mLkW1IU9RWY/WqTR4xJI1R3xYSyN+5XIWJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r38yequ6; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r38yequ6"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92edb12cdf2so139496485a.3
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 00:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786604978; x=1787209778; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gw73m5PwUErvfwwmzv0TlDv6S2DhMcVdC6Gz7QT0ok4=;
        b=r38yequ6LKTbxDuYyvJMJQcfHgIpNwqcqvjtmDtFiJQLDPH2RhhIaMTM8LTvZKOVB8
         ol9M6xDuVkwv+RX4Mjg/CR/uRIePjvZTUfP8gJmX6vPHCbTnoUMIVPZjNoL9GRCZ1Cgq
         tPbAsQsLKmgZX/lYIfYKgjpwrBlNz+FT9pvn9QRnsknFeqQRiYSVofkOnYngIBF7/d8P
         idP6IgV6dwaRZ8BGYeVcghbZLh4S/1UXJTJ9NuPNj+sb49HAB+LSG9ZsfbntPK7t1L5p
         F/bVBXB+zt8FSLIDIzO35w5yQYtyVJWz2dyTwHPwuPH60ZlEBa9tpL0tPhmcfvOfdRlq
         7rgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786604978; x=1787209778;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gw73m5PwUErvfwwmzv0TlDv6S2DhMcVdC6Gz7QT0ok4=;
        b=RlES5iu1pStZStEXhiotNNZrqkU/MksvFW3sC+boL1ZpNUEv1Gk3Rj3xCqoJtRMdX0
         pjooRU8oMsuwgBjmFFwosmQT2Avatyugyl9mS5VsczprFY00x/YpaC9WW/m7WGG5YMYG
         Hu+fiohG3y+saFMuQeI2vzF/zPIo8MvuqELbTlNhBb5iE6ayNgLY/M26WaUvITPn2aVt
         80/laayeH6bSKa4XL+Mf1PV5q8PHa5bWhBZdZBY49GhBdznr67D5X72tLoqnwRWLyKwm
         e+p4RQL+0ON6F82OZVjaZFOSniI2iA2G0hoVGrPmzb92I34bOUXp2H8yaZ8dEstgLZ42
         nEHQ==
X-Forwarded-Encrypted: i=1; AHgh+RrVdTbk3e6jh92uSgRoIdSZAO9nvm+r2dy9gN+50R/qGjn5tUcxe29ZZp2ZxyJ53vMXnXAbMfeW8I0C@vger.kernel.org
X-Gm-Message-State: AOJu0YykOYieHVVm9SLXnv/zmPo0DAW+MBOALXNKKsiS5F0Fceoxf8Wr
	TNjf8P7RzhXt1GCnzEwTGMcpBetzPRUxeReXKfk7XWY+lM/mXGWi7uRw
X-Gm-Gg: AR+sD126qyr477uWOPVb4s5q0DbwNatwvO+AqlmvbrHaxgHG/Q3tv+iU5CexFyN6Ase
	OIheX1afjyi48vrUU+6avC3tjh5D2eIv9q6kZWv6W12ZjfgOS7p6lIs9J3zYNp+d1lM5xqDVLvn
	XTr64GKEyUZVt3fI4wviYspxsvgfSzzFziiKszlJsjY+0kpTpIE7lii56QtHlWDkwPKrd37Ft4w
	Pv1s+DfZGYI2XWAa3bwmtSqmJbNwBm+42qjVwY7ebCSt7tVvuMfx5m5Wy9G5iuIMWNLq+tZfQSt
	W815Z2j3uixqh43DY7kq8+6M8qWCjVZvDdJoItCNyN492kUjQ/UzztQm7IGryrQGFpx1irDcHLY
	UYBGMTG1lRPEOMseTbphvEkYHwlcfSnUktQHvFfjnYqEwN5ZQp18YugoguK4+v6UhyVUFaOpI3d
	DStk4haXMZHXMi6vNG2THjiCcqhOp61h8vixxk3/a1YuO0T5C5Vevk
X-Received: by 2002:a05:620a:2804:b0:92e:76a1:96d3 with SMTP id af79cd13be357-936bfb36a6cmr330873485a.34.1786604977813;
        Thu, 13 Aug 2026 00:09:37 -0700 (PDT)
Received: from localhost ([37.19.206.57])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936c1b4d57asm86530885a.35.2026.08.13.00.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:09:37 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:09:32 +0300
From: Dan Carpenter <error27@gmail.com>
To: Justin Tee <justin.tee@broadcom.com>
Cc: Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: lpfc: remove unnnecessary NULL check
Message-ID: <an1trOAUeQmYEus_@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The "evt_dat" variale is non-NULL at this point so there is no need to
check.  Delete the check and pull the code in a tab.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index c95165905483..7354ae9ba8e5 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1329,10 +1329,8 @@ lpfc_bsg_hba_get_event(struct bsg_job *job)
 	else
 		bsg_reply->reply_payload_rcv_len = 0;
 
-	if (evt_dat) {
-		kfree(evt_dat->data);
-		kfree(evt_dat);
-	}
+	kfree(evt_dat->data);
+	kfree(evt_dat);
 
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	lpfc_bsg_event_unref(evt);
-- 
2.53.0

