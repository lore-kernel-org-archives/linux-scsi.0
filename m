From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] - MPT FUSION - SPLITTING SCSI HOST DRIVERS
Date: Sat, 26 Mar 2005 11:21:08 +0000
Message-ID: <20050326112108.GA25751@infradead.org>
References: <91888D455306F94EBD4D168954A9457C01B7055E@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:22950 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262033AbVCZLVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Mar 2005 06:21:17 -0500
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C01B7055E@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I took a quick look an a here's a few comments:

 - I don't think renaming mptscsih.c to mpt_core.c makes sense.
   the new name is confusing at best, and keeping the old name allows
   to keep SCCS history aswell.  That means the new SPI stub driver should
   be called mptspi or something like that.
 - please don't link mpt_core.o into both mptfch.ko and mptscsih.ko but
   make it a module of it's own
 - the new driver shoild use module_param, not MODULE_PARM
 - why does the fc driver set ioc->spi_data.mpt_pq_filter?
 - no need to forward-declare the module_init/module_exit handlers
