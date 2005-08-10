From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: Re: kernel workqueue -max name length
Date: Wed, 10 Aug 2005 07:45:18 +0200
Message-ID: <42F9946E.2040609@ext.bull.net>
References: <42F8AE91.9030708@ext.bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44698 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S964995AbVHJFpV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 01:45:21 -0400
In-Reply-To: <42F8AE91.9030708@ext.bull.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>

Hi,


any explanation about the 10 chars limit for kernel workqueue name ?


another question: why is the name length test managed by BUG_ON ?
returning a NULL workqueue is done in the next test (failed kmalloc for wq)...

Anyway, this can explain some issues when loading some SCSI drivers modules.


hope that somebody knows...


Frederic TEMPORELLI wrote:
> Hello,
> 
> 
> When creating a workqueue, workqueue name is limited to 10 chars
> (kernel/workqueue.c , function is __create_workqueue, test is done in a 
> BUG_ON).
> 
> Why has this length be limited to 10 chars ?
> Can I safely increase this max length (13 chars should be enough...) ?
> 
> 
> 
> Some comments about these questions:
> 
> In SCSI layer, HBA kernel ID is incremented after each modprobe/rmmod.
> 
> Then, when a scsi driver is managing a working queue and HBA kernel ID 
> is greater than 99 (let's assume that you have modprobe/rmmod the scsi 
> driver to get this ID to 99, or you may have play with 'scsi_debug' 
> module), an oops is generated when loading again the driver (and the 
> driver is frozen).
> 
> This is because working queue name format is "scsi_wq_%d" 
> (drivers/scsi/hosts.c , function scsi_add_host, %d is the HBA ID), and 
> so working queue name length is greater than 10 chars when HBA kernel ID 
> is > 99...
> 
> 
> Best regards
> 
> 


-- 
Frederic TEMPORELLI

