From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Tue, 11 Feb 2003 10:44:55 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030211184455.GA1114@beaverton.ibm.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <20030211100006.A28010@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e35.co.us.ibm.com (8.12.7/8.12.2) with ESMTP id h1BIiOKo218970
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2003 13:44:24 -0500
Content-Disposition: inline
In-Reply-To: <20030211100006.A28010@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield [patmans@us.ibm.com] wrote:
> On Tue, Feb 11, 2003 at 12:13:51AM -0800, Mike Anderson wrote:
> > This patch series is against scsi-misc-2.5.
> > 
> 
> > +#define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
> > +#define SCSI_EH_REC_TIMEOUT	0x0002	/* EH retry timed out */
> 
> SCSI_EH_REC_TIMEOUT isn't used.
> 

SCSI_EH_REC_TIMEOUT is used in scsi_eh_times_out to indicate that a
scsi_eh_cmd timed-out. While we are not retrying failed commands in the
eh handler we are sending TURs which could timeout.

> Can we add a SCSI_EH_CMD, set for any command sent down for use in error
> handling, and for users (well, at least one user) of the obosolete
> eh_state?
> 

We need a solution, but I was trying to keep these flags for eh use
only. Since there is some broken drivers now, maybe the easiest solution
is to provide a flag.

> Two drivers (u14-34f.c, eata.c) use eh_state as a redundant bug check
> during abort, its use there could be deleted.
> 

Yes, maybe this check should be deleted.

Another option would be to use this check.

if (scmd->serial_number != scmd->serial_number_at_timeout) {
	return (FAILED);
}

> One driver (drivers/fc4/fc.c, might not even work) uses eh_state to track
> the state of an internal scsi_cmnd - it needs two states, or it could
> be changed to track the scsi_cmnd state separately.
> 

Short term might be easier to add the flag, but this driver could
allocate mem for host_scribble and use this.

> One driver (dpt_i2o.c) uses eh_state to figure out if it has a command
> sent via error handler, if not, it resets the timeout to a fixed value of
> 300 seconds (TMOUT_SCSI). It could use a SCSI_EH_CMD state to match its
> previous intended behaviour.
> 

I do not have a good answer here right now.


-andmike
--
Michael Anderson
andmike@us.ibm.com

