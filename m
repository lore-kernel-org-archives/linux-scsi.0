From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: ybin on powerpc
Date: Sun, 20 Aug 2006 10:39:15 -0500
Message-ID: <1156088355.3726.39.camel@mulgrave.il.steeleye.com>
References: <20060819111919.a60dca49.akpm@osdl.org>
	 <1156024644.5803.73.camel@localhost.localdomain>
	 <20060819182818.bf3ff5bc.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:16365 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750827AbWHTPj0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 11:39:26 -0400
In-Reply-To: <20060819182818.bf3ff5bc.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, linux-scsi@vger.kernel.org

On Sat, 2006-08-19 at 18:28 -0700, Andrew Morton wrote:
> Bisection shows that this brokenness is introduced by
> git-scsi-misc.patch.
> 
> Someone has gone in and made some ill-advised "improvements" to
> /proc/scsi/scsi.  The switch from "Direct-Access" to "Direct access"
> broke
> ofpath.  I fixed that (in ofpath) but it remains broken for other
> reasons.
> 
> James, this is a non-compatible change to the kernel->userspace
> interface.  Please
> drop it like a hot potato.

Well ... OK, we shouldn't break things gratuitously.  However,
the /proc/scsi interface is deprecated and has been for a while now.

Secondly, as Matthew pointed out, the SCSI standards actually keep
changing their minds about the names of these things ...

But, thirdly, in order to get around the issue, we provided the

/sys/class/scsi_disk/<x:y:z:i>/device/type

interface which supplies the numeric field value precisely so people
shouldn't parse the translated strings.

So, it sounds like yaboot is also in need of modification.

James


