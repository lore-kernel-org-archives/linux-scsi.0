Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A68126F2B6;
	Sat, 20 Dec 2025 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766247007; cv=none; b=cltqpkPbcKENL+pwmAKSurCa5qctZGysSBi3JDwHz0o7PEImeILcsiYXNhed44ccuU342tTdhqZx2xva/YaKQV32LsC7MIWhlFGcFE5gJwdmcyKrfY2pw74diFxoOy5DiLBhZT495opayWbeWNaYGhSn7xth1rWvNE2Cj8lWBak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766247007; c=relaxed/simple;
	bh=3xsV0oI2wQr121cNCBKzs4dljwqZHphncWQPYAn7Pig=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=g5sWjR44W7xUUnHt7aFUxj5NoFIfE5kTxagHoIiblbYypZqsX75GUjrOTMZwItFHJovp5YQNXcU0lYfkFYEugvzQfV8fzpofbVOgw3ImJyWibNGh7r609TlPUFqWrQiTL8vHqJhPVOq1HqO5uodjrQY4Y9LIZWfS9zllQuPAsyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=kVQ7HwJG; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="kVQ7HwJG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1766246996; x=1766851796; i=markus.elfring@web.de;
	bh=ClvdF52tyBTj1vQnvRx1egcfnAzuavIbXHLKNDt764Y=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=kVQ7HwJGw8T3d1NiQOYj0dB6Nv9ZTYkSLlXuUzoSsNyDx9+oiBA1XXmOORlDEJPH
	 DoRqYElaWkqwxaY1PjIJxU/QAwIb6LMmJjkyTbCGBIxCFKmgo226m3wIqJe3ET/yC
	 3pTpE1di+n0DkQbNAlvcpmd0W6wHHapN35hKCtRgEHu6tubrO+z+a1+3/kGc0/5x0
	 65fGZxqwD/ilA3d/QFPIq7DGWUGfx4VOr+nbeNGlGXCT2W58sEZpt1d2gCm6t3awx
	 WgrFYrAKdz7HF90KbvjIB5iSYpOCMCr9805iekMdz6H1CrGNZR38ZS+ZFeM1/GDhS
	 3qivAvERAlvubAG+jg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.215]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MBS71-1vge310fMt-005yXo; Sat, 20
 Dec 2025 17:09:56 +0100
Message-ID: <53c5a56b-81fc-44af-bade-21aea79682f8@web.de>
Date: Sat, 20 Dec 2025 17:09:50 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>, linux-scsi@vger.kernel.org,
 Hannes Reinecke <hare@suse.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
 Ketan Mukadam <ketan.mukadam@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20251213083643.301240-1-lihaoxiang@isrc.iscas.ac.cn>
Subject: Re: [PATCH] scsi: be2iscsi: fix a memory leak in
 beiscsi_boot_get_sinfo()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251213083643.301240-1-lihaoxiang@isrc.iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HWJGfzw82e2VS6ty9ih7yk/E1AYV5vSWbsAX91+CDKeNLFCEAZF
 PEbtZkcLCzzbe7a972L5cv/XbPTY7HZqRjwvIU5rjZfAq8rZhNiVkFIt5wYqtsbOL9gxQ81
 B3PyMC6eOJsk1lepGB08sP+pCLEiUoFUJ9gxYb0w0hxFQysBPLaUSgITtOVDaZN+ep+TYJ2
 daDYqyW/FeOUTrZ24RYbw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:rKamhJrhLiA=;MV2aYO6MevRMquWNxBs70LMK9FG
 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
 tD/dcnUumwqMRy0v3QfgcX8gb8t4KSHIzL3nis

> If nonemb_cmd->va fails to be allocated, call free_mcc_wrb()
> to restore the impact caused by alloc_mcc_wrb().

     avoid?


=E2=80=A6
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -1025,6 +1025,7 @@ unsigned int beiscsi_boot_get_sinfo(struct beiscsi=
_hba *phba)
>  					      &nonemb_cmd->dma,
>  					      GFP_KERNEL);
>  	if (!nonemb_cmd->va) {
> +		free_mcc_wrb(ctrl, tag);
>  		mutex_unlock(&ctrl->mbox_lock);
>  		return 0;
>  	}

I suggest to avoid also repeated mutex_unlock() calls in this function imp=
lementation.

Regards,
Markus
