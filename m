From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [scsi hcil 3/9] misc cleanups
Date: Fri, 28 Oct 2005 20:34:19 -0500
Message-ID: <1130549660.3328.35.camel@mulgrave>
References: <20051024220013.GA10070@havoc.gtf.org>
	 <20051024220205.GC10567@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:3566 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750966AbVJ2Bej (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 21:34:39 -0400
In-Reply-To: <20051024220205.GC10567@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2005-10-24 at 18:02 -0400, Jeff Garzik wrote:
>     - eliminate use of 'channel' and 'id' in starget_for_each_device()

Actually, we can't do this.  The reason for the way it looks today is
that shost_for_each_device() actually performs a lot of magic assuming
that the list can be changing under it (it was a long precursor to the
klists, if you like).  list_for_each_entry() does no such magic.

We could convert to klists to get this, or simply replicate the host
magic per target.

James


