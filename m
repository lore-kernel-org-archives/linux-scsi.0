From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: sd: Why we need to call sd_revalidate_disk twice in sd_probe_async
Date: Wed, 10 Nov 2010 05:11:53 -0500
Message-ID: <yq1eiatzdw6.fsf@sermon.lab.mkp.net>
References: <014D70148ADE4E969B698514F7F6913E@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:33865 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab0KJKMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2010 05:12:19 -0500
In-Reply-To: <014D70148ADE4E969B698514F7F6913E@usish.com.cn> (Jack Wang's
	message of "Wed, 10 Nov 2010 15:21:22 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, martin.petersen@oracle.com

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

-- 
Martin K. Petersen	Oracle Linux Engineering
