From: Saeed Bishara <Saeed.Bishara@il.marvell.com>
Subject: sense buffer not cleaned when retrying failed command by the eh
Date: Mon, 12 Jan 2004 13:50:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40028A1A.2030609@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop3.galileo.co.il ([199.203.130.130]:5601 "EHLO
	mail.galileo.co.il") by vger.kernel.org with ESMTP id S266131AbUALLvi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2004 06:51:38 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Rabeeh Khoury <Rabeeh@il.marvell.com>, Slava Samsonov <samsonov@il.marvell.com>

Hello,
    when the scsi error handler(eh) retries failed command after 
resetting the bus and sending test unit ready, it doesn't clean the 
sense buffer. in my case the test unit ready completed successfully but 
with check condition (reporting bus reset and parameters changed), after 
then, the eh retried the failed command, and it was completed 
successfully without check condition, but since the sense buffer was not 
cleaned, the eh thinks that the sense data for the retried command was 
valid!
    the failed command I'm talking about it the INQUIRY that sent by 
scsi scan, so due the problem described above, the scsi scan decided to 
but the device offline!
    I've fixed the problem in my LLD by cleaning the sense buffer when 
there is no sense data to report, but I do think this should be done by 
the mid layer.

I'm using kernel 2.4.20

-- 
Saeed Bishara
Marvell Semiconductor Israel Ltd
Moshav Manof, D.N. Misgav 20184, ISRAEL
Email    -  Saeed.Bishara@il.marvell.com
Tel      -  + 972 4 9991014
Cell     -  + 972 67 619030
Fax      -  + 972 4 9999574
WWW Page:     http://www.marvell.com 




