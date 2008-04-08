From: Rakesh <raksac@yahoo.com>
Subject: megaraid sas driver
Date: Tue, 8 Apr 2008 13:41:58 -0700 (PDT)
Message-ID: <96296.65150.qm@web30203.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web30203.mail.mud.yahoo.com ([209.191.69.50]:41530 "HELO
	web30203.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752748AbYDHUsi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2008 16:48:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, megaraidlinux@lsi.com

I am curious to ask, why were these lines omitted from
the megaraid SAS driver with kernel version 2.6.15
onwards.

In my opinion these were blocking physical disks which
were part of a RAID set on the controller from being
visible to OS. Is this correct?

Thanks,
Rakesh

----------------
megaraid_sas.c
                /*
 989                 * Don't export physical disk
devices to mid-layer.
 990                 */
 991                if (!MEGASAS_IS_LOGICAL(cmd->scmd)
&&
 992                    (hdr->cmd_status ==
MFI_STAT_OK) &&
 993                    (cmd->scmd->cmnd[0] ==
INQUIRY)) {
 994
 995                        if (((*(u8 *)
cmd->scmd->request_buffer) & 0x1F) ==
 996                            TYPE_DISK) {
 997                                cmd->scmd->result
= DID_BAD_TARGET << 16;
 998                                exception = 1;
 999                        }
1000                }




      ____________________________________________________________________________________
You rock. That's why Blockbuster's offering you one month of Blockbuster Total Access, No Cost.  
http://tc.deals.yahoo.com/tc/blockbuster/text5.com
