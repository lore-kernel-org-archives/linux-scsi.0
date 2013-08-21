From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 8/9] target: Add support for COMPARE_AND_WRITE emulation
Date: Wed, 21 Aug 2013 10:47:29 -0700
Message-ID: <1377107249.32763.54.camel@haakon3.risingtidesystems.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
	 <1377029280-19144-9-git-send-email-nab@daterainc.com>
	 <20130821161408.GB30848@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130821161408.GB30848@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-08-21 at 09:14 -0700, Christoph Hellwig wrote:
> I don't like the layering here.  The re-execution of the same command
> for both reading and writing the data from/to the backend device already
> looks sketchy here due to doubling work of task attribute handling, the
> various state bits, etc.  And it will only get more complicated when
> the required locking is added.  In addition we have all that confusion
> about overloading the data direction.
> 
> I think the way this should be handled is:
> 
> 
>  - cmd->execute_cmd gets set to a new sbc_emulate_compare_and_write
>  - sbc_emulate_compare_and_write does all the setup for the locking,
>    sets up the read buffer, then calls ops->execute_rw to do the
>    read.  The complete callback does the comparism, then calls
>    ops->execute_rw to do the write, and the second time we hit
>    the complete callback we teard down the read buffer, stop the
>    locking, etc.
> 

I do like this approach better, however calling ops->execute_rw() the
second time around does require at least the TRANSPORT_PROCESSING and
other transport_state bits from target_execute_cmd() to be set for
things to work correctly.  Bypassing the aborted + CMD_*STOP checks
should be OK for the write submission, and will kick (if necessary)
during the final completion.

Setting up the read buffer from sbc_emulate_compare_and_write() would
require two extra COMPARE_AND_WRITE specific se_cmd elements, so I'm
tempted to continue to use the bidi fields for this (because they
already exist) with transport_generic_get_mem_bidi(), and use a
SCF_COMPARE_AND_WRITE flag to avoid any CDB specific checks in
transport_complete_ok(), and reverse dma direction mapping case.

> This also avoids bloating the command with another function pointer
> or having to change all execute_cmd prototypes.

Indeed.

--nab
