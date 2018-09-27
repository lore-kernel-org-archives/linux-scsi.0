From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] scsi: bfa: Avoid implicit enum conversion in
 bfad_im_post_vendor_event
Date: Thu, 27 Sep 2018 16:49:33 -0700
Message-ID: <20180927234933.GA15651@flashbox>
References: <20180926045435.9213-1-natechancellor@gmail.com>
 <CAKwvOdmc+LE60tYFGzoWV5OA9kTLVqq9O9SAvXKmFZmRWD7BRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKwvOdmc+LE60tYFGzoWV5OA9kTLVqq9O9SAvXKmFZmRWD7BRQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 27, 2018 at 04:35:37PM -0700, Nick Desaulniers wrote:
> On Tue, Sep 25, 2018 at 9:58 PM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > Clang warns when one enumerated type is implicitly converted to another.
> >
> > drivers/scsi/bfa/bfa_fcs_lport.c:379:26: warning: implicit conversion
> > from enumeration type 'enum bfa_lport_aen_event' to different
> > enumeration type 'enum bfa_ioc_aen_event' [-Wenum-conversion]
> >                                   BFA_AEN_CAT_LPORT, event);
> >                                                      ^~~~~
> >
> > The root cause of these warnings is the bfad_im_post_vendor_event
> > function, which expects a value from enum bfa_ioc_aen_event but there
> > are multiple instances of values from enums bfa_port_aen_event,
> > bfa_audit_aen_event, and bfa_lport_aen_event being used in this
> > function.
> 
> Indeed, it seems that bfad_im_post_vendor_event() assigns this parameter to
> 161         entry->aen_type = evt;
> 
> which is defined as:
> 
> 1456         u32                     aen_type;
> 
> so already we know that aen_type is meant to be a grab bag of enum
> values.  bfad_im_post_vendor_event() is already passed many different
> types of enums, as you mention.  Does changing aen_type to an `int`
> produce further warnings, because it would be nice to have that change
> in this one, too.  AFAICT, it's only ever saved away in a containing
> struct.
> 

No, it doesn't introduce any new warnings. I can send that as a v2 here shortly.

Nathan

> >
> > Given that this doesn't appear to be a problem since cat helps with
> > differentiating the events, just change evt's type to int so that no
> > conversion needs to happen and Clang won't warn.
> >
> > Link: https://github.com/ClangBuiltLinux/linux/issues/147
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >
> > The alternate way of fixing these warnings is to explicitly cast the
> > conversion when calling the function but since there are about 8-10 of
> > these warnings, it seems logical to just change the function definiton
> > which is cleaner in my opinion.
> >
> > See commits 3eb95feac113 ("mm/zsmalloc.c: change stat type parameter to
> > int") and 04fecbf51b3c ("mm: memcontrol: use int for event/state
> > parameter in several functions") for similar fixes.
> >
> >  drivers/scsi/bfa/bfad_im.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
> > index e61ed8dad0b4..bd4ac187fd8e 100644
> > --- a/drivers/scsi/bfa/bfad_im.h
> > +++ b/drivers/scsi/bfa/bfad_im.h
> > @@ -143,7 +143,7 @@ struct bfad_im_s {
> >  static inline void bfad_im_post_vendor_event(struct bfa_aen_entry_s *entry,
> >                                              struct bfad_s *drv, int cnt,
> >                                              enum bfa_aen_category cat,
> > -                                            enum bfa_ioc_aen_event evt)
> > +                                            int evt)
> >  {
> >         struct timespec64 ts;
> >
> > --
> > 2.19.0
> >
> 
> 
> -- 
> Thanks,
> ~Nick Desaulniers
