From: Naresh Kumar Inna <naresh@chelsio.com>
Subject: Re: [SCSI] csiostor: Chelsio FCoE offload driver
Date: Fri, 8 Feb 2013 13:04:29 +0530
Message-ID: <5114AA85.8040005@chelsio.com>
References: <20130206130943.GU4989@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:21750 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3BHHef (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2013 02:34:35 -0500
In-Reply-To: <20130206130943.GU4989@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kbuild@01.org" <kbuild@01.org>

On 2/6/2013 6:39 PM, Dan Carpenter wrote:
> Hopefully, you recieved an email about this last November, but this
> is a follow up because the bug is still there.
> 

I don't recollect getting that email. Thanks for reporting nevertheless.
There are some patches lined up for supporting new features and some bug
fixes. I will ensure those patches address the issues you have reported.

Thanks,
Naresh.


> Smatch complains about a buffer overflow in this:
> 
> drivers/scsi/csiostor/csio_rnode.c:872 csio_rnode_fwevt_handler()
> 	error: buffer overflow '(rn)->stats.n_evt_fw' 22 <= 26
> 
>    859  void
>    860  csio_rnode_fwevt_handler(struct csio_rnode *rn, uint8_t fwevt)
>    861  {
>    862          struct csio_lnode *ln = csio_rnode_to_lnode(rn);
>    863          enum csio_rn_ev evt;
>    864  
>    865          evt = CSIO_FWE_TO_RNFE(fwevt);
>    866          if (!evt) {
> 
> Events greater than PROTO_ERR_IMPL_LOGO are invalid.
> 
>    867                  csio_ln_err(ln, "ssni:x%x Unhandled FW Rdev event: %d\n",
>    868                              csio_rn_flowid(rn), fwevt);
>    869                  CSIO_INC_STATS(rn, n_evt_unexp);
>    870                  return;
>    871          }
>    872          CSIO_INC_STATS(rn, n_evt_fw[fwevt]);
> 
> It looks like new events were added and the size of the n_evt_fw[]
> array wasn't updated to hold them.  Everything after RSCN_DEV_LOST
> causes memory corruption.
> 
>    RSCN_DEV_LOST           = 0x16,
>    SCR_ACC_RCVD            = 0x17,
>    ADISC_RJT_RCVD          = 0x18,
>    LOGO_SNT                = 0x19,
>    PROTO_ERR_IMPL_LOGO     = 0x1a,
> 
> There is a related bug in the lnode version of this code which
> Smatch does not catch.
> 
> drivers/scsi/csiostor/csio_lnode.c
>   1555                          /* save previous event for debugging */
>   1556                          ln->prev_evt = ln->cur_evt;
>   1557                          ln->cur_evt = rdev_wr->event_cause;
>   1558                          CSIO_INC_STATS(ln, n_evt_fw[rdev_wr->event_cause]);
>                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Memory corruption.
> 
>   1559  
>   1560                          /* Translate all the fabric events to lnode SM events */
>   1561                          evt = CSIO_FWE_TO_LNE(rdev_wr->event_cause);
>   1562                          if (evt) {
> 
> Valid events handled here but we already corrupted memory three
> lines earlier.
> 
>   1563                                  csio_ln_dbg(ln,
>   1564                                          "Posting event to lnode event:%d "
>   1565                                          "cause:%d flowid:x%x\n", evt,
>   1566                                          rdev_wr->event_cause, rdev_flowid);
>   1567                                  csio_post_event(&ln->sm, evt);
>   1568                          }
>   1569  
> 
> I wasn't a part of the discussion in November, but the fix for this
> seems trivial.  I'm probably missing something?
> 
> regards,
> dan carpenter
> 

