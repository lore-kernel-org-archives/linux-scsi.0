From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] scsi-mq: Only show the CDB if available
Date: Tue, 05 Dec 2017 08:43:49 -0800
Message-ID: <1512492229.3019.25.camel@linux.vnet.ibm.com>
References: <20171205003809.1705-1-bart.vanassche@wdc.com>
         <20171205003809.1705-2-bart.vanassche@wdc.com>
         <20171205011536.GC8365@ming.t460p> <1512439190.2739.0.camel@wdc.com>
         <20171205050008.GA9989@ming.t460p> <1512490952.2660.18.camel@wdc.com>
         <20171205163824.GB23788@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171205163824.GB23788@ming.t460p>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-12-06 at 00:38 +0800, Ming Lei wrote:
> On Tue, Dec 05, 2017 at 04:22:33PM +0000, Bart Van Assche wrote:
> > 
> > On Tue, 2017-12-05 at 13:00 +0800, Ming Lei wrote:
> > > 
> > > No, do not mix two different things in one patch, especially the
> > > fix part need to be backported to stable.
> > > 
> > > The fix part should aim at V4.15, and the other part can be a
> > > V4.16 stuff.
> > 
> > Does this mean that you do not plan to post a v5 of your patch and
> > that you want me to rework this patch series? I can do that.
> 
> I believe V4 has been OK for merge, actually the only concern from
> James is that 'set the cmnd to NULL *before* calling free so we
> narrow the race window.', but that isn't required as I explained,
> even though you don't do that in this patch too.
> 
> 	https://marc.info/?t=151030464300003&r=1&w=2
> 
> I will work on V5 if Martin/James thinks it is needed.

I don't buy that it isn't needed.  The point (and the pattern) is for a
destructive action set the signal *before* you execute the action not
after.  The reason should be obvious: if you set it after you invite a
race where the check says OK but the object has gone.  Even if the race
is highly unlikely, the pattern point still holds.

James
