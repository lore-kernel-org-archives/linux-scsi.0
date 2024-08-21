Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36F2199956;
	Wed, 21 Aug 2024 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724259663; cv=none; b=edJVtRRgr62Jhe9Kx1iZe1DQv7nYTqkFB+ZUcLZVpXLmnq3/CcmNTu4T0hvdGBxEciRlzWhQoOJOfiTPjq1bCv6nbIYsY7tAzL8IftxOQ+On0Vwlrbzks+3eqoDwBCqvXYFkf0VYN9Q+EJdz9AECfymg03KHK25S1xJwH4tEb2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724259663; c=relaxed/simple;
	bh=jUEZoOE+I/HL6qmkqpRxBAW840EWU6rM2MCD09k8aQI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n9B1iFdgThjVJDYXjE/3iPBsTNgGiPjy73PqeLvqINbSitYsRIQc2c+3AUT8MMot8P/5uTz1Gsx+3x5Vf3XKfTfXis1fZp/F9AaVW8Ca16vZviqudwU1D6GMoJhgazq1xNwdO2hoWw/xM86BNWezs89ySnp0wIfLmP0MfFI45sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tee2qmv4; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tee2qmv4"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e116a5c3922so6825097276.1;
        Wed, 21 Aug 2024 10:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724259661; x=1724864461; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jUEZoOE+I/HL6qmkqpRxBAW840EWU6rM2MCD09k8aQI=;
        b=Tee2qmv4xRv8zLQ06fEElSct/AcFDzU4PmEKFMcZQ4amFzCILCSpYIM03UwrGot7Qy
         yuZpcFBbNABctQO5uuoRBXqFhA7VetElb2MScRh3mj18OX3sdbiSefbfgn/QnX2R4Rvi
         scGCdoqdM4YM38RB5C1RoPQKO2TbIilB7w9dBYMJybWPnBrxcTAcr/DQ4I9WecdOUx0I
         cS542RWZ4ZJtkp18eINtYh3SxlAiebprsuQKIoOa80sChG+AcB2NsZHgkYR+UYg/qKU9
         yP6byuWq1DfUXweBD6BrVxvd3Y7kT8uC6CtEIHZc40oDfFnTXGm2IzLijRX5kHTGngJd
         odcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724259661; x=1724864461;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jUEZoOE+I/HL6qmkqpRxBAW840EWU6rM2MCD09k8aQI=;
        b=YF1LuXAIQrq40juqwgcUcBmuJpzqGAlPZoGNgOvU9AaUZdFBx/FzUuA6MujVzu6uXq
         yZoinXwmFuxFIHapNcXOBlCLXaP1otcfcuPFUQtVbtR4IRdxq0QZbWTFqIAr2UxnPBmo
         HXzBnVjafYJvwXmyTirBLH37hm4zL4DD3kJa16rKROFyjHfSv+YdwCulAHYghi4dy1th
         isVkk7fU9gZxpC4kMtD8Ovd1FL8T7+YP8vpjpkqIrL/gXJrNQtqrd9fmydldY6OSpxYq
         se1ePXKZEo0npf3tZJi36FqESaWSkShT5/RzuvTx7Ehq0lMXZgBFKMHgkfEeIWcBoz1M
         OZtw==
X-Forwarded-Encrypted: i=1; AJvYcCUoAge/m4EoWlUgsmz3DWarhl9TFOL++sW+7tlEJLoIVeNQmekpPCBMUasWga3qnPEFXadM+KQOF/MYkA==@vger.kernel.org, AJvYcCWrQy1M2Mdl+e/0ror6etdg2nxc/9/XYS9vqCPHIGYouAakTa5hZenruG2RKObjp3V4yLUxP7O7TKL0GdY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFGeuBgWF7rV1s8SCFvY7YBNq45F81M8hHOuulK3OLHAAeV7cm
	Y2tIfPq7uZLVYfkzMS6V2ZTMyFwi7GFO1+h/HSfxmbfdzZo/pDUndhpF1IU4ueXKA5ZzpvRKTZd
	opKgyBA6UdLvTBVRCTaNTw8ohBcg=
X-Google-Smtp-Source: AGHT+IHJtsVTdcWpB6K1lde36WYTbOIQqqa2SThwZxersF8oZwCQZO6hrNlfeyomgV75DZrsAyY/Ewvpvw7CPjD9Jg8=
X-Received: by 2002:a05:6902:1583:b0:e16:506a:343c with SMTP id
 3f1490d57ef6-e1665495d0dmr3829937276.30.1724259660665; Wed, 21 Aug 2024
 10:01:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240821065131.1180791-1-sherry.yang@oracle.com>
In-Reply-To: <20240821065131.1180791-1-sherry.yang@oracle.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Wed, 21 Aug 2024 10:00:49 -0700
Message-ID: <CABPRKS8f88W6nCiaTLKpfXcM+XfZ5TxE3cCxL7dDRHH2mFXRTQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: fix overflow build issue
To: Sherry Yang <sherry.yang@oracle.com>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Justin Tee <justin.tee@broadcom.com>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Thanks looks fine.

Regards,
Justin
