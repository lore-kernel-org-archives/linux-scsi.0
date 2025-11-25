Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1918A329E66;
	Tue, 25 Nov 2025 17:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764090911; cv=none; b=VXMpMyPOczCqKF87+jisYJ+Nvbf0a5AEv1Sa8yZrnSNki+68ojJcehyawJ8XRNd+x4Yj6JP43uuE5LhhqbDj2dB1fJ1fao0lBI7zu7cL05I97vhwiUSfutmZNqIsxRMe4RvJm8+TabFvprX8DvrnRxwQDv665/TXI/p0MhwfXb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764090911; c=relaxed/simple;
	bh=OcwrmxPc8idBxxhd80HaC+UsrAFUT5hpiUULCLR459g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qWkD+GHA7rSGrW1IBS9gijkV9Rsa+r6+7cjMGgM+0UXinsqH4kI70XOqrhNYYD+FzLCYSwOLJqaShGFeW7aLfaGqwYinQ62VKXtUJs9A5qypk3TcMSGNYanW9ZDHiIV4s7Emt5otbsqjKHazGfUqV+Yxm0vDmURsYuLkAncjHiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mvobnqUY; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mvobnqUY"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4dG8T66TnNzm1Dsn;
	Tue, 25 Nov 2025 17:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764090904; x=1766682905; bh=LyWyCloUdHrGYWyY72Ay1h0C
	NqbHDupZm7mkxO17fOo=; b=mvobnqUYMHhsXNQz+esGp80A+xfDYSeph1PZmA/+
	wZIy6+btAgam1tTSjutBM6uPrAYcAQd5q4WMDbRp5kqvQlhOPCnFiTC03D7G1cEn
	F+Cp7psmJQWa09mld78NJlB7DdQTolj6u+Zi0BQxKyQxEN/JESIbR/Pqsy9VBX8S
	2bBWS5kVPkdm1X5KqIWJSiDHX/LeCfD4KB2Uahk2cNTWPMNQdrnmSuwUxlJR3XZ1
	t2eRUfzoYyYtBmhMzhUGoQTuuf0AYozSM3tI/Kl+Xgh0o50q+ra94lSgjIzAeyvw
	MRKRJn6XewU5Ewuilt2pCCtg+aXrPLc1VvAvpUl8HvzYMg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8U4GFbvDuEgn; Tue, 25 Nov 2025 17:15:04 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4dG8Sz741Fzm1Hbg;
	Tue, 25 Nov 2025 17:14:59 +0000 (UTC)
Message-ID: <ab007560-7ccd-4ffe-9bc1-53f858c4c771@acm.org>
Date: Tue, 25 Nov 2025 09:14:57 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] libata: Stop using cmd->budget_token
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
 Niklas Cassel <cassel@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20251124182201.737160-1-bvanassche@acm.org>
 <20251124182201.737160-4-bvanassche@acm.org>
 <597e6678-d62f-48d0-8a4d-225d4a6013d8@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <597e6678-d62f-48d0-8a4d-225d4a6013d8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/24/25 9:35 PM, Damien Le Moal wrote:
> On 11/25/25 3:21 AM, Bart Van Assche wrote:
>> Since a single hardware queue is used by ATA drivers, the request tag
>> uniquely identifies in-flight commands. Stop using the SCSI budget token
>> to prepare for no longer allocating a budget token if possible. The
>> modified code was introduced by commit 4f1a22ee7b57 ("libata: Improve ATA
>> queued command allocation").
>>
>> Cc: Damien Le Moal <dlemoal@kernel.org>
>> Cc: Niklas Cassel <cassel@kernel.org>
>> Cc: John Garry <john.g.garry@oracle.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> It is very hard to review this without the cover letter and the other patches
> to give context.
> 
> So as-is, without trying to find where the other patches are, this is a big no
> from me: this will break drivers for SAS HBAs that use libsas, and so libata as
> their SAT implementation. In this case, the tag of a scsi command request is
> the HBA tag, NOT the device tag. So this simply does not work at all.
> 
> Maybe you fixed that in other patches of this series. I don't know. If you want
> a proper review with context, please send everything to the people from whom
> you expect a review.

Hi Damien,

Thank you for having provided feedback on this patch.

This patch series will have to be resent. When I resend it I will Cc you
on the entire patch series including the cover letter. If you would like
to take a look now at the cover letter and the other patches in this
series, these are available here:
https://lore.kernel.org/linux-scsi/20251124182201.737160-1-bvanassche@acm.org/

How about excluding ATA and SAS kernel drivers from this patch series by
dropping this patch and by applying something like the patch below on
top of this patch series?

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
@@ -4493,6 +4499,7 @@ int ata_scsi_add_hosts(struct ata_host *host, 
const struct scsi_host_template *s
  		shost->max_lun = 1;
  		shost->max_channel = 1;
  		shost->max_cmd_len = 32;
+		shost->needs_budget_token = true;

  		/* Schedule policy is determined by ->qc_defer()
  		 * callback and it needs to see every deferred qc.
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
@@ -217,6 +217,8 @@ static void scsi_unlock_floptical(struct scsi_device 
*sdev,

  static bool scsi_needs_budget_map(struct Scsi_Host *shost, unsigned 
int depth)
  {
+	if (shost->needs_budget_token)
+		return true;
  	if (shost->host_tagset || shost->tag_set.nr_hw_queues == 1)
  		return depth < shost->can_queue;
  	return true;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e87cf7eadd26..2b3fc8dcbf0b 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -695,6 +695,9 @@ struct Scsi_Host {
  	/* The transport requires the LUN bits NOT to be stored in CDB[1] */
  	unsigned no_scsi2_lun_in_cdb:1;

+	/* Whether the LLD uses cmd->budget_token */
+	unsigned needs_budget_token:1;
+
  	/*
  	 * Optional work queue to be utilized by the transport
  	 */

Thanks,

Bart.
