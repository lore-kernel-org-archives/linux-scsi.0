Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2085465D;
	Fri, 16 Feb 2024 14:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708095442; cv=none; b=LH6JB/Dh1O+BFtL9UzeP37GEyy+PjTHSsigkHsBO6Kd9yd2GJsqWsAnhVbeygJ8EptrIO2BRwlsI1sOaUXxdpVieuDGKZEI/PiMJpQeSpc7XFOlcnPEp2y1IONVYw1KvqzSd7qt+LmBv7EngbQv3tv1D3mGXH3WQr0z+kFMXguM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708095442; c=relaxed/simple;
	bh=wAY3ufdEMmUjsCvCBHBuq0Zl1K89KI9vKD7ZUjkReI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lNxfgsmcmQX6gRHB6DVRovdwliKcqgZvzb5DlUJ4Znmus8yLdeukDWgw2f0cpOILW5eM51Xo3UwKvejpqlYWMWMjoXt02Z3mEmvDgs6E/v+UGmKUC/VOqoOXPtNXSggMCXvMSnWX3nRrSX5HUBeCRqRlWg1LmytjAKR7m88YBds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 036EA72C8F5;
	Fri, 16 Feb 2024 17:57:18 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
	by imap.altlinux.org (Postfix) with ESMTPSA id EC2A236D016B;
	Fri, 16 Feb 2024 17:57:17 +0300 (MSK)
Date: Fri, 16 Feb 2024 17:57:17 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
	belegdol@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: core: Consult supported VPD page list prior to
 fetching page
Message-ID: <20240216145717.bywcwpx5m7ymyzyp@altlinux.org>
References: <20240214221411.2888112-1-martin.petersen@oracle.com>
 <883d670c-3ae1-4f44-bcb1-45e1428c9c3b@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <883d670c-3ae1-4f44-bcb1-45e1428c9c3b@acm.org>

Bart,

On Thu, Feb 15, 2024 at 10:28:06AM -0800, Bart Van Assche wrote:
> On 2/14/24 14:14, Martin K. Petersen wrote:
> > Commit c92a6b5d6335 ("scsi: core: Query VPD size before getting full
> > page") removed the logic which checks whether a VPD page is present on
> > the supported pages list before asking for the page itself. That was
> > done because SPC helpfully states "The Supported VPD Pages VPD page
> > list may or may not include all the VPD pages that are able to be
> > returned by the device server". Testing had revealed a few devices
> > that supported some of the 0xBn pages but didn't actually list them in
> > page 0.
> > 
> > Julian Sikorski bisected a problem with his drive resetting during
> > discovery to the commit above. As it turns out, this particular drive
> > firmware will crash if we attempt to fetch page 0xB9.
> > 
> > Various approaches were attempted to work around this. In the end,
> > reinstating the logic that consults VPD page 0 before fetching any
> > other page was the path of least resistance. A firmware update for the
> > devices which originally compelled us to remove the check has since
> > been released.
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Bart Van Assche <bvanassche@acm.org>
> > Fixes: c92a6b5d6335 ("scsi: core: Query VPD size before getting full page")
> > Reported-by: Julian Sikorski <belegdol@gmail.com>
> > Tested-by: Julian Sikorski <belegdol@gmail.com>
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 
> BTW, here is another report related to this patch:
> https://lore.kernel.org/linux-scsi/64phxapjp742qob7gr74o2tnnkaic6wmxgfa3uxn33ukrwumbi@cfd6kmix3bbm/
> 
> Vitaly, can you help with testing this patch? See also:
> https://lore.kernel.org/linux-scsi/20240214221411.2888112-1-martin.petersen@oracle.com/

With this patch applied over 6.6.16 problem still persists.

Also reading page 0x89 (mentioned in patch description) does not show any signs
of crash (any errors in dmesg with it of with the following reads):

  [root@host-226 ~]# sg_vpd -p 0x89 /dev/sdc
  ATA information VPD page:
    SAT Vendor identification: LSI     
    SAT Product identification: LSI SATL        
    SAT Product revision level: 0008
    Device signature indicates SATA transport
    Command code: 0xec
    ATA command IDENTIFY DEVICE response summary:
      model: WDC WD2005FBYZ-01YCBB2                  
      serial number:      WD-WMC6N0J5VKLH
      firmware revision: RR07    

Thanks,

