From: R.E.Wolff@BitWizard.nl (Rogier Wolff)
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Tue, 2 Jul 2002 13:27:17 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200207021127.NAA10291@cave.bitwizard.nl>
References: <20020701151553.G776@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020701151553.G776@redhat.com> from Doug Ledford at "Jul 1, 2002
 03:15:53 pm"
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Matthew Jacob <mjacob@feral.com>, "[G_rard Roudier]" <groudier@free.fr>, Jeremy Higdon <jeremy@classic.engr.sgi.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org

Doug Ledford wrote:
> On Mon, Jul 01, 2002 at 12:08:03PM -0700, Matthew Jacob wrote:
> > Yes, exponential backoff is good in a lot of cases. BTW- this is something I
> > want to put into cam_periph_error for FreeBSD- I want to make the retry after
> > selection timeout also have exponential delays up to retry count.
> 
> Hmmm...what's the purpose on this BTW?  Selection timeouts on what, fiber 
> or SPI or something else?

As I'm in the data-recovery business, I've seen more than my share of
"bad disks".

I've seen (mostly IDE) cases where the retry "interrupted" the drive
while it was still recovering from the last problem, leading to a new
erorr condition, which triggered the same "lengthy recovery" in the
drive. Repeat ad inifinitum. 

Exponential backoff would've helped.

If "now" we think that a retry after 1 second is right, then I would
suggest something like a "backoff factor" of 1.5, and an initial value
of 0.7 seconds.

			Roger. 


-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2137555 **
*-- BitWizard writes Linux device drivers for any device you may have! --*
* There are old pilots, and there are bold pilots. 
* There are also old, bald pilots. 
