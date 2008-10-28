From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 13/13] dm-mpath: convert to request-based
Date: Tue, 28 Oct 2008 12:03:51 -0400 (EDT)
Message-ID: <20081028.120351.78702656.k-ueda@ct.jp.nec.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	<20080912.104727.38325381.k-ueda@ct.jp.nec.com>
	<807b3a220810240055g1dfa4deam3f6a90d6c58aac32@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <807b3a220810240055g1dfa4deam3f6a90d6c58aac32@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: nikanth@gmail.com
Cc: k-ueda@ct.jp.nec.com, linux-scsi@vger.kernel.org, knikanth@suse.de, linux-kernel@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, j-nomura@ce.jp.nec.com, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hi Nikanth,

On Fri, 24 Oct 2008 13:25:33 +0530, "Nikanth K" wrote:
> On Fri, Sep 12, 2008 at 8:17 PM, Kiyoshi Ueda wrote:
> > This patch converts dm-multipath target to request-based from bio-based.
> 
> Can we keep both the bio-based as well as request-based dm-multipath?

Why do you want to keep bio-based dm-multipath?
In the realistic environment, dm-multipath is usually the bottom
of the stacking devices.  So I think existing working configurations
are still possible with request-based dm-multipath.

If we keep both types of multipath targets, maintenance cost would
be doubled and additional user interface might be needed to specify
which type is used.  I can't see any major benefit worth paying
the cost of keeping bio-based dm-multipath.

I know dm developers sometimes use linear/error maps under multipath
just for testing purpose.  If that is your requirement, I can make
request-based targets for linear and error (e.g. named like linear_rq
and error_rq).

Thanks,
Kiyoshi Ueda
