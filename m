Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094F222A4FC;
	Wed, 16 Apr 2025 09:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744796473; cv=none; b=gXYHUv3pFKbJmpD27HqhThutPdrS41R2wXdPgcoT2JbASehKqYAVH9+A56rX5zWAivOhOE0+kHa26x2TpKshwlNxBu8ZZyze1jWRu9W0FsBUSmjwjuUSw1r+phnnOcPQISdTFer2Kynwz2quQ5CMSCmdQm/ulYQgW3zn6y8zUl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744796473; c=relaxed/simple;
	bh=uWTVzsZR5H1pZoGNqNd2f466n6uymxcu3RqqCm+IyD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2gIQlCGv0WTbenUmq6sLVWKCAONzIDTUCv3BechrTo2IEZj38IwsDj0xqtZeecJY+r3mV2gwK5PsMPnZLWXv/o1Z/6PbF5h8KStSF5R96AiqpHphyqcOycsua0tzkbDE8TyY0tO/fFopyan3T3y9vJWU7ITUDp2dIih9rDchYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uGTk1qnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uGTk1qnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB7DC4CEE2;
	Wed, 16 Apr 2025 09:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744796472;
	bh=uWTVzsZR5H1pZoGNqNd2f466n6uymxcu3RqqCm+IyD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uGTk1qnnq6Thh9bIuRTfupEhVJOKTj2N0Sn7zpGjqhX0qwLGqinLsK4lG7Ip+7DU2
	 rQaQ+go5BY/y/cf8uLZShm2fN+zKP7rhQEMd/56bHlFU+LMWhbTJpQutToC1ScKICc
	 uIOiSrYyP0VzPTejKTmznydCM4eZEW+IJIYTQ3jw+VaGSNa+gkjsWYkdB1/43UG09x
	 YX2GnrwQ23DiHBzPVFbPKuRTjTCE/dcbga8cPRewctM31SfBxl71lYXpYQ/fHBBSHb
	 o79SfpKp1z6OxDCAm9XE7DTCgq32Em7IW1dkF3McKupyF/5VryyMX9qe/RpIyaKslj
	 DQTAyEcHGNG8A==
Date: Wed, 16 Apr 2025 11:41:07 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] scsi: Improve CDL control
Message-ID: <Z_97M6AAJa1Ag8CA@ryzen>
References: <20250416084238.258169-1-dlemoal@kernel.org>
 <20250416084238.258169-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416084238.258169-4-dlemoal@kernel.org>

On Wed, Apr 16, 2025 at 05:42:38PM +0900, Damien Le Moal wrote:
> With ATA devices supporting the CDL feature, using CDL requires that the
> feature be enabled with a SET FEATURES command. This command is issued
> as the translated command for the MODE SELECT command issued by
> scsi_cdl_enable() when the user enables CDL through the device
> cdl_enable sysfs attribute.
> 
> However, the implementation of scsi_cdl_enable() always issues a MODE
> SELECT command for ATA devices when the enable argument is true, even if
> CDL is already enabled on the device. While this does not cause any
> issue with using CDL descriptors with read/write commands (the CDL
> feature will be enabled on the drive), issuing the MODE SELECT command
> even when the device CDL feature is already enabled will cause a reset
> of the ATA device CDL statistics log page (as defined in ACS, any CDL
> enable action must reset the device statistics).
> 
> Avoid this needless actions (and the implied statistics log page reset)
> by modifying scsi_cdl_enable() to issue the MODE SELECT command to
> enable CDL if and only if CDL is not reported as already enabled on the
> device.
> 
> And while at it, simplify the initialization of the is_ata boolean
> variable and move the declaration of the scsi mode data and sense header
> variables to within the scope of ATA device handling.
> 
> Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---

Reviewed-by: Niklas Cassel <cassel@kernel.org>
