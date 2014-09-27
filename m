From: Matias Bjorling <m@bjorling.me>
Subject: Re: blk-mq, scsi-mq, UFS
Date: Sat, 27 Sep 2014 19:42:42 +0200
Message-ID: <5426F712.3010501@bjorling.me>
References: <loom.20140927T001325-865@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:48691 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaI0Rmq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Sep 2014 13:42:46 -0400
Received: by mail-la0-f43.google.com with SMTP id gb8so6525530lab.16
        for <linux-scsi@vger.kernel.org>; Sat, 27 Sep 2014 10:42:44 -0700 (PDT)
In-Reply-To: <loom.20140927T001325-865@post.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andras Kovacs <neoteny@freemail.hu>, linux-scsi@vger.kernel.org

On 09/27/2014 12:14 AM, Andras Kovacs wrote:
> Hi all,
>
> could someone explain to me:
>
> - what is the difference between blk-mq and scsi-mq

blk-mq is the actual block layer, while scsi-mq enables the scsi 
subsystem to use blk-mq. Any driver that wish to use blk-mq, has to 
explicit hook into it.

> - why don't I observe large speedups when running the same tiotests on Linux
> v3.12 (which has no blk-mq) and Linux v3.14 (which does have blk-mq) on a
> Xilinx Zynq development board (the two Linux versions are configured by
> Xilinx Zynq and I know only how to add kernel command line parameters)?

Only the virtio driver (and the null blk driver) have been converted to 
blk-mq in 3.14.

> - when Linux v3.17 becomes available (and Xilinx Zynq ports it for their
> development board) will I see large speedups reading/writing to the target
> SDD (which is driven through the UFS driver)?

Depends if you're CPU bound. If you are, then a speedup is expected. You 
will at least see lower CPU usage.

scsi-mq has to be explicit enabled with the scsi_mod.use_blk_mq=Y in the 
kernel boot options for 3.17 until it is marked stable.

>
> Any and all info would be greatly appreciated.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

