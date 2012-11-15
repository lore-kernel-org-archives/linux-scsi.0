From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/3] target: Add max_write_same_len device attribute
Date: Thu, 15 Nov 2012 11:23:12 -0800
Message-ID: <1353007392.4447.22.camel@haakon2.linux-iscsi.org>
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>
	 <1352405238-23267-3-git-send-email-nab@linux-iscsi.org>
	 <20121115105312.GC28956@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121115105312.GC28956@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-11-15 at 05:53 -0500, Christoph Hellwig wrote:
> On Thu, Nov 08, 2012 at 08:07:17PM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds a new max_write_same_len device attribute for use with
> > WRITE_SAME w/ UNMAP=0 backend emulation.
> > 
> > Also, update block limits VPD emulation code in spc_emulate_evpd_b0() to
> > set the default MAXIMUM WRITE SAME LENGTH value of zero.
> 
> why do we need an exposed attribute for this?
> 

This is useful for userspace to reduce the allowed maximum from the
default 0xFFFF set by IBLOCK.  Allowing huge WRITE_SAMEs can very much
effect performance (esp. with spinning media), so being able to reduce
the max we accept via a userspace tunable is helpful.

--nab
