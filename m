Received: from outbound.easymail.ca (outbound.easymail.ca [64.68.200.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F8937AA9C
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 18:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.68.200.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790621730; cv=none; b=CrPMQmHShHUYRpirBXHqEPvCqxieMdEYH7qpQUy7u4a0/dlD4VgKM5iJHRZtf2qEIFgPphvD/8gl3UjfixZeRTMOMKsdUYxR7cQsEhzXDcikbdS/zJs9K8FHSR5B+VATpT2EqCUNQHpr2Z53zk7E4RB1Do01F0PXur/TLkOYUZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790621730; c=relaxed/simple;
	bh=coENoMSuIkzsez6ygxHJ5CQyS7ug4CU+Z0oRPxhCyu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o6HXPLdJGB9FMEz7SFNYJll+sj7zSun7/rpjTZRXrfEZCrtH8IgULM2kAur0pOm4c/6QVWYOVO8cuBt8vdfkpFH2nhhP622dgetd5aM7yIPfw6N0GgZNBdyvZt/m4UocU4fsGtJUTrFZwZmi7DlkPW9uOO8OXnDeRJyKALmorC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gonehiking.org; spf=pass smtp.mailfrom=gonehiking.org; dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.b=GtHtDvSi; dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.b=GtHtDvSi; arc=none smtp.client-ip=64.68.200.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gonehiking.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gonehiking.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.b="GtHtDvSi";
	dkim=pass (2048-bit key) header.d=gonehiking.org header.i=@gonehiking.org header.b="GtHtDvSi"
Received: from mailout.easymail.ca (pco.easydns.net [64.68.203.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by outbound.easymail.ca (Postfix) with ESMTPS id BC12320B78;
	Mon, 28 Sep 2026 18:55:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mailout.easymail.ca (Postfix) with ESMTP id A969061139;
	Mon, 28 Sep 2026 18:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gonehiking.org;
	s=easymail; t=1790621721;
	bh=i984+zcrJMYqsZIQ8iNcwpvF9rDs4VvR74KKi7j0tF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GtHtDvSiMQ/SIdNWQvENjY1v1h3d80A6dEjaie3TSXpRlLw2BJalT/I/l35gY9Y0U
	 NMvGX8TzhuviuSV7Bu5dcAaka4DVz0fsmWMn7NAjOy7am+fAjXOTphTl5frcNtycZv
	 P4ftxUPiOSq6CKq2vk9TxK4tksbiEspAaB0xv+jnlxE1PtpxYpzfkSNC76ZLYL8x0L
	 00HOsw13X3QIxy5vk908qkQi7GX6ph8YRIg7+s2ydKr22GpnwBE+8s/myA5eT8E4VI
	 o9IfOjfmA2e6NjaKVSlGgozb7RfrFVdiuc+l9irkR9kx5l/VaEGGFqGVZYoUOOJ7a3
	 TmObgtvW/z4Tg==
X-Virus-Scanned: Debian amavisd-new at emo07-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
	by localhost (emo07-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RIPSYKjxtIMO; Mon, 28 Sep 2026 18:55:21 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by mailout.easymail.ca (Postfix) with ESMTPSA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gonehiking.org;
	s=easymail; t=1790621721;
	bh=i984+zcrJMYqsZIQ8iNcwpvF9rDs4VvR74KKi7j0tF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GtHtDvSiMQ/SIdNWQvENjY1v1h3d80A6dEjaie3TSXpRlLw2BJalT/I/l35gY9Y0U
	 NMvGX8TzhuviuSV7Bu5dcAaka4DVz0fsmWMn7NAjOy7am+fAjXOTphTl5frcNtycZv
	 P4ftxUPiOSq6CKq2vk9TxK4tksbiEspAaB0xv+jnlxE1PtpxYpzfkSNC76ZLYL8x0L
	 00HOsw13X3QIxy5vk908qkQi7GX6ph8YRIg7+s2ydKr22GpnwBE+8s/myA5eT8E4VI
	 o9IfOjfmA2e6NjaKVSlGgozb7RfrFVdiuc+l9irkR9kx5l/VaEGGFqGVZYoUOOJ7a3
	 TmObgtvW/z4Tg==
Received: from [127.0.0.1] (localhost [127.0.0.1]) by mailout.easymail.ca (Postfix) with ESMTPSA
Received: by rhapsody (Postfix, from userid 1000)
	id 9718E1E05BB; Mon, 28 Sep 2026 12:55:20 -0600 (MDT)
Date: Mon, 28 Sep 2026 12:55:20 -0600
From: Khalid Aziz <khalid@gonehiking.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: Re: [PATCH v4 04/54] scsi: BusLogic: Pass the host pointer directly
 to several functions
Message-ID: <arq4GHK0OLyusPBh@gonehiking.org>
References: <cover.1790360262.git.bvanassche@acm.org>
 <09e99ec9c6fa24ee5fe3c47110c88a1be076e01a.1790360262.git.bvanassche@acm.org>
 <argk3DLMl_YSDOsV@gonehiking.org>
 <97ab2119-2067-4c6c-9edf-286666f94e40@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97ab2119-2067-4c6c-9edf-286666f94e40@acm.org>

On Mon, Sep 28, 2026 at 10:41:38AM -0700, Bart Van Assche wrote:
> On 9/26/26 1:02 PM, Khalid Aziz wrote:
> > On Fri, Sep 25, 2026 at 11:25:42AM -0700, Bart Van Assche wrote:
> > > -static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
> > > +static enum scsi_qc_status blogic_qcmd_lck(struct Scsi_Host *shost, struct scsi_cmnd *command)
> > 
> > Buslogic.c defines blogic_qcmd() usind "DEF_SCSI_QCMD(blogic_qcmd)" which in turn will call
> > blogic_qcmd_lck() with just struct *scsi_cmd as a single parameter as defined in
> > include/scsi/scsi_host.h. I did not see an update to DEF_SCSI_QCMD in patches 1-3. With this
> > change, callers are not being updated and that will not work. Can you double check this?
> 
> [ ... ]
> 
> > > -static DEF_SCSI_QCMD(blogic_qcmd)
> > > +static enum scsi_qc_status blogic_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> > > +{
> > > +	enum scsi_qc_status rc;
> > > +
> > > +	spin_lock_irq(&shost->host_lock);
> > > +	rc = blogic_qcmd_lck(shost, cmd);
> > > +	spin_unlock_irq(&shost->host_lock);
> > > +	return rc;
> > > +}
> Hi Khalid,
> 
> Please take a look at the above changes. It seems like these have been
> overlooked.

Yes, that change does modify caller. I prefer not to pull in macro definitions from
header files into the driver code. This opens up possibility for API inconsistencies if the
macro in header file is ever updated. Why not extract struct *scsi_host in blogic_qcmd_lck() from
struct *scsi_cmd instead and continue to use DEF_SCSI_QCMD()?

--
Khalid
