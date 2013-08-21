From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/9] target: Allow sbc_ops->execute_rw() to accept SGLs +
 data_direction
Date: Tue, 20 Aug 2013 23:35:24 -0700
Message-ID: <20130821063524.GH25506@infradead.org>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
 <1377029280-19144-7-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1377029280-19144-7-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 20, 2013 at 08:07:57PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@daterainc.com>
> 
> COMPARE_AND_WRITE expects to be able to send down a DMA_FROM_DEVICE
> to obtain the necessary READ payload for comparision against the
> first half of the WRITE payload containing the verify user data.
> 
> Currently virtual backends expect to internally reference SGLs,
> SGL nents, and data_direction, so change IBLOCK, FILEIO and RD
> sbc_ops->execute_rw() to accept this values as function parameters.
> 
> Also add the sbc_execute_rw() wrapper to handle the special case
> for the initial COMPARE_AND_WRITE DMA_FROM_DEVICE -> READ I/O
> submission.

I don't like the way this is structured with the new method.  It seems
like we should just pass the sgl and associated data to execute_cmd
and have the read vs write logic driven by command code, using generic
flags instead of specificly checking for compare and write.
