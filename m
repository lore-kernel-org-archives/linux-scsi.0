Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313C5286A6;
	Wed,  4 Sep 2024 04:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725425908; cv=none; b=fRat/3Bzxo7v6TvFVGdiJp8kV5G9BCk3WXEjDxoeJJBFbN8piX6AV5PI9sIOk0XpyL+Ajmp8qn9dNGB48jEizXq+VqI8xYnQ6rbildX8qe02/kjXazi5vCjEl/uFwwwUURezsSUuu4di1UhBXdUZ0la7tfIHVB0NkfLAP9J2y84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725425908; c=relaxed/simple;
	bh=LhI4B56slGs9YPgAwlbHmUKmiqFYCpgK6OupcKSiUJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtLy/iI1fxZfJTI6TzhbT9h7IFTGysZBPPU2dV9AvsmmOQes9oe6crOuVK0i1YcoC2Sort46xUHqky4+jT7WO4Tw16UgXr1pKYDFEPUNEFtWx8TUVC/NX9WC/QdGVrIOSxoHOeimx9qKTA8hxgYW6Kja8XhadxJhkS142ioCGJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RXCyRG7T; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RXCyRG7T"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2d8818337a5so247665a91.1;
        Tue, 03 Sep 2024 21:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725425906; x=1726030706; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dc+SrEyI9sxhQZvqFrCZSaR00xZLH9W3lK7EOUusxxU=;
        b=RXCyRG7T9HzO9qd2E+3wW9MaiwobllggYUo/UjNRt2gXFW78VdORjoQnGGtq+o3iQ3
         wQvQRb3s9B3j+XE9ZbQCvRA1X7/aaxc9JUfQSU6tAOMBwsrzdZL7FKz8K1HVdq7iDNin
         QLSTYVgwhe+ii6MlefHQLnjeNRrOc4u6U6qzRrrH6htst8o4g1129lmXC0Z92VWcpl+l
         lgXAH7MzqGo9pl3IzgzazUdsQVASU2892BVbNEmMkQihYde3QC9Rmj/sge5BOWz/SrJk
         5xGOQoc/nZni0XiWLgGUbyVkfrvYKLaa15BWlIuDiLp1V1J6R1sR8Bcevph7sWgqDP46
         xD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725425906; x=1726030706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dc+SrEyI9sxhQZvqFrCZSaR00xZLH9W3lK7EOUusxxU=;
        b=jllkOGite6JBMsLis72CROx6cFwWXtKdOFbQ688FQFvNbJbxYuFE1H0PUfTwy3QjQb
         q7cXVeRkys4mF+/HrGqW4DXHoTfM2p2YdTbGauKApsi8zTddGZIp6urnI2c7Z/zKgKmg
         1oXUHe3L6e9jioEHQSptsMhOHsINFw1sn0cOZVFHVjlivvf5+Lq3mgLDg5u5jU0JTlBz
         6G7c3175CAVrCv/dp5jdEEBC8nYwoxpujzQRExJcSppaJcTlTUfU74rnJtjcBq5yH26+
         Z7sEmgpuMhEQkDGvMOLgkLCqnOUXrv7gBmeF1nNQIkxV66ZgjxRhDGZjndpwCpv5aKeG
         jdkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxvPlDvYvQRo9foH3Z9To2huQqBEUq/FpscwqnNIbZBnCiCXl5ZMqrndcIx+pBjE67l2VXBPj9HPAJpwM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0F3lubZlILSnfVnZHxsgc1wFI5Me8gvZOT540P77wI0HzJHVE
	BGeOf1oTywasdWJZp7/w9VxfbtP2u5iexBtRpgrCnRxnRcDv/cc8NRIm7chHETw=
X-Google-Smtp-Source: AGHT+IHxcvPeN3R2FI7JuFZ+OXwq4fOXwwv1cilWhl0siVVpuZLiDTm3IlD0Mqd54DDDF8w7dKyvBA==
X-Received: by 2002:a17:90b:4b07:b0:2da:6e46:ad48 with SMTP id 98e67ed59e1d1-2da8e9cf76dmr1491007a91.1.1725425906215;
        Tue, 03 Sep 2024 21:58:26 -0700 (PDT)
Received: from fedora.. ([106.219.164.163])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d85b0fe17bsm12378511a91.10.2024.09.03.21.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 21:58:25 -0700 (PDT)
From: Riyan Dhiman <riyandhiman14@gmail.com>
To: bvanassche@acm.org,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aacraid: Fix memory leak in open_getadapter_fib function
Date: Wed,  4 Sep 2024 10:28:18 +0530
Message-ID: <20240904045820.5510-1-riyandhiman14@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <bf6746d0-d8cc-412e-ac7b-6f17c3e3de9d@acm.org>
References: <bf6746d0-d8cc-412e-ac7b-6f17c3e3de9d@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>>> Just above the copy_to_user() call there is the following statement:
>>>
>>> 	list_add_tail(&fibctx->next, &dev->fib_list);
>>>
>>> Does that mean that the above kfree() will cause list corruption?
>> 
>> Yes, you are correct. I overlooked that fibctx is part of a list, and freeing the
>> memory without removing the list entry would corrupt the list.
>> The list entry should be deleted before freeing the memory if copy_to_user() fails.
>
> Are you sure that this is what the code should do?

If copy_to_user function fails that means data was not copied to args successfully, which can leads to 
issue as args might remain unchanged or in an uninteded state. Since we are returning an -EFAULT error, 
we should free fibctx and remove the list entry in the case of an error. If there are any other methods, 
additional checks, or potential issues with this approach that I should consider, 
please let me know, and I'll make the necessary adjustments promptly.

Regards,
Riyan Dhiman
