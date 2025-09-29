Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C93221FC7
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 17:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759167863; cv=none; b=CMD2QKWPxH0qAwOg5TtIOEXXiuE4rFtH6gNpA6RNhUGwZDLZvdkk52Qfi6Xqatnchm0Vcwp1dKOBeit0tBtJ1xkjHLLLsKr1V9rND5fcwliHZCdNvTy2g/f+uXfNo9Ub5ZxkZwKMweo0pvwe1MYpN1vAvEpjcwnY+ripUWoNmBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759167863; c=relaxed/simple;
	bh=Y25ZPS+yMiAHIHwXXqVuK1iZBdEUXnZ+cLLht36dkfE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e8egwXtyGtSOEMom+SXnAPlIqyTIpwB2EDiE2uL4udZpYgWIpN1E3Bk5SkJxxPlwo341j1Uk/by4E8a7esISEKgxpOxQAFKhqwaRgEOphuxQ30+j27mvnVEUWg7DlosKEbsCedz45Wn8AaHPxHauVyTvI6lwsqTj26T6Ej9qu6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LyAnmDH4; arc=none smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LyAnmDH4"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-63470a6f339so4585768d50.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 10:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759167861; x=1759772661; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2iq1xGli16J7nUmjOGkf2lv1qlOI+tiFZeMK2lYQ+jc=;
        b=LyAnmDH4PsqwIKECCFvpG90yHs6wVmkeO/PeABLjKFiXxJ4+fQatoHg9NM2rcIuhcm
         pPKI2aeIQH+lxP6DeXNfryrJxewFqHbFb+Mc8ah5m/k27nBU1sNx2F7stEqgWk/SXURL
         y3uJNAw/CZTLHx4MmWKbXU1Tb2MaTbYLEDb51SpliA862LcvNZLgjMXGKIyWRE0uqbNF
         C+QXoK23KkXP1gOD2mRu2m1AYR/Oru42j3pqEPDSLcBxhDnMUuU5ffFDgW/CvKxpqMee
         fB7DtDgbOXXzkObwsDzmtFkmxaXpoZ7Y0aiMQbCW9vD9QxpSN74Sb7iJ8M9Pd1v+gey/
         llkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759167861; x=1759772661;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2iq1xGli16J7nUmjOGkf2lv1qlOI+tiFZeMK2lYQ+jc=;
        b=mayPWejIBBe0FAoihpnnEvon8br1p/wvi/DbFMep9UtJwKCeQ8ibJmEJK5rDAxp5Us
         T9mQ7B8T+jtRM7DoYtNcI6dSmdhmDhqUlDncoLsrzVYeTH+TZxti5LtkZUr9nDTzH5TM
         poGP6xVxM0P0gm4b1fB6KBtIV4QfO2O3A/MS6qcpAvzjTvYFmB2U9hp8DZ9br/U509w0
         3xM20JrGJahdy025u2zL4/n2A39WeqmsVgHFEU70o7SlYJTQUeFVlNvZv/NB2dxkceUR
         5uRDQki7FbGVKM7iDmsic0JswUrW6UH7Librv5r9lYJshyPL1qVRET4Hfdz5KHriuYhY
         ocdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkkDkklIelPc3groUwLvIh6yV+m1vw1TRK/9e+u5DsAAoHxe/G5F7yE/mdPNCVB1HM+cSvpzuD4WV/@vger.kernel.org
X-Gm-Message-State: AOJu0YzG4C64Xp8XQ60RjtYSNlA2aaq9PghCtE8KpXWSALg0bJ0oPN9c
	6z+YR+8ixGpGkvIoBtYXM35xpZHGvZ9y5ivvvzWo1s/qX4Axj/3oUvbYbGlibboX8T1e+KbFBgH
	rE6ImJBRSUlgLbiz+b2AqN7QN8Ixqppo=
X-Gm-Gg: ASbGnctej5E4i8ndERGhx+JhUdNCpyQGpqqwlHIzVWHpemikkPQAjdY6fdjx8rX4IaP
	Ixb+7VMj6nvsieakpkE6jZYG3Z2PCh0bCzAyRLrcCErvaFyUrl1JFHW8oXjpjXWvZWatJL2B7Kx
	A5L/S6OvFZDax82cs2wr89AH3Q+mmRONdeR1rgwJ7xd4ReWlTg/Psp7MfTvZLwEiejuLjXNDwTm
	h0UBpuY
X-Google-Smtp-Source: AGHT+IHD+fud1cqNFyL89ZYpolBKRgySAYj8na2dCzjfyjGhO2C4PNGwPCYLf3yuYC3SlrkRYNBF+8yYs1tNJabNujg=
X-Received: by 2002:a05:690e:1548:20b0:639:2794:341e with SMTP id
 956f58d0204a3-639279435b7mr4583288d50.3.1759167861254; Mon, 29 Sep 2025
 10:44:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926000200.837025-1-jmeneghi@redhat.com> <20250926000200.837025-2-jmeneghi@redhat.com>
In-Reply-To: <20250926000200.837025-2-jmeneghi@redhat.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 29 Sep 2025 10:44:06 -0700
X-Gm-Features: AS18NWBdrQ2OubyJNBy1xJM3AAOOxCFmeRS_MY6SKBbtmZUo0BgYs_yjSiVtfKo
Message-ID: <CABPRKS_AOnXmG7NAfgsEKLx2Er_WBcR48wCZwxbKLXnv7FPCZQ@mail.gmail.com>
Subject: Re: [PATCH v10 01/11] fc_els: use 'union fc_tlv_desc'
To: John Meneghini <jmeneghi@redhat.com>
Cc: hare@suse.de, kbusch@kernel.org, martin.petersen@oracle.com, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	bgurney@redhat.com, axboe@kernel.dk, emilne@redhat.com, gustavoars@kernel.org, 
	hch@lst.de, james.smart@broadcom.com, Justin Tee <justin.tee@broadcom.com>, 
	kees@kernel.org, linux-hardening@vger.kernel.org, njavali@marvell.com, 
	sagi@grimberg.me
Content-Type: text/plain; charset="UTF-8"

Hi John,

Which branch is this patch based on?  include/uapi/scsi/fc/fc_els.h
does not apply cleanly on 6.18/scsi-queue.

Presumably, is this patch based on a branch without?
44b6169ada7f scsi: fc: Avoid -Wflex-array-member-not-at-end warnings

Regards,
Justin
