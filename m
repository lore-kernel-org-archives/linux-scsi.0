From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: READ CAPACITY 16
Date: Thu, 18 Dec 2008 07:08:51 -0700
Message-ID: <20081218140851.GI19967@parisc-linux.org>
References: <20081217164210.GC19967@parisc-linux.org> <da824cf30812170950p393be2fq729e98e93edef5dc@mail.gmail.com> <20081217180640.GE19967@parisc-linux.org> <494A1272.8040008@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33215 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYLROIw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 09:08:52 -0500
Content-Disposition: inline
In-Reply-To: <494A1272.8040008@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org

On Thu, Dec 18, 2008 at 11:05:54AM +0200, Boaz Harrosh wrote:
> Matthew Wilcox wrote:
> >>> Algorithm B:
> >>>
> >>> Issue RC10
> >>> Issue RC16
> >>>  -> If it succeeds, use its results in preference to those from RC10
> >>>  -> If it fails, carry on with the results from RC10
> >>>  -> If it times out, reset the device, carry on with the results from RC10
> >> I fail to see an effective difference between Algo A and B.
> > 
> > Whether to issue an RC10 before issuing an RC16 or not.  It matches what
> > we currently do better (we currently issue an RC10 and then issue an
> > RC16 if RC10 reports we have 0xffffffff LBAs).
> > 
> 
> Sorry to barge in but I think this is the most practical solution and the one
> to go to T10 with.
> 
> If a (new) device supports RC16 it should return LBAs==0xffffffff for RC10 even
> if it's capacity is smaller, to indicate an RC16 request.

That breaks compatibility with older software that doesn't know that
RC16 exists.

> If LBAs!=0xffffffff and !SCSI_3 then do not risk RC16 unless a white list
> or load parameter.
> 
> Since you are going to T10 with this the white list should be, as you said
> in other mail, zero length.

I don't need to go to T10 for anything except Algorithm D.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
