From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] libfc: fix seconds_since_last_reset miscalculation
Date: Wed, 16 Nov 2016 17:58:14 +0100
Message-ID: <4107905.14NieVZ4Uo@wuerfel>
References: <1478594694-98847-1-git-send-email-jthumshirn@suse.de> <1479221415.3426.3.camel@sandisk.com> <20161115150531.73jvxfclzzbtpfal@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161115150531.73jvxfclzzbtpfal@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tuesday, November 15, 2016 4:05:31 PM CET Johannes Thumshirn wrote:
> On Tue, Nov 15, 2016 at 02:50:17PM +0000, Bart Van Assche wrote:
> > On Tue, 2016-11-15 at 10:18 +0100, Johannes Thumshirn wrote:
> > > On Tue, Nov 08, 2016 at 03:04:43PM +0000, Bart Van Assche wrote:
> > > > I think the above code will miscalculate seconds_since_last_reset
> > > > if 
> > > > 'jiffies' wraps around after an lport has been created and before 
> > > > seconds_since_last_reset is computed. Shouldn't
> > > > seconds_since_last_reset 
> > > > be computed as follows?
> > > > 
> > > >   fc_stats->seconds_since_last_reset = (jiffies - boot_time) /
> > > > HZ;
> > > 
> > > But what happens when jiffies - boot_time becomes negative? Then we
> > > reintroduce the bug again and have 'fcoeadm -s' show weird values.
> > 
> > Hello Johannes,
> > 
> > If your concern is about 'jiffies' wrapping around on 32-bit systems
> > then you should use get_jiffies_64(). get_jiffies_64() - boot_time
> > can't become negative. It namely takes several million years before a
> > 64-bit HZ counter wraps around.
> 
> You're right. I'll respin using get_jiffies_64() and resent once it is tested.

Sorry for the bug I introduced and for not noticing this thread earlier.
Looking at this again now, I think it's clear that the bug was simply
mixing up the left and right side of the subtraction, the simple fix
would be

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 2d3133f62463..fe643f2195f0 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -311,7 +311,7 @@ struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 	fc_stats = &lport->host_stats;
 	memset(fc_stats, 0, sizeof(struct fc_host_statistics));
 
-	fc_stats->seconds_since_last_reset = (lport->boot_time - jiffies) / HZ;
+	fc_stats->seconds_since_last_reset = (jiffies - lport->boot_time) / HZ;
 
 	for_each_possible_cpu(cpu) {
 		struct fc_stats *stats;

This works correctly across jiffies overflows, as long as there is at least one
reset for every jiffies overflow (49 days or more). If we can have longer times
between resets, then we could either use get_jiffies_64() or ktime_get_seconds().

The latter would only need a 32-bit variable (overflow is after 136 years).

	Arnd
