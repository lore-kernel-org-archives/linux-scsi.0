Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34774EB5E;
	Wed, 12 Jun 2024 19:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718220643; cv=none; b=VF1kV3FXXVeSeK9yzmU19582l+acNrb8d/5alo3EOnkjLmd0Rq0G/aMuLrDMXHHcZW+PYhFfV3j5ecPmxLulr946aEVtRY27RtH8p+iibkSj00Aefh4jfJH+EmUL6TZt3Ik+YlRcxS3CPy5olgoTpNXBLqQ1pu+ZqZst40hxrW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718220643; c=relaxed/simple;
	bh=pOKcclZG5WBcGPNDhmkX9t0VWMOahQad1f72xT6Z7lo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oNyfNHd9mS4PP4+LwhsHS8kgGT2hYVN7vtEXE4ofh+Npk0OjxYFpk0ik4y1eTNaV6TMNuzjPkYrgNzBAjLu16w0sg9tYXunBpWN/B7HmVkpjrA+B6hAVSyAErMnbZm9IQ4+1dgglfkyxG8cSRiLxatEPWd5/3wVNcSUyBT8gzJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=h4loWMPj; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="h4loWMPj"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vzwcc6lztz6Cnv3g;
	Wed, 12 Jun 2024 19:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718220637; x=1720812638; bh=xwgGaJ+ldD3QPjS7YWXLQ8Z9
	xFMNRb/6AI+EbIL/3VY=; b=h4loWMPj6eaentZVGsSvsu/zFAp5e0VJCSj9sYod
	GZ0uZm4LJNiJ+jvdFRHtGHbvvfRrsN/7lbsMuVse4lHECFkZ9NZ2GA4DnnmMg2NK
	bUbtl8rb43s26/w2rqBZAXTFEtnalfLbqhB9i3BL0kRasiV1EHgauLtygDS4tHy6
	5ee1YmTMqHR67LIqII5yAqqduoXcq4wTyx56RVPJGq3rMOShN4Mlip6Z2f+Vdn7I
	WmEYo7LWV+AUX03+D3/gLosMfyUf0tQ7ShU7Dgdn4eCXuYbeyXQATXxmPfaoxIbw
	AbHmTQcX4SigSHaQVyffvIQgbko7u6XJcEWxAQkOFeU9/g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id t-qeBMebE9_D; Wed, 12 Jun 2024 19:30:37 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VzwcX24GZz6Cnk9Y;
	Wed, 12 Jun 2024 19:30:35 +0000 (UTC)
Message-ID: <a7ac0431-2b30-43bf-bb90-1476e33aa6cd@acm.org>
Date: Wed, 12 Jun 2024 12:30:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: core: Do not query IO hints for USB devices
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
 Joao Machado <jocrismachado@gmail.com>,
 Andy Shevchenko <andy.shevchenko@gmail.com>,
 Christian Heusel <christian@heusel.eu>, stable@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20240612165249.2671204-1-bvanassche@acm.org>
 <20240612165249.2671204-3-bvanassche@acm.org>
 <de4492b5-a681-42bf-99d7-e9ba30dabeb2@rowland.harvard.edu>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <de4492b5-a681-42bf-99d7-e9ba30dabeb2@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/24 11:08 AM, Alan Stern wrote:
> You might want to do the same thing in uas.c.  I don't know if UAS
> devices suffer from the same problem, but it wouldn't be surprising if
> they do.

Hi Alan,

How about replacing patch 2/2 from this series with the patch below?

Thanks,

Bart.

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index b31464740f6c..b4cf0349fd0d 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -79,6 +79,12 @@ static int slave_alloc (struct scsi_device *sdev)
  	if (us->protocol == USB_PR_BULK && us->max_lun > 0)
  		sdev->sdev_bflags |= BLIST_FORCELUN;

+	/*
+	 * Some USB storage devices reset if the IO hints VPD page is queried.
+	 * Hence skip that VPD page.
+	 */
+	sdev->sdev_bflags |= BLIST_SKIP_IO_HINTS;
+
  	return 0;
  }

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index a48870a87a29..bb75901b53e3 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -820,6 +820,12 @@ static int uas_slave_alloc(struct scsi_device *sdev)
  	struct uas_dev_info *devinfo =
  		(struct uas_dev_info *)sdev->host->hostdata;

+	/*
+	 * Some USB storage devices reset if the IO hints VPD page is queried.
+	 * Hence skip that VPD page.
+	 */
+	sdev->sdev_bflags |= BLIST_SKIP_IO_HINTS;
+
  	sdev->hostdata = devinfo;
  	return 0;
  }

