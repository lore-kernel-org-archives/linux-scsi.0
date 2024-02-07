Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE291AACF
	for <linux-scsi@vger.kernel.org>; Wed,  7 Feb 2024 10:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707302449; cv=none; b=NrHqauFhAHhumFndG/s52W5P9xSGFtt62TEW2NN8tk7aENy28dL3hPkf9wyyFHtU3OlLos2vBok2i88mcZb4Y42L3Dqmvgl0L4RYbLgxWUJdHNsGGbU8MAYnBKNbVWfyFJP5YLf6QjsE6yR6uw4HqEOxXQ8uYH67w14iIWqqvsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707302449; c=relaxed/simple;
	bh=y7mfnDkpkBX9UzT7rvEawvP3Nzr1YWsD+mlYAX5Q0Io=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ek0E75uzA3zrPckOkV40N8y0QSGoG0AXy8OYEv69LBn6xnPEUAqikZ6t6IulbHmhkJw3groW8IUcIZQGLaBgskQO4J2Pe7EytOaT9RrKirpwQOE+CUJU21tp0zXMhsal7cZj9YYAq7usdAElG3Yop7YmwaozNsCr0rjyX4sknbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UlLh6B6+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UlLh6B6+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707302447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D8D95Wv2uFhy3JNCjiYOnY3j4dsKXxlHj6HBfXvMeto=;
	b=UlLh6B6+GmpIDJfFTjh/i9d8pb8+L3/vRBYdpijeb17H32mRt8zmA2kbY5k7/kVTowwGl7
	mxDbLORMenxhQXTbbJ0oIxv6G88WiJV28NY3X2PeHxC7Md54sk2A5/qsLqZVLpVUl874mv
	w9Q01JS/3jtW6/AUcxhzRr/UIH9a4wU=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-srAS6p-XNpawCGIAMrNWSA-1; Wed, 07 Feb 2024 05:40:45 -0500
X-MC-Unique: srAS6p-XNpawCGIAMrNWSA-1
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-4c0522e6dbdso276323e0c.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Feb 2024 02:40:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707302444; x=1707907244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8D95Wv2uFhy3JNCjiYOnY3j4dsKXxlHj6HBfXvMeto=;
        b=gl+YieeiO24PP5JQ+WVQjLvR4mum0NWctJ8zgnM559Y9uCyjkRpfrat3hBa511Qjtz
         HJejsP/mSXxUvDdJhiWS8/X52kvCaGtQlTCdIglnLTTKOYbur3uJLAtjxdQp0ld+WOb4
         EJXjzfhC1H8b3E1iWulVxOqmYTXjh2T1ifBJzgWodJ34/J6ZDhqjKl+dkulE/MnjTTwt
         sokLrtD1zLvTO9Xp+WyxqTVwhL3Zs6JqHYm2FfAE5H2JD4HTK0wObTlDJjazGZnNsNP1
         OACEcZTOubYh7hWIavVYjUOwEwFOx4NrrQfNmqNKIjQR3v1F5UqtFTKj87ZhBpMD2dYe
         ceqw==
X-Gm-Message-State: AOJu0YwCKFIjl+DrZCJh7udv5MgkTBRO5vEpdY2NSOSU5YZnaf/6MFaM
	86CBmuEgM1JvAFX7Gexx5M5EN8kNzLFMZdBe1o6N1M40k4advlaCX6h2vp/BP0sCcgaIIez6j7V
	Vaw9vGdFi3V+wvM1A0RW3opWcthcjYUy5zdl0B3Gnv3NudaWk4Elwm0FBk5+NtjRrAYClt2gFiG
	ahhR3kHaseHuHYoZ1qoAZrWgNRwECfQ+Mi6Q==
X-Received: by 2002:a05:6122:c96:b0:4b6:dbc2:1079 with SMTP id ba22-20020a0561220c9600b004b6dbc21079mr1573156vkb.0.1707302444590;
        Wed, 07 Feb 2024 02:40:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEfejQaK4aq55exy2XCBo4m6y6EkX6aYpyYLsWL0ix6y4nkZXQ4E5fDliKxJO3YJcqwURzU4vygUFKNQIQ0Afo=
X-Received: by 2002:a05:6122:c96:b0:4b6:dbc2:1079 with SMTP id
 ba22-20020a0561220c9600b004b6dbc21079mr1573148vkb.0.1707302444351; Wed, 07
 Feb 2024 02:40:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240207021919.7989-1-michael.christie@oracle.com>
In-Reply-To: <20240207021919.7989-1-michael.christie@oracle.com>
From: Maurizio Lombardi <mlombard@redhat.com>
Date: Wed, 7 Feb 2024 11:40:32 +0100
Message-ID: <CAFL455m_+s7nHA_FYFHzadb-qWf3VLdCqatGFbWHY1YCeuv3nw@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: target: Fix unmap setup during configuration
To: Mike Christie <michael.christie@oracle.com>
Cc: me@xecycle.info, target-devel@vger.kernel.org, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

st 7. 2. 2024 v 3:19 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> +static int target_try_configure_unmap(struct se_device *dev,
> +                                     const char *config_opt)
> +{
> +       if (!dev->transport->configure_unmap)
> +               return 0;

With this patch, if the configure_unmap callback is NULL then we
return 0, implying that discard is supported.

Before, a NULL configure_unmap callback triggered an error:

        if (flag && !da->max_unmap_block_desc_count) {
                if (!dev->transport->configure_unmap ||   <<------
                    !dev->transport->configure_unmap(dev)) {
                        pr_err("Generic Block Discard not supported\n");
                        return -ENOSYS;
                }
        }

Shouldn't you return -ENOSYS in target_try_configure_unmap() if
configure_unmap is NULL?

Maurizio

