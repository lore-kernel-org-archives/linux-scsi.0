From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi: Fix incorrect reporting of host protection
	capabilities
Date: Thu, 15 Oct 2009 13:18:18 -0600
Message-ID: <20091015191818.GN7545@parisc-linux.org>
References: <yq18wfc8phm.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51313 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935249AbZJOTSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2009 15:18:55 -0400
Content-Disposition: inline
In-Reply-To: <yq18wfc8phm.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 15, 2009 at 02:46:13PM -0400, Martin K. Petersen wrote:
> 
> The advent of DIF Type 2 devices exposed these missing break statements.

Is there not a similar problem in scsi_host_dix_capable()?

And are these performance path?  If not, it might be nice to move them
out of line and code them like this:

unsigned scsi_host_dif_capable(struct Scsi_Host *shost, unsigned target_type)
{
	static unsigned cap[4] = {
		0, SHOST_DIF_TYPE1_PROTECTION,
		SHOST_DIF_TYPE2_PROTECTION, SHOST_DIF_TYPE3_PROTECTION
	};
	unsigned type = cap[target_type];
	return (shost->prot_capabilities & type) ? 1 : 0;
}

unsigned scsi_host_dix_capable(struct Scsi_Host *shost, unsigned target_type)
{
	static unsigned cap[4] = {
		SHOST_DIX_TYPE0_PROTECTION, SHOST_DIX_TYPE1_PROTECTION,
		SHOST_DIF_TYPE2_PROTECTION, SHOST_DIF_TYPE3_PROTECTION
	};
	unsigned type = cap[target_type];
	return (shost->prot_capabilities & type) ? 1 : 0;
}

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
