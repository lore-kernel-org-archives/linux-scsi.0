From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: associate bio write hint with WRITE CDB
Date: Thu, 03 Jan 2019 16:40:41 -0500
Message-ID: <6152b478ea77dacf57eef6f758ba795f756cd3da.camel@redhat.com>
References: <20181226041504.66283-1-huangrandall@google.com>
         <20190103075133.GA5141@infradead.org> <20190103094755.GA96532@google.com>
         <e5bc96cd-1b48-3b7e-706f-4cbbd1a040a4@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e5bc96cd-1b48-3b7e-706f-4cbbd1a040a4@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com, Randall Huang <ihhuang@abmail.org>, Christoph Hellwig <hch@infradead.org>
Cc: huangrandall@google.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2019-01-03 at 16:00 -0500, Douglas Gilbert wrote:
> On 2019-01-03 4:47 a.m., Randall Huang wrote:
> > On Wed, Jan 02, 2019 at 11:51:33PM -0800, Christoph Hellwig wrote:
> > > On Wed, Dec 26, 2018 at 12:15:04PM +0800, Randall Huang wrote:
> > > > In SPC-3, WRITE(10)/(16) support grouping function.
> > > > Let's associate bio write hint with group number for
> > > > enabling StreamID or Turbo Write feature.
> > > > 
> > > > Signed-off-by: Randall Huang <huangrandall@google.com>
> > > > ---
> > > >   drivers/scsi/sd.c | 14 ++++++++++++--
> > > >   1 file changed, 12 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > > > index 4b49cb67617e..28bfa9ed2b54 100644
> > > > --- a/drivers/scsi/sd.c
> > > > +++ b/drivers/scsi/sd.c
> > > > @@ -1201,7 +1201,12 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
> > > >   		SCpnt->cmnd[11] = (unsigned char) (this_count >> 16) & 0xff;
> > > >   		SCpnt->cmnd[12] = (unsigned char) (this_count >> 8) & 0xff;
> > > >   		SCpnt->cmnd[13] = (unsigned char) this_count & 0xff;
> > > > -		SCpnt->cmnd[14] = SCpnt->cmnd[15] = 0;
> > > > +		if (rq_data_dir(rq) == WRITE) {
> > > > +			SCpnt->cmnd[14] = rq->bio->bi_write_hint & 0x3f;
> > > > +		} else {
> > > > +			SCpnt->cmnd[14] = 0;
> > > > +		}
> > > 
> > > No need for braces here.
> > 
> > Already send a new version
> > > 
> > > But what I'm more worried about is devices not recognizing the feature
> > > throwing up on the field.  Can you check what SBC version first
> > > references these or come up with some other decently smart conditional?
> > 
> > My reference is SCSI Block Commands – 3 (SBC-3) Revision 25.
> > Section 5.32 WRITE (10) and 5.34 WRITE (16)
> > 
> > > Maybe Martin has a good idea, too.
> 
> That is the GROUP NUMBER field. Also found in READ(16) at the same
> location within its cdb. The proposed code deserves at least an
> explanatory comment.
> 
> Since it is relatively recent, perhaps the above should only be done iff:
>     - the REPORT SUPPORTED OPERATION CODES (RSOC) command is supported, and
>     - in the RSOC entry for WRITE(16), the CDB USAGE DATA field (a bit mask)
>       indicates the GROUP NUMBER field is supported
> 
> That check can be done once, at disk attachment time where there is already
> code to fetch RSOC.
> 
> 
> Is there a bi_read_hint ? If not then the bi_write_hint should also be applied
> to READ(16). Makes that variable naming look pretty silly though.
> 
> Doug Gilbert
> 

SBC-5 says that support for the grouping function is indicated by the
GROUP_SUP bit in the Extended Inquiry VPD page (86h).  I'm not sure how
many devices actually support that page though.  Probably most don't.

What devices actually DO support the grouping and do something with it?

We'd probably need a blacklist flag to turn this off and/or some code in
the error path to discontinue setting the field if the device returns
INVALID FIELD IN CDB or something, like we do for disabling discard
commands if they don't actually work in sd_done().

-Ewan
