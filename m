From: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Subject: RE: [PATCH][RFC] iSCSI transport class
Date: Tue, 6 Apr 2004 10:36:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF0337E1AA.5DF92CB1-ONC1256E6E.001E7BD2-C1256E6E.002F650D@de.ibm.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAA9J1WRvNm9EOzhZvg3SDlSwEAAAAA@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:49121 "EHLO
	mtagate1.uk.ibm.com") by vger.kernel.org with ESMTP id S263665AbUDFIvR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 04:51:17 -0400
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAA9J1WRvNm9EOzhZvg3SDlSwEAAAAA@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: linux-iscsi-devel@lists.sourceforge.net, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, 'Mike Christie' <michaelc@cs.wisc.edu>, Martin Peschke3 <MPESCHKE@de.ibm.com>

Hi,

> > I get your point (you just chose the above attributes based 
> > on name to accentuate this right). However, in your example 
> > it seems like you would want to show the parent-children 
> > relationships like
> > here:
> > 
> > /sys/class/iscsi_transport_host
> > |-- host1
> > |   |-- a_host_attribute
> > |   |-- 1:0:1
> > |   |   |-- target_name
> > |   |   |-- 1:0:1:0
> > |   |   |   |- some_lun_attribute
> > 
> > Or you could also do something like
> > 
> > /sys/class/iscsi_transport_host
> > |-- host1
> > |   |- a_host_attribute
> > |   |- 1:0:1 -> ../iscsi_transport_target/1:0:1
> > |   `- 1:0:2 -> ../iscsi_transport_target/1:0:2
> > /sys/class/iscsi_transport_target
> > |-- 1:0:1
> > |   |- target_name
> > |   |- ../iscsi_transport_lun/1:0:1:0

Looking at all the different transport classes recently
introduced, I don't think this is the way to go. The
sysfs layout for scsi devices gets too complicated in my
opinion.

To give you another example for an ugly sysfs layout,
caused by the lack of a generic solution, here is what
we do within the zfcp lldd:

/sys/devices/css0/0.0.000e/0.0.50dc
|-- <zfcp lldd hba specific attributes>
|-- host0
|   |- <host_attributes>
|   |- 0:0:1:0
|   .  |- <lun attributes>
|   .
|
|-- <wwpn0> (this and stuff below created by zfcp lldd)
|   |-- <fc port attributes>
|   |-- <zfcp lldd specific fc port attributes>
|   |-- <fcp_lun0>
|   .    |-- <fcp lun attributes>
|   .    |-- <zfcp lldd specific fcp lun attributes>
|
|-- <wwpn1>
.   .
.   .

So with using the fc transport class we would end up
with even another place where one has to look for things:

/sys/class/fc_transport/0:0:1:0


Now that there are transport classes available, the fc port
and lun attributes should move there. But we still have quite
a bunch of zfcp lldd specific fc port and lun attributes that
don't fit into any other place. It would be nice to have a
common place for all the different attributes, i.e. lldd
attributes, midlayer attributes and transport attributes.

>From my point of view it would be better to go for a simple
hierarchical structure like this:

/sys/devices/<hba0>
             |-- <host0>
             .   |- <scsi midlayer attributes>
             .   |- <transport attributes>
             .   |- <lldd attributes>
                 |- <bus0>
                 .  |- <scsi midlayer attributes>
                 .  |- <transport attributes>
                 .  |- <lldd attributes>
                    |- <target0>
                    .  |- <scsi midlayer attributes>
                    .  |- <transport attributes>
                    .  |- <lldd attributes>
                       |- <lun0>
                       .  |- <scsi midlayer attributes>
                       .  |- <transport attributes>
                       .  |- <lldd attributes>

In addition I can think of getting rid of hostnumber,
or is it really needed for anything?

Any comments/flames?

Heiko

