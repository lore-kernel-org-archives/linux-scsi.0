From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: 29 Sep 2004 10:24:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096467874.1762.15.camel@mulgrave>
References: <415A67B8.2080003@suse.de>  <1096466196.2028.8.camel@mulgrave>
	<1096463876.15905.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:22486 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268490AbUI2OYj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 10:24:39 -0400
In-Reply-To: <1096463876.15905.23.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-09-29 at 09:17, Alan Cox wrote:
> On Mer, 2004-09-29 at 14:56, James Bottomley wrote:
> > The key to the solution of this problem is to know what USB is trying to
> > do with the dead device.  SCSI is trying to be polite and explicitly
> > kill the outstanding commands before it removes the HBA.  Presumably USB
> > is returning something that says this can't be done so the EH gets all
> > the way up to offlining.
> 
> Its nothing to do with USB, rmmod with eh running crashes all the other
> SCSI drivers I've tested too. After the state transition fails you get
> kobject related errors and a crash. 

There is no crash in the log ... there was only a state transition
complaint.

I think the solution is in the eh and its simply not to try to ready the
device on SDEV_CANCEL (no point readying a device you're being asked to
kill).

James


