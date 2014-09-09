From: Tejun Heo <tj@kernel.org>
Subject: Re: WARNING in block layer triggered in 3.17-rc3
Date: Wed, 10 Sep 2014 00:17:26 +0900
Message-ID: <20140909151726.GA8890@mtj.dyndns.org>
References: <20140909011945.GD11706@mtj.dyndns.org>
 <Pine.LNX.4.44L0.1409091026470.1677-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1409091026470.1677-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Shirish Pargaonkar <shirishpargaonkar@gmail.com>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello, Alan.

On Tue, Sep 09, 2014 at 11:08:22AM -0400, Alan Stern wrote:
> Sorry, the meaning wasn't clear.  I meant that the existing code 
> doesn't work.  The patch seems to work okay (except that I can't use 
> queue_flag_test_and_set because the queue isn't locked at that point).  
> I'll submit the patch shortly.

Given it's fully synchronized, the following should work fine and
probably is less misleading than using atomic test_and_set.

	if (!blk_queue_init_done) {
		queue_flag_set_unlocked(QUEUE_FLAG_INIT_DONE, q);
		blk_queue_bypass_end(q);
	}

Thanks.

-- 
tejun
