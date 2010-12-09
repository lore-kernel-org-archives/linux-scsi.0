From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Is it possible to issue device reset to PMC PM8388 expander
 using sg3_utils or smp_utils?
Date: Thu, 09 Dec 2010 12:59:52 -0600
Message-ID: <1291921192.3002.339.camel@mulgrave.site>
References: <4D0122BC.8060501@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598Ab0LIS76 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2010 13:59:58 -0500
In-Reply-To: <4D0122BC.8060501@aeoncomputing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2010-12-09 at 10:41 -0800, Jeff Johnson wrote:
> Greetings,
> 
> Is it possible to issue a low level device reset to a PMC-Sierra PM8388 
> 24x3G SAS expander using either sg3_utils or smp_utils?
> 
> I am able to enumerate and read the status of the phys on the PM8388, 
> read end device information, etc. I tried sg_reset and it does a bus 
> reset but not an expander reset.
> 
> Technical documentation on the PM8388 is not readily available so I do 
> not know if it has a mode select bit or other special method to get the 
> expander to reset itself.
> 
> I am looking for an inband method to reset the expander to clear a 
> condition where some phys in a wide connection fail to link. A power 
> cycle clears the condition and I am looking to mimic a power cycle by 
> bouncing the expander at the lowest level possible via the SAS host 
> connection.

There's no protocol defined way to reset an expander using SMP
functions, so it's not really possible to do it in-band.  It's sort of
like asking if there's an ethernet packet you can send to a switch to
cause it to reset.

If the wide port isn't forming, you could try doing a hard reset of all
the phys in the port.

James


