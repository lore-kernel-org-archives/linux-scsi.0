From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v8 0/10] More device removal fixes
Date: Thu, 07 Feb 2013 12:33:33 +0100
Message-ID: <5113910D.2060100@acm.org>
References: <5110FE98.8030209@acm.org> <alpine.DEB.2.02.1302061727030.11804@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:45831 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3BGLdh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2013 06:33:37 -0500
In-Reply-To: <alpine.DEB.2.02.1302061727030.11804@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

On 02/06/13 23:31, Joe Lawrence wrote:
> crash> list scsi_device.siblings -H 0xffff8808513a4290 -s scsi_device
>
> ffff880851232520
> struct scsi_device {
>    is_visible = 0x1,
>    sdev_state = SDEV_DEL,
> }
> ffff880851235388
> struct scsi_device {
>    is_visible = 0x1,
>    sdev_state = SDEV_DEL,
> }

This is interesting. This probably means that one or more threads got 
stuck in __scsi_remove_device(). If you still have the crash dump 
available it would be appreciated if you could verify whether this is 
correct. If so, there might be an issue in the mpt2sas driver where 
scsi_done() does not get invoked for all outstanding commands after a 
surprise removal.

Bart.
