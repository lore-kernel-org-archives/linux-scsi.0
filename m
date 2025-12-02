Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169891D47B4
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 01:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764638988; cv=none; b=BxqQD/5JlaCR0W9upRBM78lts6w/rGwYe7WK/N/ERwrJQjL1AvKcFh4S9eCF6dMPeSwocbPrDfPb+5alOAGuR0KdRpHTGWwdqO+vR08QuMhagzYKTl9U2OpuqmVTEvSdNHLdHpqbjfXFXYUZyc3M6XVviDx+HIT/fiGlDVLlhdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764638988; c=relaxed/simple;
	bh=PJGSrQwgKLTaNJmkPldPLbl6UIQtiUe5Bo9RauaNCi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QV0iZcbwRkD0MkSNdSsjPvpU/2NJSZoI23Lf6PVigxWUkVITSOtiKRjdzpoqr8dvQ7gRjy5NPhq4ZCUPI6bETwMBcVq1dsJQSgk5X7peEQPQZ8xauvmVdxpXnkiMmOMpl/G8P9/gejYM37/+/cIxTI4yDXuLRha0v//IheI8EWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wOfACgZK; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wOfACgZK"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dL3963nnhz1XM6J9;
	Tue,  2 Dec 2025 01:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764638984; x=1767230985; bh=wRXmuXinu14tKMLK0hp3mi/J
	Q9xuXCUyt3BRu+ArM2E=; b=wOfACgZKVtJ+ryu5x3Qqig7N7Bv3Uw0qICWebSnd
	Vx2f1c7Cd7AkiFwE8jJcILiPeA5U2QAQY0qQlKX0fVNRD4SGkw95cbAWWWK8SsDJ
	5fh/b7jAD2wN9a4suwDfWXGVgIPZe115LvAT6WugiE/l3ZM6iLHW95MOo+WbS7S4
	SZCEXO4yL5CZQ2sUOYfb2ROKKGbq0mnzH7uS9u10R4tgW8r/FEoKOznxQXAd1eWB
	u1mciwbNO1PujlZ+DPSZEc+XsoiXf5fGlvYGiQxXiNAOz+nDKFf0La2s1YG89cW8
	IAJArB7y6ItoHZrvIXz/RuLP7cIwQ37awiMXDwPphoBSTw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id D6dHOajtt8oa; Tue,  2 Dec 2025 01:29:44 +0000 (UTC)
Received: from [100.68.218.127] (syn-076-081-111-208.biz.spectrum.com [76.81.111.208])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dL3901DfYz1XM6JF;
	Tue,  2 Dec 2025 01:29:39 +0000 (UTC)
Message-ID: <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
Date: Mon, 1 Dec 2025 15:29:38 -1000
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
 Roger Shimizu <rosh@debian.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/28/25 6:51 PM, Manivannan Sadhasivam wrote:
> On Fri, Nov 28, 2025 at 06:31:36PM -0800, Bart Van Assche wrote:
>> On 11/27/25 8:59 AM, Manivannan Sadhasivam wrote:
>>> [1] https://lore.kernel.org/linux-scsi/20251114193406.3097237-1-bvanassche@acm.org/
>>
>> This log fragment is only 55 lines long. Please provide the full kernel
>> log.
>>
> 
> I just copied the relevant log. But you can find the full log here:
> https://gist.github.com/Mani-Sadhasivam/770022b53f11340fbaba06d8eaac1843
> 
> Unfortunately, there is not much useful information in the log.

(+Roger since he ran into a similar issue with a similar UFSHCI
controller)

Does the untested patch below help if it is applied on top of commit
1d0af94ffb5d ("scsi: ufs: core: Make the reserved slot a reserved
request")? I'm wondering whether changing hba->reserved_slot from 31 to
0 triggers some controller behavior that has not been fully documented.

Thanks,

Bart.

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 20eae5d9487b..95f5b08e1cdc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2476,7 +2476,8 @@ static inline int ufshcd_hba_capabilities(struct 
ufs_hba *hba)
         hba->nutrs = (hba->capabilities & 
MASK_TRANSFER_REQUESTS_SLOTS_SDB) + 1;
         hba->nutmrs =
         ((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 
16) + 1;
-       hba->reserved_slot = 0;
+       WARN_ON_ONCE(hba->host->nr_reserved_cmds <= 0);
+       hba->reserved_slot = hba->host->nr_reserved_cmds - 1;

         hba->nortt = FIELD_GET(MASK_NUMBER_OUTSTANDING_RTT, 
hba->capabilities) + 1;

diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index d36df24242a3..46c98910dbfb 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -135,7 +135,7 @@ enum {
  #define MINOR_VERSION_NUM_MASK         UFS_MASK(0xFFFF, 0)
  #define MAJOR_VERSION_NUM_MASK         UFS_MASK(0xFFFF, 16)

-#define UFSHCD_NUM_RESERVED    1
+#define UFSHCD_NUM_RESERVED    2
  /*
   * Controller UFSHCI version
   * - 2.x and newer use the following scheme:


