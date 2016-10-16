From: Nicholas Mc Guire <der.herr@hofr.at>
Subject: possible if/else bug in dc395x.c
Date: Sun, 16 Oct 2016 17:26:47 +0000
Message-ID: <20161016172647.GA26334@osadl.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: dc395x@twibble.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi !

in drivers/scsi/dc395x.c:srb_done()
3387                 if (srb->total_xfer_length
3388                     && srb->total_xfer_length >= cmd->underflow)
3389                         cmd->result =
3390                             MK_RES_LNX(DRIVER_SENSE, DID_OK,
3391                                        srb->end_message, CHECK_CONDITION);
3392                 /*SET_RES_DID(cmd->result,DID_OK) */
3393                 else
3394                         cmd->result =
3395                             MK_RES_LNX(DRIVER_SENSE, DID_OK,
3396                                        srb->end_message, CHECK_CONDITION);
(line numbers from 4.9.0-rc1, localversion-next next-20161016) 

The if and else are identical, these lines date back to pre-git (so git blame
assigns them to the initial 2.6.12-rc2 import).

Not sure if it makes much sense trying to fix up something like this at all
is it worth trying to figure out what this should be ? I would asume that 
given that this survived atleast 12 years in this form that the condition 
could be removed and the cmd-> result set unconditionally here. 

thx!
hofrat
