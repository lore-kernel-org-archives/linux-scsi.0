Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1883A26C39E
	for <linux-scsi@vger.kernel.org>; Fri,  3 Oct 2025 09:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759483829; cv=none; b=g/tQCz/zBzxXOk8ZAejQ3ilyaVdAShRDmr5553MS61FWSnphdYTxM5A+EYikY9nt5h+ag8YHJAx55gyD8AYZEHIBsV2KsweWvsb5Th9ytlej6+phkgXNM6oM44TJkfY1AdSRozy+lCUcqIU6rYuO3Cark2i866Y0zbO0q9oCYEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759483829; c=relaxed/simple;
	bh=GBHNdzaM8gQtenoI6mfiM6GXui5H0h32LA0yeyj2ciU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=o9/hEDvQDcT0Eb2iBWzKrgN9Lxa+V8TdpKhe25vnlV+f7Fs4yhcdsrR9EGkQ4u3qQjbBmJJMG6Lx/KTrtqEdVX4irJ/Un8ockS+UWHNMMEHyFxNjBzoIsdRYQ2laLzhbpXFV7+zOXqCf7Uuf+ZQmX6CuRH1I0uWXAgHWmHpwdfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zDhqyWWD; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zDhqyWWD"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e42deffa8so21084585e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Oct 2025 02:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759483824; x=1760088624; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H0EBtqSqgeFXQZr6pfRdyEIeXrxqzAS1NvTsWALCO9I=;
        b=zDhqyWWDmQQqIEcNlrCmIFaOLAaBzzONFG5CKJYdnflPDvT75Fu9+SqUEQwCHqVgU9
         51L005SfsL/qeeWLUgeFYeQ54iGo+wlKXWbAYlUXZjNsx6iuP56fvc2UUnZru/BR0edA
         hpklvOdSpRFrT4faHJnTofiJVcZkpjICLCWk6ricOll6scTibe3fI3zff3O6+lJYaX0S
         h4/OcthiUXKhezdZtxoat9h12oZBiwW8cxwqs0GbnRGS2JFAj//d5CxLageDG1L3RQ9Q
         ZY4q8CCjLyyeZqfMmyK3soDnF7UiVy3Yavf42WRi26I3HQiQxbdaLQNmJc6UNDPr8Wph
         1TQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759483824; x=1760088624;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H0EBtqSqgeFXQZr6pfRdyEIeXrxqzAS1NvTsWALCO9I=;
        b=ZvX7X3nLKyIaUL/+dWY8MCWgq5VJGOmhe/GY0POaHA3PoxaBlQetN0gy6oIFmS/59e
         RbE9untMWYbpprjAAMBhDZ078whfLcUNmLWz4DKuVrawjxApLwiVouWlU/vfpqYJW394
         1ykfGbIeL8hcJjDHE/PmNebzoeCRZaY8uIpcLOfYc/iJtYwlEXRH9Na6bHFZCndzlpNb
         vmvG/n5aRsQIHZW2ax2H59RVohqI3Gyz1AXFoYiKUOlvEo2lC4CnqjLmX7MSGjerWX6T
         ErNTGxTmHcZ3PNzBtfVdH7r6NH3XuiY3xPB3w7YbaMtBIyXKAblHttKbJXtuhnOHORj2
         8MTg==
X-Gm-Message-State: AOJu0YyTolehYG5dqOTIah9BBtJ5c0gDtgkLTLMk44Hvk+9o3eFJZuoy
	OXgGQf0cDDz7luQJItQdR8Y8ri+LkrYBK6Y0x/9WrLPOpAyGMlWK+ChKi9xs4Q7oFbchXUWRu4c
	+K1l4
X-Gm-Gg: ASbGncsc7WprEXMd8AvaQvvsXb0MPVNAxNyNQwAQPO3cPyRrgDcIbXcyyqeuNZ5OXmA
	2IpUjukxiWuuGR2ze5MBW4cU34RmepMzApi+NJ2/7Bn5M6xudYjrCrLO5wbm/nXbm0ktU3ADzhF
	0aLXNdKzvBXdnLr5CWE/frjGSJwNOyLXzIsv21sMWkGlsFg0H4zhy0wuh/YZvFDgo1vHwcnPrKF
	zHsBX5Pd9CM3rmZOb/QnATZtvypqbr/Rq0XzqiACdt/YiOTBzWivxeTYCvb0cZthMZdn9d0fgkU
	XbEUnpqjeBdpVMUet9FCSq9MrX37J9Kd4pYNwHEVkqO93dguTcZFUClIK3b9K8kcSgcRmWEbFgw
	JrkffGJCCKRcimA+Lu58RFlgeV1dJJ9yJ/OPPVVXDRP7u4AMRShq8tCwXVPC8KaC2Vx/XXPhkri
	icTg==
X-Google-Smtp-Source: AGHT+IH+Lup7L6QjLVrHnG70AJPFRPYs/0x1M/U3EfC2D8yaLIgDfQYT/ILk8Vbo4NnJ3GC1aOdDvg==
X-Received: by 2002:a05:6000:4212:b0:3eb:dcf:bfad with SMTP id ffacd0b85a97d-425671aa848mr1445856f8f.34.1759483823621;
        Fri, 03 Oct 2025 02:30:23 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4255d8e9780sm7067474f8f.29.2025.10.03.02.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 02:30:23 -0700 (PDT)
Date: Fri, 3 Oct 2025 12:30:20 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Peter Wang <peter.wang@mediatek.com>
Cc: linux-scsi@vger.kernel.org
Subject: [bug report] scsi: ufs: core: Fix runtime suspend error deadlock
Message-ID: <aN-XrK70ORfuWfEG@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Peter Wang,

Commit f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error
deadlock") from Sep 26, 2025 (linux-next), leads to the following
Smatch static checker warning:

  drivers/ufs/core/ufshcd.c:6844 ufshcd_err_handler()
  warn: inconsistent returns '&hba->host_sem'.
    Locked on  : 6691
    Unlocked on: 6683,6844

drivers/ufs/core/ufshcd.c
    6658 static void ufshcd_err_handler(struct work_struct *work)
    6659 {
    6660         int retries = MAX_ERR_HANDLER_RETRIES;
    6661         struct ufs_hba *hba;
    6662         unsigned long flags;
    6663         bool needs_restore;
    6664         bool needs_reset;
    6665         int pmc_err;
    6666 
    6667         hba = container_of(work, struct ufs_hba, eh_work);
    6668 
    6669         dev_info(hba->dev,
    6670                  "%s started; HBA state %s; powered %d; shutting down %d; saved_err = 0x%x; saved_uic_err = 0x%x; force_reset = %d%s\n",
    6671                  __func__, ufshcd_state_name[hba->ufshcd_state],
    6672                  hba->is_powered, hba->shutting_down, hba->saved_err,
    6673                  hba->saved_uic_err, hba->force_reset,
    6674                  ufshcd_is_link_broken(hba) ? "; link is broken" : "");
    6675 
    6676         down(&hba->host_sem);
                 ^^^^^^^^^^^^^^^^^^^^
We're holding this semaphore.

    6677         spin_lock_irqsave(hba->host->host_lock, flags);
    6678         if (ufshcd_err_handling_should_stop(hba)) {
    6679                 if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
    6680                         hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
    6681                 spin_unlock_irqrestore(hba->host->host_lock, flags);
    6682                 up(&hba->host_sem);

Released.

    6683                 return;
    6684         }
    6685         spin_unlock_irqrestore(hba->host->host_lock, flags);
    6686 
    6687         ufshcd_rpm_get_noresume(hba);
    6688         if (hba->pm_op_in_progress) {
    6689                 ufshcd_link_recovery(hba);
    6690                 ufshcd_rpm_put(hba);
    6691                 return;

The patch introduces a new return but doesn't release the hba->host_sem.
The patch was supposed to fix a deadlock but I would have thought it
would introduce a new deadlock...

    6692         }
    6693         ufshcd_rpm_put(hba);
    6694 

regards,
dan carpenter
