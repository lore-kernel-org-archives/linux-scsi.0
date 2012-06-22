From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1] Fix sector number translation in sense buffer for SATA drives
Date: Thu, 21 Jun 2012 18:35:10 -0700
Message-ID: <CABE8wws6w0uWhskDJZPuKr3S1_qwo8M1vy-q8CuvJs=C1BRs2A@mail.gmail.com>
References: <1340322136.3712.61.camel@praveen-debian.lg.local>
	<CAA9_cmf-aufpXarLc5_NNzKs-LM39hYYxP-2RP7rWTf1o0p6Mg@mail.gmail.com>
	<1340324637.3712.67.camel@praveen-debian.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:61260 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760890Ab2FVBfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2012 21:35:19 -0400
Received: by bkcjc3 with SMTP id jc3so1035655bkc.25
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jun 2012 18:35:10 -0700 (PDT)
In-Reply-To: <1340324637.3712.67.camel@praveen-debian.lg.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pmurali@logicube.com
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 21, 2012 at 5:23 PM, Praveen Murali <pmurali@logicube.com> =
wrote:
> On Thu, 2012-06-21 at 17:04 -0700, Dan Williams wrote:
>> On Thu, Jun 21, 2012 at 4:42 PM, Praveen Murali <pmurali@logicube.co=
m> wrote:
>> > For my large capacity drives connected to my SAS HBA i get imprope=
r
>> > sector values when i use hdparm to get the native max. Also, the d=
rives
>> > have known bad sectors, but when read fails, the sector informatio=
n
>> > printed in the sense buffer is incorrect.
>> > =A0In fill_result_tf() of libata-core.c the flags for the resultan=
t tf is
>> > copied from the request tf before calling the qc_fill_rtf() for th=
e
>> > driver. In case of SAS we convert the FIS to tf after receiving th=
e
>> > response and memcpy this tf over to the result tf in
>> > sas_ata_qc_fill_rtf(); which results in overwriting the flags
>> > for rtf. As a result, when ata_tf_read_block() is called by
>> > ata_gen_ata_sense() ata_tf_read_block() does not find ATA_TFLAG_LB=
A or
>> > ATA_TFLAG_LBA48 in the rtf flags. Hence, the returned block value =
is not
>> > calculated correctly.
>> >
>> > The fix sets the flags in result tf from tf after calling qc_fill_=
rtf()
>> > to take care of overwrites (as in libsas). Also, if the overwrite =
was
>> > intentional, we will only setup the right bits here.
>>
>> Hmm, I think libsas is at fault here and should be using
>> ata_tf_from_fis() like the other ->qc_fill_rtf() implementations.
> libsas calls ata_tf_from_fis in sas_ata.c sas_ata_task_done() to copy
> the result FIS. But then it copies this information to sata_dev.tf in
> the domain device. It mem copies this (sata_dev.tf) over to the rtf i=
n
> sas_ata_qc_fill_rtf().
> =A0Another way to fix this might be to save the flags in sata_dev.tf =
from
> qc->tf in sas_ata_task_done() before/after it calls ata_tf_from_fis()=
=2E
> This was it can still keep doing the mem copy and the order in libata
> need not be changed.
> What do you think?

tf->flags is an internal detail of libata to record context about the
in-flight command.  So just fixing sas_ata_qc_fill_rtf() to not
trample on the non-fis fields in the tf should be all that is needed,
i.e. just a copy from the original qc.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
