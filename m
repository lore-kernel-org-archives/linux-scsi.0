From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REGRESSION 3.17] scsi (uas) disks no longer using tagged
 command queuing
Date: Thu, 11 Sep 2014 09:13:31 -0700
Message-ID: <20140911161331.GA24488@infradead.org>
References: <540EC52C.3000804@redhat.com>
 <20140909152730.GA17882@infradead.org>
 <540FFBF4.9090001@redhat.com>
 <20140910154535.GA5102@infradead.org>
 <541172E9.8070309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <541172E9.8070309@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-usb <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 11, 2014 at 12:01:13PM +0200, Hans de Goede wrote:
> > So we're initializing the tag map, but scsi_activate_tcq doesn't pick it
> > up.  I can't really come up with a good explanation for it, but there
> > even without that there is an elephant in the room:  as part of the
> > scsi-mq series I moved the bqt field used for this into a union with the
> > new blk_mq_tag_set.  Below is a patch to get rid of that union, can you
> > try if that fixes it?
> 
> Unfortunately that does not fix it :|

Alright, I guess we need the big bisect hammer unfortunately.

We should be able to start with trying the first and last commit
of the big SCSI merge:

 start:		fcc95a763444017288b318d48367098850c23c0d
 end:		c21a2c1a4973c8dde32557970fdb44eaa9489aeb
