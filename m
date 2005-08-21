From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] minimal SAS transport class
Date: Sun, 21 Aug 2005 18:52:50 +0200
Message-ID: <20050821165250.GA18942@lst.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:42445 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751160AbVHUVlt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Aug 2005 17:41:49 -0400
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id j7LGrJKh000953
	for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2005 09:53:21 -0700
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: luben_tuikov@adaptec.com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Sat, Aug 20, 2005 at 12:15:41AM -0400, James.Smart@Emulex.Com wrote:
> Now - back to Christoph's point....
> 
> For iSCSI, (correct me if I'm wrong) as the scsi_host is mapped 1:1
> with the session, there really is no such thing as multiple targets,
> so it works. Even if it isn't 1:1, it is controlled via user space
> so it's likely managable. Note: instead of target id shifting, there
> may now be scsi_host number shifting.

That's the case for the open-iscsi (and the older cisco) software
initiator.  For the two iSCSI HBA drivers I've seen it's very different.

> For SAS, looking at Christoph's code - 
> The target id comes from the LLDD.

This is just a brindup helper because the Fusion hardware does a SAS
remote port to target ID mapping in firmware, in fact the firmware
interface only addresses them using this assigned ID, which is a big
shortcoming in the Fusion interface.  Once the more basic things are
dealt with that will go away, similarly to how Fusion won't be able
to use their firmware mapping for FC once they fully support the FC
transport class.

