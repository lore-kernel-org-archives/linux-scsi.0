Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C63C429811
	for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2026 06:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783318950; cv=none; b=WaAzuw8TcZNzmu1OCFBO4GIx9q4LdnSJMihoLJndHPSom89G+IbEXS3jE041hD62Y8EINAjJV1qvfmDYK5CrSnYgLpJOIi9XDxvPlr/ySRlLe8Y73umvLrm08Y/TmG0+Q0bglkFSEH6XtcT8LA+5/Gk4/IhudjCgn9QSXdq5qzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783318950; c=relaxed/simple;
	bh=efzKjDZijOjRd4MF7DmkC/VG68tjPZCWbDF4QacBCAU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NDvhGpHceT+YFzj5F+jOlcUeW/4piVJq2wKzpMYMldxMz2/aKzvhvqeBm/gNmL25ODD8/4But9469/wRDPH8LX14CNlvA3WUXnZxUIi4RyFgxnFDGMqMhgjAV1NjEQV0ho3a6vfz7GvjqUNNuCTWD1ITva3VmsicH8jwFtLQkyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kmNg3XMC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kmNg3XMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAF81F01567;
	Mon,  6 Jul 2026 06:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783318941;
	bh=kwa8e3pwbtHmRDzCnJJ668Um64LxikooHJCDEWDDz1c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kmNg3XMCLnUVk7UtQFm6OBoMtNIDp4TWPNN1MdWJHdf7XvEAqTwsqOrGfl3sNmS7z
	 i0u5zaUnUGnBldK/kInm4zV3r7AukkoRF7/7t6jj4RqoD4EQF8P1zRtctBmWAfyaiw
	 pok0bEtoPeEWGbb5p83rd1sLPAIZbz7Acx+HmqmuOcDNZmhbTO2Bxuiag+LO48yO8x
	 AI8Tb6CttCKsTVQfB7aHU1qoc+2kH8ohNJRvV4xZh+rV41adWoIxhpmxm7buzJb86M
	 CA/xMEFghbiY6c8oSlpuK7D/TvIgxXeoqP6zIOgIDrwGcFO4fL33PvNI8C7e4zK5Gr
	 Dhgd1jVc9uZkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: fix invalid kfree of embedded event_data
 in event callback
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260706060840.2287-1-lirongqing@baidu.com>
References: <20260706060840.2287-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 06:22:20 +0000
Message-Id: <20260706062220.CBAF81F01567@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The driver queues delayed works for firmware events but fails to c=
ancel them properly during module unload and host removal, leading to a use=
-after-free and workqueue corruption when the delayed timer eventually fire=
s.
- [High] Integer overflow in firmware event size calculation leads to out-o=
f-bounds read on the kernel heap.
- [Medium] Missing bounds check on EventDataLength allows out-of-bounds rea=
d from the DMA pool, leaking data to userspace.
--

commit b3e94f572f1eaa0696e3b47cd0fd8d836c959627
Author: Li RongQing <lirongqing@baidu.com>

scsi: mpt3sas: fix invalid kfree of embedded event_data in event callback

This commit removes an erroneous kfree(fw_event->event_data) call in the
MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST error path. Since event_data is a
flexible array member embedded within the fw_event_work structure, freeing
it separately is invalid and can corrupt the heap. The extra kfree is also
redundant because the subsequent fw_event_work_put() frees the entire
structure.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 12caffeed3a0d..ca01a496f14c7 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -12267,7 +12267,6 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPT=
ER *ioc, u8 msix_index,
>  		if (!fw_event->retries) {
> =20
>  			ioc_err(ioc, "failure at %s:%d/%s()!\n",  __FILE__, __LINE__, __func_=
_);
> -			kfree(fw_event->event_data);
>  			fw_event_work_put(fw_event);
>  			return 1;
>  		}

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing this function
I noticed the size calculation can silently overflow:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:mpt3sas_scsih_event_callback() {
    ...
	u16 sz;
    ...
	sz =3D le16_to_cpu(mpi_reply->EventDataLength) * 4;
	fw_event =3D alloc_fw_event_work(sz);
    ...
}

If a device provides a large EventDataLength (e.g., 16385), le16_to_cpu() *=
 4
will overflow the 16-bit sz integer, wrapping it to a small value like 4.
alloc_fw_event_work() will allocate memory using this truncated size.

Later, could _scsih_sas_topology_change_event() cast this small buffer and
read fields from uninitialized adjacent heap memory, potentially causing
unexpected device removals or a denial of service?

[Severity: High]
This is a pre-existing issue, but does this code properly cancel the timer?

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_fw_event_cleanup_queue() {
    ...
		if (cancel_work_sync(&fw_event->work))
			fw_event_work_put(fw_event);
    ...
}

The driver queues delayed works for firmware events but calls
cancel_work_sync(&fw_event->work) instead of
cancel_delayed_work_sync(&fw_event->delayed_work) during module unload and
host removal.

Could this leave the timer active, leading to a use-after-free on the ioc
structure and workqueue corruption when the delayed timer eventually fires
after the ioc has been freed?

[Severity: Medium]
This is a pre-existing issue, but does this memcpy read out-of-bounds from
the DMA pool?

drivers/scsi/mpt3sas/mpt3sas_ctl.c:mpt3sas_ctl_add_to_event_log() {
    ...
		event_data_sz =3D le16_to_cpu(mpi_reply->EventDataLength)*4;
		sz =3D min_t(u32, event_data_sz, MPT3_EVENT_DATA_SIZE);
		memset(event_log[i].data, 0, MPT3_EVENT_DATA_SIZE);
		memcpy(event_log[i].data, mpi_reply->EventData, sz);
    ...
}

The function calculates event_data_sz from the untrusted EventDataLength
field and clamps it to MPT3_EVENT_DATA_SIZE (192 bytes), but fails to check
if this exceeds the actual hardware reply frame size (ioc->reply_sz,
typically 128 bytes).

Could the memcpy read past the end of the reply frame, pulling in data from
adjacent reply frames in the DMA pool and leaking it to userspace via the
MPT3EVENTREPORT ioctl?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706060840.2287=
-1-lirongqing@baidu.com?part=3D1
