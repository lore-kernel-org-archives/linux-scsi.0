From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libfc: fix seconds_since_last_reset miscalculation
Date: Tue, 15 Nov 2016 16:05:31 +0100
Message-ID: <20161115150531.73jvxfclzzbtpfal@linux-x5ow.site>
References: <1478594694-98847-1-git-send-email-jthumshirn@suse.de>
 <BLUPR02MB16830DECB29262BACBA94FA681A60@BLUPR02MB1683.namprd02.prod.outlook.com>
 <20161115091840.7cldqui4dpi7nrz5@linux-x5ow.site>
 <1479221415.3426.3.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57190 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751088AbcKOPFe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Nov 2016 10:05:34 -0500
Content-Disposition: inline
In-Reply-To: <1479221415.3426.3.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "arnd@arndb.de" <arnd@arndb.de>

On Tue, Nov 15, 2016 at 02:50:17PM +0000, Bart Van Assche wrote:
> On Tue, 2016-11-15 at 10:18 +0100, Johannes Thumshirn wrote:
> > On Tue, Nov 08, 2016 at 03:04:43PM +0000, Bart Van Assche wrote:
> > > I think the above code will miscalculate seconds_since_last_reset
> > > if 
> > > 'jiffies' wraps around after an lport has been created and before 
> > > seconds_since_last_reset is computed. Shouldn't
> > > seconds_since_last_reset 
> > > be computed as follows?
> > > 
> > > 	fc_stats->seconds_since_last_reset = (jiffies - boot_time) /
> > > HZ;
> > 
> > But what happens when jiffies - boot_time becomes negative? Then we
> > reintroduce the bug again and have 'fcoeadm -s' show weird values.
> 
> Hello Johannes,
> 
> If your concern is about 'jiffies' wrapping around on 32-bit systems
> then you should use get_jiffies_64(). get_jiffies_64() - boot_time
> can't become negative. It namely takes several million years before a
> 64-bit HZ counter wraps around.

You're right. I'll respin using get_jiffies_64() and resent once it is tested.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
