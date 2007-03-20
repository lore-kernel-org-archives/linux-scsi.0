From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 2/3] sd: implement START/STOP management
Date: Wed, 21 Mar 2007 02:08:11 +0900
Message-ID: <460014FB.1050703@gmail.com>
References: <20070320150718.GF6152@htj.dyndns.org>	 <20070320151359.GG6152@htj.dyndns.org> <1174409899.3522.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:62655 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965310AbXCTRIT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 13:08:19 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1673531uga
        for <linux-scsi@vger.kernel.org>; Tue, 20 Mar 2007 10:08:18 -0700 (PDT)
In-Reply-To: <1174409899.3522.16.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, djwong@us.ibm.com, hmh@hmh.eng.br

James Bottomley wrote:
> On Wed, 2007-03-21 at 00:13 +0900, Tejun Heo wrote:
>> Implement SBC START/STOP management.  sdev->mange_start_stop is added.
>> When it's set to one, sd STOPs the device on suspend and shutdown and
>> STARTs it on resume.  sdev->manage_start_stop defaults is in sdev
>> instead of scsi_disk cdev to allow ->slave_config() override the
>> default configuration but is exported under scsi_disk sysfs node as
>> sdev->allow_restart is.
>>
>> When manage_start_stop is zero (the default value), this patch doesn't
>> introduce any behavior change.
> 
> I have this in scsi-misc-2.6.  There was a minor space before tab no-no
> which git complained about (and I fixed).  Unfortunately, there's a
> pretty major merge conflict with prior sd.c patches in scsi-misc-2.6.
> I've merged and fixed this but it's going to create a bit of a
> difficulty for applying the libata pieces.

I got too comfortable with libata-dev#upstream and forgot to verify
patches against scsi-misc-2.6.  Sorry about that.  If you don't have
objection against the content, I'll resubmit the SCSI part against
scsi-misc-2.6.  Once it's in scsi-misc-2.6, we can pull it into
libata-dev#upstream and do the libata part there.  As the SCSI change
doesn't break libata, they can be done separately.

Thanks.

-- 
tejun
