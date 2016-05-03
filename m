From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions
 at LSF/MM
Date: Tue, 3 May 2016 13:44:42 -0400 (EDT)
Message-ID: <1874809245.33624161.1462297482879.JavaMail.zimbra@redhat.com>
References: <1461800389.2311.70.camel@HansenPartnership.com> <74308856.32308210.1461862044976.JavaMail.zimbra@redhat.com> <850484819.32589649.1461966427528.JavaMail.zimbra@redhat.com> <5723FE06.70501@sandisk.com> <1184712515.32596182.1461977223746.JavaMail.zimbra@redhat.com> <5727A152.70109@sandisk.com> <766510830.33459561.1462217284242.JavaMail.zimbra@redhat.com> <5727D480.30706@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:54469 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbcECRot (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2016 13:44:49 -0400
In-Reply-To: <5727D480.30706@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, lsf@lists.linux-foundation.org



----- Original Message -----
From: "Bart Van Assche" <bart.vanassche@sandisk.com>
To: "Laurence Oberman" <loberman@redhat.com>
Cc: "James Bottomley" <James.Bottomley@HansenPartnership.com>, "linux-scsi" <linux-scsi@vger.kernel.org>, "Mike Snitzer" <snitzer@redhat.com>, linux-block@vger.kernel.org, "device-mapper development" <dm-devel@redhat.com>, lsf@lists.linux-foundation.org
Sent: Monday, May 2, 2016 6:28:16 PM
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions at LSF/MM

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hello Bart

OK, Yes, that lines up with my testing here with Qlogic and Emulex.
I am about to test srp but I need to add some jammer code first.
The link down and other interruptions will always be fast. 
Its always going to be the black-hole events that are troublesome.

Thanks
Laurence
