From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Question about scsi_qla_host_t.fcports list protection (qla2xxx)
Date: Tue, 15 Aug 2006 14:18:59 +0400
Message-ID: <44E19F93.2020305@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-01.infobox.ru ([85.249.135.210]:33466 "EHLO
	out-relay-01.infobox.ru") by vger.kernel.org with ESMTP
	id S965358AbWHOKTb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 06:19:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com
Cc: linux-scsi@vger.kernel.org

Hello

Looking at the qla2xxx driver source code I noticed that 
scsi_qla_host_t.fcports is used without any protection. For instance, 
qla2x00_loop_reset() walks over this list. This function is called from 
qla2xxx_eh_bus_reset(), which could be called at any time. What does 
protect fcports from being changed, eg, by some async loop event during 
the walking and eventually oops'ing? Do I miss something? There are many 
such unprotected fcports list usages in the driver.

Vlad
