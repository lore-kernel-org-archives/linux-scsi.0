From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [RFC] libata new EH document
Date: Wed, 31 Aug 2005 20:33:22 -0700 (PDT)
Message-ID: <20050901033322.96752.qmail@web51609.mail.yahoo.com>
References: <431665D9.7010500@pobox.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <431665D9.7010500@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

--- Jeff Garzik <jgarzik@pobox.com> wrote:

> Tejun Heo wrote:
> >  IMHO, it's a good idea to maintain one qc to one ATA/ATAPI command 
> > mapping as long as possible.  And, in the suggested framework, it's 
> > guaranteed that no other command can come inbetween CHECK_SENSE and 
> > REQUEST_SENSE.
> > 
> >  Requesting sense from EH, calling scsi_decide_disposition() on the 
> > sense and following the verdict should achieve the same effect as 
> > emulating autosense.  Is there any compelling reason to break one qc to 
> > one command mapping?
> 
> 
> Yes, you should have one qc <-> one ATA/ATAPI command.  That's why, in 

Agree.

> the NCQ scenario, I wanted to make sure that one qc was always reserved 
> for error handling:  REQUEST SENSE or READ LOG EXT, most importantly.

Yes.

> For SAT layer MODE SELECT translations, that implies multiple calls to 
> qc_new/qc_issue/qc_complete before completing the overall SCSI command. 
>   The same for handling sata_sil mod15write:  I am beginning to feel 
> like the mod15write workaround might be best implemented in a manner 
> that caused libata-scsi (not sata_sil) to create/issue/complete multiple 
> ATA commands.
> 
> The only problem you run into is that a qc may be active during EH, when 
> you need another qc.  So avoiding recursive details becomes an issue.

Hmm...

     Luben

