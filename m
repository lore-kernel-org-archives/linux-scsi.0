From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] cxgb4i: add support for T5 adapter
Date: Thu, 27 Jun 2013 23:47:02 +0300
Message-ID: <20130627204627.GA13082@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36364 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab3F0UrU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jun 2013 16:47:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kxie@chelsio.com
Cc: linux-scsi@vger.kernel.org

Hello Karen Xie,

The patch 3bd3e8bf6250: "[SCSI] cxgb4i: add support for T5 adapter"
from May 29, 2013, leads to the following Sparse warning:

drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:284:29: warning: incorrect type in assignment (different base types)
drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:284:29:    expected restricted __be64 [usertype] params
drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:284:29:    got restricted __be32 [usertype] <noident>

drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
   271                  struct cpl_t5_act_open_req *req =
   272                                  (struct cpl_t5_act_open_req *)skb->head;
   273  
   274                  req = (struct cpl_t5_act_open_req *)skb->head;
   275  
   276                  INIT_TP_WR(req, 0);
   277                  OPCODE_TID(req) = cpu_to_be32(MK_OPCODE_TID(CPL_ACT_OPEN_REQ,
   278                                          qid_atid));
   279                  req->local_port = csk->saddr.sin_port;
   280                  req->peer_port = csk->daddr.sin_port;
   281                  req->local_ip = csk->saddr.sin_addr.s_addr;
   282                  req->peer_ip = csk->daddr.sin_addr.s_addr;
   283                  req->opt0 = cpu_to_be64(opt0);
   284                  req->params = cpu_to_be32(select_ntuple(csk->cdev, csk->l2t));
                        ^^^^^^^^^^^
For cpl_t5_act_open_req ->params is a __be64.  For other types it is a
__be32 so I suspect this is a copy and paste error.

   285                  opt2 |= 1 << 31;
   286                  req->opt2 = cpu_to_be32(opt2);

Here is an article on how to use Sparse for endian bugs:
http://lwn.net/Articles/205624/

Also I'm on the topic, I had another concern later in the file:

drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
  1629          rpl = (struct cpl_act_establish *)skb->data;
  1630          opc = rpl->ot.opcode;
  1631          log_debug(1 << CXGBI_DBG_TOE,
  1632                  "cdev %p, opcode 0x%x(0x%x,0x%x), skb %p.\n",
  1633                   cdev, opc, rpl->ot.opcode_tid, ntohl(rpl->ot.opcode_tid), skb);
  1634          if (cxgb4i_cplhandlers[opc])
  1635                  cxgb4i_cplhandlers[opc](cdev, skb);
                                           ^^^
Since "opc" comes from skb->data shouldn't we check that it is less than
ARRAY_SIZE(cxgb4i_cplhandlers) (239 elements)?  Another solution that's
used in drivers/net/ethernet/chelsio/cxgb/cpl5_cmd.h would be to define
the array as having 256 elements.

  1636          else {
  1637                  pr_err("No handler for opcode 0x%x.\n", opc);
  1638                  __kfree_skb(skb);
  1639          }

regards,
dan carpenter

