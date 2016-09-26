From: Christoph Hellwig <hch@infradead.org>
Subject: Re: UAS driver seems to be reporting a 4k sector size for a 512 byte
 sector device?
Date: Mon, 26 Sep 2016 09:25:11 -0700
Message-ID: <20160926162511.GA1949@infradead.org>
References: <20160926161926.cmayrily476v3wa7@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33484 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423062AbcIZQZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 12:25:12 -0400
Content-Disposition: inline
In-Reply-To: <20160926161926.cmayrily476v3wa7@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Mon, Sep 26, 2016 at 12:19:26PM -0400, Theodore Ts'o wrote:
> Is this a problem with the hardware, or with the UAS driver?

UAS is just SCSI transport, and doesn't touch the content of command,
so it's a very unlikely culprit.  The SCSI layer intreprets it, but I
don't really think it's doing any of this either..  Your bridge most
likely always reports 4k sectors when using UAS for some reason.

To verify this call sg_readcap on the device node for both the
usb-storage and uas mode.
