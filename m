Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899B913AD38
	for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 20:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711745451; cv=none; b=beytFl0kTk6hGkTM9iEbmrrv/wXZg7nAXWyFAGcVlYCPsj3bNFqw8AootArCazkbfztbAE4kD/seUXGO97i4pXKCvHFyNy8Qq8KazCtKYBlHJKz6Cm2e1ArGMZSy8hcsfuQAuGtBTSP9XzUhXb1amO2JADqU4BRg3MU0q00smyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711745451; c=relaxed/simple;
	bh=Zy+bgvSnjLkgq0s4C6zNdmvBRZh1cOH+2n6Swd6Xvls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mLA0cZhG+QXPXO+Y5awDl/h4ezUJxjtxL0Aswbp3mctrhMXITbn4gdP+8Liz0F2xr71xzVR3uDcoji5egAQ8wsXSfqC6fyXz14h5drLixvu84u4JTe5u+vymL4DWMdW9olZbN+39bWauhQalqvaR7yLMGrAvm4dLbkHQDAat0lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ckrvrsME; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ckrvrsME"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711745448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XPnsustGT4GoUrGTcO/hGoT1b1FUZsTVit4gdTDovY0=;
	b=ckrvrsMED1h4VCxfnb0ekQzIHI3IiRBdwKT+f6jfs2L0ilDK2Nudf4xEgo0mWeKenCPTcW
	0mUzgoUGZRNuBXqX7s06aE9JeE9zsF1uUya5+mdGVx0LxICsY43ye/eBYtXbvXDMJKGgvb
	FMO+B9jZlCvHTdSkA2xJLRc9HYT2edk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-sIFnOJscP22zvaz7q82iWg-1; Fri, 29 Mar 2024 16:50:47 -0400
X-MC-Unique: sIFnOJscP22zvaz7q82iWg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-69655dbec66so23874016d6.3
        for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 13:50:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711745443; x=1712350243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XPnsustGT4GoUrGTcO/hGoT1b1FUZsTVit4gdTDovY0=;
        b=uwnhQErkuOwgPIYI+HprFS1lb9W3Hk9f9ibq9Pme67cV30o93UiQ/1m76MfjoSJGYo
         7nnQR3rIhtQjqUikf/mHkGIlzQKcn2oRsSSDpPAErFQmiGlJCwWp8b/W6+xER/cI7HSo
         anF6klV0JODf+Bf9MGock09nejaYG14NcuXWU3HdsRclofk4I0hlqPU3WTf06XAQ6elV
         bJm4hAder/Up0IuGsk5r+jQZ8V0Xg1oGnELDR2rO91Byc9LcKVIQvWFk3LK0diXSwbMy
         9s/kAhjuBBHKGA1pVb9ry1pAjTYKlpfplDknOVrZO490pD43bsaKlY4KWlvH9yR3NSAL
         MVwA==
X-Forwarded-Encrypted: i=1; AJvYcCXbbDu12lFvE8IXwcN9ew6g+Uq3XdTWFMPo5zo/UGPWYW0PcJey12fCercC6K26V7dgBaXwBDVHMwJuCXABxOAEhk5dDC8OvfR8eQ==
X-Gm-Message-State: AOJu0YxItiOFVspqQRt5496PbKvnfIF7ezXiAW7V5i/irmziLXFDhLYq
	2k5XVZrvli6JJaqCpFdKWph5Q1BQOZ0zF/BjXZVrnJaLpg8TOfdZntfHZnXlDKvZ2lOrjKEBUTx
	cvroSmggNlGjLAc8HpluHmTD1mIF66rhz3UpyySziUSshzAk3+1+idORfVsw=
X-Received: by 2002:a0c:d646:0:b0:698:f3f0:39dd with SMTP id e6-20020a0cd646000000b00698f3f039ddmr2065508qvj.6.1711745443262;
        Fri, 29 Mar 2024 13:50:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBLrn+K4mLNtCh2Rz2Xmh067Hv24Kl9mQ40ZdwbQbhkZQb5T0j5S5g1FGjMUP56UzrNARqQA==
X-Received: by 2002:a0c:d646:0:b0:698:f3f0:39dd with SMTP id e6-20020a0cd646000000b00698f3f039ddmr2065487qvj.6.1711745442848;
        Fri, 29 Mar 2024 13:50:42 -0700 (PDT)
Received: from x1gen2nano.redhat.com ([2600:1700:1ff0:d0e0::33])
        by smtp.gmail.com with ESMTPSA id jz10-20020a0562140e6a00b00698f27c6460sm794271qvb.110.2024.03.29.13.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 13:50:39 -0700 (PDT)
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
	Can Guo <quic_cang@quicinc.com>,
	Anjana Hari <quic_ahari@quicinc.com>
Cc: Andrew Halaney <ahalaney@redhat.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 10/11] scsi: ufs: core: Remove unnecessary wmb() after
 ringing doorbell
Date: Fri, 29 Mar 2024 15:46:52 -0500
Message-ID: <20240329-ufs-reset-ensure-effect-before-delay-v5-10-181252004586@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240329-ufs-reset-ensure-effect-before-delay-v5-0-181252004586@redhat.com>
References: <20240329-ufs-reset-ensure-effect-before-delay-v5-0-181252004586@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.13.0
Content-Transfer-Encoding: quoted-printable

Currently, the doorbell is written to and a wmb() is used to commit it=0D
immediately.=0D
=0D
wmb() ensures that the write completes before following writes occur,=0D
but completion doesn't mean that it isn't stored in a buffer somewhere.=0D
The recommendation for ensuring this bit has taken effect on the device=0D
is to perform a read back to force it to make it all the way to the=0D
device. This is documented in device-io.rst and a talk by Will Deacon on=0D
this can be seen over here:=0D
=0D
    https://youtu.be/i6DayghhA8Q?si=3DMiyxB5cKJXSaoc01&t=3D1678=0D
=0D
But, completion and taking effect aren't necessary to guarantee here.=0D
=0D
There's already other examples of the doorbell being rung that don't do=0D
this. The writel() of the doorbell guarantees prior writes by this=0D
thread (to the request being setup for example) complete prior to the=0D
ringing of the doorbell, and the following=0D
wait_for_completion_io_timeout() doesn't require any special memory=0D
barriers either.=0D
=0D
With that in mind, just remove the wmb() altogether here.=0D
=0D
Fixes: ad1a1b9cd67a ("scsi: ufs: commit descriptors before setting the door=
bell")=0D
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>=0D
---=0D
 drivers/ufs/core/ufshcd.c | 3 ---=0D
 1 file changed, 3 deletions(-)=0D
=0D
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c=0D
index dfa4f827766a..a2f2941450fd 100644=0D
--- a/drivers/ufs/core/ufshcd.c=0D
+++ b/drivers/ufs/core/ufshcd.c=0D
@@ -7090,10 +7090,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba=
,=0D
 =0D
 	/* send command to the controller */=0D
 	__set_bit(task_tag, &hba->outstanding_tasks);=0D
-=0D
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);=0D
-	/* Make sure that doorbell is committed immediately */=0D
-	wmb();=0D
 =0D
 	spin_unlock_irqrestore(host->host_lock, flags);=0D
 =0D
=0D
-- =0D
2.44.0=0D
=0D

