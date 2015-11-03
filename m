From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1 22/25] hpsa: enhance device messages
Date: Tue, 3 Nov 2015 14:12:45 +0100
Message-ID: <5638B2CD.3080907@redhat.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220644.5323.17616.stgit@brunhilda> <56337F81.1040403@redhat.com>
 <56379543.7000907@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbbKCNMt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2015 08:12:49 -0500
In-Reply-To: <56379543.7000907@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <brace77070@gmail.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 2.11.2015 17:54, Don Brace wrote:
> On 10/30/2015 09:32 AM, Tomas Henzl wrote:
>> RAID_UNKNOWN is used in few other places - raid_level_show for example,
> raid_level_show handles physical devices by using "N/A", otherwise it 
> displays
> the RAID level for logical devices.
>
> Other functions avoid the use of raid_type when the drive is not a RAID 
> device.
>
> Or, am I missing your point?

Seems that I missed the fact that raid_level_show output is N/A,
I thought it would be "RAID-Unknown".

Last minor point is that you could replace 
+				dev->raid_level > RAID_UNKNOWN ? "?" :
+				raid_label[dev->raid_level]);
with
+				dev->raid_level > RAID_UNKNOWN ? raid_label[RAID_UNKNOWN] :
+				raid_label[dev->raid_level]);
but that's not important.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

