From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
Date: Thu, 19 Jul 2007 09:02:50 -0500
Message-ID: <1184853770.3464.85.camel@localhost.localdomain>
References: <469C10F6.3050008@googlemail.com>
	 <20070717100921W.fujita.tomonori@lab.ntt.co.jp>
	 <469C1E2A.8010508@googlemail.com>
	 <20070719082516W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:53222 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937955AbXGSOCy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 10:02:54 -0400
In-Reply-To: <20070719082516W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: nix.or.die@googlemail.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org

On Thu, 2007-07-19 at 08:25 +0900, FUJITA Tomonori wrote:
> From: Gabriel C <nix.or.die@googlemail.com>
> Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
> Date: Tue, 17 Jul 2007 03:40:58 +0200
> 
> > FUJITA Tomonori wrote:
> > > From: Gabriel C <nix.or.die@googlemail.com>
> > > Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
> > > Date: Tue, 17 Jul 2007 02:44:38 +0200
> > >
> > >   
> > >> Gabriel C wrote:
> > >>     
> > >>> Hello,
> > >>>
> > >>> sdparm and hdparm are broken for me on git (
> > >>> abce891a10559343d8ac9f79b46d78afdba63a40 )
> > >>>
> > >>>
> > >>> ~$ sudo hdparm  /dev/sdc
> > >>>
> > >>> /dev/sdc:
> > >>>  BLKROGET failed: Inappropriate ioctl for device
> > >>>  BLKRAGET failed: Inappropriate ioctl for device
> > >>>  BLKGETSIZE failed: Inappropriate ioctl for device
> > >>>
> > >>>
> > >>> ~$ sudo sdparm  --all /dev/sdc
> > >>> unable to access /dev/sdc, ATA disk?
> > >>>
> > >>>   
> > >>>       
> > >> Well it is bsg , setting BLK_DEV_BSG=n fixed all this errors.
> 
> I've not tested this yet (need to find sata drives in my workplace),
> but James Bottomley told me that both works for him with bsg enabled.
> It might worth trying the latest git tree.

It certainly does work for me.  However, my ATA devices are connected to
an aic94xx SAS controller.  Although this uses libata, the ioctl path is
probably slightly different from the libata one. I assume you're using a
SATA controller?  Unfortunately I have no ability to test on a SATA
controller, but I'd suggest looking at the ioctl and REQ_BLOCK_PC paths
in libata for clues.

James


