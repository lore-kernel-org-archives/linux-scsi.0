From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 2/4] 2.4 SCSI error handling fixes
Date: Thu, 12 Sep 2002 14:18:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020912141806.J1551@redhat.com>
References: <20020912191354.B4739@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020912191354.B4739@flint.arm.linux.org.uk>; from rmk@arm.linux.org.uk on Thu, Sep 12, 2002 at 07:13:54PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-scsi@vger.kernel.org

On Thu, Sep 12, 2002 at 07:13:54PM +0100, Russell King wrote:
> -	scsi_setup_cmd_retry(SCpnt);
> -	scsi_send_eh_cmnd(SCpnt, SCpnt->timeout_per_command);
> +	do {
> +		scsi_setup_cmd_retry(SCpnt);
> +		scsi_send_eh_cmnd(SCpnt, SCpnt->timeout_per_command);
> +	} while (SCpnt->eh_state == NEEDS_RETRY);

> +		 * If the SCSI device responded with "logical unit
> +		 * is in process of becoming ready", we need to
> +		 * retry this command.
> +		 */
> +	} while (SCpnt->eh_state == NEEDS_RETRY);

> +		/*
> +		 * If the SCSI device responded with "logical unit
> +		 * is in process of becoming ready", we need to
> +		 * retry this command.
> +		 */
> +	} while (SCpnt->eh_state == NEEDS_RETRY);

>  		default:
> -			SCpnt->eh_state = FAILED;
> +			ret = FAILED;
> +			/*FALLTHROUGH*/
> +		case FAILED:
> +		case NEEDS_RETRY:
> +		case SUCCESS:
> +			SCpnt->eh_state = ret;
>  			break;
>  		}
>  	} else {

I don't see any bounding here.  You *have* to bound this.  It is not that 
uncommon for a device to report "logical unit is in the process of 
becoming ready" forever on certain types of hardware failures.  Without 
bounding, we won't ever give up on it.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
