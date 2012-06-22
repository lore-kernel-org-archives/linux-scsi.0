From: Praveen Murali <pmurali@logicube.com>
Subject: Re: [PATCH v1] Fix sector number translation in sense buffer for
 SATA drives
Date: Thu, 21 Jun 2012 17:23:57 -0700
Message-ID: <1340324637.3712.67.camel@praveen-debian.lg.local>
References: <1340322136.3712.61.camel@praveen-debian.lg.local>
	 <CAA9_cmf-aufpXarLc5_NNzKs-LM39hYYxP-2RP7rWTf1o0p6Mg@mail.gmail.com>
Reply-To: pmurali@logicube.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:36301 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760749Ab2FVAYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2012 20:24:50 -0400
In-Reply-To: <CAA9_cmf-aufpXarLc5_NNzKs-LM39hYYxP-2RP7rWTf1o0p6Mg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2012-06-21 at 17:04 -0700, Dan Williams wrote:
> On Thu, Jun 21, 2012 at 4:42 PM, Praveen Murali <pmurali@logicube.com> wrote:
> > For my large capacity drives connected to my SAS HBA i get improper
> > sector values when i use hdparm to get the native max. Also, the drives
> > have known bad sectors, but when read fails, the sector information
> > printed in the sense buffer is incorrect.
> >  In fill_result_tf() of libata-core.c the flags for the resultant tf is
> > copied from the request tf before calling the qc_fill_rtf() for the
> > driver. In case of SAS we convert the FIS to tf after receiving the
> > response and memcpy this tf over to the result tf in
> > sas_ata_qc_fill_rtf(); which results in overwriting the flags
> > for rtf. As a result, when ata_tf_read_block() is called by
> > ata_gen_ata_sense() ata_tf_read_block() does not find ATA_TFLAG_LBA or
> > ATA_TFLAG_LBA48 in the rtf flags. Hence, the returned block value is not
> > calculated correctly.
> >
> > The fix sets the flags in result tf from tf after calling qc_fill_rtf()
> > to take care of overwrites (as in libsas). Also, if the overwrite was
> > intentional, we will only setup the right bits here.
> 
> Hmm, I think libsas is at fault here and should be using
> ata_tf_from_fis() like the other ->qc_fill_rtf() implementations.
libsas calls ata_tf_from_fis in sas_ata.c sas_ata_task_done() to copy
the result FIS. But then it copies this information to sata_dev.tf in
the domain device. It mem copies this (sata_dev.tf) over to the rtf in
sas_ata_qc_fill_rtf().
 Another way to fix this might be to save the flags in sata_dev.tf from
qc->tf in sas_ata_task_done() before/after it calls ata_tf_from_fis().
This was it can still keep doing the mem copy and the order in libata
need not be changed.
What do you think?

> --
> Dan

Praveen

