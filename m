From: Andrew Morton <akpm@osdl.org>
Subject: Re: ybin on powerpc
Date: Sun, 20 Aug 2006 15:41:18 -0700
Message-ID: <20060820154118.e489f445.akpm@osdl.org>
References: <20060819111919.a60dca49.akpm@osdl.org>
	<1156024644.5803.73.camel@localhost.localdomain>
	<20060819182818.bf3ff5bc.akpm@osdl.org>
	<1156088355.3726.39.camel@mulgrave.il.steeleye.com>
	<1156110857.5803.82.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:50368 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751751AbWHTWlc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 18:41:32 -0400
In-Reply-To: <1156110857.5803.82.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Paul Mackerras <paulus@samba.org>, linux-scsi@vger.kernel.org, Paul Nasrat <pnasrat@redhat.com>

On Mon, 21 Aug 2006 07:54:17 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> > Well ... OK, we shouldn't break things gratuitously.  However,
> > the /proc/scsi interface is deprecated and has been for a while now.
> > 
> > Secondly, as Matthew pointed out, the SCSI standards actually keep
> > changing their minds about the names of these things ...
> > 
> > But, thirdly, in order to get around the issue, we provided the
> > 
> > /sys/class/scsi_disk/<x:y:z:i>/device/type
> > 
> > interface which supplies the numeric field value precisely so people
> > shouldn't parse the translated strings.
> > 
> > So, it sounds like yaboot is also in need of modification.
> 
> CC'ed Paul Nasrat who is the current yaboot maintainer
> 
> (Paul, the problem is about a /proc/scsi change breaking ofpath. The
> change will probably be reverted, but still, ofpath should be changed to
> not rely on that crap anymore)
> 

yup.

James, I think the best (only) way in which we can communicate with all
users of the kernel is via the kernel.  So we add a once-per-boot printk on
first access to /proc/scsi/scsi (it should include current->comm).

That should get people migrating off /proc/scsi/scsi as quickly as we can
reasonably expect.  Then in a year or four we can perhaps remove it.
