From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Sat, 30 Oct 2004 09:21:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1099120870.27274.37.camel@zezette>
References: <1098833278.4914.24.camel@zezette>
	 <20041027081713.GC32712@marowsky-bree.de>
	 <1098903759.12464.32.camel@zezette> <1098914250.1588.1.camel@mulgrave>
	 <20041028113728.GT32712@marowsky-bree.de>
	 <20041028181436.GA18874@beaverton.ibm.com>
	 <20041028182154.GY32712@marowsky-bree.de>
	 <20041030004131.GA29908@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.wanadoo.fr ([193.252.22.26]:52036 "EHLO
	mwinf0504.wanadoo.fr") by vger.kernel.org with ESMTP
	id S263633AbUJ3HVP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Oct 2004 03:21:15 -0400
In-Reply-To: <20041030004131.GA29908@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Lars Marowsky-Bree <lmb@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> > I'm just saying we should stop on the first failed command (TUR) and not
> > retry to read all 64 sectors regardless. I can live with one error per
> > passive path, but 64 really kills the logs.
> 
> That makes sense.
> 
> What is the result of the TUR? I did not see any information about it in other posts in this thread.
> 

the tur checker in multipath-tools report ghosts as failing.

> We should change state somehow if the TUR failed or was not ready, maybe
> call set_media_not_present(), or maybe change the sdev state to
> SDEV_OFFLINE - though that might cause extra logging.
> 
> We might not normally every hit this since the scan (INQUIRY failure)
> would likely prevent the device from showing up at all. 

scsi_id and INQUIRY succeed on ghost paths, which allow multipath to
group them with valid paths to the same LU.

> Plus, we only call sd_spinup_disk() during discovery and not on open,
> unlike the calls to sd_media_changed().
> 
Would it be workable to add a scsi_devinfo flag for devices with ghosts.
If this flag is set and state is down, open calls sd_media_changed().
The multipath-tools and device-mapper will try as hard as possible to
avoid opening those device if not necessary, by grouping them in a low
priority path group.

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

