From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: 19 Aug 2003 09:19:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061302795.2134.7.camel@fuzzy>
References: <20030819073926.GA423@fib011235813.fsnet.co.uk>
	<20030819094838.F8428@sistina.com>
	<1061283871.3f41e81f8226b@impt3-2.free.fr>
	<20030819115110.I8420@sistina.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:64226 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S272338AbTHSPys (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2003 11:54:48 -0400
Received: from hancock.sc.steeleye.com ([65.114.3.137])
	by zeus.kernel.org (8.11.6/8.11.6) with ESMTP id h7JELb630151
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2003 07:21:37 -0700
In-Reply-To: <20030819115110.I8420@sistina.com>
List-Id: linux-scsi@vger.kernel.org
To: mauelshagen@sistina.com
Cc: christophe.varoqui@free.fr, mge@sistina.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-08-19 at 04:51, Heinz J . Mauelshagen wrote:
> On Tue, Aug 19, 2003 at 11:04:31AM +0200, christophe.varoqui@free.fr wrote:
> No, device-mapper is designed completely generic (LVM2 as well BTW).
> It will never contain any vendor specific hacks.

We don't need it to contain any vendor code, but we do need an interface
for vendor specific additions.

How arrays accomplish a path switch is highly vendor specific.  Some
(like EMC) run all paths active, so nothing needs doing.  Others need a
specific command sent to the array down the path before the switch can
be done.

> Ghosts should report EIO in case of an unstarted LUN anyway ?
> In case they are started they are supposed to report EPERM on IO because
> they don't support any.

This is awfully vendor specific again.  I know, for example, the HP MSA
array will report a check condition, not ready.  I think we translate
this to I/O error in the mid-layer (best we can do).  This is why we'll
do a better job of error reporting in fastfail.

James


