From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [ANNOUNCE] hotplug-ng 001 release
Date: Fri, 18 Feb 2005 09:17:37 -0800
Message-ID: <20050218171737.GA20012@us.ibm.com>
References: <20050211193627.GB20015@suse.de> <20050211204626.GC2568@katya> <20050211211028.GB21512@suse.de> <20050212003458.GI2568@katya> <20050214224208.GC13110@suse.de> <20050216105117.GB2360@katya> <20050216110752.GC2360@katya> <1108594961l.5056l.5l@serve.riede.org> <20050216231741.GD2870@katya> <1108596771l.5056l.6l@serve.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1108596771l.5056l.6l@serve.riede.org>
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: Willem Riede <osst@riede.org>, linux-scsi@vger.kernel.org
Cc: linux-hotplug-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

[added linux-scsi]

On Wed, Feb 16, 2005 at 11:32:51PM +0000, Willem Riede wrote:
> On 02/16/2005 06:17:41 PM, Roman Kagan wrote:

I tried out Roman's patch, well at least simple loading of st via
"modprobe scsi-type-1", works nicely as expected. (modprobe -r sd is
hanging on down() in device_unregister with 2.6.11-rc4 ... must be a ref
count problem, have not figured anything out, and took me a while before
trying st and sg instead.)

> > On Wed, Feb 16, 2005 at 11:02:41PM +0000, Willem Riede wrote:
> > > On 02/16/2005 06:07:52 AM, Roman Kagan wrote:
> > > > It handles only st, sd_mod and sr_mod cases (as
> > > > hotplug-ng-001/module_scsi.c did).  Are there any other?
> > > 
> > > Not all tapes are supported by st - OnStream drives need osst instead.
> > 
> > As an excuse I can say that I reproduced what was in
> > hotplug-ng-001/module_scsi.c, no more, no less :)
> > 
> > > How do you suggest that is to be handled?
> > 
> > AFAICS they coexist nicely, so, if you add the same thing to osst.c:
> > 
> > MODULE_ALIAS("scsi-type-1");	/*	TYPE_TAPE	*/
> > 
> > both osst and st will be loaded (provided Greg convinces Rusty to make
> > modprobe load _all_ matching modules as he suggested the other day).
> > Then the one whose .probe succeeds will handle the device.
> > 
> > Will that work?
> 
> Yes. If we can get that load-all behaviour implemented, everything will be fine.

You could also append the sdev->vendor and sdev->model, and use alias wild
cards.

So OSST would not be loaded for all tape devices found (not a big deal).
st would still load for all tapes (likely the same as we have today, and
not easy to *not* load it for osst devices).

That is, add aliases to osst.c like:

MODULE_ALIAS("scsi-type-1-onStream-SC-*");
MODULE_ALIAS("scsi-type-1-onStream-DI-*");

etc.

The vendor (8 bytes) and model (16 bytes) can have spaces, and the values
are not '\0' terminated. modprobe does not seem to handle spaces in an
alias.

And for st.c:

MODULE_ALIAS("scsi-type-1-*");

sd.c:

MODULE_ALIAS("scsi-type-4-*");
MODULE_ALIAS("scsi-type-5-*");

Also, sg loading would want (along with modprobe load all feature):

MODULE_ALIAS("scsi-type-*");

-- Patrick Mansfield


-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now.
http://ads.osdn.com/?ad_id=6595&alloc_id=14396&op=click
