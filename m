From: "Scott M. Ferris" <sferris@acm.org>
Subject: Re: [iscsi 2/2] iscsi-probe.c
Date: Wed, 24 Sep 2003 13:26:47 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030924182647.835015DC69@bambi.visi.com>
References: <018b01c382b7$b7f81220$8f074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from corb.mc.mpls.visi.com ([208.42.156.1]:44525 "EHLO
	corb.mc.mpls.visi.com") by vger.kernel.org with ESMTP
	id S261598AbTIXS0t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 14:26:49 -0400
In-Reply-To: <018b01c382b7$b7f81220$8f074d0a@apac.cisco.com> from "Sachin Mhatre
 (smhatre)" at "Sep 24, 2003 09:50:02 pm"
List-Id: linux-scsi@vger.kernel.org
To: smhatre@cisco.com
Cc: 'Christoph Hellwig' <hch@infradead.org>, 'Jeff Garzik' <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

Sachin Mhatre (smhatre) wrote:
> Hi,
> 
> 1. We are using the following options in the indent command for handling
> the 80 character limit:-
> indent -kr -i8 -ts8 -sob -l80 -ss -bs -psl <filename>.c
> However, this does not handle the log messages in double quotes. We will
> manually take care of such messages.
> 2. The opening of files from kernel space is important for the iscsi
> probing mechanism.
> We read/write into the "/proc/scsi/scsi" file for
> configuration/deconfiguration of iSCSI devices.
> 3. typedefs in our code will be removed. Kernel functions will be used
> wherever available.
> We will update you once the above mentioned changes are done.

If this iSCSI driver is going into a mainline 2.6 kernel,
iscsi-probe.c should cease to exist, among numerous other cleanups.

The probing code in linux-iscsi tries to accomplish two things:

1) Deal with the lack of a stable device naming scheme for dynamically
added SCSI devices on 2.2 and 2.4 kernels (since devfs was hardly ever
used).  Now that 2.6 has sysfs and hotplugging, those mechanisms
should be used, and if need be altered to work better with iSCSI.

2) Get all LUNs scanned properly.  The SCSI midlayer in 2.2 and (at
least older) 2.4 kernels didn't use REPORT_LUNS at all, and the kernel
still doesn't use REPORT_LUNS unless the INQUIRY data indicates
SCSI-3.  This results in the kernel not scanning for all of the LUNs
available through a variety of iSCSI<->FC and iSCSI<->SPI gateway
devices, especially gateways that virtualize targets and do LUN
mapping.

It could be argued that the gateways are broken for not adjusting the
INQUIRY data to indicate SCSI-3.  It could also be argued that a
gateway changing the SCSI level in the INQUIRY data would falsely
indicate that the end device supports commands that it can't actually
handle.  One solution is to add a mechanism for the low-level driver
to tell the SCSI midlayer that it should use REPORT_LUNs
unconditionally when scanning, regardless of the end device's SCSI
level.  Any gateway reached via a SCSI-3 transport protocol ought to
either respond to REPORT_LUNs or return the appropriate check
condition.

-- 
Scott M. Ferris,
sferris@acm.org 
