From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/3] sd: implement START/STOP management
Date: Tue, 20 Mar 2007 13:41:27 -0500
Message-ID: <1174416087.3522.28.camel@mulgrave.il.steeleye.com>
References: <20070320150718.GF6152@htj.dyndns.org>
	 <20070320151359.GG6152@htj.dyndns.org>  <460020DF.6090203@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:48650 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965618AbXCTSlf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 14:41:35 -0400
In-Reply-To: <460020DF.6090203@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, djwong@us.ibm.com, hmh@hmh.eng.br

On Tue, 2007-03-20 at 13:58 -0400, Douglas Gilbert wrote:
> I note at this point that the IMMED bit in the
> START STOP UNIT cdb is clear. [The code might
> note that as well.] All SCSI disks that I have
> seen, implement the IMMED bit and according to
> the SAT standard, so should SAT layers like the
> one in libata.
> 
> With the IMMED bit clear:
>   - on spin up, it will wait until disk is ready.
>     Okay unless there are a lot of disks, in
>     which case we could ask Matthew Wilcox for help
>   - on spin down, will wait until media is
>     stopped. That could be 20 seconds, and if there
>     were multiple disks ....
> 
> I guess the question is do we need to wait until a
> disk is spun down before dropping power to it
> and suspending.

Realistically, if you're thinking of doing a bank spin up / spin down
with IMMED=1 I suspect we can wait and see if anyone has sufficient need
for it to be implemented before trying.  The majority of the
suspend/resume cases are laptops with a single disc ... and there immed
is irrelevant to them.

I think we need assurance that the head is parked before full suspend,
yes, so IMMED=0 seems the easiest way to do this.

James


