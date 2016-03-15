From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RFC 0/2] mempool based chained scatterlist alloc/free
 api api
Date: Tue, 15 Mar 2016 16:12:03 -0700
Message-ID: <1458083523.2375.120.camel@HansenPartnership.com>
References: <1458081569-30953-1-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458081569-30953-1-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-03-15 at 15:39 -0700, Ming Lin wrote:
> From: Ming Lin <ming.l@ssi.samsung.com>
> 
> Hi list,
> 
> This moves the mempool based chained scatterlist alloc/free code from
> scsi_lib.c to lib/scatterlist.c.
> 
> So other drivers(for example, the under development NVMe over fabric 
> drivers) can also use it.
> 
> Ming Lin (2):
>   scatterlist: add mempool based chained SG alloc/free api
>   scsi: use the new chained SG api
> 
>  drivers/scsi/scsi_lib.c     | 129 ++----------------------------------
>  include/linux/scatterlist.h |  12 ++++
>  lib/scatterlist.c           | 156 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 175 insertions(+), 122 deletions(-)

I'd really rather this were a single patch so git can tell us the code
motion.  If you add in one patch and remove in another the code motion
trackers don't see it.

Secondly, you said "This copied code from scsi_lib.c to scatterlist.c
and modified it a bit" could you move in one patch and modify in
another, so we can see exactly what you're changing.

Thirdly, are you sure the pool structure for NVMe should be the same as
for SCSI?  We don't do buddy pools for 1,2 or 4 entry transactions in
SCSI just basically because of heuristics, but the packetised io
characteristics of NVMe make single entry lists more likely for it,
don't they?

James
