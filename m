From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [RFC] [PATCH 0/5] qla4xxx: Add IPv6 support and misc
Date: Wed, 02 May 2007 19:04:30 -0700
Message-ID: <1178157870.20898.35.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:37978 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767296AbXECBE2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2007 21:04:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Somayajulu <david.somayajulu@qlogic.com>, David Wagner <david.wagner@qlogic.com>

The following set of patches 
        1. add support for ipv6 for qla4032 
        2. provide bug fixes
        3. misc. support 

Patch 1/5  
has changes to the driver and firmware related structures to
        1. clean up and make the firmware related structures look linux like.
        2. add fields/structures for ipv6 support
        3. add support for capaturing all AEN types in a ring buffer, to aid troubleshooting.
        4. abstract the functions for sending commands to the HBA (i.e., sending via Request Queue or Mailbox registers) so that the underlying functions can be different in future hardware. Also mailbox commands which are not performance critical may be sent via Request Queues (using mailbox iocbs).
        
Patch 2/5 
has the following changes for initialization routines.
        1. fix qla4x00_pci_config()
        2. fix in qla4xxx_add_device_dynamically(), so that a new target coming online and existing targets which went offline and then came back online are differentiated.
        3. In qla4xxx_build_ddb_list() the firmware ddb entry's state needs to be updated by calling qla4xxx_get_fwddb_entry() after qla4xxx_set_ddb_entry().

Patch 3/5 
adds support code for handling new AENs specific to qla4032.

Patch 4/5 
cleans up the mailbox code and adds functionality to support qla4032.

Patch 5/5 
        1. Since qla4xxx is a multifunction device having one iSCSI and one Ethernet function per physical port, when one of the functions resets the HBA all others need to acknowledge it and wait till the reset is complete and each of them need to re-initialize. A bug in qla4xxx_free_adapter() was resulting in where the resources pertaining to a function were getting released due to module unload, when the function was recovering from reset issued by one of the other functions.
        2. In qla4xxx_free_adapter() memory resources needed to be freed after free_irq() is invoked.
        3. add support for passthru commands to HBA.

Thanks
David Somayajulu
Qlogic Corporation
