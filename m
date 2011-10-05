From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Re: Re: BUG in kernel: Wrong Handling of USB
 =?UTF-8?Q?HDD=E2=80=99s?= in scsiglue(slave_configure) and
 scsi/sd(sd_read_cache_type)
Date: Wed, 05 Oct 2011 10:24:02 -0700
Message-ID: <1317835442.7238.8.camel@dabdike>
References: <CADDb1s0ZnHzM72sDnFmRrM=GFJtxj5JkYUSPo6GdyQ_=7L2m9A@mail.gmail.com>
	 <Pine.LNX.4.44L0.1110041007070.1954-100000@iolanthe.rowland.org>
	 <CADDb1s0taBR2=xpKE5rLJTWJBMbXijS8b_GEA-MbZvWKFDFvYg@mail.gmail.com>
	 <CADDb1s3sPxpfNi-OD=QvVT+JWO9kUeTAmb8ZGyN0YCuBKWd4rg@mail.gmail.com>
	 <CADDb1s3FN4Ft2yXs-L8LfhoJEDP+KhSCrG8GGbOUgn_GXEr0yA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDb1s3FN4Ft2yXs-L8LfhoJEDP+KhSCrG8GGbOUgn_GXEr0yA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-10-05 at 22:29 +0530, Amit Sahrawat wrote:
> Can anyone suggest what is the way ahead to detect the presence of
> Write Cache in these kind of USB HDD and proceed accordingly by
> assigning proper flushing method.
> Please share some opinions on this.

We're a bit out of ideas.  We've already established that we do exactly
what windows does in this situation, which is usually what we aim for.
Realistically, if the disks lie how do we know when not to believe them?

The best we could probably offer is an interface to turn on the WCE bit
in software (technically, you can do this today
in /scsi/class/scsi_disk/<disk>/cache_type, it's just that it will try
to commit the change as a MODE_SELECT which will presumably fail).

James
