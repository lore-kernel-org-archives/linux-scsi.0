From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 2/4] mpt3sas: Fix for Crusader to achieve product
 targets with SAS devices.
Date: Fri, 20 Jan 2017 16:00:26 +0100
Message-ID: <20170120150026.GA9315@linux-x5ow.site>
References: <1484923333-8509-1-git-send-email-chaitra.basappa@broadcom.com>
 <1484923333-8509-3-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60563 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752271AbdATPAf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Jan 2017 10:00:35 -0500
Content-Disposition: inline
In-Reply-To: <1484923333-8509-3-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com

On Fri, Jan 20, 2017 at 08:12:11PM +0530, Chaitra P B wrote:
> Small glitch/degraded performance in Crusader is improved with SAS
> drives by removing unnecessary spinlocks while clearing scsi command
> in drivers internal lookup table.
> 
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---

Whats wrong with creating a __scsih_scsi_lookup_get_clear() and calling
it with the scsi_lookup_lock held from _scsih_scsi_lookup_get_clear()
instead of duplicating the code?

It's quite common in the linux kernel to have two functions func and __func,
where func is 

func()
{
	spin_lock();
	__func();
	spin_unlock();
}

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
