From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: calling scsi_adjust_queue_depth() during I/O...
Date: Fri, 05 Aug 2005 12:20:31 -0500
Message-ID: <1123262432.5003.44.camel@mulgrave>
References: <20050804234155.GJ13374@plap.qlogic.org>
	 <20050805075751.GN9369@suse.de> <20050805110911.GA22867@htj.dyndns.org>
	 <42F350E6.2090109@gmail.com> <20050805123301.GA3311@htj.dyndns.org>
	 <1123259528.5003.36.camel@mulgrave>  <20050805171034.GA5046@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:46031 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263087AbVHERUs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2005 13:20:48 -0400
In-Reply-To: <20050805171034.GA5046@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-08-06 at 02:10 +0900, Tejun Heo wrote:
>  Yes, we can do that, but I'm not sure if that would be necessary.
> AFAIK, queues are normally not very deep and a tag only occupies one
> pointer and one bit.  Also, the shrinking operation isn't very common,
> at least for traditional SPI devices and SATA drives, I think.
> 
>  Are newer SCSI devices (say, SAS/iSCSI) different? - like having very
> deep queue and needing dynamic queue depth adjustment?  If that's the
> case, I think I can implement shrinking in a separate patch. (and try
> not to screw up this time ;-)

Well, yes, there are reasons for wanting deeper queues, but I'd leave it
for the time being.

What I'm looking into is support for aic7xxx/aic79xx queueing.  There,
the sequencer has to have a globally unique tag (from which it generates
the device locally unique tag internally).  That gives TCQ depths of up
to 512 I believe.  However, still probably not a significant waste of
memory to worry about.

James


