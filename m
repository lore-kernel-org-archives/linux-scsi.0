From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: change srb status busy return
Date: Tue, 19 Jun 2007 15:37:20 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22E28@otce2k301.adaptec.com>
References: <1182274845.3432.31.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:34188 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764726AbXFSThX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 15:37:23 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1182274845.3432.31.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley <mailto:James.Bottomley@SteelEye.com> sez:
>On Tue, 2007-06-19 at 11:41 -0400, Salyzyn, Mark wrote:
>>It was discovered that if we had a busy status return
>>from the Adapter for the SCSI srb command to a physical
>>component, that we returned DID_NO_CONNECT rather than
>>what one would expect DID_BUS_BUSY.
>Are you sure you want DID_BUS_BUSY? I'm just asking because
>I'm not sure of the firmware ramifications. DID_BUS_BUSY
>will turn the command around for an immediate retry.
>If there's a firmware resource issue, you should return
>something like DID_REQUEUE which will throttle the
>queue and reissue this command when another one returns.

Thanks for noting this. I believe that this is the behavior we want.

This is related to a SCSI pass-through to the physical targets. I see no
dummied-up returns of SRB_STATUS_BUSY from the top all the way down to
the CHIM. This is a report from the physical bus or end device and thus
does not represent an Adapter resource limit. Immediate re-queuing is
indicated.

I noticed this issue when we were talking internally about mitigating
the sequential queuing of commands to SATA ATAPI devices at the CHIM
level. A long command (erase CD for example) issued by an application
was followed by a test unit ready with a short timeout issued by the
Linux device class layer for media checking and we ended up timing out
the test unit ready. I had suggested, in violation of the sat
specification, to return the test unit ready with SRB_STATUS_BUSY when
timed out prior to even making it to the physical transport while
sitting in the sequential queue. Thus I noticed the shortcoming in the
driver regarding the recent (> 2.6.10) addition of this return value.
The CHIM folks balked at a spoofed SRB_STATUS_BUSY response. Even though
the workaround was not accepted, this scenario would still be acceptable
for immediate re-queuing.

Sincerely -- Mark Salyzyn

