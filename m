Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A567034677D
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 17:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768585721; cv=none; b=UWUOtvGScKA3rLISzBTg5t7XzoQcyyvWudL+wzPv55DQdLQkT3uxmUJhzll5uy566RndbzV7sRCVl3bD7qLv7sV7p7QeeM8XX9UpmxGYZEJ7cLrG6UNlfQUgDGEhdjQRSDZ+wh5tAcDrgVU7rIU50d3LccyKbhE6VTQLCh8hrdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768585721; c=relaxed/simple;
	bh=/6u/jxUE09UwI7rUlzQkEsyvBI77MuYC+E7W1082utI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nC3O9a+YotwQmc/4d+7PlZvwuWSRQgAJ+LYaswCymvwIpbAwzTGACtvgY0pVNvHDLkoF+R4NP7+yx+ySgJIivBsW0eGh3pRP+Ig8Yuz0Q1V8fn1gQ28UtvM+2hxH5Lgb/b7ug8kjZfAtM2cQNXnj6lChWvHsgHajWGxh9NmcbNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RpfS4HQm; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RpfS4HQm"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5029aa94f28so15507871cf.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 09:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768585705; x=1769190505; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6u/jxUE09UwI7rUlzQkEsyvBI77MuYC+E7W1082utI=;
        b=RpfS4HQmxQIuLAjWYBLAjkJv0zfU1J9Fu5fKSe1yqAdFMkcidk7fvPjsWXdITeWsjo
         jNO8t8Z2ADlZFT2JtMIZKlqk3UnjeiOSvrGPb5iUVed/ua4HiiFj9t/fx6cZwzTguw6a
         R0uAI2wwG3QO1Bq8wpvbJco3NBeDs0jki6eCpLNZXrrM4Gg50IoiFMiYTD1AZxGPNGdQ
         9ZDFge/46t2oxqafL6cNkTTJwhcrLZfshFMhQ9FHtl0LClZomRJQF/tEWxpboshQRoAH
         Pk6D0vOEvY0Y63b7pifAXeQAehJpitEYRKMlukOkvAp/TNsTXJ6yndCMDYJMSCPLpoTU
         N3/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768585705; x=1769190505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/6u/jxUE09UwI7rUlzQkEsyvBI77MuYC+E7W1082utI=;
        b=vplsl7iczS9WfGhGsmyrfweMtIM/ouLGMhBdZoPedFFKY+zhyTIt1I5HeXf35DFx1G
         Z0M5S17/xn9nCQ4NOKYcL8yq/UNSU9BFeS8NQTZc3s9dAam/j1VlE7J9ManMSQHoGdGm
         JhIeeUyqDY50GuFEerLhZb/fdPklwzDc/tQ3Gt7mAzvGGow3oKxwwBKhwbbrduIfmNwD
         jVDOHawoa9k4Wh/VNxqvOFTw7NrDdlWm5bcWh80KCRqLcyy3zfXeyra70/V/123bTMvF
         Yy004qA2KdpEj8L5MO29udxXu+y+XORYCqSkuVPe+heXSsHSrk4H0/DYRTsGDG6TLdhq
         0C7g==
X-Forwarded-Encrypted: i=1; AJvYcCUDsYsuQYFP4kGsANSUAkqvU/9st8pcwQXUHjkg/iZgD+UYBqEm+dUBEQkoVHC8vypWIHc4pqaEQZG4@vger.kernel.org
X-Gm-Message-State: AOJu0YyRBjVy0NoWi+MIbqM2U0k0f1IcyIZGl+a1Vjog8apISgi8Dy26
	M8KVSl5kpn7K1YpExuCMQczl0oGi0wwMenLBbqHG6rCcI4mRGiUUR7iojN9dHBzfmc6g09sfpyx
	lvDKWXyD2bODd9gq4U4mB/15Kogt+O68=
X-Gm-Gg: AY/fxX6t5+h6r5mwJJX3zu0fUSaP5hlSzeq45+sDMkFaRsNXMSmjjdPQeMv7aVFN8V1
	qAf90MBS7SebPFuc9fDd4xbjg7R5fUMaj/R/FIMrBG79xFKiTVp4OLhTsWkAsDYXLyNlGqzBCkA
	mqHphOeUkrRuxpiCjy8Av6+W1LjYqMIBbbPVBhS5M39aLLHQNkjjrrKAakDOZtOBI4obhi1LKxo
	mGlXIng9HJtj/udL/ZIr9I7uoOtqiFNEQSZgCGKqSCL6bUjwAw+5AnAZs2/2WyghJvq+qdH
X-Received: by 2002:a05:622a:1309:b0:4ed:a6b0:5c14 with SMTP id
 d75a77b69052e-5019f8e3937mr98351331cf.23.1768585705410; Fri, 16 Jan 2026
 09:48:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113222716.2454544-1-minipli@grsecurity.net>
In-Reply-To: <20260113222716.2454544-1-minipli@grsecurity.net>
From: Justin Tee <justintee8345@gmail.com>
Date: Fri, 16 Jan 2026 09:46:46 -0800
X-Gm-Features: AZwV_QjxtgtW5nCVrRxO84eNCps09QeR_9ohNRpvTbe_EpxaEfTiiRgvBkM1Bwo
Message-ID: <CABPRKS89zwXdUT1Bhj37cQDyOHNupOJ-Ez6kS7Dp_pu06X9Myw@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Properly set WC for DPP mapping
To: Mathias Krause <minipli@grsecurity.net>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>, 
	linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mathias,

> I don't have any hardware to test this on. I just got the report from a
> customer of ours regarding the CONFIG_DEBUG_VIRTUAL BUG_ON(). As I don't
> have any spec for the hardware either, I assumed a few things, like:
> 1/ DPP regions are only supported on SIL4 devices.
> 2/ DPP may be shared with other registers (doorbells?) in the same BAR.

Sure, we=E2=80=99ll have close look at this patch and test on real hardware=
.
Will report back on our findings.

Thanks,
Justin
