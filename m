From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [patch] qla1280 update for 2.6.1-mm4
Date: 19 Jan 2004 16:18:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yq01xpvocwd.fsf@wildopensource.com>
References: <16395.51364.833229.536552@gargle.gargle.HOWL>
	<1074531798.1894.17.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:8898 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S263596AbUASVSo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 16:18:44 -0500
In-Reply-To: <1074531798.1894.17.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, jeremy@sgi.com

>>>>> "James" == James Bottomley <James.Bottomley@steeleye.com> writes:

James> Something to think about (I'm not asking you to change it) is
James> whether you really want to use 64 bit descriptors on all 64 bit
James> machines.  The way the qla1280 single issue queue is organised
James> it looks like we eat up slots (and, worse, overflow slots)
James> quite a bit faster in 64 bit addressing mode.  Therefore, it
James> seems like the driver would operate more efficiently in 32 bit
James> mode, so it might be worth a runtime check even on 64 bit
James> machines to see whether the addressing mode is really necessary
James> (i.e. no physical memory > 4GB for instance).

Hi James,

Certainly a valid concern, however it would probably more likely be
based on available IOMMU slots, ie. with loads of 1280's in a box or
other devices causing a lot of packets going through the system, it
will probably be preferred to use 64 bit addressing where on smaller
boxes I think you suggestion will be a pretty decent win. The driver
also needs to handle it's busy situation a lot better, the current
busy wait loop in qla1280_req_pkt is ehm ... no comment. Even if we
decide to do dynamic switching between 64 and 32 bit mappings then I
think it will be desirable to merge the two queuecommand versions for
cache locality.

Cheers,
Jes
