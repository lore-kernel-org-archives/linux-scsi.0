Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8D624BC1D;
	Thu, 13 Feb 2025 20:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739477987; cv=none; b=qrDB6IAtJzq8tzKTrQgzp9XEq0PDVELjF1kEdel7XcstFkHH7aAiGOO8rCgclU5PmxUtbHU+05iZ+xhNdmG4NbK+D4LWkEN+C23YbPc0fa3421UFDDFY1gbGHVBs6kd2vIVBLaGs2VHA+qwlNdn2leV9F5/QXlgUk7F85wpXFxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739477987; c=relaxed/simple;
	bh=hql0WxxUz5upyphom9gBH+X2zwTnwWPz5bjY0x7Q5SM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=td8rmxPfbYNlYZfVW+wEvZSw+Byax5ssmLUb+TuVQu8AXdpejwkCn8pP9JlgiTIj1jpm2r/TvBg2GrFG+J7W1wdr4ypReO9Yb7sgILrj7DmrJcF+EbpNuTls0tSiOgAMFlleIJbtIZzi5CSfumsFESA/VqW90IIw/l7I8Z7S9HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KSUb0v8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KSUb0v8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDC0C4CED1;
	Thu, 13 Feb 2025 20:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739477987;
	bh=hql0WxxUz5upyphom9gBH+X2zwTnwWPz5bjY0x7Q5SM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KSUb0v8NHvyltW8eLeaT3acLr6MXMy8luTSE+qMoS/6v5xox29MOEkB7snYYQRQzh
	 /tfCx4g+2JVtWoAZ7aGCJzNP17P4BT8VAW2sCup5LVNP0NDWsr5jTFXPnWHKJ0GVKg
	 YZcic0AHt+0d/yDSlcvGolO77OyMhpGzkZELHte6nzbwMJRDn2fpeZLKLkBK3vaDLW
	 Dt8r460piQxD+PVyqCleeBiDdJpV903/Yl5TDdDZW5b05D4mPpsm3jKvziZRG0QwDW
	 4hg2b5qyZMUmK2x0AyQKnysdFKU5ecJmynQAGlKssR3kUnxAfZ4k6q4ZFYQZ64OE5B
	 +wUYfOssXCL7w==
Date: Thu, 13 Feb 2025 12:19:46 -0800
From: Kees Cook <kees@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-hardening@vger.kernel.org, storagedev@microchip.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: hpsa: Replace deprecated strncpy() with
 strscpy_pad()
Message-ID: <202502131218.B53CB1EB@keescook>
References: <20250213114047.2366-2-thorsten.blum@linux.dev>
 <2c1fcd13-ffac-4590-a345-c5389d1ccc9f@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c1fcd13-ffac-4590-a345-c5389d1ccc9f@acm.org>

On Thu, Feb 13, 2025 at 10:24:25AM -0800, Bart Van Assche wrote:
> On 2/13/25 3:40 AM, Thorsten Blum wrote:
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index c7ebae24b09f..968cefb497eb 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -7236,8 +7236,7 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
> >   static void init_driver_version(char *driver_version, int len)
> >   {
> > -	memset(driver_version, 0, len);
> > -	strncpy(driver_version, HPSA " " HPSA_DRIVER_VERSION, len - 1);
> > +	strscpy_pad(driver_version, HPSA " " HPSA_DRIVER_VERSION, len);
> >   }
> >   static int write_driver_ver_to_cfgtable(struct CfgTable __iomem *cfgtable)
> 
> Has it been considered to introduce a Coccinelle semantic patch that
> performs this conversion? See also the scripts/coccinelle directory.

Using this:

@pad0 depends on !(file in "tools") && !(file in "samples")@
expression DEST, SRC;
expression LENGTH;
@@

-     memset(DEST, 0, LENGTH);
-     strncpy(DEST, SRC, LENGTH - 1);
+     strscpy_pad(DEST, SRC, LENGTH);

@padNUL depends on !(file in "tools") && !(file in "samples")@
expression DEST, SRC;
expression LENGTH;
@@

-     memset(DEST, '\0', LENGTH);
-     strncpy(DEST, SRC, LENGTH - 1);
+     strscpy_pad(DEST, SRC, LENGTH);

It turns out this is the only place left in the kernel using that
pattern. :)

> 
> Anyway:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
