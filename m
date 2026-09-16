Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6A751D528
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 15:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789572587; cv=none; b=HVwPucxEqq/gRycxOCnGs2TIUi/W242H4u3RopCXdS+qn7rL2vTYo/5HzFRsI+zSJzqsNSdw6cBqhVd479/XaOMMJPusCFG1KaytshN7XirRq1QrSuZtlZvQ2f12pQ90bdeFveTEoQO3Hg/QbYUnmLmuLCPuGz2HLzZ20fzq4Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789572587; c=relaxed/simple;
	bh=IAuAq7AfEMYN6bZoSj5fh4iCiJsktZHQdvOkf8LfBug=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pz+jBAbjDUme/PTQo3wi821JKSh3MNCQ/sj/60/IYXXNi/P73mBu7Q/xL+cvozMj9SHniweC37O1QJ/ill7esgknirek227hCoZsbqf/Dos3VOugXVluZcc6i04feugzPIcNeZKdo4MlKpw3l0W4rFjGgTtfUn+Od884fgFgtnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Aj8UsJ+Y; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eJDSLUrH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Aj8UsJ+Y";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eJDSLUrH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789572580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=16Klj/8b45VwOWfkXP9CkYxD9spB2q1cvTb2rAE2bR0=;
	b=Aj8UsJ+Y9EpHFm5G5hr8Qy1ktR8W/MrKViYgPvYhXoZMA8tuYCRIqwR5ws3tbBXjiXwWZx
	Cz7192Tl1lBb0yuebg5ZlrSrxWgRh6qj2uA0dmT64xgup/mo8AUljWFKGimI2u5Mek7qeY
	7sPBSZebrAhUeAxbAj2QqtwFC4sEPjo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-viZyeQRoN66KrYXx18JoVA-1; Wed, 16 Sep 2026 11:29:38 -0400
X-MC-Unique: viZyeQRoN66KrYXx18JoVA-1
X-Mimecast-MFC-AGG-ID: viZyeQRoN66KrYXx18JoVA_1789572578
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-9393ac4961fso703383885a.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 08:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789572578; x=1790177378; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=16Klj/8b45VwOWfkXP9CkYxD9spB2q1cvTb2rAE2bR0=;
        b=eJDSLUrH2AtmmBJF6j/ol2T43Ord3OE8SCG4FvxbmCL5TZ9P8uQyGV90hk8ELOyZ8k
         iy01FucVg/UdXrzHhZNGkWczXRnOH9tid/k59S1f3arQzTXHr/gFDsBmuOkfoUfBAMLz
         IT04KDgw5/5e9MFJlfq8/QjkbJio40ctygs7ZlBNqSGFJuF+NkRUUWAuhUDpdZJ32Z1s
         g2qAzqQcTrnV9r5x3rLbRX0DEvC4l7SRnSX9eXSiIAfwXhMveiflLnx0PJ9rFtPTo828
         KEtdw5KhWfIL/N6HA4snJve2u82uthaXcvgt/z0Gla9ztjJms7ZTnGc0RZTbfgHn3LIO
         VXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789572578; x=1790177378;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=16Klj/8b45VwOWfkXP9CkYxD9spB2q1cvTb2rAE2bR0=;
        b=qIioQe8TjxVeHz/tqSf+qK/8CgpnhAl+c4D++WUm7y4F4LV0LvD5V7excjw2w1y0Y6
         7K5PGIrHEYbxiz8Bxa3wjcgE2kXTN5qQo8+vJigfrQw0e8SqJTR3GLhrlUWCjIPtow5D
         bUjqyWdSgPNfMXgg15PHA1U16dgiszhbyvG9BltH6I8WEYPvpj7/Zd/RpjzFG+r9sLw+
         V0f94O/FCDejgTk/T2Uu/7WFbPPH/hb4aW78j6K7RY9gFGJlZ3FvgjB8PeLhq3k9+ygz
         RsBdtkfCO9K13x/KO5HOIadAGqm3IbZRsL9Cs2VH1kJm8HV/oi4zQfUo25d9+b2+un/O
         2A5A==
X-Forwarded-Encrypted: i=1; AKwUvBzhDQrvyiLirNSXxseuT0JAFUAcYsReZL5icu4LcYTa6lvmVffDU0QhdFl3yEQ/sDyYWwp5N4I1fG6y@vger.kernel.org
X-Gm-Message-State: AFuF++m6VcWHdapNfXuvVVE1lNv7xMzBt1MBDhTNIhzaAfjnLhpXV7c3
	O+oFdcSEqSv+m1N+sW3rqTbDmyzh4NHLO8YwR+d/8tq8r1CgcYbFj340fED425IzCKl7GgZfeo2
	SZtIdWaRASeCIC6dxsvbrDMpi1waiNXGZB7oYssB1w63FBAUQ+U9LtghvpUjtgxM=
X-Gm-Gg: AYBFou15GG960n/dttARJsNThid6+LFBfEym5QAa0lKPp/Z15IWsGhdmcKZkSzJAIVy
	e4nkOVVjZqTV+Sk4L5dmLx9PKnz2Jn1jN7kF2wDmfQt7zXm8z35menE+RCD5tzRNPjQkm3hq9ct
	NNiizyf8mgfDjabxy6HRrBhdX8ba8W5H6aVTiuZre8E0yCJXfw3c5BEUd3B1gjHRzYxLWcednqj
	KTi6K1cdI3BY2dm3VPpVXWaWzoHqHI21NEzlpBz60JGwSDmRVrlE+C2g+sS9j7cb+Lf+VN4p3WO
	qVm0I7CdUz75ur0Z/Ni0U3dn+gggJ2lW9hPFbQEAdZrdIxWCh7yx/oLkhdoRKk3R8EdbrA5LNA/
	IQCrHgiYElQHFy37E03J6oC70VykkrtS9bvpN
X-Received: by 2002:a05:620a:2548:b0:93a:273:6a41 with SMTP id af79cd13be357-93bb791b543mr474153285a.29.1789572577914;
        Wed, 16 Sep 2026 08:29:37 -0700 (PDT)
X-Received: by 2002:a05:620a:2548:b0:93a:273:6a41 with SMTP id af79cd13be357-93bb791b543mr474129085a.29.1789572576026;
        Wed, 16 Sep 2026 08:29:36 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:dbb1:97f1:a6e6:766b])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b81d18e5asm246235785a.44.2026.09.16.08.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 08:29:35 -0700 (PDT)
Message-ID: <2ff511fa29b801ab74ce9ee60e1257c47918c1db.camel@redhat.com>
Subject: Re: [PATCH 12/37] scsi: st: use 16-bits defined sense codes
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org
Date: Wed, 16 Sep 2026 11:29:34 -0400
In-Reply-To: <20260831021927.90FD21F00A3D@smtp.kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
	 <20260831020451.585944-13-dlemoal@kernel.org>
	 <20260831021927.90FD21F00A3D@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-08-31 at 02:19 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> - [Medium] Incorrectly assigning ASC value to ASCQ in SCSI
> tracepoint.
> --
>=20
> commit c1f7c0aa9501c3562bd45de8a85431d940fa338b
> Author: Damien Le Moal <dlemoal@kernel.org>
> Subject: scsi: st: use 16-bits defined sense codes
>=20
> This commit refactors the SCSI tape driver to use the 16-bit
> sense_code
> field of struct scsi_sense_hdr. It replaces hard-coded additional
> sense
> codes and qualifiers with enum values defined in
> include/scsi/scsi_sense.h
> to improve code clarity.
>=20
> While reviewing this patch series, I noticed an issue introduced in
> the
> related change to include/trace/events/scsi.h:
>=20
> > diff --git a/include/trace/events/scsi.h
> > b/include/trace/events/scsi.h
> > --- a/include/trace/events/scsi.h
> > +++ b/include/trace/events/scsi.h
> > @@ -303,8 +303,8 @@
> > DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
> > =C2=A0		if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
> > =C2=A0		=C2=A0=C2=A0=C2=A0 scsi_command_normalize_sense(cmd, &sshdr)) {
> > =C2=A0			__entry->sense_key =3D sshdr.sense_key;
> > -			__entry->asc =3D sshdr.asc;
> > -			__entry->ascq =3D sshdr.ascq;
> > +			__entry->asc =3D scsi_sense_asc(&sshdr);
> > +			__entry->ascq =3D scsi_sense_asc(&sshdr); <-
> > --- here
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ^^^^^^^^^^^^^^
>=20
> [Severity: Medium]
> Is there a typo in this assignment?
>=20
> In the scsi_cmd_done_timeout_template tracepoint, __entry->ascq is
> being
> assigned scsi_sense_asc(&sshdr) instead of the ASCQ value. This
> appears to
> log the Additional Sense Code for both the asc and ascq fields, which
> will
> result in lost diagnostic data when userspace tools analyze SCSI
> errors via
> tracepoints.
>=20
> Should this use scsi_sense_ascq(&sshdr) for the ascq field instead?

Hello Damien
This seems to be real issue here that sashiko found

We assign the same for=C2=A0__entry->ascq  as we do for __entry->asc i.e.
scsi_sense_asc(&sshdr)

We need to have it as

+			__entry->asc =3D scsi_sense_asc(&sshdr);
+			__entry->ascq =3D scsi_sense_ascq(&sshdr); <--

Otherwise we will miss the ASCQ

Thanks
Laurence



