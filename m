From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [RFC][PATCH] 2.5 hosts.c and scsi_host list cleanup
Date: Thu, 5 Sep 2002 01:26:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020904232624.GA10227@win.tue.nl>
References: <20020904204310.GA3588@beaverton.ibm.com> <20020905000158.A14644@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020905000158.A14644@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Sep 05, 2002 at 12:01:58AM +0100, Christoph Hellwig wrote:

 +       shost_name = (Scsi_Host_Name *) kmalloc(sizeof(Scsi_Host_Name),
 +                                               GFP_KERNEL);
  
 Cast isn't really needed again.


It is true that the cast is not needed, but it belongs to the good casts.
Usually a cast is bad because it disables checks.
In this case the cast is a good one, it enables checks.

[Indeed, a void * can be assigned to any pointer, so without the cast
gcc will only check that shost_name is a pointer. With the cast it
will check that it is a pointer of the right type.

	foo = (type *) kmalloc(N*sizeof(type), ...)

is a good coding habit. Of course using  sizeof(*foo)  is an alternative.]

Andries
