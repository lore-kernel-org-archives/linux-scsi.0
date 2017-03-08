From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: out of range LBA using sg_raw
Date: Wed, 8 Mar 2017 21:41:48 +0530
Message-ID: <a408113afc010cb987d384dc78800f74@mail.gmail.com>
References: <cf343e80707394b8945cd7643f7beecd@mail.gmail.com>
 <20170308151113.GB27450@infradead.org> <eb88925faa247b2ae6e510fc7fd0cff9@mail.gmail.com>
 <20170308160633.GA25913@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35862 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753852AbdCHQR6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2017 11:17:58 -0500
Received: by mail-qk0-f169.google.com with SMTP id 1so73334320qkl.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Mar 2017 08:17:57 -0800 (PST)
In-Reply-To: <20170308160633.GA25913@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, March 08, 2017 9:37 PM
> To: Kashyap Desai
> Cc: Christoph Hellwig; linux-kernel@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Subject: Re: out of range LBA using sg_raw
>
> On Wed, Mar 08, 2017 at 09:29:28PM +0530, Kashyap Desai wrote:
> > Thanks Chris. It is understood to have sanity in driver, but how
> > critical such checks where SG_IO type interface send pass-through
request.
> ?
> > Are you suggesting as good to have sanity or very important as there
> > may be a real-time exposure other than SG_IO interface ? I am confused
> > over must or good to have check.
> > Also one more fault I can generate using below sg_raw command -
>
> SCSI _devices_ need to sanity check any input and fail commands instead
of
> crashing or causing other problems.  Normal SCSI HBA drivers don't need
to
> do that as they don't interpret CDBs.  Megaraid (and a few other raid
drivers)
> are special in that they take on part of the device functionality and do
> interpret CDBs sometimes.  In that case you'll need to do all that
sanity
> checking and generate proper errors.
>
> It would be nice to have come common helpers for this shared between
> everyone interpreting SCSI CBD (e.g. the SCSI target code, the NVMe SCSI
> emulation and the various RAID drivers).

Thanks Chris.  I will  continue on this and will come back with changes.
Let me check with Broadcom internally and figure out all possible
scenarios for megaraid_sas.

Thanks, Kashyap
