Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAE64252AB;
	Tue,  1 Sep 2026 17:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788284349; cv=none; b=iWcDwKmhKtuxk/dC6hLHEsG9mcWD6ISOGBcHuKgMcFaVt6levTw+dHXbvYuYW8UmZfuxtS3HP2VyioNqOxbaF8nGRbBlq6mrvwG8mneerQzjBiHchlBRw8oJ8KsMUu9KukrnqPrMypujbtWgV5HdLL5uRy+WlU47vUGs/tRLuCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788284349; c=relaxed/simple;
	bh=ZmEUc6+1+5GIbRih8FiifsWBhzfw6ZzX3usu2ADUPpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V2KBEJbeDMcuBaz8LJQeTGosp2Wb/IE7WeSEXJMIM/onHfqy7xfhCLhf82yk1Zz3Ln2uVTp1FFL8LEPNRTrT88cOkQUbqvTMlUqDODcYF4AaihBgpyfsjnSgo/5LmxhypPeUAOmDAJxe/RaOKokl75uw10z73zdKWUww927mnlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zf6Uexd9; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zf6Uexd9"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hZClb3tzHzlfvq7;
	Tue,  1 Sep 2026 17:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788284342; x=1790876343; bh=VhMiWS9zbsjYFa3kKEsqZtgE
	OgYUYwPIyZ0rNVaxAGM=; b=zf6Uexd9pe2RA4EKxMU21EN9On0HxreUEwFbkU1I
	oMmmt/CexQtea1XHowafh8aohhbfvnHRuG1RIVJ2OsOL6C0X8WZluUsH1t4NKl8M
	5kWJ5WGX3sFux8HyWFkR9i0jM6ISibIt0TGkPMDuNnUAJ798qgLuPdxfP9DiLesO
	/MpC17fiOJ3I+/g+z4b9pNizDDA1LAfIckMoQkRmSO8hV7PeWeI7AJTAdTai9TVj
	eedbdG4OuTrxLC5v7HU637rUKuTnp2g1xVfwbZsMRmB5cedFUKOIyPRAZrrQ4lq3
	JbYk7MmOFH+qjAMFiST1e+kcYCzoA6i7KQgfBj12OlXPDQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uurcTr_b2l-G; Tue,  1 Sep 2026 17:39:02 +0000 (UTC)
Received: from [100.80.227.50] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hZClS0YXszlfq9P;
	Tue,  1 Sep 2026 17:38:59 +0000 (UTC)
Message-ID: <6f78c4bd-a70b-402d-abfd-599091b67674@acm.org>
Date: Tue, 1 Sep 2026 10:38:59 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Set BLK_FEAT_SKIP_TAGSET_QUIESCE on pseudo
 SCSI devices
To: Stanley Jhu <stanleyjhu@google.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K . Petersen" <mkp@kernel.org>
Cc: hare@suse.de, john.g.garry@oracle.com, hch@lst.de,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <CAE14pdef2u=Eo7M9NGdABzsjy2o2SO=Z-U_BbRn9n45nJJR+wg@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAE14pdef2u=Eo7M9NGdABzsjy2o2SO=Z-U_BbRn9n45nJJR+wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/26 5:23 AM, Stanley Jhu wrote:
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3b82e80e807a..eb48866ed0dc 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -336,6 +336,8 @@ static struct scsi_device *scsi_alloc_sdev(struct
> scsi_target *starget,
>          sdev->sg_reserved_size = INT_MAX;
> 
>          scsi_init_limits(shost, &lim);
> +       if (scsi_device_is_pseudo_dev(sdev))
> +               lim.features |= BLK_FEAT_SKIP_TAGSET_QUIESCE;
>          q = blk_mq_alloc_queue(&sdev->host->tag_set, &lim, sdev);
>          if (IS_ERR(q)) {
>                  /* release fn is set up in scsi_sysfs_device_initialise, so

The above change will break frequency scaling because
ufshcd_pause_command_processing() also calls blk_mq_quiesce_tagset(),
isn't it? Has it been considered to remove the blk_mq_unquiesce_tagset()
call from ufshcd_err_handling_unprepare() and to change the
blk_mq_quiesce_tagset() call in ufshcd_err_handling_prepare() into
blk_mq_wait_quiesce_done()? The following comment can be kept:
	/* Wait for ongoing ufshcd_queuecommand() calls to finish. */

Thanks,

Bart.
