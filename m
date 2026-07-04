Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7C727732
	for <linux-scsi@vger.kernel.org>; Sat,  4 Jul 2026 14:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783173693; cv=none; b=X6Vay61c5BMEiXpMs0+MyL2ED9zH4VVcAf2V1u+B5PRZBxQxC07w/9cZ24NVE4Ppfcg9/2bDk9as6c6srMrmU6iscXtOjO2aPl98+30k0nlaS12GS/sbP9paNCzzlcEQkGI1eqJmCvTbKhOSfzGykmoUqphjqV3KJcZMOQSFI8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783173693; c=relaxed/simple;
	bh=X/aUfjm1ytiWBQKSsoJFWVGuSu64ruDLhkhKQT26bFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sFu45RolPNb6lfv37zaxkNcnELBM82CT4fM+yZQIMrUVYPL7EuyiRRxFRPkh7GvfTfn1sRAEW9NY5jR0qz+AzLCssKh5vSK5HHY29KJQ2+G1TObXn2XRdWxknuCS5xy7LYxtUI7ypxCi+PC3/JSihGhSnJlTfBY2aVHJUezKUIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GdExZnqj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=o/4AwnQB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GdExZnqj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="o/4AwnQB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783173690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RG/qppTW5QiC+uZfEkeQXRtZMh5udm6vGfwyGZ5WcNg=;
	b=GdExZnqjL2NeVQ+cDqXeKIAtJHB2x9I2HccmDwu660Z6cRIj87POxO2BeTHg6TZqSRZddJ
	Ylztll9lScqjyKsENT+wpdENR4XRC9PgucUY++vZRW9Yegs8lnB3IcsnQQ0NvTQeWO5ikU
	y1/I1rm2fZtYmFcUvoA5i//9/If02vU=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-ee9v1MI_NcyZu4pnZkL4bw-1; Sat, 04 Jul 2026 10:01:28 -0400
X-MC-Unique: ee9v1MI_NcyZu4pnZkL4bw-1
X-Mimecast-MFC-AGG-ID: ee9v1MI_NcyZu4pnZkL4bw_1783173686
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-8114ebd5deeso41881797b3.2
        for <linux-scsi@vger.kernel.org>; Sat, 04 Jul 2026 07:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783173686; x=1783778486; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RG/qppTW5QiC+uZfEkeQXRtZMh5udm6vGfwyGZ5WcNg=;
        b=o/4AwnQBIBCB9VNZn1OUWd8KvkgEDu76HuY/iTlO8ZpmenIq6JVQRYUUt4J2oR63EK
         NrjZugP+UO+e06V+a/Uui0pDUIgcP3Mp2q81sqRcmYA9iVWosJmrTnb4lrC4/edRFBRF
         mAKdI9bM48rHx495j7yKMxHSUhDcIeXq5a7LsBMml3VDo9IRwaqbJa4NDKQJSdBknePV
         h+eMoMLaYL9XHO9lOAi4p/TwUfY7UpGDJVEcGQUSD4rMDrJh0zrsDqQTqS3yJPp0XoCP
         BTOdGN4Ad60bT4+jYm0hqKUZ8NmR8xsgBpz3Hw4oyz2zU0L/TmtmvEgRI36KdaXGcIqI
         X+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783173686; x=1783778486;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RG/qppTW5QiC+uZfEkeQXRtZMh5udm6vGfwyGZ5WcNg=;
        b=gqZbtdw3dJI4ZfhFa58yzmZ4d4SysOvAdWWgG+6qA1qALIPOb+e0fKYZ+tmBHxtgYK
         AtJV0wQOhMemICv0vuDlNN56QQ3J1t2OSJwobJyuWrDTwN0yvficQi0/t7cJmYz9sX1m
         7cMpCnBBzGyZv5qJ5/0fz7u67ybJeN6PELwlSfNdmKrIgDAHXuCI+hGdoPPgcQDZLG6C
         ZlSjYnbTFtkokk7xEZaP8LVqGYQEzZXkdBPLbqoOrczjYM70ThYYgD0tEZKTb7exfF4q
         nF+tcv84y8PldlIyMEypLm2kjNEeeuf0INhZr/n7fU2Uegyx629igRScIiznzWCH7xjj
         94QQ==
X-Forwarded-Encrypted: i=1; AHgh+RpsnzmtdYg3m1B0G0znScjMkm51vpnpSFOQsYD5BgA0KSb+UIo6Kuby+CWcfruAeEyR9gTQ7Uwac232@vger.kernel.org
X-Gm-Message-State: AOJu0YyFEVzXnAESaV0tyVhKuS53YCJAyJ2+HyEaJBK/Ir/0s+/W8hCB
	uITFgMuHkcjC3L+K3V311uLaHmnOHVM0gA7Mkui4KGGX1WuKSpjC0UcRfCHfbfFx2koWCH/4rLJ
	uWNdnycxyuzooH5tZTEwOAiKVextyeSrUGtzVKFWrPAqRYk/zUDLP4mfGgqrRvVQ=
X-Gm-Gg: AfdE7cnyl3U+QczfQrpmb/gRaAbx0jsu8zpcfzBC1BJCIhHjYDYOT7hn4V3sPQnh0uN
	cYoDlzR/Dqm7WR7YX5DfMShtDmD9YtTtJi1TR3tyitk9hD4mJpU+Ln+hTPmshYhLz/xzC4ovqE5
	ao2Ya4VQKo/Q6GHWDOGsawltE2lixDGMd2AbrzH+HU7g7nIw0y2XdxfEBo1dyBms+OkPIgMfvqu
	VYMAyWmivbd6wAD+Uqix8+FyYLbTpO+UwCpQXCX7ccPhOrKNL3YRSLdvneCirOoERUNilERxKM7
	m2MjWSx3w6e+wupsUSGqHfbTz6kESEuk0GsApDTx/pwSOqoNMp8cHXuAua5posc=
X-Received: by 2002:a05:690e:454d:20b0:666:3330:3d8f with SMTP id 956f58d0204a3-66652e9dc1emr2462590d50.51.1783173685469;
        Sat, 04 Jul 2026 07:01:25 -0700 (PDT)
X-Received: by 2002:a05:690e:454d:20b0:666:3330:3d8f with SMTP id 956f58d0204a3-66652e9dc1emr2462196d50.51.1783173681958;
        Sat, 04 Jul 2026 07:01:21 -0700 (PDT)
Received: from rhdev ([2600:1700:f361:20bf::14c1])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-666408b2d99sm2171811d50.20.2026.07.04.07.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 07:01:21 -0700 (PDT)
Date: Sat, 4 Jul 2026 10:01:19 -0400
From: Jennifer Berringer <jberring@redhat.com>
To: Yixun Lan <dlan@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] riscv: dts: spacemit: k3: Add UFS support
Message-ID: <akkSL1nQ5UieqHNs@rhdev>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-3-1a64a3ab128f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702-08-k3-ufs-support-v1-3-1a64a3ab128f@kernel.org>

On Thu, Jul 02, 2026 at 02:31:37AM +0000, Yixun Lan wrote:
> Add UFS Host Controller support for SpacemiT K3 SoC, and enable
> it both on both Pico-ITX and CoM260-IFX boards.
> 
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
>  arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts |  4 ++++
>  arch/riscv/boot/dts/spacemit/k3-pico-itx.dts   |  4 ++++
>  arch/riscv/boot/dts/spacemit/k3.dtsi           | 13 +++++++++++++
>  3 files changed, 21 insertions(+)
> 
> diff --git a/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts b/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts
> index 238bb03d0e9e..b37e1c7b03e3 100644
> --- a/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts
> +++ b/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts
> @@ -19,3 +19,7 @@ chosen {
>  		stdout-path = "serial0:115200n8";
>  	};
>  };
> +
> +&ufshc {
> +	status = "okay";
> +};

I believe k3-com260.dtsi would be a more fitting file for this change.
UFS is soldered on the underside of the compute module and not part of
the carrier board.

Because it is next to the microSD card slot, a picture showing both can
be seen in section 5.12 (TF-Card Interface) of the PDF version of the K3
CoM260 User Guide. That picture is notably not visible in the HTML
version.

https://www.spacemit.com/community/document/info?lang=en&nodepath=hardware/eco/k3_com260/com260_user_guide.md

> diff --git a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
> index b89c1521e664..f1560a5a9031 100644
> --- a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
> +++ b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
> @@ -221,3 +221,7 @@ hub@1 {
>  &usb2_phy {
>  	status = "okay";
>  };
> +
> +&ufshc {
> +	status = "okay";
> +};

Nit: if sorted by label, ufshc would be before usb2_host.

> diff --git a/arch/riscv/boot/dts/spacemit/k3.dtsi b/arch/riscv/boot/dts/spacemit/k3.dtsi
> index 19fc9b49668e..6c0b0598d5c8 100644
> --- a/arch/riscv/boot/dts/spacemit/k3.dtsi
> +++ b/arch/riscv/boot/dts/spacemit/k3.dtsi
> @@ -1186,5 +1186,18 @@ maplic: interrupt-controller@f1800000 {
>  			riscv,num-sources = <512>;
>  			status = "reserved";
>  		};
> +
> +		ufshc: ufshc@c0e00000 {
> +			compatible = "spacemit,k3-ufshc";
> +			reg = <0x0 0xc0e00000 0x0 0x40000>;
> +			clocks = <&syscon_apmu CLK_APMU_UFS_ACLK>,
> +				 <&syscon_apmu CLK_APMU_UFS_REFCLK>;
> +			clock-names = "aclk", "ref_clk";
> +			resets = <&syscon_apmu RESET_APMU_UFS_ACLK>;
> +			interrupts = <135 IRQ_TYPE_LEVEL_HIGH>;
> +			freq-table-hz = <491520000 491520000 19200000 19200000>;
> +			lanes-per-direction = <2>;
> +			status = "disabled";
> +		};
>  	};
>  };
> 
> -- 
> 2.54.0
> 

Best regards,
Jennifer

