Received: from out30-73.freemail.mail.aliyun.com (out30-73.freemail.mail.aliyun.com [115.124.30.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55899285061;
	Mon,  2 Feb 2026 07:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770017792; cv=none; b=FE35T8eQOXKvAb0aqHY70PBDeYS6611zrzCIqGxARXi7fTiTwqpD9TN9b7XWtSTFstqss1Zvfr3E6sZCdjwGNwa90+vai/U6S+MKWN82CdaYSfvu4vgYC1e0qlcy2tEHHok+x8G3SbCOEGr2ZCWHlYjmHKmnuAag8ZMppH+6dmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770017792; c=relaxed/simple;
	bh=evq5mFKsQfQYAhfNwz7jyrMpvrjdX5Ih9w6OlcIRmmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXYPM8YbBjTBEs7cwUIU1JsPJorzjBCxK2pO3EUIMoXBfiSbK6px/p86KEzh4M927aWR+GaCgoqFZOSwgxrnz0Z5xFYw3olZh4lH48bgiWOmHZdfAyE9ADlaKU5464JfGTubtvcNReArWHV274PtA8cZXMPYhMV7wX4I+4ubDCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=mqx/sMUG; arc=none smtp.client-ip=115.124.30.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="mqx/sMUG"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1770017787; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=VXJ75vYByY0Ypooc5hHeKXJ2jK9pnmWHFHf1J62wfrc=;
	b=mqx/sMUGMCG/+vcNMr01VIcDmjgApdd7NhZuLcRDhXy2kvBs/8G+MFPIJBrn+8YvemKnzFtGJu63GYqaN8LqUVtN6smScfdy+mYZl3VJ9kKpNKLa7yMAznqRHNWXK1fF5WovDElTmA7dWltnxESzL9WbsE4Av2wmMH+Z/kXM9zU=
Received: from VM-209-93-tencentos(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0WyKqZAJ_1770017781 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Feb 2026 15:36:26 +0800
Date: Mon, 2 Feb 2026 15:36:20 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: john.g.garry@oracle.com, yanaijie@huawei.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	johannes.thumshirn@wdc.com, mingo@kernel.org, cassel@kernel.org,
	tglx@kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libsas: Fix dev_list race conditions with proper
 locking
Message-ID: <aYBT9ASycq4hA5U7@VM-209-93-tencentos>
References: <20260129093859.1418749-1-wdhh6@aliyun.com>
 <aa5ca682-ea38-49f6-81a1-6b154f00239d@kernel.org>
 <aX3lV4erBYL068PT@LAPTOP-RK2E6KJ3.localdomain>
 <b4f3b1d7-45f7-49c4-ad16-e085d71e2d9b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4f3b1d7-45f7-49c4-ad16-e085d71e2d9b@kernel.org>

On Mon, Feb 02, 2026 at 10:21:43AM +0900, Damien Le Moal wrote:
> On 1/31/26 20:19, Chaohai Chen wrote:
> >>> +	 * We need to unlock before calling sas_unregister_dev() as it
> >>> +	 * may sleep, but we hold a reference to prevent device removal.
> >>
> >> And why is that necessary ?
> >>
> > Because when unlocked, it is possible that the device has already been 
> > released by another thread. If there is no reference count, it will lead
> > to used after free.
> 
> Please clearly explain the problem path. Your statements about "another thread"
> is too vague.
> 
1.
CPU 1: disco_q                          CPU 2: event_q
==============================          ==============================
sas_discover_domain()                   sas_phye_loss_of_signal()

sas_ex_level_discovery()                sas_deform_port(phy, true)

list_for_each_entry(dev,                sas_unregister_domain_devices()
  &port->dev_list, ...)

NOP                                     list_for_each_entry_safe_reverse(
                                        dev, n, &port->dev_list, ...)

NOP                                     sas_unregister_dev(port, dev)

NOP                                     kfree(dev)

if (dev_is_expander(dev->dev_type))(UAF)
...

2.
CPU 1: disco_q                          CPU 2: event_q
==============================          ==============================
sas_resume_devices()                    sas_porte_link_reset_err()

sas_resume_port()                       sas_deform_port(phy, true)

list_for_each_entry_safe(dev,           sas_unregister_domain_devices()
  &port->dev_list, ...)

NOP                                     free dev

visit dev->ex_dev(UAF)
