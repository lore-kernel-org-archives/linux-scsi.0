From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: 2.6.0 stability and the BK scsi trees
Date: 22 Oct 2003 09:23:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066832592.10892.33.camel@mulgrave>
References: <1066265974.16761.426.camel@fuzzy>
	<3F8E8786.2020502@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:31751 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263425AbTJVOXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 10:23:49 -0400
In-Reply-To: <3F8E8786.2020502@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

OK, I now have the scsi-misc-2.5 tree split up correctly into
scsi-bugfixes-2.6 and scsi-misc-2.7

Since BK isn't very good at keeping two parallel trees like this
(especially if I have to move patches from one to the other), this is
probably the end of usable SCSI BK trees.


On Thu, 2003-10-16 at 06:56, Douglas Gilbert wrote:
> What was the point of putting 32 dev_t's into the
> kernel? Many people who were advocating it used
> the increased number of scsi disks (> 256) and
> partitions (from 15 to 63 [to match the ide subsystem])
> as a major reason.
> 
> The sd driver is still littered with hacks to distribute
> its 256 (max) disks over 8 majors. Shouldn't this be
> fixed?

Well, my opinion is that this bugfix only edict is to get 2.6.0 stable. 
I anticipate the rules for driver updates will be relaxed again for
2.6.1+

I'm also going to argue that our current refcounting problems are a bug
(especially since they induce oopses), so fixes for refcounting problems
will go into the bugfix tree.

I'm not sure about 32 bit kdev_t.  Initially, I think it counts as an
enhancement, but will revise this if any other driver gets 32 bit kdev_t
patches in under the bugfixes label.

As far as driver bug fixes go, using the old error handler is still a
bug.  However, I'll only place it into the bugfix tree if you've tested
it out on the actual hardware (however obvious the change looks).

I'll cc the list on tree submissions, so you'll be able to read any
objections I get from Andrew or Linus over what constitutes a bug.

James


