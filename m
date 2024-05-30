Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 0D6645645E
	for <linux-scsi@vger.kernel.org>; Thu, 30 May 2024 19:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.131.102.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717095791; cv=none; b=Vpz9RWXn3UnQsinj2bEKH818JbYQZEoAWdY4JkMbY++zruaL2B4zWhn5+xaIkpwe31+wCw+0LvmBkWI4YRAzCEeOYZ02q4qtB/WaC1tnuZbfTaPcksLdSUvFwTaXwlrRT7UVMMAaCU35xl54EAXR9OJupUc4h/cOcy5TUMxPegc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717095791; c=relaxed/simple;
	bh=0lKhfZlDBAa7HoACl2A4qma59lizY6S5/5RG+YrWO44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdkIlION/G34jeo8Ns/xkQCOF0cAcYKiR7MS9mMYrz0edND8xGXI9LTjmkTGZmQKBs1yHHMXdbv+5w2vcRzfryIOqQUdG88o4b8jdrA+jhs28zdfIjvxRVLLY7kyTAPsNJJefEPXLCmZ7pnCBr6Ho47DCj91Otw75Fo5OytYJcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu; spf=pass smtp.mailfrom=netrider.rowland.org; arc=none smtp.client-ip=192.131.102.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netrider.rowland.org
Received: (qmail 14304 invoked by uid 1000); 30 May 2024 15:03:01 -0400
Date: Thu, 30 May 2024 15:03:01 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Pierre Tomon <pierretom+12@ik.me>,
  USB mailing list <linux-usb@vger.kernel.org>,
  SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [Bug 218890] reset SuperSpeed USB device number 2 using xhci_hcd
Message-ID: <70dd7ae0-b6b1-48e1-bb59-53b7c7f18274@rowland.harvard.edu>
References: <bug-218890-208809@https.bugzilla.kernel.org/>
 <bug-218890-208809-ISXsODEmWC@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-218890-208809-ISXsODEmWC@https.bugzilla.kernel.org/>

On Thu, May 30, 2024 at 05:08:36PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218890

Martin:

This bug report was bisected down to your commit 321da3dc1f3c ("scsi: 
sd: usb_storage: uas: Access media prior to querying device 
properties").  Apparently the drive in question doesn't like READ(10) 
commands but it does work with READ(16).

Can you provide a test patch that updates the new sd_read_block_zero() 
routine to issue READ(16) if the drive has more than 4G logical blocks?

Alan Stern
