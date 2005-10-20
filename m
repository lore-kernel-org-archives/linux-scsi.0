From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 17:49:42 +0200
Message-ID: <20051020154942.GA12809@lst.de>
References: <91888D455306F94EBD4D168954A9457C048F08AE@nacos172.co.lsil.com> <4356B3D3.1010203@adaptec.com> <20051020141123.GA7119@lst.de> <4357B7C5.9000709@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:27554 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932215AbVJTPtu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 11:49:50 -0400
Content-Disposition: inline
In-Reply-To: <4357B7C5.9000709@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org

<lots of useless rants snipped>

Yes, we have two cases, local phy and phy on an expander.  The proper
way to support remote phys is via smp passthru as we hopefully agree.
Right now the sas transport class doesn't do smp passthru (although
I'm working on it) so we only implement local link stats.  Once we have
smp passthru we can support link stats, in one of two ways:

 - do it in userland as in your example program.  in that case we don't
   need to do anything in kernel land and need the local_attached flag
   to disable this functionality for expander phys.
 - do it in kernel, in which case the transport class must call the smp
   passthru entry point of the driver to query link stats, so it needs
   the local_attached flag aswell for that.

What's your problem with the flag now?
