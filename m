From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Regarding ordered-tag support.
Date: Wed, 08 Feb 2006 14:59:28 -0600
Message-ID: <1139432368.2979.13.camel@mulgrave.il.steeleye.com>
References: <43E99248.7090505@gmail.com>
	 <1139413766.3003.19.camel@mulgrave.il.steeleye.com>
	 <43EA1AD4.8010402@emulex.com>
	 <1139431826.2979.8.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:4832 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932098AbWBHU7h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 15:59:37 -0500
In-Reply-To: <1139431826.2979.8.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Tejun Heo <htejun@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2006-02-08 at 14:50 -0600, James Bottomley wrote:
> > - How does multipathing affect this (maybe not dm, but others that exist).
> 
> Hey, with block level multi-path that's now officially Someone Else's
> Problem. (And it's also a problem for software RAID as well).

And actually (in the time honoured tradition of telling someone else
what they should be doing while blowing your own trumpet) could I just
point out that I think that it's impossible to enforce barriers in the
face of multi-path (because of the cross path synchronisation
requirements).  However, it should be quite easy to enforce linked
command ordering in these environments by the simple expedient of
tagging a link to a single path.  Even on path failure for partial link
completion, you simply resend the entire segment of link command set
that you don't know completed (because writes are idempotent).

James


