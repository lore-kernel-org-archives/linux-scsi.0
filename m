Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6EE139579;
	Wed,  7 Jan 2026 09:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767776809; cv=none; b=X0QhLBYtv9tw5NUb1AZZYZLjY96wFx4EW8dwZGWh/7uATyEiI6DoL+HIwlfNyLNXxt43zQfvvKcF2Cok2q4Yoat2iUljpCuj4yYW7wTOl4ichaZTby1B2lJbMEAyrMWHEOTRxqBjsKGPeL65a1Go1Q6baywX9v5EbzbT6Mg79Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767776809; c=relaxed/simple;
	bh=xfbP3iiQiTvylfEBBsP/tGgAzqlIRaiPQDG0x9eR+R4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eOpcGB+UDoEJ6+eD/Ma9AmkSe/V5qMqYStZ1SeqR/aoUj1bD0tPVWFKNx0vHpFalJjI2gdoSQGjXL/csutvIM8Q97LXu7Qksy/DAaL+J8kETTRwwJRhSVd8LO09d3N6db6KU4cB8bbTdIwK1fLOyt20AuC3+LqpvCR443iewIlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=ceHkUQX5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gcFxzme5; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="ceHkUQX5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gcFxzme5"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 9E0061D000C9;
	Wed,  7 Jan 2026 04:06:45 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 07 Jan 2026 04:06:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1767776805; x=1767863205; bh=Y+BmCaPEds
	vR0QuU5EbuvJUcLSLZqO/lUAQ6j2+r1Hw=; b=ceHkUQX5dLJ5cQ9jqtn5T3Tvjd
	M24oU2yLU+32njrWQjHfoTELVU1Q+CRAIOCmLI/yT/ngKOcbkVU9rDb58Un+8T6v
	P6dqkAOTuTLktw9omt2KNdNS9AAgf7GLBij/FCVhg5Dpttp8loEDHcYCffO6PcaH
	waKN8zwxZzXcXMWrCu4OL7xMS4PcCjDqiC82yQlFiQ9w6J0GbotZov4Ktd6qKCU0
	EAh/FI2onwD8Pe6Co+qQJHEToRn8xCeV96OeeD4K+9YAwpBJnpEWlupqDJ2INYJP
	sHQDGUKdCQhGc39lMkfJS1KRvGmJ2d9Z9umbP8p3qUoyBxu7j7rmW85FQkiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1767776805; x=1767863205; bh=Y+BmCaPEdsvR0QuU5EbuvJUcLSLZqO/lUAQ
	6j2+r1Hw=; b=gcFxzme5bdk0oIjLg9PVeVzDGGNEsI7igadjKIekyFqu40CyCj9
	fhoxCLtom4S5eQGRMUx04ZIOL07CRZV3CxRO1FZnj0rttqMTHBtBe3O75LWyBDTw
	7bajhDMURzkhy9BQkY8cmkV+b+mih2lw63vOddJe0Guuibplyo3jXrfTnOcQDp3W
	OsO3K+WZctAZAdto5s/yOAVbIZT2hrqjMkvaIca54Dh1TIEzceeoS9yirkxEy7Z1
	g5remq2OZzGd1JNxlxWJZCaYWevlUOyhEDI6rUxpQ0sZuXUnC+Ey29Zun/PB3OvT
	oIB4fRaXRIy5ODZHydyvc0DiPJZn+fWgLgQ==
X-ME-Sender: <xms:JCJeac7bMAJSffiv5rk5QNXmQNkxPN314a0bYstXnOKFgx_YIDEgFA>
    <xme:JCJeaSyegRyFBUha3KvtvCT1JSU6w97xBVWaVGZJc4xDYiX29jZaKFfZGqa5AIKtv
    cIwNguPlMMLCnn86V-9XhwvGeW17964GLYTWL_gztkb-uEd>
X-ME-Received: <xmr:JCJeaZDxB-iuJpyg_KztSVhoviI43YvbRCuFAxRwgrJ5almZU_xiWtVZr-f-6VQvPQ9g4vZN-40cMqqGzCH-eAOWIudBXejkXNtgng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddutddvieejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvdevvd
    eljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhmpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheplhhihhgrohigihgrnhhgsehishhrtgdrihhstggrshdrrggtrdgtnhdprhgtphhtth
    hopehjrghmvghsrdgsohhtthhomhhlvgihsehhrghnshgvnhhprghrthhnvghrshhhihhp
    rdgtohhmpdhrtghpthhtohepughonhdrsghrrggtvgesmhhitghrohgthhhiphdrtghomh
    dprhgtphhtthhopehmrghrthhinhdrphgvthgvrhhsvghnsehorhgrtghlvgdrtghomhdp
    rhgtphhtthhopehjsghothhtohhmlhgvhiesphgrrhgrlhhlvghlshdrtghomhdprhgtph
    htthhopehstggrmhgvrhhonhessggvrghrughoghdrtggtvgdrhhhprdgtohhmpdhrtghp
    thhtohepshhtohhrrghgvgguvghvsehmihgtrhhotghhihhprdgtohhmpdhrtghpthhtoh
    eplhhinhhugidqshgtshhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:JCJeaTMKzIvz6KtMCIpc3xN-vlHABGBViaU-PPL52h8W_GB_1aIybA>
    <xmx:JCJeafSCVhReE0uiwOy9y_TT7cy5Oum3kbKtNJv6YrCR7znWevGL3g>
    <xmx:JCJeaUtBl4E87nN6z0OFbo-VH0SgiJYHMbNhP5fNADvqqnxQiacx3g>
    <xmx:JCJeadVu8ZXRDiJx7lhu3CGTKbGfovDV5lKZmAcc9a0uOjk-KvnFug>
    <xmx:JSJeaa6cNecK3iYch-UPgzVjSXhCflJFcScXbku52LpbFJhqQSCLEMkO>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Jan 2026 04:06:44 -0500 (EST)
Date: Wed, 7 Jan 2026 10:06:41 +0100
From: Greg KH <greg@kroah.com>
To: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Cc: James.Bottomley@hansenpartnership.com, don.brace@microchip.com,
	martin.petersen@oracle.com, jbottomley@parallels.com,
	scameron@beardog.cce.hp.com, storagedev@microchip.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] hpsa: fix a memory leak in hpsa_find_cfgtables()
Message-ID: <2026010718-upchuck-nimbly-6ffb@gregkh>
References: <20260107085617.3391860-1-lihaoxiang@isrc.iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107085617.3391860-1-lihaoxiang@isrc.iscas.ac.cn>

On Wed, Jan 07, 2026 at 04:56:17PM +0800, Haoxiang Li wrote:
> If write_driver_ver_to_cfgtable() fails, add iounmap() to
> release the memory allocated by remap_pci_mem().

How did you find this bug?  You always need to document the tool you are
using.

> 
> Fixes: 580ada3c1e2f ("[SCSI] hpsa: do a better job of detecting controller reset failure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
> ---
>  drivers/scsi/hpsa.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 3654b12c5d5a..4cc129d2d6f2 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -7646,8 +7646,11 @@ static int hpsa_find_cfgtables(struct ctlr_info *h)
>  		return -ENOMEM;
>  	}
>  	rc = write_driver_ver_to_cfgtable(h->cfgtable);
> -	if (rc)
> +	if (rc) {
> +		iounmap(h->cfgtable);
> +		h->cfgtable = NULL;

Shouldn't you just call hpsa_free_cfgtables() instead?

thanks,

greg k-h
