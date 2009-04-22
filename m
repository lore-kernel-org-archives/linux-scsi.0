From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
Subject: Re: The order of generating sd name
Date: Wed, 22 Apr 2009 23:16:48 +0800
Message-ID: <d364733c0904220816g6ade8b98u4fb80b9d1fbb4a8f@mail.gmail.com>
References: <d364733c0904210226i2b48ae21pb5c39f338f53194b@mail.gmail.com>
	 <20090421144313.GA313@mars.virtualiron.com>
	 <d364733c0904210801n2d317adeh1978d71c35741c0b@mail.gmail.com>
	 <d364733c0904220409g4a86cf54k82ab3b7afdbcb8a2@mail.gmail.com>
	 <1240403080.3431.7.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:53883 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbZDVPQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 11:16:50 -0400
Received: by wf-out-1314.google.com with SMTP id 26so14961wfd.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 08:16:49 -0700 (PDT)
In-Reply-To: <1240403080.3431.7.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Konrad Rzeszutek <konrad@virtualiron.com>, linux-scsi@vger.kernel.org

On Wed, Apr 22, 2009 at 8:24 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2009-04-22 at 19:09 +0800, =D0=BB=B8=D9 wrote:
>> I found that, my my kernel version is 2.6.16 (SUSE10). And the HBA
>> driver are qla. The scsi async scan is not supported in this version=
=2E
>> And It seems that,  if the scan starts at scsi_scan_host, the naming
>> order is ensured.  Did the qla driver scan the lun in the thread
>> qla2x00_do_dpc itself?  To generate the sd name, sd_probe need to be
>> invoked. I can not find the invokation in the qla driver.
>
> This is business as usual.  The discovery order isn't guaranteed.
> Without async scan it depends on machine deterministic things like th=
e
> order the bios lays out the PCI bus, but that's not going to be const=
ant
> across machines.  Async scanning just makes reordering less machine
> hardware dependent.
Yes, I didn't find any reference of scsi_scan_host in the qla2xxx
driver source code. How does the driver probe the lun, create sdev for
the lun and finally invoke sd_probe to generate device file for the
lun?
I'm little confused about the bios order.  The host controller is pci
device, They may be laid out randomly by the bios. But for each host
controller, the names of the luns which belong to the same host
controller should be orderd. But this is not true in my case. So I
think the qla driver probes the lun and contends for names in
parallel. It's said that the qla2x00_rescan_fcports function is
invoked in thread  qla2x00_do_dpc to probe luns. But how does it
works?

Thanks,

>
> The way to cope with this is to mount devices by device id or uuid.
>
> James
>
>
>



--=20
Xie Gang
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
