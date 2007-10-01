From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/8] scsi: megaraid_sas - add module param max_sectors,
 cmd_per_lun
Date: Mon, 01 Oct 2007 12:50:22 -0500
Message-ID: <4701335E.6080906@linux.vnet.ibm.com>
References: <1190820470.5955.12.camel@dhcp-75-534.se.lsil.com> <46FD727C.3090008@linux.vnet.ibm.com> <9738BCBE884FDB42801FAD8A7769C265010A09BF@NAMAIL1.ad.lsil.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56696 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbXJARu1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Oct 2007 13:50:27 -0400
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C265010A09BF@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>

Yang, Bo wrote:
> Brian,
>  
> Thanks for your review.  What is your objection to the current
> implementation by using bin_attribute?

Binary attributes are generally used for data which cannot
be parsed by the user. Since this attribute is simply a
single decimal value, it makes most sense to just use a regular
class_device_attribute. Additionally, if you use the
existing shost_attrs infrastructure in the scsi_host_template,
you can simplify your code, since you don't need to manually
create and destroy the sysfs files as scsi core will do this for
you.

-Brian

>  
> Bo Yang
> 
> ------------------------------------------------------------------------
> *From:* Brian King [mailto:brking@linux.vnet.ibm.com]
> *Sent:* Fri 9/28/2007 3:30 PM
> *To:* Yang, Bo
> *Cc:* linux-scsi@vger.kernel.org; James.Bottomley@SteelEye.com;
> akpm@osdl.org; linux-kernel@vger.kernel.org; Patro, Sumant
> *Subject:* Re: [PATCH 3/8] scsi: megaraid_sas - add module param
> max_sectors, cmd_per_lun
> 
> bo yang wrote:
> 
>> +static ssize_t
>> +sysfs_max_sectors_read(struct kobject *kobj,
>> +                     struct bin_attribute *bin_attr,
>> +                     char *buf, loff_t off, size_t count)
>> +{
>> +     struct Scsi_Host *host = class_to_shost(container_of(kobj,
>> +                                     struct class_device, kobj));
>> +     struct megasas_instance *instance =
>> +                             (struct megasas_instance *)host->hostdata;
>> +
>> +     count = sprintf(buf, "%u\n", instance->max_sectors_per_req);
>> +
>> +     return count+1;
>> +}
>> +
>> +static struct bin_attribute sysfs_max_sectors_attr = {
>> +     .attr = {
>> +             .name = "max_sectors",
>> +             .mode = S_IRUSR|S_IRGRP|S_IROTH,
>> +             .owner = THIS_MODULE,
>> +     },
>> +     .size = 7,
>> +     .read = sysfs_max_sectors_read,
>> +};
> 
> Why is this implemented as a binary sysfs attribute? Also, can you use
> the existing shost_attrs infrastructure that's in the scsi_host_template
> like megaraid_mbox uses?
> 
> 
>> +
>> +     /*
>> +      * Check if the module parameter value for max_sectors can be used
>> +      */
>> +     if (max_sectors && max_sectors <= instance->max_sectors_per_req)
>> +             instance->max_sectors_per_req = max_sectors;
>> +     else {
>> +             if (max_sectors)
>> +                     printk(KERN_INFO
>> +                             "megasas: max_sectors should be > 0 and"
>> +                             "<= %d\n",
>> +                             instance->max_sectors_per_req);
>> +     }
> 
> Could be simplified to an else if, which would remove one indent level...
> 
> -Brian
> 
> --
> Brian King
> Linux on Power Virtualization
> IBM Linux Technology Center
> 


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
