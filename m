From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: fix large I/O regression with iSER in 4.4+ V2
Date: Tue, 12 Apr 2016 07:13:23 -0700
Message-ID: <1460470405-11673-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Since iSER was converted to use the generic virt_boundary mechanism
(which was called something else in 4.4), it didn't handle the case
where a request is using up the full size of max_hw_segments, but
not actually aligned to the virt boundary.  This series sets the
maximum segment size limit to fix this workload (xfs_repair is a good
reproducer, btw).

Should probably go into 4.4 and 4.5-stable.

Changes since V1:
 - use min_not_zero
 - use SIZE_4K instead of PAGE_SIZE in iser

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
