From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 6/7] blk_end_request: remove/unexport
	end_that_request_*
Date: Tue, 04 Sep 2007 19:13:18 -0400 (EDT)
Message-ID: <20070904.191318.23007091.k-ueda@ct.jp.nec.com>
References: <20070831.184335.85683085.k-ueda@ct.jp.nec.com>
	<E472128B1EB43941B4E7FB268020C89B02992D9B@riverside.int.panasas.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E472128B1EB43941B4E7FB268020C89B02992D9B@riverside.int.panasas.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bhalevy@panasas.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, linux-ide@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Hi,

On Tue, 4 Sep 2007 17:25:14 -0400, "Halevy, Benny" <bhalevy@panasas.com> wrote:
> We suspect we'll still need the extern entry points for handling the bidi 
> request in the scsi_io_completion() path as we only want to call
> end_that_request_chunk on req->next_rq and never
> end_that_request_last.
>  
> (see 
> http://www.bhalevy.com/open-osd/download/linux-2.6.23-rc2_and_iscsi-iscsi-2007_08_09/0005-SCSI-bidi-support.patch)

If this patch-set is merged, there may be other way to do that.

For tricky drivers, special interface, blk_end_request_callback(),
is added in the patch 5/7.
(http://marc.info/?l=linux-kernel&m=118860027714753&w=2)
Currently, only user of the interface is ide-cd (cdrom_newpc_intr()).
It needs to call only end_that_request_first() too.

With the patch 7/7, you can set your own handler in rq->end_io()
to complete the request by your own way.

Thanks,
Kiyoshi Ueda
