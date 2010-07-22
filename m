From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: BUG at drivers/scsi/scsi_lib.c:1113
Date: Thu, 22 Jul 2010 13:39:17 +0300
Message-ID: <4C481FD5.4070509@gmail.com>
References: <4C47ED7B.1050709@gmail.com> <20100722173716.66264bef@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48212 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab0GVKj2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2010 06:39:28 -0400
In-Reply-To: <20100722173716.66264bef@notabene>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org

On 07/22/2010 10:37 AM, Neil Brown wrote:
> On Thu, 22 Jul 2010 09:04:27 +0200
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> Hello,
>>
>> I'm seeing this BUG while booting:
>>
>> EXT3-fs (md1): using internal journal
>> ------------[ cut here ]------------
>> kernel BUG at /home/l/latest/xxx/drivers/scsi/scsi_lib.c:1113!
> 
> You aren't the only one.
> https://bugzilla.kernel.org/show_bug.cgi?id=16275
> 
> 
>> I bisected it down to:
>> commit 74450be123b6f3cb480c358a056be398cce6aa6e
>> Author: Christoph Hellwig <hch@lst.de>
>> Date:   Fri Jun 18 11:53:43 2010 +0200
>>
>>     block: unify flags for struct bio and struct request
>>
>>     Remove the current bio flags and reuse the request flags for the
>> bio, too.
>>     This allows to more easily trace the type of I/O from the filesystem
>>     down to the block driver.  There were two flags in the bio that were
>>     missing in the requests:  BIO_RW_UNPLUG and BIO_RW_AHEAD.  Also I've
>>     renamed two request flags that had a superflous RW in them.
>>
>>     Note that the flags are in bio.h despite having the REQ_ name - as
>>     blkdev.h includes bio.h that is the only way to go for now.
>>
>>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>>     Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>>
>>
> 
> Thanks for doing that.
> 
> I suspect that problem is that "do_sync" and "do_barriers" in
> drivers/md/raid1.c are still 'bool' and should now be 'unsigned long'.
> 
> I'm not sure how wide '_Bool' is, but I'm guess it isn't wide enough.
> 
> Could you please try changing ever 'bool' in that file to 'unsigned long'
> and see if that fixes it?
> 

Please don't. This is really bad programming, and produces slower
code. You should do:

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 73cc74f..8bd1ecb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -787,7 +787,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	struct bio_list bl;
 	struct page **behind_pages = NULL;
 	const int rw = bio_data_dir(bio);
-	const bool do_sync = (bio->bi_rw & REQ_SYNC);
+	const bool do_sync = (bio->bi_rw & REQ_SYNC) != 0;
 	bool do_barriers;
 	mdk_rdev_t *blocked_rdev;
 
Boaz

> Thanks,
> NeilBrown
