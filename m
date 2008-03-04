From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 04 Mar 2008 21:40:53 +0900
Message-ID: <47CD4355.4050401@gmail.com>
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp>	 <20080304085944.GG6704@kernel.dk>	 <20080304180648W.fujita.tomonori@lab.ntt.co.jp>	 <20080304182228Z.fujita.tomonori@lab.ntt.co.jp>	 <20080304093536.GH6704@kernel.dk> <1204634238.5997.5.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.182]:61118 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135AbYCDMlD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 07:41:03 -0500
Received: by el-out-1112.google.com with SMTP id v27so1031043ele.17
        for <linux-scsi@vger.kernel.org>; Tue, 04 Mar 2008 04:41:02 -0800 (PST)
In-Reply-To: <1204634238.5997.5.camel@homer.simson.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

Mike Galbraith wrote:
> On Tue, 2008-03-04 at 10:35 +0100, Jens Axboe wrote:
> 
>> Looks excellent to me, has a variant of this been tested as OK by the
>> users reporting the regression?
> 
> K3b burning seems to be a nogo here.  This is git pulled this morning
> though, so it's a somewhat different tree than previously tested fwtw.
> 
> [  136.440021] ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> [  136.440043] ata1.01: cmd a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
> [  136.440045]          cdb 51 00 00 00 00 00 00 00  02 00 00 00 00 00 00 00
> [  136.440047]          res 58/00:02:00:02:00/00:00:00:00:00/b0 Emask 0x2 (HSM violation)
> [  136.440053] ata1.01: status: { DRDY DRQ }
> [  136.440086] ata1: soft resetting link
> [  165.327627] ata1.01: qc timeout (cmd 0xa1)
> [  165.327627] ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  165.327627] ata1.01: revalidation failed (errno=-5)
> [  165.327627] ata1: failed to recover some devices, retrying in 5 secs
> [  177.272373] ata1: port is slow to respond, please be patient (Status 0x80)
> [  180.388879] ata1: device not ready (errno=-16), forcing hardreset
> [  180.388879] ata1: soft resetting link
> [  210.832471] ata1.01: qc timeout (cmd 0xa1)
> [  210.832471] ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  210.832471] ata1.01: revalidation failed (errno=-5)
> [  210.832471] ata1: failed to recover some devices, retrying in 5 secs
> [  223.392899] ata1: port is slow to respond, please be patient (Status 0x80)
> [  225.920376] ata1: device not ready (errno=-16), forcing hardreset
> [  225.920376] ata1: soft resetting link
> [  256.542565] ata1.01: qc timeout (cmd 0xa1)
> [  256.542565] ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  256.542565] ata1.01: revalidation failed (errno=-5)
> [  256.542565] ata1.01: disabled

Aiee... device going down after timing out on READ_DISC_INFO.  That's
gruesome.  Can you please try the other patches?

Thanks.

-- 
tejun
