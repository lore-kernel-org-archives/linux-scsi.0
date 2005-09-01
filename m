From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] libata new EH document
Date: Wed, 31 Aug 2005 22:22:17 -0400
Message-ID: <431665D9.7010500@pobox.com>
References: <20050829061124.GA2725@htj.dyndns.org> <43142279.3070004@tw.ibm.com> <43143461.7040606@gmail.com> <43146DE7.1070501@adaptec.com> <4316569B.6080406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:16336 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S965031AbVIACWf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 22:22:35 -0400
In-Reply-To: <4316569B.6080406@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Doug Maxey <dwm@maxeymade.com>

Tejun Heo wrote:
>  IMHO, it's a good idea to maintain one qc to one ATA/ATAPI command 
> mapping as long as possible.  And, in the suggested framework, it's 
> guaranteed that no other command can come inbetween CHECK_SENSE and 
> REQUEST_SENSE.
> 
>  Requesting sense from EH, calling scsi_decide_disposition() on the 
> sense and following the verdict should achieve the same effect as 
> emulating autosense.  Is there any compelling reason to break one qc to 
> one command mapping?


Yes, you should have one qc <-> one ATA/ATAPI command.  That's why, in 
the NCQ scenario, I wanted to make sure that one qc was always reserved 
for error handling:  REQUEST SENSE or READ LOG EXT, most importantly.

For SAT layer MODE SELECT translations, that implies multiple calls to 
qc_new/qc_issue/qc_complete before completing the overall SCSI command. 
  The same for handling sata_sil mod15write:  I am beginning to feel 
like the mod15write workaround might be best implemented in a manner 
that caused libata-scsi (not sata_sil) to create/issue/complete multiple 
ATA commands.

The only problem you run into is that a qc may be active during EH, when 
you need another qc.  So avoiding recursive details becomes an issue.

	Jeff


