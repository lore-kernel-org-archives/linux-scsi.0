From: "Surekha.PC" <surekhap@cisco.com>
Subject: RE: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 24 Nov 2003 11:39:48 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <00c901c3b251$91016a30$a0074d0a@apac.cisco.com>
References: <20031027153932.A16679@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:60819 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S263574AbTKXGJz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 01:09:55 -0500
In-Reply-To: <20031027153932.A16679@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org


Hi,

>>  	- this comment indicates you don't want normal EH:

>> * check condition with no sense.  We need to avoid this, 
>> * since the Linux SCSI code could put the command in 
>> * SCSI_STATE_FAILED, which it's error recovery doesn't appear 
>> * to handle correctly, and even if it does, we're trying to 
>> * bypass all of the Linux error recovery code
>> * to avoid blocking all I/O to the HBA.  Fake some sense 
>> * data that gets a retry from Linux.

>	so don't use scsi_error.c and define your own
eh_strategy_handler method.

By implementing the iSCSI driver specific strategy_handler we will need
to duplicate most of the mid layer strategy handler logic only to
accommodate the above condition.

Is that justified ? Or is it ok, to fix the above case in scsi_error.c ?

Thanks,
surekha

