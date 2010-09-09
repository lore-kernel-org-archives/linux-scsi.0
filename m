From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: 2.6.36-rc3: EIP is at scsi_init_io+...
Date: Thu, 09 Sep 2010 13:00:59 +0200
Message-ID: <4C88BE6B.6000006@fusionio.com>
References: <20100830184620.GA4818@core2.telecom.by> <AANLkTikyv10vkg1g+G3LW+nu=0omBpc40KehOUH=YXk2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46424 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab0IILBK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Sep 2010 07:01:10 -0400
In-Reply-To: <AANLkTikyv10vkg1g+G3LW+nu=0omBpc40KehOUH=YXk2@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 2010-09-09 02:12, Linus Torvalds wrote:
> Hmm. No noise about this one.
> 
> Jens, Fujita, James, any comments?
> 
> On Mon, Aug 30, 2010 at 11:46 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> Not much of a calltrace, it scrolled away because of hardlockup detector.
>> On the bright side, radeon KMS worked correctly and actually showed it.
>>
>> $ addr2line -e vmlinux ffffffff812d207b
>> drivers/scsi/scsi_lib.c:1015
>>
>>  1012  err_exit:
>>  1013          scsi_release_buffers(cmd);
>>  1014          scsi_put_command(cmd);
>>  1015  ===>    cmd->request->special = NULL; <===
>>  1016          return error;
>>  1017  }
>>  1018  EXPORT_SYMBOL(scsi_init_io);
> 
> I do have to say that it looks rather wrong that it accesses "cmd"
> after it has done the "scsi_put_command(cmd)" on it.
> 
> I also note that that was introduced pretty recently by commit
> 610a63498f7 ("scsi: fix discard page leak"), merged during this merge
> window. That does look suspicious to me.

Agree, that's clearly a bug. That assignment should just go away.

-- 
Jens Axboe

