From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 2/4] 2.4 SCSI error handling fixes
Date: Thu, 12 Sep 2002 19:20:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020912192028.E4739@flint.arm.linux.org.uk>
References: <20020912191354.B4739@flint.arm.linux.org.uk> <20020912141806.J1551@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17pYZp-0005DG-00
	for linux-scsi@vger.kernel.org; Thu, 12 Sep 2002 19:20:29 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17pYZo-0001M2-00
	for linux-scsi@vger.kernel.org; Thu, 12 Sep 2002 19:20:28 +0100
Content-Disposition: inline
In-Reply-To: <20020912141806.J1551@redhat.com>; from dledford@redhat.com on Thu, Sep 12, 2002 at 02:18:06PM -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, Sep 12, 2002 at 02:18:06PM -0400, Doug Ledford wrote:
> On Thu, Sep 12, 2002 at 07:13:54PM +0100, Russell King wrote:
> > -	scsi_setup_cmd_retry(SCpnt);
> > -	scsi_send_eh_cmnd(SCpnt, SCpnt->timeout_per_command);
> > +	do {
> > +		scsi_setup_cmd_retry(SCpnt);
> > +		scsi_send_eh_cmnd(SCpnt, SCpnt->timeout_per_command);
> > +	} while (SCpnt->eh_state == NEEDS_RETRY);
> 
> > +		 * If the SCSI device responded with "logical unit
> > +		 * is in process of becoming ready", we need to
> > +		 * retry this command.
> > +		 */
> > +	} while (SCpnt->eh_state == NEEDS_RETRY);
> 
> > +		/*
> > +		 * If the SCSI device responded with "logical unit
> > +		 * is in process of becoming ready", we need to
> > +		 * retry this command.
> > +		 */
> > +	} while (SCpnt->eh_state == NEEDS_RETRY);
> 
> >  		default:
> > -			SCpnt->eh_state = FAILED;
> > +			ret = FAILED;
> > +			/*FALLTHROUGH*/
> > +		case FAILED:
> > +		case NEEDS_RETRY:
> > +		case SUCCESS:
> > +			SCpnt->eh_state = ret;
> >  			break;
> >  		}
> >  	} else {
> 
> I don't see any bounding here.  You *have* to bound this.  It is not that 
> uncommon for a device to report "logical unit is in the process of 
> becoming ready" forever on certain types of hardware failures.  Without 
> bounding, we won't ever give up on it.

Shrug.  I've not changed the behaviour here.  I've just fixed the ONE
problem where we reissue the command back to the HBA driver with stale
state information.  I never claimed that it fixed ALL bugs.

I'm afraid that I'm going to have to leave the other bugs are for
someone else to address; I've already spent too long on this issue.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

