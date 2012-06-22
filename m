From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1] Fix sector number translation in sense buffer for SATA drives
Date: Thu, 21 Jun 2012 17:04:54 -0700
Message-ID: <CAA9_cmf-aufpXarLc5_NNzKs-LM39hYYxP-2RP7rWTf1o0p6Mg@mail.gmail.com>
References: <1340322136.3712.61.camel@praveen-debian.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f51.google.com ([209.85.213.51]:50955 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760706Ab2FVAEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2012 20:04:54 -0400
Received: by yhnn12 with SMTP id n12so1307568yhn.10
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2012 17:04:54 -0700 (PDT)
In-Reply-To: <1340322136.3712.61.camel@praveen-debian.lg.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pmurali@logicube.com
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 21, 2012 at 4:42 PM, Praveen Murali <pmurali@logicube.com> =
wrote:
> For my large capacity drives connected to my SAS HBA i get improper
> sector values when i use hdparm to get the native max. Also, the driv=
es
> have known bad sectors, but when read fails, the sector information
> printed in the sense buffer is incorrect.
> =A0In fill_result_tf() of libata-core.c the flags for the resultant t=
f is
> copied from the request tf before calling the qc_fill_rtf() for the
> driver. In case of SAS we convert the FIS to tf after receiving the
> response and memcpy this tf over to the result tf in
> sas_ata_qc_fill_rtf(); which results in overwriting the flags
> for rtf. As a result, when ata_tf_read_block() is called by
> ata_gen_ata_sense() ata_tf_read_block() does not find ATA_TFLAG_LBA o=
r
> ATA_TFLAG_LBA48 in the rtf flags. Hence, the returned block value is =
not
> calculated correctly.
>
> The fix sets the flags in result tf from tf after calling qc_fill_rtf=
()
> to take care of overwrites (as in libsas). Also, if the overwrite was
> intentional, we will only setup the right bits here.

Hmm, I think libsas is at fault here and should be using
ata_tf_from_fis() like the other ->qc_fill_rtf() implementations.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
