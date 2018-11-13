From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 0/9] mpt3sas and dmapool scalability
Date: Mon, 12 Nov 2018 22:44:44 -0800
Message-ID: <20181113064444.GU21824@bombadil.infradead.org>
References: <88395080-efc1-4e7b-f813-bb90c86d0745@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <88395080-efc1-4e7b-f813-bb90c86d0745-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 12, 2018 at 10:40:57AM -0500, Tony Battersby wrote:
> I posted v3 on August 7.  Nobody acked or merged the patches, and then
> I got too busy with other stuff to repost until now.

Thanks for resending.  They were in my pile of things to look at, but
that's an ever-growing pile.

> I believe these patches are ready for merging.

I agree.

> cat /sys/devices/pci0000:80/0000:80:07.0/0000:85:00.0/pools
> (manually cleaned up column alignment)
> poolinfo - 0.1
> reply_post_free_array pool  1      21     192     1
> reply_free pool             1      1      41728   1
> reply pool                  1      1      1335296 1
> sense pool                  1      1      970272  1
> chain pool                  373959 386048 128     12064
> reply_post_free pool        12     12     166528  12

That reply pool ... 1 object of 1.3MB?  That's a lot of strain to put
on the page allocator.  I wonder if anything can be done about that.

(I'm equally non-thrilled about the sense pool, the reply_post_free pool
and the reply_free pool, but they seem a little less stressful than the
reply pool)
