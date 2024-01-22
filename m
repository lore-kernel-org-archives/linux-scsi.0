Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6320360DC8
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 17:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705944113; cv=none; b=f78btXqgxP3U0P4eisHy8qvJACakXscAKkOaCZAD30hqWtYMHtobKkUuCsjwqo/ubOjglAjwzRYaRAtjEQ7Z4J6YWI8PdpcNuWkpFf8d5HaN+22bNM2H9yPXML6+5ulRECJfVwd6jzwWB8VPszb8hmPOchrjF78//wIal7xvr5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705944113; c=relaxed/simple;
	bh=98P8Ul6Yd7c/3fLfOg78lrSuMF8zpONCYx14LZgSuKM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MUo03sskzazhSJ8anSD3M9CQvDyOgLi/Ijzxst8VRs+Qh6f247GR02ACiL2ARajOzahJ1BPVu8sd9ApMKQmMX1VPWANUmTsG/V8ZZ5yJoMvG9Fz4llO5Mo07A/dI32glPIF1jPdS/H+QaF/RYWdap66zVLVtmcZssQzXgIINONs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G0tlRiiA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G0tlRiiA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705944110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R70AogzmSo/CRKtY8ackbX9p9Zw/xQ4/D9I9iZgsmTo=;
	b=G0tlRiiAaCqyAAoh6s8VJZJhCE0Y2rw89vJCAgl2WkXP5uyX6aA5HDnscm0NYBWIRh8DNo
	Ibt6yvhS63UAXffHG0fBeoquQZgCZmI2UAr0DuUQa1YgvTw6AJu36+OLkTRPb7ItvYYUNA
	BUQq2HY7iuhZBidCy4HJvXkgNGHWV+c=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-3a9avyUgNnaC7-FXyfmpjg-1; Mon, 22 Jan 2024 12:21:48 -0500
X-MC-Unique: 3a9avyUgNnaC7-FXyfmpjg-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-683699fede9so50122906d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 09:21:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705944106; x=1706548906;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R70AogzmSo/CRKtY8ackbX9p9Zw/xQ4/D9I9iZgsmTo=;
        b=OqEf0jfkBqSnS+yniEqiM9nvH/FQ1U0gT+tP3a9dG2+IuPtkQeYBcgLbVK0U1PHTnM
         2ZgprHpTXfeXawUGZvJJnHmw2gmdq6Vk9Huwn7LXZ3iadPNEObTk8277wsyCGuOLz1pe
         nG1meHrdg/4TVTAiBiGnwKFc5ki6iA1ygiG8XTSFeieUUhd3e4XCAKqGpKwO1YnF7xVB
         kJvR/EN8S75WyB5kcBVpifNN2Tt7LXZoksYg8yxT3UDxeIbG/ROCPzAz8wFygJjzsdMh
         vzsDkiZUL/74rZn59ID5uVMmYEbJnpxgNjfVtbRozc9G2eYyPlNSBMB2yCu5FZGnx2UH
         Qb7A==
X-Gm-Message-State: AOJu0YzDwPV5FtBLO9yQl761ZHeAadthFZV9CgA89ihhYNn6fzGBBliK
	XogFNXjaVmm6ktTlNAYPzkRSPqDjFEPgt3crkXn8TEybEvqazyAlZyzRjjCDaBvJ9xZzovaYRwn
	zZ0AEgtsi3ejGb1S/rTQ7QnbqlzQSz9bN3TaYVJAqnokucNUOR78G6gBrb4k=
X-Received: by 2002:ad4:5d45:0:b0:681:888c:b82c with SMTP id jk5-20020ad45d45000000b00681888cb82cmr6893801qvb.125.1705944106734;
        Mon, 22 Jan 2024 09:21:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGsma1BTJH1NJyj/o8MHNafqTa7tvq2hIYGZ9YYQ15ylWOe7E5a5Aggrc/RaI6Iu3ZEfYrJBA==
X-Received: by 2002:ad4:5d45:0:b0:681:888c:b82c with SMTP id jk5-20020ad45d45000000b00681888cb82cmr6893775qvb.125.1705944106311;
        Mon, 22 Jan 2024 09:21:46 -0800 (PST)
Received: from [192.168.1.163] ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id lf3-20020a0562142cc300b00680c25f5f06sm2567738qvb.86.2024.01.22.09.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 09:21:42 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
Date: Mon, 22 Jan 2024 11:21:29 -0600
Subject: [PATCH RFC v4 04/11] scsi: ufs: qcom: Perform read back after
 writing unipro mode
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240122-ufs-reset-ensure-effect-before-delay-v4-4-6c48432151cc@redhat.com>
References: <20240122-ufs-reset-ensure-effect-before-delay-v4-0-6c48432151cc@redhat.com>
In-Reply-To: <20240122-ufs-reset-ensure-effect-before-delay-v4-0-6c48432151cc@redhat.com>
To: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Hannes Reinecke <hare@suse.de>, Janek Kotas <jank@cadence.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Can Guo <quic_cang@quicinc.com>
Cc: Will Deacon <will@kernel.org>, linux-arm-msm@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Andrew Halaney <ahalaney@redhat.com>
X-Mailer: b4 0.12.3

Currently, the QUNIPRO_SEL bit is written to and then an mb() is used to
ensure that completes before continuing.

mb() ensure that the write completes, but completion doesn't mean that
it isn't stored in a buffer somewhere. The recommendation for
ensuring this bit has taken effect on the device is to perform a read
back to force it to make it all the way to the device. This is
documented in device-io.rst and a talk by Will Deacon on this can
be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

But, there's really no reason to even ensure completion before
continuing. The only requirement here is that this write is ordered to
this endpoint (which readl()/writel() guarantees already). For that
reason the mb() can be dropped altogether without anything forcing
completion.

Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and power optimizations")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/host/ufs-qcom.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index a489c8c6f849..decad95bd444 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -278,9 +278,6 @@ static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 
 	if (host->hw_ver.major >= 0x05)
 		ufshcd_rmwl(host->hba, QUNIPRO_G4_SEL, 0, REG_UFS_CFG0);
-
-	/* make sure above configuration is applied before we return */
-	mb();
 }
 
 /*

-- 
2.43.0

