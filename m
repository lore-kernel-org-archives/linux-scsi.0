From: Dave Jiang <djiang@mvista.com>
Subject: Adaptec DPT call schedule_timeout with irq off
Date: Fri, 26 Aug 2005 17:45:28 -0700
Message-ID: <430FB7A8.8020105@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([12.44.186.158]:2811 "EHLO
	av.mvista.com") by vger.kernel.org with ESMTP id S965183AbVH0Apb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 20:45:31 -0400
Received: from [10.50.1.77] (av [127.0.0.1])
	by av.mvista.com (8.9.3/8.9.3) with ESMTP id RAA10656
	for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2005 17:45:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I noticed that in the Adaptec DPT driver, drivers/scsi/dpt_i2o.c in 
funciton adapt_i2o_post_wait() around line 1161ish. spin_lock_irqsave() 
is called. However then spin_unlock() is called 2 lines later and 
leaving IRQ disabled. Then a little bit later, schedule_timeout() is 
called with IRQ off. Isn't that bad? Why was irq left off earlier 
instead of doing spin_unlock_irqrestore()? Am I missing something.....

Please cc me on replies. Thank you!

-- 
Dave

