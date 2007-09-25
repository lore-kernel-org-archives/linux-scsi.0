From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 6/9] mpt fusion: error recovery improvements, andsynchronizing internal commands
Date: Mon, 24 Sep 2007 19:26:00 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709D92A3@NAMAIL4.ad.lsil.com>
References: <1190478152.3347.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35444 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbXIYB0I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2007 21:26:08 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1190478152.3347.25.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Saturday, September 22, 2007 10:23 AM,  James Bottomley wrote:

> 
> OK, I thought I'd wait here for the breakout, but in the meantime I
> tried to compile the first five patches, but they don't:
> 
>   CC [M]  drivers/message/fusion/mptscsih.o
> drivers/message/fusion/mptscsih.c: In function 'mptscsih_qcmd':
> drivers/message/fusion/mptscsih.c:1357: error: 'MPT_SCSI_HOST' has no
> member named 'resetPending'
> drivers/message/fusion/mptscsih.c: In function 'mptscsih_TMHandler':
> drivers/message/fusion/mptscsih.c:1554: error: 'MPT_ADAPTER' has no
> member named 'diagLock'
> ...

Its not going to compile if you didn't pull down all 6 patchs associated
to "error recovery improvements".   Those six patchs were divided by
sources.  Meaning patch 4 was mptbase.[h,c] changes, then patch5 was
mptctl.[c,h] changes, and so on.  So the changes assoicated for
mptscsich.c are in patch 8.   Since you didn't apply the 8th patch,
offcourse your going to get the errrors in mptscish.c.    All patchs 4-9
need to go togeather, as mentioned in the first patch 0.

> 
> The series can't be applied in this form, because if git bisect steps
> into the middle of this, the compile will break (and hence the
> bisection) and a lot of people will say a lot of nasty things.

> 
> A patch series really needs to be one patch per logical change (with
> other peoples' patches broken out) in a form that is separately
> compilable for each patch.  Additionally, with a separate 
> change log and
> summary (i.e. not four patches all saying "mpt fusion: error recovery
> improvements, and synchronizing internal commands").
>

I understand, and thats been going on for the past couple months,
starting with Sathya's patchs early August.   The changes associated
with the rewrite of internal commands, and errror recovery is rather
difficult to seperate due to many depandancies and new structure
changes, and my concerned risk of what small steps could introduce more
issues, so IMO, the least risk was jump starting you to the customer and
factory tested code. 
 
> I'll back all of this out; can you resend the series conforming to the
> above request?
> 

The first three patchs did conform that, which are:

1) adding usage of shost_priv and removing all the typecasting
2) Fixing sparse warnings
3) locking down ScsiLookup


Youve rejected the error recovery patchs, which is fair enough.  



