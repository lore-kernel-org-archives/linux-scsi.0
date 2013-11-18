From: James Bottomley <jbottomley@parallels.com>
Subject: Re: Question on SCSI target scan
Date: Mon, 18 Nov 2013 15:28:02 +0000
Message-ID: <1384788482.2001.16.camel@dabdike.int.hansenpartnership.com>
References: <5645D6F831469342AF2BC26CC827D68C5940032A27@BRM-EXCH-3.corp.brocade.com>
	 <94D0CD8314A33A4D9D801C0FE68B4029547B9343@G9W0745.americas.hpqcorp.net>
	 <5645D6F831469342AF2BC26CC827D68C5940B2D7C5@BRM-EXCH-3.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:59253 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3KRP2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2013 10:28:05 -0500
In-Reply-To: <5645D6F831469342AF2BC26CC827D68C5940B2D7C5@BRM-EXCH-3.corp.brocade.com>
Content-Language: en-US
Content-ID: <5E0CB739A31C514A8F9DDCD6F3A07A22@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramesh Chikkanayakanahally <rcnagara@Brocade.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2013-11-18 at 00:52 -0700, Ramesh Chikkanayakanahally wrote:
> Thanks for the response. 
> 
> If using RSCN sounds like a reasonable approach in this scenario
> (protocol limitations),  then as per the original question  - would it
> be acceptable to add an interface in scsi_transport_fc layer, which
> can be invoked on receiving RSCN to trigger SCSI target re-scan
> (REPORT LUNS) ?

No, but what you want to do is send a TEST UNIT READY to one of the
target LUNs ... you can trigger that from the FC transport class, I
think.  That should return a CHECK CONDITION/UNIT ATTENTION which will
trigger the collection of sense and the new uevent mechanism for doing a
rescan.  This hooks it into the standard AEN UNIT ATTENTION handling
rather than having this all done per-transport.  The only per-transport
thing we need is to trigger collection of the UA on the transport
specific AEN.

James

