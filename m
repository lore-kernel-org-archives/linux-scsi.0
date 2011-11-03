From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 4/6 v2] PM: Limit race conditions between
 runtime PM and system sleep (v2)
Date: Wed, 2 Nov 2011 18:31:27 -0700
Message-ID: <20111103013127.GA3481@kroah.com>
References: <201106260054.20578.rjw@sisk.pl>
	<CACRpkdafpsgUi-0K5krr2_Hp+8GzCG8ZPu-HVNOK0_7uwURxdg@mail.gmail.com>
	<20111102211708.GA19025@kroah.com> <201111030128.52823.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <201111030128.52823.rjw@sisk.pl>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/linux-pm/>
List-Post: <mailto:linux-pm@lists.linux-foundation.org>
List-Help: <mailto:linux-pm-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=subscribe>
Sender: linux-pm-bounces@lists.linux-foundation.org
Errors-To: linux-pm-bounces@lists.linux-foundation.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>, Ulf Hansson <Ulf.Hansson@stericsson.com>, Tejun Heo <tj@kernel.org>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 03, 2011 at 01:28:52AM +0100, Rafael J. Wysocki wrote:
> On Wednesday, November 02, 2011, Greg KH wrote:
> > On Wed, Nov 02, 2011 at 10:00:39PM +0100, Linus Walleij wrote:
> > > On Wed, Nov 2, 2011 at 9:11 PM, Greg KH <greg@kroah.com> wrote:
> > > > On Wed, Nov 02, 2011 at 09:06:02PM +0100, Linus Walleij wrote:
> > > >> On Wed, Nov 2, 2011 at 8:14 PM, Greg KH <greg@kroah.com> wrote:
> > > >> > So, what specific git commits do you want to see in the 3.0-stable
> > > >> > tree, and in what order should they be applied in?
> > > >>
> > > >> So to my untrained eye it looks like it should be applied like this (top to
> > > >> bottom) using the reverse commit order from the mainline kernel:
> > > >>
> > > >> e529192 PM: Introduce generic "noirq" callback routines for subsystems (v2)
> > > >> 455716e PM / Runtime: Update documentation of interactions with system sleep
> > > >> 1e2ef05 PM: Limit race conditions between runtime PM and system sleep (v2)
> > > >> f3393b6 PM / Runtime: Add new helper function: pm_runtime_status_suspended()
> > > >>
> > > >> So (2) documents the problem, (3) fixes it, whereas (1) and (4) makes
> > > >> it possible
> > > >> to write proper _noirq() code that does not race, IIRC.
> > > >
> > > > But, after this, it's just adding new infrastructure that drivers will
> > > > then be able to use.  As I'm not adding new drivers to 3.0, there will
> > > > not be any users of this code, so why add it in the first place?  It
> > > > doesn't look like this follows the rules of the stable kernel tree at
> > > > all, does it?
> > > 
> > > We'll have to get some feedback from Rafael, but the way I percieved
> > > it, the patch (2) fixes a very real race, then fixing that makes it
> > > necessary for drivers using runtime_pm to do things differently to
> > > be on the safe side. But none were really fixed when first merging
> > > it.
> > > 
> > > So on second thought you probably only want patch (2)
> > > "PM: Limit race conditions between runtime PM and system sleep (v2)"
> > > for stable.
> > 
> > Ok, Rafael, any objection to me applying just this one?
> 
> Well, I'd prefer not to unless there are reports confirming user problems
> being fixed specifically by this patch.  It changes the PM core's behavior
> quite significantly and I'm a little afraid of possible regressions that may
> result from it.

Ok, good reason to not apply it, consider it dropped :)

greg k-h
