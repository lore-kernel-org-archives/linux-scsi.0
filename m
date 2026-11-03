Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793739218;
	b=qTjcIBlCnNLU3mxLqDdK3PelrM3RSlr+xCNCuE6x7Ys9qSVNWNEmxJ2YC6yf+sueEc5T
	 GnXcpwmP8WN0nGG1TiVehQlE65OHoZuT1nyyN4F0sEijUsaZEtr/ca/bhz7QCK1HlJn0k
	 iC7TYZ08uv8CAY5QDQWnrmrxMXlc1dAGmcgql5es5EcEe5GOFr53H32G2giKlOYKe2NGT
	 Uz1R90gBMfQ0lZZAZ9taaFDvPGGzY/4sJevXpX/gJ9EeVAVcIig7Hazns1DgU3SJ+vwge
	 n8KoK9pzY5XfjX0YCLVQUf1mY+Po3qBe0vRo622iwmFvUJWrG6eKjiDgkVqHiyXA9Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793739218;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=5xPft9KWXDkuOx6B7/u4FFqsvHBu2VvHvH2RwxyN1/g=;
	b=ap++w7LxckAqTq8onRsO7Cy+98sE3VuI3vKxjjhpfDUr9qWdhWo8BKpCTVYLh7tU7MA6
	 +ZHGIfCp28fsPA2NnmZoBklGU8wi/+99us/5One5nEWTltFwN0N6+VmUbvV1iwhdg0nUX
	 kuRjIgHBnemLJm1v00nnymRlx4JymvAJCl27zDcjTp/X4hyLnqaPQ/utAmEYqm2/6iiVN
	 EkG4h/TL0QaY1kr6d6id1odxaUbQw3P11yC5JCqU1Yrodmer4IAkbDjaCVku7D5PDj582
	 s5aWzviFjnRYT1GJ4V4S8BLTDxLSTwkkL0blAnLMW7lRMLGsy8UhWtE8892fQ53MBag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ag3VuK5A;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=tT8fNFNr;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256AC606A324
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 20:53:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 256AC606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Ag3VuK5A;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=tT8fNFNr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793739217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xPft9KWXDkuOx6B7/u4FFqsvHBu2VvHvH2RwxyN1/g=;
	b=Ag3VuK5AUyaEfJUPkJXijvvM0gzio3z75X66tnYnwYiCTI9pC6hTYqCOKWeKy3S4U5U1p1
	uXjLBCGxJppqYpybqd8ggtDwCaSjwnzKewHjSJtMUWoCaHvsgSKTYlLhHOmoTVUhW7ne3x
	/l8w7Awz+aimtJKwgY8LO0eHbv84sXw=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-thy-gmpuO0yUEjuCRYJkqQ-1; Tue, 03 Nov 2026 15:53:35 -0500
X-MC-Unique: thy-gmpuO0yUEjuCRYJkqQ-1
X-Mimecast-MFC-AGG-ID: thy-gmpuO0yUEjuCRYJkqQ_1793739215
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-88322409239so397577b3.1
        for <linux-scsi@vger.kernel.org>; Tue, 03 Nov 2026 12:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793739215; x=1794344015; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5xPft9KWXDkuOx6B7/u4FFqsvHBu2VvHvH2RwxyN1/g=;
        b=tT8fNFNr6S0O+XqApgnUOxbVGOG8DuJyT3Qy/+KaPj06AFSSpIzuhOlW/38uFVv2pc
         c47aoKR0zcZerlvJDCbBlrQYyrFMpUkNSTEspcC+FI5ElHyiKoYmKVqcL4r7YnWbKmsD
         Hk0e1hzuoHXJLT0T4+VXCzziv3v2PMUS3p18v7CVBjHE6hHqyzfUU9Hqd5xTDBBAC35d
         mGkneeO/nM/49EeAOoidtjriEv+zPoP+/VcaRIHg/hJMsbtEkXzY9gi6a88blR/OM8gU
         7QIFhE/Qmr8aoyaP74WeCivttJ7vWCLc2mF10CwL8gogP7W48PsZdh/6E/+s7jy0wKW2
         Z6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793739215; x=1794344015;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5xPft9KWXDkuOx6B7/u4FFqsvHBu2VvHvH2RwxyN1/g=;
        b=1Kz3ySK/kmOBsB6jkA76Cvw+EFaYfG+nTU+ZMk89eExms3m+q5f44Xdrg69HjzzOVU
         BWYDJIWaGj0SHLhoERqKtUzH7vxYFH4XmKCly9FNTcdqXEr72gRGOsCj/nt7mrit4VxF
         KaXKXAMsEo+Gd0kSgqTKSBDbmCe0gmqn88Hn0wj0rQLFBcYgaY129mdPrVZok7rLca+9
         LODHZ7L1T9LgZ70CBByvlLG7uqP+HOcBa8C7dXRfRgeXCp13XXRShwtUNP/G9f87Brxf
         ScyC0p/lFywCfwaXtfCDtRaA5gY5YaEdsp4Ko3AighroPavYB7mV8FYyxaG42ROvYGbT
         0YNg==
X-Gm-Message-State: APuU4Z+zqrTksazOvgU9t5gB7VxS7I+Kh5V+aWKsH4n4aK5G4Oj6XIwo
	CBXq17lo3TJHnh1PJMSNbXViW0koEuPBBbCWisPjkTZJ/KhN9B7GNFB813vHn9OfF0gGgv2zbqX
	kKNN9DfJCLekQ3uXJe7A51e9b/an2CBaXNq1GBcqRr10XuI3ahLAv0tys1A6g3mkSkkygdfa1Gz
	iYIngIlD4w6FPKaBPZKIHiI4Q/1/WKgBvynUe87wCcRsoPKfI=
X-Gm-Gg: AYBFou0814ivCSpGMb4AfJwkwnnI/KPYWgm3Ulc8WSjQ7EPHwtyq9byleWu4uWnqxPh
	UkdfdEWoUnBCVbQgWEZKO/OuaIMjoiVXeF5O9V9NaX88W2/NF9SY4Sv5A6GHpt92hbkh0Hed6oQ
	RB1WnRaOn8Gq4YC230gACbPCF7YiLHJENfYMAKwpLCClzB82q2JWizjX3WAEB/H8YJtX3vQapSB
	N7n1WXoW/c078n/9++oS3gmnWj649m9gTfJZD2L8xrOWtr+4jAcZelwVSXbWYfuFRbxC+h5yv2o
	C3gnvtX4h7lj0DNGfsNQYFvG6mwx0QZKMFOHDh2SgVEpT+YgQZA2fqDdZDUP+ZGvQp0MKJRSR4H
	Euw0T3kIFToOWkB4UTpg8zipRa5ATxCctgw0fRK3cRaV8g73xrktYVsTJXo4u9CZWnzTtysy7uV
	mX2Or/zMJjwmPmteRfjBdfxkKvGA8vorj66XxCUKivl1wa1Xfnzw2lpRsxFAdfSh5wf/Rjw80=
X-Received: by 2002:a05:690c:19:b0:8b1:ce5:be3a with SMTP id 00721157ae682-8b2b677f906mr103815237b3.37.1793739215214;
        Tue, 03 Nov 2026 12:53:35 -0800 (PST)
X-Received: by 2002:a05:690c:19:b0:8b1:ce5:be3a with SMTP id 00721157ae682-8b2b677f906mr103814837b3.37.1793739214512;
        Tue, 03 Nov 2026 12:53:34 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b30998fd95sm4851957b3.30.2026.11.03.12.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 12:53:33 -0800 (PST)
Message-ID: <98fdc5862cfd344f1b1401a3301382807ce4eaff.camel@redhat.com>
Subject: Re: [PATCH] scsi: scsi_debug: Wait for async target cleanup on
 module exit
From: Laurence Oberman <loberman@redhat.com>
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <mkp@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Hannes Reinecke	 <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>,
 Wenchao Hao	 <haowenchao22@gmail.com>, Wenchao Hao
 <haowenchao2@huawei.com>, Catalin Marinas	 <catalin.marinas@arm.com>, Ming
 Lei <tom.leiming@gmail.com>, Will Deacon	 <will@kernel.org>,
 cki-project@redhat.com, jmoyer@redhat.com, bgoncalv@redhat.com, 
	mpatalan@redhat.com, ftjahjad@redhat.com, fsuba@redhat.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Nov 2026 15:53:31 -0500
In-Reply-To: <20261103193235.1564898-3-loberman@redhat.com>
References: <8e4ba1820a7c56867bf7fff07bd52ff3f79573a1.camel@redhat.com>
	 <20261103193235.1564898-1-loberman@redhat.com>
	 <20261103193235.1564898-3-loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Tue, 2026-11-03 at 14:32 -0500, Laurence Oberman wrote:
> sdebug_target_destroy() is called with the host lock held, so it
> defers
> removal of the per-target debugfs directory to
> sdebug_tartget_cleanup_async() on sdebug_async_domain.
> scsi_debug_exit() removes the hosts and then removes
> sdebug_debugfs_root without waiting for that work. The recursive
> removal of the root frees the per-target dentries, and a cleanup that
> runs afterwards calls debugfs_remove() on a stale dentry:
>=20
> =C2=A0 BUG: KASAN: slab-use-after-free in _raw_spin_lock+0x2d/0x40
> =C2=A0 Workqueue: async async_run_entry_fn
> =C2=A0 Call Trace:
> =C2=A0=C2=A0 kasan_report+0x92/0xc0
> =C2=A0=C2=A0 _raw_spin_lock+0x2d/0x40
> =C2=A0=C2=A0 lockref_get+0x9/0x40
> =C2=A0=C2=A0 __simple_recursive_removal+0x35/0x570
> =C2=A0=C2=A0 debugfs_remove+0x40/0x60
> =C2=A0=C2=A0 sdebug_tartget_cleanup_async+0x43/0x60 [scsi_debug]
> =C2=A0=C2=A0 async_run_entry_fn+0x96/0x520
> =C2=A0=C2=A0 process_one_work+0x925/0x1910
> =C2=A0=C2=A0 worker_thread+0x567/0xcc0
> =C2=A0=C2=A0 kthread+0x355/0x450
> =C2=A0 Allocated by task 150:
> =C2=A0=C2=A0 __d_alloc+0x34/0x9e0
> =C2=A0=C2=A0 d_alloc+0x44/0x1d0
> =C2=A0=C2=A0 ...
> =C2=A0=C2=A0 debugfs_create_dir+0x18/0x3d0
> =C2=A0=C2=A0 sdebug_target_alloc
> =C2=A0=C2=A0 scsi_alloc_target+0x7c7/0xa70
>=20
> followed by a NULL inode dereference in down_write() from
> __simple_recursive_removal(). CKI hit this running blktests
> throtl/001
> on arm64. The cleanup can also run after the module text has been
> freed.
>=20
> Commit b402a0dce64a ("scsi: scsi_debug: Fix create target debugfs
> failure") drains sdebug_async_domain before creating a target. Do the
> same in scsi_debug_exit() just before removing the debugfs root,
> after
> the driver has been unregistered so that no host can still be bound
> and
> queue further cleanup work.
>=20
> Fixes: f084fe52c640 ("scsi: scsi_debug: Add debugfs interface to fail
> target reset")
> Reported-by: Catalin Marinas <catalin.marinas@arm.com>
> Closes: https://lore.kernel.org/r/auja2VnJTp-ijxqu@arm.com
> Reported-by: CKI Project <cki-project@redhat.com>
> Closes:
> https://datawarehouse.cki-project.org/kcidb/checkouts/redhat:3017229113
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> ---
> =C2=A0drivers/scsi/scsi_debug.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index a922c8318a2f..deaed8b3e6c4 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -9053,6 +9053,8 @@ static void __exit scsi_debug_exit(void)
> =C2=A0
> =C2=A0	sdebug_erase_all_stores(false);
> =C2=A0	xa_destroy(per_store_ap);
> +	/* Wait for deferred per-target debugfs cleanup before
> removing the root */
> +	async_synchronize_full_domain(&sdebug_async_domain);
> =C2=A0	debugfs_remove(sdebug_debugfs_root);
> =C2=A0}
> =C2=A0
Please ignore, this went out without series numbering. Resent as [PATCH
2/2] in reply to the cover letter.

