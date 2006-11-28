From: Mark Haverkamp <markh@osdl.org>
Subject: Re: aic94xx panic on module load
Date: Tue, 28 Nov 2006 13:46:19 -0800
Message-ID: <1164750379.21827.26.camel@markh3.pdx.osdl.net>
References: <1164734233.21827.8.camel@markh3.pdx.osdl.net>
	 <456C83A2.8020507@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:64931 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1757100AbWK1Vxt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Nov 2006 16:53:49 -0500
In-Reply-To: <456C83A2.8020507@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>, djwong@us.ibm.com

On Tue, 2006-11-28 at 13:44 -0500, Douglas Gilbert wrote:

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

I'm not sure how to interpret this, but it looks like something didn't
work right.  

After the modprobe I see this:

Nov 28 13:42:28 odt2-003 kernel: Fusion MPT misc device (ioctl) driver 3.04.02
Nov 28 13:42:28 odt2-003 kernel: mptctl: Registered with Fusion MPT base driver
Nov 28 13:42:28 odt2-003 kernel: mptctl: /dev/mptctl @ (major,minor=10,220)


Then running the smp_discover command: 
# ./smp_discover -p 12 -s 0x500508b300a27a2f /dev/mptctl
smp_send_req failed, res=-1

gets this in the log:
Nov 28 13:43:17 odt2-003 kernel: mptbase: ioc0: IOCStatus(0x0001): Invalid Function


> 
-- 
Mark Haverkamp <markh@osdl.org>

