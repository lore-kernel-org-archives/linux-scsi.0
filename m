Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458A04963CF
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 23:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789601080; cv=none; b=KHTC1CJfH+1IStsDXGqI2WG5tilld18qCuCDmQ5bO/He1bURGxdo4fD3IqhYJKYucqgJky6kQ8DaqFxmqQnVAYEotQiNk0l+mLbxuhnogKUKf9dB4bo9tYeSsc64VBmtp+G9saLmhyHqfqjHRWf1eJghA6rgml/EVGV4++X5+BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789601080; c=relaxed/simple;
	bh=kCo8NIpeVtImq+XmZ5s5uDsee19WteZpfzZLX2DcwQo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gkcW5pJs4fw67j48i/YbzjXif211P8BVyJa8RnGg4s8FKZL3LZQThnhPENMmzMHdDdePfDUcqwhPhsQnSbfn4hyBLYQc7qpzdE+jECv9ZLzXFXnLvkb4NuJHPz4hWEsiZwzkIkNYLTC6JEJpQ8WXOxradcvXiLaQHBpXi3MRhFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZuTGfLGU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZuTGfLGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AE11F000FF;
	Wed, 16 Sep 2026 23:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789601078;
	bh=hxnJQuB8QyyjpNj5IBp6TyQXSFvPXS6UP3PXA63KFw4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZuTGfLGU/FjZbJR2tJGRIsPgcGljnMnyNlak8CNm2W0Sm6mHxmIDRwoxoW8okF7EL
	 8I6pauRv9HGksrvAQsiboUWkWvr7fByrOOqSx2XonoOdwL61NhoDNwFGKhWqmhaLSz
	 Cjru7Urt2eNr9tfFIHIRc0qlbFp/oPrAn0HHOQpeI8AETiAdePRrNM+M5BHDkWf00u
	 EYviA9EqGO76w6eUme8PDf3m5W2vAoblBgFSi2cqJTrwiseX28SQfHKbKl/q4YxAhJ
	 cZB8MW57o1OmWSIGsmY9O7FIAUxCQSvTlWQj+i84mKzd1FQWEUaImuEk0Zynb/hOGH
	 YuoIKkDWNwTnQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/20] scsi: ibmvfc: complete NVMe FCP requests on
 H_CLOSED send failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260916230921.2204729-4-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
 <20260916230921.2204729-4-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 23:24:38 +0000
Message-Id: <20260916232438.C6AE11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] scsi: ibmvfc: double completion and UAF on NVMe H_CLOSED error=
 path
- [High] scsi: ibmvfc: invalid assignment of -EBUSY to unsigned NVMe fcp_re=
q->status
--

commit 09b742c396cef74ab36e606d794a591d97008dc8
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: complete NVMe FCP requests on H_CLOSED send failure

When ibmvfc_send_event() returns H_CLOSED the event is freed without
notifying the NVMe-FC transport, which left the transport waiting on a
request that was silently dropped. This commit fixes the hang by explicitly
completing the NVMe FCP request with a busy status before freeing the event.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 6c243b2a84d7a..26a73db662545 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -1845,6 +1845,10 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
>  				dev_warn(vhost->dev, "Send warning. Receive queue closed, will retry=
.\n");
>  			if (evt->cmnd)
>  				scsi_dma_unmap(evt->cmnd);
> +			else if (evt->fcp_req) {
> +				evt->fcp_req->status =3D -EBUSY;
[Severity: High]
Does assigning -EBUSY to fcp_req->status result in an underflow? Since this
field is an unsigned 32-bit integer, -EBUSY (-16) becomes 0xfffffff0.

When the NVMe-FC completion handler nvme_fc_fcpio_done() checks if this
status is non-zero, it might translate it into a fatal
NVME_SC_HOST_PATH_ERROR instead of recognizing it as a retry request,
potentially causing a permanent I/O failure rather than a seamless retry.

> +				evt->fcp_req->done(evt->fcp_req);
> +			}
>  			ibmvfc_free_event(evt);
>  			return SCSI_MLQUEUE_HOST_BUSY;
[Severity: Critical]
Will this lead to a double completion and use-after-free? When
ibmvfc_send_event() returns SCSI_MLQUEUE_HOST_BUSY (which is a positive
value), the caller ibmvfc_nvme_fcp_io() propagates this non-zero error code
directly back to the NVMe-FC transport.

The NVMe-FC LLDD API contract requires that if the fcp_io callback returns a
non-zero value, it signifies a synchronous queueing failure, and the driver
must not call fcp_req->done().

Because the NVMe-FC core executes its own teardown path that unmaps the SG
list and completes the request when the fcp_io callback returns non-zero,
invoking done() here inline causes it to also be completed asynchronously,
resulting in a fatal use-after-free and double DMA unmap.

Should the driver instead omit calling done() completely and translate the
internal SCSI_MLQUEUE_HOST_BUSY into -EBUSY as the direct return value of
ibmvfc_nvme_fcp_io() to correctly signal a transport retry?

>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916230921.2204=
729-1-tyreld@linux.ibm.com?part=3D3
