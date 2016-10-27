From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: A question regarding "multiple SGL"
Date: Thu, 27 Oct 2016 08:41:15 +0200
Message-ID: <20161027064115.GA5864@lst.de>
References: <20161027005230.9904DC00097@webmail.sinamail.sina.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161027005230.9904DC00097-2RFepEojUI2gQzYKMK1YzK/p1tWXv8elb9TvmfFkwKk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?B?6ZGr5oS/?= <qiuxincsu-k+cT0dCbe1g@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "tiger.zhao" <tiger.zhao-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, qiuxin <qiuxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Robert,

There is no feature called "Multiple SGL in one NVMe capsule".  The
NVMe over Fabrics specification allows a controller to advertise how
many SGL descriptors it supports using the MSDBD Identify field:

"Maximum SGL Data Block Descriptors (MSDBD): This field indicates the
maximum number of (Keyed) SGL Data Block descriptors that a host is allowed to
place in a capsule. A value of 0h indicates no limit."

Setting this value to 1 is perfectly valid.  Similarly a host is free
to chose any number of SGL descriptors between 0 (only for command that
don't transfer data) to the limit imposed by the controller using the
MSDBD field.

There are no plans to support a MSDBD value larger than 1 in the Linux
NVMe target, and there are no plans to ever submit commands with multiple
SGLs from the host driver either.

Cheers,
	Christoph
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
