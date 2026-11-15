Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794746009;
	b=Kt0bKsHz/g/xZ12dTQxyg9TyG8wrul1yEkQUnRMql4e94UtGBre22SYE2J2kmP1sr4wD
	 yiJ23hhTOcqf/yXbZy3X9sqpYDR4uH7xduFrrtPBVT3vNHPTnEbAxbYCCaiXYyo6q3MFP
	 i907TIEo5WvS9xE83ts/B5KrbZPCQJR/+JmAA0cTVD8BK29uUOkZOnlGDPRHSTR39Lw/t
	 g1pew/LnqDIYl1cHjQJOmLbTzsRlDKQVatIiIm8clNy1RdPEieZLhCnO+tDOCWEaZLIvA
	 DmTnVg3rTahimpdfyvAMHksMZO7LOwNFWg5b4yxz8jQvb/vK2FmLkbn/URsG8MIkzpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794746009;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=y64iy0pqD08/Ai/03CFQy91l7Ilihgu041YxkWheTK4=;
	b=Chq6OXz6LPdmiB63+RBEONxNdKZ6+2jH/rHsXWizyJLmWJuEHa7Nm7kOagJHQHehSpuD
	 UI+HP9FI19acCaZcUXtjr/1PspdI3Mr3dWNcMfzDsFcfoXU1NXN6NqM+Q8qlfgug+rLhY
	 rJ1uk+wuKCciAawiKxrAa3BtBNYGzFkSuEwr+mqYm2u0a4cz7hi2bsRyyxQbz6tgWXnep
	 u9gpL9ymvVWBQQiYoaAN9A6BjfKBYx9RlOtsKoi8T3/YBcK3EZSbR/apvzrsRLFVPqR1G
	 S65EWrkLnZK6TqtMhKjE2M4WiDpNspvDfFZtCER8nHpBp0saeEYoZqbcZGPEp8dEoPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BsWFNbWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24AC606A31A
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 12:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BsWFNbWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD041F000C4;
	Sun, 15 Nov 2026 12:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794746008;
	bh=y64iy0pqD08/Ai/03CFQy91l7Ilihgu041YxkWheTK4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BsWFNbWikC6Lz9LJ9ebtFmY3YzQWCTKYEzMW1PZl+8i05KtDVEYc0BQVR+qoLvegR
	 ArteNBP/7cF/C3fHqZ6+vIFd7ZsmEvynjyaE6Ja8SeVFFYxnh3JeLB8ayhK8EF0QqI
	 sw1TlZ0zsoYAl4N9CVKYMA3BFbLy/E3DI4c1rycNq3f8iKS0wGZKROTLGVXaqtxgEh
	 vyOgQ96JIfQ4tp/FsiM3XbrqnBY/R0ayGhilyR0ezhYGNUuGuzikIyDie2KtHfBLr4
	 2AW9bNSW1AU3dECZnAYTcQqV9NZhzc1pwka/ZRUBHJNe1PpKV7f/7lzfOT+CIQcsy9
	 wZ/XIsLvBqVFQ==
Message-ID: <sashiko-outbox-215499@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] scsi: mvumi: flush the event work before the
 host is freed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261115122153.1446810-4-yhlee@isslab.korea.ac.kr>
References: <20261115122153.1446810-1-yhlee@isslab.korea.ac.kr>
 <20261115122153.1446810-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 12:33:28 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] scsi: mvumi: mvumi_release_fw() called before
  pci_disable_device() on error
--

commit 4d0117b39b9433095d582919461757b3980ec9e3
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: flush the event work before the host is freed

This commit gives mvumi a dedicated workqueue for event notifications and
flushes or destroys it during probe failure and device removal before the
host is freed.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 48652640afc18..f58b29e55a377 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c

[ ... ]

> @@ -2560,9 +2567,12 @@ static int mvumi_probe_one(struct pci_dev *pdev, c=
onst struct pci_device_id *id)
>  fail_io_attach:
>  	mhba->instancet->disable_intr(mhba);
>  	free_irq(mhba->pdev->irq, mhba);
> +	flush_workqueue(mhba->work_q);
>  fail_init_irq:
>  	mvumi_release_fw(mhba);
>  fail_init_fw:
> +	destroy_workqueue(mhba->work_q);
> +fail_alloc_workqueue:
>  	scsi_host_put(host);
> =20
>  fail_alloc_instance:

[Severity: Medium]
Does fail_io_attach free quarantined DMA buffers in mvumi_release_fw()
while the controller still has bus-mastering enabled?

Because flush_workqueue(mhba->work_q) runs after free_irq(), any queued
mvumi_scan_events() work times out in mvumi_issue_blocked_cmd(), and
mvumi_delete_internal_cmd() quarantines cmd->data_buf and cmd->frame onto
mhba->res_list to be freed only after pci_disable_device().  However, unlike
mvumi_detach_one(), this error path calls mvumi_release_fw() ->
mvumi_release_mem_resource() before fail_set_dma_mask calls
pci_disable_device(pdev), so dma_free_coherent() returns those buffers and
mhba->handshake_page to the allocator while the controller can still DMA to
them.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115122153.1446=
810-1-yhlee@isslab.korea.ac.kr?part=3D3
