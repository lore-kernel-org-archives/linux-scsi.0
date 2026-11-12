Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794503876;
	b=mUqnESIeq/ymsAmp8Q4KAGKk07Bmpd6Z6c9p9p8EN7IBF4ObEBZzP83DhzeHfaHCyx/D
	 ce5HqslU5MDrJnCm71C6sfElkLD9ZgNnelNCTVb+7iLZMWaRKhE+Pugb1KTAD1V+SwWPL
	 jf+tNW7yZkB69RvijNtWqc795etdUa3p4AiaflBNf/7a4l4HtCcNZ91EWbtyzb5MDqTdK
	 L6g75FSwo6PUBOuKcvXHrVL9Ce/LmPNUF5eyBaT8wmQ0NNy1k2cmySvFGiC2MWBOBUwis
	 PhzxLqkfTWL2nCBcZLFxCjHmaSvFoWXRdHw6c3WJlsRMgMuzyxSpqPWXa4iICvlg4uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794503876;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=VMi+hIkLWXT7siLEN9ATyCll+A1V4GrHFAEeCBcDPio=;
	b=25EheIKy2mCkG8KJlAlZepDJWxlqrKr+5BN9JIO/HMNByML0t0lLkBu4Zaf+7kH51Lny
	 DYkTXFwlZAsxwcsi6YduH5D+XS8Cwdq0kv1PlDhwN855MVJSaJKkXLjBdPgdRQJLN2vBG
	 r8eaGZpfhZWDUlNj50PVceX+1SYrhFq0+W6oaO2XHMr7+IvXMfoNo9xTuD67DEyKFI4cc
	 t/hPuGPnNt48OnmjFSR//Min+O/yId5ZzT7zdZc3v+1wT8ayhWQ4tKB0h70EOEV/tvaj5
	 B5kL53GbKUfL5e3XjxkJAlyDyBkN5VKE1prug4a3OFXHrhXPTY941KK7co0zesIKq3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xi1M0Wrq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F8A606A321;
	Thu, 12 Nov 2026 17:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xi1M0Wrq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9171F000C5;
	Thu, 12 Nov 2026 17:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794503876;
	bh=VMi+hIkLWXT7siLEN9ATyCll+A1V4GrHFAEeCBcDPio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xi1M0WrqH5bMvx0n0pi4w5v7a8qJzrxjW4xzgjyJBTk4w5Ha9LDFHd8Q2SIO4bI0/
	 R1AH44wKcxNJXbaWLeAun1BY623lBE7mWeM8MlocaX0VT4oGCtm1o/G3AsbPIXS1Ln
	 HAfe4Gi1tJJQuDHDrzTAcmJcvP7xkP9KNg6uFt8kIbAQS0k0mQOiMe1zrTRcGbMEAP
	 QjV4y8GkI+IFa+IR6J9g75IGth5ijUGZ2Wd4tjx81In8/mDCI0Hl19n37GOo0mpyES
	 RMm1owYYSjXmybNXysJzMRsSMwbMIAEWBzrarLAWP33yYlnJBqzwDlRjfOGVF8svjx
	 eUQ0ymv8EqhZg==
Date: Thu, 12 Nov 2026 09:17:55 -0800
From: Kees Cook <kees@kernel.org>
To: Bence Csokas <bence.csokas@arm.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Jes Sorensen <Jes.Sorensen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <groeck@chromium.org>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	arm-scmi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	chrome-platform@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Add struct_offsetofend() for pointer arithmetic
Message-ID: <202611120916.3619B95@keescook>
References: <20261112-offsetof-v2-0-276ede839967@arm.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261112-offsetof-v2-0-276ede839967@arm.com>

On Thu, Nov 12, 2026 at 10:29:32AM +0100, Bence Csokas wrote:
> A common usage pattern for offsetof() is the following:
> 
>   offsetof(typeof(*ptr), member)
> 
> This is exactly the definition of struct_offset(). Some call sites use
> offsetofend() instead of offsetof(). Add this variant, then replace all
> call sites with the corresponding macros.

Yeah, I think this is reasonable. I'd prefer to see the Coccinelle
script explicitly added to tools/coccinelle/api/ though, so it can be
trivially re-run as needed.

Also, while Alejandro is right about the needless outer parens, I think
I'd like to keep them just to match the other define, and they do no
harm.

-Kees

> 
> Signed-off-by: Bence Csokas <bence.csokas@arm.com>
> ---
> Changes in v2:
> - Use struct_offset() instead of reinventing it
> - Rename offsetofendp() to struct_offsetofend()
> - Merge the two treewide patches
> - Link to v1: https://patch.msgid.link/20261105-offsetof-v1-0-4153f5c10edc@arm.com
> 
> To: Kees Cook <kees@kernel.org>
> To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> To: Marcel Holtmann <marcel@holtmann.org>
> To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> To: Sumit Semwal <sumit.semwal@linaro.org>
> To: Christian König <christian.koenig@amd.com>
> To: Philipp Stanner <phasta@kernel.org>
> To: Sudeep Holla <sudeep.holla@kernel.org>
> To: Cristian Marussi <cristian.marussi@arm.com>
> To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> To: Maxime Ripard <mripard@kernel.org>
> To: Thomas Zimmermann <tzimmermann@suse.de>
> To: David Airlie <airlied@gmail.com>
> To: Simona Vetter <simona@ffwll.ch>
> To: Jani Nikula <jani.nikula@linux.intel.com>
> To: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> To: Rodrigo Vivi <rodrigo.vivi@intel.com>
> To: Tvrtko Ursulin <tursulin@ursulin.net>
> To: Lyude Paul <lyude@redhat.com>
> To: Danilo Krummrich <dakr@kernel.org>
> To: Zack Rusin <zack.rusin@broadcom.com>
> To: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
> To: Selvin Xavier <selvin.xavier@broadcom.com>
> To: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> To: Jason Gunthorpe <jgg@ziepe.ca>
> To: Leon Romanovsky <leon@kernel.org>
> To: Chengchang Tang <tangchengchang@huawei.com>
> To: Junxian Huang <huangjunxian6@hisilicon.com>
> To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> To: Hans de Goede <hansg@kernel.org>
> To: Mauro Carvalho Chehab <mchehab@kernel.org>
> To: Haiyang Zhang <haiyangz@microsoft.com>
> To: Wei Liu <wei.liu@kernel.org>
> To: Dexuan Cui <decui@microsoft.com>
> To: Andrew Lunn <andrew+netdev@lunn.ch>
> To: "David S. Miller" <davem@davemloft.net>
> To: Eric Dumazet <edumazet@kernel.org>
> To: Jakub Kicinski <kuba@kernel.org>
> To: Paolo Abeni <pabeni@redhat.com>
> To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> To: Jes Sorensen <Jes.Sorensen@gmail.com>
> To: Ping-Ke Shih <pkshih@realtek.com>
> To: Johannes Berg <johannes@sipsolutions.net>
> To: Benson Leung <bleung@chromium.org>
> To: Tzung-Bi Shih <tzungbi@kernel.org>
> To: Guenter Roeck <groeck@chromium.org>
> To: Nilesh Javali <njavali@marvell.com>
> To: GR-QLogic-Storage-Upstream@marvell.com
> To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> To: "Martin K. Petersen" <mkp@kernel.org>
> Cc: linux-hardening@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-bluetooth@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org
> Cc: arm-scmi@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: intel-gfx@lists.freedesktop.org
> Cc: nouveau@lists.freedesktop.org
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-hyperv@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: chrome-platform@lists.linux.dev
> Cc: linux-scsi@vger.kernel.org
> 
> ---
> Bence Csokas (2):
>       stddef: Add offsetofend() variant of struct_offset()
>       treewide: Use struct_offset()
> 
>  drivers/bluetooth/btmrvl_main.c                    | 12 +++++-----
>  drivers/dma-buf/dma-resv.c                         |  2 +-
>  drivers/firmware/arm_scmi/base.c                   |  2 +-
>  drivers/gpu/drm/drm_edid.c                         | 26 +++++++++++-----------
>  drivers/gpu/drm/i915/gem/i915_gem_object.c         |  4 ++--
>  drivers/gpu/drm/i915/i915_active.c                 |  2 +-
>  drivers/gpu/drm/i915/i915_sw_fence_work.c          |  2 +-
>  .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c  |  2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            | 12 +++++-----
>  drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  2 +-
>  drivers/infiniband/hw/hns/hns_roce_cq.c            |  4 ++--
>  drivers/infiniband/hw/hns/hns_roce_qp.c            |  6 ++---
>  drivers/media/usb/uvc/uvc_v4l2.c                   |  4 ++--
>  drivers/net/hyperv/rndis_filter.c                  |  2 +-
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  2 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  2 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  2 +-
>  .../net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c |  5 ++---
>  drivers/net/wireless/realtek/rtl8xxxu/core.c       |  2 +-
>  drivers/net/wireless/realtek/rtw88/fw.c            |  2 +-
>  drivers/net/wireless/realtek/rtw89/core.c          |  2 +-
>  drivers/net/wireless/realtek/rtw89/fw.c            |  8 +++----
>  drivers/net/wireless/virtual/mac80211_hwsim_main.c |  4 ++--
>  drivers/platform/chrome/cros_ec_lightbar.c         |  4 ++--
>  drivers/scsi/qla2xxx/qla_gs.c                      |  2 +-
>  drivers/scsi/qla2xxx/qla_mbx.c                     |  2 +-
>  drivers/scsi/qla2xxx/qla_os.c                      |  2 +-
>  drivers/scsi/qla2xxx/qla_tmpl.c                    |  4 ++--
>  drivers/scsi/scsi_transport_fc.c                   |  2 +-
>  include/linux/overflow.h                           | 12 ++++++++++
>  30 files changed, 75 insertions(+), 64 deletions(-)
> ---
> base-commit: 9d66f26fefacebfeed15de31c1123451a17ff119
> change-id: 20261105-offsetof-f62aa6348f0d
> 
> Best regards,
> --  
> Bence Csokas <bence.csokas@arm.com>
> 

-- 
Kees Cook
