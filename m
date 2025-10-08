Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723B32BE020;
	Wed,  8 Oct 2025 16:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759939441; cv=none; b=gi6p7LEA3p6nbQSR6LjskhQCuMJ+wtHglfSEgMwbvtCQkU7xuDDZ3eja672dOak6/XOonrZ+GkUn/jv7DokBK0wikFEsNsi5svsaTCwoGf8924HUdbw1x8rS/6iTRsWe2HqmUmZxnK1bM4gUo7OMkJ3JuCjZuBRPltFZlbDWxzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759939441; c=relaxed/simple;
	bh=qRGrciwh24/r0rMBH/z4DnVMPsm6JU9NYKa2O2p8Cyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aeCoQhdvUjk6t4uUBIvjvDEIhQHiqg91g2fplRc1QJm0xMKCkse0qiF3V+0BGzKgd7IVm6hbhO+k1DK/LU+g99s0iMbqRZmAFMj6Jkjll8TJ3KtYgo2UGeHAzNCoy4PAZGt54iLSdaAoodlezbLYsk94rzPll5/111TBmj0xRMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tFkGT4Vf; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tFkGT4Vf"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4chd996c7nzlgqxl;
	Wed,  8 Oct 2025 16:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759939435; x=1762531436; bh=i6kqsxtRDB6sbvfO8K5y5sD6
	F6tM1jHqnp6pWG6pxyE=; b=tFkGT4VfJJcWaquPYtJUVWn6+2R7UPy2umFOl7vZ
	EKYy2S6I+F4azcO/nk7Bb8vbC4doD6ahROVbHe8VzqrvBZy/ImUmjtKXw4B465GN
	VD/wuQxVsd5eoE7tx/fhwq+AsRHKPhv6HnVYvKf3CY0JGUO2DPn4bi2ER7pOT+1n
	EDAhkqwVAT3wXnKOx2HuGGtPBh5evU/WKp+OVR18NoKvOUAd9pH9QVZSIxBWiXQT
	MrBL2ovgRJkuMvFwP7iEZt1FX5WWD8VdXAtIJTbF5lE2aN5TSshVauFYy3rV9U13
	uKpIlqROl2sMR9B9C4B/LtCS6tRqReCNbe3Irlda8j6jhw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id S2QNzb7VcNYK; Wed,  8 Oct 2025 16:03:55 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4chd8v4c7KzlgqyY;
	Wed,  8 Oct 2025 16:03:42 +0000 (UTC)
Message-ID: <3fb0bc7b-bcde-417a-96ef-239af94cff54@acm.org>
Date: Wed, 8 Oct 2025 09:03:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] scsi: ufs: core: Remove duplicate macro
 definitions
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
 avri.altman@sandisk.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, can.guo@oss.qualcomm.com,
 ulf.hansson@linaro.org, beanhuo@micron.com, jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251008145854.68510-1-beanhuo@iokpp.de>
 <20251008145854.68510-2-beanhuo@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251008145854.68510-2-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/25 7:58 AM, Bean Huo wrote:
> Remove duplicate definitions of SD_ASCII_STD and SD_RAW macros from
> ufshcd-priv.h as they are already defined in include/ufs/ufshcd.h.
> 
> Suggested-by: Avri Altman <Avri.Altman@sandisk.com>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>   drivers/ufs/core/ufshcd-priv.h | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
> index d0a2c963a27d..cadee685eb5e 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -77,9 +77,6 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd);
>   int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
>   void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
>   			     struct ufshcd_lrb *lrbp);
> -
> -#define SD_ASCII_STD true
> -#define SD_RAW false
>   int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
>   			    u8 **buf, bool ascii);
>   

Please improve this patch as follows:
- Remove the ufshcd_read_string_desc() declaration from
   include/ufs/ufshcd.h because this function has not been exported.
- Change the type of the 'ascii' argument into an enumeration type.
   Code readability improves significantly if boolean arguments are
   replaced with enumeration type arguments.

Below there is an untested patch that illustrates the above.

Thanks,

Bart.


diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 1f0d38aa37f9..85d3d9e64bd7 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -80,10 +80,12 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, 
int tag);
  void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
  			     struct ufshcd_lrb *lrbp);

-#define SD_ASCII_STD true
-#define SD_RAW false
-int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
-			    u8 **buf, bool ascii);
+enum ufs_descr_fmt {
+	SD_RAW = 0,
+	SD_ASCII_STD = 1,
+};
+int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf,
+			    enum ufs_descr_fmt fmt);

  int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
  int ufshcd_send_bsg_uic_cmd(struct ufs_hba *hba, struct uic_command 
*uic_cmd);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index be4bf435da09..b10de1ade23b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3759,16 +3759,15 @@ static inline char 
ufshcd_remove_non_printable(u8 ch)
   * @desc_index: descriptor index
   * @buf: pointer to buffer where descriptor would be read,
   *       the caller should free the memory.
- * @ascii: if true convert from unicode to ascii characters
- *         null terminated string.
+ * @ufs_descr_fmt: if %SD_ASCII_STD, convert from UTF-16 to ASCII
   *
   * Return:
   * *      string size on success.
   * *      -ENOMEM: on allocation failure
   * *      -EINVAL: on a wrong parameter
   */
-int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
-			    u8 **buf, bool ascii)
+int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf,
+			    enum ufs_descr_fmt fmt)
  {
  	struct uc_string_id *uc_str;
  	u8 *str;
@@ -3797,7 +3796,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, 
u8 desc_index,
  		goto out;
  	}

-	if (ascii) {
+	if (fmt == SD_ASCII_STD) {
  		ssize_t ascii_len;
  		int i;
  		/* remove header and divide by 2 to move from UTF16 to UTF8 */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 8a5649933715..f030e9a062a3 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1428,10 +1428,6 @@ static inline int 
ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
  void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
  void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
  			     const struct ufs_dev_quirk *fixups);
-#define SD_ASCII_STD true
-#define SD_RAW false
-int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
-			    u8 **buf, bool ascii);

  void ufshcd_hold(struct ufs_hba *hba);
  void ufshcd_release(struct ufs_hba *hba);

