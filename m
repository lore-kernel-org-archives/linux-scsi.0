Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECE0416851
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 20:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791403840; cv=none; b=M8U7VDRV+KYehn25EGpNySKvTrn8Lm1rBK5dXJExCp2Y/aoUcghQBEb/F/YjSIPWvUKmEJ0kVXoBp5f7DK+5QdChzNmX2RIPT8XkDOHkNDlw9AkuKwjje3YkzCQhA2t2zvVM5u4kA+xAyN9Wbu+lRAgZAgqMrhv2lwPbMZDt2yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791403840; c=relaxed/simple;
	bh=Tcno/iCJyHeHq1vpc4Y7zIIm3Gc1BTssIyu+tQMw7YM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=My3537whLKokWCKcxKzqtwVCsQaqxHau2+u28PHNPV7MfWfA7v6X3q+Wd4eBKxWWeyVpyFWf36QLv2vFYPjacX6zcQb6m9wGcFLa2ze9366L1yjJWZFc3HJWB0u1Y5dSom7RFtkvYaN1BS+pNoWyQDs/ujBrF6KuM2rSOOhxK4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cBBWUH8Q; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cBBWUH8Q"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j0PPm6Sbyz1XLwWr;
	Wed,  7 Oct 2026 20:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1791403830; x=1793995831; bh=jzZ+KAvZg+H0LXnTr/qiJovo
	qPGSdqJMAl2y7KfzeRI=; b=cBBWUH8Qag7RO/+HUSa1INIK9fcDKWqUZ427Y/Ua
	RIWP9ejdA7S40W4CrusIe67Co8/Qdc/9YgILaxHMUtgxYOxOq9A7XRV9fJLTNXqc
	X5IYPoDNcIcLDYQzyCurKM9zXf7rAGmG/ToWmZcL9R/ca5fFrmg7CovoP3sJbGOG
	MySi0I8cQh1Oi2nxhYDAdmRp1v/jwfd9II31AY3wS6tuc0YF9uHxNkl0NlRxxuvF
	rBaprLvmSBo1EQPACzFdMr8DzsBroSO+dv1fpzioA3pErdRqb4nfG2gfcAXtsJbW
	hcGVWfTYWYP8nRVtfkhERdE6AM95h94bPFWIZEHOWAr1WQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id k0r9hNA3pJjh; Wed,  7 Oct 2026 20:10:30 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:d224:603c:1a28:dc62] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j0PPc697Vz1XM0pk;
	Wed,  7 Oct 2026 20:10:28 +0000 (UTC)
Message-ID: <cf697d5c-1b5d-4e3a-983b-f710eb41b5b6@acm.org>
Date: Wed, 7 Oct 2026 13:10:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/8] scsi: scsi_debug: Improve lock context annotations
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Marco Elver <elver@google.com>, llvm@lists.linux.dev
References: <cover.1791349129.git.bvanassche@acm.org>
 <765bf3683555f3d7fbe8510cde1eb50d5f6d0c6f.1791349129.git.bvanassche@acm.org>
 <20261007131411.GE30647@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261007131411.GE30647@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/7/26 6:14 AM, Christoph Hellwig wrote:
> On Tue, Oct 06, 2026 at 10:07:29PM -0700, Bart Van Assche wrote:
>>   static inline void
>>   sdeb_read_lock(rwlock_t *lock)
>> +	__acquires_shared(lock)
>> +	__context_unsafe(/*conditional locking*/)
>>   {
>> -	if (sdebug_no_rwlock)
>> -		__acquire(lock);
>> -	else
>> +	if (!sdebug_no_rwlock)
>>   		read_lock(lock);
>>   }
> 
> Is there no way we can make the spare-style __acquire/__release work for
> clang?  That would be this and similar patterns so much better and
> safer than the blanket __context_unsafe.

Hi Christoph,

Do you like the alternative below better? If so then I will replace
patch 7/8 with the changes below.

Thanks,

Bart.


diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b339f022af26..e8d8b693751e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4052,42 +4052,47 @@ static inline struct sdeb_store_info 
*devip2sip(struct sdebug_dev_info *devip,

  static inline void
  sdeb_read_lock(rwlock_t *lock)
+	__acquires_shared(lock)
  {
-	if (sdebug_no_rwlock)
-		__acquire(lock);
-	else
+	if (!sdebug_no_rwlock)
  		read_lock(lock);
+	else
+		__acquire_shared(lock);
  }

  static inline void
  sdeb_read_unlock(rwlock_t *lock)
+	__releases_shared(lock)
  {
-	if (sdebug_no_rwlock)
-		__release(lock);
-	else
+	if (!sdebug_no_rwlock)
  		read_unlock(lock);
+	else
+		__release_shared(lock);
  }

  static inline void
  sdeb_write_lock(rwlock_t *lock)
+	__acquires(lock)
  {
-	if (sdebug_no_rwlock)
-		__acquire(lock);
-	else
+	if (!sdebug_no_rwlock)
  		write_lock(lock);
+	else
+		__acquire(lock);
  }

  static inline void
  sdeb_write_unlock(rwlock_t *lock)
+	__releases(lock)
  {
-	if (sdebug_no_rwlock)
-		__release(lock);
-	else
+	if (!sdebug_no_rwlock)
  		write_unlock(lock);
+	else
+		__release(lock);
  }

  static inline void
  sdeb_data_read_lock(struct sdeb_store_info *sip)
+	__acquires_shared(&sip->macc_data_lck)
  {
  	BUG_ON(!sip);

@@ -4096,6 +4101,7 @@ sdeb_data_read_lock(struct sdeb_store_info *sip)

  static inline void
  sdeb_data_read_unlock(struct sdeb_store_info *sip)
+	__releases_shared(&sip->macc_data_lck)
  {
  	BUG_ON(!sip);

@@ -4104,6 +4110,7 @@ sdeb_data_read_unlock(struct sdeb_store_info *sip)

  static inline void
  sdeb_data_write_lock(struct sdeb_store_info *sip)
+	__acquires(&sip->macc_data_lck)
  {
  	BUG_ON(!sip);

@@ -4112,6 +4119,7 @@ sdeb_data_write_lock(struct sdeb_store_info *sip)

  static inline void
  sdeb_data_write_unlock(struct sdeb_store_info *sip)
+	__releases(&sip->macc_data_lck)
  {
  	BUG_ON(!sip);

@@ -4120,6 +4128,7 @@ sdeb_data_write_unlock(struct sdeb_store_info *sip)

  static inline void
  sdeb_data_sector_read_lock(struct sdeb_store_info *sip)
+	__acquires_shared(&sip->macc_sector_lck)
  {
  	BUG_ON(!sip);

@@ -4128,6 +4137,7 @@ sdeb_data_sector_read_lock(struct sdeb_store_info 
*sip)

  static inline void
  sdeb_data_sector_read_unlock(struct sdeb_store_info *sip)
+	__releases_shared(&sip->macc_sector_lck)
  {
  	BUG_ON(!sip);

@@ -4136,6 +4146,7 @@ sdeb_data_sector_read_unlock(struct 
sdeb_store_info *sip)

  static inline void
  sdeb_data_sector_write_lock(struct sdeb_store_info *sip)
+	__acquires(&sip->macc_sector_lck)
  {
  	BUG_ON(!sip);

@@ -4144,6 +4155,7 @@ sdeb_data_sector_write_lock(struct sdeb_store_info 
*sip)

  static inline void
  sdeb_data_sector_write_unlock(struct sdeb_store_info *sip)
+	__releases(&sip->macc_sector_lck)
  {
  	BUG_ON(!sip);

@@ -4165,102 +4177,122 @@ sdeb_data_sector_write_unlock(struct 
sdeb_store_info *sip)

  static inline void
  sdeb_data_lock(struct sdeb_store_info *sip, bool atomic)
+	__acquires(&sip->macc_data_lck)
  {
-	if (atomic)
+	if (atomic) {
  		sdeb_data_write_lock(sip);
-	else
+	} else {
  		sdeb_data_read_lock(sip);
+		__release_shared(&sip->macc_data_lck);
+		__acquire(&sip->macc_data_lck);
+	}
  }

  static inline void
  sdeb_data_unlock(struct sdeb_store_info *sip, bool atomic)
+	__releases(&sip->macc_data_lck)
  {
-	if (atomic)
+	if (atomic) {
  		sdeb_data_write_unlock(sip);
-	else
+	} else {
+		__release(&sip->macc_data_lck);
+		__acquire_shared(&sip->macc_data_lck);
  		sdeb_data_read_unlock(sip);
+	}
  }

  /* Allow many reads but only 1x write per sector */
  static inline void
  sdeb_data_sector_lock(struct sdeb_store_info *sip, bool do_write)
+	__acquires(&sip->macc_sector_lck)
  {
-	if (do_write)
+	if (do_write) {
  		sdeb_data_sector_write_lock(sip);
-	else
+	} else {
  		sdeb_data_sector_read_lock(sip);
+		__release_shared(&sip->macc_sector_lck);
+		__acquire(&sip->macc_sector_lck);
+	}
  }

  static inline void
  sdeb_data_sector_unlock(struct sdeb_store_info *sip, bool do_write)
+	__releases(&sip->macc_sector_lck)
  {
-	if (do_write)
+	if (do_write) {
  		sdeb_data_sector_write_unlock(sip);
-	else
+	} else {
+		__release(&sip->macc_sector_lck);
+		__acquire_shared(&sip->macc_sector_lck);
  		sdeb_data_sector_read_unlock(sip);
+	}
  }

  static inline void
  sdeb_meta_read_lock(struct sdeb_store_info *sip)
+	__acquires_shared(&sip->macc_meta_lck)
  {
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__acquire(&sip->macc_meta_lck);
-		else
-			__acquire(&sdeb_fake_rw_lck);
-	} else {
-		if (sip)
+	if (!sdebug_no_rwlock) {
+		if (sip) {
  			read_lock(&sip->macc_meta_lck);
-		else
+		} else {
  			read_lock(&sdeb_fake_rw_lck);
+			__release_shared(&sdeb_fake_rw_lck);
+			__acquire_shared(&sip->macc_meta_lck);
+		}
+	} else {
+		__acquire_shared(&sip->macc_meta_lck);
  	}
  }

  static inline void
  sdeb_meta_read_unlock(struct sdeb_store_info *sip)
+	__releases_shared(&sip->macc_meta_lck)
  {
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__release(&sip->macc_meta_lck);
-		else
-			__release(&sdeb_fake_rw_lck);
-	} else {
-		if (sip)
+	if (!sdebug_no_rwlock) {
+		if (sip) {
  			read_unlock(&sip->macc_meta_lck);
-		else
+		} else {
+			__acquire_shared(&sdeb_fake_rw_lck);
  			read_unlock(&sdeb_fake_rw_lck);
+			__release_shared(&sip->macc_meta_lck);
+		}
+	} else {
+		__release_shared(&sip->macc_meta_lck);
  	}
  }

  static inline void
  sdeb_meta_write_lock(struct sdeb_store_info *sip)
+	__acquires(&sip->macc_meta_lck)
  {
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__acquire(&sip->macc_meta_lck);
-		else
-			__acquire(&sdeb_fake_rw_lck);
-	} else {
-		if (sip)
+	if (!sdebug_no_rwlock) {
+		if (sip) {
  			write_lock(&sip->macc_meta_lck);
-		else
+		} else {
  			write_lock(&sdeb_fake_rw_lck);
+			__release(&sdeb_fake_rw_lck);
+			__acquire(&sip->macc_meta_lck);
+		}
+	} else {
+		__acquire(&sip->macc_meta_lck);
  	}
  }

  static inline void
  sdeb_meta_write_unlock(struct sdeb_store_info *sip)
+	__releases(&sip->macc_meta_lck)
  {
-	if (sdebug_no_rwlock) {
-		if (sip)
-			__release(&sip->macc_meta_lck);
-		else
-			__release(&sdeb_fake_rw_lck);
-	} else {
-		if (sip)
+	if (!sdebug_no_rwlock) {
+		if (sip) {
  			write_unlock(&sip->macc_meta_lck);
-		else
+		} else {
+			__acquire(&sdeb_fake_rw_lck);
  			write_unlock(&sdeb_fake_rw_lck);
+			__release(&sip->macc_meta_lck);
+		}
+	} else {
+		__release(&sip->macc_meta_lck);
  	}
  }


