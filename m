From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Use a more selective error recovery strategy based on device capabilities
Date: Wed, 13 Feb 2013 20:43:03 -0600
Message-ID: <12DB2383-B7CE-4DD4-BBAA-D6701271A6E6@cs.wisc.edu>
References: <511A87CA.5010901@tributary.com> <511B8FBF.9000705@suse.de> <511BB545.7060600@tributary.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55259 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab3BNCn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2013 21:43:56 -0500
In-Reply-To: <511BB545.7060600@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Scsi <linux-scsi@vger.kernel.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>


On Feb 13, 2013, at 9:46 AM, Jeremy Linton <jlinton@tributary.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 2/13/2013 7:06 AM, Hannes Reinecke wrote:
> 
>> But unfortunately it failed the reality check; of my zoo of storage arrays
>> only NetApp OnTap 8.X and HP P2000 supports the REPORT SUPPORTED TASK
>> MANAGEMENT FUNCTIONS command. None of the others (HP EVA, NetApp E-Series,
>> EMC Clariion CX-3) do.
> 
> 	I'm not really surprised. I've had better luck with devices that report
> compliance with more recent versions of the specification. Of the those, I
> would guess slightly more than 50% support it. That includes tape drives,
> changer devices, and raid controllers. Of the ones I've tested that support
> it, they almost always report 0xDA for the first byte. Which correspond to
> abort task, abort task set, clear task set, lun reset and target reset.
> 


For the case where report supported TMFs is not supported can we just have the LLD return some new return code from the eh callback when it gets FUNCTION_REJECTED. scsi-ml would then clear the eh_*_ok bit, so at least it would not be called again.