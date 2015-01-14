From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 3/9] scsi: use external buffer for command logging
Date: Wed, 14 Jan 2015 10:36:19 +0100
Message-ID: <20150114093619.GA11129@lst.de>
References: <1420699430-9492-1-git-send-email-hare@suse.de> <1420699430-9492-4-git-send-email-hare@suse.de> <1421175409.2076.17.camel@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45932 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbbANJgW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2015 04:36:22 -0500
Content-Disposition: inline
In-Reply-To: <1421175409.2076.17.camel@parallels.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "hare@suse.de" <hare@suse.de>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Jan 13, 2015 at 06:56:17PM +0000, James Bottomley wrote:
> I really hate using an on-stack buffer here ... we're pretty deep in the
> call chain already.
> 
> Since it's just required for printing a "command: " prefix, why not just
> use scsi_print_command()?

Both the ch and sr callers are not really a problem in terms of stack
usage, as they are directly in file operations of character or block
devices, so the whole FS/MM stack stack problem isn't an issue.

But using higher level functions might still be useful here.
