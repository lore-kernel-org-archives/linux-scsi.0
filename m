From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Fw: [Bugme-new] [Bug 6114] New: Initio sbp2 causes: "slab error in cache_free_debugcheck(): cache `size-512(DMA)': double free, or memory outside" object was overwritten
Date: Wed, 22 Feb 2006 01:29:42 +0000
Message-ID: <20060222012942.GY27946@ftp.linux.org.uk>
References: <20060221040511.35b69d26.akpm@osdl.org> <43FB6545.8080103@s5r6.in-berlin.de> <43FB67BD.7030101@s5r6.in-berlin.de> <20060221134543.5f844d7c.akpm@osdl.org> <43FB9FE5.8070309@s5r6.in-berlin.de> <Pine.LNX.4.64.0602220041070.21474@jbgna.fhfr.qr> <43FBB1A2.9030009@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:12713 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1161143AbWBVB3v
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2006 20:29:51 -0500
Content-Disposition: inline
In-Reply-To: <43FBB1A2.9030009@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Bernhard Kaindl <bk@suse.de>, Andrew Morton <akpm@osdl.org>, bcollins@debian.org, scjody@modernduck.com, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

On Wed, Feb 22, 2006 at 01:34:42AM +0100, Stefan Richter wrote:
> Al's patch is certainly better since it adds checks to the actual 
> affected code region, i.e. mode_sense handling in the SCSI layers. 
> James, would you integrate this patch?
> 
> However sbp2 will keep some sort of skip_ms_page_8 blacklisting anyway 
> because of different issues with other bridges.

Sure, but for this bridge it's not needed - with that fix we get the
right data out of bridge response.  Note
+sda: missing header in MODE_SENSE response
and
+SCSI device sda: drive cache: write back
in that diff.  The former is exactly what we get when we detect that
sort of breakage (bare page 6 without header) and the latter is where
we manage to get the cache type.
