From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [RFC] libata new EH document
Date: Wed, 31 Aug 2005 21:38:49 -0700 (PDT)
Message-ID: <20050901043850.15186.qmail@web51611.mail.yahoo.com>
References: <20050901034429.GA3418@htj.dyndns.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web51611.mail.yahoo.com ([68.142.224.84]:594 "HELO
	web51611.mail.yahoo.com") by vger.kernel.org with SMTP
	id S932543AbVIAEiy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Sep 2005 00:38:54 -0400
In-Reply-To: <20050901034429.GA3418@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Albert Lee <albertcc@tw.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Doug Maxey <dwm@maxeymade.com>

--- Tejun Heo <htejun@gmail.com> wrote:
>  As implementing autosensing will probably need rewriting failed qc
> for REQUEST SENSE command, I'm opposing it.  My proposal is to do the
> following, which, in effect, should be equivalent to autosensing.
> 
>  1. ATAPI CHECK SENSE occurs
>  2. libata fails the command
>  3. SCSI sees failure code but no sense data, SCSI EH invoked
>  4. libata EH invoked
>  5. REQUEST SENSE
>  6. sense data acquired
>  7. scsi_decide_disposition() called (this needs to be exported from SCSI)
>  8. libata handles the failed qc according to the verdict.

Hmm, yes.  It sounds good, except can you make it so that step 3
doesn't exist, ever.  This means that you would _reduce_ the
double "bouncing" between eh's _and_ implement autosense.

SCSI Core should never know what happened.  I.e. if the command
has completed with CHECK SENSE, sense data _is_ present => "autosense".

> This is very similar to what SCSI EH currently does for commands
> without sense data.

Yes, you're right -- it is very similar to what SCSI EH currently does.
Unfortunately it isn't quite correct.

>  As ATAPI device's queue depth is always one (ignoring SERVICE cruft
> everyone seems to hate), I don't think there will be any noticeable
> performance penalty as James was describing in the other mail in this
> thread.

What you can do is keep a qc around to request sense immediately
afterwards.  If _that_ qc fails, then you know you need the big hammer.

      Luben

