Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADECD39FCB4
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 16:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790094875; cv=pass; b=b1fwI14jZZJGpCl9m0iFZt5I+rJ+I4sTt171hQhBkrcjpaFLYCl+JJluL9gJ2GhcHEUozj9SG7TtcDY6zMGIUH4FHlhA/D5Vhp9Mo0q5jxPEsQpI0xg49R2gzAGc9VCY3XMJvKg+uJuNuSzPzBuZ+5vSkqBGzGQ+oyWCP5tgQms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790094875; c=relaxed/simple;
	bh=cKbRWUWUNFCMJjKOH3yHgRtEpoahj/lRVoNkkOfXTsg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XntiBYBH9Xa/8KL8kswZzkS5pTuExIvGBvVYUyaCxzOb88kRopBdMaHUyOhBrxevFK+1UhY1qfUTmWWZze0YFRSmH0n34UBPnegGGZ6muY4IOm52ykSkwqn1piKS/2L+W4eBysxGQOHHqFZ1UEX65dAgh6Gyqx9Ur8WolxdJE7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AB0zXoy1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JFcMYyPe; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AB0zXoy1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JFcMYyPe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790094872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cKbRWUWUNFCMJjKOH3yHgRtEpoahj/lRVoNkkOfXTsg=;
	b=AB0zXoy1Yvcm012ebd22g93OJbpurDQn8u1uHe5d8RzsT3ZMpvCxh+yo0EUJqXz7bfpG5G
	PKjxa7qRnG1F6zZ1ph085yF6pgjNLW2brVmm5iZ6VKBRiBZG/P9YOQ0hCC7epr0C7KjsEH
	+G6OYZB0KHfZrCFF7neyM9Bu0OgJUss=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-na90CnymOSevVY5le1Yppg-1; Tue, 22 Sep 2026 12:34:31 -0400
X-MC-Unique: na90CnymOSevVY5le1Yppg-1
X-Mimecast-MFC-AGG-ID: na90CnymOSevVY5le1Yppg_1790094871
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5c8323b8464so21835e0c.3
        for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 09:34:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790094871; cv=none;
        d=google.com; s=arc-20260327;
        b=YAL+XevOKxoTHEe0nUpW/gCB0KOcJHWqGrHuDDjbuNyARNFWIORPlCeIi4hwnv7Ccl
         EQZqpgX8NdfZBsjACm53NYUSELDRWgWusORog909CpGbD/fi7087y7yd1/M9zYRF8YU9
         xM1f9xPPLG1NemrYmcWRrbCIE7CdFhRkxPFdEPZPbwg7ZtvK6WhUnKCoTxowf3ZKqP5j
         tZy8/rqvbun8GtsfWM87W64zoIP9rxAV3IvjLhew8g7lT3985LGXe/D3R1f4oDzZzq6O
         hiG9daKPaMr3G8coxpe0VJA/FpKRtez0un6T/UTHmD7wAqZLos3Q4VOk0XD8lNpwLL1r
         Sw6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cKbRWUWUNFCMJjKOH3yHgRtEpoahj/lRVoNkkOfXTsg=;
        fh=ogH+oXRPbrx78UZxd2AQf9OuANeIQ77hD6FCmj2yG2w=;
        b=HLg+n0aeGtKxRexl02YJ9BnJRFM9Wl6jIzJQdgc3dPekCp5iueFFJ/LRLbHZbGbV2m
         XtBSzxveQiVi+zfq/hgYmrwyBeN9I69NrTocJZBQWpOv6est8GY7qa1VuEbAx/gr9/lW
         4qU3J/WNOZjmL6LwNcNWdwzB1Ce9WIui1dDb0DOcXmdLxLsUy2RBh7FeO9tHxwWQn11F
         ZHdHFWMxKS9MJg/gc6xD7Ambv0K60bfVMqlskavawevgi56iGj0ceeOgcKveNfKZdXqC
         uiNZh6xlKPG4oMafo+qZbJuOBCaFvnypROD8XTaHJmlJUFPAL2+gWL9ylkHnkcm9q1wa
         MASA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790094871; x=1790699671; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cKbRWUWUNFCMJjKOH3yHgRtEpoahj/lRVoNkkOfXTsg=;
        b=JFcMYyPeetOC3hyTIz7DST7NcJm/TD2yslUQK+hCqUdwvXUmtVKbN0d+zpIZeZgn8Y
         jXJI+fN2UNvqdUyxVn82tW+X7LeTaGQk2lMEzdOb/qnOt/P/zs8ekhAR709/DXu2pqbI
         tmypp0UV46TG+3QOXq02/QrBB0TCpP3ijZ4kuNt+t4Ky2k0V9/AO1KOX2ny4Hh+LpU7w
         8LVC9qZOG2XvIbt0hv2hPKHhDP3p3gU3eu7iSzsdHwJZmgol+OPguRIknGmsvd6tKN/I
         Mm1dFUaIxmYowaQ7hFLa0F6kZAVKr1BxRqBUSMFHRbARJJb9sZCozHRdRNvxpJP83tJM
         5jnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790094871; x=1790699671;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cKbRWUWUNFCMJjKOH3yHgRtEpoahj/lRVoNkkOfXTsg=;
        b=qTqUfCKsI6kzSBVznztheH51MoiVe+c1YaOMbh/6Qiz7WRuoOm+4eT7/j8BJfwclzg
         yBDkNPhfAiFJpD+Qcq2ZSOi+8nTubaVC9kzqOsx9MnWmlCUMNKTc5v7vBF2fPwSYen+O
         gnEq3/HseSP3sHvgQeHczfVh5mxgGxohIae+WrtXyKjHuy/+xY077Bib8JsOVyAAc/Gj
         zlBIE2bX25ViESlQWPK68/nQ2HliBSQ1/4uQek8knWzdz86ZEeHGsDCdhdXRPtqxglcj
         ws3cJkEB6FJbOYKWGtS+nNdrSXFAPSl7CSa9dSbq5a/SbPhmrL3T2tHo/EHWI2uBfPVJ
         2V3A==
X-Forwarded-Encrypted: i=1; AKwUvByvfK4SfWBKdYNv/Fe9gSgqhRb6OOEAyHpBBGkXKa+mbzJt5C8bxZLU7ShM7ehC34yJyCY3MJ7RhEjk@vger.kernel.org
X-Gm-Message-State: AFuF++l/FkWXEQWM/3etDTwAyS5WvYEi5JlAFeQ2fd1KmDB/cSvccj+p
	6ejqLh72VJ/p6RwWg2TXcomVQ4llIpvCFvmy3gFl7LaR4l7EMPJluv/549+XSPxyA6pEdds1up3
	cnbFvzF/muYGxDX6hexNs00odK/ekt+qq0fR+cIH4coKNCppaQXJEPKKXXh3bxoeTvxjWjKWKAB
	fr9rNGgIatngYBfU/zb31EslycselLgzEzzoYprg==
X-Gm-Gg: AYBFou0+xKN4wxDQDdLya59KfKH7Q2vIQ6OHD9oloYjGpZSVihM5AeTmsEVxFA/k2QH
	cGBHMRaj/1fV/wOsezyC54XIr76GYDEEb7I5wtnQzAV1gw/GMRnCJK3AewsdCVh83YJfP2zDbDk
	j9ma8S+f8foaOSJh/72DLIAvQnyUDUElodHr7ayibDbWJsqFN9G7jcGacsLFGVHMpBq+6mrpDAo
	fzI/iqcDKOvwVh1OHwUXVRSRVqpG6I3Dt/BaL/K/Ai+OQaJTDoBjCiCmFOO9E1kKQ7zBpaqw2E=
X-Received: by 2002:a05:6122:4d01:b0:5c2:b01f:e503 with SMTP id 71dfb90a1353d-5c9f15bb2a3mr57784e0c.7.1790094870728;
        Tue, 22 Sep 2026 09:34:30 -0700 (PDT)
X-Received: by 2002:a05:6122:4d01:b0:5c2:b01f:e503 with SMTP id
 71dfb90a1353d-5c9f15bb2a3mr57708e0c.7.1790094870278; Tue, 22 Sep 2026
 09:34:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260917163744.191748-1-djeffery@redhat.com>
In-Reply-To: <20260917163744.191748-1-djeffery@redhat.com>
From: David Jeffery <djeffery@redhat.com>
Date: Tue, 22 Sep 2026 12:34:19 -0400
X-Gm-Features: AclHuK_gOIIAGH-J9mfA_6kGZQPoZd_UXxbRIgUMsQf82GPy6D8kJfhp32jIMog
Message-ID: <CA+-xHTE65H=WSU4kavq7dC=FkaMVKuEZiNw5-o5DekRpgRkDeA@mail.gmail.com>
Subject: Re: [PATCH v22 0/9] shut down devices asynchronously
To: driver-core@lists.linux.dev, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, kexec@lists.infradead.org, 
	Ewan Milne <emilne@redhat.com>, John Meneghini <jmeneghi@redhat.com>, 
	"Lombardi, Maurizio" <mlombard@redhat.com>, Bart Van Assche <bvanassche@acm.org>, 
	John Garry <john.g.garry@oracle.com>, Jeremy Allison <jallison@ciq.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Pasha Tatashin <tatashin@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 12:37=E2=80=AFPM David Jeffery <djeffery@redhat.com=
> wrote:
>
> These patches are rebased against the driver-core tree's driver-core-next
> branch and should also apply against recent linux-next. Changes for v18 a=
re
> contained in patch 3.
>
> This patchset allows the kernel to shutdown devices asynchronously and
> unrelated async devices to be shut down in parallel to each other.
>
> Only devices which explicitly enable it are shut down asynchronously. The
> default is for a device to be shut down from the synchronous shutdown loo=
p.
>
> This can dramatically reduce system shutdown/reboot time on systems that
> have multiple devices that take many seconds to shut down (like certain
> NVMe drives). On one system tested, the shutdown time went from 11 minute=
s
> without this patch to 55 seconds with the patch. And on another system fr=
om
> 80 seconds to 11.
>
> And thank you to everyone who has spent some of their valuable time
> providing reviews, suggestions, criticisms, or tests on the various
> iterations of this patchset.
>
> Changes from V21:
> - Check a device is alive before accessing its bus pointer
>

And this has resolved Sashiko's last complaint. Sashiko found no
issues with the v22 patchset.

David Jeffery

