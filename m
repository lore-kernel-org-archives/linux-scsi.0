Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E00D16C6B0
	for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2024 16:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713977563; cv=none; b=nycSFocA8igTTDrC9vnTXVg9jQ2cFnby3eg1BLsye/nDyuqQmNYfZgbKiRr80VV4m9Ch7MUJjZDGiopL6C032IgdzgtKda58GDMU8S4XjVC3Dj+IKYDpxaKUk3ArPaf24gOYJ8a7YPmFxQDeSV6lhaanim3HDFhhhVDVSvrpito=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713977563; c=relaxed/simple;
	bh=kfefPbBv2p+596/zjC8TGqc/f+fUGhjZo9fBV6pyK+8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n6C4kBOy+A2sFebafjvAIaH6quzo9J6NfWgFTG3ptS9WAOSNunBRcEqSMai+uX/CTv7qMZO6WZTGQlAyss/9B3KtaVq+ESa/lM8xpO+UoBQEJ3SOJ7hnS0DexGM8zMPKMLd/wZSbn8ZXw/KbbbLrxtB79BXOSo6/7EsuIO16OJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KnuOnN1C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KnuOnN1C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713977560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kfefPbBv2p+596/zjC8TGqc/f+fUGhjZo9fBV6pyK+8=;
	b=KnuOnN1CPzc+DAS4I7f5ergwlFhB0hC0POYbAqHHx+p/v9b1d728UEsEGcK93t075H9w+x
	4fCB5GklUuHpYY1FmKcjQ7uAO54qP88Sl3rRA7iz/8euhI7Mvm6qoUfeyc/lCwSrWZ5tPD
	UsRpjCV1yiEROMkU2KVblE9BEGVk9uk=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-cexH2YziMgq4QR4gDbJMYw-1; Wed, 24 Apr 2024 12:52:38 -0400
X-MC-Unique: cexH2YziMgq4QR4gDbJMYw-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-de45d8ec875so154300276.3
        for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2024 09:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713977557; x=1714582357;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kfefPbBv2p+596/zjC8TGqc/f+fUGhjZo9fBV6pyK+8=;
        b=pE+KqCB5zxs//9vw1Xju8Dhc6RfxPLh93qhm2Mz30hKujc81XYuFDHgyEhOiua8XIg
         9ETeQ6R8ma856CC9ApOTO1SBitlFf7/++ZrlcqCTrrMZHYLOEKtj6lFi3gS9mBabZBw/
         /9Vh1aWseI/0cN/Y33UYoDqYHda4J73qCqMlzQKq9vTjNdjhhIBSpT9kizQdJU8m40n1
         /oIYH1N6Cf3t4hscSnWBf2R1m9Sav4limdd0EZvCSe2qOO6LMu40AqEwlfAJ3RqfDGXp
         95F+l2DW0SrNO0LS6IiFZ5qhAujCNBY7vXh1MsIi3USA/VbAKAqBGO2OuyiDTgKy7GA4
         /S7w==
X-Forwarded-Encrypted: i=1; AJvYcCWmW7srdGnIJv7528W/8UU8/HP2MVXOGzI8j7H55TJyURp05h/UFPM8EYmbxpFIbL2Lt4FKRW57YVCHzO1RgLuWOj11sGVKwRUrCw==
X-Gm-Message-State: AOJu0YwEIZxKWuRmqgcEdVWpHxY8rWJyG7afF5cY1ggrxmThIneW5n/F
	sUEzfVtVH1axgsc5F4+CKZyTUa0ToBE+5y7McZ8MAWtjXkT+ZHSsiNqvz+T2rTj1kcv2kf1o481
	pt1y9WF3Sz7e8KbFpto9byton8yjmCPry3xrPgMDAP6kC6eSDTGccsvwzg2DpzZNqfXk=
X-Received: by 2002:a25:69d4:0:b0:de4:6ef8:2778 with SMTP id e203-20020a2569d4000000b00de46ef82778mr3182307ybc.29.1713977556975;
        Wed, 24 Apr 2024 09:52:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxxIJ5pNf/rQZSNEQ6WCD/GhFmiR9OawjAA1kjrn2J9KGe/4EQ9u03lJmHfHkW3TQA4A0wsQ==
X-Received: by 2002:a25:69d4:0:b0:de4:6ef8:2778 with SMTP id e203-20020a2569d4000000b00de46ef82778mr3182292ybc.29.1713977556646;
        Wed, 24 Apr 2024 09:52:36 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a? ([2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a])
        by smtp.gmail.com with ESMTPSA id 185-20020a250bc2000000b00dc74d5e3ff7sm3206694ybl.31.2024.04.24.09.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 09:52:36 -0700 (PDT)
Message-ID: <134b44cec24e0480f8df4e9bc0f0c1e28df24887.camel@redhat.com>
Subject: Re: unsafe shutdown during system restart
From: Laurence Oberman <loberman@redhat.com>
To: Winston Wen <wentao@uniontech.com>, linux-scsi@vger.kernel.org
Date: Wed, 24 Apr 2024 12:52:35 -0400
In-Reply-To: <482E2895A2BA14A6+20240424154718.47b5976d@winn-pc>
References: <482E2895A2BA14A6+20240424154718.47b5976d@winn-pc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-04-24 at 15:47 +0800, Winston Wen wrote:
> Hi,
>=20
> I noticed that my hard drive had an unsafe shutdown during system
> restart. I have done some related research and found that a stop
> command will be sent to the hard drive during system shutdown, but
> not during system restart.=20
>=20
> Is there a way to avoid the unsafe shutdown? Or is it the
> responsibility of the firmware to send the stop command to the hard
> drive before shutdown?=20
>=20
> And why doesn't the kernel send the stop command in system restart? I
> am indeed curious about it, and I would greatly appreciate it if
> anyone
> could help me clarify it. :)
>=20
> Thanks!
>=20
Which Distro are you using, where you are seeing this.
And what is the kernel version.

Regards
Laurence

