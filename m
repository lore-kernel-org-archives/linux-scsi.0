Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9E31E1DF2
	for <linux-scsi@vger.kernel.org>; Tue,  1 Jul 2025 07:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751353873; cv=none; b=mlpcVIdNys4bkS7tDphi2YNWqYUXqnmWVPJRgTWCVQTdgXUaUfO7VpTfM+Xr78kwa0g4NGLv2Wf5Y/VW0TcpnHkByBrk5lOnR3bk47YhRPRu8SrDaKoLirlWAKK5OWIcMtvg9BSU0AFv62GQ6pS6NZcM0UdEGnUjrk4akLItM4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751353873; c=relaxed/simple;
	bh=gz2k1uTtHT3pD2yquUXxfcMI0+h40Ol80pAebQJKDGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EkhtEatn2/csV0vT7ibPCBTPWNZWU61SspvN/YuVAu8/JxXB5SMYHjwUa/C2der3v44FhhLAfDvGUUHWGdFS+raZSrCqIEXmVG0cyUDBmq8Y/3SqFDk06EJPpSBLVaDdbzrv6VB5FbXEyl9umnCcqpZFcFOsHoP88GAPkDYx+vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Wx71Edoa; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Wx71Edoa"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-748f54dfa5fso4596771b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jul 2025 00:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1751353869; x=1751958669; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=zlJot7sx2YopdWxHyoyhohLl4TchU03X/u4osGspitU=;
        b=Wx71EdoaavEbpZ+ztjNWAWzP+tmJXo7QGk3i/7WgicRvtrUSMWnYaYcSqxXmTNJ/et
         1wC0kNTvB1smJFED8VqLpsT0eWIekq8tR0eH42kJvOgtNa5tu0IO94ZXL7vHiSPpmV2+
         TxiX7/mss8RoU+ipG7oIrYXQs0CnyyIrtGpIA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751353869; x=1751958669;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zlJot7sx2YopdWxHyoyhohLl4TchU03X/u4osGspitU=;
        b=pRj4lumhXOQrHX3xidlqz4F+DwqNJ8EJpJI5pqHTN0kO2fV0LlUQkNLvUXU91TYdiW
         UZx4XAEUxHCfraPiDEShWyuHsf+YSDXEp480MHCWPzrOBPAZR2CgUwJSuqxvGknwmf9a
         XXuSqq1NsEQlI1p5SIGzV22lGRMUMT/r8jEIiAygFbqSpX7AHmh4HZu/sHXVwqSo4PMo
         Gu3e6CavGHa+KXnNBT5PtNgVOncbgT4VpgrwqQDwkk+L4Zvt1y7xebH0b3cM8SZyPEWt
         PCzFU2+708ot7QojHurW1jXPWH4dPRTvqOdEWQKxKMeE0jfiVYjxeicrvFYKNeKMbk9p
         0usw==
X-Forwarded-Encrypted: i=1; AJvYcCWD2Wo8QXQO9Y7JlXqMMBdpMKRyaJlEFVcSz9iAaG441pvGxaf63s8tjvFHL+CS0iBD2tVnbpMTWgVo@vger.kernel.org
X-Gm-Message-State: AOJu0YxP9YY2xsFUZxB1ToDXCyvOn4GE9XCc67ZK7osNo6j1B55jolim
	yW8TUi6uml+cReBahiehgHVi7ZNohtbHl/Ou3dDb/NRu1SMzIQ8GNWt28+sw1IXkEooxFQ+SPVJ
	3M06C28VgcFAjEDnie5eFpPo1jIlIyXQIFbJiKNw0UEO4E+bVz3KK
X-Gm-Gg: ASbGnctd2pBv8oVb+brDMP9nj2bosIarNcuNf7PCNnv05xz7E0S6Ou/crjdLNy5G6nG
	hcJpzOKzysf4xYYE2XOCmos/8MbDsk+ZJn7KKhXW2+Fk+YqDmYMPxjLbJ/xLJE7mM+ecjLSS7/h
	Bn9kW4zBVo3yyHLTnBprdnjG+MO9Alwj817CNcZtBltK9mi0+GxshZd+OrndHqo0K5JiJtGlTIu
	Z8s0xVoEw2nyxkVV0YeHoYjYfFBn9r1CLJT72+MJTbAmKYGpgwOSs2T+dmPniPVNOiqgRtyfnnF
	IJ6qTEqxubNIKsC+cdevuOkFtO9rEHhcckgTVZEn0wiqPZA64ZI8B4nOy2YnKt50sEbs+M2lBYz
	1iDau1wcq3K6K0BMLt2sr7xqMYnL9asyMJA==
X-Google-Smtp-Source: AGHT+IFjV6+RrH4+UnV8V5+50viki/aZYcrx5DBr5GFjR0CD6LtrULS5qzOc04+1tAG58NB1KrApAA==
X-Received: by 2002:a05:6a00:4b11:b0:749:93d:b098 with SMTP id d2e1a72fcca58-74af6fd7312mr21032262b3a.22.1751353869139;
        Tue, 01 Jul 2025 00:11:09 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af540a8f6sm11235597b3a.12.2025.07.01.00.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 00:11:08 -0700 (PDT)
From: Muneendra Kumar <muneendra.kumar@broadcom.com>
To: bgurney@redhat.com
Cc: axboe@kernel.dk,
	dick.kennedy@broadcom.com,
	hare@suse.de,
	hch@lst.de,
	james.smart@broadcom.com,
	jmeneghi@redhat.com,
	kbusch@kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	njavali@marvell.com,
	sagi@grimberg.me,
	muneendra737@gmail.com,
	Muneendra Kumar <muneendra.kumar@broadcom.com>
Subject: Re: [PATCHv7 0/6] nvme-fc: FPIN link integrity handling
Date: Mon, 30 Jun 2025 17:27:24 -0700
Message-Id: <20250701002724.1435361-1-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250624202020.42612-1-bgurney@redhat.com>
References: <20250624202020.42612-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"

Thanks for the patch .
We have tested this patch and this is working as designed.
This functionality is a crucial enhancement for Fibre Channel solutions.
This feature perpetuates the capabilities available in dm for NVMe in previous releases.
With this patch we have a solution for both SCSI and NVMe.

Tested-by: Muneendra Kumar <muneendra.kumar@broadcom.com>


Regards,
Muneendra.


-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.
