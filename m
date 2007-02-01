From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] - export scsilun_to_int
Date: Thu, 01 Feb 2007 03:35:42 -0500
Message-ID: <45C1A65E.8000708@garzik.org>
References: <20070131225433.GA6652@lsil.com> <1170294717.3402.92.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37102 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422680AbXBAIfp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Feb 2007 03:35:45 -0500
In-Reply-To: <1170294717.3402.92.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Eric Moore <eric.moore@lsi.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2007-01-31 at 15:54 -0700, Eric Moore wrote:
>> static int
>> +mptscsih_cmp_scsilun(struct scsi_lun * lun1, struct scsi_lun * lun2)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i < 8 ; i++)
>> +               if (lun1->scsi_lun[i] != lun2->scsi_lun[i])
>> +                       return 1;
>> +
>> +       return 0;
>> +}
> 
> what's wrong with
> 
> memcmp(lun1->scsi_lun, lun2->scsi_lun, 8)
> 
> rather than introducing a wrapper?  The compiler can even optimise
> memcmp for a fixed size nicely.

I would rather introduce a wrapper that calls memcmp()

That's why I have done in my scsilun tree (jgarzik/scsilun-2.6.git, 
branches submit1, submit1 and hacking)

	Jeff


