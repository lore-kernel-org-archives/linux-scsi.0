From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] tcm_qla2xxx: Add special case for COMPARE_AND_WRITE
 data_direction
Date: Wed, 21 Aug 2013 08:53:14 -0700
Message-ID: <20130821155314.GA17850@infradead.org>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
 <1377029280-19144-10-git-send-email-nab@daterainc.com>
 <CAL1RGDVSrf6++PMdfnAZAUw=QX0VbQ9Wck+v=7ebfc-_FXJ_NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDVSrf6++PMdfnAZAUw=QX0VbQ9Wck+v=7ebfc-_FXJ_NA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 21, 2013 at 07:38:21AM -0700, Roland Dreier wrote:
> I don't understand this.  In fact the whole patch series looks quite
> confused.  COMPARE AND WRITE is a normal Data-Out command, with no
> requirement for special bidirectional handling or anything like that.
> The only slightly unusual thing is that a CAW command with a NUMBER OF
> LOGICAL BLOCKS equal to N will actually transfer 2*N worth of data --
> one set of data for the compare operation and a second set to write if
> the compare succeeds.  But just to be clear, the transfer of those 2*N
> blocks happens as a single transfer during the Data-Out phase.

I think the confusion is that the implementation of COMPARE AND WRITE
obviously requires a read and a write phase, and the implementation
tries to mix this up with an actual bidirectional scsi command.

If the core stopped keying off t_bidi_data_sg and used better flag
this could be easily solved.
