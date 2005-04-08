From: Douglas Gilbert <dougg@torque.net>
Subject: Re: proc_name in sysfs
Date: Fri, 08 Apr 2005 18:03:16 +1000
Message-ID: <42563AC4.4050605@torque.net>
References: <4253CA94.8000500@bull.net> <20050408064645.GA4860@infradead.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:43183 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262758AbVDHIHN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2005 04:07:13 -0400
In-Reply-To: <20050408064645.GA4860@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Frederic TEMPORELLI <frederic.temporelli@bull.net>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Apr 06, 2005 at 01:40:04PM +0200, Frederic TEMPORELLI wrote:
> 
>>Hello,
>>
>>
>>We are using HBAs modules names from "proc_name" interface in sysfs:
>>/sys/class/scsi_host/hostX/proc_name.
>>
>>But with new Emulex drivers (8.0.21 and +), proc_name is reporting <NULL> 
>>(previous drivers were reporting "lpfc").
>>=> In the driver code, .proc_name field from scsi_host_template structure 
>>is no more initialized.
>>James Smart told us that the "removal" of .proc_name field (not really 
>>removed, but no more initialized) was part of the /proc interfaces removal 
>>(suggested by scsi-linux feedback).
>>
>>So:
>>1/ now, what is the aim of proc_name interface (reporting "<NULL>") in 
>>sysfs ?
>>2/ now, how can we get the adapter module name from sysfs ?
>>
>>=> I'm just thinking that .proc_name field has to be kept initialized 
>>and/or something has to be changed to replace the confusing "proc" prefix.
> 
> 
> The real problem is that someone decided to export the proc_name in sysfs.
> It's supposed to be only procfs-specific but someone violated that rule.

Forget the "proc_" part. It is effectively the lld_name.

Allowing the LLD to name itself to the scsi subsystem
makes sense, especially when the LLD is made up of several
kernel modules. See my previous example comparing the
output of lsscsi -H and scan_host.sh .

> Not sure how to proceed forward with this.

Doug Gilbert

