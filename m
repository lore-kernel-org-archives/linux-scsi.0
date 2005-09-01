From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 1 Sep 2005 12:44:29 +0900
Message-ID: <20050901034429.GA3418@htj.dyndns.org>
References: <4316569B.6080406@gmail.com> <20050901033027.63466.qmail@web51605.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050901033027.63466.qmail@web51605.mail.yahoo.com>
Sender: linux-ide-owner@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Albert Lee <albertcc@tw.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

 Hi, Luben.

On Wed, Aug 31, 2005 at 08:30:27PM -0700, Luben Tuikov wrote:
> --- Tejun Heo <htejun@gmail.com> wrote:
> >   IMHO, it's a good idea to maintain one qc to one ATA/ATAPI command 
> > mapping as long as possible.  And, in the suggested framework, it's 
> 
> Yes, that makes sense.
> 
> > guaranteed that no other command can come inbetween CHECK_SENSE and 
> > REQUEST_SENSE.
> 
> That's good.
> 
> >   Requesting sense from EH,
> 
> Done in an ATA eh handler.
> 
> > calling scsi_decide_disposition() on the 
> > sense 
> 
> Done in SCSI Core.
> 
> > and following the verdict should achieve the same effect as
> > emulating autosense.
> 
> Yes, precisely.
> 
> > Is there any compelling reason to break one qc to 
> > one command mapping?
> 
> ?
> 

 I wasn't clear enough.  I'll try again.  :-)

 As implementing autosensing will probably need rewriting failed qc
for REQUEST SENSE command, I'm opposing it.  My proposal is to do the
following, which, in effect, should be equivalent to autosensing.

 1. ATAPI CHECK SENSE occurs
 2. libata fails the command
 3. SCSI sees failure code but no sense data, SCSI EH invoked
 4. libata EH invoked
 5. REQUEST SENSE
 6. sense data acquired
 7. scsi_decide_disposition() called (this needs to be exported from SCSI)
 8. libata handles the failed qc according to the verdict.

 This is very similar to what SCSI EH currently does for commands
without sense data.

 As ATAPI device's queue depth is always one (ignoring SERVICE cruft
everyone seems to hate), I don't think there will be any noticeable
performance penalty as James was describing in the other mail in this
thread.

 Thanks.

-- 
tejun
