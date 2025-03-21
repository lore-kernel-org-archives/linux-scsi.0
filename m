Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18FEA18B46E;
	Fri, 21 Mar 2025 07:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.143.206.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742543140; cv=none; b=V1fekF6xuYdsh9zkXJcFqKj3ON/F9GRZ1uw3QmTvS5HLq/atNRGleeOCY7Y8wMdwZ9PC0/BWAtAIF/PIRoYU+sg3pMyZx0K7pwMxuxyEDX/bb8QbuTZyUZOuX17v/r3BLeaZMXnNx7y/Gov3lGB+PUGM4JyfIu1vEobjTHOmJqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742543140; c=relaxed/simple;
	bh=88Exi2HZ9Cc6huUhql+Ovz5rbiT40NweTdFXZoOdqEM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qBp4A3TpgWtdl9kbOHdToTvdM7zOAnHK3mSl/M+W67wWw8ASqdiEGAZH6OaHapUFv5tTTRBThk3bjMSEqzheeeu9X1xTQGeoduwrHhTnHBIZfo1HukNOdO+8gpZXn1Hi2ONgY6kVd96WYzBxiaHuGWOMW4y1qxXjV3t24eHfQiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=118.143.206.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: FBRpd6qkS9acFf+w/ToNGQ==
X-CSE-MsgGUID: 5biK3S1MQNKhmprzYLRN5g==
X-IronPort-AV: E=Sophos;i="6.14,264,1736784000"; 
   d="scan'208";a="109466495"
From: ZhangHui <zhanghui31@xiaomi.com>
To: <ebiggers@kernel.org>
CC: <James.Bottomley@hansenpartnership.com>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <bvanassche@acm.org>, <linux-kernel@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<peter.griffin@linaro.org>, <zhanghui31@xiaomi.com>
Subject: Re: [PATCH] ufs: crypto: add host_sem lock in ufshcd_program_key
Date: Fri, 21 Mar 2025 15:45:23 +0800
Message-ID: <20250321074524.126338-1-zhanghui31@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250321044455.GB98513@sol.localdomain>
References: <20250321044455.GB98513@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BJ-MBX03.mioffice.cn (10.237.8.123) To YZ-MBX07.mioffice.cn
 (10.237.88.127)

On Thu, Mar 20, 2025 at 09:44:55PM -0700, Eric Biggers wrote:
> It seems broken that the filesystem doesn't get unmounted until after the UFS is
> shut down.  It would be helpful to get a clearer picture of exactly why things
> are happening in that order.
> 
> But disregarding that, it's indeed logical for blk_crypto_evict_key() to return
> an error if it cannot fulfill the request.
> 
> But I'm wondering if this needs to be solved in the UFS driver itself or whether
> the blk-crypto framework should handle this (so that it also gets fixed for
> other drivers that may have the same problem).  In block/blk-crypto-profile.c,
> pm_runtime_get_sync() is already called before ->keyslot_evict.  So
> ->keyslot_evict is supposed to be called only when the device is resumed.
> 
> The blk-crypto code (in blk_crypto_hw_enter()) doesn't check the return value of
> pm_runtime_get_sync(), though.  That seems like a bug.  Is it possible this
> issue would be fixed if it checked the return value?
> 

hi Eric,

I have checked the device_shutdown process and it seems only wait for the resume
that has not been processed to be completed, and then continue. It does not seem
to cause pm_runtime_get_sync to return an error.

> Or does the UFS driver still need to check ufshcd_is_user_access_allowed() too?
> If that's the case, I'm also wondering whether it's okay to nest host_sem inside
> pm_runtime_get_sync().  Elsewhere in the UFS driver they are called in the
> opposite order.

I found that ufshcd_is_user_access_allowed is used in many places in the ufs driver
code. What is the historical reason for this?

thanks
zhanghui

