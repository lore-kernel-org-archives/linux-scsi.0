From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH 2/4] 2.4 SCSI error handling fixes
Date: Thu, 12 Sep 2002 12:31:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020912193114.GB1170@beaverton.ibm.com>
References: <20020912191354.B4739@flint.arm.linux.org.uk> <20020912141806.J1551@redhat.com> <20020912192028.E4739@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020912192028.E4739@flint.arm.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-scsi@vger.kernel.org

Russell King [rmk@arm.linux.org.uk] wrote:
> On Thu, Sep 12, 2002 at 02:18:06PM -0400, Doug Ledford wrote:
> > On Thu, Sep 12, 2002 at 07:13:54PM +0100, Russell King wrote:
> > > -	scsi_setup_cmd_retry(SCpnt);
> > > -	scsi_send_eh_cmnd(SCpnt, SCpnt->timeout_per_command);
> > > +	do {
> > > +		scsi_setup_cmd_retry(SCpnt);
> > > +		scsi_send_eh_cmnd(SCpnt, SCpnt->timeout_per_command);
> > > +	} while (SCpnt->eh_state == NEEDS_RETRY);
> > 
> > > +		 * If the SCSI device responded with "logical unit
> > > +		 * is in process of becoming ready", we need to
> > > +		 * retry this command.
> > > +		 */
> > > +	} while (SCpnt->eh_state == NEEDS_RETRY);
> > 
> > > +		/*
> > > +		 * If the SCSI device responded with "logical unit
> > > +		 * is in process of becoming ready", we need to
> > > +		 * retry this command.
> > > +		 */
> > > +	} while (SCpnt->eh_state == NEEDS_RETRY);
> > 
> > >  		default:
> > > -			SCpnt->eh_state = FAILED;
> > > +			ret = FAILED;
> > > +			/*FALLTHROUGH*/
> > > +		case FAILED:
> > > +		case NEEDS_RETRY:
> > > +		case SUCCESS:
> > > +			SCpnt->eh_state = ret;
> > >  			break;
> > >  		}
> > >  	} else {
> > 
> > I don't see any bounding here.  You *have* to bound this.  It is not that 
> > uncommon for a device to report "logical unit is in the process of 
> > becoming ready" forever on certain types of hardware failures.  Without 
> > bounding, we won't ever give up on it.
> 
> Shrug.  I've not changed the behaviour here.  I've just fixed the ONE
> problem where we reissue the command back to the HBA driver with stale
> state information.  I never claimed that it fixed ALL bugs.
> 
> I'm afraid that I'm going to have to leave the other bugs are for
> someone else to address; I've already spent too long on this issue.
> 

In 2.5 we are carrying a change in scsi_eh_completed_normally (I believe
this came from  Andries.Brouwer@cwi.nl as I cannot find another
reference to it) that limits the number of retries. 

Though this is modifying the original cmds retry count which I do not
believe it is a good thing at least it stops the loop. I know retries
are going to change, but until then I made a similar adjustment to my
scsi_error cleanup and will repost shortly.

-andmike
-- 
Michael Anderson
andmike@us.ibm.com

