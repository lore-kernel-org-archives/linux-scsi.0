Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792496742;
	b=1FLc5o3zRTcaip2xMP1443QLzRiBoNhVjI0YPPdbTF5IKh8gTzaT3LMwb3DijiuNCNxs
	 XCJklZvfe2N5mscfoXn49Jd8GBBOQd69A2uyBflfD/hFEmfZ1dYoAciJ/x8guCItsTTsy
	 ksTtmogZHvuIcxO+GNshG7kbVqWhMW29BbpGq3uqWZ1HQQVvn2THS0A1EzVZcYIPceCTF
	 B4ztvC8JBfg87coFZnP4HNLtBhR302oIzOs4P/aORfesl1oX1kjrg+RF5z+KEwGJ72tNS
	 NaeenbBHMw375Z29eZyzKwB5MCKhC5EyxhhgdYSg2tJWIkosbX7IJQ2Wg60uItrJpvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792496742;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=5o7bq1LNEbbWgsEfPKTFPtjTTmn9qJR3M1gs+IfQMQ8=;
	b=bcoyC4Qkh1BRPL/62gkZRKvSmPo3VIXdZAubg4qRSVP8S1UDhb+iP5In7nZRO00eAedo
	 jO7Ex8zcnbYxYKW7/mz25j1AjuynaeFmsLpd9emfE1qeBeJCnCkrt4k5nIUTLczUwgltV
	 W8EZBs49jjQJ6HTgzy9qKe7anVSNdyo1vNdYVF0IsqEUABLAzkh96Q/iayQqo5vW78lT4
	 dqODVHgwhfcKpIT9FT4PAtY0vL0E2SRiumjNmYc2tWDFaMLS/SWtxlw1P2Xo3WrvEVlEb
	 PxUVevkW7QkaP3rv/LIOBIyGiD3cWrGqKY3+aQDt10pA274+nsb7euFWwzwbW6YfbCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEYyqK5K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4798606A321;
	Tue, 20 Oct 2026 11:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEYyqK5K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D951F000C4;
	Tue, 20 Oct 2026 11:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792496741;
	bh=5o7bq1LNEbbWgsEfPKTFPtjTTmn9qJR3M1gs+IfQMQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VEYyqK5KqwGQExCbyidCSdOXFNpHzRoVyO9sprj0/NkVVfjNDU8gqdVhMiqzPRgGy
	 GaLfMiceKzMIWT28r0L8S2SUGGcH/FiJm3qBF6dhwUU8kaBIV1BHtC7kLlCBka8aO6
	 tCvIvo4032EsfystBGFuwd+SyUzSar/nOPg924QA=
Date: Tue, 20 Oct 2026 13:45:36 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexander Antonakakis <alexis@maich.gr>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
	linux-scsi@vger.kernel.org, sashal@kernel.org
Subject: Re: [REGRESSION] 6.1.178+: lpfc: boot hang due to use-after-free of
 mboxq in lpfc_sli4_driver_resource_setup() backport
Message-ID: <2026102021-audio-banish-24e2@gregkh>
References: <29f6c901-5209-4681-81cc-ff768cd405f4@maich.gr>
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
In-Reply-To: <29f6c901-5209-4681-81cc-ff768cd405f4@maich.gr>

On Tue, Oct 20, 2026 at 01:23:03PM +0300, Alexander Antonakakis wrote:
> 
> Hello,
> 
> Since 6.1.178, servers with an Emulex SLI-4 Fibre Channel HBA hang
> during boot when the lpfc driver initializes. 6.1.177 works.
> 6.1.180, 6.1.187 and 6.1.190 (Debian 12 kernels 6.1.0-52 to -54)
> all hang in the same way.
> 
> Hardware:
>    Emulex LPe31000/LPe32000 Series 16Gb/32Gb Fibre Channel Adapter
>    Firmware 14.4.322.17, sli-4:2:c
>    lpfc 14.2.0.7
> 
> The cause appears to be the 6.1.y backport of:
> 
> 299f5baa1321 ("scsi: lpfc: Fix memory leak in 
> lpfc_sli4_driver_resource_setup()")
> 
> upstream commit 1bd28625e25be549ee7c47532e7c3ef91c682410
> 
> In mainline, the new mempool_free(mboxq, ...) is placed after the
> call to lpfc_get_sli4_parameters(phba, mboxq) and its error check.
> In the 6.1.y backport it landed before that call. In
> drivers/scsi/lpfc/lpfc_init.c at v6.1.178:
> 
> 8178:  mempool_free(mboxq, phba->mbox_mem_pool);
> 8187:  rc = lpfc_get_sli4_parameters(phba, mboxq);
> 8200:  mempool_free(mboxq, phba->mbox_mem_pool);  /* error path */
> 8207:  mempool_free(mboxq, phba->mbox_mem_pool);  /* error path */
> 
> So mboxq is freed, then used for a mailbox command to the HBA
> (use-after-free), and may be freed again on the error paths
> (double free). This runs on every SLI-4 HBA probe, which matches
> the hang about 2 seconds into boot.
> 
> Moving the mempool_free() at line 8178 to after the
> lpfc_get_sli4_parameters() call and its error handling, as in
> mainline, should fix it. Other stable branches that took this
> backport may be worth checking for the same placement.

Great, can you send a fix for this?

thanks,

greg k-h
