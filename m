From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] Use a more selective error recovery strategy based on
 device capabilities
Date: Thu, 14 Feb 2013 23:42:57 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402950D58F40@G9W0745.americas.hpqcorp.net>
References: <511A87CA.5010901@tributary.com> <511B8FBF.9000705@suse.de>
 <511BB545.7060600@tributary.com>
 <12DB2383-B7CE-4DD4-BBAA-D6701271A6E6@cs.wisc.edu>
 <511D4FB5.708@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:25615 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935091Ab3BNXoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2013 18:44:55 -0500
In-Reply-To: <511D4FB5.708@tributary.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>, Michael Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, Linux Scsi <linux-scsi@vger.kernel.org>

Each logical unit is independent and is allowed to be different.  

Examples: In a RAID controller, the direct-access block device type logical units (i.e., logical drives) are probably all the same, but storage array controller and enclosure service type logical units might be more limited.  In a tape library, sequential-access device type logical units (i.e., tape drives) might differ from a media changer logical unit.

Although the SCSI transport protocol might currently mandate everything and leave no options, that might change in the next version of the SCSI transport protocol.


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Jeremy Linton
> Sent: Thursday, 14 February, 2013 2:57 PM
> To: Michael Christie
> Cc: Hannes Reinecke; Linux Scsi; Elliott, Robert (Server Storage)
> Subject: Re: [PATCH] Use a more selective error recovery strategy based on
> device capabilities
> 
> On 2/13/2013 8:43 PM, Michael Christie wrote:
> > For the case where report supported TMFs is not supported can we just have
> the LLD return some new return code from the eh callback when it gets
> FUNCTION_REJECTED. scsi-ml would then clear the eh_*_ok bit, so at least it
> would not be called again..
> 
> 
> 	Hmm, that seems like a good idea. The question is, does propagating the
> flag
> change to all the devices on the I_T make sense?
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
