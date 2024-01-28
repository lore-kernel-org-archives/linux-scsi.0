Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AD51362;
	Sun, 28 Jan 2024 01:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706406609; cv=none; b=h3EzvtcBl585bkkmKJP00NVGw9FgoHy1yXkLoM1jkEU2beDMXUACHzKQRubzEMbwYP7Xd6JfjwHKqbV5Ut/KA5a3N60gkGvxMv7xy9sBVzYFtI6S5ZcrJ+VEWxrwwOnk5ZczsOjxwFbNjTx6k2JUVhp7Dbwx9n04Qs1qXmny4kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706406609; c=relaxed/simple;
	bh=SYut84D1SsmE34WN82G+H0xoo0YRKUwAO6HyDU0GEGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nw9LTlXSUxYXvjRdpbyqAFgOzettCf4AdeCCOX49aqe+G66NHTtFX74Qb3HOOvpcuK+Qpb3gvAC+seU7cBEsCm+tahq6kyBjU4xNPqykYQbgnFt9fZmxJlo2OiMfXVphkpoiHXnb2JCCky12JcOTVqYnpnDhB/FcB/4Z3bG/2Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N//n48oY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N//n48oY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B04C433F1;
	Sun, 28 Jan 2024 01:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706406608;
	bh=SYut84D1SsmE34WN82G+H0xoo0YRKUwAO6HyDU0GEGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N//n48oYvmeLyTEhOrGKToaMnL5VSe20rcdr/t5NveopbPzwBq220bdf9TwbaFS7e
	 B9DOLH+jMJ8P/sxJ6PDxglj9WrLLu85rgS6xEYoXkHBzZ6mO2STCt+50/bL07CNA7n
	 ng6SDF6ov0FpjdUAM4xa5EWjhD+CJTvcNcBRDMiw=
Date: Sat, 27 Jan 2024 17:50:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Milan Broz <gmazyland@gmail.com>
Cc: linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	linux-scsi@vger.kernel.org, stern@rowland.harvard.edu,
	oneukum@suse.com
Subject: Re: [PATCH v6] usb-storage,uas: use host helper to generate driver
 info
Message-ID: <2024012744-ungreased-retention-4e84@gregkh>
References: <20231103201709.124372-1-gmazyland@gmail.com>
 <20231105182047.166007-1-gmazyland@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231105182047.166007-1-gmazyland@gmail.com>

On Sun, Nov 05, 2023 at 07:20:47PM +0100, Milan Broz wrote:
> The USB mass storage quirks flags can be stored in driver_info in
> a 32-bit integer (unsigned long on 32-bit platforms).
> As this attribute cannot be enlarged, we need to use some form
> of translation of 64-bit quirk bits.
> 
> This problem was discussed on the USB list
> https://lore.kernel.org/linux-usb/f9e8acb5-32d5-4a30-859f-d4336a86b31a@gmail.com/
> 
> The initial solution to use a static array extensively increased the size
> of the kernel module, so I decided to try the second suggested solution:
> generate a table by host-compiled program and use bit 31 to indicate
> that the value is an index, not the actual value.
> 
> This patch adds a host-compiled program that processes unusual_devs.h
> (and unusual_uas.h) and generates files usb-ids.c and usb-ids-uas.c
> (for pre-processed USB device table with 32-bit device info).
> These files also contain a generated translation table for driver_info
> to 64-bit values.
> 
> The translation function is used only in usb-storage and uas modules; all
> other USB storage modules store flags directly, using only 32-bit flags.
> 
> For 64-bit platforms, where unsigned long is 64-bit, we do not need to
> convert quirk flags to 32-bit index; the translation function there uses
> flags directly.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>

I see the need for this, but why now?  We haven't run out of ids yet
have we?  Do we need to add another one?

Also, after building, I get the following files marked by git as needed
to be added to the tree, so perhaps you also need a .gitignore file:

$ git status
On branch work-testing
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	drivers/usb/storage/mkflags
	drivers/usb/storage/usb-ids-uas.c
	drivers/usb/storage/usb-ids.c

thanks,

greg k-h
