Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792476292;
	b=v0zyp2LE2vTos7AWodbU7qziUpVpf5p5KLT7bnbdpRsLecp+rQXMA1TFTOYxBACcUTR7
	 wcO/xaQRr/4S0jdD5DICdMwZG1k0K4DT0mL1bmuQtfy0DCGn0ab+AeG9Wn3lVXVwaGFPA
	 ctjHZ+Ipxhv9P59w9+HhyavIolYmWj+WpXyUKm2JcBcx00dmwh7YN2I1k9KWIfGVOBHUC
	 FFWZGyn0ae3uzEOMhBHfDeZiNKNx783vYMvFHp0zOarLRjA9CzVfAMolskKLOI3o2bifc
	 GDwJyfCHeNQzLBamdnGVzqiTnywqTCsC+3br6R3QPUuxUkdmS8MagkzoGoJ+wibowmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792476292;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=rQqFxEC/LlvMiwUar68b8H+DzYLlRZlQd9Usb1HL9CA=;
	b=S8iQ4kVkd7UBl47EyRxuqT8icxmUT5aicD2/yMyY+fUh/TzPjrXkNNSQWL4OweMVASz1
	 +ulB1KUL7NiUDbv0VMzV1TGKOKJj+NK0+pYh2ZLVzBG3yj9/JoSthmJMULgOjDrHlAL6c
	 6ziZcvsE3EmAX4sJFgQXEDUA0HlWNdtAjfmBWmDpqI1GPKg6ynV3z6Eg7lqjn0xfImSfd
	 WlVvzAdazGkagZCkSO7SmOWkIC6c86MGHSb1a+dHJK5z7jVXu/oW0PIUlGWMI4LM6LPWH
	 RzHEnvRWjoUQkkVIyzc0moC+4KJ94fTgWNc8fWRPWidDRFRb1DOhNzhmxsbu9YVui8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zon0lnby;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960C0606A31C;
	Tue, 20 Oct 2026 06:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zon0lnby
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1881F000C4;
	Tue, 20 Oct 2026 06:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792476291;
	bh=rQqFxEC/LlvMiwUar68b8H+DzYLlRZlQd9Usb1HL9CA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zon0lnby0Lm4ap+qIbwrlj4VJWZocAJUJeDAlvKvDZ1ewa1tYp4mTlhTphpaE2lTV
	 TR9ImDQ8jfEaq4+PX2FlwKbRHqV3ZTiggnI/F8mj+wz44G3Ct6YcqVrf9DG6VgYCPm
	 qtxbOAH0Wh3Q+kLg1FuTXP9qvP5Q0JuE1CAOtDzY=
Date: Tue, 20 Oct 2026 08:04:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yu Zhang <yuz08559@gmail.com>
Cc: Mike Christie <michael.christie@oracle.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-usb@vger.kernel.org, target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] usb: gadget: f_tcm: NULL-ptr-deref / use-after-free when
 the UDC is disconnected during in-flight target I/O
Message-ID: <2026102035-unsure-garland-2281@gregkh>
References: <20261020052629.92551-1-yuz08559@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020052629.92551-1-yuz08559@gmail.com>

On Tue, Oct 20, 2026 at 03:26:29PM +1000, Yu Zhang wrote:
> Hi,
> 
> f_tcm frees its per-endpoint USB requests on the teardown path without
> waiting for in-flight target_core commands to finish, so a command that
> is still being processed by the backend when the gadget is disconnected
> completes into freed/NULL request memory.

Great, can you submit a patch for this?

thanks,

greg k-h
