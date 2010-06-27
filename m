From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 16275] Kernel panic when mounting filesystem
Date: Sun, 27 Jun 2010 16:06:10 -0500
Message-ID: <1277672770.10879.5.camel@mulgrave.site>
References: <bug-16275-11613@https.bugzilla.kernel.org/>
	 <201006250813.o5P8Dd7w030091@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921Ab0F0VGP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jun 2010 17:06:15 -0400
In-Reply-To: <201006250813.o5P8Dd7w030091@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Fri, 2010-06-25 at 08:13 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> any news ?
> I can test if someone give - patch that fix this issue.

For those who don't have access to bugzilla, there's a gif image of the
crash:

https://bugzilla.kernel.org/attachment.cgi?id=26910

Unfortunately, the crucial information has scrolled off the top of the
screen, but the presentation is some type of crash in
scsi_setup_fs_cmnd().  Without the missing information, it's hard to
say, but I'd would be a reasonable guess that it's this BUG_ON:

	/*
	 * Filesystem requests must transfer data.
	 */
	BUG_ON(!req->nr_phys_segments);

Which would point to the filesystem.  First order of business would be
to validate the guess by getting the missing part of the trace, and then
start looking into the relevant filesystem.

James


