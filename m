From: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] sdev_printk - scsi_device helper macro
Date: Thu, 09 Oct 2003 11:03:09 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <009401c38e09$7fecc8a0$2988110a@lsd.css.fujitsu.com>
References: <200310071318.11847.dsteklof@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35236 "EHLO
	fgwmail7.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S261885AbTJICDb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Oct 2003 22:03:31 -0400
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73]) by fgwmail7.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id h9923T49012614 for <linux-scsi@vger.kernel.org>; Thu, 9 Oct 2003 11:03:29 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from s1.gw.fujitsu.co.jp by m3.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id h9923T62010441 for <linux-scsi@vger.kernel.org>; Thu, 9 Oct 2003 11:03:29 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from fjmail502.fjmail.jp.fujitsu.com (fjmail502-0.fjmail.jp.fujitsu.com [10.59.80.98]) by s1.gw.fujitsu.co.jp (8.12.10)
	id h9923SoS015983 for <linux-scsi@vger.kernel.org>; Thu, 9 Oct 2003 11:03:28 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from CARREN (fjscan503-0.fjmail.jp.fujitsu.com [10.59.80.124])
 by fjmail502.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HMG0023IWDQH4@fjmail502.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Thu,  9 Oct 2003 11:03:27 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: Daniel Stekloff <dsteklof@us.ibm.com>, linux-scsi@vger.kernel.org

Hi Dan,

>
> I originally posted this patch for comments:
>
> http://marc.theaimsgroup.com/?l=linux-scsi&m=106487047707538&w=2
>
> The sdev_printk macro is meant to provide two things for the mid-layer and
> LLDs:
>
> 1) Add consistency to printing out scsi_device information.
>
> 2) Identifying printk with a specific scsi_device.
>

I agree these.


> diff -urN --exclude=SCCS scsi-misc-2.5/include/scsi/scsi_device.h
> scsi-misc-2.5-sdev/include/scsi/scsi_device.h
> --- scsi-misc-2.5/include/scsi/scsi_device.h 2003-10-06 16:13:57.000000000
> -0700
> +++ scsi-misc-2.5-sdev/include/scsi/scsi_device.h 2003-10-06
> 20:04:19.671217176 -0700
> @@ -105,6 +105,9 @@
>  #define class_to_sdev(d) \
>   container_of(d, struct scsi_device, sdev_classdev)
>
> +#define sdev_printk(level, sdev, format, arg...) \
> + printk(level "scsi <%s>: " format , (sdev)->sdev_gendev.bus_id , ## arg)
> +

It would be nice if the message format is the same with the dev_printk().

    #define dev_printk(level, dev, format, arg...)  \
        printk(level "%s %s: " format , (dev)->driver->name , (dev)->bus_id , ##


And, there are many colon separated bus_id, I prefer adding "scsi" before that.
Also, bus_id is separated with ":", so your idea that it is quoted by "< >" is
nice.
I propose the folloing format.

#define sdev_printk(level, sdev, format, arg...) \
  printk(level "%s <scsi%s>: " format , (sdev)->sdev_gendev.driver->name, \
                (sdev)->sdev_gendev.bus_id , ## arg)

It would produce a message like this:
    st <scsi0:0:4:0>: Device offlined - not ready after error recovery

Thanks,
Hironobu Ishii

