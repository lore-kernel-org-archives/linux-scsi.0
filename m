From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Patch: change the serial_number for error-handler commands
Date: Wed, 21 May 2003 16:15:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030521161544.A24646@beaverton.ibm.com>
References: <3ECA9D46.7010301@rogers.com> <Pine.LNX.4.44L0.0305202110520.4914-100000@netrider.rowland.org> <20030521180308.GD1116@beaverton.ibm.com> <3ECBD122.3090702@rogers.com> <20030521202809.GA1791@beaverton.ibm.com> <3ECBEB8D.4030008@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:35208 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262319AbTEUXGe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2003 19:06:34 -0400
Content-Disposition: inline
In-Reply-To: <3ECBEB8D.4030008@rogers.com>; from tluben@rogers.com on Wed, May 21, 2003 at 05:11:41PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

On Wed, May 21, 2003 at 05:11:41PM -0400, Luben Tuikov wrote:

> Mike Anderson wrote:

> > 
> > Why compare with MAX_SN and not just let the value role over and check
> > for false. 
> 
> First, zero is reserved, and I was trying to keep the _next_ sn in
> the ``session'' cmdsn variable, but there's a little _bug_ up there too,
> so here's a corrected version:
> 
> static inline unsigned long scsi_get_cmdsn(struct Scsi_Host *shost)
> {
> 	static const typeof(shost->serial_number) MAX_SN =
> 		~((typeof(shost->serial_number) 0);
> 	return  shost->serial_number == MAX_SN ?
> 		(shost->serial_number += 2)++  :
> 		shost->serial_number++;

My less than $.02:

As far as the code goes, it does not matter whether we store the current
or next value in shost->serial_number, so we ought to use the simpler code
(Mike's version).  And (x += 2)++ won't compile.

Per naming: "get" is already overloaded and implies a put. We have code
like scsi_get_cmd that allocates and returns a pointer/value, and then
various scsi and other kernel get/put functions that take a pointer and
increment or decrement ref counters. cmdsn is a rather cryptic
abbreviation that my brain can't easily parse.

I suggest scsi_serial_number(host) or scsi_cmdsn(host).

-- Patrick Mansfield
