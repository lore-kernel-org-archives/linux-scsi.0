Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C39377B2B
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 19:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fyPu1vkA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703185877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AWn/QHp2YPYufEDNjOJpKb2JC/5WKNiZSL7HfeI2UL8=;
	b=fyPu1vkATZbKSwLgWdPD5Wa8J3Tzm3g90HYKUcqBvO2olIIkzPPTf0e/Hj9/3xkhikG1aS
	3h6naUSjvJTMjmUrECCzJSlBV3axFCnxBxPfifSn5auQYBmW6BVmhVzd6vp2VbPah/6ZoO
	ebMVPjtdECfFP0eKK2rsDax9C8rA960=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-fy0YLehWOoWh1HNLLS3NsQ-1; Thu, 21 Dec 2023 14:11:15 -0500
X-MC-Unique: fy0YLehWOoWh1HNLLS3NsQ-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-78125f9fa75so42032385a.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 11:11:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703185872; x=1703790672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AWn/QHp2YPYufEDNjOJpKb2JC/5WKNiZSL7HfeI2UL8=;
        b=MsCS9RwhDOlqENOBFz0esUBZhLi6QF3C4YRC9PVe8aK/gSXpIkbXMcI6u6zZNG2XI8
         JNDeh9XQoAtDlu90bDFNfE1tKjJqP2h7uewU/luZuTEzf3qUcxyZA6c7hbhEa7jbpEBB
         v9lT3LtcwysLMIUXdLktVLEu5H9jxnj+b67JE2YoCjYeaF/TfyXj4cTmM1SGk+pdgK4I
         FPxcUbhyOqT1W1C7DdrHDxkyKCXdhOBxqYHligOY8OnodZ29kt9w83f+c8rvX6LF64MP
         iN3yRmVtnXFDmJvdjkpiNxcPyPLGKbD6foAKDgYcjFTSzaZE5o2WLjk75ySxu7wD0p5X
         U9Fw==
X-Gm-Message-State: AOJu0YyDQDSgbBpA9I5+gHkeWT4zpIpCvNiqHtmhgsA5H5wqM+FFrjUC
	0FUzIZC/gP1LRfqie5cbogo50znlde6T/tFDBmTMhXJLLOWobuA10yxr5O+GwxDpQwNmom2wMbb
	4kgJsaaWAtKM+3ikUJHuJaWj/88CTeg==
X-Received: by 2002:a05:620a:22d2:b0:781:153b:ae6 with SMTP id o18-20020a05620a22d200b00781153b0ae6mr229448qki.107.1703185871911;
        Thu, 21 Dec 2023 11:11:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbiWNqLTkVz0w6Uq+vhXvP8nkEAOb5pdCpgBAECHkBck/Eb7Lx/DDl7BzIBwYkcs/Qf08L0A==
X-Received: by 2002:a05:620a:22d2:b0:781:153b:ae6 with SMTP id o18-20020a05620a22d200b00781153b0ae6mr229432qki.107.1703185871667;
        Thu, 21 Dec 2023 11:11:11 -0800 (PST)
Received: from fedora.redhat.com ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id 25-20020a05620a04d900b0077f0a4bd3c6sm846370qks.77.2023.12.21.11.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 11:11:11 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Janek Kotas <jank@cadence.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>
Cc: Andrew Halaney <ahalaney@redhat.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RFC v3 09/11] scsi: ufs: core: Perform read back after disabling UIC_COMMAND_COMPL
Date: Thu, 21 Dec 2023 13:09:55 -0600
Message-ID: <20231221-ufs-reset-ensure-effect-before-delay-v3-9-2195a1b66d2e@redhat.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231221-ufs-reset-ensure-effect-before-delay-v3-0-2195a1b66d2e@redhat.com>
References: <20231221-ufs-reset-ensure-effect-before-delay-v3-0-2195a1b66d2e@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.3
Content-Transfer-Encoding: 8bit

Currently, the UIC_COMMAND_COMPL interrupt is disabled and a wmb() is
used to complete the register write before any following writes.

wmb() ensures the writes complete in that order, but completion doesn't
mean that it isn't stored in a buffer somewhere. The recommendation for
ensuring this bit has taken effect on the device is to perform a read
back to force it to make it all the way to the device. This is
documented in device-io.rst and a talk by Will Deacon on this can
be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. Because the wmb()'s
purpose wasn't to add extra ordering (on top of the ordering guaranteed
by writel()/readl()), it can safely be removed.

Fixes: d75f7fe495cf ("scsi: ufs: reduce the interrupts for power mode change requests")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bb603769b029..75a03ee9a1ba 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4240,7 +4240,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		 * Make sure UIC command completion interrupt is disabled before
 		 * issuing UIC command.
 		 */
-		wmb();
+		ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 		reenable_intr = true;
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);

-- 
2.43.0

