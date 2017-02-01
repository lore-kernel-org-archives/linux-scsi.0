From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH] scsi, block: fix duplicate bdi name registration
        crashes
Date: Wed, 1 Feb 2017 09:07:36 +0100
Message-ID: <20170201080736.GA29170@lst.de>
References: <148566590827.1627.3631056985359212959.stgit@dwillia2-desk3.amr.corp.intel.com> <20170130122452.GA9043@lst.de> <CAPcyv4jJ5VMNueBTkYhTS=DmAQVDT6qJV0Do86ZNVGLGoTJ=gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4jJ5VMNueBTkYhTS=DmAQVDT6qJV0Do86ZNVGLGoTJ=gQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@osandov.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 30, 2017 at 01:53:36PM -0800, Dan Williams wrote:
> On Mon, Jan 30, 2017 at 4:24 AM, Christoph Hellwig <hch@lst.de> wrote:
> > Hi Dan,
> >
> > this looks mostly fine to me.  A few code comments below, but except
> > for this there is another issue with it:  We still have drivers
> > that share a single request_queue for multiple gendisks, so I wonder
> 
> scsi drivers or others? If those drivers can switch to dynamically
> allocated devt (GENHD_FL_EXT_DEVT), then they don't need this fix.

Mostly old floppy drivers.
