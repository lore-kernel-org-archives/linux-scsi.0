From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Dell/Adaptec PERC3/Di crashes, even with kernel 2.4.25 and aacraid 1.1.5
Date: Mon, 12 Apr 2004 10:13:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F88D3AC@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:42723 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262870AbUDLONr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Apr 2004 10:13:47 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-poweredge@dell.com, Jason Harrop <jharrop@speedlegal.com>

Is there a reason that you reported this same report to RH bugzilla,
linux-scsi, linux-poweredge and not to Dell or Adaptec technical
support?

Your Firmware has hung solid (the driver can not do anything about it
...). Please confirm that the 1.1.5 driver is loaded (cat
/proc/scsi/aacraid/?) to be sure it is loaded (but the default 2.4.25
driver does not report SCSI bus appears hung, so I am just covering the
bases). It is unlikely either driver could mitigate the problem, the
1.1.5 driver will do better on this Firmware (3170) only because of the
heightened priority within the Firmware to perform an internal Cache
Flush and appear reticent for a short duration as a result.

I had a desire to send you an instrumented driver reporting the Adapter
Health in more details, but since your driver did not report any `health
check' problems ("Host adapter appears dead" message), I fear that this
driver will just report the same.

You may be able to get more details about why the Adapter or SCSI bus is
hung on your system by commenting out the AAC_DETAILED_STATUS_INFO line
in aacraid.h line 43 of the aacraid 1.1.5 driver. There is probably a
set of reports just prior to the failure that may indicate which target
is the problem.

I strongly urge you to report your problem to Dell technical support.
They also have an Adaptec Firmware engineer embedded on staff to try to
trace this problem down. In addition, their technical support staff may
be able to trace your problem down to other possible sources (one cause
that pops up often with similar symptoms is a bad power supply or power
supply connector). The appearance of this problem getting worse on
additional samples may be a set of deteriorating hardware.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jason Harrop
Sent: Monday, April 12, 2004 12:48 AM
To: linux-scsi@vger.kernel.org; linux-poweredge@dell.com
Subject: Dell/Adaptec PERC3/Di crashes, even with kernel 2.4.25 and
aacraid 1.1.5

Crashed again :(

It seems that the problem occurs when the cron daily jobs run.  It looks

like the system survived the cron daily job on April 11, but not April
12.

Its only since i upgraded to kernel 2.4.25 and aacraid 1.1.5 that i've 
started to get anything like this in the logs.

Apr 11 04:02:01 promo syslogd 1.4.1: restart.
Apr 12 04:03:02 promo kernel: aacraid: Host adapter reset request. SCSI 
hang ?
Apr 12 04:04:02 promo kernel: aacraid: SCSI bus appears hung
Apr 12 04:04:12 promo kernel: scsi: device set offline - command error 
recover failed: host 0 channel 0 id 0 lun 0
Apr 12 04:04:12 promo kernel:  I/O error: dev 08:03, sector 20185272
Apr 12 04:04:12 promo kernel:  I/O error: dev 08:03, sector 20185288
Apr 12 04:04:12 promo kernel:  I/O error: dev 08:03, sector 20185304
Apr 12 04:04:12 promo kernel:  I/O error: dev 08:03, sector 20185320
Apr 12 04:04:12 promo kernel:  I/O error: dev 08:03, sector 20447272

# ls /etc/cron.daily/
00-logwatch  0anacron  inn-cron-expire  logrotate  makewhatis.cron  rpm 
  slocate.cron  tmpwatch



Any ideas what I should try next?

thanks,

Jason





Jason Harrop wrote:
> Dell 2650 BIOS A15
> PERC3/Di firmware 3170
> ext3 filesystem
> 
> It crashed less than 2 days after rebooting, which is less uptime than

> with RedHat kernel 2.4.18-14smp
> 
> See below for contents of log.
> 
> cheers,
> 
> Jason
> 
> --------------
> 
> Apr 10 04:03:51 promo kernel: aacraid: Host adapter reset request.
SCSI 
> hang ?
> Apr 10 04:04:51 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:05:01 promo kernel: aacraid: Host adapter reset request.
SCSI 
> hang ?
> Apr 10 04:06:01 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:06:11 promo kernel: aacraid: Host adapter reset request.
SCSI 
> hang ?
> Apr 10 04:07:11 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:07:21 promo kernel: aacraid: Host adapter reset request.
SCSI 
> hang ?
> Apr 10 04:08:21 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:08:31 promo kernel: aacraid: Host adapter reset request.
SCSI 
> hang ?
> Apr 10 04:09:31 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:09:41 promo kernel: aacraid: Host adapter reset request.
SCSI 
> hang ?
> Apr 10 04:10:41 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:10:51 promo kernel: aacraid: Host adapter reset request.
SCSI 
> hang ?
> Apr 10 04:15:31 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:15:31 promo kernel: aacraid: Host adapter reset request.
SCSI 
> hang ?
> Apr 10 04:15:31 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:15:31 promo kernel: aacraid: Host adapter reset request.
SCSI 
> hang ?
> Apr 10 04:15:31 promo kernel: aacraid: SCSI bus appears hung
> :
> Apr 10 04:15:31 promo kernel: aacraid: Host adapter reset request.
SCSI 
> hang ?
> Apr 10 04:15:31 promo kernel: aacraid: SCSI bus appears hung
> Apr 10 04:15:31 promo kernel: scsi: device set offline - command error

> recover failed: host 0 channel 0 id 0 lun 0
> Apr 10 04:15:31 promo kernel: SCSI disk error : host 0 channel 0 id 0 
> lun 0 return code = 6000000
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 11014520
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 12058624
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 12058856
> :
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 39846008
> Apr 10 04:15:31 promo kernel:  I/O errev 08:03, sector 262368
> :
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 19398840
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 19398856
> Apr 10 04:15:31 promo kernel:  I/O error: dev 0 sector 9464
> Apr 10 04:15:31 promo kernel:  I/O error: dev 08:03, sector 74856
> 
> 

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
