From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH v2 1/1] aacraid: pci_alloc_consistent() failures on ARM64
Date: Tue, 25 Apr 2017 23:21:11 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A51341B71@avsrvexchmbx1.microsemi.net>
References: <1491389056-15543-1-git-send-email-mahesh.rajashekhara@microsemi.com>
 <20170425070721.GA13214@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0054.outbound.protection.outlook.com ([104.47.38.54]:46690
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1946221AbdDYXVS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 19:21:18 -0400
In-Reply-To: <20170425070721.GA13214@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Tuesday, April 25, 2017 12:07 AM
> To: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
> Cc: Dave Carroll <david.carroll@microsemi.com>; linux-scsi@vger.kernel.or=
g;
> jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; dl-esc-Aacraid Linux
> Driver <aacraid@microsemi.com>
> Subject: Re: [PATCH v2 1/1] aacraid: pci_alloc_consistent() failures on A=
RM64
>=20
> On Wed, Apr 05, 2017 at 04:14:16PM +0530, Mahesh Rajashekhara wrote:
> > There were pci_alloc_consistent() failures on ARM64 platform.
> > Use dma_alloc_coherent() with GFP_KERNEL flag DMA memory allocations.
> >
> > Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
> > ---
> > v2:
> >  - Removed platform specific MACRO and call dma_*_coherent routines
> directly.
> >  - Removed all the casts to and from void * in the arguments and
> > return values
>=20
> The indentation is weird, and you're also adding memsets of the allocatio=
ns
> which is a behavior change.  Please take a look at the the attached versi=
on that
> fixes this up.
>=20
> If you really need the zeroing please send an additional patch to switch =
to
> dma_zalloc_coherent.
>=20
> ---
> From 522b355c4fe021822d385332de525c7de5c2b290 Mon Sep 17 00:00:00
> 2001
> From: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
> Date: Wed, 5 Apr 2017 16:14:16 +0530
> Subject: aacraid: pci_alloc_consistent() failures on ARM64
>=20
> There were pci_alloc_consistent() failures on ARM64 platform.
> Use dma_alloc_coherent() with GFP_KERNEL flag DMA memory allocations.
>=20
> Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
> [hch: tweaked indentation, removed memsets]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
Acked-by: Dave Carroll <david.carroll@microsemi.com>
