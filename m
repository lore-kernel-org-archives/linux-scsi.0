From: <yang.bin18-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Subject: =?UTF-8?B?UmU6W1BBVENIXSBDaGVjayBzayBiZWZvcmUgc2VuZHBhZ2U=?=
Date: Thu, 11 Jul 2019 15:42:20 +0800 (CST)
Message-ID: <201907111542202002207@zte.com.cn>
References: <1562784731.3213.98.camel@linux.ibm.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=====_001_next====="
Return-path: <open-iscsi+bncBAABBFPEULUQKGQEKSWHJZA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1562784731.3213.98.camel-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
References: 1562743809-31133-1-git-send-email-yang.bin18-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org,1562784731.3213.98.camel-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, LDuncan-IBi9RG/b67k@public.gmane.org
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wang.liang82-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, wang.yi59-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, xue.zhihong-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org
List-Id: linux-scsi@vger.kernel.org



--=====_001_next=====
Content-Type: multipart/alternative;
	boundary="=====_003_next====="


--=====_003_next=====
Content-Type: text/plain; charset="UTF-8"

> On Wed, 2019-07-10 at 17:47 +0000, Lee Duncan wrote:
> > On 7/10/19 12:30 AM, Yang Bin wrote:
> > 
> > > From: " Yang Bin "<yang.bin18-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> > > 
> > > Before xmit,iscsi may disconnect just now.
> > > So must check connection sock NULL or not,or kernel will crash for
> > > accessing NULL pointer.
> > > 
> > > Signed-off-by: Yang Bin <yang.bin18-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> > > ---
> > >  drivers/scsi/iscsi_tcp.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> > > index 7bedbe8..a59c49f 100644
> > > --- a/drivers/scsi/iscsi_tcp.c
> > > +++ b/drivers/scsi/iscsi_tcp.c
> > > @@ -264,6 +264,9 @@ static int iscsi_sw_tcp_xmit_segment(struct
> > > iscsi_tcp_conn *tcp_conn,
> > >      unsigned int copied = 0;
> > >      int r = 0;
> > >  
> > > +    if (!sk)
> > > +        return -ENOTCONN;
> > > +
> > >      while (!iscsi_tcp_segment_done(tcp_conn, segment, 0, r)) {
> > >          struct scatterlist *sg;
> > >          unsigned int offset, copy;
> > > 
> > 
> > If the socket can be closed right before iscsi_sw_tcp_xmit_segment()
> > is called, can it be called in the middle of sending segments? (In
> > which case the check would have to be in the while loop.)

> I think the important point is: is this an actual observed bug or just
> a theoretical problem?

> The reason for asking is this call is controlled directly by the
> ISCSI_UEVENT_DESTROY_CONN event sent by the iscsi daemon.  Obviously if
> the daemon goes haywire and doesn't shut down the connection before
> sending the destroy event, we may get the crash, but I would be
> inclined to say fix the daemon.

> James
We have repproduced this bug several times .
It`s a good idea that sending ISCSI_UEVENT_STOP_CONN event  first.
But there is another choice , adding "iscsi_suspend_tx" int the front of "destroy" ,
for not increasing dependence between kernel and daemon.

 Yangbin

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
To view this discussion on the web visit https://groups.google.com/d/msgid/open-iscsi/201907111542202002207%40zte.com.cn.
For more options, visit https://groups.google.com/d/optout.

--=====_003_next=====--

--=====_001_next=====--
