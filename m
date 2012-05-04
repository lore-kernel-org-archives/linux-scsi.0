From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 5/6] qla4xxx: Capture minidump for ISP82XX on firmware
 failure
Date: Fri, 4 May 2012 03:00:17 -0700
Message-ID: <CBC9A645.E8BA%vikas.chaudhary@qlogic.com>
References: <CBC865CB.E843%vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:46331
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752318Ab2EDKAZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 May 2012 06:00:25 -0400
In-Reply-To: <CBC865CB.E843%vikas.chaudhary@qlogic.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, "jbottomley@parallels.com" <jbottomley@parallels.com>
Cc: scsi <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Tej Parkash <tej.parkash@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>


Looks like my earlier email fails to go on scsi-liist. Resending email.

From:  Vikas <vikas.chaudhary@qlogic.com>
Date:  Thu, 3 May 2012 04:30:11 -0700
To:  Mike Christie <michaelc@cs.wisc.edu>
Cc:  "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi
<linux-scsi@vger.kernel.org>, Lalit Chandivade
<lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Tej
Parkash <tej.parkash@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>
Subject:  Re: [PATCH 5/6] qla4xxx: Capture minidump for ISP82XX on
firmware failure


>
>-----Original Message-----
>From: Mike Christie <michaelc@cs.wisc.edu>
>Date: Fri, 27 Apr 2012 09:05:15 -0700
>To: Vikas <vikas.chaudhary@qlogic.com>
>Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi
><linux-scsi@vger.kernel.org>, Lalit Chandivade
><lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Tej
>Parkash <tej.parkash@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>
>Subject: Re: [PATCH 5/6] qla4xxx: Capture minidump for ISP82XX on
>firmware failure
>
>>On 04/24/2012 12:32 AM, vikas.chaudhary@qlogic.com wrote:
>>> +
>>> +static ssize_t
>>> +qla4_8xxx_sysfs_write_fw_dump(struct file *filep, struct kobject
>>>*kobj,
>>> +                         struct bin_attribute *ba, char *buf, loff_t off,
>>> +                         size_t count)
>>> +{
>>> +   struct scsi_qla_host *ha =
>>>to_qla_host(dev_to_shost(container_of(kobj,
>>> +                                          struct device, kobj)));
>>> +   uint32_t dev_state;
>>> +   int reading;
>>> +
>>> +   if (!is_qla8022(ha))
>>> +           return -EINVAL;
>>> +
>>> +   if (off != 0)
>>> +           return 0;
>>> +
>>> +   reading = simple_strtol(buf, NULL, 10);
>>
>>I think we are supposed to be using kstrtol now.
>
>
>We tried using kstrtol but most of times we found kstrtol return error.
>
>We added following patch to debug this issue:-
>
>--- a/drivers/scsi/qla4xxx/ql4_attr.c
>+++ b/drivers/scsi/qla4xxx/ql4_attr.c
>@@ -35,7 +35,8 @@ qla4_8xxx_sysfs_write_fw_dump(struct file *filep,
>struct kobject *kobj,
>        struct scsi_qla_host *ha =
>to_qla_host(dev_to_shost(container_of(kobj,
>                                               struct device, kobj)));
>        uint32_t dev_state;
>-       int reading;
>+       long reading;
>+       int read, ret;
>
>        if (is_qla40XX(ha))
>                return -EINVAL;
>@@ -43,7 +44,20 @@ qla4_8xxx_sysfs_write_fw_dump(struct file *filep,
>struct kobject *kobj,
>        if (off != 0)
>                return 0;
>
>-       reading = simple_strtol(buf, NULL, 10);
>+       printk("------------------------------------------\n");
>+       ql4_printk(KERN_INFO, ha, "Buf = %s\n", buf);
>+       printk("------------------------------------------\n");
>+       read = simple_strtol(buf, NULL, 10);
>+       ql4_printk(KERN_INFO, ha, "simple strtol val = %d\n", read);
>+       ret = kstrtol(buf, 10, &reading);
>+       if (ret) {
>+               ql4_printk(KERN_INFO, ha, "\nError %d\n", ret);
>+               ql4_printk(KERN_INFO, ha, "Error Converted Val %ld\n",
>reading);
>
>+               return ret;
>+       }
>+       ql4_printk(KERN_INFO, ha, "kstrtol val = %ld\n", reading);
>+       return count;
>+
>        switch (reading) {
>        case 0:
>                /* clear dump collection flags */
>
>
>----
>
>When we do:
># echo 6 > /sys/class/scsi_host/host7/device/fw_dump
>We get following result for this patch:-
>--------------------------------------------------------------------------
>----------------------------------------------------
>May  3 16:45:59 magana kernel: ------------------------------------------
>May  3 16:45:59 magana kernel: qla4xxx 0000:18:00.4: Buf = 6./../../host7
>May  3 16:45:59 magana kernel: ------------------------------------------
>May  3 16:45:59 magana kernel: qla4xxx 0000:18:00.4: simple strtol val = 6
>May  3 16:45:59 magana kernel: qla4xxx 0000:18:00.4:
>May  3 16:45:59 magana kernel: Error -22
>May  3 16:45:59 magana kernel: qla4xxx 0000:18:00.4: Error Converted Val
>-2129482613
>
>--------------------------------------------------------------------------
>----------------------------------------------------
>
>From above logs looks like sysfs attribute reading some extra garbage
>characters because of which
>'kstrtol()' fails but in same case 'simple_strtol()' works fine.
>
>Do you have any idea why we are getting some garbage characters from
>sysfs attribute?
>
>Can you please accept this patch with 'simple_strtol()' till this issue
>get fixed.
>Once it is fix we will update the patch.
>
>Thanks,
>Vikas.
>


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

