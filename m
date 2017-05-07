From: Pavel Machek <pavel@ucw.cz>
Subject: Re: Race to power off harming SATA SSDs
Date: Sun, 7 May 2017 22:40:07 +0200
Message-ID: <20170507204007.GA25628@atrey.karlin.mff.cuni.cz>
References: <20170410232118.GA4816@khazad-dum.debian.net>
 <20170410235206.GA28603@wtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170410235206.GA28603@wtj.duckdns.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Tejun Heo <tj@kernel.org>
Cc: boris.brezillon@free-electrons.com, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

Hi!

> > However, *IN PRACTICE*, SATA STANDBY IMMEDIATE command completion
> > [often?] only indicates that the device is now switching to the target
> > power management state, not that it has reached the target state.  Any
> > further device status inquires would return that it is in STANDBY mode,
> > even if it is still entering that state.
> > 
> > The kernel then continues the shutdown path while the SSD is still
> > preparing itself to be powered off, and it becomes a race.  When the
> > kernel + firmware wins, platform power is cut before the SSD has
> > finished (i.e. the SSD is subject to an unclean power-off).
> 
> At that point, the device is fully flushed and in terms of data
> integrity should be fine with losing power at any point anyway.

Actually, no, that is not how it works.

"Fully flushed" is one thing, surviving power loss is
different. Explanation below.

> > NOTE: unclean SSD power-offs are dangerous and may brick the device in
> > the worst case, or otherwise harm it (reduce longevity, damage flash
> > blocks).  It is also not impossible to get data corruption.
> 
> I get that the incrementing counters might not be pretty but I'm a bit
> skeptical about this being an actual issue.  Because if that were
> true, the device would be bricking itself from any sort of power
> losses be that an actual power loss, battery rundown or hard power off
> after crash.

And that's exactly what users see. If you do enough power fails on a
SSD, you usually brick it, some die sooner than others. There was some
test results published, some are here
http://lkcl.net/reports/ssd_analysis.html, I believe I seen some
others too.

It is very hard for a NAND to work reliably in face of power
failures. In fact, not even Linux MTD + UBIFS works well in that
regards. See
http://www.linux-mtd.infradead.org/faq/ubi.html. (Unfortunately, its
down now?!). If we can't get it right, do you believe SSD manufactures
do?

[Issue is, if you powerdown during erase, you get "weakly erased"
page, which will contain expected 0xff's, but you'll get bitflips
there quickly. Similar issue exists for writes. It is solveable in
software, just hard and slow... and we don't do it.]
									
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
