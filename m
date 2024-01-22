Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBCC51000
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 17:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705944110; cv=none; b=sYqVBl0JPqy337lHEZii75QG/k/bqXjrjyJ3VgaEQ2X8a2bh4lLmzgP7sNP6DkQGRjFNsV1+tnmhCEMUDHOfFTT/5tCCwD8L2yRFDAhKGs1+J7ZMiJ1mDPmQtV41Fz0OSEcn4B0oQ6Ob5XDTCyJfF+yQarguLzZFMppRIU6RA0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705944110; c=relaxed/simple;
	bh=r/jz8Df2KX737BM4u04ZW0ds9pGrXMmBG5wbF5ma2rg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=joSMHd41NUN9wkzQ8xPyWzl5/8Mx9Xnjjtb8bAmPEsRJSaChcMyDPuQgPyDO2vmHKFhy0gauTDNXEcw5Pstq/GMvlTRV2jvJMSUn+o5qzQV0vFCFAUzzExd52F4JoY+KA2Vs9af1cjBM7aat7BOnTmXxI/NegPKc6BSvub6mpxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fQY+o1PY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fQY+o1PY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705944107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sjlATDY0QO5uIJmBTf+Xy8olJtH1umxQHbsM1EB2vCM=;
	b=fQY+o1PYoNW03yURhTttg2ocIQGgdTpQVaR7xb9I72660Ox6pWOcstdVbIi0FalbrGCcxx
	F1Px7KpNmzHUpBNf5wMz6/luXPwyzxQEMQyaKt1xAPYeZnKme+NYQzsHpYY8dcxR+awS29
	YoRNY1ECVaNtAilKZYKMORtf94oCZyM=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-dcPl2ujIOJq9WYC1IPMOOg-1; Mon, 22 Jan 2024 12:21:46 -0500
X-MC-Unique: dcPl2ujIOJq9WYC1IPMOOg-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-598d67da1c2so3204053eaf.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 09:21:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705944102; x=1706548902;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sjlATDY0QO5uIJmBTf+Xy8olJtH1umxQHbsM1EB2vCM=;
        b=Te2/QBH9Az5BRXD3J5izBoab/O6MVMmMfQGGrCRj0fL3XOLrwwkkYyXoRFxfySMKNh
         BMUp+rpjSA3X8BBHxqiBKt0Slz0nyrghmuuD/a+Y0DHWvs5a7RQoz7JxF4lvisLIvjyG
         4M3T4YNuTOxV9T+X3CEGF4jSKLEbIzOUxFYYPjBfCP/zDzHh8vUmAcUu0vKWpx27v68G
         AaqDgWvfH0g7rHzMGgU62N5SSn07gcKe5dk/A0ckoM6xI488w0JG5aQB9Y3XkswmqMZQ
         pgOmY6+3wH6qYFxo0YRX2oOvR5L7PSML1DIWqYDuB92B0sWRLrygFaiv8jU/pH4OZ28l
         J/Qw==
X-Gm-Message-State: AOJu0Yxw7I+YKZRruGHSDytQGt/nX92p4NNxCRH/as4uxWXq869jLfZS
	cPr84I9zrl4xZwR37Y3fAK0h1gNrP2fFqxEjxuR+btX9JkNwiAELuatMZ0hS88Cg4f37S0h6hTR
	P1Z04PSqtuQYpe1zClyBDy+pc+ZFn9FhF4SA1LPZEldHY/OdnNP3JtcrWJtGpT2Dj/zY=
X-Received: by 2002:a05:6358:9386:b0:173:203:c5c1 with SMTP id h6-20020a056358938600b001730203c5c1mr2261919rwb.62.1705944101728;
        Mon, 22 Jan 2024 09:21:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuePQ2c2TR6znf0LRpOqv6HnOFMSiNT+KeM1co6Jjj6P9hOielxqplttblTBbZvrww1rTKog==
X-Received: by 2002:a05:6358:9386:b0:173:203:c5c1 with SMTP id h6-20020a056358938600b001730203c5c1mr2261899rwb.62.1705944101357;
        Mon, 22 Jan 2024 09:21:41 -0800 (PST)
Received: from [192.168.1.163] ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id lf3-20020a0562142cc300b00680c25f5f06sm2567738qvb.86.2024.01.22.09.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 09:21:37 -0800 (PST)
From: Andrew Halaney <ahalaney@redhat.com>
Date: Mon, 22 Jan 2024 11:21:28 -0600
Subject: [PATCH RFC v4 03/11] scsi: ufs: qcom: Remove unnecessary mb()
 after writing testbus config
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240122-ufs-reset-ensure-effect-before-delay-v4-3-6c48432151cc@redhat.com>
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

Currently, the testbus configuration is written and completed with an
mb().

mb() ensure that the write completes, but completion doesn't mean
that it isn't stored in a buffer somewhere. The recommendation for
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

Fixes: 9c46b8676271 ("scsi: ufs-qcom: dump additional testbus registers")
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/host/ufs-qcom.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 0603a07a23a2..a489c8c6f849 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1429,11 +1429,6 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 		    (u32)host->testbus.select_minor << offset,
 		    reg);
 	ufs_qcom_enable_test_bus(host);
-	/*
-	 * Make sure the test bus configuration is
-	 * committed before returning.
-	 */
-	mb();
 
 	return 0;
 }

-- 
2.43.0

