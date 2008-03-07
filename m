From: "Ke Wei" <kewei.mv@gmail.com>
Subject: Re: [PATCH] mvsas: fix default can_queue
Date: Fri, 7 Mar 2008 18:50:00 +0800
Message-ID: <6b2481670803070250p7e6eab01i6660c53188914058@mail.gmail.com>
References: <1204308113.4003.45.camel@localhost.localdomain>
	 <1204504945.3069.30.camel@localhost.localdomain>
	 <6b2481670803030017h43da68bcxd78a6142f8f5c6bb@mail.gmail.com>
	 <1204556371.3043.7.camel@localhost.localdomain>
	 <1204682849.3091.95.camel@localhost.localdomain>
	 <1204750960.3047.67.camel@localhost.localdomain>
	 <6b2481670803060646m54675625g729a82c4da33ce05@mail.gmail.com>
	 <1204818725.3062.14.camel@localhost.localdomain>
	 <1204825474.3062.25.camel@localhost.localdomain>
	 <47D03117.2020903@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:65508 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbYCGKuB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2008 05:50:01 -0500
Received: by wa-out-1112.google.com with SMTP id v27so475146wah.23
        for <linux-scsi@vger.kernel.org>; Fri, 07 Mar 2008 02:50:00 -0800 (PST)
In-Reply-To: <47D03117.2020903@garzik.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On a system with many SAS targets,  It appears possible that a
scsi_cmnd can time out without ever making it to the SAS LLDD or at
the same time that a completion is occurring.
in file sas_scsi_host.c :
               /* Queue up, Direct Mode or Task Collector Mode. */
               if (sas_ha->lldd_max_execute_num < 2)
                               res = i->dft->lldd_execute_task(task,
1, GFP_ATOMIC);
               else
                               res = sas_queue_up(task);
If I set lldd_max_execute_num above 1, I find that libsas couldn't
queue a task to the SAS LLDD sometimes.
System will always report: not at initiator: EH_RESET_TIMER.
Is queue_thread pending? I will keep investigating.



-- 
Best Regards,
Ke Wei
