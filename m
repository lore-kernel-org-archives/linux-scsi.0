Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3222D440A34
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 13:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786539604; cv=none; b=r3IAIb0hJxbYPCktMmxeU1WCrgECXc23BYQihz96Q45T/1d1fJpS29VKyt+KRESwqbZrT4vM9E9gIX+pyoTL2aaEaPPA5HJLmDAJv/ep1Z8ipRQQFDXD0L9G7D4oLz0y5Xw3D/lPHkZ7XqJ9I+T6poDKh4olWgc8MhRHEeQN+QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786539604; c=relaxed/simple;
	bh=8CKuUfKxKwZLUWDExyklUlm3JISoXgk4RLJ7+TM+cwU=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M1b15+xDLNIBUEWOSK71ANT+chfwoksTsb6QAL3KnUfJGnrEGH80PSchafcU/81gY/rlr/pBClIfNVCP9tTu6jyPrRII+Yza94S3N059ZGvLSvBF+NZnRv3dWpHxttJ1GfTslVTH7KXbA6/JF2NEab3jcyX0fJB+pmVbflGkhiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ru88uSr4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eV+iCfq5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ru88uSr4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eV+iCfq5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786539597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8CKuUfKxKwZLUWDExyklUlm3JISoXgk4RLJ7+TM+cwU=;
	b=Ru88uSr44DXhhhn3kPKFB0f2M9Ty17xB8L+FYAiOAkW/XHl6ldbqi6mf/6BIrI6JwpP6Fc
	WRH3mfYhcWq/MRrIJHBxhQ/xXETTn9CP+DSsX3inl65GdxX/UEF2qf8zdGpzzZC/7sxhXX
	5JkwE2kNPfWQ8KCXZlV5M2IEiPJR++8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-a2C7i0UpMsWF4RiMe0jmVw-1; Wed, 12 Aug 2026 08:59:45 -0400
X-MC-Unique: a2C7i0UpMsWF4RiMe0jmVw-1
X-Mimecast-MFC-AGG-ID: a2C7i0UpMsWF4RiMe0jmVw_1786539583
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-907c59bd73bso15955706d6.3
        for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 05:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786539583; x=1787144383; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:to:from:subject:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8CKuUfKxKwZLUWDExyklUlm3JISoXgk4RLJ7+TM+cwU=;
        b=eV+iCfq5dXAxfj6YQIxnipXTEAGegHMy6KId8spoIEPpKie3c/e2BO/tg5Ez3cblDo
         2VWzw3uwhoy1X3ssWveIukxywyteXaYmIglL909/aCfPQaDAAhPmz39/fRjAnAuv2P8C
         JYtsRsaovuIjSV2HmATJrNT6MpSB3cd+JACufkMZfa8dQCS4jPi80BFFqPNBqcll5n7T
         D8W3jcqZ5dKMZgVij6gTRMmmQHFFWy2IwKwBZcYKQ5S0fzCsZEziO1mxRLeI2weZkUzY
         QMluISti/NZMCD84GJOXK/ix35gROeopKF2A0OLZxeogqnOoqOS3Fi+pKu/OvEY1oGv2
         MThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786539583; x=1787144383;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8CKuUfKxKwZLUWDExyklUlm3JISoXgk4RLJ7+TM+cwU=;
        b=quUaMBLrulbSgximX+L84I9wmBWVEkBvw0BvtrmS8/q2sZFoUmbZaFuaoQ4F9ARJ9h
         TWWfyNDEelu34ydewcJ0bIwS0RYYg6eDHUNguVegWVqLSW59GbpsMH8PvwEOD5Wzb/4Y
         a7cVGuvHNdeoFasoA8vIx4wXHvq5Q0xly1MFxw5q99JMqCyJysY1WI1RZgBbO2UVKKIg
         93ndeeKVmaWH/mBVyfzd/XgWy+pYuOxmrVhEQkCA4s89tc1xaqSXP/Ez8KEDxaYFZtja
         k5s6ODRIkyKNNXiYohNgqUEw7UbcryNsnAqaeXgYj43r+NsgYk3pM/xUmdfUIV+6XQbw
         oI+w==
X-Forwarded-Encrypted: i=1; AHgh+RpnmubIQbAx+3I3+H23X/4QtHjrCWr+daeM0bIE/f2GiFT9/NCusUfIuLl2rhIE4nqtziseaHcyMiIa@vger.kernel.org
X-Gm-Message-State: AOJu0YzfQeBhCAwqX9KHBXFqZESwnyoD220F//Zp/vZnW/+6KVe7CVnd
	pBbzHEkzUGN5a6uOC6LGoz5rKKugH1uavnGjTSIcRMMYHLDiRnhbQYGXzDpd5FIQIQVv7XpZMta
	FDix1kRR0pL7fz1VZOCkTp3gELo6y0inx5H7CGRECLPMft6oQvAl1KrX+p+yjfqzY9w6Ju+Q=
X-Gm-Gg: AR+sD12fTy7OxQzVNX8hnXd/I+gQu7XsMbG/2TbyjDr/0DBliH3HiQQQ+q2mTDIaUDg
	AMrFklt0Ki80ovlK/51zd8NovwQUEgXVTQJtXBxyvwrRpZ7FOhGl7gSxE165hgyYaDI8NBl9T2i
	97BsbB3Y+eRtzLbnOeZDwKQ/gR9GLD9/ISZyYCKBbvqYITLAJnGzBmGUAw/AROIx1fFJZZ3hInc
	qoeiylwpUa6TgC15HjYp6dtSDjJTSvy5hZt/9RZnStFlK8Y6bWqSTSKDLMjmRZkxope6aNlJf1y
	YbABoD+dLUmHM5JKPfW5eDnw/VltK4+pkewIqr8emyHXQtXuCcDwoppt730Fg/nwH7ZhXLd4jHa
	z9oeUmeAxo+m6I+Zspyv6w3GeNXffSaKTy8/7
X-Received: by 2002:a05:6214:46a1:b0:907:94e6:f8bc with SMTP id 6a1803df08f44-90a6ffefe51mr45323666d6.15.1786539583417;
        Wed, 12 Aug 2026 05:59:43 -0700 (PDT)
X-Received: by 2002:a05:6214:46a1:b0:907:94e6:f8bc with SMTP id 6a1803df08f44-90a6ffefe51mr45323226d6.15.1786539583011;
        Wed, 12 Aug 2026 05:59:43 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:dbb1:97f1:a6e6:766b])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c3c8cc9sm20647866d6.35.2026.08.12.05.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 05:59:42 -0700 (PDT)
Message-ID: <debab5c220e3c966ed8da95f00d95d47790e5b8a.camel@redhat.com>
Subject: Re: [PATCH 0/2] scsi: mpi3mr: Fix error handling and resource leak
 in mpi3mr_sas_port_add()
From: Laurence Oberman <loberman@redhat.com>
To: "Milan P. Gandhi" <mgandhi@redhat.com>, linux-scsi@vger.kernel.org
Date: Wed, 12 Aug 2026 08:59:41 -0400
In-Reply-To: <20260812103344.174247-1-mgandhi@redhat.com>
References: <20260812103344.174247-1-mgandhi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-08-12 at 16:03 +0530, Milan P. Gandhi wrote:
> This series fixes resource leaks and potential crashes in the
> mpi3mr_sas_port_add() error path:
>=20
> - Patch 1 adds a missing NULL check on sas_port_alloc_num() failure
> =C2=A0 and ensures allocated ports are released via sas_port_free() if
> =C2=A0 sas_port_add() fails.
> - Patch 2 releases the target device reference acquired via
> =C2=A0 mpi3mr_get_tgtdev_by_addr() if subsequent allocation errors occur.
>=20
> Milan P. Gandhi (2):
> =C2=A0 scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add(=
)
> =C2=A0 scsi: mpi3mr: Fix target device refcount leak in
> mpi3mr_sas_port_add()
>=20
> =C2=A0drivers/scsi/mpi3mr/mpi3mr_transport.c | 8 ++++++++
> =C2=A01 file changed, 8 insertions(+)
Given the Sashiko reports were pre-existing issues:
For this series it looks good.

Reviewed-by: Laurence Oberman <loberman@redhat.com>

