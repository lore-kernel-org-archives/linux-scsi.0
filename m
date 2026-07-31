Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43D237DAD5;
	Fri, 31 Jul 2026 20:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785528731; cv=none; b=WJhvBp4iwKRA+aBng2OsLPz2p3pXPLHWcLyK3WnhYk2D16lAsO8gC976VuaLLMcqNkFMQAOtKUn8iTF7B827oMfOarJD03AhdR17IJGTYGmYE3thyD1sgHDuOk7uyv6iU2A7sU3/po92yBwvi+Xq7hXg3u0m0QyUwwvW17uHKmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785528731; c=relaxed/simple;
	bh=YjZT6YoSR6OQoqIAM5GNSEGQmHFxSo0tYoQohnu1WKE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pJil1Awzq85qlrmcC+EvvL4yy28B/YZFgMhuV3yvOspjBzh9gdsZbLPzg6F/TaIf4Oh/DUb3yZcGE/IMTMxsnxDhlCCZ5EqJZ4pAiVfLmKpv9A54zIkvv3F9UmSR8WJT8XM4Tn3xRh+3b0d/EAyGKYsPl4gAxfB1dnz5+8EMOx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5byKkIk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5byKkIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3653C1F00AC4;
	Fri, 31 Jul 2026 20:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785528730;
	bh=gOsd1WK/jYVoH+aRTsIWYKLjrnNYrDBxquT/JXt33EI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k5byKkIkYSnlauNrsElbL5UMPvlC9RLaYPySz4V6ctzTLqGM4FiDz2ybltzK6TGT9
	 KQP46jTlfzR0SrTOypB1/UmBl6dzGSxGQ9e7IvntRzp1XRfdMRTOwa5kcG6AO43PCB
	 S0zr2pr35+NIOm4VL3KAJ6tMbKvQElDZou6PuLS9bqY01cNikbAD7eURHmR2UXXmGM
	 4cGmHwHsJ+HDv8idK3+cyAswdaLH8MHrckLsg70j5Hc0dQZu2mSoBspfPtR8WTaJIU
	 BdL/3HgJPr4IacSI7q5HJav6jWvrxCftoLKIXmJq1adA3KLJZsswtIwxZvnI6rG+tF
	 qwv6ImQ7cU5AQ==
From: sashiko-bot@kernel.org
Subject: Re: [RESEND PATCH net-next 3/6] hv_netvsc: Remove GPADL teardown
 special case for old Hyper-V hosts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Kelley" <mhkelley58@gmail.com>
Cc: linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20260730201123.1767-4-mhklinux@outlook.com>
References: <20260730201123.1767-1-mhklinux@outlook.com>
 <20260730201123.1767-4-mhklinux@outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 20:12:09 +0000
Message-Id: <20260731201210.3653C1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] If GPADL teardown fails, the receive/send buffers are mistakenly r=
eturned to the kernel allocator via vfree() instead of being intentionally =
leaked, creating a guest memory corruption vulnerability (DMA-after-free).
--

--- Patch [3]: [RESEND PATCH net-next 3/6] hv_netvsc: Remove GPADL teardown=
 special case for old Hyper-V hosts ---
commit eeed9aa2167381d7fb4f1e329217b52e4689eb18
Author: Michael Kelley <mhkelley58@gmail.com>

hv_netvsc: Remove GPADL teardown special case for old Hyper-V hosts
   =20
With the overall removal of Linux support for running on Hyper-V
hosts earlier than WS2016 and Windows 10, the special case handling of
GPADL teardown is no longer necessary. Remove it.

> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 4d319c50955ed..4295b96b43127 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c

[ ... ]

> @@ -733,14 +724,9 @@ void netvsc_device_remove(struct hv_device *device)
>  	/* Now, we can close the channel safely */
>  	vmbus_close(device->channel);
> =20
> -	/*
> -	 * If host is Win2016 or higher then we do the GPADL tear down
> -	 * here after VMBus is closed.
> -	*/
> -	if (vmbus_proto_version >=3D VERSION_WIN10) {
> -		netvsc_teardown_recv_gpadl(device, net_device, ndev);
> -		netvsc_teardown_send_gpadl(device, net_device, ndev);
> -	}
> +	/* Must do the GPADL teardown after channel is closed */
> +	netvsc_teardown_recv_gpadl(device, net_device, ndev);
> +	netvsc_teardown_send_gpadl(device, net_device, ndev);
> =20
>  	/* Release all resources */
>  	free_netvsc_device_rcu(net_device);

[Severity: High]
This is a pre-existing issue, but I noticed a potential DMA-after-free
related to these teardown functions.

If vmbus_teardown_gpadl() fails inside netvsc_teardown_recv_gpadl() (or the
send equivalent), the code attempts to intentionally leak the buffer rather
than bugchk:

drivers/net/hyperv/netvsc.c:netvsc_teardown_recv_gpadl() {
    ...
    ret =3D vmbus_teardown_gpadl(device->channel,
                               &net_device->recv_buf_gpadl_handle);
    if (ret !=3D 0) {
        netdev_err(ndev, "unable to teardown receive buffer's gpadl\n");
        return;
    }
}

However, because net_device->recv_buf isn't set to NULL on this error path,
execution continues to free_netvsc_device_rcu() just below, which ends up
unconditionally freeing it:

drivers/net/hyperv/netvsc.c:free_netvsc_device() {
    ...
    if (!nvdev->recv_buf_gpadl_handle.decrypted)
        vfree(nvdev->recv_buf);
    ...
}

Since the GPADL teardown failed, does the host still have this memory mapped
when it gets returned to the kernel allocator via vfree(), leading to
potential guest memory corruption if the host writes to it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730201123.1767=
-1-mhklinux@outlook.com?part=3D3
