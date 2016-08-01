From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v6 0/2] Block layer support ZAC/ZBC commands
Date: Mon, 1 Aug 2016 12:07:41 -0500
Message-ID: <CAJVOszCAb4o5LWpJL8Yd66n9jPvy+EMQX2Xfr6awZCxfGJf_CA@mail.gmail.com>
References: <1469818955-20568-1-git-send-email-shaun@tancheff.com> <20160801094116.GB14677@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:12291 "EHLO
	mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754160AbcHARIm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Aug 2016 13:08:42 -0400
Received: from pps.filterd (m0075032.ppops.net [127.0.0.1])
	by mx0b-00003501.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u71H6nu7045402
	for <linux-scsi@vger.kernel.org>; Mon, 1 Aug 2016 13:08:01 -0400
Received: from mail-ua0-f200.google.com (mail-ua0-f200.google.com [209.85.217.200])
	by mx0b-00003501.pphosted.com with ESMTP id 24j7jqryge-23
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2016 13:08:01 -0400
Received: by mail-ua0-f200.google.com with SMTP id n59so177385193uan.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2016 10:08:01 -0700 (PDT)
In-Reply-To: <20160801094116.GB14677@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Josh Bingaman <josh.bingaman@seagate.com>, Hannes Reinecke <hare@suse.de>, Damien Le Moal <damien.lemoal@hgst.com>

On Mon, Aug 1, 2016 at 4:41 AM, Christoph Hellwig <hch@lst.de> wrote:
>
> Can you please integrate this with Hannes series so that it uses
> his cache of the zone information?

Adding Hannes and Damien to Cc.

Christoph,

I can make a patch the marshal Hannes' RB-Tree into to a block report, that is
quite simple. I can even have the open/close/reset zone commands update the
RB-Tree .. the non-private parts anyway. I would prefer to do this around the
CONFIG_SD_ZBC support, offering the existing type of patch for setups that do
not need the RB-Tree to function with zoned media.

I do still have concerns with the approach which I have shared in smaller
forums but perhaps I have to bring them to this group.

First is the memory consumption. This isn't really much of a concern for large
servers with few drives but I think the embedded NAS market will grumble as
well as the large data pods trying to stuff 300+ drives in a chassis.

As of now the RB-Tree needs to hold ~30000 zones.
sizeof() reports struct blk_zone to use 120 bytes on x86_64. This yields
around 3.5 MB per zoned drive attached.
Which is fine if it is really needed, but most of it is fixed information
and it can be significantly condensed (I have proposed 8 bytes per zone held
in an array as more than adequate). Worse is that the crucial piece of
information, the current wp needed for scheduling the next write, is mostly
out of date because it is updated only after the write completes and zones
being actively written to must work off of the last location / size that was
submitted, not completed. The work around is for that tracking to be handled
in the private_data member. I am not saying that updating the wp on
completing a write isn’t important, I am saying that the bi_end_io hook is
the existing hook that works just fine.

This all tails into domain responsability. With the RB-Tree doing half of the
work and the ‘responsible’ domain handling the active path via private_data
why have the split at all? It seems to be a double work to have second object
tracking the first so that I/O scheduling can function.

Finally is the error handling path when the RB-Tree encounters and error it
attempts to requery the drive topology virtually guaranteeing that the
private_data is now out-of-sync with the RB-Tree. Again this is something
that can be better encapsulated in the bi_end_io to be informed of the
failed I/O and schedule the appropriate recovery (including re-querying the
zone information of the affected zone(s)).

Anyway those are my concerns and why I am still reluctant to drop this line of
support. I have incorporated Hannes changes at various points. Hence the
SCT Write Same to attempt to work around some of the flaws in mapping
discard to reset write pointer.

Thanks and Regards,
Shaun

> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=CwIBAg&c=IGDlg0lD0b-nebmJJ0Kp8A&r=Wg5NqlNlVTT7Ugl8V50qIHLe856QW0qfG3WVYGOrWzA&m=0ZPyN4vfYZXSmuCmIm3wpExF1K28PYO9KmgcqDsfQBg&s=aiguzw5_op7woZCZ5Qi7c36b16SxiWTJXshN0dG3Xyo&e=



-- 
Shaun Tancheff
