From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: Weird SCSI error, can anyone interpret?
Date: Thu, 4 Mar 2004 22:07:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040305060748.GC9315@praka.local.home>
References: <4046AB54.9010909@backtobasicsmgmt.com>
Reply-To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:51374 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261877AbUCEG2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2004 01:28:35 -0500
Content-Disposition: inline
In-Reply-To: <4046AB54.9010909@backtobasicsmgmt.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kpfleming@backtobasicsmgmt.com, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Wed, 03 Mar 2004, Kevin P. Fleming wrote:
> I've got a client with a server running 2.6.3-rc2, using a QLogic 
> ISP2100 connected to a CMD FC-to-SCSI RAID controller. On Saturday 
> morning, the system lost access to the RAID array, with thousands of 
> messages like these in the log:
> 
> Feb 28 03:15:46 alpha kernel: SCSI error : <2 0 0 0> return code = 0x20000
> Feb 28 03:15:46 alpha kernel: end_request: I/O error, dev sdc, sector 
> 278362544

Before the deluge of I/O error messages, does the messages file
contain any useful bits of information, i.e. the driver posting
messages about link failures, devices going away, etc.  

> Restarting the Linux system did not help; 
>

Did the driver not recognize the RAID box on the loop?

> power cycling the RAID array did help.

Now that's interesting...

> I'd like to get some clue as to whether this points to a 
> problem with the RAID controller, the FC host adapter, or the kernel's 
> QLogic driver.
>

Well given the information that was presented, I'd say it seems rather
suspicious that the RAID- box needed a power-cycle to be restored into
functioning state.  What type of I/O patterns were being run to the
RAID box?  How many concurrent commands were being queued?

Could you enable some additional debug in the driver and rerun your
test?   Set DEBUG_QLA2100 to 1 in qla_settings.h and define
QL_DEBUG_LEVEL_2 in qla_dbg.h.  Recompile the driver, then run your
test.  If a failure occurs, send me the resultant /var/log/messages
file and the output of the following command:

	# cat /proc/scsi/qla2xxx/* 

This should provide some clues as to what's occuring on the loop.

Regards,
Andrew Vasquez
QLogic Corporation
