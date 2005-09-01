From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 1 Sep 2005 11:42:53 +0900
Message-ID: <20050901024253.GA1648@htj.dyndns.org>
References: <20050829061124.GA2725@htj.dyndns.org> <43142279.3070004@tw.ibm.com> <43143461.7040606@gmail.com> <43146DE7.1070501@adaptec.com> <4316569B.6080406@gmail.com> <431665D9.7010500@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <431665D9.7010500@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

 Hello, Jeff.

On Wed, Aug 31, 2005 at 10:22:17PM -0400, Jeff Garzik wrote:
> Tejun Heo wrote:
> > IMHO, it's a good idea to maintain one qc to one ATA/ATAPI command 
> >mapping as long as possible.  And, in the suggested framework, it's 
> >guaranteed that no other command can come inbetween CHECK_SENSE and 
> >REQUEST_SENSE.
> >
> > Requesting sense from EH, calling scsi_decide_disposition() on the 
> >sense and following the verdict should achieve the same effect as 
> >emulating autosense.  Is there any compelling reason to break one qc to 
> >one command mapping?
> 
> 
> Yes, you should have one qc <-> one ATA/ATAPI command.  That's why, in 
> the NCQ scenario, I wanted to make sure that one qc was always reserved 
> for error handling:  REQUEST SENSE or READ LOG EXT, most importantly.

 Having an extra (as opposed to reserved) EH qc doesn't break one qc
<-> one command mapping.

 a. All EH commands are non-NCQ.
 b. Inside EH, no other command is allowed.

 So, we can allocate a qc which does not have a corresponding NCQ tag.
This qc will never be used for normal commands.  It's used only for
internal commands when no other qc can be active.

 If we don't have an extra qc for EH, as non-NCQ devices have only one
qc, we should either,

 a. Rewrite failed qc to issue recovery command
 b. Complete failed qc and issue recovery command

 Both are not too attractive, IMHO.

 I currently don't understand very well why you don't like extra qc
approach.  Can you please elaborate?

> 
> For SAT layer MODE SELECT translations, that implies multiple calls to 
> qc_new/qc_issue/qc_complete before completing the overall SCSI command. 
>  The same for handling sata_sil mod15write:  I am beginning to feel 
> like the mod15write workaround might be best implemented in a manner 
> that caused libata-scsi (not sata_sil) to create/issue/complete multiple 
> ATA commands.

 That's what I've done for multi-qc SCSI cmd translation patch I've
posted the other day, and I think it would be really neat to do
similar thing for m15w.  However, to do so, we'll need some callbacks
at libata scsi/core layers (say, driver-overridable command
translation callbacks?) at the very least and I'm not sure about
adding those just for m15w.

> The only problem you run into is that a qc may be active during EH, when 
> you need another qc.  So avoiding recursive details becomes an issue.

 I guess this means the same thing I've described above about non-NCQ
devices, right?

 Thanks.

-- 
tejun
