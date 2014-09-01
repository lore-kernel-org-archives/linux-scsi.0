From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 20/22] scsi: align logging messages
Date: Mon, 1 Sep 2014 01:00:26 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C2F65E@G9W0745.americas.hpqcorp.net>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-21-git-send-email-hare@suse.de>
 <20140831222556.GL16432@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:43425 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaIABBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 21:01:10 -0400
In-Reply-To: <20140831222556.GL16432@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Hoffmann, Elliot" <elliot.hoffmann@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Sunday, 31 August, 2014 5:26 PM
...
> On Thu, Aug 28, 2014 at 07:33:34PM +0200, Hannes Reinecke wrote:
> > Always use 'scmd 0x%p' when logging a command pointer.
> 
> Is there any good reason to print the address of a command pointer?
 
It relates the messages to each other.  When you get lots of
interleaved messages like:

[ 3161.441116] sd 2:0:0:2: [sdt] scmd ffff88041a874e70 abort scheduled
[ 3161.444258] sd 2:0:0:2: [sdt] scmd ffff88041a8b3b30 abort scheduled
...
[ 3162.707427] sd 2:0:0:2: [sdt] aborting command ffff88041a8b3b30
[ 3162.710445] sd 2:0:0:2: [sdt] scmd ffff88041a8b3b30 abort failed, rtn 8195
[ 3162.713092] sd 2:0:0:2: [sdt] aborting command ffff88041a8dd530
[ 3162.715172] sd 2:0:0:2: [sdt] scmd ffff88041a8dd530 abort failed, rtn 8195
...
[ 3171.052277] sd 2:0:0:2: [sdt] scsi_eh_2: flush retry cmd: ffff88041a8b3b30
[ 3171.054910] sd 2:0:0:2: [sdt] scsi_eh_2: flush retry cmd: ffff88041a8dd530
...
[ 3203.406218] sd 2:0:0:0: [sdr] scmd ffff88041a8214b0 not aborting, host in recovery
[ 3203.406424] sd 2:0:0:0: [sdr] scmd ffff88041a8474f0 not aborting, host in recovery

scmd ties the messages together so you can tell which command
has gotten to which state.  grep works.

---
Rob Elliott    HP Server Storage



