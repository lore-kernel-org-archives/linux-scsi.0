From: Tejun Heo <htejun@gmail.com>
Subject: Re: SCSI layer a stumbling block for true SATA hotplug
Date: Sun, 17 Jul 2005 10:53:10 +0900
Message-ID: <42D9BA06.90601@gmail.com>
References: <42D994C3.8090702@nit.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.193]:61505 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261905AbVGQBxQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Jul 2005 21:53:16 -0400
Received: by zproxy.gmail.com with SMTP id 4so580811nzn
        for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2005 18:53:15 -0700 (PDT)
In-Reply-To: <42D994C3.8090702@nit.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukasz Kosewski <lkosewsk@nit.ca>
Cc: linux-scsi@vger.kernel.org, jgarzik@pobox.com

  Hi, Lukasz.

Lukasz Kosewski wrote:
> Hello all,
> 
> I'm currently working on a project to get a true disk-hotplug subsystem 
> working in libata, experimenting with Promise SATA150 Tx2 Plus and 
> SATAII150 Tx2 Plus controllers.
> 
> I am very near a 'beta' release of my patches to this mailing list, 
> however, I have hit a stumbling block in the SCSI layer, which I'm 
> hoping someone can give me good suggestions for resolving.
> 
> The situation is as follows:
> -> I unplug a disk from my controller.
> -> An interrupt fires off telling me I've unplugged a disk.
> -> I acknowledge the interrupt, add an entry to my workqueue to handle 
> the bottom half.
> -> Bottom half kicks in, I need to call "scsi_remove_device" in order to 
> purge the information about this disk from the system.
> 
> HOWEVER, "scsi_remove_device", through a chain of functions, ends up 
> calling sd_shutdown, which attempts to synchronize the SCSI cache for my 
> disk.  Well... bad plan, I've just unplugged the disk, it's gone.
> 
> So the system gets dazed and confused and locks up, timing out waiting 
> for the disk which isn't there.
> 
> If anyone has a suggestion as to a good (ie. acceptable by all parties) 
> solution to this problem, I'd love to hear it.

  AFAIK, lldd (libata in this case) should be ready to handle/fail 
requests until the removal is complete.  As device hot-unplugging can be 
initiated from different layers, upper layer currently depends on lldd 
to handle such cases.  On detecting device removal, mark the device gone 
inside libata and fail all commands afterward until actual removal is 
complete.  That should do and, IIRC, what other drivers do.

-- 
tejun
