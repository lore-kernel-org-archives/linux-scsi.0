From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 0/6] qla2xxx device removal fixups
Date: Tue, 26 Aug 2014 09:20:55 -0400
Message-ID: <20140826092055.53a2ff26@jlaw-desktop.mno.stratus.com>
References: <1403100139-1798-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c11o143.mxlogic.net ([208.65.144.76]:48271 "EHLO
	p02c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbaHZNaD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Aug 2014 09:30:03 -0400
In-Reply-To: <1403100139-1798-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Bill Kuzeja <william.kuzeja@stratus.com>, Dave Bulkow <david.bulkow@stratus.com>, Christoph Hellwig <hch@lst.de>

On Wed, 18 Jun 2014 10:02:13 -0400
Joe Lawrence <joe.lawrence@stratus.com> wrote:

> Hi Chad, Giri, et al.
> 
> Stratus has been testing the upstream qla2xxx driver against surprise
> device removal and has found a few minor issues along the way.  With
> this patchset, results have been good.  Although the following changes
> may be most interesting on a Stratus platform, they should be applicable
> to general hotplug scenarios on other hardware.
> 
> The first two patches are independent from the others and can be
> reviewed as such.  One fixes up a use-after-free and the other
> consolidates some code.

Patch 1 corrects a bug introduced by commit fe1b806, which has made its
way into three linux-stable releases:

% git tag --contains fe1b806 | grep '^v3.[0-9]*$'
v3.14
v3.15
v3.16

> The final four patches are more invasive and modify the scsi_qla_host
> structure to avoid device removal race conditions.  These changes were
> written to demonstrate the problem at hand and minimally fix them in
> order to continue testing.  (For example, adding completely a new
> pci_flags member to scsi_qla_host is probably overkill.) 
> 
> We would welcome any feedback or questions about our testing.

Chad ack'd the series on 28 Jul 2014.  Any chance this can make into
hch's queue for 3.18?

Regards,

-- Joe
