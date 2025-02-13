Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7E6155326;
	Thu, 13 Feb 2025 20:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739478916; cv=none; b=XCfH7yGZ9LV8XVn/pFbJDChSFwfGvq9YG38dqqokwTipSCrCQL72MmiBq9X/eRotpKOi5UoLVVAcxWJWxzBLPuoqL9fo19GWKo/UBpusJOmcKWXNjCOyTmE+wggRhM+R/3i0JTn7OO8QmC82X+dZ4eozIak6huVk5Gtk50orBpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739478916; c=relaxed/simple;
	bh=nF7G5VWK+O0cmoOpjP36eVh1sD3D/hMeBEvXQfO2MXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=odBbGt8VwZrJ1nvJK/3z37eyh9fL/lylTpq4e3pRN3dK7D1lXah5OjI0oIzQMs8fJmI+WbE80fPseQ+Sb6KIQIs1Tdd3IM26rM+kB2BgRZGnOmFwbfEf7hwgyAwpjnIJblqi7jWp7OBQIEyZ3Z6mgMYFHrVkaYpULav/1yd1DIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qBu53Lod; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qBu53Lod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017EAC4CED1;
	Thu, 13 Feb 2025 20:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739478916;
	bh=nF7G5VWK+O0cmoOpjP36eVh1sD3D/hMeBEvXQfO2MXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qBu53Lod4622Y1FVthxmlmAdSGpVHRe6m4pTH1Rm1WP2MFcnzKkIFuJ9FerwrYs4E
	 fHa5R+iaSq3CdKgY3qGPAWdGA6ssIhxqnD/0ZM9/Mc7rN6x4d4ZelfgcIBF28qBGcM
	 RsS3xpwxhNHtfhJ0Ytr9zWLwyx0xfYWRgF3Z/josreN6jgWbC8ISRXp+B+40MFBCj5
	 vU3IV2+vwSfQIj5rSEEBnPT5GKH/0/FFE1E/CUU2wi8oX1zsT6zb7Z4LqdEjdViQF8
	 EsgTLXp49Jkcmg5Wei0vLmwdR5KP/OhuDYrpH2DpqXLQ45L3et8zdTV+WrM45BUtj7
	 3+nKR52hWeU4Q==
Date: Thu, 13 Feb 2025 12:35:15 -0800
From: Kees Cook <kees@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-hardening@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>, storagedev@microchip.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: hpsa: Replace deprecated strncpy() with
 strscpy()
Message-ID: <202502131231.98A662655@keescook>
References: <20250213195332.1464-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213195332.1464-3-thorsten.blum@linux.dev>

On Thu, Feb 13, 2025 at 08:53:33PM +0100, Thorsten Blum wrote:
> strncpy() is deprecated for NUL-terminated destination buffers. Use
> strscpy() instead and remove the manual NUL-termination.
> 
> Use min() to simplify the size calculation.
> 
> Compile-tested only.
> 
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Changes in v2:
> - Adjust len to copy the same number of bytes as with strncpy()
> - Link to v1: https://lore.kernel.org/r/34BB4FDE-062D-4C1B-B246-86CB55F631B8@linux.dev/
> ---
>  drivers/scsi/hpsa.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 84d8de07b7ae..c7ebae24b09f 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -460,9 +460,8 @@ static ssize_t host_store_hp_ssd_smart_path_status(struct device *dev,

for added context:

        char tmpbuf[10];

>  
>  	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
>  		return -EACCES;
> -	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
> -	strncpy(tmpbuf, buf, len);
> -	tmpbuf[len] = '\0';
> +	len = min(count + 1, sizeof(tmpbuf));
> +	strscpy(tmpbuf, buf, len);
>  	if (sscanf(tmpbuf, "%d", &status) != 1)
>  		return -EINVAL;
>  	h = shost_to_hba(shost);

Okay, this is making sure that "len" is either the last byte of tmpbuf,
or all the bytes in buf, if it is less than sizeof(tmpbuf), and then NUL
terminates the string that was copied into tmpbuf from buf.

This is what memtostr() was made for.

> @@ -484,9 +483,8 @@ static ssize_t host_store_raid_offload_debug(struct device *dev,
>  
>  	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
>  		return -EACCES;
> -	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
> -	strncpy(tmpbuf, buf, len);
> -	tmpbuf[len] = '\0';
> +	len = min(count + 1, sizeof(tmpbuf));
> +	strscpy(tmpbuf, buf, len);
>  	if (sscanf(tmpbuf, "%d", &debug_level) != 1)
>  		return -EINVAL;
>  	if (debug_level < 0)

I think this patch should be:

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 84d8de07b7ae..bff0e768b042 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -453,16 +453,14 @@ static ssize_t host_store_hp_ssd_smart_path_status(struct device *dev,
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
 {
-	int status, len;
+	int status;
 	struct ctlr_info *h;
 	struct Scsi_Host *shost = class_to_shost(dev);
 	char tmpbuf[10];
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
-	strncpy(tmpbuf, buf, len);
-	tmpbuf[len] = '\0';
+	memtostr(tmpbuf, buf);
 	if (sscanf(tmpbuf, "%d", &status) != 1)
 		return -EINVAL;
 	h = shost_to_hba(shost);
@@ -477,16 +475,14 @@ static ssize_t host_store_raid_offload_debug(struct device *dev,
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
 {
-	int debug_level, len;
+	int debug_level;
 	struct ctlr_info *h;
 	struct Scsi_Host *shost = class_to_shost(dev);
 	char tmpbuf[10];
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	len = count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
-	strncpy(tmpbuf, buf, len);
-	tmpbuf[len] = '\0';
+	memtostr(tmpbuf, buf);
 	if (sscanf(tmpbuf, "%d", &debug_level) != 1)
 		return -EINVAL;
 	if (debug_level < 0)

-- 
Kees Cook
