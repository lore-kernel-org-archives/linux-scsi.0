Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0E6477285;
	Wed,  2 Sep 2026 11:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788348555; cv=none; b=g3DQBdmCDTx8VINirO52IF1/mz44tSpQV0E3zRvcyPiQ6Cyc1hiwftXQoN6nP4tsqlcTn2JfIchXuwokyzXyOPvAN2Tlpbciug9LEtI/e652PYNWY43AuFK+c8G/9hbPymlBaFXhku+zEXvU5L/2SAHaHJGmWPqBwnDxXmRsgDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788348555; c=relaxed/simple;
	bh=gyzdEzme7lFDjf/tquEWQWPcfPYvp1lu54rae5judD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sn7jE8k70C1Y1kW7iRh7jk4wT2XTUlYMcYVsO2+lci+zf6T5/a/WbZCTEwniiJLtdxnd/gNlBUfpesdEAszs/ogyGEjVy6RV6fQVlCoT3F6FWsAVdbHBHxjXUcR+vYO0yZ3EceuWpKBMCZQ4UaMESk8sizxGU0TEp9ok85Nkrzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zkt52PJ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zkt52PJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8EC1F000E9;
	Wed,  2 Sep 2026 11:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788348545;
	bh=G6COaUZJxKf9AGZAlBdJyQBoWIGyZnpHatyadIQjBbg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zkt52PJ9a88hpa5jhEaOJqpqUfcWv8ZrSFe9g+kH6Ec+aPlWpgblc9ub2QEr/dx25
	 e9sLHmsuT87DHC/2sn0R124Gr9tIOgbYyGT1On7OWRKdjOJ2K+cAJton1hOs9vCCjI
	 P93Wm9K6JXfES3JV2egwB+jYQBamQ+Pz/Nt1UENvz6gwNIqslTF7UZxcAOJk/ECxIT
	 uW0mJwkwj4DnFWz1dEXczyRRyzQh7nPG2AiKiUR51kvFcwubaOMwV2kXjtDxMpevvE
	 IKTfsoNzSyR13fJIWBeFvq+Z9odqrOB5Y2fxQKuM5w9zMObUCunsIcU5ldaLmEIErv
	 MSzfL55YiY5JQ==
Date: Wed, 2 Sep 2026 13:29:01 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 36/37] ata: libata: use 16-bits defined sense codes
Message-ID: <apgIfRr9MjNov6FV@ryzen>
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-37-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831020451.585944-37-dlemoal@kernel.org>

On Mon, Aug 31, 2026 at 11:04:50AM +0900, Damien Le Moal wrote:
> Refactor libata core code to use the 16-bits sense_code field of
> struct scsi_sense_hdr and replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
> 
> No functional change intended.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/ata/libata-eh.c   |  13 +-
>  drivers/ata/libata-sata.c |  14 +-
>  drivers/ata/libata-scsi.c | 346 +++++++++++++++++++++++---------------
>  drivers/ata/libata.h      |   5 +-
>  4 files changed, 226 insertions(+), 152 deletions(-)
> 
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index c93c24b22d9c..71961fbaa42f 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -1516,11 +1516,13 @@ static bool ata_eh_request_sense(struct ata_queued_cmd *qc)
>  	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
>  	/* Ignore err_mask; ATA_ERR might be set */
>  	if (tf.status & ATA_SENSE) {
> -		if (ata_scsi_sense_is_valid(tf.lbah, tf.lbam, tf.lbal)) {
> +		u16 sense_code = scsi_sense_code(tf.lbam, tf.lbal);

Here you take asc and ascq and combine them to one.
I see the reason, since ata_scsi_sense_is_valid() takes a u16 sense code.
That is fine, and I think makes ata_scsi_sense_is_valid() easier to read.


> +
> +		if (ata_scsi_sense_is_valid(tf.lbah, sense_code)) {
>  			/* Set sense without also setting scsicmd->result */
> -			scsi_build_sense_buffer(dev->flags & ATA_DFLAG_D_SENSE,
> -						cmd->sense_buffer, tf.lbah,
> -						tf.lbam, tf.lbal);
> +			scsi_set_sense_buffer(dev->flags & ATA_DFLAG_D_SENSE,
> +					      cmd->sense_buffer, tf.lbah,
> +					      sense_code);

However, here you call scsi_set_sense_buffer() which is just an inline
function that calls:
scsi_build_sense_buffer(desc, buf, key, scsi_sense_code_asc(code),
			scsi_sense_code_ascq(code));

which will call scsi_sense_code_asc() and scsi_sense_code_ascq() to
split sense_code to asc and ascq again.

It seems that you series has decided to not kill scsi_build_sense_buffer().

As long as scsi_build_sense_buffer() exists, and since we already have asc
and ascq stored in separate variables, I think we should let this code
continue calling scsi_build_sense_buffer().

Especially since, even after this series, we still will have a call to
scsi_build_sense_buffer() in libata-sata.c:ata_eh_get_ncq_success_sense().

I think either this function and ata_eh_get_ncq_success_sense() should both
call scsi_build_sense_buffer(), or both should call scsi_set_sense_buffer().



Is there a reason why you don't convert all scsi_build_sense_buffer() users
to scsi_set_sense_buffer() and drop scsi_build_sense_buffer() ?
You could even keep the same function name (scsi_build_sense_buffer()) and
just have it take an u16 sense_code instead of u8 asc + u8 ascq?

(Doing a git grep scsi_build_sense_buffer shows a few users even after this
series.)


Kind regards,
Niklas
