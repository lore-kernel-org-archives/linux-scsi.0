From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH][RFC] scsi: Use W_LUN for scanning
Date: Sun, 7 Apr 2013 17:37:20 +0000
Message-ID: <1365356239.1992.33.camel@dabdike>
References: <1363340771-46925-1-git-send-email-hare@suse.de>
	   <1365239280.2787.11.camel@dabdike> <51617547.7040201@suse.de>
	  <1365346182.1992.6.camel@dabdike> <516197D2.20102@interlog.com>
	 <1365351330.1992.25.camel@dabdike> <51619FFF.6070009@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:37490 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170Ab3DGRhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Apr 2013 13:37:24 -0400
In-Reply-To: <51619FFF.6070009@interlog.com>
Content-Language: en-US
Content-ID: <691101F381651C48892386A3336E49F3@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, George Martin <marting@netapp.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>

On Sun, 2013-04-07 at 12:34 -0400, Douglas Gilbert wrote:
> On 13-04-07 12:15 PM, James Bottomley wrote:
> >> No specs apply that I can see.
> >
> > SPC-3 Section 8.3 "Access Controls"
> 
> spc4r36f.pdf section 8.3.1.2 [Overview]
> 
> "Access controls are handled in the SCSI target device by
> an access controls coordinator located at the ACCESS CONTROLS
> well known logical unit. The access controls coordinator also
> may be accessible via LUN 0. The access controls coordinator
> associates a specific LUN to a specific logical unit depending
> on which initiator port accesses the SCSI target device and
> whether the initiator port has access rights to the
> logical unit."
> 
> That seems to strengthen the argument for going the W_LUN route.

The W-LUN route is only viable if we can find a way of making it work
for everything (and that includes USB).

The spec also says in 8.3.1.7 [Verifying access rights]

"If an INQUIRY command is addressed to a LUN for which there is no
matching LUN value in any LUACD in any ACE allowing the initiator port
logical unit access rights, the standard INQUIRY data (see 6.4.2)
PERIPHERAL DEVICE TYPE field shall be set to 1Fh and the PERIPHERAL
QUALIFIER field shall be set to 011b (i.e., the device server is not
capable of supporting a device at this logical unit)."

That means our current LUN0 probe should work just fine.

James

