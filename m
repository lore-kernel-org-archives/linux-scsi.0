Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CA0130A7F
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 23:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712273526; cv=none; b=abqZ3wVKwkx6HbBP4zaF+Ei/OXbZHS8TjKYpOrf/Oi5OL5ydNwv5Mf1ZEg2y+pIKgwOxhFg4xCaypxbLtHfy2syv1fTviLd0/QPP+B6VTTpAtvN9Rebra00yVDw/hfVYH5Dd+BDOoLqCO6/A835KbM7YCS3g0SCzcPEHSFYUM0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712273526; c=relaxed/simple;
	bh=zJs/CwnKi2yvuItPniUNdCpks3JixideMZ+SmDTO4Wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4oUJo+wA0wI7tj/qNTrpguU6FxoHdsMh/vp5HtKfLsWvOGmNX+oyTTDmMHMyTBFEssQ8/RQw4KSQTj3RBCyvoljU47nGfneOKuj5U3tulOJyygHqfK8cwvH3nuWZtEh3UGDUKFl3lKO/7A6bvFPLyP/9LzOxJrNOrCUB+HHplo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZTguJZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZTguJZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAB6C433C7;
	Thu,  4 Apr 2024 23:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712273525;
	bh=zJs/CwnKi2yvuItPniUNdCpks3JixideMZ+SmDTO4Wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MZTguJZ4NFMwKUCI3EzimpdNnRiyKz3+avjSKqoCKh+DIUNgoQG97rEG9IHr73wXz
	 1g554rTUNUhnTsxYQXiITXkdFUI/wMXKjTY+sT9CgHlNbqtzv63p1bfmCbe5PPG+4s
	 RssSjY+C4CfyF7yj9OHGWZio/wvPMynDp9EkaIq/7u7MQg+KBb8Ms6aM1WUdBmq79y
	 SLWGHOTlFGt4OVoSM1Vt7/+/X2jAXsk5ZaiiQGLh1g64FIlIqQ7DgkI08TsueaF5zO
	 /WjDmycDNCUbf4BK5jJ4KzPZT7JcmH5T634IksFgbqL96ZetZcYBtKV1cgXP47OXDs
	 i+JmD0m1J9ymg==
Date: Thu, 4 Apr 2024 17:32:02 -0600
From: Keith Busch <kbusch@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com,
	martin.petersen@oracle.com,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] scsi: sg: fix refcount warning
Message-ID: <Zg84ci15skTWzNy5@kbusch-mbp.dhcp.thefacebook.com>
References: <20240404231840.2015678-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240404231840.2015678-1-kbusch@meta.com>

On Thu, Apr 04, 2024 at 04:18:40PM -0700, Keith Busch wrote:
> This fixes the warning:
> 
>  ------------[ cut here ]------------
>  WARNING: CPU: 8 PID: 394 at drivers/scsi/sg.c:2236 sg_remove_sfp_usercontext+0x1ad/0x1d0 [sg]

I see the tree we're testing is a little behind the latest scsi, and a
proper fix was already committed:

  https://lore.kernel.org/linux-scsi/81266270-42F4-48F9-9139-8F0C3F0A6553@linux.ibm.com/T/#t
