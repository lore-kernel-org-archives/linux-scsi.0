Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D0113959D;
	Thu, 30 Jul 2026 20:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785444474; cv=none; b=POr8dd5o1axum973wNTEnju0mp3GDtvMBQ1WqI3S7ndqxxoM1ejtKtdd6fSqZBjAxlQKCnVztAfD5okX6pOuTRUd8tv/C/lWkB8LhzldBmZPKSwAyi3Ek69C+V4VGd5bkEIxqL6M7GOqcjli4YpY06UVwk6btZjCbAxWGzcZnGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785444474; c=relaxed/simple;
	bh=LgB0EJLtU2FGnOzqpmmvPddiayHPb3U+NyYHgqiNP0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oWzb6IZXihZ+lmOB7UINMQbdhyIj3ac3CVs31+PbFZiGhn+k/9QbkVCCv3ULJWL+11rICdac/QEfYk+fWkW/ZLi6Ad9tgWQPBXKTYyJiDZt67AC7p7woloNGjelmnWN7Iz2+toweVBlu6ZoPVB7KojOqMfD+QWos3XTarTm2k9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=zjXHXN6T; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="zjXHXN6T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=TY0IrMd0BC7glBD9LmPPRPksKcbqLLy1R8rWMvMhY3s=; b=zjXHXN6T9IIYrzafBdCljZ0rLr
	u84tNPG6iIDJur/mLvwyU0WBAYrfGIuWjrdfD77QcaWHRnh2usgGs17HwYpsHlZAzCmHWsmAvLcnx
	rQ1iu3TS6giWCcqDhuJxKkvw6V8PhGeCOJGEw/cfLaaiUbMF5bnVuZq+3t6iUEpVh/+0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1wpXeb-00F3qd-3F; Thu, 30 Jul 2026 22:46:57 +0200
Date: Thu, 30 Jul 2026 22:46:57 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: mhklinux@outlook.com
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, longli@microsoft.com, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	hpa@zytor.com, daniel.lezcano@kernel.org,
	ssengar@linux.microsoft.com, maarten.lankhorst@linux.intel.com,
	mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
	simona@ffwll.ch, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	sgarzare@redhat.com, horms@kernel.org, x86@kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org, virtualization@lists.linux.dev
Subject: Re: [RESEND PATCH net-next 2/6] hv_sock: Remove check for old
 Hyper-V hosts
Message-ID: <04e5274c-b44c-4b59-998c-1af2f58883c1@lunn.ch>
References: <20260730201123.1767-1-mhklinux@outlook.com>
 <20260730201123.1767-3-mhklinux@outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730201123.1767-3-mhklinux@outlook.com>

On Thu, Jul 30, 2026 at 01:11:19PM -0700, Michael Kelley wrote:
> With the overall removal of Linux support for running on Hyper-V
> hosts earlier than WS2016 and Windows 10, the check for such versions
> during hv_sock initialization is no longer necessary. Remove the
> check.

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

Please don't send new versions of a patchset within 24 hours. You need
to give reviewers time to review your patches. And if there is
discussion, please wait for it to reach a conclusion.

    Andrew

---
pw-bot: cr
