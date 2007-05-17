From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] [PATCH]  qla4xxx: Updated add IPv6 and misc support bugfixes
 cleanup
Date: Thu, 17 May 2007 11:20:22 -0500
Message-ID: <464C80C6.9060103@cs.wisc.edu>
References: <1178157870.20898.35.camel@iscsi-sles10> <1186362293.5921.25.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38156 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbXEQQUi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2007 12:20:38 -0400
In-Reply-To: <1186362293.5921.25.camel@iscsi-sles10>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>

David C Somayajulu wrote:
> This patch OBSOLETES previous patches 0/5 thru 5/5 titled qla4xxx: Add IPv6 support and misc. It incorporates the feedback received from Mike Christie and others, and encapsulates everything into a single patch. 
> 
> The patch contains the following:
> 	1. clean up and make firmware related structures in ql4_fw.h to confirm to linux coding style.
> 	2. add support for IPv6 for QLA4032
> 	3. add support for capturing all AEN types in a ring buffer, to aid troubleshooting.
> 	4. abstract the functions for sending commands to the HBA (i.e., sending via Request Queue or Mailbox registers) so that the underlying functions can be different in future hardware. Also mailbox commands which are not performance critical may be sent via Request Queues (using mailbox iocbs).
> 	5. In ql4_init.c fix qla4x00_pci_config()
> 	6. In ql4_init.c fix in qla4xxx_add_device_dynamically(), so that a new target coming online and existing targets which went offline and then came back online are differentiated.
> 	7. In ql4_init.c in qla4xxx_build_ddb_list() the firmware ddb entry's state needs to be updated by calling qla4xxx_get_fwddb_entry() after qla4xxx_set_ddb_entry().
> 	8. remove dead code in ql4_dbg.c and ql4_mbx.c
> 	9. Since qla4xxx is a multifunction device having one iSCSI and one Ethernet function per physical port, when one of the functions resets the HBA all others need to acknowledge it and wait till the reset is complete and each of them need to re-initialize. A bug in qla4xxx_free_adapter() was resulting in where the resources pertaining to a function were getting released due to module unload, when the function was recovering from reset issued by one of the other functions.
> 	10. In qla4xxx_free_adapter() memory resources needed to be freed after free_irq() is invoked.
> Thanks
> David Somayajulu
> QLogic Corporation
> 

Looks ok, but it is best to send updates with one change per patch and
each patch having some change info. It makes it nice for when searching
git logs for problems later. Maybe James wants you to resubmit a proper
patchset though.
