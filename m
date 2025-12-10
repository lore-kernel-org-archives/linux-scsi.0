Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F62623B62C
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 22:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765405265; cv=none; b=ZXhClA4n9hQfJD6Sq8SUneCKIVHk6BiUcW8RsIH0c1bJtcxFutJX/GJmn7/Qk2tOpZEsrCOwbOWxJY8lbD3A6ji3fHLkKgaskU2OkoZlKssmBPSWsnc6o5K/8LpNyAJ2LKFtlfb2VAfb8E+lEuOUboJvzyqnqVUBKw/En8YKgdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765405265; c=relaxed/simple;
	bh=A6Cd/0mb6FqIJxkiogpHaxlTvTu+oLt3gHlcrdodupY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kq5c8HBD4j12VuOZPdxyccKTsFVvHUWOUnpxKj8oMfXqkQX1XTpDdnNkJYP5tajrcU2NU3spdbpT33GwTWIoKbiYy2FcgyWDb/gGWeoMN8SlTat07T00Mj7I9x4hPko0ZSl/tphJRMvohQCZWsA78U4oRBLwNadKMiz9m6sDy6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IzZHfCVz; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzZHfCVz"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4779a637712so1958445e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 14:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765405262; x=1766010062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWXuaZ1LRLxZUJc92tOksdRhg+61kseDeN7K4X7i7OY=;
        b=IzZHfCVzTIuyLGx9aq0YJl5Xaq9FSYwhsZpXZMlr94ENbic8o9n1YWBttnWKf04/Is
         LCE5I+8rMTyl4r8PyUA9lPSA5JvqzTdqRVcuJ/7+0kg6dqCPWRf0m6+0i40hHfLee/5A
         WMbZPi6MksAgSj2Lg2bsjeeCYaFuY7X4dJcjQsYoasDbifLGtYbxXgn3Ya37HrzlESIu
         1X3sIt9GaL/381ec2nsihO4USNvKO6Ab05VRIy9RDAR7NkLfRRI9nh40tQhp+dTPBNSi
         IXsLf5N0yCFr9m4OGUmUcjf/8VDeuqJMV7nGd6xjCLMMbGRBDiHx4WRUdAUvB8bnlNa6
         jLKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765405262; x=1766010062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vWXuaZ1LRLxZUJc92tOksdRhg+61kseDeN7K4X7i7OY=;
        b=PctSPZ0aHJBkBr/icHYZrgK0yX6y7JtosTL+1vQO3+yBwC+IWcrbXrhA7jc+9wM3wj
         EORsXOhO7GUsShRFr1eXbT9HEPoG22l4hraVfLQLPVtL2el860TvgjKuOHJLjNdvwNCy
         EWr+L8FMsWHkS7ZpZ8+PvZ1p2PJzyr0kdHu7DU5sw5QPUIRd+cEft4VgpqPOpq7r0We6
         LZ/xB6TmIIuSa1kJzpW/5qs2XS/9P4eka9cs9zOqXaVdgof3+gH86MrySKqmHdE6NNtf
         tHYs1n7r79GK/UNzEM6tTL7AenZWSxNSrsHHWisLVBJJ+GNSlyki5dwmSCqSqpuHkB7a
         wxMw==
X-Forwarded-Encrypted: i=1; AJvYcCVdUgO9RPIah/AGYii3B4vhsB9ImFUyG86Ks2nUrNbF4QyybH3CjDJNIBJmldTnuqszTgJ3tE5CJ/rz@vger.kernel.org
X-Gm-Message-State: AOJu0YzsnXq01gyjHA8G7xoagfZUTxvauQxlAwfEtMHNKKBVQRzTK7e5
	75hslsDPV11KnSt3dWLRN4EMKprd5SL4KCftq9xyXYwk73yLBgp2n5WX
X-Gm-Gg: ASbGncvaN9bSbeK2JeetUplzivUNEqKDBCY+Yfsizst0/1yk6hTX6pRcQFdGEH2cNop
	5KXfaKhg6H7gyOsBHYG6Mxkqnl1/0J+cWyu5/HmSTJhcs7/Do3fLC5/jTl6yxIjj1eelXUD+Q+w
	fCvHXOEbYHAD8LWD6XjSJFc9gwGIlt05CYuHMAD9WT/6LXsDlQXnIPqsvpOCnfEUeKXDxb+e8UW
	lpDNKrH0bllQr9HZyjfWAyPAu4BpON8HKZq/toV4y5Aj7uirGJvLNd7jEGF71OWyFL02Mm3Pw8P
	JvPKwuDTNfa6jUsXu7m77vo8fLU/MrDrasmfCgLFZwatScn2/+W+lxK15wvXKt4Bn/4Hy+2GENz
	D9xd9nfuao/61p848kXx4f+kVBpma49mJxvUfPHV3Buo/ulaWZ1LhkxbcLYYM2dkBd3wa0MD+oz
	leQhna6d9gD/O0UHzpvk+33V7Z0CzDzkh9s4QmCHttbrktKZbEDDciHvG469OYpzw=
X-Google-Smtp-Source: AGHT+IHic6vH4FWDb5njZD5Zzyl2kUXfGUA79hbrjZCunAGnbv/i++EBIhjMX8oFl/EeSYeDc3sOfQ==
X-Received: by 2002:a05:600c:4585:b0:477:76cb:4812 with SMTP id 5b1f17b1804b1-47a835d23a6mr35313675e9.0.1765405262098;
        Wed, 10 Dec 2025 14:21:02 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a882064ccsm15830535e9.5.2025.12.10.14.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 14:21:01 -0800 (PST)
Date: Wed, 10 Dec 2025 22:21:00 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pmcraid: Replace cpu_to_be64 + le64_to_cpu with
 swab64
Message-ID: <20251210222100.66ac5c88@pumpkin>
In-Reply-To: <E269B89A-5111-4AB7-A875-92A3EA13B4E1@linux.dev>
References: <20251210143322.596158-1-thorsten.blum@linux.dev>
	<aTmOB6-uRMV4BT1H@infradead.org>
	<E269B89A-5111-4AB7-A875-92A3EA13B4E1@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 Dec 2025 16:39:36 +0100
Thorsten Blum <thorsten.blum@linux.dev> wrote:

> On 10. Dec 2025, at 16:13, Christoph Hellwig wrote:
> > On Wed, Dec 10, 2025 at 03:33:21PM +0100, Thorsten Blum wrote:  
> >> Replace cpu_to_be64(le64_to_cpu()) with swab64() to simplify
> >> pmcraid_prepare_cancel_cmd().  
> > 
> > How does this not break the __le64/__be64 annotation checking?  
> 
> I'm not sure and didn't investigate, but it compiles without warnings.
> 
> 

You'd need to run sparse.

	David
