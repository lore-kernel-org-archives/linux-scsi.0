From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Fri, 21 Oct 2005 11:50:54 +1000
Message-ID: <4358497E.6070107@torque.net>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:14827 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S964822AbVJUBuB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 21:50:01 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

Moore, Eric Dean wrote:
> On Wednesday, October 19, 2005 3:00 PM, Luben Tuikov wrote: 
> 
> 
>>On 10/19/05 16:08, Moore, Eric Dean wrote:

<snip>

> Luben suggestion(correct me if I'm wrong) is this should be 
> done thru user space, instead of exporting this in the 
> /sys/class/sas_phy attributes.  Thus we need to export a 
> SMP_PASSTHRU mechanism.  I believe there is discussion
> by Christoph ( and I believe Luben backs this idea) of doing 
> all this thru the /dev/sg interface.

Folks,
Just a suggestion if you want to bring /dev/sg into
the picture for a SMP (and even a STP) passthrough.
The host could define a lun (pick a number) and the
LLDD could supply the target code for it (as scsi_debug
does for example).

Details need to be sorted out (e.g. pdt of "host" lun)
and a way to pass an 8 byte SAS address through a
SCSI cdb (there are lots of vendor specific SCSI
opcodes available). For a STP pass through, we
have the SAT ATA PASS THROUGH SCSI commands already
defined (although they don't allow for an 8
byte target (SAS) address).

SG_IO code paths through the SCSI subsystem are pretty
well tested and are available in all lk 2.4 and 2.6
kernels. All OSes that I am aware of have some sort
of SCSI pass through mechanism so this approach bypasses
the objection to adding new ioctls (from both Microsoft
and Linux).

The idea is not original. Windows 2000 has a lun for
just this purpose (and it was dropped in Windows 2003).

Doug Gilbert
