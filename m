Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA5F12D203;
	Thu, 13 Jun 2024 19:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718307883; cv=none; b=hmCXpLF3PtO8jRhUiKl0z1rqt6BhE1lkMh3Pp20XZeq56bKfLNmVJo0xz20eGOGhotXrPF+WtD6HUrnDHEEcD2A3uizSf83Nyf9fwf6+voP3AmDM9l99k+tv6qBYRbnAh20Y7HCfDHXeDWLe76pkUqk7WrmMParX3tWVUF4a490=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718307883; c=relaxed/simple;
	bh=o0k56xni3HjDQhvMyd4bxJKEJ2zBYP72MK0RubwZrQM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mqrbDj3X+v8g9QNJLeaniq7S0p6NciUEq1EqVJqNRX7uiukUtUSkD+SI1uIRUSQ4NGzQypu6EUHl14B3dn76nM9w03GfW6yoyUKGb1CtTjUI9BtQTZNFADx67Hl7VdfVdvr68+j+79/SVE4YVKmQBAC+DgGwYDq6yvE8+6vO4QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HAz005uY; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HAz005uY"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57ca578ce8dso1663541a12.2;
        Thu, 13 Jun 2024 12:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718307880; x=1718912680; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o0k56xni3HjDQhvMyd4bxJKEJ2zBYP72MK0RubwZrQM=;
        b=HAz005uYOYZa7o3m3ZWEg90rQunhkScI6ExTwsDYmgK8nHlayv8U4SuU9wqguHod9V
         FBuOROWRVx5b2n8/efGrLomGNfiAvmU1XA80fji+KG5n9Gtcrt0zKftW65FvypUVzD6N
         JeCGcrjK130zx/ZOC0A/GUdor+5jGWI/9LA4G1+ortueKA3t40Yy/kAqhRQQYEA4M0dx
         NTlLZvTv+4wVYzyGvhiutKlkIoxCfBnWGaO9lxvmP7DyE+n+daJtqgss90G7Gpjni+SO
         9Qo59bqA7c+c5PspxvG97pMbBh8g+bKjhzd6TVbiZkuIpT5EiBJnCf3LEOFu3GRmLF0d
         SCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718307880; x=1718912680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o0k56xni3HjDQhvMyd4bxJKEJ2zBYP72MK0RubwZrQM=;
        b=RcNWgRaygPxFszX/Qz77czOMY44Ryzdz2IxPjds5jHkDPl/T7Bk/QtqwU0d+V1MNtf
         hBL7daVqPw1YtyKjNRF6AK5S7BzOmFLcXEvZXLeGHg6NiH3EOHppp0Dz+sBOs5jykbpO
         tXhmZclHSJJ5Szml2vuYFiixbn3E9dj/60yPUPlpSPhSeH3Xyl45okupb6iPEferv+HV
         GCcyy9haWlMzhvMAHeAymM5f32n4b/92D2B0e78aHtvrhUuJaQDELtOU2xbPY4nvaQuN
         JoMCREX7TylkRXOTTHBRj0gzh79Q4A4y1NC1NN+OW5KEyQl3iG75odSMyd62CNSgd1+G
         otsg==
X-Forwarded-Encrypted: i=1; AJvYcCVZTpL7KtrRb9UXNpo9v22DWMq6T/uHGu/6rzT7/dW/9NytzpaJ9rVjC8VKZRONeEts62dt9luLXffDhNu+63sXQt2zVzVO83AKA4c9Y14sKOxUapGxbjgwxS3I7g5FK2zzWsJt9l2SRgdnASDXelnjniFFysQkOW1nUNPhKA==
X-Gm-Message-State: AOJu0YyBa+zvdhDdXJUDhwMpNBaXepCw/A/9OOkvvQhgBBa5SJm8BgJn
	X86NAqDxVz3L9Dp8mlWML49smOyltIfnnTqRNLWG2kukx0bq8r/mdqUXpUfbAA8JH+PCpNYXh49
	jyIUrqSIhrhDp3ebdEM6kyjLPe6c=
X-Google-Smtp-Source: AGHT+IFkfjIYvIomJOHy/oyUucdP9vfmUYl+A+z1nkrwTNcXt7YAGybnuvgjDx59TFBK8xk6zkOSEbux8u61ozgHBKQ=
X-Received: by 2002:a17:906:6848:b0:a6e:f3d7:4107 with SMTP id
 a640c23a62f3a-a6f60de61cbmr45873266b.72.1718307880290; Thu, 13 Jun 2024
 12:44:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240612165249.2671204-1-bvanassche@acm.org> <20240612165249.2671204-3-bvanassche@acm.org>
 <CAHp75VdT8hp+aSN_ZyGebkUykaP=p9ipq4Guk6+e_HJ2apu18g@mail.gmail.com> <f3a8f117-4534-4071-8084-4cc984f963e4@acm.org>
In-Reply-To: <f3a8f117-4534-4071-8084-4cc984f963e4@acm.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 13 Jun 2024 21:44:03 +0200
Message-ID: <CAHp75VfvuNCvPCMa_aUYVzL6+b=UE5stC8rTwYzXSassLnDqmA@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: core: Do not query IO hints for USB devices
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Alan Stern <stern@rowland.harvard.edu>, 
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, 
	Joao Machado <jocrismachado@gmail.com>, Christian Heusel <christian@heusel.eu>, stable@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2024 at 8:10=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:
> On 6/13/24 10:44 AM, Andy Shevchenko wrote:
> > On Wed, Jun 12, 2024 at 6:53=E2=80=AFPM Bart Van Assche <bvanassche@acm=
.org> wrote:
> >>
> >> Recently it was reported that the following USB storage devices are un=
usable
> >> with Linux kernel 6.9:
> >> * Kingston DataTraveler G2
> >> * Garmin FR35
> >>
> >> This is because attempting to read the IO hint VPD page causes these d=
evices
> >> to reset. Hence do not read the IO hint VPD page from USB storage devi=
ces.
> >
> >> Cc: Alan Stern <stern@rowland.harvard.edu>
> >> Cc: linux-usb@vger.kernel.org
> >> Cc: Joao Machado <jocrismachado@gmail.com>
> >
> >> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> >> Cc: Christian Heusel <christian@heusel.eu>
> >
> > Besides no need to repeat these Cc's in case there are other tags for
> > the same emails, can you move the rest of Cc's after the --- line
> > below? For you it will be the same effect, for many others the Git
> > history won't be polluted with this noise.
>
> I will leave out the redundant Cc's but I'm surprised by the request to m=
ove
> Cc tags after the --- line. There are many patches with Cc: tags in Linus=
' tree.

I know, and that's why I am asking for them to be moved away. It's
just duplicate information and since we have lore.kernel.org, we may
always get the real message with the same data, no need to repeat this
in Git history.

> I have never before seen anyone requesting to move Cc tags after the --- =
line.



--=20
With Best Regards,
Andy Shevchenko
