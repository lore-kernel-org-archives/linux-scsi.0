From: Nicolai Stange <nicstange@gmail.com>
Subject: Re: [PATCH] sd: make ->no_write_same independent of reported ->max_ws_blocks
Date: Tue, 06 Dec 2016 09:08:19 +0100
Message-ID: <87lgvteaz0.fsf@gmail.com>
References: <20161205235638.11539-1-nicstange@gmail.com>
        <yq1d1h5viob.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:32887 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbcLFIIX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2016 03:08:23 -0500
In-Reply-To: <yq1d1h5viob.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
        message of "Mon, 05 Dec 2016 22:29:56 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nicolai Stange <nicstange@gmail.com>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hello Martin,

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>>>>>> "Nicolai" == Nicolai Stange <nicstange@gmail.com> writes:
> Nicolai> Due to reported problems with Write Same on ATA devices, commit
> Nicolai> 0ce1b18c42a5 ("libata: Some drives failing on SCT Write Same")
> Nicolai> strived to report non-support for Write Same on non-zoned ATA
> Nicolai> devices.
>
> Nicolai> However, due to the following control flow in
> Nicolai> sd_config_write_same() this doesn't always take effect, namely
> Nicolai> if the ->max_ws_blocks as set in the by the ATA Identify Device
> Nicolai> exceeds SD_WS10_BLOCKS:
>
> I'd much prefer for libata to set no_write_same = 1 for non-ZAC devices.

Or just try it once and let the sd layer, i.e. sd_done(), disable it
once a ILLEGAL COMMAND OPCODE is reported. This works right now and as
you said below, calling code must cope gracefully with a failing Write
Same anyway (which doesn't work right now).

>
> Older SCSI devices have no way to explicitly report that WRITE SAME is
> supported. So the heuristic is the way it is to permit trying WRITE SAME
> unless no_write_same has been set by the device driver.

Ok, I didn't see that there might be a heuristic going on.

I've got a couple of questions about this, but they're mainly out of
curiosity. So feel free to ignore them.

1.) Do these older SCSI devices have a way to report ->max_ws_blocks?
    Because otherwise the heuristic would not work?
    Or is it set speculatively somewhere?

2.) If so, what about such older devices having
    0 < ->max_ws_blocks < SD_MAX_WS10_BLOCKS ?
    Wouldn't these also be suitable candidates for trying that
    heuristic on?

3.) Those older devices that have ->max_ws_blocks > SD_MAX_WS10_BLOCKS
    but ->ws16 == ->ws10 == 0, i.e. the heuristicated ones would
    always be given WRITE_SAME, not WRITE_SAME_16 commands?
    C.f. sd_setup_write_same_cmnd(): if ->ws16 is not set, do
    WRITE_SAME. Isn't this a little bit odd given that the reported 
    ->max_ws_blocks would be greater than SD_MAX_WS10_BLOCKS?
    Ok, given that these devices are older anyway, WRITE_SAME seems
    like the obvious choice to be made over WRITE_SAME_16. Which
    brings me back to question 2.).

    The answer to this question would possibly affect ATA devices with
    this heuristic going on as well: according to ata_scsiop_maint_in(),
    they would only support WRITE_SAME_16, but not WRITE_SAME.

    Heck, this is perhaps the reason why I'm seeing those errors this
    commit 0ce1b18c42a5 ("libata: Some drives failing on SCT Write
    Same") effectively turns the heuristics for my ATA device on,
    i.e. unsets ->ws16, resulting in WRITE_SAME's which are unsupported
    by libata-scsi, c.f. ata_get_xlat_func()...

>
> Nicolai> Since commit e73c23ff736e ("block: add async variant of
> Nicolai> blkdev_issue_zeroout"), blkdev_issue_zeroout() got a little bit
> Nicolai> more sensitive towards failing Write Sames on devices that
> Nicolai> claim to support them and this results in messages like
>
> That's something that needs to be addressed. blkdev_issue_zeroout() must
> cope with WRITE SAME failing and fall back to a manual zeroout.

That's very useful information! So this commit really needs a fixup in
either way.


Thank you!

Nicolai
