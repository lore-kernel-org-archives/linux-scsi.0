From: Christoph Hellwig <hch@lst.de>
Subject: Re: NVMe over Fabrics target implementation
Date: Thu, 9 Jun 2016 15:46:03 +0200
Message-ID: <20160609134603.GA29820@lst.de>
References: <1465248177-17970-1-git-send-email-hch@lst.de> <1465280632.5365.58.camel@haakon3.risingtidesystems.com> <20160607105550.GB17113@lst.de> <1465363301.5365.81.camel@haakon3.risingtidesystems.com> <20160608121932.GA31316@lst.de> <575819BB.7010209@lightbits.io> <1465446975.5365.123.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54236 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbcFINqF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2016 09:46:05 -0400
Content-Disposition: inline
In-Reply-To: <1465446975.5365.123.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagi@lightbits.io>, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, keith.busch@intel.com, target-devel <target-devel@vger.kernel.org>

On Wed, Jun 08, 2016 at 09:36:15PM -0700, Nicholas A. Bellinger wrote:
> The configfs ABI should not dictate a single backend use-case.

And it doesn't.  I actually had a file backend implemented to
benchmark it against the loopback driver.  It needed absolutely
zero new configfs interface.  And if we at some point want
different backends using different attributes we can trivially
add them using configfs_register_group.

> Along with having common code and existing configfs
> ABI, we also get a proper starting point for target-core
> features that span across endpoints, and are defined for
> both scsi and nvme.  PR APTPL immediately comes to mind.

PRs are a useful feature on the road map.  However we need a separate
pluggable backend anyway for distributed backends like RBD or Bart's
DLM implementation.  Also the current LIO PR implementation will need
a lot of work to be usable for NVMe while actually following the
spec in all it's details and to be power =D1=95afe.   The right way to
go here is a PR API that allows different backends, and the existing
LIO one might be one of them after it's got the needed attention.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
