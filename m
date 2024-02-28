Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 575F715D5A4
	for <linux-scsi@vger.kernel.org>; Wed, 28 Feb 2024 16:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.131.102.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709136105; cv=none; b=ayIfDVbgtWUtcfHJHsRK2PXJrv9nuIHDB9sKOB45bK8zYEX0vb5z2NMF8Hk0ozJCq8kVPFJpWQxyeMnHMP35ymMCTvR8JrBFEh/qcdTGjp0ySCOLZFpotOEZhzJSkF50UHaKPVHptRgMlu2xMc1yNlBHTAONxlg/3gDFucpQfxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709136105; c=relaxed/simple;
	bh=3m7AJ3rDjtJcvbL3dVAsxKVcznvJ7mSp1oVf93rdMO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ie2x+XhIKBBY+PLRmo/jYwR5M235frD5mUvmYQr+qtySiJ4lLMiNyoLKxgduPJdGKAbMooqtBbP/fwRGvappdmLjqOu7ls1oHykm9pf/emUiIVXMpUHo8Xa/F5VgKj2nJPUkOf4uIx7DPtm82SLm482oQxd0w08GDzapV4UayT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu; spf=pass smtp.mailfrom=netrider.rowland.org; arc=none smtp.client-ip=192.131.102.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netrider.rowland.org
Received: (qmail 797254 invoked by uid 1000); 28 Feb 2024 11:01:42 -0500
Date: Wed, 28 Feb 2024 11:01:42 -0500
From: Alan Stern <stern@rowland.harvard.edu>
To: Keith Busch <kbusch@kernel.org>
Cc: Harald Dunkel <harald.dunkel@aixigo.com>, Jens Axboe <axboe@kernel.dk>,
  Bart Van Assche <bvanassche@acm.org>,
  "Martin K. Petersen" <martin.petersen@oracle.com>,
  linux-block@vger.kernel.org, linux-usb@vger.kernel.org,
  linux-scsi@vger.kernel.org
Subject: Re: RIP on discard, JMicron USB adaptor
Message-ID: <76fcb1b1-cdf2-45d0-aeab-c712ee517b34@rowland.harvard.edu>
References: <70bc51d7-c8a2-4b06-ab7a-e321d20db49a@aixigo.com>
 <62296d89-f7e6-4f54-add8-35b531dc657c@rowland.harvard.edu>
 <Zd9Xbz3L6JEvBHHT@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd9Xbz3L6JEvBHHT@kbusch-mbp>

On Wed, Feb 28, 2024 at 08:55:27AM -0700, Keith Busch wrote:
> On Wed, Feb 28, 2024 at 10:46:39AM -0500, Alan Stern wrote:
> > On Wed, Feb 28, 2024 at 01:22:12PM +0100, Harald Dunkel wrote:
> > > [1400821.811585] ------------[ cut here ]------------
> > > [1400821.811594] WARNING: CPU: 0 PID: 614303 at block/blk-lib.c:50 __blkdev_issue_discard+0x14b/0x180
> > > [1400821.811868] CPU: 0 PID: 614303 Comm: blkdiscard Tainted: P           OE      6.1.0-18-amd64 #1  Debian 6.1.76-1
> > > [1400821.811875] Hardware name: Gigabyte Technology Co., Ltd. Z790 GAMING X/Z790 GAMING X, BIOS F9b 11/10/2023
> > > [1400821.811878] RIP: 0010:__blkdev_issue_discard+0x14b/0x180

> > > I tried a discard on a Samsung PM981 1TB SSD (m.2) using a JMicron USB adaptor.
> > > 
> > > udev rule:
> > > 
> > > ACTION=="add|change", ATTRS{idVendor}=="152d", ATTRS{idProduct}=="0583", SUBSYSTEM=="scsi_disk", ATTR{provisioning_mode}="unmap"
> > > 
> > > Probably I was too optimistic.
> > 
> > Notice that the USB layer does not show up at all in the stack dump 
> > above, but the block layer figures prominently.  This strongly suggests 
> > that the bug lies in the block layer.
> > 
> > CC'ing the appropriate mailing list and maintainer.
> 
> In the code comments above the WARN, this condition indicates "the
> discard granularity isn't set by buggy device driver". The block layer
> needs this set if your driver also sets the max_discard_sectors limit.

The usb-storage and uas drivers do not set any of these; however, the 
SCSI sd driver does.  Maybe that's where the problem lies.  Adding more 
CC's.

Alan Stern
