From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/9] target: Add support for COMPARE_AND_WRITE emulation
Date: Wed, 21 Aug 2013 09:14:08 -0700
Message-ID: <20130821161408.GB30848@infradead.org>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
 <1377029280-19144-9-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1377029280-19144-9-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

I don't like the layering here.  The re-execution of the same command
for both reading and writing the data from/to the backend device already
looks sketchy here due to doubling work of task attribute handling, the
various state bits, etc.  And it will only get more complicated when
the required locking is added.  In addition we have all that confusion
about overloading the data direction.

I think the way this should be handled is:


 - cmd->execute_cmd gets set to a new sbc_emulate_compare_and_write
 - sbc_emulate_compare_and_write does all the setup for the locking,
   sets up the read buffer, then calls ops->execute_rw to do the
   read.  The complete callback does the comparism, then calls
   ops->execute_rw to do the write, and the second time we hit
   the complete callback we teard down the read buffer, stop the
   locking, etc.

This also avoids bloating the command with another function pointer
or having to change all execute_cmd prototypes.
