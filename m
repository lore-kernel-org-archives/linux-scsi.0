Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C11345C706;
	Tue,  6 Oct 2026 13:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791293167; cv=none; b=YH/eIuw8qWn59z09jo6dEy9IlfGmx80X50W49K2Iik450KiWjaC+gQZ6UHDcqQEv2/htM0Y+RpBz0vu4vXfrUFhwJaD+IRDQ2p2WFa0Kdx51KIpaaxT7LVE4AGnyct5cbcPMGCguJaHti+UF/o9whXTCju+kcfszA22t7rGWq/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791293167; c=relaxed/simple;
	bh=akFvPIQoj7047XMgfMpWSI+xzVCn4iuQWXfmXjetovk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YtR7U80MeonOyzmRwXr54UjTtPjeMUkNs2xVW3NoQ3SCcTfsVIbXR78dku/kb9VDPQ7TUr11zLGIhLP3TXv+fl21ofE4Ei9sVfIofUCCGoGY6tPx9WVxV4BwCot1MonTJtc+uHspDLc2rih7Wo0XdxKC1c7cD+1mqVGbEn1qj84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9GVho30; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9GVho30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A301F000FF;
	Tue,  6 Oct 2026 13:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791293160;
	bh=LSC8s/Mh33eMrP4QZf7c10FyzuzFeEgqlEVOv26WaLU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K9GVho30gcSA4W3sO6IFMdoTVAd/5GahsfErWsCDT0NtHC96N8fFPDikD6UfuRJpr
	 ILW0kw0JvlCsyCZ+urIhawmkrSDifo+r9jKT9bLNlTyY7mTmxvxZhe8JZYQv7NgVJu
	 6kz3ZA0I+/sC7/jcwu11XzTPQziN1XhwoZOaUZth+/j36f3Y/hd/VTs4cySnFo0Tbw
	 gBTk0XsmS/MGguN/op48/uWrxv8b+7+HJ76riWufmPp1Axj4tpD+3KLdNCMDA5oFbh
	 lrr2D3iPXJpmf/lfuP3GwAA1TS0HCbMyuaUOCC/glsNP7mrk8+5ZW3hkaYEvK79KdM
	 /gtNKL8p8ngkA==
Date: Tue, 6 Oct 2026 06:26:00 -0700
From: Kees Cook <kees@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Bill Wendling <morbo@google.com>, Ian Bridges <icb@fastmail.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v5 03/12] scsi: lpfc: Print rx monitor records straight
 into the seq_buf
Message-ID: <202610060624.88739E8B@keescook>
References: <20261005155653.late.426-kees@kernel.org>
 <20261005155708.1471260-3-kees@kernel.org>
 <20261005195411.3e09bc8e@pumpkin>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005195411.3e09bc8e@pumpkin>

On Mon, Oct 05, 2026 at 07:54:11PM +0100, David Laight wrote:
> On Mon,  5 Oct 2026 08:56:53 -0700
> Kees Cook <kees@kernel.org> wrote:
> 
> > lpfc_rx_monitor_report() formats each record into a stack buffer, then
> > appends it with seq_buf_puts(), relying on seq_buf_puts() appending
> > nothing when a string does not fit: the debugfs output then ends at the
> > last whole record, and the record left out is read in full next time.
> > The next patch makes seq_buf_puts() copy as much as fits instead, as
> > seq_buf_printf() and strlcat() do.
> > 
> > Print each record with seq_buf_printf(), and when it does not fit, end
> > the string where the record began, since the reader takes the buffer up
> > to its NUL. This also takes the DBG_LOG_STR_SZ buffer off the stack.
> > 
> > Build tested ARCH=x86_64 with GCC 16.2.0, CONFIG_SCSI_LPFC=m and W=1.
> > 
> > Assisted-by: LLM
> > Signed-off-by: Kees Cook <kees@kernel.org>
> > ---
> >  drivers/scsi/lpfc/lpfc_sli.c | 45 +++++++++++++++++++++---------------
> >  1 file changed, 27 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> > index cfa4371169f1..a7b1ea67ed98 100644
> > --- a/drivers/scsi/lpfc/lpfc_sli.c
> > +++ b/drivers/scsi/lpfc/lpfc_sli.c
> > @@ -8108,7 +8108,6 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
> >  	spinlock_t *ring_lock = &rx_monitor->lock;
> >  	u32 ring_size = rx_monitor->entries;
> >  	u32 cnt = 0;
> > -	char tmp[DBG_LOG_STR_SZ] = {0};
> >  	bool log_to_kmsg = (!buf || !buf_len) ? true : false;
> >  	struct seq_buf s;
> >  
> > @@ -8133,27 +8132,37 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
> >  
> >  		/* Read out this entry's data. */
> >  		if (!log_to_kmsg) {
> > +			unsigned int len;
> > +
> > +			/* A header that did not fit leaves no room. */
> > +			if (seq_buf_has_overflowed(&s))
> > +				break;
> > +			len = seq_buf_used(&s);
> > +
> > +			seq_buf_printf(&s,
> > +				       "%03d:\t%-16llu%-16llu%-16llu%-16llu%-8llu%-8llu%-8llu%-8u%-8u%-8u%u(%u)\n",
> > +				       *head_idx,
> > +				       entry->max_bytes_per_interval,
> > +				       entry->cmf_bytes,
> > +				       entry->total_bytes,
> > +				       entry->rcv_bytes,
> > +				       entry->avg_io_latency,
> > +				       entry->avg_io_size,
> > +				       entry->max_read_cnt,
> > +				       entry->cmf_busy, entry->io_cnt,
> > +				       entry->cmf_info,
> > +				       entry->timer_utilization,
> > +				       entry->timer_interval);
> > +
> >  			/*
> >  			 * Drop a record whole if it does not fit, without
> > -			 * consuming its ring entry.
> > +			 * consuming its ring entry: the reader takes the
> > +			 * string up to its NUL.
> >  			 */
> > -			scnprintf(tmp, sizeof(tmp),
> > -				  "%03d:\t%-16llu%-16llu%-16llu%-16llu%-8llu%-8llu%-8llu%-8u%-8u%-8u%u(%u)\n",
> > -				  *head_idx,
> > -				  entry->max_bytes_per_interval,
> > -				  entry->cmf_bytes,
> > -				  entry->total_bytes,
> > -				  entry->rcv_bytes,
> > -				  entry->avg_io_latency,
> > -				  entry->avg_io_size,
> > -				  entry->max_read_cnt,
> > -				  entry->cmf_busy, entry->io_cnt,
> > -				  entry->cmf_info,
> > -				  entry->timer_utilization,
> > -				  entry->timer_interval);
> > -
> > -			if (seq_buf_puts(&s, tmp) < 0)
> > +			if (seq_buf_has_overflowed(&s)) {
> > +				buf[len] = '\0';
> 
> There should probably be a seq_buf_truncate() to do that.
> Then a request for the length will be correct.

We don't really have a "rewind" API. (Oh please don't make me add
another API ... I'm at 3 already in this series...)


-- 
Kees Cook
