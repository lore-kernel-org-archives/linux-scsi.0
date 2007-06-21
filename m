From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Thu, 21 Jun 2007 13:58:12 -0700
Message-ID: <1182459492.3923.35.camel@mulgrave.il.steeleye.com>
References: <200706191025.30986.swen@vnet.ibm.com>
	 <20070619171217.GA30099@infradead.org>
	 <1182307586.10507.7.camel@mulgrave.il.steeleye.com>
	 <20070621150308.GA29643@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44350 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751902AbXFVBe1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2007 21:34:27 -0400
In-Reply-To: <20070621150308.GA29643@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2007-06-21 at 17:03 +0200, Christof Schmitt wrote:
> Now that everybody is happy with using the FCP LUN in the SCSI
> midlayer, this raises a question from the user's perspective:
> 
> sysfs and lsscsi display the LUN as decimal number. For the FCP LUN
> 0x401040c300000000, sysfs and lsscsi display this:
> 
> $ ls -l /sys/bus/scsi/devices/
> total 0
> lrwxrwxrwx 1 root root 0 Jun 21 16:49 0:0:0:1086537744 ->
> ../../../devices/css0/0.0.0010/0.0.181d/host0/rport-0:0-0/target0:0:0/0:0:0:1086537744
> 
> $ lsscsi
> [0:0:0:1086537744]disk    IBM      2107900          .270  /dev/sda
> 
> Asking a system admin to translate the number to hex (0x40C34010) and
> then swap the pairs to get the real FCP LUN (0x401040c3) is too much.
> 
> Are there any plans to improve this? Showing the LUN in sysfs as hex
> number would be the first step. Or does it make more sense to keep the
> decimal number in sysfs and let tools like lsscsi do the conversion?

A proposal to display the correct form of the LUN would be useful if you
wish to make it? ...  The problem is really that SAM specifies a
possible 4 level structure with 4 possible address methods per level.

The well known LUNs should be simple; there are only three: Report Lun,
Access Controls and Target Log Pages.  The rest we really need input on.
For instance, I could see the vendors wishing us to combine a
multi-level flat addressing space into a single logical unit number,
whereas I could see them wanting us to supply some sort of hierarchy for
the peripheral and logical unit methods of addressing.

Since you're already using 2 level flat addressing, how do you want to
see that represented?

James


