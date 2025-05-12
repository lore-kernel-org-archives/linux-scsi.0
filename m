Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B046724BD02;
	Mon, 12 May 2025 16:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747066240; cv=none; b=dHKvOQ/8na92SHRea80PrdlDIhhyLcru8gT99uZYN5bHZqQH1Y7pHmbtaBaOa/w+NWvIEgCYJXIhw68pZqf1PHpzyryv70yHhPcSuQRQ/E6fpELydEnXds8UNVLFQQoylzVp8QcP/FUgMGHZHpptChvapirF8XMCCZehSJISEnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747066240; c=relaxed/simple;
	bh=x5dkzsUmSGXFdAIE2vpjG06+LOXWs2VUeJtC+t8/c3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ItE1NR6lt8y9L1FMg4DY2RwH9x2LX1QlnaKA5kV9k0lg5/GJxtuotWSKJBS1zKbTLruy8XPuAekWcmtfBd92glEJ+fercX9bp1Kmly2ojzOuSsluUu/nrU2r9/Ql+L7HqL1bsoK8d4CKGezSRZ7B1lC6fBqsj4t+MRPuW/3iEGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA81C4CEF2;
	Mon, 12 May 2025 16:10:39 +0000 (UTC)
Date: Mon, 12 May 2025 12:11:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Kassey Li <quic_yingangl@quicinc.com>
Cc: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
 <mathieu.desnoyers@efficios.com>, <linux-kernel@vger.kernel.org>,
 <linux-trace-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: trace: change the rtn log in hex format
Message-ID: <20250512121100.1b3a77b0@gandalf.local.home>
In-Reply-To: <20250509053840.2990227-1-quic_yingangl@quicinc.com>
References: <20250509053840.2990227-1-quic_yingangl@quicinc.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 May 2025 13:38:40 +0800
Kassey Li <quic_yingangl@quicinc.com> wrote:

> In default it showed rtn in decimal.
> 
> kworker/3:1H-183 [003] ....  51.035474: scsi_dispatch_cmd_error: host_no=0 channel=0 id=0 lun=4 data_sgl=1  prot_sgl=0 prot_op=SCSI_PROT_NORMAL cmnd=(READ_10 lba=3907214  txlen=1 protect=0 raw=28 00 00 3b 9e 8e 00 00 01 00) rtn=4181
> 
> In source code we define these possible value as hexadecimal:
> 
> include/scsi/scsi.h
> 
> SCSI_MLQUEUE_HOST_BUSY   0x1055
> SCSI_MLQUEUE_DEVICE_BUSY 0x1056
> SCSI_MLQUEUE_EH_RETRY    0x1057
> SCSI_MLQUEUE_TARGET_BUSY 0x1058

Hmm, would you want to make this show text?

> 
> This change converts the rtn in hexadecimal.
> 
> Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
> ---
>  include/trace/events/scsi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index bf6cc98d9122..a4c089ac834c 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -240,7 +240,7 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
>  
>  	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
>  		  " prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s)" \
> -		  " rtn=%d",
> +		  " rtn=0x%x",

		  " rtn=%s",

>  		  __entry->host_no, __entry->channel, __entry->id,
>  		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
>  		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,

		__print_symbolic(rtn, { SCSI_MLQUEUE_HOST_BUSY, "HOST_BUSY" },
				      { SCSI_MLQUEUE_DEVICE_BUSY, "DEVICE_BUSY" },
				      { SCSI_MLQUEUE_EH_RETRY, "EH_RETRY" },
				      { SCSI_MLQUEUE_TARGET_BUSY, "TARGET_BUSY" })

?

-- Steve
