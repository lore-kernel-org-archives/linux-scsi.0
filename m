From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Fri, 16 Aug 2013 18:41:57 +0200
Message-ID: <20130816164156.GA14582@dhcp-26-207.brq.redhat.com>
References: <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
 <1374248000.2266.20.camel@dabdike>
 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
 <51EAA33C.9010405@fusionio.com>
 <20130809191542.GD25306@dhcp-26-207.brq.redhat.com>
 <1376079457.5171.172.camel@haakon3.risingtidesystems.com>
 <20130815162316.GA27882@dhcp-26-207.brq.redhat.com>
 <1376619569.5171.217.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1376619569.5171.217.camel@haakon3.risingtidesystems.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Mike Christie <mchristie@fusionio.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 15, 2013 at 07:19:29PM -0700, Nicholas A. Bellinger wrote:
> I'm playing with a patch to do this, but am currently getting hung-up on
> what appear to be some separate blk-mq reserved_tags > 0 bugs, the first
> of which is passing queue_depth=1 + reserved_tags=1 is broken, and
> results in tags->nr_free = 0.

That is not a bug - please look at Jens replies in this thread some week ago.
In short, queue_depth=1 means 1 tags in total and reserved_tags=1 results
in zero normal tags. You need to request the depth=2 and reserved_tags=1.

But yes, this is a separate topic and I am looking forward to hear from Jens
wrt flushes.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
