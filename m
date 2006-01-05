From: Andreas Herrmann <AHERRMAN@de.ibm.com>
Subject: Re: [PATCH] fc transport: new attributes for NPIV
Date: Thu, 5 Jan 2006 16:51:47 +0100
Message-ID: <OF3AADDAAC.7D3516AC-ON412570ED.00570F79-412570ED.00572278@de.ibm.com>
References: <43BD285B.9020805@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:40179 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751433AbWAEPwI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jan 2006 10:52:08 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id k05Fprg7042042
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jan 2006 15:51:53 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k05Fpo7M124970
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jan 2006 16:51:50 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k05FpnZi016954
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jan 2006 16:51:50 +0100
In-Reply-To: <43BD285B.9020805@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>

On 05.01.2006 15:08 James Smart <James.Smart@Emulex.Com> wrote:
> Drop the physical_port_id attribute. I'm assuming that each virtual
> port shows up as a unique scsi_host, as the FC ports and SCSI views it
> has is unique to it's FC address (N_Port_ID).  As such, the
> physical_port_id would be redundant with the port_id on the scsi_host
> that corresponds to the physical port. Rather than determine the
> relationship through scsi_host attributes, you would determine the
> relationship via multiple scsi_host children under the pci adapter under
> the device tree.  Obviously, if you don't buy into the scsi_host per
> port_id relationship, things change and we should talk further.

This all sounds sensible and I agree.
Problem is that on the mainframe I don't have access to the primary
port. Virtualization is done in adapter microcode. I just have
access to the virtual port. Hence the primary port does not show up
as a scsi_host. I cannot directly send any commands via the primary
port. I just can get some information about the primary port
(i.e. WWPN/N_Port_ID). This information I like to display in sysfs
for troubleshooting purposes. (E.g. To check whether the primary port
shows up on the switch.)

Seems that requirements for workstations and mainframes are
contrary.

> As for physical_port_name, minimally, this should be changed to
> primary_port_name, per the standards terms. However, as this is
> meaningful only to a FC/NPIV savvy person - it may be better to simply
> have an attribute such as virtual_port=<true/false>. If false, then PPN
> is the port_name. If true, then you would use the same device tree
> relationship pointed out above to find out which of the peers to the
> scsi_host has virtual_port=true, then you have it's port_name, port_id,
> etc...  Yes, it feels like a little more work, but I feel it's a better
> alternative as the spread of object information internally is limited,
> and the external view, which can be easily managed via scripts/tools has
> as much or more information available.

Again, fine with me, but due to the "flat" view of virtual adapters on
Linux on zSeries I see problems to implement this.

Only way to implement an hierarchical view for zfcp is to introduce a
"dummy" scsi_host for the primary port ... Ouch

Have to think about this for a while.


Regards,

Andreas
