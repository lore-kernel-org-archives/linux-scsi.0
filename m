Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EE4DDDC;
	Tue, 31 Dec 2024 01:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735607178; cv=none; b=AguXhYqBwYhkyhHGuZQciOZliNViY4hF7RaWFnZWjKUucQGbjayJW0cHFakhPMDeHuXt2j3VvlpMcy1ygMazlfjNH24h2zlk6uoz7v0iwGi2QMhz+9EuNNbjm7Pm1wngkW4JcvDaA4GH7A8bh6ibblaNqBZRcioJtRrJ+3RrQhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735607178; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r0YnW7g+iD8lUx9IkWui74qnG1y4YPl8iS8rrrRsw9gAFHburILEA3sxRP+EAykWXKTQIntqyzpqUoh2R7YQsJ3owmrGhTrXMPzoraL1kGt7Q9ZfGz9AxtDdIgtGZe5bAFvvZcMHWrDMgVMYOc6e3pJQE09utE925O7ya8XXFlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YjKFOAsT; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YjKFOAsT"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e5390ed85a1so11237877276.1;
        Mon, 30 Dec 2024 17:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735607176; x=1736211976; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=YjKFOAsThpjwgEtiW3Qg5tjMCXaEaJPDMacmAuQLBWAPjCDEtjuDIpGgjpQ3TKrVax
         XzaCjeFRufL8qC+5jwvdVJ4Ahe8mG8otZvnbUaiY5G5IwB0rxC/xCNHXJN6+gootL4fN
         7FD5ocP6aFDji+Q+EEs1QIwDDCeyvPHBzcFYHe3Skgaf8b5RxvH/HeHYV9FI7ukVdsEI
         2y8zZ4YcSiyDITW4mnsfCOUMcw6BNJxl/BKpgfAq53tvxDTeXsQ7kPXm3j9dy7w/+l+o
         LpCdsUrv99nWzxAIwCSi7HrqOFohsJjAVmCwTJCfbwiFz54ynpj00XMWYt1PZJsR1E0s
         QACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735607176; x=1736211976;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=DZTinmIDsuK7ZMnQmkwi76nkCwpDYO7CkP5CLJp+ssgwFVQbCUPjqlJ48ecFviGwoj
         33osJ1VuZqoPmZqiZA6+lYM986WpVFTg+xLuosgeaGeK+mbdgG/HshR8LaJDwvnsD4Ez
         T3jwqHUrH3Ghc5YHATHIopjKnPxPdQ5cTP7k+SYIXfQmWt3FBnddNrn1w/ieOy20lwCl
         GMBaWGeqbRKGtYA7kryYNxq8glDLXwsXd2XUU5AcCNpARY/s7b56QllGF/jZYj1IttxP
         FXxSKg0b4nr3IJVm8MTcg5+vF6JXcBglcjqfo3e/coefcprCYXWsp0gGyRgt1V13WD2o
         /Y5w==
X-Forwarded-Encrypted: i=1; AJvYcCVnQDDamB6iLTho+y7JkpfyNMId5ahpBbh4lH1CG4R6adkYumM3761mUFkKAp3j+HSnusQlpYYlQhBEN1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6nXSTsWeS+WI+iKqF2T0RUuQT7TWGTY9iqqw7+obBRugAoC9h
	Djv0Whc06mEzJCf1C5Smh/IxEetBXXPJ7BX1k2KjQ8Fbr9Nczc9YcqJS94E+mi0mmMZ/9YPQ/Sf
	hmpao7Q+3kedDRonidzpegL3nOyc=
X-Gm-Gg: ASbGncsCsbPat7uuXQWhh9HQUVOZVWLHYoIpKTYso49t08V57o/nAhuwQCwd53HQBzv
	MQ4hofHLDsik099r7EP4d0Zymr6siF75FszCdtes=
X-Google-Smtp-Source: AGHT+IHUP6cOIKVBNeNt22rnav/uA8Mp6Kk2tOz/RmjsVJH/9xSqA/+XkQvP00CORMMgwzmuk1FJndCBRV+Wi/vc3bo=
X-Received: by 2002:a05:690c:4b93:b0:6e9:e097:718c with SMTP id
 00721157ae682-6f3f80de76bmr288646807b3.6.1735607176506; Mon, 30 Dec 2024
 17:06:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241228184949.31582-1-yury.norov@gmail.com> <20241228184949.31582-13-yury.norov@gmail.com>
In-Reply-To: <20241228184949.31582-13-yury.norov@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 30 Dec 2024 17:06:01 -0800
Message-ID: <CABPRKS95e_3bh3wXMoV4AUf+qJqKNS0udSWpGjBN6=_d+9ZwUg@mail.gmail.com>
Subject: Re: [PATCH 12/14] scsi: lpfc: rework lpfc_next_{online,present}_cpu()
To: Yury Norov <yury.norov@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Justin Tee <justin.tee@broadcom.com>, James Smart <james.smart@broadcom.com>, 
	Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
