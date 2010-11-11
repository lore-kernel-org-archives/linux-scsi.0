From: "jack_wang" <jack_wang@usish.com>
Subject: Re: Re: sd: Why we need to call sd_revalidate_disk twice in sd_probe_async
Date: Thu, 11 Nov 2010 08:31:55 +0800
Message-ID: <201011110831550629239@usish.com>
References: <014D70148ADE4E969B698514F7F6913E@usish.com.cn>,
 <yq1eiatzdw6.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:37428 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab0KKAbz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2010 19:31:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>


 
>>>>> "Jack" == Jack Wang <jack_wang@usish.com> writes:
Jack> I notice in sd.c, we call sd_revalidate_disk twice in function
Jack> sd_probe_async?  Are there some special reasons?
I'm traveling right now and don't have my scribbles. But my recollection
is that it's due to a quirk in the way things are registered with the
block layer. Some limits are hanging off of the request queue and some
off of struct gendisk.
For stacking purposes we need to set some queue defaults before we
register the gendisk. And then we do a second revalidate pass to get
everything in place after the gendisk has been set up. Alignment
offsets, for instance, need to be updated after the partition table has
been read.
So, yes. It is intentional that revalidate is called both before and
after add_disk().
If this causing you problems? And if so, why?


Hi, Martin

Thanks for explaination, I just curious about the duplicated call, No problems found.

Jack
-- 
Martin K. Petersen Oracle Linux Engineering


