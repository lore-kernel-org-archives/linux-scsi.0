From: Anton Altaparmakov <anton@tuxera.com>
Subject: Deadlock due to device removal - race condition in scsi/block layer?
Date: Sun, 30 Oct 2011 23:52:02 +0000
Message-ID: <F9300DCD-387B-481A-85B2-5ED30204CADC@tuxera.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

We have seen a deadlock when doing "unplug whilst writing" testing.

I have analysed is and what appears to be happening is this:

File system does read_mapping_page() which calls the file system readpage function which uses fs/buffer.c::end_buffer_async_read() as i/o completion handler for the buffers of the page.  In this case the block size is 1kiB and the PAGE_SIZE is 4kiB thus each page has four buffer_heads attached.  The ->readpage() completes and do_read_cache_page() then does lock_page() which goes to sleep whilst waiting for all the buffers to complete i/o which then causes end_buffer_async_read() to mark the page error or uptodate and to unlock the page.

However instead of the buffers completing, we only get one buffer completing with an error (due to the device having been unplugged before) and we then see this message in dmesg:

	[ 1155.264728] scsi: killing requests for dead queue

And that's it.  We now do NOT see the remaining buffers that had i/o in flight completing, i.e. end_buffer_async_read() was only called for one of the buffers but not for the others thus the page remains locked and thus do_read_cache_page() remains sleeping waiting for the page lock.

DEADLOCK.  )-:

120 seconds later the kernel starts printing the "task blocked for more than 120 seconds" reports which describe the above explained state.

Why are the i/o completions not happening?  It presumably is a direct consequence of the "scsi: killing requests for dead queue" message.

I looked around and the message appears to be coming from:

	drivers/scsi/scsi_lib.c::scsi_request_fn()

which at the top does:

	if (!sdev) {
               printk("scsi: killing requests for dead queue\n");
               while ((req = blk_peek_request(q)) != NULL)
                       scsi_kill_request(req, q);
               return;
       }

So I imagine either blk_peek_request() is buggy so it is not seeing all the requests or more likely scsi_kill_request() is somehow causing the completion handler not to be called or a combination of the two.

Note this was on a Debian Wheezy out-of-the-box kernel 3.0.0-1-686-pae and we have seen this happen only once so far which suggests that it is a race condition happening only when read_mapping_page() is called just at the "right" (or is that "wrong"? /-;) time when a device is unplugged so that the "scsi: killing requests for dead queue" happens in the middle of the i/os for the page buffers being in progress.

Any ideas would be greatly appreciated!

Thanks a lot in advance!

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
