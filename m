Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794580560;
	b=jpjlX65E7dVlOQowyVsBX+/I2tO4Y4NCxTsyS7retd/6yZhteIS7GZQtseTm9LVMKIUW
	 VKv+PbbKNUmyFT5AJhMEvYbfAFNJyCBt+Q5nCXIwaBL63GQ5wGwu2c8LewXohAi4E9Fin
	 NMpZ4pEMPZmdDRdCRmCETAsOnVYbAziKcnqx8VS+X8tHcXM0T56A9L/7P5CnZfG4AOj6K
	 AZlgrJWkpy6wfS7sZUP6WC44fWRNPSBxtKQD0B+lH2/tdWj76kgXk78SZRSBGOBuTxc7X
	 2D+Wy247LXVOLizrdz/0RBnLWGXvNB7VoFKQ9KfkbiQfDHA9c6OLAzQVGvGw1s8T8Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794580560;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6CApjWzc8o2s4OsWyzjbJDLb4t6rT+GkzIwDqfO2u3M=;
	b=zHAwjDt1NQ/vs7P75gyIB6Fs6Q02MlklPhnvh/vprHs1RgUjE+cnFh1HjPvfJHpzYZ0g
	 e4doL7RlElXa4YPFQiVroxTt+mOOlljC0hxBb157cntcxo7xBrEy6P4KIt2bvgJFdYyGH
	 K78avd3k/qQLL4JiDnhAf37zeh+aAntZuXsrQimjRUoYMsDII6eD1IQPeoKWHjInBCa1o
	 7VBy8+BGDQQvED+DnJxCQABYAiboy3/QsuqQw9rys/BA+FUi1X8jsd6cSgyn9BKoJT5FE
	 LychvWkLFICuwEz0FF3FfcWyob8bNOykXYa9oTBMbt/hARfsUN6YJjUEudXjSunmdFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bxf25c1T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CB8606A331
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 14:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bxf25c1T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA1E1F000C4;
	Fri, 13 Nov 2026 14:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794580560;
	bh=6CApjWzc8o2s4OsWyzjbJDLb4t6rT+GkzIwDqfO2u3M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bxf25c1TZSS+X2WyAHlvF4K7fWlZXX5qBqCLQaXO2ArW4wGc+agZCB6pfdZcDJ7Z3
	 LHUd3EBRDab+glI+oUp4XU1IyRfvsTn4HMTeAZrArTb9an05wY1tDA575j2/gocDgt
	 6hJjxG99NuyoJy4wQusHBhIKotVT87/y79Q19zPPlQCUU6xuMMKYpEbMClCZlyPFHY
	 QQmdxDI8EswIQIPuam9uODoScNg4n6bvTcTO4OgXy/ITdmpgtbSz+0OkN5bmj2Mood
	 bKfakvodsxQF0Y3hzLdwglih6C15w16PCNs3tTPpu4N5DaEnj+Pri+vMgbQiwoGgPO
	 vfDTckqjkcPWw==
Message-ID: <sashiko-outbox-212996@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mptfusion: Fix potential chain array leaks on
 attach failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guangshuo Li" <liguangshuo@mail.sdu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261113-4e14e563a1-scsi-mptfusion@mail.sdu.edu.cn>
References: <20261113-4e14e563a1-scsi-mptfusion@mail.sdu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 14:35:59 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] message/fusion: lockless list modification in mpt_attach()
  [1]
--

commit bd21a339f04c74107336a8df0b58bbfb54c0a200
Author: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>

scsi: mptfusion: Fix potential chain array leaks on attach failure

This commit frees the ChainToChain, RequestNB, and ReqToChain arrays in
mpt_attach() when mpt_do_ioc_recovery() fails during adapter bring-up.

> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mp=
tbase.c
> index 3a431ffd3e2eb..a0592404472cc 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -2015,6 +2015,9 @@ mpt_attach(struct pci_dev *pdev, const struct pci_d=
evice_id *id)
>  		destroy_workqueue(ioc->reset_work_q);
>  		ioc->reset_work_q =3D NULL;
> =20
> +		kfree(ioc->ChainToChain);
> +		kfree(ioc->RequestNB);
> +		kfree(ioc->ReqToChain);
>  		kfree(ioc);
>  		return r;
>  	}

[Severity: Critical]
This problem wasn't introduced by this patch, but can uncoordinated
modifications to the global ioc_list [1] cause a use-after-free?

mpt_attach() and mpt_adapter_dispose() add and remove ioc from ioc_list
without holding any lock.  Meanwhile, mptctl_fasync() iterates over
ioc_list under mpctl_mutex (which is private to mptctl.c and not held by
writers), and mpt_verify_adapter() iterates over ioc_list without any
lock at all.  During hotplug or sysfs bind/unbind, a reader can traverse
a broken list pointer or access a freed ioc:

CPU0                              CPU1
mpt_attach() / mpt_adapter_dispose()
                                  mptctl_fasync()
                                    mutex_lock(&mpctl_mutex)
                                    list_for_each_entry(ioc, &ioc_list, lis=
t)
  list_del(&ioc->list)
  kfree(ioc)
                                      ioc->aen_event_read_flag =3D 0;  <-- =
use-after-free

[1] https://sashiko.dev/#/bug/linux-3331f265-1868-460b-9ec0-3fe42034986b

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-4e14e563a1=
-scsi-mptfusion@mail.sdu.edu.cn?part=3D1
