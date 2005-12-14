From: Michael Reed <mdr@sgi.com>
Subject: Current Issues with 2.6.15-rc5
Date: Wed, 14 Dec 2005 11:58:44 -0600
Message-ID: <43A05D54.5070309@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:56230 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S964773AbVLNSBB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 13:01:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, James.Smart@Emulex.Com
Cc: Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Christoph Hellwig <hch@lst.de>, Michael Reed <mdr@sgi.com>

Hello Everyone,

I'm concerned about the stability of the fibre channel infrastructure
in 2.6.15-rc.  There are current issues which I see effecting our (SGI's)
customers' satisfaction.  I feel that these issues must be addressed
prior to the release of 2.6.15.

1 - fc transport change gets really noisy if targets disappear from
    the fabric due to recursion on the workqueue.  I've seen recursion
    depths > 40 and it's only really limited by the number of targets
    on a fibre channel fabric.  It's unknown (to me) what side effects
    this recursion might have if the number of targets is in the
    hundreds, which is not uncommon for our customers.  James Smart
    is aware of this and is working on a solution.
    See my posting of 12/2/2005 and replies.
    "2.6.15-rc4 error messages with multiple qla2300 hba ports on fabric".

2 - qlogic fibre channel driver no longer properly handles targets coming
    and going.  There is a race condition within the driver which can
    result in targets being deleted yet they are present and accounted for.
    This is a show stopper for SGI's customers.  We have to have reliable
    target [re-]discovery.  Andrew Vasquez is aware of this issue.
    See my posting on 12/5/2005.  "qla2x00 driver serialization issue".

In a private email, Andrew wrote:
> Yes, I was afraid of something like this happening (due to qla2xxx
> detections of ports being dropped from an interrupt context)...  Codes
> in qla_rscn.c already queue-up rport_adds() via the standard
> kernel-workqueue:
> 
> 	qla_init.c:     INIT_WORK(&fcport->rport_add_work, qla2x00_rport_add, fcport);
> 
> 	qla_rscn.c:     schedule_work(&fcport->rport_add_work);
> 
> With the additions though, I'm wondering if adding a special
> single-cpu qla2xxx-rport workqueue would make sense (at least we could
> enforce serialization).


What can be done to assure fc stability in the 2.6.15 release?  It appears
that the revision of the fc-transport from 2.6.14 has caused some
difficulty for a current driver, and potentially the entire system.  Is
it ready for prime time?

Mike Reed
