From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Tue, 11 Feb 2003 10:00:06 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030211100006.A28010@beaverton.ibm.com>
References: <20030211081351.GA1368@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030211081351.GA1368@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, Feb 11, 2003 at 12:13:51AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Feb 11, 2003 at 12:13:51AM -0800, Mike Anderson wrote:
> This patch series is against scsi-misc-2.5.
> 

> +#define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
> +#define SCSI_EH_REC_TIMEOUT	0x0002	/* EH retry timed out */

SCSI_EH_REC_TIMEOUT isn't used.

Can we add a SCSI_EH_CMD, set for any command sent down for use in error
handling, and for users (well, at least one user) of the obosolete
eh_state?

Two drivers (u14-34f.c, eata.c) use eh_state as a redundant bug check
during abort, its use there could be deleted.

One driver (drivers/fc4/fc.c, might not even work) uses eh_state to track
the state of an internal scsi_cmnd - it needs two states, or it could
be changed to track the scsi_cmnd state separately.

One driver (dpt_i2o.c) uses eh_state to figure out if it has a command
sent via error handler, if not, it resets the timeout to a fixed value of
300 seconds (TMOUT_SCSI). It could use a SCSI_EH_CMD state to match its
previous intended behaviour.

-- Patrick Mansfield
