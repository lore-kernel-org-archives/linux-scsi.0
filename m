From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bidirectional, long commands + OSD
Date: 30 Jan 2004 09:22:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075472579.2026.20.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E5703D19D33@exa-atlanta.se.lsil.com>	<10751367
	27.2290.48.camel@mulgrave>  <401625CA.1070404@torque.net>
	<1075316397.1739.15.camel@mulgrave>  <40190591.5060409@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:3234 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261298AbUA3OXB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2004 09:23:01 -0500
In-Reply-To: <40190591.5060409@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-01-29 at 08:07, Douglas Gilbert wrote:
> James Bottomley wrote in thread:
> > As I see it, OSD seems to require a different interface from the current
> > bio layer, so there would be some type of object layer glue between the
> > fs and the mid-layer, with the block layer relegated simply to queueing
> > specials for the mid-layer, but since no-one's actually come forward
> > with an implementation, that's just a guess.
> 
> Both Jens and Linus jumped on me when I suggested
> similar heresy :-)

Well ... I merely stated what it seems to require.  I didn't recommend
implementing it.

>From what I can tell, the OSD spec seems to be aimed at large clustered
filesystems.  The recommended mapping seems to be <multiple objects> <->
<one file>.  However, since different objects are distinct and currently
require distinct commands to access them, I believe using OSD for a
typical Linux filesystem would be a big loss because most files are
small and we can no-longer elevate the requests.  It would be
interesting to see if this loss could be offset by not having to do
indirect block lookups, but I have my doubts.

James


