From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: twa generates WARNING upon boot
Date: Wed, 30 Sep 2015 09:15:30 -0700
Message-ID: <1443629730.2185.25.camel@HansenPartnership.com>
References: <68ee66bf9581d10b0ab813e5006869ec.squirrel@atoth.sote.hu>
	 <CAHtARFHdFOVHZ2_-JT9_nvRZmbF+cffRrtaaE4DSZSrJwU6BCA@mail.gmail.com>
	 <d8e4bcdc939f0926a63f5c4a35fb8e0c.squirrel@atoth.sote.hu>
	 <1443548266.2207.19.camel@HansenPartnership.com>
	 <1443549768.2207.22.camel@HansenPartnership.com>
	 <95d34bcc4c0fcf84d02d76a4443ba07c.squirrel@atoth.sote.hu>
	 <1443551581.2207.26.camel@HansenPartnership.com>
	 <20150930160835.GA16534@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41276 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752385AbbI3QPc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2015 12:15:32 -0400
In-Reply-To: <20150930160835.GA16534@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "\"T?th Attila\"" <atoth@atoth.sote.hu>, adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2015-09-30 at 09:08 -0700, Christoph Hellwig wrote:
> Hi all,
> 
> I'd like to propose the following patch intead.  It uses a helper
> to check the conditions for the copied commands, and also fixes another
> place to use it which uses a different and I think buggy check:
> 
> This avoids the usage of scsi_cmnd.SCp which I'd like to get rid of
> mid-term.
> 
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index add419d..74eac90 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -212,6 +212,17 @@ static const struct file_operations twa_fops = {
>  	.llseek		= noop_llseek,
>  };
>  
> +/*
> + * The controllers use an inline buffer instead of a mapped SGL for small,
> + * single entry buffers.  Note that we treat a zero-length transfer like
> + * a mapped SGL.
> + */
> +static bool twa_command_mapped(struct scsi_cmnd *cmd)
> +{
> +	return scsi_sg_count(cmd) != 1 ||
> +		scsi_bufflen(cmd) >= TW_MIN_SGL_LENGTH;
> +}

I already thought of this.  Unfortunately, it fails if the internally
posted command is a single sector (the size of TW_MIN_SGL_LENGTH), which
is true for most of them.

James


