From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Sat, 30 Oct 2004 10:22:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1099124563.27274.50.camel@zezette>
References: <1098833278.4914.24.camel@zezette>
	 <20041027081713.GC32712@marowsky-bree.de>
	 <1098903759.12464.32.camel@zezette> <1098914250.1588.1.camel@mulgrave>
	 <20041028113728.GT32712@marowsky-bree.de>
	 <20041028181436.GA18874@beaverton.ibm.com>
	 <20041028182154.GY32712@marowsky-bree.de>
	 <20041030004131.GA29908@beaverton.ibm.com>
	 <1099120870.27274.37.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.wanadoo.fr ([193.252.22.27]:9502 "EHLO
	mwinf0401.wanadoo.fr") by vger.kernel.org with ESMTP
	id S263636AbUJ3IWq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Oct 2004 04:22:46 -0400
In-Reply-To: <1099120870.27274.37.camel@zezette>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Lars Marowsky-Bree <lmb@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> > Plus, we only call sd_spinup_disk() during discovery and not on open,
> > unlike the calls to sd_media_changed().
> > 
> Would it be workable to add a scsi_devinfo flag for devices with ghosts.
> If this flag is set and state is down, open calls sd_media_changed().
> The multipath-tools and device-mapper will try as hard as possible to
> avoid opening those device if not necessary, by grouping them in a low
> priority path group.
> 
In fact the NOSTARTONADD flag seems just used for devices with ghosts
paths. So we could extend its logic : no start on add, but start on IO
is state is down.

SG_IO should not activate the path though, for the path checker not to
activate it.

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

