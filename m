Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE4E279DA1
	for <linux-scsi@vger.kernel.org>; Thu,  2 Oct 2025 20:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759437851; cv=none; b=AM8vaDDB12EG/iZgaax8N9CvyRvRN3u0PKtYzezexaaJjVZgjKCVyAUK3qXQ1hssSpSuW2hyzJhrbOEc8ShPKZjfmOSdM0qNin9Pa6uhSFzMblOCQX4/zYxvq8nFQ5tGiJ/RKg8QaVouROi8actej4vz0tz+OqjKvaZFk/c6PsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759437851; c=relaxed/simple;
	bh=gOhQHnFNNIRBurl3ntNcPJa2Mmt22yZFAJnutuZIgR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Da35XwJAuY07NpqaQA9yR9bz6wvSXdK+eed5AU/4OdzTDRnX93eHjkNkgLI4DuTaR+/a9WOZa8qUprXpnindlIiXytKtVeNBvndoBNwqYUpfXvKOVIXI/DZLkdlAy9C4X8CAfLVq0WdxrNc685QGdsRo0/8CcY7fJMFWVsIlntk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LXqyk+09; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LXqyk+09"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759437847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q/h9DuP41W+s41OnyipZ8gQ7revK9O5DUHKIW3LVxL8=;
	b=LXqyk+09TLH5umIWT4cy6ch+Z22cW/fZPnyBtoY/xl9Zztu17LtQfKK6j65e/OwjGRccrf
	j/o2HWHOUDNBp7NlLGgydcnHfqr+9LMsDNwi9WtgZzR3O2Il+nfT0KZx10Rj4TUZ1fm9Yb
	bCT80bNMcT7VJPMHeTwRlI/zVKiPMZ8=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-3CyGw6p5MOSn4IzIWOa5hA-1; Thu, 02 Oct 2025 16:44:06 -0400
X-MC-Unique: 3CyGw6p5MOSn4IzIWOa5hA-1
X-Mimecast-MFC-AGG-ID: 3CyGw6p5MOSn4IzIWOa5hA_1759437846
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7448a11535aso19762307b3.3
        for <linux-scsi@vger.kernel.org>; Thu, 02 Oct 2025 13:44:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759437845; x=1760042645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/h9DuP41W+s41OnyipZ8gQ7revK9O5DUHKIW3LVxL8=;
        b=AfFeY+XFDrzr7VvDnYZzePHnuThhoh4NXNfBFw2/ex0F/NA2fMvR9Q+Uyn2g0i6bRj
         om0+RvETa0eRmj7fhAgdW4Dcr2G0r7maddpoH7KK2bZV2UgfA4Eb40hfXMyfllBbubwl
         BnXfZp3YVwWnX5VHVw/BZVyJLtTYmHyPKCcxkXfUgU1M1TC3tjbbs96ox+gqb/soROVH
         IkLaadKb5eLzbY2seqBTjEFovIFd31HA8mU7Jx+emqqlZ8GWmGDZqtV9go1rFYLpR22z
         vpFwfuPONyWx3uzd6cH8b9W5TSzI6JpkxIEsh2vgwxGHVwucgpH5ISKDRbiE2u+DNgnd
         mzng==
X-Gm-Message-State: AOJu0YyY+NdRpHUd+ahIy/h3WIUsdt7l2EM6XmhVRkS/QqpdgO6pvbWH
	5PXSjM2ENp9J2/r7wPXddxbgexuuYjyqVn1vd3Kt8HTaWLWl/sEB6N6xGGfwPb6olFT/5Irg64O
	k2eClsZC0oc76AhP+mQPDNpjXQqUAYGZi8OpDmmDj1KtKVZaYDdJj46WdUsmZL+H/+v1YyaYAav
	SPJIMowkFRNSOelB3+n1WBt+LRJ32uQrJNYeywv2usUj2yLQ==
X-Gm-Gg: ASbGncs/XAmwX98QkaLVEKiaKqsyYFontNV8jQl1WIQ+Mws0zif60h7UEmhYQTtdMdT
	+7nKhW4SCJ0nfN8KATMMEj+/mI7kcJ6EONG4qkqO5PU6j+H+VpZc9CmOIg8GZ7LgGbOb2+4KXvX
	SFF1t0wPp49g6xg9AyECaMt8ktCS0=
X-Received: by 2002:a05:690e:159a:20b0:629:e2b6:1302 with SMTP id 956f58d0204a3-63b9a07171emr627916d50.17.1759437845517;
        Thu, 02 Oct 2025 13:44:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvuUsKIeu7AOarxkJ6D4a1q6sZn8PjzdUHygy8oua/52fXE+M0cOvxe3ih+62fSys/4ZE74qWgOHt3+cLDY+U=
X-Received: by 2002:a05:690e:159a:20b0:629:e2b6:1302 with SMTP id
 956f58d0204a3-63b9a07171emr627894d50.17.1759437845084; Thu, 02 Oct 2025
 13:44:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <E7947463-9D29-494A-9044-460DD40CEA90@ibm.com> <B5CCED31-E0A4-4F2A-B317-E8EE56F7430C@ibm.com>
In-Reply-To: <B5CCED31-E0A4-4F2A-B317-E8EE56F7430C@ibm.com>
From: Ewan Milne <emilne@redhat.com>
Date: Thu, 2 Oct 2025 16:43:54 -0400
X-Gm-Features: AS18NWChDY0CqFvQzU_0anOFQJ7nv6rB6HAhr-zW_6yzhAUbqhfgHjBMZG1x1YY
Message-ID: <CAGtn9rmfeSRuCiX6=iCi5QwUdQXHwF_AKkY6Ood7OERmf7g2qg@mail.gmail.com>
Subject: Re: SG driver duplicating requests
To: Mauricio de Jesus Cardenas Hernandez <mcardenas@ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I seem to recall a problem report similar to this way back that had to
do with a restarted system call.

It is problematic behavior with sequential access devices like tapes.

-Ewan

On Wed, Oct 1, 2025 at 11:54=E2=80=AFPM Mauricio de Jesus Cardenas Hernande=
z
<mcardenas@ibm.com> wrote:
>
> Hello everyone.
> I=E2=80=99m sorry if this is not the way to talk about these issues but I=
=E2=80=99m new to all of this.
>
> When sending a write request into a sg device it seems that a request is =
duplicated. Specifically stopping the program on write and then continuing.=
 In a real case scenario this is happening with system-tap. I haven't repli=
cated this problem using system-tap but it seems that it sends a SIGSTOP si=
gnal to the process and then it continues.
>
> Independently of system-tap, I made this code that also shows this behavi=
or:
>
> int tape_write(size_t count, uint8_t* data) {
>   sg_io_hdr_t request =3D {0};
>   uint8_t sb[32] =3D {0};
>   uint8_t cdb[6] =3D {0};
>   cdb[0] =3D 0x0a;  // Write
>   cdb[2] =3D (count >> 16) & 0xff;
>   cdb[3] =3D (count >> 8) & 0xff;
>   cdb[4] =3D count & 0xff;
>
>   memset(&request, 0, sizeof(request));
>   request.dxfer_direction =3D SG_DXFER_TO_DEV;
>   request.cmdp =3D cdb;
>   request.cmd_len =3D sizeof(cdb);
>   request.interface_id =3D 'S';
>   request.mx_sb_len =3D sizeof(sb);
>   request.sbp =3D sb;
>   request.dxferp =3D data;
>   request.dxfer_len =3D count;
>
>   if (ioctl(fd, SG_IO, &request) < 0) {
>     return errno;
>   }
>
>   if (request.masked_status !=3D 0) {
>     // print_sense_buffer(sb);
>     return 1;
>   }
>
>   return 0;
> }
>
> =E2=80=A6
>
> // This is running on main after unit is ready and set the position to 0
> for (int i =3D 0; i < 10000; i++) {
>   char c =3D (i % 26) + 65;
>   if (tape_write(1, (uint8_t*)&c) !=3D 0) {
>     printf("Failed to write to tape drive\n");
>     return 1;
>   }
> }
>
>
> If I ran this and SIGSTOP it using this following script:
>
> ./program &
> PID=3D$!
> sleep 0.4
> kill -SIGSTOP $PID
> sleep 1
> kill -SIGCONT $PID
> wait
>
> It will ran successfully but a block on tape will be replicated:
>
> Data on tape:
> ABCDEFGHIJKLMNOPQRSTUVWXYZ=E2=80=A6
> ABCDEEFGHIJKLMNOPQRSTUVWXYZ
> =E2=80=A6ABCDEFGHIJKLMNOPQRSTUVWXYZ...
>
> As you can see the block that contains the E is duplicated.
> I don=E2=80=99t know if this is an issue regarding the sg driver or the k=
ernel.
> Can somebody point to me what is going on here? It seems that is happenin=
g a lot on a IBM=E2=80=99s product that it=E2=80=99s using this driver.
>
> Thanks for your time.
> Best regards.
> Mauricio Cardenas
>
>
>

