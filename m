From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] Associate HBA and storage in rdac_controller to
 support partitions in storage
Date: Wed, 27 Jul 2011 11:20:30 -0700
Message-ID: <1311790830.3210.997.camel@chandra-lucid.beaverton.ibm.com>
References: <1311196948.5505.10779.camel@chandra-lucid.beaverton.ibm.com>
	 <1311762897.5029.0.camel@mulgrave>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45025 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab1G0SUf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 14:20:35 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6RI7l9B022361
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2011 14:07:47 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p6RIKY75162512
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2011 14:20:34 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p6REKLu8005028
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2011 11:20:22 -0300
In-Reply-To: <1311762897.5029.0.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>, "Moger, Babu" <Babu.Moger@netapp.com>, yanling.Qi@netapp.com, "Stankey, Robert" <Robert.Stankey@netapp.com>

Oops. Sorry. By mistake sent an earlier version. Will send the correct
version.
On Wed, 2011-07-27 at 14:34 +0400, James Bottomley wrote:
> On Wed, 2011-07-20 at 14:22 -0700, Chandra Seetharaman wrote:
> > rdac hardware handler assumes that there is one-to-one relation ship
> > between the host and the controller w.r.t lun.  IOW, it does not
> > support "multiple storage partitions" within a storage.
> > 
> > Example:
> > HBA1 and HBA2 see lun 0 and 1 in storage A (1)
> > HBA3 and HBA4 see lun 0 and 1 in storage A (2)
> > HBA5 and HBA6 see lun 0 and 1 in storage A (3)
> > 
> > luns 0 and 1 in (1), (2) and (3) are totally different.
> > 
> > But, rdac handler treats the lun 0s (and lun 1s) as the same when 
> > sending a mode select to the controller, which is wrong.
> > 
> > This patch makes the rdac hardware handler associate HBA and the
> > storage w.r.t lun (and not the host itself).
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > ---
> >  drivers/scsi/device_handler/scsi_dh_rdac.c |   10 +++++++---
> >  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> This doesn't apply;
> 
> patching file drivers/scsi/device_handler/scsi_dh_rdac.c
> Hunk #1 succeeded at 158 (offset 9 lines).
> Hunk #2 FAILED at 381.
> Hunk #3 FAILED at 389.
> Hunk #4 FAILED at 403.
> Hunk #5 FAILED at 526.
> 4 out of 5 hunks FAILED -- saving rejects to file
> drivers/scsi/device_handler/scsi_dh_rdac.c.rej
> 
> 
> it looks like there's a missing intermediate patch somewhere, can you
> check scsi-misc and tell me what it is?
> 
> Thanks,
> 
> James
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


