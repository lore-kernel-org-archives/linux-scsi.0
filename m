From: Mark Haverkamp <markh@osdl.org>
Subject: Re: aic94xx panic on module load
Date: Tue, 28 Nov 2006 10:51:12 -0800
Message-ID: <1164739872.21827.21.camel@markh3.pdx.osdl.net>
References: <1164734233.21827.8.camel@markh3.pdx.osdl.net>
	 <456C83A2.8020507@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54233 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1758759AbWK1Sym (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Nov 2006 13:54:42 -0500
In-Reply-To: <456C83A2.8020507@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>, djwong@us.ibm.com

On Tue, 2006-11-28 at 13:44 -0500, Douglas Gilbert wrote:
> Mark Haverkamp wrote:
> > I got this panic when loading the aic94xx module.  The adapter is
> > connected to an HP MSA50 SAS enclosure with 3 72GB SAS disks.
> > 
> > Kernel 2.6.19-rc6-scsi-misc on an x86_64

[ ... ]

> So this is an interesting expander setup within the enclosure.
> There are two expanders (500508b300a27a2f + 500508b300a27a3f)
> interconnected via a two wide link (0,1 <-> 10,11 (T-S)) with
> a four wide link back to the 94xx HBA (4,5,6,7 <-> 0,1,2,3).
> My guess is that 500508b300a27a2f:12 is virtual and contains a
> SES target. That leaves SAS disks on 500508b300a27a3f:0,
> 500508b300a27a3f,2 and 500508b300a27a3f,4
> 
> The pain starts immediately after the sas transport layer
> tries to process those expander SMP DISCOVER responses.
> The trace seems to suggest the device at 500508b300a27a2f:12
> is SATA: extremely unlikely.
> 
> Mark, do you have a LSI MPT Fusion SAS HBA handy? If
> so you might connect the enclosure to it, get smp_utils
> and do something like:
>  # modprobe mptctl
>  # smp_discover -p 12 -s 0x500508b300a27a2f /dev/mptctl
> 
> and post the output.

I do have one on another machine.  I'll get it installed in this machine
and give it a try.  We do have LSI cards connected to these kinds of
enclosures and disks and they seem to be working OK.

Mark.

> 
> BTW Darrick, SATA disks connected to an expander usually
> get SAS addresses like <expander_sas_address + n> where
> "n" is small. The device attached to 500508b300a27a2f:12
> is in that region: 500508b300a27a2c
> 
> Doug Gilbert
> 
> 
-- 
Mark Haverkamp <markh@osdl.org>

