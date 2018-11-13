From: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Subject: Re: [PATCH] drivers/scsi/fnic/fnic_trace.c: Use vzalloc
Date: Tue, 13 Nov 2018 21:34:59 +0530
Message-ID: <CAJr6mf1Og4uNG3gOu56EBrm+2MQGg9=SZ2mCn9hQ=+8Er-WkBw@mail.gmail.com>
References: <5beae8ff.1c69fb81.bd59a.b7fa@mx.google.com> <a34379dd-f6f0-b439-b6de-f2db142f1823@huawei.com>
 <13d3418f-49d1-d683-48a6-cedbc073d86f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <13d3418f-49d1-d683-48a6-cedbc073d86f@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: jthumshirn@suse.de
Cc: john.garry@huawei.com, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, Souptick Joarder <jrdr.linux@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Brajeswar Ghosh <brajeswar.linux@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 13, 2018 at 9:23 PM Johannes Thumshirn <jthumshirn@suse.de> wro=
te:
>
> On 13/11/2018 16:44, John Garry wrote:
> > On 13/11/2018 15:08, Sabyasachi Gupta wrote:
> >> Replaced vmalloc + memset with vzalloc
> >>
> >> Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
> >> ---
> >>  drivers/scsi/fnic/fnic_trace.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/scsi/fnic/fnic_trace.c
> >> b/drivers/scsi/fnic/fnic_trace.c
> >> index 8271785..129ab27 100644
> >> --- a/drivers/scsi/fnic/fnic_trace.c
> >> +++ b/drivers/scsi/fnic/fnic_trace.c
> >> @@ -468,14 +468,14 @@ int fnic_trace_buf_init(void)
> >>      fnic_max_trace_entries =3D (trace_max_pages * PAGE_SIZE)/
> >>                        FNIC_ENTRY_SIZE_BYTES;
> >>
> >> -    fnic_trace_buf_p =3D (unsigned long)vmalloc((trace_max_pages *
> >> PAGE_SIZE));
> >> +    fnic_trace_buf_p =3D (unsigned long)vzalloc((trace_max_pages *
> >> +                                PAGE_SIZE));
> >
> > If you remove the extra brackets in vzalloc() argument then you may not
> > spill onto the next line.
>
> And remove the unnecessary cast. vzalloc() (just like vmalloc()) returns
> a void*, so no reason to cast it.
>
> --
> Johannes Thumshirn                                        SUSE Labs
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
 I will remove it and send v2
