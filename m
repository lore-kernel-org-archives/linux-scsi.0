From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: No LUNs detected with 2.6.1-mm4 qla2xxx / qla2300
Date: Sun, 18 Jan 2004 21:27:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119052701.GA16779@praka.local.home>
References: <20040118232525.59450.qmail@web10412.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:14992 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S264363AbUASFjV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 00:39:21 -0500
Content-Disposition: inline
In-Reply-To: <20040118232525.59450.qmail@web10412.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: mwshaffer@yahoo.com
Cc: linux-scsi@vger.kernel.org

On Sun, 18 Jan 2004, Michael W. Shaffer wrote:

[snip]
> I just compiled kernel 2.6.1-mm4, which includes
> this merged version of the QLogic drivers called
> qla2xxx. I built the qla2300 driver as a module,
> and when I load it, the HBAs are detected just
> fine, and I see their port and node IDs, but no
> LUNs are detected, and no SCSI devices registered.
> 

>From the logs it appears the firmware recognized no SCSI devices
during its scan (the firmware handles device discovery in a loop).

> SCSI Device Information:
> scsi-qla0-adapter-node=200000e08b0e7851;
> scsi-qla0-adapter-port=210000e08b0e7851;
> 

Could you do two things for me:

1) Could you enable enable a couple of debug swtiches:

  In qla_settings.h update the following line:

        #define DEBUG_QLA2100           0       /* For Debug of qla2x00 */

  to read as:

        #define DEBUG_QLA2100           1       /* For Debug of qla2x00 */

  Then update qla_dbg.h or qla_def.h (depending on the driver version
  you are using) to have the following line:

        /* #define QL_DEBUG_LEVEL_2  */ /* Output error msgs to COM1 */

  to read as:

         #define QL_DEBUG_LEVEL_2   /* Output error msgs to COM1 */

  Rebuild the driver, reload, then forward the /var/log/messages file to
  me so that we can take a look at the information that is coming back
  from the firmware?

2) At the qla2xxx SF.net site, where is a patch that syncs the mm
tree with the latest full driver (8.00.00b9).  Could you apply the
patch, enable debug as before then rerun your test?


	http://prdownloads.sourceforge.net/linux-qla2xxx/qla2xxx-resync_bk-v8.00.00b9.diff.bz2


Regards,
Andrew Vasquez
