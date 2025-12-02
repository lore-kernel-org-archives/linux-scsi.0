Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765C9248896
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 16:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691437; cv=none; b=qfGylWZyulhkzzBLdfVt8duJwEQIjgjmRAv8/vempIFcJ9Vvrf1iFBhXjid0FgiWk+mlMxxKcGA3idqu+m3Hf3g+bNF+0W0M5qJKc7D48+9ajPv4zn6HBdwrSU8poH5V//2kCKza3rRa02NsIuoPrrlcyzaxf00ZuCaRlwqxWtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691437; c=relaxed/simple;
	bh=GdOcQ8bdM5FRAUdIjb9oXyIgATBZzRGAsFZWOwUdS2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=phE0VJ3SCafk9CDsdO4g641UDzWgBlqmY2NJCrkZLPZdyXl4Kz8MkhXDcf/t3QetxDqg9/N0AfRUOl9J5+weVkNifS7byOw620KU8qqbqzv5WpBGm0J+FtQmdxBfi8fmy9ItVg41EcPfRQ52q+IAKHDueSJ67cma9Th3bLvW6zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=x8v837ao; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="x8v837ao"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dLQYk3xjZzlkCQ0;
	Tue,  2 Dec 2025 16:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764691431; x=1767283432; bh=P9AGGZ2RffJ+pftS2OzGs7/c
	Pln90gYIdRuhuYBLEYs=; b=x8v837aoFoUKPibPWulsCOwy3+iTgJBo/5eXS6gA
	sNZq0a3/vTddYcPZOuEaqtZ6fppngDT3oe/ZKTb8iNuT70UJ3DO62XOO0OtoEJ0A
	oLinBH7meG4Vn2MQ69my1+EecaVoIlpMimVWgy1mNZ9Oc5V9TLShDkk5RIesb46j
	nXfRneZTe8lN+vFyjGTh/cbMOZeZlbl3kpJZlPPrCUQRGJqKO7kcfhchSYro9pre
	7sPEcNqORw/ZM1WNCATv9SfHZBBZOG5UJXeFNjATXUUChAwnIsms+w13ZDHeMqfO
	m4nqUkKQCwqqfS88netBRXLlekR0UKYmPSfTbJYVP/8VJw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EvNU_40_Dk4U; Tue,  2 Dec 2025 16:03:51 +0000 (UTC)
Received: from [10.25.100.232] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dLQYV4y2KzlkCPy;
	Tue,  2 Dec 2025 16:03:41 +0000 (UTC)
Message-ID: <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>
Date: Tue, 2 Dec 2025 06:03:40 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Roger Shimizu <rosh@debian.org>, Nitin Rawat <nitin.rawat@oss.qualcomm.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
 <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>
 <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/25 10:51 PM, Manivannan Sadhasivam wrote:
> Please share a fix on top of scsi-next or next/master.
Before a fix can be developed, the root cause needs to be identified.
We just learned that commit 1d0af94ffb5d ("scsi: ufs: core: Make the
reserved slot a reserved request") is not the root cause of the boot
hang.

Can you please help with the following:
* Verify whether or not Martin's for-next branch boots fine on the
   Qcom RB3Gen2 board (I expect this not to be the case). Martin's
   Linux kernel git repository is available at
   git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git.
* If Martin's for-next branch boots fine, bisect linux-next.
* If the boot hang is reproducible with Martin's for-next branch,
   bisect that branch. After every bisection step, apply the patch
   below to work around bisectability issues in this patch series.
   If any part of that patch fails to apply, ignore the failures.
   We already know that the boot hang does not occur with commit
   1d0af94ffb5d ("scsi: ufs: core: Make the reserved slot a reserved
   request"). There are only 35 UFS patches on Martin's for-next branch
   past that commit:
   $ git log 1d0af94ffb5d..mkp-scsi/for-next */ufs|grep -c ^commit
   35

Thanks,

Bart.


diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 1b3fbd328277..ef7d6969ef06 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -231,12 +231,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, 
struct device *dev,
  		goto fail;
  	}

-	if (shost->nr_reserved_cmds && !sht->queue_reserved_command) {
-		shost_printk(KERN_ERR, shost,
-			     "nr_reserved_cmds set but no method to queue\n");
-		goto fail;
-	}
-
  	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
  	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
  				   shost->can_queue);
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 7d6d19361af9..4259f499382f 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -374,7 +374,12 @@ static inline bool 
ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_info, u8
   */
  static inline struct scsi_cmnd *ufshcd_tag_to_cmd(struct ufs_hba *hba, 
u32 tag)
  {
-	struct blk_mq_tags *tags = hba->host->tag_set.shared_tags;
+	/*
+	 * Host-wide tags are enabled in MCQ mode only. See also the
+	 * host->host_tagset assignment in ufs-mcq.c.
+	 */
+	struct blk_mq_tags *tags = hba->host->tag_set.shared_tags ?:
+					   hba->host->tag_set.tags[0];
  	struct request *rq = blk_mq_tag_to_rq(tags, tag);

  	if (WARN_ON_ONCE(!rq))

