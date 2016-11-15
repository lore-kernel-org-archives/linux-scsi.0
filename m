From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libfc: fix seconds_since_last_reset miscalculation
Date: Tue, 15 Nov 2016 10:18:40 +0100
Message-ID: <20161115091840.7cldqui4dpi7nrz5@linux-x5ow.site>
References: <1478594694-98847-1-git-send-email-jthumshirn@suse.de>
 <BLUPR02MB16830DECB29262BACBA94FA681A60@BLUPR02MB1683.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BLUPR02MB16830DECB29262BACBA94FA681A60@BLUPR02MB1683.namprd02.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 08, 2016 at 03:04:43PM +0000, Bart Van Assche wrote:

[...]

> Hello Johannes,
> 
> I think the above code will miscalculate seconds_since_last_reset if 
> 'jiffies' wraps around after an lport has been created and before 
> seconds_since_last_reset is computed. Shouldn't seconds_since_last_reset 
> be computed as follows?
> 
> 	fc_stats->seconds_since_last_reset = (jiffies - boot_time) / HZ;

But what happens when jiffies - boot_time becomes negative? Then we
reintroduce the bug again and have 'fcoeadm -s' show weird values.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
