From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions
 at LSF/MM
Date: Mon, 2 May 2016 15:28:16 -0700
Message-ID: <5727D480.30706@sandisk.com>
References: <1461800389.2311.70.camel@HansenPartnership.com>
 <610090691.32303585.1461860624844.JavaMail.zimbra@redhat.com>
 <57223D36.60304@sandisk.com>
 <74308856.32308210.1461862044976.JavaMail.zimbra@redhat.com>
 <850484819.32589649.1461966427528.JavaMail.zimbra@redhat.com>
 <5723FE06.70501@sandisk.com>
 <1184712515.32596182.1461977223746.JavaMail.zimbra@redhat.com>
 <5727A152.70109@sandisk.com>
 <766510830.33459561.1462217284242.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0072.outbound.protection.outlook.com ([157.56.111.72]:13376
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755166AbcEBW2U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 May 2016 18:28:20 -0400
In-Reply-To: <766510830.33459561.1462217284242.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, lsf@lists.linux-foundation.org

On 05/02/2016 12:28 PM, Laurence Oberman wrote:
> Even in the case of the ib_srp, don't we also have to still run the
> eh_timeout for each of the devices that has inflight requiring error
> handling serially. This means we will still have to wait to get a
> path failover until all are through the timeout.

Hello Laurence,

It depends. If a transport layer error (e.g. a cable pull) has been 
observed by the ib_srp driver then fast_io_fail_tmo seconds later the 
ib_srp driver will terminate all outstanding SCSI commands without 
waiting for the error handler to finish. If no transport layer error has 
been observed then at most (SCSI timeout) + (number of pending commands 
+ 1) * 5 seconds later srp_reset_device() will have finished terminating 
all pending SCSI commands.

Bart.
