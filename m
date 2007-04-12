From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: qla_wxyz pci_set_mwi question
Date: Wed, 11 Apr 2007 22:15:07 -0700
Message-ID: <20070411221507.69c97257.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:28041 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422656AbXDLFNS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2007 01:13:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, PCI <linux-pci@atrey.karlin.mff.cuni.cz>
Cc: linux-driver@qlogic.com, gregkh <greg@kroah.com>


Both scsi/qla2xxx/qla_init.c and scsi/qla4xxx/ql4_init.c use pci_set_mwi()
like this:


	mwi = 0;
	if (pci_set_mwi(ha->pdev))
		mwi = PCI_COMMAND_INVALIDATE;

and then go on to set the PCI_COMMAND "word" based on that value.

I don't quite get it.  pci_set_mwi() returns 0 for success or
negative for error... so if pci_set_mwi() fails, the qla init
code still tries to set the PCI_COMMAND_INVALIDATE bit in the
PCI_COMMAND word?  The logic looks inverted to me.  What am I
overlooking?

Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
