From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] storvsc: do not assume SG list is continuous when doing
 bounce buffers (for 4.1 stable only)
Date: Tue, 22 Aug 2017 19:11:04 +0000
Message-ID: <MWHPR21MB0190D1C8C3FAF25AE283ABCFCE840@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <1503379905-18908-1-git-send-email-longli@exchange.microsoft.com>
 <20170822062841.GA1061@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170822062841.GA1061@infradead.org>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

 
> Wouldn't it make sense to backport the changes to set the virt_boundary
> (which probably still is the SG_GAPS flag in such an old kernel)?

We can make storvsc use SG_GAPS. But the following patch is missing in 4.1 stable block layer to make this work on some I/O situations. Backporting is more difficult and affect other code.

commit 5e7c4274a70aa2d6f485996d0ca1dad52d0039ca
Author: Jens Axboe <axboe@fb.com>
Date:   Thu Sep 3 19:28:20 2015 +0300

    block: Check for gaps on front and back merges
    
    We are checking for gaps to previous bio_vec, which can
    only detect back merges gaps. Moreover, at the point where
    we check for a gap, we don't know if we will attempt a back
    or a front merge. Thus, check for gap to prev in a back merge
    attempt and check for a gap to next in a front merge attempt.
    
    Signed-off-by: Jens Axboe <axboe@fb.com>
    [sagig: Minor rename change]
    Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
