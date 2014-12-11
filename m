From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: T10-PI: Getting failed tag info
Date: Wed, 10 Dec 2014 20:58:16 -0800
Message-ID: <54892468.5060300@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:61419 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaLKE6W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2014 23:58:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Hi,

We are currently developing a SCSI target system with T10-PI. We are using block integrity interface and found a problem that this interface fundamentally can not pass Oracle T10-PI certification tests. Those tests require to receive on the initiator side information about which particular tag failed the target checks, but the block integrity interface does not preserve this information, hence the target can not deliver it to the initiator => certification failure. The storage provides the right sense, but then in scsi_io_completion() it is dropped and replaced by a single EILSEQ.

What would be the best way to fix that? By making a patch introducing new -EXXXXXX error codes for the PI errors?

Thanks,
Vlad
