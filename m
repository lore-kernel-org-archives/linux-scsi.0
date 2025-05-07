Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF0528ECCB;
	Wed,  7 May 2025 20:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746649356; cv=none; b=lLXcO4ab3ma+ZDIWumBxcwRCOxjcor/JgTeU/jroUlYY4mVgQY5rNnwT887XfmdgokdjRl86q1gN4Ay16VQkACqowE/oOH5OC3Auzw8HH9zLqEHFih2n36UOnHBvrubMr1jyKPeyKuPF2JIy0/7HnJOjC6RYQrhnMaCaWwABd2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746649356; c=relaxed/simple;
	bh=ciZk+xzvWcfZ7+r0pbXbKYyfhFmvz0llK0OmkK7d/sM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uKL+v44nYKSkBy0B2dXC65h92xpZrqZ8+/VhQJoQ284o/Sc8UqC4Txqk4IIUYaMvolLaqpC5TBbVK3U4Du5NmS0bDyUI1kub9pEwshHMd23v3jJkZT8SNX3LaeYfS0JAAmG+21yUlT1JG03a2rYNIbyexp5nLr08pgpujjjgsXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MhjgPwuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MhjgPwuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA76C4AF0B;
	Wed,  7 May 2025 20:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746649355;
	bh=ciZk+xzvWcfZ7+r0pbXbKYyfhFmvz0llK0OmkK7d/sM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MhjgPwuFH+7DBpOqYm32xk99kKFmA4jpsHEk7mqQj34YfIWemSeMT01gvO1Q3nDl8
	 /WE0i/TEkulifvYOh7TRHFDnG+s4HpvXEA4+L7r3RgEOXPdUuiR75xd1Pd5XxRxnWh
	 o52h4fdFyqgHIH1vyvJfZ8VbxBLhB+Qkb2rpwYhZHzaPXVRhTev4hI9tY29ebyydtt
	 pK+wrXBuotkg9P26axhg+36cbl/mge1YiJl7W0ytfh/fV4hDVSO2HtvG4VZF26h9ns
	 qJW1RgDEn5EGYOfXTyaQdjwqIL3RA6ctv/g05JdGvryWvZ2hh4UBTgazbLHRB10WHt
	 GW2keA5vrEHOA==
Date: Wed, 7 May 2025 21:22:30 +0100
From: Nathan Chancellor <nathan@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, WangYuli <wangyuli@uniontech.com>,
	Mark Brown <broonie@kernel.org>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: qedf: Use designated initializer for struct
 qed_fcoe_cb_ops
Message-ID: <20250507202230.GA3536142@ax162>
References: <20250502224156.work.617-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502224156.work.617-kees@kernel.org>

On Fri, May 02, 2025 at 03:41:57PM -0700, Kees Cook wrote:
> Recent fixes to the randstruct GCC plugin allowed it to notice
> that this structure is entirely function pointers and is therefore
> subject to randomization, but doing so requires that it always use
> designated initializers. Explicitly specify the "common" member as being
> initialized. Silences:
> 
> drivers/scsi/qedf/qedf_main.c:702:9: error: positional initialization of field in 'struct' declared with 'designated_init' attribute [-Werror=designated-init]
>   702 |         {
>       |         ^
> 
> Fixes: c2ea09b193d2 ("randstruct: gcc-plugin: Remove bogus void member")

For the record, this is also needed after your recent change to clang to
do the same thing as the plugin:

  drivers/scsi/qedf/qedf_main.c:702:2: error: a randomized struct can only be initialized with a designated initializer
  702 |         {
      |         ^

so this should probably have

  Cc: stable@vger.kernel.org
  Fixes: 035f7f87b729 ("randstruct: Enable Clang support")

> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Saurav Kashyap <skashyap@marvell.com>
> Cc: Javed Hasan <jhasan@marvell.com>
> Cc: <GR-QLogic-Storage-Upstream@marvell.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: <linux-scsi@vger.kernel.org>
> ---
>  drivers/scsi/qedf/qedf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index 436bd29d5eba..6b1ebab36fa3 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -699,7 +699,7 @@ static u32 qedf_get_login_failures(void *cookie)
>  }
>  
>  static struct qed_fcoe_cb_ops qedf_cb_ops = {
> -	{
> +	.common = {
>  		.link_update = qedf_link_update,
>  		.bw_update = qedf_bw_update,
>  		.schedule_recovery_handler = qedf_schedule_recovery_handler,
> -- 
> 2.34.1
> 
