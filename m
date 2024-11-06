Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB57E1DA0ED
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 09:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730884197; cv=none; b=k1Iyp0dOFwlwdtyxPGXpKGU+DEHPOSmVgL9IGicYVZp6JeOlulPohINxylPAgUDHf9UWLOq6aN/+fZHxZqhK87n/RgHvPuVE5NrP16j9EPtZT7+hset6CE9RudHJKyfDexW4fJx19vemHiofjx4dWPItoSyKytOUTFdB+YFWN+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730884197; c=relaxed/simple;
	bh=Ve3ngN2EEXHIJllVwR94QiODyXjYWDIRJ59WcErDYVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LisVN2cS8GvHYkkbLmgGHoo7L/FcN7ZV8Y6A8icqa1LlKwtLMFp4onImNunPeWav1jQr3Nuz0nyLdBAyt1JG6KHxdKPcTFiyUcvaQXw9ZZ3JwZptk96LQ8R/OLrgrTFOJxGggT89U8u4iYPqq9CXrPN/9QM6UaaQFwA8OYIbnhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fE8/hyhv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fE8/hyhv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730884194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGIM5USzAXYsKg5z2NxV6SvyDptl8f4iMkBBwNNtWVo=;
	b=fE8/hyhvWINz/39yJUsDfPymP7kSWQrtDTTyS6toBpVF4TjfRuUg+RK6ZpbtgkSPOfMlEw
	c5c4VuEo4XqTiU/ScgNlyRIwG7gnrf86cLYOd6L/LGEtWaqQ08ZjDJiYvPyKUQ8iEbce0s
	cx63IKTbk/w1AVTuZNbN1xp8ekRT5P0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-TZo-3XbQNZyshBuB8M6dGQ-1; Wed, 06 Nov 2024 04:09:52 -0500
X-MC-Unique: TZo-3XbQNZyshBuB8M6dGQ-1
X-Mimecast-MFC-AGG-ID: TZo-3XbQNZyshBuB8M6dGQ
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6d3736a62b0so54186696d6.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2024 01:09:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730884192; x=1731488992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGIM5USzAXYsKg5z2NxV6SvyDptl8f4iMkBBwNNtWVo=;
        b=R+1ZBnXorZo28tDc0A42FPTnN9mrK2YGt5tnsAx9MEzPq8UufdCMcGRCJtiipGexOG
         eCgAUSC/vcLd7Mwx7dgRa9TCY7fs0bfZQoGMoMQMXiwXi2nvHXr4p5axYL9ZR2FtEse2
         13jNsypMIwVXQJY1jZ+p4/BGtSzNzq5/S+nS/t/hVS0sN6zs7iAgSVrLaKF86Y4ASwP5
         qoSEsy/AaBcYx5/0CB5BOBE4xYnrAPQ1BB8oNKyTMeKzDo/qAD4Nu0Oz+igYORKg0Z8A
         IAEu7HWP/Nq2NibMKppW5RRyluHlT1RXV02tWisn1A1Dln2vlL8/K0LB4RorlILl//BV
         bx4g==
X-Forwarded-Encrypted: i=1; AJvYcCWhgTuGvz5WcJWYWewv0x4kqvoBpkTuasEiRCWby7NV9CF6N9KX8NEwQPCFWQbb6/QgazTkkJCcvcwt@vger.kernel.org
X-Gm-Message-State: AOJu0YyWrhNPNGGMKUTzkU3xDlQwl5zO9vr0SGkfSFD8iYafmj1tZdO8
	4TtKL5puS4Q1Tyz20p4V0gycGAiukr9cbWZctlqUKMTOLi6mLrD2rEC8feyx3znegvWJXrMEjmk
	97aqdErritat4P3gJ94qGe5TzF/iPzmoa2uaOVrygBVziz6gQu7KlbrzrziY9tz4CKm3H0jEjev
	FMJi73b+HojjMcjn5UwsXqATQEwq9aJrwQ/Q==
X-Received: by 2002:a05:6214:2c0f:b0:6d3:71ab:adb9 with SMTP id 6a1803df08f44-6d371abc487mr181888956d6.45.1730884191746;
        Wed, 06 Nov 2024 01:09:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGLsFkorkkGw4mojt664zWvWPLr3Scpo66osjjuJqG5oZ4qhtX+rowBC3sywsaK62RI3BDLKaQTGDUzR5Jf7D0=
X-Received: by 2002:a05:6214:2c0f:b0:6d3:71ab:adb9 with SMTP id
 6a1803df08f44-6d371abc487mr181888866d6.45.1730884191530; Wed, 06 Nov 2024
 01:09:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <672ad9a8.050a0220.2a847.1aac.GAE@google.com>
In-Reply-To: <672ad9a8.050a0220.2a847.1aac.GAE@google.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 6 Nov 2024 17:09:40 +0800
Message-ID: <CAFj5m9LSOvbaOdM8Gvgt8HVprB_DAxiFDOW3Qou8bfAtEz_e8g@mail.gmail.com>
Subject: Re: [syzbot] [usb?] [scsi?] WARNING: bad unlock balance in sd_revalidate_disk
To: syzbot <syzbot+331e232a5d7a69fa7c81@syzkaller.appspotmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, 
	martin.petersen@oracle.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 10:51=E2=80=AFAM syzbot
<syzbot+331e232a5d7a69fa7c81@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    c88416ba074a Add linux-next specific files for 20241101
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1051f55f98000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D704b6be2ac2f2=
05f
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D331e232a5d7a69f=
a7c81
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Deb=
ian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D16952b40580=
000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/760a8c88d0c3/dis=
k-c88416ba.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/46e4b0a851a2/vmlinu=
x-c88416ba.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/428e2c784b75/b=
zImage-c88416ba.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+331e232a5d7a69fa7c81@syzkaller.appspotmail.com

#syz test: https://github.com/ming1/linux.git for-next

