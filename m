From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH 1/1] cciss: resubmit export uid, model, vendor, rev to
 sysfs
Date: Fri, 10 Apr 2009 11:19:53 -0600
Message-ID: <1239383993.5183.75.camel@grinch>
References: <20090407180411.GA4324@beardog.cca.cpqcorp.net>
	 <20090409215226.8b03bc2b.akpm@linux-foundation.org>
	 <1239340134.19984.276.camel@grinch>
	 <20090409221722.6439ba11.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:48240 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZDJRUG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2009 13:20:06 -0400
In-Reply-To: <20090409221722.6439ba11.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>, LKML-SCSI <linux-scsi@vger.kernel.org>, mike.miller@hp.com

On Thu, 2009-04-09 at 22:17 -0700, Andrew Morton wrote: 
> On Fri, 10 Apr 2009 05:08:54 +0000 Andrew Patterson <andrew.patterson@hp.com> wrote:
> 
> > > > +	char model[MODEL_LEN + 1];
> > > > ...
> > > > +		return snprintf(buf, MODEL_LEN + 2, "%s\n", drv->model);
> > > 
> > > Isn't the buffer sizing wrong here?  Should be MODEL_LEN+1.
> > > 
> > 
> > Don't we need space for the '\0' and the '\n'?
> 
> The second arg to snprintf() tells snprintf() how large the buffer is. 
> That buffer should be sized to allow room for the trailing \0.
> 
> So if MODEL_LEN represents the maximum number of characters in a string
> then you want:
> 
> 	char model[MODEL_LEN + 2];	/* Room for the \n and the \0 */
> 	...
> 	return snprintf(buf, sizeof(model), "%s\n", drv->model);

Note that I don't want the '\n" in the source string.  I just want it
output to the dest string (buf).  I could do:

  return snprintf(buf, sizeof(model) + 1, "%s\n", drv->model);

if that is preferable.  Perhaps what is confusing is using:

#define MODEL_LEN	16
char model[MODEL_LEN + 1];   /* SCSI model string */

So MODEL_LEN is not accounting for the '\0'.

I am not sure what the convention is here.  It have seen SCSI code that
uses the above, e.g., include/scsi/scsi_transport_sas.h.  But I am happy
to have *_LEN account for the '\0' if that makes it less confusing.

Andrew

