From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 16 Jul 2003 14:06:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058360799.6600.0.camel@dhcp22.swansea.linux.org.uk>
References: <1058310172.981.7.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:16841
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S270545AbTGPMy0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2003 08:54:26 -0400
In-Reply-To: <1058310172.981.7.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Nick Piggin <piggin@cyberone.com.au>, Andrew Morton <akpm@osdl.org>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mer, 2003-07-16 at 00:02, Mark Haverkamp wrote:
> Daniel McNeil and I have been debugging a hang with the aacraid driver
> using the as I/O scheduler.  We found that scsi_request_fn would
> de-queue a request and later re-queued it.  This left the
> as_data->nr_dispatched variable in an inconsistent state (it was never
> being decremented back to zero).  We added a call to
> elv_completed_request to clean up the state before re-adding the
> request.  This has fixed our hang problem.  The linux-scsi list is being
> copied for review of the scsi_lib.c change.

Your aacraid is now terminally obsolete btw, the 2.4 one adds new cards
and fixes some bugs including one or two "under high load it dies" cases

