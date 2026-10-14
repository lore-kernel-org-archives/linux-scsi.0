Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB2E35BDC2
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 03:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791947290; cv=pass; b=XSlKLgQCK6FLPmETZmXCNSj5Ari/ECgTV83uq1vGsWtJiVB90Y6Txfd4dbJQzGdqv6rANIDOBnCgTTecV9YqpvhOJJr4fKWnytZ4pN/8McO9fd+iwg8zSota9oj3WnIRoweTjmWIjOatpEcApmL1sW2/9NN6mOlPQ2LFtrTgI8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791947290; c=relaxed/simple;
	bh=uSCQoYpzjWFeo1wHrvvzz7nrDX04om5nCgnCg/UJRJ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XrufDmuMYLYMmgRMJKOMUgm45RGIrDCXBP+bv2vbrQIpcEkb+pRFBHqmvMwpykKhmMR4vG5XbuvFWn97B7QNaX4mxlENwzKp3H1Q2+lLq9wzMXZg5I7NYd7Ni7FASiekKkHIxg+7k1K9piKA7IMvrPh/6aazQWFLmGeKPZ0mwkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AeWh+tc4; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AeWh+tc4"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2e6df2742cso557138866b.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 20:08:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791947287; cv=none;
        d=google.com; s=arc-20260327;
        b=WmvJMQo6+DY//8iHuc1q4GnQVEE5zcJFrniOp5b7cETqC8tuCcMMHt1g8UG9Uo4K2P
         SDyrQB9lrpzlBaq2UaEJwFtjRJoOLwab643p9XUfV/loWMNiBgwlartU8MgkVKVkre2Y
         9oIcLlpRRl7aj0aYNNt6b9i4paKlogWVBLGWIFa6inBFbIVuXa1xfcDe10asfNttNy5r
         nU4O6Zft/Zu6r7RplQ1ms5UYjgE2VwWXCUnQ4GwNPZaKkoTCWn1aDqV9KHyKxZ8oq0Ji
         lM77VL7j6UcPF1y+qRsSzabVQJpGSFo4aV5AlU06MrcX0MfWoh2Y7RK0A5/Qm/NiYr0v
         KnZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aa4Yr7SwreeKDT4ivX8qB2f4mW+4V99pbNocmP3LRcY=;
        fh=wCMRbCQIFKg7yPX6zODHDavdCxo4TU+EMjZWrmx68sc=;
        b=GSquv1CHMK3iQOjuUvldIcoVS4roe91/wQBYkODcuxBOEaCy+k4m3K1ZADONFmQpH1
         w+a0+xJbAwxriVnhsvqcCea8D7CS2M8813i2no5IrqX8re2LlIx1Pu7dNQipuHk1XBlX
         t+ywbwTjv4gEpHvuuRiZjVFlNNwNIVCNJFWQo8oNL6QoPDKE+HC3vsr8zqzXitq0B1/S
         8sxc5nCQARNUX3JLz7zZ1QYQUwpsBzYX5ikDkdpbvbQoM5Ka1uIZ00eQg1can4DSh3aQ
         kwXAsZHbpp5E2BXGaIvR8MYloYDBGt325hYYhkHJd5X8x6XLa+5iq9xyW4ilwy+1Vllr
         K/qg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791947287; x=1792552087; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aa4Yr7SwreeKDT4ivX8qB2f4mW+4V99pbNocmP3LRcY=;
        b=AeWh+tc4jiOr10euWKCqzxOKp0eyOxAwqxjPynb2G0VRQJ1DzJKgarn2zHwUUdWc0D
         zGaFYBCIsHRRtNRbbRjdabW2KMN2fUH7mA+vMtT0aalcLv1NeqRtxzUth15JMasbDx9q
         qhbMRK06glIfiVan5hAQSpRnnJha5TInp69ts3cCTgbYcYpoO93g9H9V7gm0FalJwvHI
         GzlqOKRjtNQlN4WDnfFpQQY/KKKo62Z07AuMEvW9h3AlyLYOVobk4jtBouDd7L7l9/Gl
         Mx8CpHXaYJ3Q7vf83QjtcLr79GIjqRdOMWsdVHlSMxgsYYOvMqJdaCrtdWFZfZ0YuRJT
         1+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791947287; x=1792552087;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aa4Yr7SwreeKDT4ivX8qB2f4mW+4V99pbNocmP3LRcY=;
        b=cSlXm8TCg7AhylglGTl9/IWyo5dETYyaBZYSh2vsTbf5o0YWhU3JvqkNltJ2VrzIaN
         hm6e9Cto7ulDOhTkJM+SlIuOZsENT8yklfCXi1BhAChv5RLHv7P89e9XSCds2qjDwSyK
         sVgvSiew+ym91jqh/A7Nonpq474tkPeeES/NUTwzYEVGe/93M1vZzhBKiyU0yHkYrev4
         0C7ndfwIfvvkOwix/oLBpT7hFBSsrFqx6DkeErlqSM76v+NIY0IRoUZreDbLkh60vnkH
         FItDWF2aJRBcfsB1EuSsAOJjSXflmvfCyUnfgVQab7cQVtaHi6iXsYXHs+L0EsDtKmqm
         HPWg==
X-Forwarded-Encrypted: i=1; AKwUvByAHHIaPm13AqGorNowFfX+pa7f9hRkvD2GBY1MCgh5R8pFd7zKgxvJdVxCrGJuNYsIjWcHJKwIc7DO@vger.kernel.org
X-Gm-Message-State: AFq9FYIcdzvCFsg1QQpbtNShpvgtK/4DGOzFKw37bJu/6KRSiT7aB+XB
	j2ukacRaBWNdyx5zFUEhpRK5XDIBg0ygFki/SffX86oUyRfXIiMfUqtcJgIcSKP3Wo0s3aelmwL
	y+nIg92UCgBhUFiQFvRK8ySyj1dpRrEU=
X-Gm-Gg: AYBFou1TUo+Fdr/nN0xNwrkViP53+01zsfJriQDd/uB2sL5MLqKLId6bfjR4qj4vwXH
	e268IKRI8XM0KJcVhLZ7x0DdxYkNUrN05UpxmcIfB2cBP7ynK07Gsz6pnKkUTzjC4PzQCwtb+aW
	jLoWGR87T9XScxcAGkGuMjMZ10AHLhZAfZ2iG4RHU/0WuQUZqc+vesM3met9HeRxO815w80UcXR
	U1AQNywnAKx6sDIxY3glMRsVhFlHYtjj/eIPiXpj5RB9EcEb4Mtn2Hhf18lKdLBtkB5J8q6yZty
	FvUcWt1lMtAig47iAMJXxPoHNUAs3kul7bxYaP/POEkOtnELVgSNJ3xV659ItQ3E29k=
X-Received: by 2002:a17:907:2d94:b0:c2e:8eb7:53e8 with SMTP id
 a640c23a62f3a-c31aa03cd11mr1407785566b.30.1791947287125; Tue, 13 Oct 2026
 20:08:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008184328.2857037-1-andrey.misyrov@gmail.com>
In-Reply-To: <20261008184328.2857037-1-andrey.misyrov@gmail.com>
From: Nigel Kirkland <nkirkland2304@gmail.com>
Date: Tue, 13 Oct 2026 20:07:53 -0700
X-Gm-Features: AclHuK-8V7o1mkWksypfs34fZk2Yx_H-EjQzA4IbedsxqhKr1LVaSdFzy0NwxQg
Message-ID: <CACnqm7_5nvH18EGCdW=VZy3bLJUG7geaeTDezG9AvAmjGPnF2A@mail.gmail.com>
Subject: Re: [PATCH 6.1.y] scsi: lpfc: Fix use-after-free of mboxq in lpfc_sli4_driver_resource_setup()
To: Andrey Misiurov <andrey.misyrov@gmail.com>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org, sashal@kernel.org, 
	paul.ely@broadcom.com, martin.petersen@oracle.com, nihaal@cse.iitm.ac.in, 
	linux-scsi@vger.kernel.org, nigel.kirkland@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 8, 2026 at 11:46=E2=80=AFAM Andrey Misiurov
<andrey.misyrov@gmail.com> wrote:
>
> The 6.1.y backport of upstream commit 1bd28625e25b ("scsi: lpfc: Fix
> memory leak in lpfc_sli4_driver_resource_setup()") added the new
> mempool_free() of mboxq in the wrong place. Upstream frees mboxq after
> the error handling of lpfc_get_sli4_parameters(). In 6.1.y the hunk
> landed before that call, right after the NVMET WWN loop:
>
>         mempool_free(mboxq, phba->mbox_mem_pool);
>         lpfc_nvme_mod_param_dep(phba);
>         rc =3D lpfc_get_sli4_parameters(phba, mboxq);
>
> mbox_mem_pool is created a few lines earlier in the same function, so
> the pool is full and mempool_free() really kfree()s mboxq.
> lpfc_get_sli4_parameters() then builds and issues a mailbox command in
> freed memory. This happens on every SLI4 probe. Its error paths also
> free mboxq a second time.
>
> Move the mempool_free() to where upstream and the other stable trees
> have it.
>
> Fixes: 299f5baa1321 ("scsi: lpfc: Fix memory leak in lpfc_sli4_driver_res=
ource_setup()")
> Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.=
c
> index 13ebbe4..fc5a640 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -8175,7 +8175,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *ph=
ba)
>                         }
>                 }
>         }
> -       mempool_free(mboxq, phba->mbox_mem_pool);
>
>         lpfc_nvme_mod_param_dep(phba);
>
> @@ -8209,6 +8208,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *ph=
ba)
>                         goto out_free_bsmbx;
>                 }
>         }
> +       mempool_free(mboxq, phba->mbox_mem_pool);
>
>         /*
>          * 1 for cmd, 1 for rsp, NVME adds an extra one
> --
> 2.43.7
>
>

Looks good, thank you

Reviewed-by: Nigel Kirkland <nkirkland2304@gmail.com>
