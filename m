From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Tue, 29 Mar 2011 14:45:01 -0400
Message-ID: <20110329184501.GG24485@redhat.com>
References: <1301373398.2590.20.camel@mulgrave.site>
 <4D91BF90.8070909@redhat.com>
 <DBFB1B45AF80394ABD1C807E9F28D15702659CFFED@BLRX7MCDC203.AMER.DELL.COM>
 <20110329173338.GD24485@redhat.com>
 <DBFB1B45AF80394ABD1C807E9F28D15702659D0011@BLRX7MCDC203.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DBFB1B45AF80394ABD1C807E9F28D15702659D0011@BLRX7MCDC203.AMER.DELL.COM>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Shyam_Iyer@Dell.com
Cc: rwheeler@redhat.com, James.Bottomley@hansenpartnership.com, lsf@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 29, 2011 at 11:10:18AM -0700, Shyam_Iyer@Dell.com wrote:
> 
> 
> > -----Original Message-----
> > From: Vivek Goyal [mailto:vgoyal@redhat.com]
> > Sent: Tuesday, March 29, 2011 1:34 PM
> > To: Iyer, Shyam
> > Cc: rwheeler@redhat.com; James.Bottomley@hansenpartnership.com;
> > lsf@lists.linux-foundation.org; linux-fsdevel@vger.kernel.org; dm-
> > devel@redhat.com; linux-scsi@vger.kernel.org
> > Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
> > 
> > On Tue, Mar 29, 2011 at 10:20:57AM -0700, Shyam_Iyer@dell.com wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > > > owner@vger.kernel.org] On Behalf Of Ric Wheeler
> > > > Sent: Tuesday, March 29, 2011 7:17 AM
> > > > To: James Bottomley
> > > > Cc: lsf@lists.linux-foundation.org; linux-fsdevel; linux-
> > > > scsi@vger.kernel.org; device-mapper development
> > > > Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
> > > >
> > > > On 03/29/2011 12:36 AM, James Bottomley wrote:
> > > > > Hi All,
> > > > >
> > > > > Since LSF is less than a week away, the programme committee put
> > > > together
> > > > > a just in time preliminary agenda for LSF.  As you can see there
> > is
> > > > > still plenty of empty space, which you can make suggestions (to
> > this
> > > > > list with appropriate general list cc's) for filling:
> > > > >
> > > > >
> > > >
> > https://spreadsheets.google.com/pub?hl=en&hl=en&key=0AiQMl7GcVa7OdFdNQz
> > > > M5UDRXUnVEbHlYVmZUVHQ2amc&output=html
> > > > >
> > > > > If you don't make suggestions, the programme committee will feel
> > > > > empowered to make arbitrary assignments based on your topic and
> > > > attendee
> > > > > email requests ...
> > > > >
> > > > > We're still not quite sure what rooms we will have at the Kabuki,
> > but
> > > > > we'll add them to the spreadsheet when we know (they should be
> > close
> > > > to
> > > > > each other).
> > > > >
> > > > > The spreadsheet above also gives contact information for all the
> > > > > attendees and the programme committee.
> > > > >
> > > > > Yours,
> > > > >
> > > > > James Bottomley
> > > > > on behalf of LSF/MM Programme Committee
> > > > >
> > > >
> > > > Here are a few topic ideas:
> > > >
> > > > (1)  The first topic that might span IO & FS tracks (or just pull
> > in
> > > > device
> > > > mapper people to an FS track) could be adding new commands that
> > would
> > > > allow
> > > > users to grow/shrink/etc file systems in a generic way.  The
> > thought I
> > > > had was
> > > > that we have a reasonable model that we could reuse for these new
> > > > commands like
> > > > mount and mount.fs or fsck and fsck.fs. With btrfs coming down the
> > > > road, it
> > > > could be nice to identify exactly what common operations users want
> > to
> > > > do and
> > > > agree on how to implement them. Alasdair pointed out in the
> > upstream
> > > > thread that
> > > > we had a prototype here in fsadm.
> > > >
> > > > (2) Very high speed, low latency SSD devices and testing. Have we
> > > > settled on the
> > > > need for these devices to all have block level drivers? For S-ATA
> > or
> > > > SAS
> > > > devices, are there known performance issues that require
> > enhancements
> > > > in
> > > > somewhere in the stack?
> > > >
> > > > (3) The union mount versus overlayfs debate - pros and cons. What
> > each
> > > > do well,
> > > > what needs doing. Do we want/need both upstream? (Maybe this can
> > get 10
> > > > minutes
> > > > in Al's VFS session?)
> > > >
> > > > Thanks!
> > > >
> > > > Ric
> > >
> > > A few others that I think may span across I/O, Block fs..layers.
> > >
> > > 1) Dm-thinp target vs File system thin profile vs block map based
> > thin/trim profile.
> > 
> > > Facilitate I/O throttling for thin/trimmable storage. Online and
> > Offline profil.
> > 
> > Is above any different from block IO throttling we have got for block
> > devices?
> > 
> Yes.. so the throttling would be capacity  based.. when the storage array wants us to throttle the I/O. Depending on the event we may keep getting space allocation write protect check conditions for writes until a user intervenes to stop I/O.
> 

Sounds like some user space daemon listening for these events and then
modifying cgroup throttling limits dynamically?

> 
> > > 2) Interfaces for SCSI, Ethernet/*transport configuration parameters
> > floating around in sysfs, procfs. Architecting guidelines for accepting
> > patches for hybrid devices.
> > > 3) DM snapshot vs FS snapshots vs H/W snapshots. There is room for
> > all and they have to help each other
> 
> For instance if you took a DM snapshot and the storage sent a check condition to the original dm device I am not sure if the DM snapshot would get one too..
> 
> If you had a scenario of taking H/W snapshot of an entire pool and decide to delete the individual DM snapshots the H/W snapshot would be inconsistent.
> 
> The blocks being managed by a DM-device would have moved (SCSI referrals). I believe Hannes is working on the referrals piece.. 
> 
> > > 4) B/W control - VM->DM->Block->Ethernet->Switch->Storage. Pick your
> > subsystem and there are many non-cooperating B/W control constructs in
> > each subsystem.
> > 
> > Above is pretty generic. Do you have specific needs/ideas/concerns?
> > 
> > Thanks
> > Vivek
> Yes.. if I limited by Ethernet b/w to 40% I don't need to limit I/O b/w via cgroups. Such bandwidth manipulations are network switch driven and cgroups never take care of these events from the Ethernet driver.

So if IO is going over network and actual bandwidth control is taking
place by throttling ethernet traffic then one does not have to specify
block cgroup throttling policy and hence no need for cgroups to be worried
about ethernet driver events?

I think I am missing something here.

Vivek
