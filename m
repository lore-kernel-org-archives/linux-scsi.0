From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: Removing the qlogicfc driver
Date: Sat, 17 Jan 2004 12:21:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040117202107.GA8301@praka.local.home>
References: <B179AE41C1147041AA1121F44614F0B0598E38@AVEXCH02.qlogic.org> <200401171357.54813.christophe.varoqui@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:40629 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266112AbUAQUcg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 15:32:36 -0500
Received: from praka.san.rr.com (66-75-130-8.san.rr.com [66.75.130.8])
	by ms-smtp-03-eri0.socal.rr.com (8.12.10/8.12.7) with ESMTP id i0HKWYF3015435
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2004 12:32:34 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <200401171357.54813.christophe.varoqui@free.fr>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sat, 17 Jan 2004, christophe.varoqui wrote:
> On Friday 16 January 2004 23:57, Andrew Vasquez wrote:
> 
> > Hmm, from the output of proc/scsi/qla* your two 2200 don't appear to
> > be recognizing any devices after the SNS scan:
> > Could you enable enable a couple of debug swtiches:
> > Andrew Vasquez
> 
> Yes, here it is :
> 
[snip]
> scsi(4): Asynchronous PORT UPDATE.
> scsi(4): Port database changed 0000 4000.
> scsi(4): F/W Ready - OK
> scsi(4): fw_state=3 curr time=4926cc4.

Firmware appears to be ready.

> qla2200 0000:03:01.0: Topology - (F_Port), Host Loop address 0xffff

F_PORT connection to the switch, we should have a PortID.

> scsi(4): Configure loop -- dpc flags =0x80040
> scsi(4): RSCN queue entry[0] = [00/000000].
> scsi(4): device_resync: rscn overflow.
> qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=0, mbx2=3c, cmd=54 
> ****
> qla2x00_issue_iocb(4): failed rval 0x102qla2x00_issue_iocb(4): failed rval 
> 0x102scsi(4): RFT_ID issue IOCB failed (258).
[snip]
> qla2x00_issue_iocb(4): failed rval 0x102qla2x00_issue_iocb(4): failed rval 
> 0x102scsi(4): GA_NXT issue IOCB failed (258).
> scsi(4): Configure fabric error exit: rval=258
>

Yet it seems all of our SNS commands are failing to be executed with a
4005 (command error).  Interesting, I'll need to talk with the
firmware folks on Monday.  

In the interim, after the 8.x series driver is loaded, could you use
the switch software to take a look at the name-server's list of
recognized devices.  I'm interested to know the information (port_id,
nn, pn, etc) it has related to the ports of the 2200s (from a previous
email, 210000e08b03896a).

Regards,
Andrew Vasquez
