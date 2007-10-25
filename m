From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi/sym53c8xx: Fix a warning in sym_eh_handler
Date: Thu, 25 Oct 2007 05:19:06 -0600
Message-ID: <20071025111905.GK27248@parisc-linux.org>
References: <20071024115920.6728832c@hyperion.delvare> <472063CE.6040409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39407 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbXJYLTH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 07:19:07 -0400
Content-Disposition: inline
In-Reply-To: <472063CE.6040409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On Thu, Oct 25, 2007 at 11:37:18AM +0200, Boaz Harrosh wrote:
> On Wed, Oct 24 2007 at 11:59 +0200, Jean Delvare <khali@linux-fr.org> wrote:
> > -		struct completion *io_reset;
> > -		int finished_reset = 0;
> > +		struct completion *io_reset = NULL;
> > +		int finished_reset;
[...]
> > -		if (!finished_reset)
> > +		if (io_reset) {

> I think you should use uninitialized_var and not brute = NULL;

Look at the patch more carefully ... uninitialized_var would be
inappropriate.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
