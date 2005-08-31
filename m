From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Possible bug in qla2xxx rev. 8.00.02
Date: Wed, 31 Aug 2005 15:08:50 -0700
Message-ID: <20050831220850.GH11577@plap.qlogic.org>
References: <47F3C2BE74738E4683574107469DFA203B97D8@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:31639 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S964873AbVHaWJA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 18:09:00 -0400
Content-Disposition: inline
In-Reply-To: <47F3C2BE74738E4683574107469DFA203B97D8@XYUSEX01.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank Borich <Frank_Borich@us.xyratex.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 29 Aug 2005, Frank Borich wrote:

> I have a controller with a firmware bug that mishandles 
> underrun situations for inquiry commands. It correctly
> sets the FCP_RESID_UNDER flag however it miscalculates
> the FCP_RESID count.  The 7.05.00 Qlogic driver for 2.4.x
> kernels thinks frame(s) were lost and retries the command
> 20 times with no success:
> 
> 
>  if (!(scsi_status & SS_RESIDUAL_UNDER)) {
>                                         ha->dropped_frame_error_cnt++;
>                                         CMD_RESULT(cp) = DID_BUS_BUSY <<
> 16;
>                                         DEBUG2(printk(KERN_INFO
> "scsi(%ld): Dropped "
>                                                 "frame(s) detected (%x
> of %x "
>                                                 "bytes)...retrying
> command.\n",
>                                                 ha->host_no,
>                                                 resid,
>                                                 CMD_XFRLEN(cp));)
>                                         break;
>                                 }
> 

Interesting, could you submit a support a problem report here:

	http://connection.qlogic.com/support/report/index.asp?id=csg

this will insure, this gets routed through the proper channels.

7.05.00 uses an older 23xx firmware.

Might be best if we had a FC trace as well, I'm sure the FW folks will
be interested to see what's comming back on the wire.

> Just wondering why the 8.00.02 driver for 2.6.x kernels did not
> detect this transport error ?
>

Did you enable the proper debug settings for this driver?  This driver
has the dropped-frame check as well...

IAC:  route this through tech-support.

> Latest Emulex and LSI drivers did
> not detect this either ???
> 

--
av
