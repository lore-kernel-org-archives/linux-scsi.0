Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BAE03911AF;
	Thu, 30 Jul 2026 22:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785450286; cv=none; b=A+62wYvhY67Wj/4E6Mo083+CFHAoYsnaIs7la9lzELwuk3Lqkh8pl/9HkJFeuFlJsEyr74+KswqeqFSfX0aF0PJrr8SO3SKDimFYj4n8qrxiGa9ae9nZiEw2n28DG0HrpQ+NImEQZV91SQIv5mFJpC3AJ78mUhhwccA7Dwj+QsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785450286; c=relaxed/simple;
	bh=BnYeYCvIYpGQ3W9fmruMxznkg+lLVKqa7Ow2sXgmc+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gEmYn+4Woxo34H+FM3UqqiAi5asR0e5UmHKpMi0eSWUyf5t2uzkQLR88Xq9QkwlBCkBGWOfhw+S9hYX0eKVk/NDkxDW2bx6QI0LGZzF4rH9nDehZu1TVsdAUzp/3pUsQI2yexqexGp3u6Lr5noxbnKoFx4440qveBdpLm4IDlnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=mzGXwP2/; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="mzGXwP2/"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id B2AD920B7166; Thu, 30 Jul 2026 15:24:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B2AD920B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1785450265;
	bh=pqRfRnByDDrmG9mYWVTH89ngmj87IUFru7WB45pYJ1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mzGXwP2/EJNYI5Ns1Yn4bfz1dd3LMSi6jLBf7Ri3GjUlwhBYmOchzbs7DYJ8ENh+C
	 xS2vqJJZwCJGVWwaESGDAbPn2tpt8gE9T7Mc3AWT3/axxnicmibv35KVO0AP0fx672
	 TdaPLOQsvytqTSam/TnsmcH0+QcsBodB7ib2Rg98=
Date: Thu, 30 Jul 2026 18:24:25 -0400
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
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
Subject: Re: [RESEND PATCH 0/6] Remove support for Windows Server 2012/2012R2
 & Win8/Win8.1 versions of Hyper-V
Message-ID: <amvPGQcEqgzWe+yn@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260730201123.1767-1-mhklinux@outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730201123.1767-1-mhklinux@outlook.com>

On Thu, Jul 30, 2026 at 01:11:17PM -0700, Michael Kelley wrote:
> Linux code for running as a Hyper-V guest includes special cases for
> running on Hyper-V in WS2012/2012R2 and Windows 8/8.1. These versions
> were initially released 14 years ago, and official support ended in 2023
> (unless a customer has contracted for extended security updates). Given
> the release of subsequent versions with improved functionality, there's
> no need to continue to support the latest Linux kernels on these versions
> of Hyper-V. If someone is running Linux on one of these older Hyper-V
> versions and doesn't want to upgrade, they can continue to do so as
> presumably they don't want upgrade the Linux version either.
> 
> Simplify Linux code by removing special cases for running on these
> old versions of Hyper-V. This includes removing the negotiation of the
> VMBus protocol versions for WS2012/Win8, and the special case code based
> on those VMBus protocol versions. Changes are in the core VMBus code and
> several drivers for synthetic VMBus devices.
> 
> Some VMBus drivers have device-specific protocols with the Hyper-V host.
> Further simplify the code by removing the use of protocol versions that
> are specific to WS2012/Win8 and earlier.
> 
> Finally, the WS2012/Win8 versions of Hyper-V were the last to use
> messages to deliver synthetic timer interrupts. Starting in WS2016/Win10,
> stimer interrupts are delivered to their own assigned interrupt vector
> (called "Direct Mode"). So remove the code for handling timer interrupts
> delivered as messages. This removal has a broader benefit in removing
> a key blocker to disentangling VMBus code (which handles the messages)
> and stimer code, as they should be independent of each other. The
> final disentangling will come as a follow-on patch set.
> 
> Testing:
> * VM on local Hyper-V on up-to-date Windows 11
> * Added temp debug code to suppress Direct Mode enumeration. Fallback
>   to LAPIC timer worked as expected (x86/x64 only)
> * Azure VM DC16eds v6: TDX CoCo VM with HvLite paravisor
> * Azure VM DC16ads v6: SEV-SNP VM with an older paravisor
> * Azure VM D16alds_v7: normal AMD x86 VM with HvLite paravisor
> * Azure VM D16plds v6: normal ARM64 VM with MSFT Cobalt processor
> * Not tested running in VTL2
> 
> There's no specific urgency to removing the special case code for
> WS2012/Win8, so if the broader Linux kernel community surfaces
> a reason why this clean-up should not be done now, we can wait.
> But I think we want to eventually stop carrying around this extra
> baggage, and based on discussions with the Hyper-V team within
> Microsoft, we're past the point that it has any value.

I do feel that this is a nice cleanup overall, however do we really want
things to break silently if someone does attempt running the latest
kernel on older hosts? or do we want to include (at the very least) a
warning message that indicates that things might be broken (and or
that we don't make any guarantees of future support)?

> 
> Michael Kelley (6):
>   Drivers: hv: Remove support for WS2012/2012R2 & Win8/8.1 version of
>     Hyper-V
>   hv_sock: Remove check for old Hyper-V hosts
>   hv_netvsc: Remove GPADL teardown special case for old Hyper-V hosts
>   drm_hyperv: Remove support for synth video protocol of old Hyper-V
>     hosts
>   scsi: storvsc: Remove support for storvsc protocol of old Hyper-V
>     hosts
>   clocksource: hyper-v: Remove support for stimer interrupts in message
>     mode
> 
>  arch/x86/hyperv/hv_init.c                 |  17 +--
>  arch/x86/kernel/cpu/mshyperv.c            |   4 +-
>  drivers/clocksource/hyperv_timer.c        | 150 +++-------------------
>  drivers/gpu/drm/hyperv/hyperv_drm_proto.c |  33 ++---
>  drivers/hv/channel_mgmt.c                 |   4 -
>  drivers/hv/connection.c                   |   8 +-
>  drivers/hv/hv.c                           |   4 -
>  drivers/hv/hv_balloon.c                   |  36 +++---
>  drivers/hv/hv_snapshot.c                  |   5 -
>  drivers/hv/vmbus_drv.c                    |  10 +-
>  drivers/net/hyperv/netvsc.c               |  20 +--
>  drivers/scsi/storvsc_drv.c                |  53 ++------
>  include/clocksource/hyperv_timer.h        |   6 -
>  include/linux/hyperv.h                    |   5 +-
>  net/vmw_vsock/hyperv_transport.c          |   3 -
>  15 files changed, 76 insertions(+), 282 deletions(-)
> 
> -- 
> 2.25.1
> 
