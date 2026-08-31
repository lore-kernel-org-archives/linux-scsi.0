Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9663A7F7A;
	Mon, 31 Aug 2026 09:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788169144; cv=none; b=RpNiqiIRg9pPx8AaTvYsyX9iAz/OdkWNuoHqh9EPBNeZLecOr7306bskyR6oRCDO6iBOW7TMWlvj+jtOgOnFuIOmH94HEaTGN2kyixV1JzcLEZYczEeHbwceNJYfsg5jtHcy3682eHcBJjdrLMwYiYM979gaK5nhd5noH+nWqNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788169144; c=relaxed/simple;
	bh=9KmyGHzwinfEUNeiMBVnkzgb0Ua3s5kQ58NqCf4GMw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fbIfmUv5jx1IrEGpt2O/Y1A00t59bezcDGM09ZN34vTTFTQnYV3B12ZsG44EpLYoyq5rnDyWGhCrD/JSgP5N/rvzY1PdPxhaXOG5KPjmb6SwVypmNpn6W09DK5Q/kPgea0bIlC4meBcJ8foZaRPEbOtWc7eMM6MByWX8vrhZMyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2wqwWTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2wqwWTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9422D1F000E9;
	Mon, 31 Aug 2026 09:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788169141;
	bh=sA/qRBKGNMnWzE85d6xd4DGM0msY81q+Vk53bTWeL50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U2wqwWTJv06oZFouqGzzLi2Zm/MYUhjsK/m09baRGy2R1zDTuRMFEE/SY+71JaqKx
	 TPhuOiyHvIsBoy/gZmQko32zDtCbAjaHsEtZ6mRw3tZnQjECMyuqY0+ifETyQ6hWlo
	 gtvd3r1l1uO61vJCU/vHDTlhDI6CSMRhIyjD86gc=
Date: Mon, 31 Aug 2026 11:38:56 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: ZW Tang <tangzw515@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] usb: gadget: f_tcm: possible circular locking dependency
 in usbg_make_tpg
Message-ID: <2026083139-enamel-result-951b@gregkh>
References: <CAA2SOT4Hok5xOtbviX4HkeqVK_u79NZjw3+0WKZMmUQb35jORw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA2SOT4Hok5xOtbviX4HkeqVK_u79NZjw3+0WKZMmUQb35jORw@mail.gmail.com>

On Mon, Aug 31, 2026 at 05:26:19PM +0800, ZW Tang wrote:
> Hi,
> 
> I am reporting a possible circular locking dependency triggered by a
> syzkaller reproducer on Linux 7.2.0-rc3. Similar issues appear to have
> been reported upstream before, but I can still reproduce this warning on
> Linux 7.2.0-rc3 with HEAD commit
> 1137d8b5df06137fb49513cc923b3b24d94cb809.
> 
> The reproducer mounts configfs, creates a USB gadget TCM function, creates
> a target usb_gadget fabric TPG, and then links the TCM function into a USB
> gadget configuration.
> 
> Lockdep reports a cycle involving the configfs inode mutex,
> tpg_instances_lock, and the f_tcm opts->dep_lock. The current path is
> creating a TPG through configfs_mkdir(). It reaches usbg_make_tpg(), holds
> tpg_instances_lock and opts->dep_lock, and then calls
> configfs_depend_item_unlocked(), which tries to acquire a configfs inode
> mutex.
> 
> The existing reverse dependency is created by the USB gadget symlink path:
> configfs_symlink() calls config_usb_cfg_link(), which calls
> usb_get_function() and then tcm_alloc(), where tpg_instances_lock is
> acquired.
> 
> This creates the following lock order cycle:
> 
> configfs inode mutex -> tpg_instances_lock -> opts->dep_lock
> opts->dep_lock -> configfs inode mutex
> 
> This looks like a lock-ordering issue in the USB gadget TCM function /
> target configfs integration. The kernel should avoid taking these locks in
> opposite orders, because this can lead to an actual deadlock.

Great, care to send a patch to fix this as you have a reproducer for the
issue?

thanks,

greg k-h
