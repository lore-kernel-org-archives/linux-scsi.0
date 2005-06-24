From: James.Smart@Emulex.Com
Subject: RE: [Fwd] further testing w/ multipath ... and bugs
Date: Fri, 24 Jun 2005 10:14:38 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC95@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52906 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S263073AbVFXOQp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2005 10:16:45 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andmike@us.ibm.com, christophe.varoqui@free.fr, andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org

> I did not see an answer to this issue. I am also hitting the problem
> (i.e., devices being removed) during some dm-mp port bounce testing.
> Is this the correct behavior going forward for the fc transport?

Current design is when the LLDD tells the transport that the port is
gone, it (and it's subtree) gets deleted.  Right or not ? don't know.
I would assume having the real state, where it does not exist if not
present, is the right overall approach.  Also makes it consistent
with other storage devices that go away when not connected
(usb sticks, etc).

> Also I see a difference in behavior between the lpfc and 
> qla2xxx drivers
> where the lpfc is not removing target even though the 
> "rport-5:0-5: blocked
> FC remote port time out: removing target" message is printed. 
> I guess I
> can look into the difference myself, but I thought Andrew or 
> James S you
> two would know.

I'll have to look into things. Likely this is a reference count issue,
and may be a reference count on a sdev. I doubt lpfc does anything relative
to this scenario, but I'll check. The drivers could also differ on the
return codes returned when the rport is in this transition state, which
may affect the sdev/block device and references.

Keep in mind there are issues in .12 if the target is torn down.
There was some recent patches to correct this.
http://marc.theaimsgroup.com/?l=linux-scsi&m=111845669410785&w=2

-- james s 
