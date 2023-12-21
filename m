Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40CE5990A
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 18:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ytw+7205"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703183130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ho/Hcsth5WNcdfU5/xCubS2uTkEJrrPZyZ0Y0+D6Mac=;
	b=Ytw+72059UtQAOhts17+5qN8065IvdqzYSdPQlDw1IFlP61QIctR3kEHPD88ejM/UqKrYX
	q71MOVv4myf1zn7ILAaMdd47TM5BTCG1hjK8ezP0birnwJzF/p1vt/fPeEhRU3+eUgDXSg
	8RC5xhGZokK6fsFFargMx0gtKYRsoPk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-21mZkKVOPtm8W8WG84iOZA-1; Thu, 21 Dec 2023 13:25:28 -0500
X-MC-Unique: 21mZkKVOPtm8W8WG84iOZA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-67a9a237908so11221076d6.2
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 10:25:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703183128; x=1703787928;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ho/Hcsth5WNcdfU5/xCubS2uTkEJrrPZyZ0Y0+D6Mac=;
        b=FuyZFalaJr/oiBiwB55quNOOM6n1/eryhr3LsNwizIR+Cm0RJ42KEvHQABgUFuHa2R
         //+BpzXOWPwf+iWzUz634ejps6DjFA/JClT1iZlEwhiHHt6fuXA7csg8Qy7EFxHCldFh
         brzq6mL1dPTJEQN9BxtW0CTJtbHKGTqwdmxIerJSdQvpReWIJftOi4/3kNmbVoG8zfvf
         V2aw+AgVmiickU+ON1FPb3Khhk3aGtdGY4/uQt+WHQS9VyoadOVZ8XOKs3bhZaWPGjxv
         My9eIPugeNu2FugsvvhnnxNaUno7dYl4GGkQv06q1WAWtrE1e6Zaq059ba3UaH8B32Mp
         3rug==
X-Gm-Message-State: AOJu0YwEPtZZfnIHTvpLCQGHiAcwti9BW8ed9/6IigzlYzYmhJ/z/efQ
	RGuV+MXicBtWA8/nizFTw9RsCOx/FATosgKQedXo6KyCI2S0DMCAorWHrshrc7K6VLxrIIs/hm8
	fHOfP3rI51EbT0o0pvyYt8wnDDdDGtA==
X-Received: by 2002:a05:6214:238e:b0:67f:6eee:3214 with SMTP id fw14-20020a056214238e00b0067f6eee3214mr75374qvb.89.1703183127834;
        Thu, 21 Dec 2023 10:25:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IElKhU75dRI9W3ZOnTjXDmnKOYqwcpW/uzTdiUJ9Us0xcxEU8rldcNCBiJuFaoPkew12OzOUQ==
X-Received: by 2002:a05:6214:238e:b0:67f:6eee:3214 with SMTP id fw14-20020a056214238e00b0067f6eee3214mr75367qvb.89.1703183127602;
        Thu, 21 Dec 2023 10:25:27 -0800 (PST)
Received: from [192.168.1.163] ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id da7-20020a05621408c700b0067f2c03d4adsm779605qvb.100.2023.12.21.10.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 10:25:27 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH RFC v2 00/11] scsi: ufs: Remove overzealous memory barriers
Date: Thu, 21 Dec 2023 12:25:17 -0600
Message-Id: <20231221-ufs-reset-ensure-effect-before-delay-v2-0-75af2a9bae51@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA2DhGUC/5WNQQrCMBQFr1L+2i9J1Jq4EgQP4Fa6iM2LDWgrS
 VsspXc39AYu5z2YmSkhBiQ6FTNFjCGFrs2gNgXVjW2f4OAykxJqJ5XQPPjEEQk9o01DBMN71D0
 /4LtMDi87cQlRamPcYS8NZdUnwofvmrnT7XqhKo9NSH0XpzU9yvX6rzJKlqyt8Fq5oxUG5wjX2
 H5bd2+qlmX5AbOnynjeAAAA
To: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Yaniv Gardi <ygardi@codeaurora.org>, Dov Levenglick <dovl@codeaurora.org>, 
 Hannes Reinecke <hare@suse.de>, Subhash Jadavani <subhashj@codeaurora.org>, 
 Gilad Broner <gbroner@codeaurora.org>, 
 Venkat Gopalakrishnan <venkatg@codeaurora.org>, 
 Janek Kotas <jank@cadence.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Anjana Hari <quic_ahari@quicinc.com>, Dolev Raviv <draviv@codeaurora.org>, 
 Can Guo <quic_cang@quicinc.com>
Cc: Will Deacon <will@kernel.org>, linux-arm-msm@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Andrew Halaney <ahalaney@redhat.com>, 
 Manivannan Sadhasivam <mani@kernel.org>
X-Mailer: b4 0.12.3

This is an RFC because I'm not all the confident in this topic. UFS has
a lot of mb() variants used, most with comments saying "ensure this
takes effect before continuing". mb()'s aren't really the way to
guarantee that, a read back is the best method.

Some of these though I think could go a step further and remove the mb()
variant without a read back. As far as I can tell there's no real reason
to ensure it takes effect in most cases (there's no delay() or anything
afterwards, and eventually another readl()/writel() happens which is by
definition ordered).

In this current series I don't do that as I wasn't totally convinced,
but it should be considered when reviewing.

Hopefully this series gets enough interest where we can confidently
merge the final result after review helps improve it.

I'll be travelling a good bit the next 2ish weeks, so expect little
response until my return.

Thanks in advance for the help,
Andrew

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
Changes in v2:
- Added review tags for original patch
- Added new patches to address all other memory barriers used

- Link to v1: https://lore.kernel.org/r/20231208-ufs-reset-ensure-effect-before-delay-v1-1-8a0f82d7a09e@redhat.com

---
Andrew Halaney (11):
      scsi: ufs: qcom: Perform read back after writing reset bit
      scsi: ufs: qcom: Perform read back after writing REG_UFS_SYS1CLK_1US
      scsi: ufs: qcom: Perform read back after writing testbus config
      scsi: ufs: qcom: Perform read back after writing unipro mode
      scsi: ufs: qcom: Perform read back after writing CGC enable
      scsi: ufs: cdns-pltfrm: Perform read back after writing HCLKDIV
      scsi: ufs: core: Perform read back after writing UTP_TASK_REQ_LIST_BASE_H
      scsi: ufs: core: Perform read back after disabling interrupts
      scsi: ufs: core: Perform read back after disabling UIC_COMMAND_COMPL
      scsi: ufs: core: Perform read back to commit doorbell
      scsi: ufs: core: Perform read back before writing run/stop regs

 drivers/ufs/core/ufshcd.c      | 10 +++++-----
 drivers/ufs/host/cdns-pltfrm.c |  2 +-
 drivers/ufs/host/ufs-qcom.c    | 14 ++++++--------
 drivers/ufs/host/ufs-qcom.h    | 12 ++++++------
 4 files changed, 18 insertions(+), 20 deletions(-)
---
base-commit: 20d857259d7d10cd0d5e8b60608455986167cfad
change-id: 20231208-ufs-reset-ensure-effect-before-delay-6e06899d5419

Best regards,
-- 
Andrew Halaney <ahalaney@redhat.com>

