From: Mike Brown <mbrown@emc.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 15:38:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031203857.GV574@lapi0061>
References: <20021031170337.GO574@lapi0061> <798370000.1036087399@aslan.btc.adaptec.com> <20021031200758.GB30047@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021031200758.GB30047@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org

Hi,

> The whole "support more than 8 luns on SCSI-2 devices" is a hack anyway, I 
> would be more likely to just remove it instead of changing other things.

This would break production environments.  Symmetrix isn't the only
storage array that supports this hack.  DG, Dell, HP, and others also
support this hack.  If its taken out in 2.5 and replaced with
REPORT_LUNS that'd be ok, but taking it out of 2.4 without replacing
it with REPORT_LUNS is going to break people.

> > 3) Linux should be using the Report Luns command to determine how
> >    many luns are on a device and at what locations.  This might
> >    even allow you to never probe more than 8 luns on a SCSI 2
> >    device unless they support this command.  Does the Symetrix support
> >    it?  Going beyond 8 luns on a SCSI2 device is really a hack
> >    otherwise.
> 
> We currently only do report luns on SCSI-3 devices.  I didn't think this 
> was a supported command on SCSI-2, but I hadn't checked the spec 
> recently...hmmm...nope, not supported in SCSI-2, so using report luns on 
> SCSI-2 devices is just as much a hack as going above lun 7 on SCSI-2 
> devices without specific knowledge of transfer interconnect.

Symmetrix supports Report Luns despite reporting SCSI_2 Units.  The
problem is that because Symmetrix in the device table with
a BLIST_LARGELUN flag, this block gets tripped in the scanning code:

	if (SDpnt && (0 == lun)) {
		int bflags = get_device_flags (scsi_result);
		if (bflags & BLIST_LARGELUN)
			lun0_sl = SCSI_3; /* treat as SCSI 3 */
		else
			lun0_sl = SDpnt->scsi_level;
	}

The quick fix is to change the AIC driver's max lun value to 32, but
Justin's right, its not the AIC driver with the problem.  I don't know
what the right fix is for 2.4.  We need a hack akin to something like:

	if ((bflags & BLIST_LARGELUN) && !shpnt->is_fibre && lun > 31)
		/* IDENTIFY only has 5 bits for LUN including reserved hack */
		break;
	else if ((lun0_sl < SCSI_3) && (lun > 7))
		/* don't probe further for luns > 7 for targets <= SCSI_2 */
		break;

	if (!scan_scsis_single(channel, order_dev, lun, lun0_sl,
		 	       &max_dev_lun, &sparse_lun, &SDpnt, shpnt,
			       scsi_result) && !sparse_lun)
		break;	/* break means don't probe further for luns!=0 */

	if (SDpnt && (0 == lun))
		lun0_sl = SDpnt->scsi_level;

and to get rid of this logic:

	if (SDpnt && (0 == lun)) {
		int bflags = get_device_flags (scsi_result);
		if (bflags & BLIST_LARGELUN)
			lun0_sl = SCSI_3; /* treat as SCSI 3 */
		else
			lun0_sl = SDpnt->scsi_level;

Comments?  Again please cc: me for list replies.

-Michael F. Brown, EMC Corp.

Email:            mbrown@emc.com

"5 years from now everyone will be running free
 GNU on their 200 MIPS, 64M SPARCstation-5."      -Andrew Tanenbaum '92

(In late 1997 I installed Linux for the first time on my 200Mhz, 128M
 AMD x86 clone)
