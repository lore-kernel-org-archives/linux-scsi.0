From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups
Date: Fri, 03 Dec 2004 23:35:08 +0100
Message-ID: <m3brdbc8o3.fsf@merlin.emma.line.org>
References: <1100467267.23710.7.camel@mulgrave> <4197E4B7.3050008@pobox.com>
	<1100473795.23649.26.camel@mulgrave>
	<m3hdnsvvfd.fsf@merlin.emma.line.org>
	<1100477105.24921.3.camel@mulgrave>
	<m34qjrx6iy.fsf_-_@merlin.emma.line.org>
	<Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de>
	<m3actaw0pv.fsf@merlin.emma.line.org>
	<20041122133014.GF25636@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:47069 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S262434AbULCWfN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Dec 2004 17:35:13 -0500
In-Reply-To: <20041122133014.GF25636@parcelfarce.linux.theplanet.co.uk>
	(Matthew Wilcox's message of "Mon, 22 Nov 2004 13:30:14 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>, Steffen Winterfeldt <snwint@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>

Matthew Wilcox <matthew@wil.cx> writes:

>> 2. is it a kernel bug if reading offset #216 (byte-wise) in the config
>>    file in sysfs confuses the hardware?
>
> No, but it does seem to me that we could do better.  Unfortunately,
> the obvious thing to do (set the file size to less than 256 bytes) isn't
> really possible in sysfs.  But we could use the 'undocumented feature'
> in drivers/pci/pci-sysfs.c:pci_read_config() of setting the pci_dev's
> cfg_size to 128 bytes.  This would prevent even root from reading more
> than 128 bytes.  That'd be OK -- there's no *PCI* data in this range,
> even on the latest 1010/1030 controllers.  The operating registers are
> exposed in the 0x80-0xFF range only up to the 875; the 876 and later
> return only 0 in that range.

Have you had a look at this already? If not, how would I go about
inplementing this?

-- 
Matthias Andree
