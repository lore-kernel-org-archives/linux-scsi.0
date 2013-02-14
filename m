From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Thu, 14 Feb 2013 03:37:09 +0000
Message-ID: <1360813027.2502.7.camel@dabdike>
References: <1360767971-947-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.parallels.com ([199.115.104.20]:49067 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3BNDtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2013 22:49:14 -0500
In-Reply-To: <1360767971-947-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <E336DA2C3908334CB7C5AAF7D7BCF9F8@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Steffen Maier <maier@linux.vnet.ibm.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Krishna Gudipati <kgudipat@brocade.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Abhijeet Joglekar <abjoglek@cisco.com>

On Wed, 2013-02-13 at 16:06 +0100, Hannes Reinecke wrote:
> shost->max_lun is only ever useful when doing a sequential
> scan as we need to limit the number of devices to scan there.
> For report lun scan we should allow _any_ reported LUN number
> as long as the LLDD supports 64 bit LUNs.
> 
> So add a new flag 'support_64bit_luns' to the scsi host and
> modify report lun scan to not check for max_luns during
> scanning if that flag is set. This will get rid of the
> annoying 'lunXXXX has a LUN larger than allowed ...'
> message and allow scanning to continue.

What advantage does this have over setting max_lun to ~0?

Plus, if we're going to advertise 64 bit lun support I'd rather have us
be actually capable of it ... luns are handled as 32 bit numbers in the
mid layer currently.

James

