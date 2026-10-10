Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312F4346AF1
	for <linux-scsi@vger.kernel.org>; Sat, 10 Oct 2026 05:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791611386; cv=none; b=oii1MEsK2afKsj3xCYVRrOxNKDV1nEQLMlMS+StUNTDFXsBGdmTSnF5Iz9pldlTA5IEI4XvqMgCLeBBo5sYtGQUPjnvO1VSLzuOwtYRfAwpowUqvteeHEy/DgfSjWDPbpvyzGtwGYTJL04FD1MY+jpVHaEDi1nAGsnqqQvtbPCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791611386; c=relaxed/simple;
	bh=11YjS3aBQimnsp80x8+0ECW648rUHy8AMz8fIwiS0xQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CcZ78YyPxW9eLw+ud5ZsK6IlXrj0PvakFP99JuFDFOy9OlEqpGcjTq19Y6MM8aWh/Tk6Vr+Yqd8ODbnfDgO4jLnIQLr/0xSMaSxkrnT3oGkk7Jcdbd2zlL1wpnieoq0UFf6Qo4pxnDdbalrzkFCKlCKC0B3/yTl4vza7HOo14eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=pl+IFFWo; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="pl+IFFWo"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3535a54bed9so471127eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2026 22:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1791611382; x=1792216182; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1xpuBGBuv4heJCbpRtk090DDHZAYZZjZ3SWsUL8DCKM=;
        b=pl+IFFWoNV//H/Wigd9ew0Cuh2psCfiBzkUe8xP+z5yLskQZH+wlgupMt/0WrE5d77
         5Ikgnxh8y2bOXfK6QOWqmDhFB1q2vLzykJQGG2IB1DE5haNYubkoKQWs9zjPU2VAUICE
         iTWlQcFl12He6eJ842F9K0lIUwptedXDN+qt5yfYu6AAXO45z1GSeAi+wq0dygC506yS
         3nQfzPFxA1rmhI80kzEfJWTgC3eflXu7re5Xr9EQBKZwTwKMDfyQe/VKLhYsX43kXwY5
         NFZBMXckYCzp1J4hAgJfcloUtEDFfLkH+oCGVeM3NmuwbZlrvi8tcVPfuHuPwjaVXgel
         uL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791611382; x=1792216182;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1xpuBGBuv4heJCbpRtk090DDHZAYZZjZ3SWsUL8DCKM=;
        b=W1KA8AcSLgLt1Arn3uSxj+lLIaDQ11PQ3fmC4Mr/0/ge8e2/syQ9mWn1U4urr3SWQF
         gd8kPcTjOW6sl5+hX7awZjiIZ5Y0u7TfmxmdNbwb3L4IsYV026soGAYaCo2Ypvk34FJd
         s+C6NtZvjy1i+iniL9Un3JWuxz/dOHrL3/CxnNK7FsHThQc+F3/qhumC/PJUqGo+NNpL
         euYsApuOudfJfjBCRrsCTxweIUkwL3gGc0SiTHynFi36vW1Cyy+4rpDODQC/Ymv5myok
         qK8aV3FHj6CQ5UO6fsiH6KO+uY1+W9qKoLtqDh5KQk7L3e4e+W1YMh/gADTCahhjAacI
         ersg==
X-Forwarded-Encrypted: i=1; AKwUvBw+6+M5o3Aa0mbWlTwZ8dKp6tXrG+ke6O/3smADlq68wE5t1e3/qSBMkEToSEXs7sA2m3Lt2+715WMD@vger.kernel.org
X-Gm-Message-State: AFq9FYIVTPyJrHGRliATcOHkkAQDGxlwlFAqz1B0YZuT3whdoeo+U0RU
	K5OnBVvyfHc2TPzithWNDQxV0dZodSIMcSfW6rCaZS/TlzxlNd+YQ71PSlwBmxjJnjo=
X-Gm-Gg: AYBFou2+TLhLE/zvqdxqtdxluBEwI+H4Le0mmiXmyWAEhbx5tKtt5DHizHI+JidP0mI
	dioN4nREtgOwTHqP0SXWHUeoO/zTtpDpFWnIs5ggu+CeERoTT0rXXx5GKfxnRTFCgYthKYWPkSW
	MHTQ/73WNtnqQ7cWqatdRhN0GoODubpsejTL3f4EwfDkeQpipxBKl+gbc3DVmcovF4SmKWBBRqg
	DfKrBy3fw8s+jx2QPPYi6AAr8YyTERrjn6vfgHZc5HUP0zD/fPHMU0IGmOwuW9ljA59vDRpafC8
	2VTyuQjEYksBpPZagMJz3nyDoXo6q/Mt9DVmb2heYHNA/nxO5bTHn48g5Uvhg1QwJCamk0pDndh
	MKHNIeE1Gcfag0/ZuLQHBISi5I2YzuOXgH0tRMngK7uo1psDPCEacqjywa/ynDAskgjfZ4qozy7
	+zNwFlIB9CIdUBLpd1TkGalamht5TzvbUGcfQpH8kyZ/gsVBLUS1t23vIbmX0AvzJ5YtIV+E2Gq
	lhvIQ3APDksantKJXcLRdf4DCTXQtSOLAV1+5EqcFWMhCDptIXWOfq5Slg5m714yNNGoPzfZcdU
	pZyeM+98RA==
X-Received: by 2002:a05:693c:2289:b0:34b:5ab2:e200 with SMTP id 5a478bee46e88-3537e0788bemr7193296eec.14.1791611381889;
        Fri, 09 Oct 2026 22:49:41 -0700 (PDT)
Received: from Metius ([103.158.43.44])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca1cc25sm13543066eec.8.2026.10.09.22.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 22:49:41 -0700 (PDT)
Date: Sat, 10 Oct 2026 11:19:35 +0530
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: Andrey Misiurov <andrey.misyrov@gmail.com>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org, sashal@kernel.org, 
	justin.tee@broadcom.com, paul.ely@broadcom.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 6.1.y] scsi: lpfc: Fix use-after-free of mboxq in
 lpfc_sli4_driver_resource_setup()
Message-ID: <irfspelsns7bao36eh5i5gebv2ktqguoinjsvmeebmwpbet34h@kuteiore4fx6>
References: <20261008184328.2857037-1-andrey.misyrov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008184328.2857037-1-andrey.misyrov@gmail.com>

On Thu, Oct 08, 2026 at 08:43:28PM +0200, Andrey Misiurov wrote:
> Move the mempool_free() to where upstream and the other stable trees
> have it.
> 
> Fixes: 299f5baa1321 ("scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()")
> Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>

I'm the author of the upstream patch (not a maintainer). 
The fix looks good to me. Thanks for catching this.

Acked-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>

How did you detect this? Just curious.

Regards,
Nihaal
