Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291808;
	b=JSKGb7UFzlaIOhvYi46vhIptxbW9GnlikrXk2kp/WIoXY2FN1WBwRjKWj0G/saw/wO6j
	 aR/z/vGtTAckPA0X3cb0t2vnKUqXjPQ/vIzfRMG6hmnL151yBIVXIp2r4pO43IiD26/N0
	 xcnU5ud3fhMYAJ0oxSNp/pSeBJhX444McaEUurV6JI0b7zv9no3w5YZdpJ3xreb5+jqQh
	 aI3ub9ksz4Rkw5Ur4VK+S5e8WaVirDpY6WiBAYXXaQmeCcJv7VWUmRMo+JonXXM7sK087
	 kpnZums5q5meqY1LabapZdW6HaDXXYelvYwlENQC1tzWLkUTDvzUBrUzjmH0zJMu7hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291808;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=Xh5GwzoMNDORSahml54f6zY7X7ZcIcv/dWobqKgZ/mM=;
	b=4m/LRlQVvki1EA0FpdTIy1TQyuuWsTMYp1wyGeZKHIjnrXfP6Cv/e9CHSYauNBCKuTrm
	 ICy/xd09oQzB9drhb24cKoTWsrcrvPkwpsD4I568wzNLXIU5woYtFdVZ+IE6C6fo+9tc0
	 m4ySsr6XZb85+MxHdvgYMNSitTGA+0NI/T85VrDLdHCZ4J7nYVrIb9S/1rPzv20uKaeBe
	 2OTD5u3hSbOMLZVitu19f1XB2d+uyU2qG0KVCZ8ovUFm2DPe1CtHhopJopJ/GOxz2bxdX
	 UPRhCNWXF/QssNUgDr0lxL5cghX67Y6zVNfWb8pcnw8rUDbBDTq1hwK7UbuwAzuH5tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hXLTQ2ok;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=B9sXz07p;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D658606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 16:36:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D658606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hXLTQ2ok;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=B9sXz07p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793291807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xh5GwzoMNDORSahml54f6zY7X7ZcIcv/dWobqKgZ/mM=;
	b=hXLTQ2oktjHqcuwcOHfIHNlWyKwFyaYtAytFI9hdkpi5eonIRn5OT4C4IOi7QGQ4A8BwmX
	YnuVRg+89CDpGvQn7S/5xd2S6xnfpFiWZpemCzVdqtGHtvkpn6Bgx/loQ6HiqnC2d1ENIY
	RZm7wGiY6Pzdfefd1k5qlQh9nOA2UNE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-7bfNRD6AOPqkRNAVfY1uBQ-1; Thu, 29 Oct 2026 12:36:39 -0400
X-MC-Unique: 7bfNRD6AOPqkRNAVfY1uBQ-1
X-Mimecast-MFC-AGG-ID: 7bfNRD6AOPqkRNAVfY1uBQ_1793291799
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91c7a26f892so48262876d6.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 09:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793291799; x=1793896599; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Xh5GwzoMNDORSahml54f6zY7X7ZcIcv/dWobqKgZ/mM=;
        b=B9sXz07pKESqyGR7JHQOLqWP2l8Hktxn8N9gBhXQGahhdRoB5KWScnd0VlxgmJA5rF
         b42xRFTZQL2brWPazu2Uw85LcIcTWNEQMcKyXXIT4ZrWAe3e/emdJtQ1Ws5P+Af1xuJE
         WuY83zjy+vQ1QY7UC4unJqjPDKAHP9KGPAbb3j7zYsHTJJGflfrNoIgZI2du1790Gvu/
         sJ+HE4uqNlDwahpkfl6rHhtuOiNhxLeow3yeARX7K6+b8pmja5uF7O1fQcDT/Sw5aec3
         PN7LG5qGl15+qkqeSIP37HVlhChQsG8xBQVwieO3M9W9GqdflAdOdgktLhTsksxPvsOO
         LLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793291799; x=1793896599;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xh5GwzoMNDORSahml54f6zY7X7ZcIcv/dWobqKgZ/mM=;
        b=Fv5yG9nd064JpHaeZfJyj/sjOPeeIwkTPFgiUtUVw5FaWwfzem5fdX0EnjXhPQdaEb
         UwlYSpg4zKqBW89YskxgAAL/InEYoS6xZUrC6CllBJ+C4or0kY80NhtGuiwB1UOJEUP0
         +EgIvLWNyJRS2V3v2s1pYMvBvk4m9ytx6ODWfZ7DbiVaDAby1Oq5UBb+dWRM7E5SYpqN
         eLd4X0B9LhXtUCi6YTD44zzQZpW5S1f+0wx/WAdgngDu2UwPdvbIcs6dmV6hR8UalFYV
         Jxk8acwYWa+Thts7h+Om834EJcsiyad3r66vpDZI+4i8CRTHzXv2tNKwGdmDTedhcXfP
         ZZ4g==
X-Gm-Message-State: AFq9FYJ22IKtOh733pU92WZd9xb0TnPhDVJ3Y5KgQK9N0sbkAbV8e2Lt
	eL944QVA+B6/BMekEIyNshA+Layxqv7Spp/XJDCtfmDDdM7d+xmZBWNkv1n3WS9mUZ6F5pxsYk8
	61XXu5TIcnlnBQIRNdMyOG294JWmeYRVEIaRMec5rycFNts9wpOLMhbVJAngsUwaRd5JYTLM=
X-Gm-Gg: AYBFou1eZNgZeQS2VH7/HZJ4OsHJXzdT/gZgDOm0u+9zyzwqPfgvd4HDh/ZuczjppNW
	zTPNzDqdWxMCORu4ff264UGwv4qE2IxG9xEYsxg0RO6wdQIpUleZBmbPvJ2VKzCAPQMN3qekioc
	1ZuEzw64Fdryr0HusdOIomIPcWxPe6jMeha3ffYHN8ZlFbqqqoiCGBxNLdEem2jk7BGZ3wVZuHO
	EYplpo9iF5E6qLs/tKqTUfpK3E5eWIxEQgvY8lsjzT/DFA2SIEYLHYDNvJOKvlCjV4vHraXFXnU
	bxD3MJ+RJds0ll6wpMu27cXnbvmD2pzOb43LIqE8XJ1NLdzvANSLkSdINQhb3fTMFQRDPNvfwZY
	T3RxL7epvW07miPv9lB//+CFPqXWdNXbB6p/L03zGM//AmfbYSfNlMwxUW7T3SBDiapN/4cR5yL
	+SMsyrmbucjSdcld7Pl0mJ+eu9ih2ZFxmMJCZHGUHnBbP+4qaO+nqYTfDXteq6VZFgsClGVuA=
X-Received: by 2002:a05:6214:4609:b0:91c:7b54:b19f with SMTP id 6a1803df08f44-91c7d1ff57bmr83917726d6.45.1793291799088;
        Thu, 29 Oct 2026 09:36:39 -0700 (PDT)
X-Received: by 2002:a05:6214:4609:b0:91c:7b54:b19f with SMTP id 6a1803df08f44-91c7d1ff57bmr83917396d6.45.1793291798472;
        Thu, 29 Oct 2026 09:36:38 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca3131f9asm416106d6.26.2026.10.29.09.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 09:36:37 -0700 (PDT)
Message-ID: <8f2bf8761328abfd3ebcda9fd227fc0abff212e8.camel@redhat.com>
Subject: Re: [PATCH] scsi: qedf: Remove unesseary function call
From: Laurence Oberman <loberman@redhat.com>
To: Jesse Taube <jtaubepe@redhat.com>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Nimal Prabudoss I
 <nprabudo@redhat.com>, 	jmeneghi@redhat.com, Nilesh Javali
 <njavali@marvell.com>, Manish Rangankar	 <mrangankar@marvell.com>,
 GR-ETH-Storage-Upstream@marvell.com
Date: Thu, 29 Oct 2026 12:36:36 -0400
In-Reply-To: <20261029160443.904468-1-jtaubepe@redhat.com>
References: <20261029160443.904468-1-jtaubepe@redhat.com>
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

On Thu, 2026-10-29 at 12:04 -0400, Jesse Taube wrote:
> The result of `skb_transport_header` was unused. Calling this
> function
> warned when `skb_transport_header_was_set` returned false causing a
> panic on debug kernels.
>=20
> Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
> ---
> =C2=A0drivers/scsi/qedf/qedf_main.c | 1 -
> =C2=A01 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qedf/qedf_main.c
> b/drivers/scsi/qedf/qedf_main.c
> index da429b3a4283..f2bc0ac684e0 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -2496,7 +2496,6 @@ static void qedf_recv_frame(struct qedf_ctx
> *qedf,
> =C2=A0
> =C2=A0	/* Pull the header */
> =C2=A0	hp =3D (struct fcoe_hdr *)skb->data;
> -	fh =3D (struct fc_frame_header *) skb_transport_header(skb);
> =C2=A0	skb_pull(skb, sizeof(struct fcoe_hdr));
> =C2=A0	fr_len =3D skb->len - sizeof(struct fcoe_crc_eof);
> =C2=A0

Looks good
Reviewed-by: Laurence Oberman <loberman@redhat.com>

