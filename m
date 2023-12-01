Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Fjo9L6Jc"
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35A81725
	for <linux-scsi@vger.kernel.org>; Fri,  1 Dec 2023 07:15:02 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6cdd9c53270so1923393b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 Dec 2023 07:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701443702; x=1702048502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=63N0jK5ZcBeJuBTrtXzoyRGZDNopQVJCv+vFWIRCiEI=;
        b=Fjo9L6Jc+XW3mkryMOXpBapHySvMEDBSGGCVBO8lKPjx7PdZLuWUaLsxYvzM/zTFbn
         4ELY1d/1mbI2mv6Fc2GfQZ+WiWX6jtLmyhZJIze7wkAIcN+3BQQr+tHhd9n+DP048NB4
         XseAf8A8MyPaH/SxxUxVuJ/OxSGM7FTYwaafsbEoIwBG8tVzOem6LWxZhepU8ru5LFQo
         JxAF4oWgM8154LI6XfpShBUPEntXLajZRlDIjE/MSLb1kIV/UDEkau5s/8tyzykTtvL3
         IpskeAyOYgH7I6YtD2v9Pg15b9C3SNioexQinroYbUk1vXzbPtjfyrbHZN05WXqmBBHU
         LZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701443702; x=1702048502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=63N0jK5ZcBeJuBTrtXzoyRGZDNopQVJCv+vFWIRCiEI=;
        b=CYupNpQxnFZh85zKpfGe/cpsJISuFJLsxHGfHEpNno3rkynOhE/pjId1fLmrDDkm7S
         VYxhaLhtk/8o8Epm+A74zZDF7cEqJRaIq91mIn9VwUE1drd+qORuUNgZ/oFE921jngQz
         6LKZL62N22UFTrOdBJVWEeD5qRZAeq85gD+5mgSZVtHTwQ8LDLFJIhF1qLdpAs+5BKPv
         +SV9tv9NyFFpKT0+hn5AHCokAn99uiTsxCN6jF3NfzFjwAhmUj0MGqdDH5K/m19LTyNR
         1v/19n2rJD306O42qhQjETGcNA+ozweN8pJ+S1I313Td2jkARgHbSMTdCwDcua7eGZKN
         AKOg==
X-Gm-Message-State: AOJu0YzIPOuqdmw55abE2WcXKuKHs0EtQN7ikLVFHunexXBPUElWpA15
	A3SpyiUZRdvAk3EXi6frpvju
X-Google-Smtp-Source: AGHT+IETQ1stSQmwhPIzf25NLke8Nu64YavF9AVB6RzSBdjnw47xK9+jZxC9s0vLs8BKJXMe1U27ug==
X-Received: by 2002:a05:6a20:9150:b0:18b:9682:59e9 with SMTP id x16-20020a056a20915000b0018b968259e9mr26138765pzc.21.1701443701963;
        Fri, 01 Dec 2023 07:15:01 -0800 (PST)
Received: from localhost.localdomain ([117.213.98.226])
        by smtp.gmail.com with ESMTPSA id s14-20020a65644e000000b00578afd8e012sm2765824pgv.92.2023.12.01.07.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 07:15:01 -0800 (PST)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: martin.petersen@oracle.com,
	jejb@linux.ibm.com
Cc: andersson@kernel.org,
	konrad.dybcio@linaro.org,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	quic_cang@quicinc.com,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 08/13] scsi: ufs: qcom: Check the return value of ufs_qcom_power_up_sequence()
Date: Fri,  1 Dec 2023 20:44:12 +0530
Message-Id: <20231201151417.65500-9-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If ufs_qcom_power_up_sequence() fails, then it makes no sense to enable
the lane clocks and continue ufshcd_hba_enable(). So let's check the return
value of ufs_qcom_power_up_sequence().

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 4948dd732aae..e4dd3777a4d4 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -415,7 +415,10 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
 
 	switch (status) {
 	case PRE_CHANGE:
-		ufs_qcom_power_up_sequence(hba);
+		err = ufs_qcom_power_up_sequence(hba);
+		if (err)
+			return err;
+
 		/*
 		 * The PHY PLL output is the source of tx/rx lane symbol
 		 * clocks, hence, enable the lane clocks only after PHY
-- 
2.25.1

