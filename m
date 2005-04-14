From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: Question about scsi_device_online() usage in mptscsih
Date: Thu, 14 Apr 2005 14:28:11 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C01F7C9F9@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33681 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261445AbVDNU3O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2005 16:29:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fukuchi.masao@jp.fujitsu.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>

Masao Fukuchi reported an issue when the
outstanding mf queue was being flushed in
contents of slave_destroy, the scsi dev was 
offlined already by the mid-layer.

They may not be an issue anymore since I removed
the error handling timers from mptscsih.

Masao can you validate this pls?

Christoph Hellwig, wrote:
> 
> On Sat, Apr 02, 2005 at 02:35:57PM +0900, Tejun Heo wrote:
> >  Hello, Eric.
> >  Hello, James.
> > 
> >  I've been working on new SCSI state model and was checking on
> > scsi_device_online() users.  As the state model is going to 
> change, I
> > need to audit device state usages in lldd's and I'm having difficult
> > time understanding why scsi_device_online() is used in mptscsih.
> > 
> >  In mptscsih.c, mptscsih_flush_running_cmds() uses
> > scsi_device_online() to determine whether or not dma-unmap data area
> > of active commands.  This was added in the changeset 1.1371.776.1 by
> > Eric Moore with the comment "MPT Fusion add back FC909 
> support".  Can
> > you please explain me why and how scsi_device_online() condition is
> > used here?
> 
> I brought that issue up a while ago, but we didn't really get 
> anywhere,
> see the "fix dma mapping leak in fusion" thread on linux-scsi.
> 
