From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Why are MegaRAID drivers mutually exclusive?
Date: Wed, 10 Nov 2004 13:42:21 -0600
Message-ID: <20041110194221.GA28524@lists.us.dell.com>
References: <0E3FA95632D6D047BA649F95DAB60E570562C128@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:31101 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S262049AbUKJTmt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 14:42:49 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570562C128@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: 'Chris Adams' <cmadams@hiwaay.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Wed, Nov 10, 2004 at 02:24:06PM -0500, Bagalkote, Sreenivas wrote:
> The new and old drivers are mutually exclusive to the extent that
> both cannot be loaded simultaneously as they both work on same
> hardware. It only seems logical that this exclusivity is represented
> in Kconfig as well.

There are three issues here that need to be addressed.
1) megaraid_mbox doesn't currently handle all of Chris's hardware.
   It's missing some PCI IDs which it should be able to handle.
   101e:1960 101e:0475, aka PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3
			    PCI_DEVICE_ID_AMI, PCI_SUBSYS_ID_PERC3_SC 

2) megaraid_mbox doesn't handle other sets of hardware it should be
   able to handle (Dell PERC2/{SC,DC}).  I am not sure why.

3) no megaraid_ioport driver has ever been produced, which was the
   original reason for splitting megaraid_mm and megaraid_mbox.  This
   driver is necessary for Chris's other older hardware.
   PCI 101e:9010, aka PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_MEGARAID


Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
