Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3548248C;
	Wed,  4 Sep 2024 04:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725425058; cv=none; b=OYtKJTuUq1O/h1t5XSvhti/+4UyqbBo4fz3gwWywnrcBbiE4IQUiAQYpkXq9ICf1fe7NAXaayEZ0q49SHGRn4mdDgmcVYLpRTUsl+757AdtbiBmPpAIwesd1N+jmsOH++lTCVnYZbjz8op1xLBYdJfqkgm5PfV29pnn592b6Jxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725425058; c=relaxed/simple;
	bh=HbSVeyGlyfMkVx1t2iiecleOFI2Uqsl59xQXLDO1UvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwLssDbG/Eu4U/Z/wpRJZYKN0iC7NKT5J4fOX/aniVoPiiREdIjXlNiXoz59I0Rp8zgpIF5yYbhoGYVV7/JATrXEEwsg2K6Yr1BimwDRgb98P4yiEjNULXhvbpwavMUnzf/m/bwOsTyalboAYNI/RS6aKvV1zfneUb9OGhQRmXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IilesiwP; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IilesiwP"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2d8b96c18f0so2320217a91.2;
        Tue, 03 Sep 2024 21:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725425056; x=1726029856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mt+0N9jJxyAwx8NVNH01DHTvE6N0adpofG7Pe6wqFbI=;
        b=IilesiwPz6yjQDduep8JL+BiiBtOgs37Z//cNJv89AY7c+nTtrJvHzmPMzrwvAnigK
         s9Hkq96kUkb405lVfWV9yHxxKY57D9IaCGWVCCjIv7m8xJQeopCS5Yg19J8DvkJ7P43t
         YzY6o0nlpT6f6A/TV1JsLb1O35RGFBzz3yBJ8vnBxj9Cnh9P9n3FdTLyShUmRhOymPM4
         OW7zPKyW7T5WjDAe3DGRFfYMq1yoVwfV9/4bj2ybHJTHRnIsxF6rFrp0UrOPxGyC8rPK
         Ns6JdLSIAV33bE6NUkEzL2EMagdF7tAyfcB0TwMWroP++IeCZdaLRuEwTGfTtU2eQZ6v
         6/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725425056; x=1726029856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mt+0N9jJxyAwx8NVNH01DHTvE6N0adpofG7Pe6wqFbI=;
        b=jjG+zMafuBiQBsRAtQCFcGZ9ubjKPFDuEOptH+FEqjLE/9iaRbEwKAxOSrcm2Ej/Xz
         gnEDyZdIUCWn4xUx2dr6iEBwxxQjiL0A1BcpuduE1sl93FH7x1pmBUmj7OzqOA/fA3tY
         APxMKpBUkvnriRT8gw7uuPZu5EzLkOiT4HCmjnXXs+ONWJxOECfZ+5R4bo3OZvNW4p/F
         Hk61FH9IP0W7yxnqL5H9oW/Gx8gJoJ9GGlT0jfjcC3UKBUrjO7Zj9sYoCnq35KcIotul
         qsIPXR8xse9ONmdv0jt0UqZqrAC1cumWRLANejxzge7apDNAohazJIahyi6cdFkAafYt
         SJxw==
X-Forwarded-Encrypted: i=1; AJvYcCUHeYw1BDaiUhkbeu4BlafcxXgBhB5i1XiIhgTZubbTwh9o6kfIb7b9l1LCRAf9DTvowEg0d1vxsQAHbOE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLnvK/vpd4uDZ3HBntX73kZ6De8YhWkEsWwwiOeJ6xPvr7XNR+
	Y5Mstq+BczbwbOVDw2XTLqNfPTO5+38FZ/+UNM0moQUabUGrIwuL
X-Google-Smtp-Source: AGHT+IHx6kCUCGOSn3HU1x4KmnxOS9mKsnI6/+/FFUeOV0Fwxo0ODUwWE/4KJzru+FUswH5QpG0rhA==
X-Received: by 2002:a17:90a:c286:b0:2da:61e1:1597 with SMTP id 98e67ed59e1d1-2da74e5fdfamr3510188a91.36.1725425056062;
        Tue, 03 Sep 2024 21:44:16 -0700 (PDT)
Received: from fedora.. ([106.219.164.163])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d8ebdf56c0sm4792636a91.23.2024.09.03.21.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 21:44:15 -0700 (PDT)
From: Riyan Dhiman <riyandhiman14@gmail.com>
To: bvanassche@acm.org,
	aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aacraid: Fix memory leak in open_getadapter_fib function
Date: Wed,  4 Sep 2024 10:13:00 +0530
Message-ID: <20240904044409.4783-1-riyandhiman14@gmail.com>
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

Yes, removing the list entry before freeing the memory is necessary to maintain list 
integrity and prevent corruption. If there are any other methods, additional checks, 
or potential issues with this approach that I should consider, please let me know, 
and I'll make the necessary adjustments promptly.

Regards,
Riyan Dhiman
