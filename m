From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Linux 2.6.16-rc3
Date: Fri, 17 Feb 2006 22:30:32 -0700
Message-ID: <20060218053032.GU12822@parisc-linux.org>
References: <1140054960.3037.5.camel@mulgrave.il.steeleye.com> <20060216171200.GD29443@flint.arm.linux.org.uk> <1140112653.3178.9.camel@mulgrave.il.steeleye.com> <20060216180939.GF29443@flint.arm.linux.org.uk> <1140113671.3178.16.camel@mulgrave.il.steeleye.com> <20060216181803.GG29443@flint.arm.linux.org.uk> <1140116969.3178.24.camel@mulgrave.il.steeleye.com> <20060216200138.GA4203@suse.de> <1140223363.3231.9.camel@mulgrave.il.steeleye.com> <adaaccpbekr.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <adaaccpbekr.fsf@cisco.com>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Roland Dreier <rdreier@cisco.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, Russell King <rmk+lkml@arm.linux.org.uk>, Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org, "Brown, Len" <len.brown@intel.com>, "David S. Miller" <davem@davemloft.net>, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, "Yu, Luming" <luming.yu@intel.com>, Ben Castricum <lk@bencastricum.nl>, sanjoy@mrao.cam.ac.uk, Helge Hafting <helgehaf@aitel.hist.no>, "Carlo E. Prelz" <fluido@fluido.as>, Gerrit Bruchh?user <gbruchhaeuser@gmx.de>, Nicolas.Mailhot@LaPoste.net, Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>, Patrizio Bassi <patrizio.bassi@gmail.com>, Bj?rn Nilsson <bni.swe@gmail.com>, Andrey Borzenkov <arvidjaar@mail.ru>, "P. Christeas" <p_christ@hol.gr>, ghrt <ghrt@dial.kappa.ro>, jinhong
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 17, 2006 at 06:12:04PM -0800, Roland Dreier wrote:
>  > +int execute_in_process_context(void (*fn)(void *data), void *data,
>  > +			       struct execute_work *ew)
>  > +{
>  > +	if (!in_interrupt()) {
>  > +		fn(data);
>  > +		return 0;
>  > +	}
> 
> Is testing in_interrupt() really sufficient to make this work?  I seem
> to remember that (at least) with CONFIG_PREEMPT disabled, there are
> contexts where it is not safe to sleep but where both in_interrupt()
> and in_atomic() still return 0.

That's correct -- in process context, with PREEMPT disabled and a spinlock
held, it's unsafe to call this function.  It works well for the SCSI
usage (where it's called either in interrupt context or in user
context with no spinlocks held), but it's not *always* safe.

I think this needs to be documented in the kerneldoc.


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=103432&bid=230486&dat=121642
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
