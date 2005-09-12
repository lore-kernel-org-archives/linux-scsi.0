From: James.Smart@Emulex.Com
Subject: RE: [PATCH 2.6.13 5/14] sas-class: sas_discover.c Discover process (end devices)
Date: Mon, 12 Sep 2005 15:04:03 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F459D@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750899AbVILTME@vger.kernel.org>
content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: patmans@us.ibm.com, James.Bottomley@SteelEye.com
Cc: dougg@torque.net, hch@infradead.org, ltuikov@yahoo.com, luben_tuikov@adaptec.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



> Though we still have problems with scsi_report_lun_scan code like:
> 
>                 } else if (lun > sdev->host->max_lun) {
> 
> max_lun just has to be large, at least greater than 0xc001 
> (49153), maybe
> even 0xffffffff, correct?

right...

> 
> But then some sequential scanning could take a while. Maybe the above
> check is not needed.
> 
> lpfc has max_luns set to 256, with max limited to 32768, I 
> don't know how
> it could be working OK here. (Has James S or anyone tested this?)

Yes we did test this (actually, we tested out to 64k). Time to perform all
this looping, plus impacts due on sg devices (some configs generate huge
numbers - outside of sg's range), made us pull back to 256 - although it's
tunable.

-- james s 
