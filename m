From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [PATCH] Check sk before sendpage
Date: Wed, 10 Jul 2019 11:52:11 -0700
Message-ID: <1562784731.3213.98.camel@linux.ibm.com>
References: <1562743809-31133-1-git-send-email-yang.bin18@zte.com.cn>
         <1bc364ff-5bff-47ac-611a-f75c43f4bd1b@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1bc364ff-5bff-47ac-611a-f75c43f4bd1b@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <LDuncan@suse.com>, Yang Bin <yang.bin18@zte.com.cn>
Cc: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "cleech@redhat.com" <cleech@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "wang.liang82@zte.com.cn" <wang.liang82@zte.com.cn>, "wang.yi59@zte.com.cn" <wang.yi59@zte.com.cn>, "xue.zhihong@zte.com.cn" <xue.zhihong@zte.com.cn>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2019-07-10 at 17:47 +0000, Lee Duncan wrote:
> On 7/10/19 12:30 AM, Yang Bin wrote:
> 
> > From: " Yang Bin "<yang.bin18@zte.com.cn>
> > 
> > Before xmit,iscsi may disconnect just now.
> > So must check connection sock NULL or not,or kernel will crash for
> > accessing NULL pointer.
> > 
> > Signed-off-by: Yang Bin <yang.bin18@zte.com.cn>
> > ---
> >  drivers/scsi/iscsi_tcp.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> > index 7bedbe8..a59c49f 100644
> > --- a/drivers/scsi/iscsi_tcp.c
> > +++ b/drivers/scsi/iscsi_tcp.c
> > @@ -264,6 +264,9 @@ static int iscsi_sw_tcp_xmit_segment(struct
> > iscsi_tcp_conn *tcp_conn,
> >  	unsigned int copied = 0;
> >  	int r = 0;
> >  
> > +	if (!sk)
> > +		return -ENOTCONN;
> > +
> >  	while (!iscsi_tcp_segment_done(tcp_conn, segment, 0, r)) {
> >  		struct scatterlist *sg;
> >  		unsigned int offset, copy;
> > 
> 
> If the socket can be closed right before iscsi_sw_tcp_xmit_segment()
> is called, can it be called in the middle of sending segments? (In
> which case the check would have to be in the while loop.)

I think the important point is: is this an actual observed bug or just
a theoretical problem?

The reason for asking is this call is controlled directly by the
ISCSI_UEVENT_DESTROY_CONN event sent by the iscsi daemon.  Obviously if
the daemon goes haywire and doesn't shut down the connection before
sending the destroy event, we may get the crash, but I would be
inclined to say fix the daemon.

James
