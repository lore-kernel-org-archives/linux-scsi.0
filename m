From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Date: Wed, 9 May 2012 04:25:27 -0400
Message-ID: <20120509082527.GA10674@infradead.org>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
 <4FAA02DA.3000201@gmail.com>
 <20120509061956.GA12329@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120509061956.GA12329@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Zheng Liu <wenqing.lz@taobao.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 09, 2012 at 02:19:56PM +0800, Zheng Liu wrote:
> disable FUA detection for SATA disk.  If FUA feature can be used, we
> could disable io_barrier to improve the performance.  Now one solution

You can't run with -o nobarrier just because the driver/hardware support
FUA.  However the implementation of -o barrier (aka REQ_FUA) is a lot
more efficient if it is implemented.  If your workload has a high
percentage of REQ_FUA requests it might be better to switch the disks to
write through mode entirely.

