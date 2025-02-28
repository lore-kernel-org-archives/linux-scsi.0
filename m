Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D90A2561D6
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2025 09:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740735456; cv=none; b=dKN8eqLZ4pMvaSKWe+xENnUMBBFjWHXiYK1HpB4AsaV5IoH0w7plmmGv4NRWrgSd5hwr/SU+iphywEDYCOiSdVOlYWPwBzPD62jSxtq9y5OPxworvpQwUb94GLGgqcaJV09aMXNtcV2TDVTgs3cOrvLgOuFPClpPCzZ0B89zwmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740735456; c=relaxed/simple;
	bh=mXhku7IHghHzgD5uOXEgBnRnYCvInJFCk9RjXNz+DvU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pei0LhaUNs4CtNjqh4HmHRlYXIzl6B3JAr+UQbIZ7TTJ5m43GOT0SAjUopmrsbebH6zpo4FEiLU/rcI6YLMFjcgjy/q0Hug+jy1jtjhgjWMxQB/LqVcRkI3m7AFWW/lnCOha5vU0ICakjQZCZG3afC28AzfuTTwa/UB4dYV+2jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RShMBrKZ; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RShMBrKZ"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e4b410e48bso2859078a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2025 01:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740735453; x=1741340253; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AF5nsT/tqJ0sa2KfZr17M52RbC0HR9O1oH21NA6kGQc=;
        b=RShMBrKZa4frQH1WfVRbDnLv0oUQPpVhAi4h8RWZTs9uX2YvDH9G5WQeTpu4aMTAYF
         LO/H34ljYqumzEW39GOSL/mnyekQiCtaMgHPygeub9nbXEE44OHDu9eBqTG0KEmUSEVC
         huMMPzwhi/sbG6V1TxocxBfZuY1iFRVOFSthB4o0GKKWUAuXJq+h6CgJViLcxwsNOFJl
         JYnCuZYbJh0V6NIfQS+IjsOYRqC+4skk6h+fny+vaaGwtWX3D3sbKgfTyH2jVmuYZJHM
         JJBEWwvtYDDFShhwc1FTiB+rYl2Cou2aqkEn/MxWzC2athtDFbD9zDn80tdrKsiqANpJ
         c0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740735453; x=1741340253;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AF5nsT/tqJ0sa2KfZr17M52RbC0HR9O1oH21NA6kGQc=;
        b=BpaVABQ+ZwoznlLusJyxHONv30jPKx8PNGFZ1Rq2FFx7XMggGs0pSvtpVBLzwdtrnQ
         ZKDHUF/5s/1lu2fnceILVXGnldNEBT8qYKfJM9PpI1nRW8SKnuyXCTjFr7Fz8wc82CCs
         N2H+BfDadDQlFlQjc/lJyP/ox1peY7TdZDw+jw8+Txs27SSbTBpTxGfqvAqMEDsQL7gH
         CXmGbQAtZIUPCSLz51/AYPp1x6rQb/J7PUV29gWFLo4iXctRaNhjbuJAggXtJuNGamPA
         u9oNS7XvIzh+g7O51hbWjrNyBA8HjpIunZEy8VDkpzyxHx+130teLa7/bcYQniSRqhFn
         DsdA==
X-Forwarded-Encrypted: i=1; AJvYcCWZNLS0tIRzt2eh7slHvOP3zZwY0jrD3Sn+yudC+GzvwXKI3usYg1+w30l3UJOQz8d9p/z97ibJjPET@vger.kernel.org
X-Gm-Message-State: AOJu0YwwqFtnwCr9QTMtp4TX2NyTbBKcsexpvLdR0NMkFyXjYIXDRWgw
	rMo70XyXb7CdjPdRtUaLvRyfrugiXzJBsv/kXhPMfcEo44OTnDRJNb9jqG3tKWo=
X-Gm-Gg: ASbGncvCpkv7JzZ2AzqsG4VALdTPxQMojBUnPm45Gur0nrZi2cSlz5gyHfSz7hO7MRC
	wFltVg+h/eVSgXuQ3jpa3cExy6pmkzNc+uolkLbpOPr/sZ0n43pWjn9cF7GMmQ1LDgbqRj/QjSX
	vH88ONh6q2ZGHv3PTeuHCzAykEcb5jJUb7A59+lGhfCQVGy3gEcu1CgBme9/hvhCjd1iA+dvBko
	G4CizhOHY2M0lT6gvhhdRlT+Brh3hz9sZ9MBHJCnNWUJcpIPrj1cXBY+i9Chv1oG9SRxRz8tTgz
	faIuemPWyuz8seJr8YWOLFmkP5iVNjA=
X-Google-Smtp-Source: AGHT+IH0rbUhLFGAEfY+tGINt28wIT6ZI81UIlrbwU1hKXYL7titFBMGZMuaFvwZupi/juouiULxXw==
X-Received: by 2002:a05:6402:2813:b0:5e4:9348:72c3 with SMTP id 4fb4d7f45d1cf-5e4d6af105cmr2172188a12.10.1740735452591;
        Fri, 28 Feb 2025 01:37:32 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5e4c43a4e26sm2229958a12.66.2025.02.28.01.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 01:37:31 -0800 (PST)
Date: Fri, 28 Feb 2025 12:37:28 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH next] scsi: mpt3sas: Fix buffer overflow in
 mpt3sas_send_mctp_passthru_req()
Message-ID: <02b0d4ff-961c-49ae-921a-5cc469edf93c@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The "sz" argument in mpt3sas_check_cmd_timeout() is the number of u32,
not the number of bytes.  We dump that many u32 values to dmesg.  Passing
the number of bytes will lead to a read overflow.  Divide by 4 to get the
correct value.

Fixes: c72be4b5bb7c ("scsi: mpt3sas: Add support for MCTP Passthrough commands")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index ff8fedf5f20e..063b10dd8251 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3017,7 +3017,7 @@ int mpt3sas_send_mctp_passthru_req(struct mpt3_passthru_command *command)
 	if (!(ioc->ctl_cmds.status & MPT3_CMD_COMPLETE)) {
 		mpt3sas_check_cmd_timeout(ioc,
 		    ioc->ctl_cmds.status, mpi_request,
-		    sizeof(Mpi26MctpPassthroughRequest_t), issue_reset);
+		    sizeof(Mpi26MctpPassthroughRequest_t) / 4, issue_reset);
 		goto issue_host_reset;
 	}
 
-- 
2.47.2

