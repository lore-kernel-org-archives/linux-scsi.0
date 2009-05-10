From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] scsi: add scsi_device->alt_capacity
Date: Sun, 10 May 2009 10:26:48 +0900
Message-ID: <4A062D58.6030401@kernel.org>
References: <1241828002-12742-1-git-send-email-tj@kernel.org>	 <1241828002-12742-3-git-send-email-tj@kernel.org>	 <1241842999.6357.2.camel@mulgrave>  <4A05AAA4.9010806@kernel.org> <1241886223.3542.37.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:43691 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbZEJB2N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 May 2009 21:28:13 -0400
In-Reply-To: <1241886223.3542.37.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Mauelshagen@RedHat.com, dm-devel@RedHat.com, dan.j.williams@gmail.com

Hello, James.

James Bottomley wrote:
> On Sun, 2009-05-10 at 01:09 +0900, Tejun Heo wrote:
>> James Bottomley wrote:
>>> This is done at slightly the wrong level.  Capacity is actually a
>>> property of struct scsi_disk not struct scsi_device ... shouldn't
>>> alt_capacity be at the same level?
>> Hmmm... I think that was my first try and then I moved it to sdev for
>> some reason I can't rememer now.  I'll look into it again and try to
>> move it into sdev.
> 
> Really one of the things I was wondering is why even scsi_disk ...
> capacity is in there, but it's also in gendisk, so I've thought
> (admittedly never translated it to action) that we could just remove the
> duplication in scsi_disk.
> 
> This alt_capacity looks to be a pure ATA thing...  I can't find it
> in the SCSI specs and there doesn't seem to be a SAT equivalent of
> the commands.  Ideally, what should be happening is that the ata ULD
> would issue the capacity commands and just set the block
> alt_capacity without having to worry about transporting the value up
> and down the stack.  Matthew Wilcox thought we could begin an
> implementation of the ATA uld using the ATA_16 command to transport
> it through SCSI ... this might provide the good reason to begin
> that.

Yeap, it's a purely ATA specific workaround.

Now I remembered what was the problem.  The problem was that the
latest hook libata can use is ->slave_configure which is called before
HLD attaches, so there's no sdkp or genhd associated during libata
configuration.  Longer term, this definitely is something which should
be stripped out of SCSI whether that happens with ATA HLD on top of
SCSI or a completely separate stack.  Any better ideas on how to work
around this for now?

Thanks.

-- 
tejun
