Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D31F4D4868
	for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2026 18:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791226457; cv=none; b=lE7F9paFujUkstjSsiwo+gJAeNssHzdLYyfbNT2VKi4xtnz4Ac5XRl4sUBOzrDcoJzHp5p1XCiVwQDU6IELL3z1MpfCSTPiFvHgBVb1ZXMp2g8ssLPllzkkqHa2hVAWZaQtY+3+KLUuKGVA5WWlf/Pfo1NMPGLF7z5paZNaHcvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791226457; c=relaxed/simple;
	bh=JqbdXiNj+1x2KIBSRHaZMkJ5f/vKrl6ix5aX6QZUvBc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lwdhZ23TWOz9gyJ0Zfde5acKoZ7k81q1hFCT10qUxdQ3glMSsSOkH8yo6Z6SbhV5VFnKtT9pfeUXlrJ2PXwkH8GTV1gqjl5u+oasd/Mcz6N82kbuBIKXMzejaui3FtRc3LflsMo8aL6ncwc9ECYqTtfRYkti8fOk5EaEoV8xQq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GRCqqMwG; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GRCqqMwG"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd5462b69so13747315e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2026 11:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791226453; x=1791831253; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YSppTa1u/xUXXfMqFKbmpz8w8GUfT7lFF5B6YtHgZns=;
        b=GRCqqMwGio24omLD1gIyIBxOsvgYN8IUnuO1FSqHuH1b+fPTo4NJ8LL2zyKv+gfbii
         SY6OVmESQ3Wy9Iqj9eTYO/zW8cdfr6Y6jl3B2aFRdrP98nfhvOyWuslV8KUzgbZ2isPV
         xBqC/gYEO2FQa0pCCJfgZD1bLRoKy20S/zuwsJbSsEFLOcmp09OWAvcNIhED3arDyVXM
         R8/yppMjiWWtRE8oGQ6LdeQWhXy3RgM6E7MzS9cUOXXF7q4PCpSKwX8WUpJCh+TaSEuo
         FON4MOsF1DGKD87wNLpp4y+Ga0XKghT4uOSfeUwkSpjaYzMn49BoV8Mh8kZiTyXDo8pJ
         S1Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791226453; x=1791831253;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YSppTa1u/xUXXfMqFKbmpz8w8GUfT7lFF5B6YtHgZns=;
        b=OhHtBTjjwogpPvqwH0jaxgTmeK5/qdaAan76Rxvilv/sQXcscQY1DBxtxie0w5KtKj
         IiD3LRlNsTaEoWL1Kkmt/zbg+Oc6JhOkkEFtBcKc5E1dd88seK05rftExAil5MQLtSkH
         MMeOJtKjr/rYYV7UbLNS12xqc5juyK8CWbVuarWoJOPyEBlMXbHkESa/f3Kdxkx8kZQc
         0ksJzQQCf39mddDV1aztLHzq4wGN8br0gcgVqNSbRjrK8W/BgVjQt63fYakQRrgheM9V
         Ylqy3mxp8+5nCmkoRb+tnArkDzmAblwHrI+ZVJBR0ORINlU2GSi5k1pnQVUCkn6N/fsK
         R/vQ==
X-Forwarded-Encrypted: i=1; AKwUvBxTk9wqGqZk0hn3n+8TLRbbpKrh59cwh8xWqege30glP13cIBvoGDsvKKB/0w3rDASPYzvZz8E10nfq@vger.kernel.org
X-Gm-Message-State: AFuF++nL74jcgjwuZ2whkYnI4dgsJj9G+od25foligzr7icoXhra3gx0
	vEm/RKuvp1ZQi6eSutZUf7yEz2UYOeGyAx1VZSuw5hjo36OoxpV9Nv9D
X-Gm-Gg: AYBFou3IQEhhuH5gwqv+TBF7KRR1vAdftq6oaOz+qmbIg8sdV2rxjXo5XzZ/H+Czwdk
	zXiDe0xHWQuMuyzXVPE6vcgTATlJSsyIo7Eqcw8CNH3jFugvRuRsz4X6q4zYAdOGSS/zlf7w8Ol
	SLAbX9l8uDXczD95T2QLLiu3dx4xvaf1QaaBzJeoWbrkpnKYGHrt1CQ85fIlQ/GSCWKuO9JpcwK
	dghLBrz2pUrya8tP/GOnl0VfQG/xSnJ5+9S0+x3zL7YQbq/ki3vJ9qSzEH3QQLMevmQj0D5uGHV
	y5ZavvbJekMkD9zUotRj2ERV80Nkn+FVTs3S1HYhurOojml8J5KsVODLK2DXH4rB0RtPDWrObIA
	BZ8byCRXmuHnQtJ6GmVZODs4ujErvD0xwfgZEMEKJS8pqGau8TkfDwhlFXv38PW1mcDk5x8xMQ4
	vqm/4w6ifNCBGuI+EkmAd0P5R6OR7yXf46gPffo/jL3vIqLgrBxdCAo3SeNM0KHx4pUpB2lOKy1
	b3Ku8GTehJ8Hfnf82JFivLR8GiAVO7ykwQ=
X-Received: by 2002:a05:600c:4f8e:b0:49f:f0bd:1e40 with SMTP id 5b1f17b1804b1-4a02769cf66mr195041635e9.23.1791226453264;
        Mon, 05 Oct 2026 11:54:13 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c622affadsm5117770f8f.40.2026.10.05.11.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 11:54:13 -0700 (PDT)
Date: Mon, 5 Oct 2026 19:54:11 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Kees Cook <kees@kernel.org>
Cc: Bill Wendling <morbo@google.com>, Ian Bridges <icb@fastmail.org>, Justin
 Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v5 03/12] scsi: lpfc: Print rx monitor records straight
 into the seq_buf
Message-ID: <20261005195411.3e09bc8e@pumpkin>
In-Reply-To: <20261005155708.1471260-3-kees@kernel.org>
References: <20261005155653.late.426-kees@kernel.org>
	<20261005155708.1471260-3-kees@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  5 Oct 2026 08:56:53 -0700
Kees Cook <kees@kernel.org> wrote:

> lpfc_rx_monitor_report() formats each record into a stack buffer, then
> appends it with seq_buf_puts(), relying on seq_buf_puts() appending
> nothing when a string does not fit: the debugfs output then ends at the
> last whole record, and the record left out is read in full next time.
> The next patch makes seq_buf_puts() copy as much as fits instead, as
> seq_buf_printf() and strlcat() do.
> 
> Print each record with seq_buf_printf(), and when it does not fit, end
> the string where the record began, since the reader takes the buffer up
> to its NUL. This also takes the DBG_LOG_STR_SZ buffer off the stack.
> 
> Build tested ARCH=x86_64 with GCC 16.2.0, CONFIG_SCSI_LPFC=m and W=1.
> 
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 45 +++++++++++++++++++++---------------
>  1 file changed, 27 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index cfa4371169f1..a7b1ea67ed98 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -8108,7 +8108,6 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
>  	spinlock_t *ring_lock = &rx_monitor->lock;
>  	u32 ring_size = rx_monitor->entries;
>  	u32 cnt = 0;
> -	char tmp[DBG_LOG_STR_SZ] = {0};
>  	bool log_to_kmsg = (!buf || !buf_len) ? true : false;
>  	struct seq_buf s;
>  
> @@ -8133,27 +8132,37 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
>  
>  		/* Read out this entry's data. */
>  		if (!log_to_kmsg) {
> +			unsigned int len;
> +
> +			/* A header that did not fit leaves no room. */
> +			if (seq_buf_has_overflowed(&s))
> +				break;
> +			len = seq_buf_used(&s);
> +
> +			seq_buf_printf(&s,
> +				       "%03d:\t%-16llu%-16llu%-16llu%-16llu%-8llu%-8llu%-8llu%-8u%-8u%-8u%u(%u)\n",
> +				       *head_idx,
> +				       entry->max_bytes_per_interval,
> +				       entry->cmf_bytes,
> +				       entry->total_bytes,
> +				       entry->rcv_bytes,
> +				       entry->avg_io_latency,
> +				       entry->avg_io_size,
> +				       entry->max_read_cnt,
> +				       entry->cmf_busy, entry->io_cnt,
> +				       entry->cmf_info,
> +				       entry->timer_utilization,
> +				       entry->timer_interval);
> +
>  			/*
>  			 * Drop a record whole if it does not fit, without
> -			 * consuming its ring entry.
> +			 * consuming its ring entry: the reader takes the
> +			 * string up to its NUL.
>  			 */
> -			scnprintf(tmp, sizeof(tmp),
> -				  "%03d:\t%-16llu%-16llu%-16llu%-16llu%-8llu%-8llu%-8llu%-8u%-8u%-8u%u(%u)\n",
> -				  *head_idx,
> -				  entry->max_bytes_per_interval,
> -				  entry->cmf_bytes,
> -				  entry->total_bytes,
> -				  entry->rcv_bytes,
> -				  entry->avg_io_latency,
> -				  entry->avg_io_size,
> -				  entry->max_read_cnt,
> -				  entry->cmf_busy, entry->io_cnt,
> -				  entry->cmf_info,
> -				  entry->timer_utilization,
> -				  entry->timer_interval);
> -
> -			if (seq_buf_puts(&s, tmp) < 0)
> +			if (seq_buf_has_overflowed(&s)) {
> +				buf[len] = '\0';

There should probably be a seq_buf_truncate() to do that.
Then a request for the length will be correct.

David 

>  				break;
> +			}
>  		} else {
>  			lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
>  					"4410 %02u: MBPI %llu Xmit %llu "

