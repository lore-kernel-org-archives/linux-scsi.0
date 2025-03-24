Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEDA25FA31
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2025 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742826135; cv=none; b=m81kzstIu104tgJzOTVfm9xL8i8p3JS8djzWHsUkk/lOh/FrPFZHDChlWRrqHKbg7qOWTAILPVLfHDwk22/a12beinLtmm80Q714Ykmd14JPrECz88EvT66z6JVDe9+OovKoYSjhweB5rmOQJlC3X2U+xm+peQNS3aFV0lCHs4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742826135; c=relaxed/simple;
	bh=XFWMUSnVJUNmCPEAKRIac3YXhnxIgsiibFL7xQ4+Q2g=;
	h=Message-ID:Date:Content-Type:MIME-Version:to:from:subject; b=F2dsDB4Tz8A+P800kY2y8f1VMgizFjuRVAkBZ06P0rNx3BbPafddsmqhgM29V5M6/A21vDDCUD2nUpR664GBecCyuZx90G1/dnzokWoi1Bd5Cryf686FZQV92uPqsYaV4gUq6I+Seltk96TtoAHp95hwomOuNU+Dd3nwI8jw5L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=So+8Dd0z; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="So+8Dd0z"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2240b4de10eso11872995ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2025 07:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742826133; x=1743430933; darn=vger.kernel.org;
        h=priority:importance:subject:from:to:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XFWMUSnVJUNmCPEAKRIac3YXhnxIgsiibFL7xQ4+Q2g=;
        b=So+8Dd0zY4oG9DevA0wTuztFr/vADBdqDqpOACO8556AyLSaNDyHISjxrmAGy/Uhwe
         5BW5/A7XQoH3pVy++f2A76NywFoCTCR7PRHC1mm5eOygV70ruqWVFkdglOWFYjdVpHZ3
         +E5NnCha5XnzKfWXHCXdaGc50mCB14mpp67GQ9VVLEL0RBu4F+1HhbHeSybe8aAYjxgr
         wT0cwivVQwjBBO3nwIP3G2VUfUQMbE4Fsqv0lZuxpQFVLMPCQFsN+tbt0cjJDJ1lHY81
         SQYVQymaPmrgrT1iTNZgNSLM+Ze77A3I6XGwJF9pjFrhjyvPajqJbi1zUKCzOnhiiSlp
         pzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742826133; x=1743430933;
        h=priority:importance:subject:from:to:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XFWMUSnVJUNmCPEAKRIac3YXhnxIgsiibFL7xQ4+Q2g=;
        b=iFU6FA161q1hGP3GqpCK1lL4wSS8tG7A4HP2LlaJ6+9Fagcy/NL7MgvWNBscpZbbkr
         l4GDdEzZSar86NodwuA5TZaUL2whVmjrDr93ssP0NnWtiU5kMDWMoBGiJ53RA8T3KQya
         vIdpBCmwlpRRa5CPR2XEVzjdHy0YQTpZP2f5vhyjPi6s0VJZ6/IeemleRKfEyKBo0sb4
         iQT8+99TIzKhND7cU2hj1DH/bPplqjIOJJbxVML6oXorYEUemd7vmUVq+bZGzzUUsdVz
         n50acIq4h1E+Xhs0O2pz3vPpJ1l45xg5e3Cv7Vh+hPJcb1g6Lr7XrSm+ySWlFTC2qkET
         zOMw==
X-Gm-Message-State: AOJu0YyYkv8Ri0KQJPoiNq7Str5Z2EcZ0+Bv6AQvos6nqITVxht97KnR
	VhpxGnR0GE3+BQzsYfKLbHXMGwEWx3PmYgw4M70d6xQITSRGot1jL5p8I4UxY1c=
X-Gm-Gg: ASbGncsAXWRt3Bq9qlAIEpj5GQnXZ0DZNo3QTbRftM+PHe6/E+OV4IW4p2bM8ULMWxW
	YH0iHXSEPsO/fQsiqeJyrYEYs6a53UclQo74UnOrjw/0nIyBGfPi9SEvxM1unwpu57m+6jNc6kr
	Nil0v013dWBCrhNSyTGEzrh+2lUZr1oghodTSq/o2tTNpK3jfslhebwPPLzN4RDNK6pErw8gehj
	4EonRUxKdP7LBhyMPgGdhgy8Nvw51B1pyEeV9O8zwXZ/u1lWyNiCyZQRxkqvZ6Nyw7yL3b27dYG
	Knq2jg9YPNq4IG5oTu4Os/djRmrHAfy9N0y4tbPUf3J9FTOhPs7ooj6DhmtbcUlNyD7tGGA0kJc
	=
X-Google-Smtp-Source: AGHT+IFXmldxQ/FDjp1rNgCGhqVTOhKKOTE4myjWvT+erR9o7qzBQV8d6/EmRjb1S4usth5xam31bg==
X-Received: by 2002:a17:902:f641:b0:224:1212:7da1 with SMTP id d9443c01a7336-22780e172a0mr81138635ad.13.1742826132589;
        Mon, 24 Mar 2025 07:22:12 -0700 (PDT)
Received: from [172.22.17.136] ([43.133.63.133])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811b7fdesm71047435ad.143.2025.03.24.07.22.11
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 07:22:12 -0700 (PDT)
Message-ID: <67e16a94.170a0220.18d4d5.ddad@mx.google.com>
Date: Mon, 24 Mar 2025 07:22:12 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============3857348638799016520=="
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
to: Dear Customer <linux-scsi@vger.kernel.org>
from: Dear Customer <manweresilas@gmail.com>
subject: Shipment 631915101641508868 has been scanned in transit.
Importance: normal
Priority: normal
X-Mailer: NovaExpress X-Mailer [v2.3]
X-MimeOLE: X-MimeOLE QuantumMessenger [v2.5]

--===============3857348638799016520==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Subject: Successful Renewal of Your McAfee Subscription for 4 Year

Dear Dear Customer,

We are pleased to announce that the renewal of your McAfee subscription for the year 4 Year has been successfully processed. Thank you for your continued partnership with McAfee. Your loyalty means the world to us.

Renewal Details:

Product Code: FEM-14684800

Service/Product: Digital Firewall-ABC

Amount Due: USD319.10

Please note that the renewal fee of USD319.10 will be processed within 12 business hours and credited to your account. You will also see this charge reflected on your next billing cycle.

If you have any questions or need further assistance, our customer support team is available to assist you at 1 888-350-2394.

We are grateful to have you as part of the McAfee community!

Warm regards,
McAfee Inc.
(c) 2025 All rights reserved.
--===============3857348638799016520==--
