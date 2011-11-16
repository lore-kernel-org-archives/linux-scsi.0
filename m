From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/4] scsi_dh_rdac: Adding the match function
 for	rdac device handler
Date: Wed, 16 Nov 2011 12:32:43 -0500
Message-ID: <20111116173243.GA26675@redhat.com>
References: <47D23AD8469A2B448F33C24BD7A39BD9105DB4D8@RTPMVEXC1-PRD.hq.netapp.com>
	<4EB0EF3F.1010300@suse.de>
	<47D23AD8469A2B448F33C24BD7A39BD9105DB8EE@RTPMVEXC1-PRD.hq.netapp.com>
	<20111102154612.GA30632@redhat.com>
	<47D23AD8469A2B448F33C24BD7A39BD9105DBDC7@RTPMVEXC1-PRD.hq.netapp.com>
	<20111103151748.GA10627@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20111103151748.GA10627@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Babu.Moger@netapp.com, hare@suse.de
Cc: device-mapper development <dm-devel@redhat.com>, Peter Jones <pjones@redhat.com>, Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 03 2011 at 11:17am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Nov 03 2011 at 10:47am -0400,
> Moger, Babu <Babu.Moger@netapp.com> wrote:
> 
> > > -----Original Message-----
> > > From: Mike Snitzer [mailto:snitzer@redhat.com]
> > > Sent: Wednesday, November 02, 2011 10:46 AM
> > > To: device-mapper development
> > > Cc: Linux SCSI Mailing list
> > > Subject: Re: [dm-devel] [PATCH 3/4] scsi_dh_rdac: Adding the match
> > > function for rdac device handler

...

> > > What about the issue where the appropriate scsi_dh isn't attached
> > > during
> > > scan (resulting in boot failures, trespasses, etc)?
> > > 
> > > Hannes, I know you had plans for how to address the early scsi_dh
> > > attachment (and this match() work is a great step forward).  I just
> > > wanted to touch base with you on what your current vision is on how to
> > > achieve proper early scsi_dh attachment (and what the remaining TODO
> > > is).
> > 
> > I am not aware of any other issue at this point. Hannes may know about it.
> 
> Yeap Hannes is aware.
> 
> I was referring to IO being issued to passive paths (ghost LUNs) because
> scsi_dh isn't yet loaded.  Whereby causing the storage backend to
> trespass unnecessarily.  This bouncing (and corresponding IO errors) are
> avoided if the appropriate scsi_dh module is always loaded before the
> storage driver (e.g. lpfc or qla2xxx).

I have reviewed the scsi_dh match() changes (those from Hannes that are
already upstream and the 4 patches from Babu to complete match() for
other device handlers and the scsi_dh cleanup).

Hannes, in your cover-letter from the original scsi_dh_alua match
patchset, here: http://www.spinics.net/lists/linux-scsi/msg54281.html,
you said:

"In contrast to what we've discussed at LinuxTag I have not tried
to attach the alua device handler directly from scsi_scan.
Reason is that I need to issue SCSI commands during activation,
which means I would have to attach it from near the end of
scsi_add_lun(), at which point the device_handler would be attached
via the current method anyway. So I fail to see the gain here."

I haven't picked through the scsi_dh/scsi code enough to know what "the
current method" is (but I'm reviewing the code now).  That said, a quick
recap of what you feel the relevant highlights are would be appreciated.

But I thought the issue we discussed at LinuxTag was: how do we autoload
the scsi_dh module(s) so that the device handler is even available for
attachment?


Babu, you said that your patchset to implement match() for rdac resolved
the problem of the device handler not attaching properly:
http://www.redhat.com/archives/dm-devel/2011-November/msg00032.html

But that is only the case if scsi_dh_rdac has already been loaded early
by the initramfs right?

Given the updated scsi_dh match code: should it be safe for the
initramfs to just load all scsi_dh modules (and ALUA will be preferred
if TPGS is set)?

Does it make sense to re-visit Peter Jones' modalias code to autoload
scsi_dh in kernel rather than relying on adhoc initramfs code to know to
load the modules?

Mike
