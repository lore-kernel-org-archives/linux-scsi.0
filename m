From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] cciss: resubmit export uid, model, vendor, rev to
 sysfs
Date: Thu, 9 Apr 2009 22:17:22 -0700
Message-ID: <20090409221722.6439ba11.akpm@linux-foundation.org>
References: <20090407180411.GA4324@beardog.cca.cpqcorp.net>
	<20090409215226.8b03bc2b.akpm@linux-foundation.org>
	<1239340134.19984.276.camel@grinch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030AbZDJFV1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Apr 2009 01:21:27 -0400
In-Reply-To: <1239340134.19984.276.camel@grinch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>, LKML-SCSI <linux-scsi@vger.kernel.org>, mike.miller@hp.com

On Fri, 10 Apr 2009 05:08:54 +0000 Andrew Patterson <andrew.patterson@hp.com> wrote:

> > > +	char model[MODEL_LEN + 1];
> > > ...
> > > +		return snprintf(buf, MODEL_LEN + 2, "%s\n", drv->model);
> > 
> > Isn't the buffer sizing wrong here?  Should be MODEL_LEN+1.
> > 
> 
> Don't we need space for the '\0' and the '\n'?

The second arg to snprintf() tells snprintf() how large the buffer is. 
That buffer should be sized to allow room for the trailing \0.

So if MODEL_LEN represents the maximum number of characters in a string
then you want:

	char model[MODEL_LEN + 2];	/* Room for the \n and the \0 */
	...
	return snprintf(buf, sizeof(model), "%s\n", drv->model);
