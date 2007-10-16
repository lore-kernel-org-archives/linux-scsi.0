From: Rob Landley <rob@landley.net>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Tue, 16 Oct 2007 18:59:54 -0500
Message-ID: <200710161859.55325.rob@landley.net>
References: <200710112011.22000.rob@landley.net> <200710160138.57893.rob@landley.net> <20071016112859.1b0fba0e@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56981
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965459AbXJQAAF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 20:00:05 -0400
In-Reply-To: <20071016112859.1b0fba0e@the-village.bc.nu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Nick Piggin <nickpiggin@yahoo.com.au>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Tuesday 16 October 2007 5:28:59 am Alan Cox wrote:
> > I'm sure somebody will eventually write an OLS paper or something on the
> > advisability of making swapping decisions with 4k granularity when disks
> > really want bigger I/O transactions.
>
> Funnily enough someone thought of that many years ago. They even added
> and documented it, then they made it adjustable.
>
> See the vm section of Documentation/filesystems/proc.txt

I presume you refer to:

  page-cluster
  ------------

  page-cluster controls the number of pages which are written to swap in
  a single attempt.  The swap I/O size.

  It is a logarithmic value - setting it to zero means "1 page", setting
  it to 1 means "2 pages", setting it to 2 means "4 pages", etc.

  The default value is three (eight pages at a time).  There may be some
  small benefits in tuning this to a different value if your workload is
  swap-intensive.

I didn't know that controlled whether the pages were contiguous (or written to 
contiguous locations in swap).  I thought it was just how many the VM tried 
to free at a time.

Still, worth a tweak.  Thanks.

> Alan

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
