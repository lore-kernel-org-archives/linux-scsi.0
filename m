From: Matthew Wilcox <matthew@wil.cx>
Subject: Thin device provisioning
Date: Fri, 8 Aug 2008 07:15:11 -0600
Message-ID: <20080808131511.GC8618@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54448 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYHHNPb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2008 09:15:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: knight@netapp.com
Cc: David Woodhouse <dwmw2@infradead.org>, ricwheeler@gmail.com, linux-scsi@vger.kernel.org, t10@t10.org


Good morning Fred,

I've been looking at your 08-149r0.pdf with a view to using the 'PUNCH'
command to implement the Linux 'DISCARD' command.  It's a little
over-specified for what we need and this causes the implementation to
be a little more complex than I would like.  The excess capability is
the ability to do multiple punches in a single command.  Do you really
need to be able to add/remove lots of ranges atomically, or could you
use a command specified like this:

0	0x9F
1	service action
2-9	LBA
10-13	length
14	reserved
15	control

and send one command for each range?

Apologies if this has already been covered in a T10 discussion; I'm not
a member and though I've searched the archives, I may have missed a
discussion.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
