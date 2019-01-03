From: Randall Huang <ihhuang@abmail.org>
Subject: Re: [PATCH] scsi: associate bio write hint with WRITE CDB
Date: Thu, 3 Jan 2019 17:47:55 +0800
Message-ID: <20190103094755.GA96532@google.com>
References: <20181226041504.66283-1-huangrandall@google.com>
 <20190103075133.GA5141@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190103075133.GA5141@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: huangrandall@google.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 02, 2019 at 11:51:33PM -0800, Christoph Hellwig wrote:
> On Wed, Dec 26, 2018 at 12:15:04PM +0800, Randall Huang wrote:
> > In SPC-3, WRITE(10)/(16) support grouping function.
> > Let's associate bio write hint with group number for
> > enabling StreamID or Turbo Write feature.
> > 
> > Signed-off-by: Randall Huang <huangrandall@google.com>
> > ---
> >  drivers/scsi/sd.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 4b49cb67617e..28bfa9ed2b54 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -1201,7 +1201,12 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
> >  		SCpnt->cmnd[11] = (unsigned char) (this_count >> 16) & 0xff;
> >  		SCpnt->cmnd[12] = (unsigned char) (this_count >> 8) & 0xff;
> >  		SCpnt->cmnd[13] = (unsigned char) this_count & 0xff;
> > -		SCpnt->cmnd[14] = SCpnt->cmnd[15] = 0;
> > +		if (rq_data_dir(rq) == WRITE) {
> > +			SCpnt->cmnd[14] = rq->bio->bi_write_hint & 0x3f;
> > +		} else {
> > +			SCpnt->cmnd[14] = 0;
> > +		}
> 
> No need for braces here.
Already send a new version
> 
> But what I'm more worried about is devices not recognizing the feature
> throwing up on the field.  Can you check what SBC version first
> references these or come up with some other decently smart conditional?
My reference is SCSI Block Commands – 3 (SBC-3) Revision 25.
Section 5.32 WRITE (10) and 5.34 WRITE (16)

> Maybe Martin has a good idea, too.
