From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC, PATCH] SCSI tape: MTIOCSENSE ioctl to return the sense
 data from errors
Date: Fri, 11 Jul 2008 11:07:10 -0700
Message-ID: <20080711110710.8728881e.randy.dunlap@oracle.com>
References: <alpine.LNX.1.10.0807111643250.5811@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:42098 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbYGKSHi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2008 14:07:38 -0400
In-Reply-To: <alpine.LNX.1.10.0807111643250.5811@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, Arne Wiebalck <arne.wiebalck@cern.ch>

On Fri, 11 Jul 2008 16:57:00 +0300 (EEST) Kai Makisara wrote:

> -----------------------8<-----------------------------------------------
> diff --git a/Documentation/scsi/st.txt b/Documentation/scsi/st.txt
> index 4075260..7847655 100644
> --- a/Documentation/scsi/st.txt
> +++ b/Documentation/scsi/st.txt
> @@ -457,6 +459,17 @@ MTIOCGET Returns some status information.
>  	is set if there is no tape in the drive. GMT_EOD means either
>  	end of recorded data or end of tape. GMT_EOT means end of tape.
>  
> +The following ioctl uses the structure mtsense to return error information:
> +MTIOCSENSE returns the sense data from the previous "interesting" SCSI command
> +	resulting in CHECK CONDITION. Sense data is not saved from a command
> +	if is used only for supporting the implementation of the tape

	if is used ??  Confusing.  Maybe "if it is used".

> +	semantics and the sense data from that command would overwrite the
> +	sense data from the error interesting to the user. For instance, error
> +	from backspacing over a block by st after a read error does not
> +	overwrite the sense data from the read. The field 'latest' tells if
> +	the sense data is from the previous SCSI command sent to the device
> +	(all SCSI commands are counted). The cmd field is the command byte
> +	from the SCSI command resulting in the sense data.
>  
>  MISCELLANEOUS COMPILE OPTIONS
>  

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
