Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EE84ADDB1
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jun 2026 21:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780522876; cv=pass; b=a4ykV2NblsTYxobnHqSJ9e5xI5dQv5uBhmc9i73ui931SxSK1pNC2t3JVYqiFcXxw6vj+Zgh/v/+vMfJyKHSH8n5Yv4XLrrcTqy8nurqUBwRjRnZquLvvsdzlZTf+fS/uJrvQK7V7jfB7mgi+PmdL6Fcc2S5mf3bIDbyw0LcAxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780522876; c=relaxed/simple;
	bh=YrdS/TEXaFu1Egbrt3UIHjVIXgPo3HVq423b7i0eJH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WSy0BAtX2VSnyykXdu/upX9bw4nWBj+jO9+pAy+fypaZUC9XZO36qWZGS4zyk6RR0TfubpcFqe+MaklJ+SFa8DDATRMYqsomOE4xtBeac2I/ZdE6MQ16PpjCeryzMAe1cIUO5j00fzQ8otKDW8a4U0cCSlYkP7xZ0Jbwq0o69bM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=FniHnaRr; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="FniHnaRr"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aa5be9ab1aso6028764e87.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2026 14:41:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780522873; cv=none;
        d=google.com; s=arc-20240605;
        b=FzsvmQBdIOENY9E0Q/9B+Ckgux5XilPXWEjvsT9xj6sSq8DqYuA5gg3bKeJhHF7s8i
         J+IUZy6/euDKTslTgJ23N5AqTTHjpsyN1yVEYq3IjwqhXZKUIgt+Qai5qZdmp3EmqDv4
         Y0GbbcidNlOW7O0ryhtn9JWIEHir0MDR46RjabWxsc9m2ufWe0C5wiES9lWJEhIa9Fmh
         MFT9oX0VEGc+lXzqOjy/eWOxQBwg9vcoUV0Fyj6O2qx3zBghjo2uNvSFpIrQewQst7d4
         NluWn9WNz73UpFYjtnfmiCdGb6gHHormwcpZQhoEIpyY7fBbUzsgRewOhxokXDIllXhy
         KTNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YGtm56fWsDCiVqCJpc9AuYA/ZFzOFDDDvhQbt0piruM=;
        fh=wwDgdlw2ydYneaVTB/AGZSRbG4RBmWGOOQm21jEqF3A=;
        b=FEhjmuaQiW4p/Mk2Ow3F96bnxyKq0s6SnDfFtwEOtqY+nqseS58qLPKtGtXQPwGGcj
         QWvCO02dyfQlaIBSjsztgc5FQmzLWK9oOvRBOXUaGv77/0rulYTlvRhILJzfTjBxSDcF
         Fh+wfYyDLcTLjeDoBox4wgM7cX8nuTFmo4o3MP65MnN3QZPzVbruqbng5m7ttoCx6ozL
         Bp+XAcIonr1Z2n4cMZ89urcASnMY1bVmX9XPIKdssmFjXKzEHKRxfg0e1n6yYa4mdQOq
         digru3BXe2B0ObJCJA0s8L8lmolm0WbqIGTole5rMn5J3DMY2nAu3/82s5o6HUHvZEcG
         S64w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780522873; x=1781127673; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YGtm56fWsDCiVqCJpc9AuYA/ZFzOFDDDvhQbt0piruM=;
        b=FniHnaRrZbM0WuE3nGCefQB8TSf686EuMNKzXy941daKRCPnuesGVdCmFFhQJm6weE
         4Tzy83zLsfgRko7qIBvDj83gsS5VcsakDUtK+FbmX2THVWs8IqPCB+1HUKdyDtp50SIb
         isysPDECSEPoQ5Bf6AbgNX8uCNh+lN4n4NE13dIVJvVI88ZO3hg7lQKTEre2/OzYo/w4
         hwWTQZkTLZHO4T2nYRumS0WSBTXL1SrkW/K79BCdnfhrgLSo8jIaqkSCOd9baTn+hCVA
         zHcNhV42hq5fyWCwXhBI8vyrF0qe+cVxZDgPsJ1BTIMTmymN+bHu0mNNfZoOfouHw9dY
         BpZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780522873; x=1781127673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YGtm56fWsDCiVqCJpc9AuYA/ZFzOFDDDvhQbt0piruM=;
        b=op10bv4U/8sHA2qPeNJUpCRHMNEXWoYCnFuWyyWuPp06N4kbnbnthr3hMN1AaFygWP
         rhq/6G9SC2WUwY4cBDFlXP042CU7UPUahPaJbErLt1xDksvI0Y6+oQxP/D1znY+JxTIh
         1XK7SEH+HqDPWBohweNjNHoBE9WbHefJ7gy+E1vnLUffORGoW7x4dl7dOtB3wsvrG5Rp
         CGG+kOIbT2fh3c3gb3GZAbVptiFAJK4IU7szUC5HGDZotb1v9/1psT9DnzKOe3Js2YS2
         kaG+a9GYyGVz14LXukTaTWJc8/kmadA+2suy+3tZR2NyCOPhr5HrhmTx26flWKG7JwLP
         pJ+A==
X-Forwarded-Encrypted: i=1; AFNElJ+j9Ij6xtF53Fe2PBaeQCOuzK6JeMSNqpYCZ5stS/o0UhoE5G2cmnldapXJIBMCq5S9PzZmpyZz0S/E@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5PxmJzjunmj3pW2/38L3WgryQR61zLyGEEHI3oSnD5Q7v2T+b
	ofalmYvsOUd+3uVB9K81ggFD7AIu0L1018y/Ix6k7y0g+X2A1kuJ3eFXOBwLatuVhk9i/cW4udK
	FsBpj935LdlhtriU9oXdOqSu8XKHP1C0s5rt0w4Wr/dSrTwPAzK2dl+w=
X-Gm-Gg: Acq92OGSpnxLllETtLo6FDEQmVwZqPb4GM2sTKJwlsmdJkk41fXTzHxQVXUsMgnwufw
	XTMUbKHCn+rQJY72Lo/jWfXiBuDg830z7Cif7lA1KkouGIJv0FpvVlL4xJWZGY9erFoV/qL7643
	E26JMLNIcG+gAtI7MQE91fCFZhAJo9ibJJ6IxQ7EJFVnWPgz45hxVieyZe8pVM1j8AxLn7KX5GM
	p4wlY+AZ06azj9jRFq0+atypZgWytRBSNyO7nxOfy063jpl22/cpMDUKI3WaRz4jGTOkaVcdKQF
	5WX/nvrynPlyHgn+tg==
X-Received: by 2002:a05:6512:1387:b0:5aa:6e60:1983 with SMTP id
 2adb3069b0e04-5aa7c0a606emr1694586e87.24.1780522872548; Wed, 03 Jun 2026
 14:41:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260603182518.27082-1-sam.moelius@trailofbits.com> <1280577210aa54ba9a769ff39c3bfa797bbd32c3.camel@HansenPartnership.com>
In-Reply-To: <1280577210aa54ba9a769ff39c3bfa797bbd32c3.camel@HansenPartnership.com>
From: Samuel Moelius <sam.moelius@trailofbits.com>
Date: Wed, 3 Jun 2026 17:41:00 -0400
X-Gm-Features: AVHnY4I6LQUziGwk48uQIlJUbxz38uUSplJxC6VbV7s-CSUkh9jOoEshw-Sh7ZE
Message-ID: <CAE+C+DYQU9P-XnZfbOR+EocYtU0Tj=PPnW5zziXnFAv-RX+Q_Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: scsi_debug: fix one-partition tape setup bounds
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
	"open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 3, 2026 at 4:45=E2=80=AFPM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Wed, 2026-06-03 at 18:25 +0000, Samuel Moelius wrote:
> > The tape setup path writes partition metadata one element past the
> > allocated tape_blocks array when a one-partition configuration is
> > selected.
>
> I don't think that's correct.  tape_blocks is defined in struct
> sdebug_dev_info as
>
>         struct tape_block *tape_blocks[TAPE_MAX_PARTITIONS];
>
> so tape_blocks[1] is always allocated.  You can argue it shouldn't be
> written to even though it is allocated, but that's not what you wrote.

Please disregard this patch. I will submit a new one.
