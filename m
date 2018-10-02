From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Tue, 2 Oct 2018 10:24:18 -0700
Message-ID: <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
References: <20180930205448.26205-1-natechancellor@gmail.com> <10b12992-3570-4646-374b-82cbd7276839@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <10b12992-3570-4646-374b-82cbd7276839@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: bvanassche@acm.org
Cc: Nathan Chancellor <natechancellor@gmail.com>, ooo@electrozaur.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 1, 2018 at 6:16 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 9/30/18 1:54 PM, Nathan Chancellor wrote:
> > diff --git a/include/scsi/osd_types.h b/include/scsi/osd_types.h
> > index 48e8a165e136..6b6fdcafa6cc 100644
> > --- a/include/scsi/osd_types.h
> > +++ b/include/scsi/osd_types.h
> > @@ -28,7 +28,7 @@ struct osd_obj_id {
> >       osd_id id;
> >   };
> >
> > -static const struct __weak osd_obj_id osd_root_object = {0, 0};
> > +static const struct osd_obj_id osd_root_object = {0, 0};
>
> Structure definitions should occur in .c files instead of in header
> files especially if the header file is included from multiple source
> files. Please consider moving the definition of osd_root_object into a
> .c file.

> Additionally, zero initializers should be left out to minimize
> the size of object files.

Sorry, my understanding was that global variables either occupy the
.bss section or the .data section, depending on whether they were
zero-initialized vs initialized to non-zero, respectively (where
non-initialized are treated as zero initialized).  Looks like without
the explicit zero initialization, compilers will put the symbols in a
"common" section, which `man 1 nm` says is also unitialized data.  I
didn't think .bss sections occupied space in an object file or binary;
the kernel's loader would set up the mappings at execution?  Can you
clarify?

>
> Boaz, the most recent osd patch that is neither trivial nor treewide
> refactoring is six years old (51976a8c85ce ("[SCSI] osd_uld: Add osdname
> & systemid sysfs at scsi_osd class"). That suggests that nobody is using
> this driver anymore. Can this driver be removed from the kernel tree?
>
> Thanks,
>
> Bart.



-- 
Thanks,
~Nick Desaulniers
