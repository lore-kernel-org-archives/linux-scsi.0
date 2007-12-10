From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 27/28] blk_end_request: changing scsi
 mid-layer for bidi (take 3)
Date: Mon, 10 Dec 2007 14:32:50 -0500 (EST)
Message-ID: <20071210.143250.39153367.k-ueda@ct.jp.nec.com>
References: <4757BFDC.6090502@panasas.com>
	<20071206.144417.41628995.k-ueda@ct.jp.nec.com>
	<475BB8C3.9040700@panasas.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <475BB8C3.9040700@panasas.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bharrosh@panasas.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Hi Boaz,

On Sun, 09 Dec 2007 11:43:31 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> >>> Index: 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
> <snip>
> >> No I don't like it. The only client left for blk_end_request_callback()
> >> is bidi,
> > 
> > ide-cd (cdrom_newpc_intr) is another client.
> > So I can't drop blk_end_request_callback() even if bidi doesn't use it.
>
> It looks like all is needed for the ide-cd case is a flag that says
> "don't complete the request". And the call-back is not actually used.
> (Inspecting the last: [PATCH 26/28] blk_end_request: changing ide-cd (take 3))
> The same exact flag could also help the bidi case. Perhaps have an API
> for that?

Thank you for looking at the ide-cd part, too.

But, no, I don't want to add the "don't complete" flag to the API.
It could be an alternative, but having such a flag explicitly may blur
the purpose of the blk_end_reuqest interfaces, which drivers give over
the ownership of the request to the block-layer when calling
blk_end_request interfaces.
(With such a flag, the API looks like explicitly allowing drivers
 to have the ownership of the request even after the API is called,
 and it is like end_that_request_chunk().)
And the API also looks easy to use for drivers and it might help
to make other tricky drivers in the future.

I would like to go with the callback API, since the usege in ide-cd
shows that the driver is very tricky and the API can be used for
other requirements like "a driver wants to do something after data
completion and before request completion."


> > Index: 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
> > ===================================================================
> > --- 2.6.24-rc3-mm2.orig/drivers/scsi/scsi_lib.c
> > +++ 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
> > @@ -629,28 +629,6 @@ void scsi_run_host_queues(struct Scsi_Ho
> >  		scsi_run_queue(sdev->request_queue);
> >  }
> >  
snip
> > +int blk_end_request(struct request *rq, int uptodate, int nr_bytes)
> > +{
> > +	return blk_end_io(rq, uptodate, nr_bytes, 0, NULL);
> > +}
> >  EXPORT_SYMBOL_GPL(blk_end_request);
> >  
> 
> All above looks fine, thanks.

OK, I'll update the patch-set using the bidi API and blk_end_io().
I'm currently updating the patch-set based on 2.6.24-rc4, not -mm.
So the new patch-set will include the blk_end_bidi_request() API
but not the scsi bidi changes.

Thanks,
Kiyoshi Ueda
