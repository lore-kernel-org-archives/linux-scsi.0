From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 9/9] tcm_qla2xxx: Add special case for COMPARE_AND_WRITE
 data_direction
Date: Wed, 21 Aug 2013 00:31:07 -0700
Message-ID: <1377070267.32763.26.camel@haakon3.risingtidesystems.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
	 <1377029280-19144-10-git-send-email-nab@daterainc.com>
	 <20130821063702.GI25506@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20130821063702.GI25506@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-08-20 at 23:37 -0700, Christoph Hellwig wrote:
> On Tue, Aug 20, 2013 at 08:08:00PM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@daterainc.com>
> > 
> > Add a special case for COMPARE_AND_WRITE for the reverse data direction
> > mapping used for pci_map_sg() + friends.
> 
> A low level driver is an even worse place to hardcode a specific cdb
> opcode.  As written before this should be done by a flag on the command.
> 

Which means adding another COMPARE_AND_WRITE specific flag to
se_cmd_flags_Table, as the SCF_COMPARE_AND_WRITE_POST is ony set after
the comparsion of the verify instance data is complete..

Is it really worth having two se_cmd_flags for COMPARE_AND_WRITE..?

> Also it might make sense to lift this helper to get a dma direction from
> a command into common code.
> 

Mmm, perhaps.  I don't recall of the top of my head why tcm_qla2xxx
actually needed to reverse it's dma direction (I'm sure that Roland
knows, CC'ed), but IIRC it was a tcm_qla2xxx specific thing..?

--nab
