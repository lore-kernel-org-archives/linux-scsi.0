From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Bugme-new] [Bug 7667] New: BUG at drivers/scsi/scsi_lib.c:1118 caused by "pktsetup dvd /dev/sr0"
Date: Tue, 12 Dec 2006 11:38:42 +0100
Message-ID: <20061212103842.GA9619@lst.de>
References: <200612112159.kBBLxmep005850@fire-2.osdl.org> <20061211141029.9a0b0376.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:40566 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbWLLKjA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Dec 2006 05:39:00 -0500
Content-Disposition: inline
In-Reply-To: <20061211141029.9a0b0376.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Christoph Hellwig <hch@lst.de>, Peter Osterlund <petero2@telia.com>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, laurent.riffard@free.fr, Adrian Bunk <bunk@stusta.de>

This is because the packet driver tries to send down read/write
BLOCK_PC commands that don't use a bio and do not use sg lists.
As part of the patch you mentioned I added strict assertations for that
case because the scsi layer doesn't handle those anymore.

The right fix is to replace all the packet_command stuff in the packet
driver by scsi_execute() which needs to be lifted from scsi code to
the block code for that.  I'll prepare a patch this weekend unless
someone beets me in doing that work.
