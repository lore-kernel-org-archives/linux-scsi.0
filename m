Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AB73C6BA
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 23:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724109984; cv=none; b=m6K5CbbZ4ZDDa/LBzVc1tPZNylufYrkusuA3gjuhPG0RvzT7eFrIE0STsrJ8dQDchlo79kcPWW63yEom9c6/IvbhcUHktYbCne2QKi+slBaZA6tTQxIx5bjeviT9tiO9ceY2NJXsIB7lvGXvoO+oMj9zc7Eaf64kE+oh7XFUJdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724109984; c=relaxed/simple;
	bh=fT2ovB9QakeaA9iBK9PHMhLbC83NTCjrtuuZfpXa2Lw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pjSOslStp6rv+B2NJXC1zs142xKqeGDssHmR5ofEiaszc2xZwl+14FAKJBSUOJAAkbigb5m+B0iYl5jD3c5nGRNHruqzL6eiK/jerkquyMhvXGxwsoDKHoh3ir9VKD98gfPM7oP40L7RhN6twnPIcMO7gWqfw+gNqhpnAalEll8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=etpUL6Q9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="etpUL6Q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A5BC32782;
	Mon, 19 Aug 2024 23:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724109983;
	bh=fT2ovB9QakeaA9iBK9PHMhLbC83NTCjrtuuZfpXa2Lw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=etpUL6Q9m4sGp7bGwsnh+WzQLGpeupj178VIdMcB5aCMUl6Dz2UOzJV0/683bzNP+
	 L/kq9GwQbRTmAY/Vz8wHryThEete37f/mkUZNOYsxdje9azP+CP+t6vEfZbqXXWrSa
	 a4eYysBfHeFXmMQHjl6ZYVpfDJtojridL+eiTi81U+/HVOhtPmHU9IQexFNMxdkKlG
	 m7aQvx1kGMx3bAj1yPqXyzm3elhkhp+P8Xj4T/mgwncxQ7hlTsPwAKA5nkL3pcZvAG
	 xviAq346ymD2OYuv1gRTj6esWutAjcGOFyO+k4LkX7OMZ03bN9O0leXQiUJxilteT1
	 MuQie7rW//xJg==
Message-ID: <3b450b95-d187-49cf-b60f-f48aebae192d@kernel.org>
Date: Tue, 20 Aug 2024 08:26:22 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] sd: Retry START STOP UNIT commands
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michael.christie@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240809193115.1222737-1-bvanassche@acm.org>
 <20240809193115.1222737-3-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240809193115.1222737-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/10/24 04:31, Bart Van Assche wrote:
> During system resume, sd_start_stop_device() submits a START STOP UNIT
> command to the SCSI device that is being resumed. That command is not
> retried in case of a unit attention and hence may fail. An example:
> 
> [16575.983359] sd 0:0:0:3: [sdd] Starting disk
> [16575.983693] sd 0:0:0:3: [sdd] Start/Stop Unit failed: Result: hostbyte=0x00 driverbyte=DRIVER_OK
> [16575.983712] sd 0:0:0:3: [sdd] Sense Key : 0x6
> [16575.983730] sd 0:0:0:3: [sdd] ASC=0x29 ASCQ=0x0
> [16575.983738] sd 0:0:0:3: PM: dpm_run_callback(): scsi_bus_resume+0x0/0xa0 returns -5
> [16575.983783] sd 0:0:0:3: PM: failed to resume async: error -5
> 
> Make the SCSI core retry the START STOP UNIT command if a retryable
> error is encountered.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

