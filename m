Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994743451DA
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2026 11:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784633839; cv=pass; b=k77ymxo51gJZbbj1q7lOM5P/kYsz9omPziPIJaaYVULA+tSOpSGJotsXhvqiboyp7HuPZch1dAYAXrX1Nr/ns58IGaNCcvfh1bweF7jy78B4ECQP+9joL4de8wt5ZBgwIuPV0LW7i1N0kEOQRXWYZ7xvlTT6Dzj9/7QgR0aL/Rw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784633839; c=relaxed/simple;
	bh=lBcKgBxSWnfFvfiMysODseyQOg5HkytACdv/kzIK08c=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=q6Lc6/09KuUmCx4cANJX80FLhn9PGsj1mynFr/H774w0JWihfxRm3rAmh6e0myMBkTxd7DyMJ3Atv1SFu/pVFJ9Kb186eDssbBx8V4SLXDPj+tRbCRberD9VNTi5P0v4cj78VT3RBN/3V/vrbu2G2FKaMhar8iwb0iiLP5HJLYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YIQXVDAN; arc=pass smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YIQXVDAN"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-4518ad44e83so4630797fac.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2026 04:37:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784633837; cv=none;
        d=google.com; s=arc-20260327;
        b=WPXt+4NE4VtwrQvNPUGcDD4P5yztWaXG4jkGm/2sFCn0EOAbK1BC854/XjCoFW1bGj
         u+idq351PCLQ+s/Pnic2cZKzbyFBXOosRGkfJBh0WPZr+818x6yvmXyfKsODAgnqbfE3
         kJrBMcQFP+OT+nSSn2wTt9Z635atDr1nBXufhV1gts/z2VlmWu87FdUf6WYt1O4zU01U
         DEUnv/BfpeLpM2ohTxT/SXhfS5wR6hUxfVAq+yG2vv+MeRu4Xex4PNKgoHyfO1NxNVNB
         XHV15pW8k/rqranFHCsbGYuMs8AZi7K1WNpYO1RYDMjhticIHTnmu8rBzeXBFqOg4dqq
         Cmvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=qYAxDd9JhohR/9LpJNEsTJFe3OpNdykTE4pA6WIfRnk=;
        fh=CYaGzFR+FVGTkVydV5GqUmSlVKiAlwaGoNniV5AVsw4=;
        b=f7AapPCeg75SSXiwyU9ogVGDl9gJUjxONZNLrpMO6hGAjA5rxjtf2m3DhquAfqjlRm
         U9XYoS+2nv/oz8Sii5FqkoeFcd6ODVAPuQeIiHJvjkpwK/whB4nn2k33L68Wf8QTo18E
         HlMXro6gy+fWeNfkk+ZieOqaAIS5X/F8lVztm0KQdZy9iWyFqp/Xv49fKXh7gFJy17m/
         r8s9GsVNsq9Ak7nqWJr427yOOptoZTPlH48/D9uVAS/oWakzjZW/1q9A7ywVwPF2ntUD
         dVMihdbbv70owhUeKrZKycb8gXszCTYWxLGHVx4npEZF9c2tIAtAYvz0mbDyO3aH8ISc
         6A2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784633837; x=1785238637; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qYAxDd9JhohR/9LpJNEsTJFe3OpNdykTE4pA6WIfRnk=;
        b=YIQXVDAN/7NCWwrTzcDdKKZ+G/t+R9Jr3oNc7BQVVuehTtIdTm/c9jTFDNNVRvQO9Z
         VVH3vylmDoL4BtE0IyGTRu0CvNL4fQe8nx6fviir6ixivjLKCw/iKfyDGO1LA7in/O9q
         UFhyWbLy//ym94tX0AINUOOPihxR8HEqADG5RN5r0o8Pi6DR8Lf9+/2jDBKH5o11K/P6
         yFKu7GkAforFW/wSzAUs3uTUTHCEoH+vWpdylGdkKr8WIZ2ZTCQ7SQQJJxU6VvDb6AQ3
         0XA+xCCoQotko2XIc1mXvLMGty0M1fZL6u/5wrFtAnMdBilj2PCurPWguq7Z1mgF/f5e
         1Ecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784633837; x=1785238637;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qYAxDd9JhohR/9LpJNEsTJFe3OpNdykTE4pA6WIfRnk=;
        b=fPe/S9+pzudOJzVt1eeADXxjLTOv+n5pQzqAINJTUoM4F507bnozHmctax85EwH0rD
         MM0yagwLxitt9qPWU7viPfwyOczw0LfHx57mZghOLomngerOdbVf0C9k3mE/kySndjbd
         zo7EvYFpTun4JhqJ0K2n2j0c+5bn+Bil6fhtVp7cEm7e8FcZTN0MD3oMH8eEE2dZES+l
         0LZsJtk9lnHi6+oyx7YBjMqsOsgCFB5jYta1MsLE9OG+BzAsSivIci9K1t7H5HCqxZP/
         5viw3ft7zO9o0gMubfvWEIpQH36CG2uQycotKrAdDcU1ZbtU0gMYjN2iyjCSfsYgz2ql
         1l1g==
X-Gm-Message-State: AOJu0YxrS1P5CmFVNtMUZ6xhEhwrWf5gKeVeju8tHTgLerWzJBn/ywXo
	FQC/dh0TDt7N80/O3ugBfctPpVraNzazzjcpvBQGeE4XpAPF1nPCSyDGDvOg5nbJPhbEZzWx4tf
	KAP37wlvsvz9oJdw87+cPUJri/YJr80Y=
X-Gm-Gg: AfdE7cnVQP0bdQJC0StMA36G1J+yL8Dj5CHDFOTyDSb/UTZIiLJKTFagb8U7/9ZK6xO
	OJevxDvMGZdg8EHK2cA0WfUgWDDqG/iO0qlIFKv/Mzp+TcBVj786Wvgx7jyS8igFOi6QqTHy6LL
	uFb6IgqWQgzOENhoAVD0uu4BTWVt+0VOAyuhP9WnVQ/xOGcJ9d0pSE6VmBCdOf9yblvt/T2EUd0
	R1o0rKylvGGDbWkd+0zU2rt6iC/PtmH6cZko/qua/xxo7/2l3ur4JA3ab/YPqfADLLUo0h+p3at
	YNloAml43M0hBeSaEg==
X-Received: by 2002:a05:6870:7889:b0:448:7192:b26c with SMTP id
 586e51a60fabf-4569037b1e2mr9805295fac.27.1784633837369; Tue, 21 Jul 2026
 04:37:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Brian Roberson <broberso@gmail.com>
Date: Tue, 21 Jul 2026 07:37:04 -0400
X-Gm-Features: AUfX_mwX9t5t0S3gkzXI2TcEi8PszBwUDLIqBVGCknr1owDy6uz2oGbYUB034fM
Message-ID: <CANsF+j3_GB_Z_BdUa3hFFN_u+AiTMbHhM=vj94xqUHa0-PC+pw@mail.gmail.com>
Subject: Regression: mpt3sas SAS3216 (9305-16e) fails after kernel update
 (works on previous kernel)
To: martin.petersen@oracle.com, sathya.prakash@broadcom.com, 
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I would like to report what appears to be a regression affecting the
mpt3sas driver with a Broadcom/LSI SAS3216 (9305-16e) controller.

Hardware
--------
Controller: Broadcom/LSI SAS9305-16e (SAS3216)
Firmware: 16.00.12.00 (latest available)
Motherboard: ASRock B850M-C
CPU: AMD Ryzen 5 7500F (or 7500X if applicable)

Software
--------
Working:
  Unraid 7.3.0
  Linux kernel: <working kernel version>

Failing:
  Unraid 7.3.1
  Linux kernel: <failing kernel version>

Symptoms
--------
- Controller initializes but later reports <brief summary>.
- Attached drives become unavailable / I/O errors occur.
- Reverting to the previous kernel immediately restores normal operation.
- Updating the HBA firmware did not change the behavior.

Attached are relevant dmesg excerpts showing the failure.

If there is additional information or debugging that would be helpful,
I'd be happy to provide it.

Thank you,
Brian
