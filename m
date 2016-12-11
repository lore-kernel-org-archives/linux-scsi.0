From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] scsi/qla2xxx: label endian-ness for many fields
Date: Sun, 11 Dec 2016 04:02:07 +0200
Message-ID: <20161211035822-mutt-send-email-mst@kernel.org>
References: <20161209224216-mutt-send-email-mst@kernel.org>
 <1481348968.5946.48.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1481348968.5946.48.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu.Madhani@cavium.com, Bart.VanAssche@sandisk.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 09, 2016 at 09:49:28PM -0800, Joe Perches wrote:
> On Fri, 2016-12-09 at 22:45 +0200, Michael S. Tsirkin wrote:
> > This adds endian-ness labels for lots of qla structs.
> > Doing this cuts down number of sparse warnings from ~1700 to ~1400.
> > Will help find and resolve some of real issues down the road.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > ---
> > 
> > Compile-tested only.
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> > index 73b12e4..a4d3071 100644
> > --- a/drivers/scsi/qla2xxx/qla_def.h
> > +++ b/drivers/scsi/qla2xxx/qla_def.h
> > @@ -1159,28 +1159,28 @@ typedef struct {
> >  	 */
> >  	uint8_t  firmware_options[2];
> >  
> > -	uint16_t frame_payload_size;
> > -	uint16_t max_iocb_allocation;
> > -	uint16_t execution_throttle;
> > +	__le16 frame_payload_size;
> > +	__le16 max_iocb_allocation;
> > +	__le16 execution_throttle;
> 
> Shouldn't all these _not_ have the leading __?

[linux]$ git grep le32 include/linux/|grep -v _le32|grep -v le32_
[linux]$ 


> Perhaps the uint8_t uses should be converted to u8 as well.
> 
> [etc...]

Sure.  It's up to maintainers to clean up this driver though. I merely
posted this to show that proper tagging of endian-ness is not hard.

-- 
MST
