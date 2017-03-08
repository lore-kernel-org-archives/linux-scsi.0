From: Christoph Hellwig <hch@infradead.org>
Subject: Re: out of range LBA using sg_raw
Date: Wed, 8 Mar 2017 08:06:33 -0800
Message-ID: <20170308160633.GA25913@infradead.org>
References: <cf343e80707394b8945cd7643f7beecd@mail.gmail.com>
 <20170308151113.GB27450@infradead.org>
 <eb88925faa247b2ae6e510fc7fd0cff9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59020 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752985AbdCHQcm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2017 11:32:42 -0500
Content-Disposition: inline
In-Reply-To: <eb88925faa247b2ae6e510fc7fd0cff9@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Mar 08, 2017 at 09:29:28PM +0530, Kashyap Desai wrote:
> Thanks Chris. It is understood to have sanity in driver, but how critical
> such checks where SG_IO type interface send pass-through request. ?
> Are you suggesting as good to have sanity or very important as there may
> be a real-time exposure other than SG_IO interface ? I am confused over
> must or good to have check.
> Also one more fault I can generate using below sg_raw command -

SCSI _devices_ need to sanity check any input and fail commands instead
of crashing or causing other problems.  Normal SCSI HBA drivers don't
need to do that as they don't interpret CDBs.  Megaraid (and a few other
raid drivers) are special in that they take on part of the device
functionality and do interpret CDBs sometimes.  In that case you'll
need to do all that sanity checking and generate proper errors.

It would be nice to have come common helpers for this shared between
everyone interpreting SCSI CBD (e.g. the SCSI target code, the NVMe
SCSI emulation and the various RAID drivers).
