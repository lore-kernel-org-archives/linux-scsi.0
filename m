From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/9] iscsi: modify transport class to support qla4xxx
Date: Wed, 28 Jun 2006 12:10:36 -0500
Message-ID: <44A2B80C.9020008@cs.wisc.edu>
References: <1151514021.11553.43.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33971 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030361AbWF1RKi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 13:10:38 -0400
Received: from [192.168.0.7] (c-69-180-139-167.hsd1.mn.comcast.net [69.180.139.167])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k5SHAbBH019984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2006 12:10:37 -0500
In-Reply-To: <1151514021.11553.43.camel@madmax>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Oh yeah, all the patches were made over scsi-misc.


Mike Christie wrote:
> It looks like qla4xxx is getting close to being mergable. The following
> patches complete the transport class related fixes I wanted qlogic to
> do. Qlogic and Doug will resend the driver with Arjan and others
> comments and lot of other bug fixes and cleanups.
> 
> The following patches modify the transport class so qla4xxx can use it.
> The patches also make any needed conversions to libiscsi and the other
> iscsi LLD modules.
> 
> The reason for the changes is because the qlogic HW can expose a
> interface that is close to a normal SPI driver that hides most of the
> iscsi details (session mode), or it can expose a interface that exposes
> more of the iscsi details (connection mode). And we chose to go with
> session mode.
> 
> Even in session mode, we have hooked the qla4xxx driver into the
> open-iscsi framework. Normally to do discovery and log into iscsi
> sessions using iscsi_tcp you can do:
> 
> iscsiadm --mode=discovery --type=sendtargets --portal=192.168.0.10:3260
> --login
> 
> To see the running session you can do:
> 
> iscsiadm --m session
> 
> These same commands now work for qla4xxx and we also support qla4xxx
> persistent targets.
> 
> We have hooked qla4xxx into the userspace scanning and iscsi state model
> code. So you can load the module, then run iscsid. iscsid will then scan
> for disks and setup userspace. Or you can run iscsid and then load the
> module. iscsid and the tools can be used with qla4xxx and iscsi_tcp and
> iscsi_iser at the same time.
> 
> In the future we plan to implement more functionality in the userspace
> tools for qla4xxx like manually adding sessions and removing sessions,
> and push more code to userspace, but the current code at least provides
> a usable driver.
> 
> Doug and Qlogic have finished the last qla4xx cleanups and will send
> that driver soon
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

