From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] fnic: FIP VLAN Discovery Feature Support
Date: Wed, 8 Jan 2014 12:57:41 +0300
Message-ID: <20140108095741.GA10666@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47740 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbaAHJ5c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2014 04:57:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hiralpat@cisco.com
Cc: linux-scsi@vger.kernel.org

Hello Hiral Patel,

The patch d3c995f1dcf9: "[SCSI] fnic: FIP VLAN Discovery Feature
Support" from Feb 25, 2013, leads to the following
static checker warning:

	drivers/scsi/fnic/fnic_fcs.c:278 is_fnic_fip_flogi_reject()
	warn: is it ok to set 'els_len' to negative?

This is some unpushable debug code on my Smatch system.  It is sort of
a nonsense warning because Smatch has run into an "impossible" condition
because of a bug in Smatch but also because of bug in
fnic_fcoe_send_vlan_req().

drivers/scsi/fnic/fnic_fcs.c
   251          fiph = (struct fip_header *)skb->data;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
fiph is untrusted data.  We don't trust the network.  This is a rule of
Linux.

   252          op = ntohs(fiph->fip_op);
   253          sub = fiph->fip_subcode;
   254  
   255          if (op != FIP_OP_LS)
   256                  return 0;
   257  
   258          if (sub != FIP_SC_REP)
   259                  return 0;
   260  
   261          rlen = ntohs(fiph->fip_dl_len) * 4;
   262          if (rlen + sizeof(*fiph) > skb->len)
   263                  return 0;
   264  
   265          desc = (struct fip_desc *)(fiph + 1);
   266          dlen = desc->fip_dlen * FIP_BPW;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
desc->fip_dlen is u8 type so it could be a number between 0-255.  That's
fine.
FIP_BPW is 4.
Here is the bug in Smatch.  It looks at the sender code and says that
desc->fip_dlen is set to either 2 or 4.  So now dlen is in 8-16 range.

   267  
   268          if (desc->fip_dtype == FIP_DT_FLOGI) {
   269  
   270                  shost_printk(KERN_DEBUG, lport->host,
   271                            " FIP TYPE FLOGI: fab name:%llx "
   272                            "vfid:%d map:%x\n",
   273                            fip->sel_fcf->fabric_name, fip->sel_fcf->vfid,
   274                            fip->sel_fcf->fc_map);
   275                  if (dlen < sizeof(*els) + sizeof(*fh) + 1)
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
8-16 is always less than 29 so this condition is always true.

   276                          return 0;
   277  
   278                  els_len = dlen - sizeof(*els);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We are in an impossible condition and Smatch doesn't know the possible
values of "dlen" any more so it generates the warning.

   279                  els = (struct fip_encaps *)desc;
   280                  fh = (struct fc_frame_header *)(els + 1);
   281                  els_dtype = desc->fip_dtype;
   282  
   283                  if (!fh)
   284                          return 0;
   285  
   286                  /*
   287                   * ELS command code, reason and explanation should be = Reject,
   288                   * unsupported command and insufficient resource
   289                   */
   290                  els_op = *(u8 *)(fh + 1);
   291                  if (els_op == ELS_LS_RJT) {
   292                          shost_printk(KERN_INFO, lport->host,
   293                                    "Flogi Request Rejected by Switch\n");
   294                          return 1;
   295                  }
   296                  shost_printk(KERN_INFO, lport->host,
   297                                  "Flogi Request Accepted by Switch\n");
   298          }
   299          return 0;
   300  }
   301  
   302  static void fnic_fcoe_send_vlan_req(struct fnic *fnic)
   303  {
   304          struct fcoe_ctlr *fip = &fnic->ctlr;
   305          struct fnic_stats *fnic_stats = &fnic->fnic_stats;
   306          struct sk_buff *skb;
   307          char *eth_fr;
   308          int fr_len;
   309          struct fip_vlan *vlan;
   310          u64 vlan_tov;
   311  
   312          fnic_fcoe_reset_vlans(fnic);
   313          fnic->set_vlan(fnic, 0);
   314          FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
   315                    "Sending VLAN request...\n");
   316          skb = dev_alloc_skb(sizeof(struct fip_vlan));
   317          if (!skb)
   318                  return;
   319  
   320          fr_len = sizeof(*vlan);
   321          eth_fr = (char *)skb->data;
   322          vlan = (struct fip_vlan *)eth_fr;
   323  
   324          memset(vlan, 0, sizeof(*vlan));
   325          memcpy(vlan->eth.h_source, fip->ctl_src_addr, ETH_ALEN);
   326          memcpy(vlan->eth.h_dest, fcoe_all_fcfs, ETH_ALEN);
   327          vlan->eth.h_proto = htons(ETH_P_FIP);
   328  
   329          vlan->fip.fip_ver = FIP_VER_ENCAPS(FIP_VER);
   330          vlan->fip.fip_op = htons(FIP_OP_VLAN);
   331          vlan->fip.fip_subcode = FIP_SC_VL_REQ;
   332          vlan->fip.fip_dl_len = htons(sizeof(vlan->desc) / FIP_BPW);
   333  
   334          vlan->desc.mac.fd_desc.fip_dtype = FIP_DT_MAC;
   335          vlan->desc.mac.fd_desc.fip_dlen = sizeof(vlan->desc.mac) / FIP_BPW;

8 / 4 = 2.  We are setting ->fib_dlen to 2.

   336          memcpy(&vlan->desc.mac.fd_mac, fip->ctl_src_addr, ETH_ALEN);
   337  
   338          vlan->desc.wwnn.fd_desc.fip_dtype = FIP_DT_NAME;
   339          vlan->desc.wwnn.fd_desc.fip_dlen = sizeof(vlan->desc.wwnn) / FIP_BPW;
                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This is actually a second Smatch bug which it inherited from Sparse.  It
doesn't understand packed structs correctly and think we are setting
->fib_dlen to 4 but we are setting it to 3.

   340          put_unaligned_be64(fip->lp->wwnn, &vlan->desc.wwnn.fd_wwn);
   341          atomic64_inc(&fnic_stats->vlan_stats.vlan_disc_reqs);
   342  

I suspect that the size calculation is not taking
sizeof(struct fc_frame_header) into consideration properly in
fnic_fcoe_send_vlan_req()?

regards,
dan carpenter

