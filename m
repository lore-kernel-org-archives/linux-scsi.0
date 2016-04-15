From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: RE: [PATCH] mpt3sas: fix possible NULL dereference
Date: Fri, 15 Apr 2016 11:35:48 -0600
Message-ID: <5b2eca0b5053d01c09f62cf498e3fc0a@mail.gmail.com>
References: <1460130162-30011-1-git-send-email-sudipm.mukherjee@gmail.com> <yq1mvovsiaa.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36144 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbcDORfv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2016 13:35:51 -0400
Received: by mail-io0-f178.google.com with SMTP id u185so141469112iod.3
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2016 10:35:50 -0700 (PDT)
In-Reply-To: <yq1mvovsiaa.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org

We need to do some more changes in this.  The concept is first pool alloc
and then memory alloc in the pool, so the memory has to be freed if the
memory is allocated in the pool and irrespective of memory allocated or
not the pool has to be destroyed if it is created.  We will work
internally and provide a complete patch.

Thanks
Sathya

-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
Sent: Thursday, April 14, 2016 8:44 PM
To: Sudip Mukherjee
Cc: Sathya Prakash; Chaitra P B; Suganath Prabu Subramani; James E.J.
Bottomley; Martin K. Petersen; linux-kernel@vger.kernel.org;
MPT-FusionLinux.pdl@broadcom.com; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] mpt3sas: fix possible NULL dereference

>>>>> "Sudip" == Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:

Sudip> We are dereferencing ioc->sense_dma_pool in pci_pool_free() and
Sudip> after that we are checking if it is NULL, before calling
Sudip> pci_pool_destroy().  Lets check if it is NULL before calling both
Sudip> pci_pool_free() and pci_pool_destroy().

Broadcom folks, please review.

-- 
Martin K. Petersen	Oracle Linux Engineering
