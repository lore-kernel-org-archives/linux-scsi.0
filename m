From: Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: [PATCH 2.6.13 9/14] sas-class: sas_expander.c Expander discovery and configuration
Date: Fri, 9 Sep 2005 13:05:17 -0700
Message-ID: <29495f1d050909130525f13c7a@mail.gmail.com>
References: <4321E553.6040001@adaptec.com>
Reply-To: nish.aravamudan@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.203]:44452 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030431AbVIIUFS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 16:05:18 -0400
Received: by zproxy.gmail.com with SMTP id r28so1419252nza
        for <linux-scsi@vger.kernel.org>; Fri, 09 Sep 2005 13:05:17 -0700 (PDT)
In-Reply-To: <4321E553.6040001@adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 9/9/05, Luben Tuikov <luben_tuikov@adaptec.com> wrote:
> Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

<snip>


> --- linux-2.6.13-orig/drivers/scsi/sas-class/sas_expander.c     1969-12-31 19:00:00.000000000 -0500
> +++ linux-2.6.13/drivers/scsi/sas-class/sas_expander.c  2005-09-09 11:14:29.000000000 -0400

<snip>

+static int sas_ex_general(struct domain_device *dev)

<snip>

+                       set_current_state(TASK_INTERRUPTIBLE);
+                       schedule_timeout(5*HZ);

Can you use msleep_interruptible() here? I don't see wait-queues in
the immediate vicinity. If not, and you're going for the normal -mm
route (and from there to mainline), can you use
schedule_timeout_interruptible(), please?

Thanks,
Nish
