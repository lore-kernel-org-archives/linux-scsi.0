From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 02 Apr 2004 13:13:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080929583.1804.122.camel@mulgrave>
References: <20040401131502.41136788.akpm@osdl.org>
	<1080862354.2118.78.camel@mulgrave> <20040402084338.GA3547@us.ibm.com>
	<1080921450.1804.66.camel@mulgrave> <20040402164531.GB3880@us.ibm.com>
	<1080925518.1830.93.camel@mulgrave>  <20040402174442.GE3880@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:38300 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264112AbUDBSNW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 13:13:22 -0500
In-Reply-To: <20040402174442.GE3880@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, stern@rowland.harvard.edu

On Fri, 2004-04-02 at 12:44, Mike Anderson wrote:
> Where does the last put come from? How do you close the open race or
> know when the final put_disk has been called? SCSI cannot do this alone
> as we have created and registered an object in another subsystem
> (alloc_disk and add_disk) and we have no indication when that objects
> ref count has reached zero. 
> 
> Or
> 
> As I previous stated in the thread below I have the gendisk /
> block layer locking mis-understood and there is something that SCSI can
> do.

well, sr has elected to merge these, so it takes a reference to
sdev_gendev on first open and releases it on last close of the block
device.  This is what ties the SCSI model into the final put_disk().

We founder on calling driver ->remove before the final put of
sdev_gendev.

Anything with objects in more than one refcounted subsystem is
responsible for tying the refcounts together uniformly.

There should be no open race as long as we error out correctly if a
reference to the underlying sdev_gendev cannot be obtained (because the
object is being destroyed).  sr seems to do this correctly.  The
indication when the non-scsi object's refcount reaches zero is given to
us because at that point the sr code does a put of the sdev_gendev (and
if this is the last put, that should trigger cleanup).

James


