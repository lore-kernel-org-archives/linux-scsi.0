Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941ED23ABA0;
	Fri, 25 Jul 2025 10:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753440579; cv=none; b=H4sfOrqkij52bb+7DkIdII7Miga2Y1dikj9yrtmYGX26GSK8xFfUbRnxjpdf8e3IqrKl3n+8/ETKO1Nkt3D2t9jkx4To/+lkMk+0CHVliS7sV1ErACy8PSX9NNDzjlmqkKdOA5lqhVfJ5KqySWyu3dFYZIHgcBDqQQ/t72EZQXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753440579; c=relaxed/simple;
	bh=DA8eSlmO2U73Ewa50lOC8l2tCn1PhSY2XndXeQUef4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QYkOmyIl2nE4FqgeRl/07RitI9BuvUPq2LLjCR1rBuFuFCnaISK8U4nmpjYEfK4KtUmQub4IhZ6moL2cA8r0w8g0eJZoyMA8io5xFjmVbNk+rkW7zvRdzQBl1uAXVkGoyAfTBx65XnhRLecrYvMMbHIo6wAFpnfWuWqr7nV8Pzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W4DIRetV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W4DIRetV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E617CC4CEE7;
	Fri, 25 Jul 2025 10:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753440579;
	bh=DA8eSlmO2U73Ewa50lOC8l2tCn1PhSY2XndXeQUef4w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W4DIRetVHLmUbYhHz+T2kgqZ98ahXPYovUZA64xRh+FSXuD9nWyBnxN3QPwlT9gtt
	 TbGFW+ltwFFneoJ4Zld0LvYJjCQ4Sg8azLZh5skrw/oJV3LDhZHTAeXdBThYwzHgVh
	 HyPFO9LRQ033KDbrO+bt8Iz0GThU+r+sVWloFi3H23ENrD7/EUex1pjcYQ/Oxq5sl1
	 3vVoyulnqAgA9UDXgEIFXCdg6v5DzFvRPoYbch1B/JRDAHjoOaUOb9ufMKLBKl6VUA
	 wSAN8/K8Sae6CoZ32MCUwuWW4SvyeV4hFEvgUzg+CqSlRDaQkeYF3UqjD0XVGuA++1
	 7LDqiSp5L+usw==
Message-ID: <287c1b05-e271-47af-b373-36e329cf512e@kernel.org>
Date: Fri, 25 Jul 2025 19:49:36 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: sd: fix sd shutdown to issue START STOP UNIT
 command appropriately
To: Salomon Dushimirimana <salomondush@google.com>
Cc: James.Bottomley@hansenpartnership.com, bvanassche@acm.org,
 ipylypiv@google.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com, vishakhavc@google.com
References: <20250724212137.105270-1-salomondush@google.com>
 <20250724214520.112927-1-salomondush@google.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250724214520.112927-1-salomondush@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/25/25 06:45, Salomon Dushimirimana wrote:
> Commit aa3998dbeb3a ("ata: libata-scsi: Disable scsi device
> manage_system_start_stop") enabled libata EH to manage device power mode
> trasitions for system suspend/resume and removed the flag from
> ata_scsi_dev_config. However, since the sd_shutdown() function still
> relies on the manage_system_start_stop flag, a spin-down command is not
> issued to the disk with command "echo 1 > /sys/block/sdb/device/delete"
> 
> sd_shutdown() can be called for both system/runtime start stop
> operations, so utilize the manage_run_time_start_stop flag set in the
> ata_scsi_dev_config and issue a spin-down command during disk removal
> when the system is running. This is in addition to when the system is
> powering off and manage_shutdown flag is set. The
> manage_system_start_stop flag will still be used for drivers that still
> set the flag.
> 
> Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system_start_stop")
> Signed-off-by: Salomon Dushimirimana <salomondush@google.com>

Tested-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
