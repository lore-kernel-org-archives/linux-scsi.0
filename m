From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 9/9] tcm_qla2xxx: Add special case for COMPARE_AND_WRITE
 data_direction
Date: Wed, 21 Aug 2013 10:52:48 -0700
Message-ID: <1377107568.32763.59.camel@haakon3.risingtidesystems.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
	 <1377029280-19144-10-git-send-email-nab@daterainc.com>
	 <CAL1RGDVSrf6++PMdfnAZAUw=QX0VbQ9Wck+v=7ebfc-_FXJ_NA@mail.gmail.com>
	 <20130821155314.GA17850@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20130821155314.GA17850@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Roland Dreier <roland@purestorage.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@parallels.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-08-21 at 08:53 -0700, Christoph Hellwig wrote:
> On Wed, Aug 21, 2013 at 07:38:21AM -0700, Roland Dreier wrote:
> > I don't understand this.  In fact the whole patch series looks quite
> > confused.  COMPARE AND WRITE is a normal Data-Out command, with no
> > requirement for special bidirectional handling or anything like that.
> > The only slightly unusual thing is that a CAW command with a NUMBER OF
> > LOGICAL BLOCKS equal to N will actually transfer 2*N worth of data --
> > one set of data for the compare operation and a second set to write if
> > the compare succeeds.  But just to be clear, the transfer of those 2*N
> > blocks happens as a single transfer during the Data-Out phase.
> 
> I think the confusion is that the implementation of COMPARE AND WRITE
> obviously requires a read and a write phase, and the implementation
> tries to mix this up with an actual bidirectional scsi command.
> 
> If the core stopped keying off t_bidi_data_sg and used better flag
> this could be easily solved.

Good point here as well..  Changing these cases to check for SCF_BIDI
instead, and adding a extra SCF_COMPARE_AND_WRITE check for the case in
transport_generic_new_cmd() to call transport_generic_get_mem_bidi().

--nab
