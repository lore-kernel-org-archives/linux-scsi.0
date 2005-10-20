From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 09:25:54 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9348 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932138AbVJTP0L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 11:26:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>, "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Wednesday, October 19, 2005 3:00 PM, Luben Tuikov wrote: 

> 
> On 10/19/05 16:08, Moore, Eric Dean wrote:
> > Luben:  He is adding support for linkerrors and link/phy reset;
> > these for for CSMI/SDI API.
> > 
> > Can you in your driver retreive link errors for the links 
> on the expanders?
> 
> Yes. (offloaded to user space)
> 

I had a very good discussion with Luben over the 
phone last night.

Luben clarified this for me in regards to expanders:

http://www.t10.org/drafts.htm#sas2 
The linkerrors can be done by issuing a SMP passthru
sending SMP_REPORT_ERROR_LOG. Section 10.4.3.6

The link/phy reset can be done by issuing a SMP passthru
sending SMP_PHY_CONTROL. Section 10.4.3.10

The mpt fusion f/w supports smp passthru, and we could for
these attributes do SMP passthru if we wanted to return
this data for expanders.  Our f/w only provides a easy special 
wrapper config page for hba phys. For expanders, we
are going to have to do smp passthru.

So Christoph what should we do in driver?  Ignore returning
data for expanders?  

Luben suggestion(correct me if I'm wrong) is this should be 
done thru user space, instead of exporting this in the 
/sys/class/sas_phy attributes.  Thus we need to export a 
SMP_PASSTHRU mechanism.  I believe there is discussion
by Christoph ( and I believe Luben backs this idea) of doing 
all this thru the /dev/sg interface.


> 
> > What and where can I get this?
> 
> http://linux.adaptec.com/sas/
> Also see my sig.

Thanks. I will check it out.

Eric Moore
