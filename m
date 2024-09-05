Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCE3155392;
	Thu,  5 Sep 2024 05:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725513000; cv=none; b=G0RVM+7cWuWWc9jH/xYrnQP56hHyQNbcDDjcfMTEUhgQy2RXDm0EQAsCP+PhboMatR9SU2FsLEU56PCqlW7j/nIKsazmt2uSa3wAlj13aHCkB02nbcGyupdKoYWRxvryLoor22dlFN+HRvPlFoeXm/v2k/y1+w1gFHVyPMlT4Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725513000; c=relaxed/simple;
	bh=0E7y7yRBCfjhFsNeMplfwL3x9L+02DL8n1LnASTAExw=;
	h=From:Subject:To:References:Cc:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=d/xKhB3gzBHgAg+YkwGRg0kroLnZa2Sh4iwoYvoQLeM37bFnXWNzsBCZVPyPrAZBxMXjShRooUgHx5PtARxh6PLbap/ld5gON7NuARloLrBn4Bqfw4DHXw19fdbBh/Md5MFHD32JHljMhXls5g0lE9HN+uyTHvQOliS49vII9nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N24wyS18; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N24wyS18"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7143ae1b48fso229164b3a.1;
        Wed, 04 Sep 2024 22:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725512997; x=1726117797; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:cc:references:to:subject:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5w5fzqj3apt6oK40ro9gvcJ+sZus76fcJwX+XM/ais=;
        b=N24wyS18uHPl6ruJ1jspKRnwlBiR/ldRFc8DPffvPDManMBfawLkIuYnP4fMRue61w
         JfsDh8Qdd0srv0J2/JbGxtsmGXUuRBOB/XD0x+JfM/d54oxXGX3ZHOrhEFaSxD+rljmJ
         PLqLe8uXbxw7uCIoU5QOR3EB61ZsZVgVu1obmD++xXpfayyUaslGsfx/ZH/qxfUdz7Nh
         Fv3kHVBj0nry0EIUaWq3yQvQrrmwkRV+1/7TqiT9CLpNRPYz0ObnGpSG4hH4BLlrZRGp
         zUQQl5+mvkbjw7o//OBL+HuiCxv/FJ7EVyRXx4Uwlqd9y4/5DpukTLDp8WNK6bAC1wxO
         FbOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725512997; x=1726117797;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:cc:references:to:subject:from:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e5w5fzqj3apt6oK40ro9gvcJ+sZus76fcJwX+XM/ais=;
        b=bwQDOKr1B75Raby4MScvU1dvJ55wKikC92p70ZD7eXMP1vczH3li5oU72Kf0ftNDUe
         JUZXoquKePxAPln5YZmeDuTQPuJfeXOi/bTsNDO4Twsh5/Jo8zGNGCZdNf61mry3642m
         AY8ItJPaYVU04rPcnPq44MJuIv5/3HAya2aakHxdMVi9e8Cv0yxd1WKHjzC9qZZp7UBY
         JppkfX6PXca/W4jimJEwr8fdr9p6k6htGOpeAGuMqKLhVexILGWirEyjsEN8iFLeThon
         udBvEEjkkbqbUXj1FNRQ6YTjbvaPkOAlbbC3Yb91iAwNUx1RPiWgdYUufGA+IRiKo+8D
         hBEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWI+O9Xs5ehTrG0GMmNw6ITAti6HWvdUS68QLab+kg1jTjfi8dSbFNfXr1NWIJ2laoYfdD8cvdfK5uf@vger.kernel.org
X-Gm-Message-State: AOJu0YzZWpj+DzU79vNg9xdyORP8e5P8taBP5RujZiCorbZhxMZUB9um
	6jwCan+4G4o13LciWsN/5AB4PH+HuPOJpcz1F93blNEw613MYiOK
X-Google-Smtp-Source: AGHT+IF1WeK1FJndZi048NN00WRTFcbVCMHyuUOGUVM99/YVPNqOKbPytba6E9tNxIEL+udApTouvA==
X-Received: by 2002:a05:6a00:9462:b0:714:1bd8:35f7 with SMTP id d2e1a72fcca58-7173fa85e0dmr14942531b3a.15.1725512996783;
        Wed, 04 Sep 2024 22:09:56 -0700 (PDT)
Received: from [10.1.1.24] (125-238-248-82-fibre.sparkbb.co.nz. [125.238.248.82])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7177859968csm2506459b3a.146.2024.09.04.22.09.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2024 22:09:56 -0700 (PDT)
From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 2/2] scsi: wd33c93: Avoid deferencing null pointer in
 interrupt handler
To: Daniel Palmer <daniel@0x0f.com>, linux-m68k@lists.linux-m68k.org,
 linux-scsi@vger.kernel.org, geert@linux-m68k.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
References: <20240903135857.455818-1-daniel@0x0f.com>
 <20240903135857.455818-2-daniel@0x0f.com>
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Message-ID: <ce330ac7-c759-f7b9-71a8-448b05f65b24@gmail.com>
Date: Thu, 5 Sep 2024 17:09:48 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240903135857.455818-2-daniel@0x0f.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Daniel.

[resent in plain text format, sorry...]

On 4/09/24 01:58, Daniel Palmer wrote:
> I have no idea if this fix is appropriate, the code in this driver
> makes my brain hurt just looking at it, but sometimes when getting
> scsi_pointer from cmd cmd itself is actually null and we get a weird
> garbage pointer for scsi_pointer.

I am not sure I read that code right (you are correct in saying all that 
state machine code inside the interrupt handler makes for headaches, but 
that's a different matter).

To me, this looks like the driver takes an interrupt without a connected 
command (that is why cmd ends up NULL). The interrupt turns out to be a 
selection interrupt, and the attempt to read the current bus phase from 
the command private data fails.

The driver does use scsi_pointer elsewhere without ever checking it's 
valid, so it would seem this case is not meant to happen. On the other 
hand, we do not expect to have a connected command while selecting, so 
this case is pretty much _guaranteed_ to happen!

It would appear that when Bart worked on this driver to move 
scsi_pointer to command private data (commit 
dbb2da557a6a87c88bbb4b1fef037091b57f701b in my tree), he overlooked the 
fact that 'cmd' is reloaded inside the interrupt handler from host 
queues, in response to interrupt conditions or phases. The copy of 
scsi_pointer initially obtained (from the connected command, without 
checking that there is in fact a command connected) is never reloaded 
though. Even if there had been a connected command, scsi_pointer would 
be stale at the point where the phase information is needed to construct 
the IDENTIFY message.

The old code used phase information from the just reloaded selecting 
command, so reloading scsi_pointer at this time (as you do) is the 
correct behaviour.

I am not certain that the test for NULL cmd at the start of the 
interrupt handler is actually required. Any part of the driver that 
changes cmd and makes use of scsi_pointer must reload scsi_pointer 
afterwards. The selection interrupt part seems the only part using 
scsi_pointer, so your fix is sufficient.

Please respin and set the appropriate Fixes: tag.

Cheers,

     Michael

> When this is accessed later on bad things happen. For my machine
> this happens when the SCSI bus is initially scanned.
>
> With this "fix" SCSI on my MVME147 is happy again.
>
> [   84.330000] wd33c93-0: chip=WD33c93B/13 no_sync=0xff no_dma=0
> [   84.330000]  debug_flags=0x00
> [   84.350000]            setup_args=
> <snip>
> [   84.490000]
> [   84.510000]            Version 1.26++ - 10/Feb/2007
> [   84.520000] scsi host0: MVME147 built-in SCSI
> [   85.480000]  sending SDTR 0103015e00
> [   85.480000] 01
> [   85.490000] 03
> [   85.500000] 01
> [   85.510000] 00
> [   85.520000] 00
> [   85.520000]  sync_xfer=30
> [   85.530000] scsi 0:0:5:0: Direct-Access     BlueSCSI HARDDRIVE        2.0  PQ: 0 ANSI: 2
> [   85.820000] st: Version 20160209, fixed bufsize 32768, s/g segs 256
> [   85.900000] sd 0:0:5:0: Attached scsi generic sg0 type 0
>
> Signed-off-by: Daniel Palmer<daniel@0x0f.com>
> ---
>   drivers/scsi/wd33c93.c | 10 +++++++---
>   drivers/scsi/wd33c93.h |  2 ++
>   2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
> index a44b60c9004a..9789d852d541 100644
> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -733,7 +733,7 @@ transfer_bytes(const wd33c93_regs regs, struct scsi_cmnd *cmd,
>   void
>   wd33c93_intr(struct Scsi_Host *instance)
>   {
> -	struct scsi_pointer *scsi_pointer;
> +	struct scsi_pointer *scsi_pointer = NULL;
>   	struct WD33C93_hostdata *hostdata =
>   	    (struct WD33C93_hostdata *) instance->hostdata;
>   	const wd33c93_regs regs = hostdata->regs;
> @@ -752,7 +752,9 @@ wd33c93_intr(struct Scsi_Host *instance)
>   #endif
>   
>   	cmd = (struct scsi_cmnd *) hostdata->connected;	/* assume we're connected */
> -	scsi_pointer = WD33C93_scsi_pointer(cmd);
> +	/* cmd could be null */
> +	if (cmd)
> +		scsi_pointer = WD33C93_scsi_pointer(cmd);
>   	sr = read_wd33c93(regs, WD_SCSI_STATUS);	/* clear the interrupt */
>   	phs = read_wd33c93(regs, WD_COMMAND_PHASE);
>   
> @@ -828,8 +830,10 @@ wd33c93_intr(struct Scsi_Host *instance)
>   		    (struct scsi_cmnd *) hostdata->selecting;
>   		hostdata->selecting = NULL;
>   
> -		/* construct an IDENTIFY message with correct disconnect bit */
> +		/* cmd should now be valid and we can get scsi_pointer */
> +		scsi_pointer = WD33C93_scsi_pointer(cmd);
>   
> +		/* construct an IDENTIFY message with correct disconnect bit */
>   		hostdata->outgoing_msg[0] = IDENTIFY(0, cmd->device->lun);
>   		if (scsi_pointer->phase)
>   			hostdata->outgoing_msg[0] |= 0x40;
> diff --git a/drivers/scsi/wd33c93.h b/drivers/scsi/wd33c93.h
> index e5e4254b1477..898c1c7d024d 100644
> --- a/drivers/scsi/wd33c93.h
> +++ b/drivers/scsi/wd33c93.h
> @@ -259,6 +259,8 @@ struct WD33C93_hostdata {
>   
>   static inline struct scsi_pointer *WD33C93_scsi_pointer(struct scsi_cmnd *cmd)
>   {
> +	WARN_ON_ONCE(!cmd);
> +
>   	return scsi_cmd_priv(cmd);
>   }
>   
