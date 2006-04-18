From: Jody McIntyre <scjody@modernduck.com>
Subject: Re: [RFC PATCH] sbp2: remove manipulation of inquiry response
Date: Tue, 18 Apr 2006 05:41:38 -0400
Message-ID: <20060418094138.GL5346@conscoop.ottawa.on.ca>
References: <tkrat.d3b4470a9a767dd4@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [205.233.219.253] ([205.233.219.253]:21952 "EHLO
	conifer.conscoop.ottawa.on.ca") by vger.kernel.org with ESMTP
	id S1750705AbWDRJmw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 05:42:52 -0400
Content-Disposition: inline
In-Reply-To: <tkrat.d3b4470a9a767dd4@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Sat, Apr 08, 2006 at 08:45:24PM +0200, Stefan Richter wrote:
> This code became ineffective a few Linux releases ago and is
> apparently not required anyway.

Applied, thanks.

Cheers,
Jody

> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> Index: linux-2.6.17-rc1/drivers/ieee1394/sbp2.c
> ===================================================================
> --- linux-2.6.17-rc1.orig/drivers/ieee1394/sbp2.c	2006-04-08 09:43:33.000000000 +0200
> +++ linux-2.6.17-rc1/drivers/ieee1394/sbp2.c	2006-04-08 20:40:00.000000000 +0200
> @@ -2079,33 +2079,6 @@ static unsigned int sbp2_status_to_sense
>  }
>  
>  /*
> - * This function is called after a command is completed, in order to do any necessary SBP-2
> - * response data translations for the SCSI stack
> - */
> -static void sbp2_check_sbp2_response(struct scsi_id_instance_data *scsi_id,
> -				     struct scsi_cmnd *SCpnt)
> -{
> -	u8 *scsi_buf = SCpnt->request_buffer;
> -
> -	SBP2_DEBUG_ENTER();
> -
> -	if (SCpnt->cmnd[0] == INQUIRY && (SCpnt->cmnd[1] & 3) == 0) {
> -		/*
> -		 * Make sure data length is ok. Minimum length is 36 bytes
> -		 */
> -		if (scsi_buf[4] == 0) {
> -			scsi_buf[4] = 36 - 5;
> -		}
> -
> -		/*
> -		 * Fix ansi revision and response data format
> -		 */
> -		scsi_buf[2] |= 2;
> -		scsi_buf[3] = (scsi_buf[3] & 0xf0) | 2;
> -	}
> -}
> -
> -/*
>   * This function deals with status writes from the SBP-2 device
>   */
>  static int sbp2_handle_status_write(struct hpsb_host *host, int nodeid, int destid,
> @@ -2444,13 +2417,6 @@ static void sbp2scsi_complete_command(st
>  	}
>  
>  	/*
> -	 * Take care of any sbp2 response data mucking here (RBC stuff, etc.)
> -	 */
> -	if (SCpnt->result == DID_OK << 16) {
> -		sbp2_check_sbp2_response(scsi_id, SCpnt);
> -	}
> -
> -	/*
>  	 * If a bus reset is in progress and there was an error, complete
>  	 * the command as busy so that it will get retried.
>  	 */
> Index: linux-2.6.17-rc1/drivers/ieee1394/sbp2.h
> ===================================================================
> --- linux-2.6.17-rc1.orig/drivers/ieee1394/sbp2.h	2006-04-08 09:43:32.000000000 +0200
> +++ linux-2.6.17-rc1/drivers/ieee1394/sbp2.h	2006-04-08 20:40:00.000000000 +0200
> @@ -394,9 +394,8 @@ static int sbp2_link_orb_command(struct 
>  static int sbp2_send_command(struct scsi_id_instance_data *scsi_id,
>  			     struct scsi_cmnd *SCpnt,
>  			     void (*done)(struct scsi_cmnd *));
> -static unsigned int sbp2_status_to_sense_data(unchar *sbp2_status, unchar *sense_data);
> -static void sbp2_check_sbp2_response(struct scsi_id_instance_data *scsi_id,
> -				     struct scsi_cmnd *SCpnt);
> +static unsigned int sbp2_status_to_sense_data(unchar *sbp2_status,
> +					      unchar *sense_data);
>  static void sbp2_parse_unit_directory(struct scsi_id_instance_data *scsi_id,
>  				      struct unit_directory *ud);
>  static int sbp2_set_busy_timeout(struct scsi_id_instance_data *scsi_id);
> 
> 
> 
> 
> -------------------------------------------------------
> This SF.Net email is sponsored by xPML, a groundbreaking scripting language
> that extends applications into web and mobile media. Attend the live webcast
> and join the prime developer group breaking into this new coding territory!
> http://sel.as-us.falkag.net/sel?cmd=lnk&kid=110944&bid=241720&dat=121642
> _______________________________________________
> mailing list linux1394-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux1394-devel

-- 
