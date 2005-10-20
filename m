From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 18:01:56 +0200
Message-ID: <20051020160155.GA14296@lst.de>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:39586 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932366AbVJTQCG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 12:02:06 -0400
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Oct 20, 2005 at 09:25:54AM -0600, Moore, Eric Dean wrote:
> So Christoph what should we do in driver?  Ignore returning
> data for expanders?  

As you mentioned doing link reset and reporting stats on expanders
is done using SMP, and thus totally independent of the driver used.
It should be either implemented in the transport class or in userland.
Doing it in the transport class has the advantage of a unified interface
for hba phys and expander phys, doing it in userland has the advantage
of less kernel bloat.

> Luben suggestion(correct me if I'm wrong) is this should be 
> done thru user space, instead of exporting this in the 
> /sys/class/sas_phy attributes.  Thus we need to export a 
> SMP_PASSTHRU mechanism.  I believe there is discussion
> by Christoph ( and I believe Luben backs this idea) of doing 
> all this thru the /dev/sg interface.

I've done a prototype using an SG_IO interface, but I'm not totally
happy about.  I've also seen lubens interface and I'm not totally
happy about it either.  Getting the interface right for SMP passthru
is very hard.

