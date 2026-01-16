Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC575238178
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 05:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768542403; cv=pass; b=l0ts1oDhmvpMp2kPj1J4WGzULwNpqHTeduxLM/KA/X+rGCtx+fGwWgoLmiymdNtNGWD6HKOBw1TMAuwceh1P4F6d4tg7B4pAySkMROM/sZyQm7WmrCcU8oAO/XOTZ9oXH1YLYn5aorFADZb2rZ7z3rX+Pl2nncOlrHIFQU17fTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768542403; c=relaxed/simple;
	bh=Mq6HQP8xs3Tz+iSoeV9fDhjYgfywQGj2t9dK9MDFSIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SwN2zKUaPTBtLa85lmnK+HxM5ZQWM6XFqRfhtnjKIZ2kvIG3wdoSyXCM0AHiehlWTkpJqzSEVuSf/ihMmJZ9sGifS8sJ3IlTtyz8ayHI8nKFHMWnVyENsff7L2Z8Nrov5Bidrqe19hjGI6vvuIRJhtD+sHdRewYlwfSlGcOQjC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=U0NYb3In; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="U0NYb3In"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b86ff9ff9feso23509266b.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2026 21:46:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768542399; cv=none;
        d=google.com; s=arc-20240605;
        b=MQfyCp5G32MX3VeWYVTgOueFM6Iz0ZcEnXnfeB4ryWFCDSGkH/DzDCXAuYKVT+s0uD
         DwaZtVHl9zh+fN5+RMc9GFSiGTCw5n+ctCpUEHYK8eruh4IcpdiGtlLGGVSx0EMsR30j
         rGORCOgOzBy/3phtIuK99ItmKw5NWflIaphlZy0Brn9MMvLIFroa+wlEGYVgNdyzWYgz
         wmOkLy2EBXEuZzseNAHVC4k31GFSRLkSr9/rE413+eH/FjbS6LffInYeEZh44FgFs/q1
         Ejg/ApmrhiJdqkgE2qQNlH+rG5Rr15fuM4YnZu2GjWIbgQmim7sAFFxsqt1yUQg/U6sB
         9dcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Hju5Ps3Msz9yMmEFtbt8Zf7haBoqvnNaSpPoh8dCW+U=;
        fh=MGp1YcMGX78Rtc116zIEAE2mmoOTepSPryCYDfcpCM4=;
        b=Bu4aSKEST/5XidAagU6TeHu2TUmcSkcXH/8u/QPHgZvyrjm5RGJUycMvp8WHAfql8E
         Kprh4zJMFSMCqLBF1N3kPjMzekY8Ebiknj1/yJV4yt//bpZYrxnOkzh00s6bmA1l+oSl
         0UwZMHgS+9/2aY33bvj06im9vE8xO1DjWy/1raKR/q+LXbn56+w+agdJvIDrvZLLXg7X
         SY4uCv4AhuFyYgpQSAXLELj/hiSY/YH4PrYxPzIu2yf9yxI5ARB9dlWs7diJm3JrK4Gn
         9Y/AXnSRe0c6RqX9+A1lbLBlVQXIlaG+iN5fQ5e9rLXUMxlA9D1ov0yFNGm7oVmY7e6E
         4tjQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1768542399; x=1769147199; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hju5Ps3Msz9yMmEFtbt8Zf7haBoqvnNaSpPoh8dCW+U=;
        b=U0NYb3InobdgJbzcx7oiyeZbkGCRK+NUa0uVQe47XCm5+7Y/ILyIVk0MAXGGq2fE5V
         pex0RIhzp8KCqvz+c/NcJt4hgi1bzxdMxCkgq/70uqW4XgtCBRS6jZ9Xg4a20aEO+yHs
         uQu4tDH1h/bUUawC+o4LY908e6CEFs1mpuAbLuMCIpIi6Qbhd/2cKAfDw/hBrSOikmwE
         1PzyKbVuwRI6ezhnc0+E5EqxrVhDiCdB6n3PsoKhfSxj40Y9Yi+Gi2pa5qQYhLOF9R9/
         MfOUXS3hWR+aqlasuIlx1polvPPAhytgCIGuzBAhvj985CsnFf/qExCSVJivSNqhSOBs
         NzQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768542399; x=1769147199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hju5Ps3Msz9yMmEFtbt8Zf7haBoqvnNaSpPoh8dCW+U=;
        b=cdMSvPtSe2nwrIxB1uc7hiLYhZ5bcdQCtEBN+/ar6deydqjRDWNcVqtE/vCJ/1d8cw
         rciZMXMBWM3FxLXo8QmZm81yiQ17bQx6y3UwmwVh6M/L5oyVy5htNj2/wBERJPMsqVgm
         FMLpFaO+yvGPcSsS4o4Ei1ISTqel9Sq9CU/XIBVZ1n5OLH4t8PUNw7/ta479nPWcWh6O
         NNdLZUqLpYKCGlOdiMwZVKNjfM/5Nlxe/t9uZ8Mo89Qs0J3fLYfXWAPQofguqdUwhWPH
         0BaTFREGj5oEpaYvQgJy2AYC9mffA/xKREpvYLcaf0Qm/R2DQv6SxjDSxRkW53Ry1Gvz
         9iAg==
X-Forwarded-Encrypted: i=1; AJvYcCUDvJ83vImyC+WNSOWhpP/JhEWBnDfohaV03nQjYgjYXnHZoTw6353z02xef8XzF8VjlrtcEYRvdHpH@vger.kernel.org
X-Gm-Message-State: AOJu0Yygm23L5kG0gN3GFVVkVT6r1pXpDUFCqgfCFeXV4kmBo/iD934w
	zBM7ygmXHHTfcqyUEWbZl7DtO9tUd/Jy3TMyJTFv+A2h3+dd0hiHYCMS7DKPp5ZL8a1ObHMHHvd
	g7mKsT3SjdeQq/TsgNfoU8KnmXImEg/A3WAI5GYLL6A==
X-Gm-Gg: AY/fxX6rXKdhTG5gFVhPAlo4zVQw1xsI7PW397q0BPx3Hg8xWFE+Cy2UYB11HhakrGK
	6es1QE7+x/zci9PRdTpPmjCFfbBQHLXeb8Ob1N/jVpJyWq/Wg6DLAbmUgA0CLKgqrX3C5o7aXyX
	95lgNUsTN7v2LaTbi+6XRIChUTPk+RA7pQN8gfX7HSgRBCdjNRCkdEaCkLGkRLDjwz8ACa4q/tu
	3IX59oWW9/9ICFzqyTSO2smGZorxHeS82u5tEqHT7KLTHEAt2XVvEmU1xS+8fXgDLhHcohCBqSb
	/U0kALotIAADeWNYnMmzYJNM5XQ=
X-Received: by 2002:a17:907:db02:b0:b87:1c20:7c5a with SMTP id
 a640c23a62f3a-b879329d941mr87685966b.8.1768542399185; Thu, 15 Jan 2026
 21:46:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115175427.290819-1-dg573847474@gmail.com>
In-Reply-To: <20260115175427.290819-1-dg573847474@gmail.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Fri, 16 Jan 2026 06:46:28 +0100
X-Gm-Features: AZwV_QjESD3GpcjIKhvfs2cVjOPZObUAkAVulxGlbOHU23oyu1AtojhouG_cOSw
Message-ID: <CAMGffEk3cgah3-xTaokDeiM0RGwKQn1OO43dWLJAwoaVDfHWdQ@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: pm8001: Fix data race in sysfs SAS address read
To: Chengfeng Ye <dg573847474@gmail.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chengfeng Ye <cyeaa@connect.ust.hk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 6:55=E2=80=AFPM Chengfeng Ye <dg573847474@gmail.com=
> wrote:
>
> From: Chengfeng Ye <cyeaa@connect.ust.hk>
>
> Fix a data race where pm8001_ctl_host_sas_address_show() reads
> pm8001_ha->sas_addr without synchronization while it can be written
> from interrupt context in pm8001_mpi_get_nvmd_resp().
>
> The write path is already protected by pm8001_ha->lock (held by
> process_oq() when calling pm8001_mpi_get_nvmd_resp()),
> but the sysfs read path accesses the 8-byte SAS address without
> any synchronization, allowing torn reads.
>
> Thread interleaving scenario:
>
>            Thread A (sysfs read)     |    Thread B (interrupt context)
> -------------------------------------+-----------------------------------=
-
> pm8001_ctl_host_sas_address_show()  |
> |- read sas_addr[0..3]               |
>                                      | process_oq()
>                                      | |- spin_lock_irqsave(&lock)
>                                      | |- process_one_iomb()
>                                      | |  |- pm8001_mpi_get_nvmd_resp()
>                                      | |     |- memcpy(sas_addr, new, 8)
>                                      | |        /* writes all 8 bytes */
>                                      | |- spin_unlock_irqrestore(&lock)
> |- read sas_addr[4..7]               |
>    /* gets mix of old and new */    |
>
> Fix by protecting the sysfs read with the same pm8001_ha->lock
> using guard(spinlock_irqsave) for automatic lock cleanup.
>
> Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
As James commented, sas address is uniq, not something changing all the tim=
e.
Do you see any real issue?
> ---
> V1 -> V2: Use guard instead of lock/unlock pair
>
>  drivers/scsi/pm8001/pm8001_ctl.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm800=
1_ctl.c
> index cbfda8c04e95..200ee6bbd413 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -311,6 +311,8 @@ static ssize_t pm8001_ctl_host_sas_address_show(struc=
t device *cdev,
>         struct Scsi_Host *shost =3D class_to_shost(cdev);
>         struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);
>         struct pm8001_hba_info *pm8001_ha =3D sha->lldd_ha;
> +
> +       guard(spinlock_irqsave)(&pm8001_ha->lock);
>         return sysfs_emit(buf, "0x%016llx\n",
>                         be64_to_cpu(*(__be64 *)pm8001_ha->sas_addr));
>  }
> --
> 2.25.1
>
