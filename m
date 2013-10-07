From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: xcopy testing with ddpt
Date: Mon, 07 Oct 2013 15:18:44 -0700
Message-ID: <1381184324.19256.311.camel@haakon3.risingtidesystems.com>
References: <20131003160033.GC5273@glanzmann.de>
	 <524DA6EC.6000900@interlog.com> <20131005182206.GA9781@glanzmann.de>
	 <5250E0D6.8000404@interlog.com> <20131006090005.GB12340@glanzmann.de>
	 <52519FA8.9050905@interlog.com> <20131006184355.GC27090@glanzmann.de>
	 <5251D179.8020405@interlog.com> <20131006213213.GA30637@glanzmann.de>
	 <5251EAF3.8090500@interlog.com> <20131007040328.GA1439@glanzmann.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55361 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3JGWKT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Oct 2013 18:10:19 -0400
In-Reply-To: <20131007040328.GA1439@glanzmann.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Douglas Gilbert <dgilbert@interlog.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <mail@hannes-reinecke.de>

On Mon, 2013-10-07 at 06:03 +0200, Thomas Glanzmann wrote:
> Hello Doug,
> 
> * Douglas Gilbert <dgilbert@interlog.com> [2013-10-07 00:58]:
> > Great, another one working.

(CC'ing Hannes)

> > BTW list_id=0 has a special meaning in some context
> > (buried deep in T10 documents: spc4r36j.pdf). That is
> > probably why Hannes Reinecke defaulted that list_id to
> > 1. I could understand the target XCOPY implementation
> > only accepting one xcopy sequence at a time, but why
> > restrict it to list_id=0 ? A question for NaB ...
> 
> Nab, do you have any input for us?
> 

It was my original understanding that when OPERATING_PARAMETERS is
reporting SNLID=1 (Supports No ListID), the initiator is expected to
send EXTENDED_COPY parameter lists with ListID Usage 11b + ListID=0.
Since we're ignoring the value of ListID for now anyways, I agree that
it doesn't make much sense to fail for a non zero value here..

However, the main concern that made me add this check to begin with was
the case with ListID Usage 00b + 10b, where the copy server is expected
to keep a per I_T list of in-use ListIDs, and return CHECK_CONDITION +
ILLEGAL REQUEST/OPERATION IN PROGRESS for a ListID for a copy sequence
already in progress.

Given that don't have this per I_T list that tracks ListIDs yet, it
seemed wrong at the time to allow non zero ListIDs to be processed..  ;)

Also, it's worth mentioning that the target XCOPY implementation does in
fact support multiple copy sequences per device at a time, and there is
currently no hard limit enforced for the number of copies, aside from
the normal fabric dependent NodeACL queue_depth, et al.  OPERATING
PARAMETERS is currently reporting 1 for TOTAL CONCURRENT COPIES and
MAXIMUM CONCURRENT COPIES, and I'll likely be adding a device attribute
to control this depth, and enforce it's usage for v3.13 code.

--nab

