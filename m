From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 11/13] dm: enable request-based dm
Date: Tue, 28 Oct 2008 12:02:27 -0400 (EDT)
Message-ID: <20081028.120227.104028516.k-ueda@ct.jp.nec.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	<20080912.104634.08318008.k-ueda@ct.jp.nec.com>
	<807b3a220810240052n6a8b41b0x1ea9c88124b3f5f8@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <807b3a220810240052n6a8b41b0x1ea9c88124b3f5f8@mail.gmail.com>
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

On Fri, 24 Oct 2008 13:22:46 +0530, "Nikanth K" wrote:
> On Fri, Sep 12, 2008 at 8:16 PM, Kiyoshi Ueda wrote:
> > This patch enables request-based dm.
> >
> > o Request-based dm and bio-based dm coexist, since there are
> >  some target drivers which are more fitting to bio-based dm.
> >  Also, there are other bio-based devices in the kernel
> >  (e.g. md, loop).
> >  Since bio-based device can't receive struct request,
> >  there are some limitations on device stacking between
> >  bio-based and request-based.
> >
> >                     type of underlying device
> >                   bio-based      requeset-based
> >   ----------------------------------------------
> >    bio-based         OK                OK
> >    request-based     NG                OK
> >
> 
> So will some configurations would become impossible, if a target is
> made request-based and bio-based one is removed. Hope both
> types of targets would co-exist and would be selectable for sometime.

If the target is used anywhere in the device stack (e.g. linear),
both types of the target are needed, and that is possible.

As for multipath, see my another reply to your comment for PATCH 13.

Thanks,
Kiyoshi Ueda
