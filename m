From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Fri, 26 Oct 2018 10:54:02 -0700
Message-ID: <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
References: <20180930205448.26205-1-natechancellor@gmail.com>
 <10b12992-3570-4646-374b-82cbd7276839@acm.org> <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
 <1538503063.193396.6.camel@acm.org> <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
 <1538521591.193396.8.camel@acm.org> <20181025213144.GB24709@flashbox>
 <CAKwvOdn=TvoGdFvgxX6TyXBXnhVLttriRrZEnzS6DjcjL64DPA@mail.gmail.com> <20181025225548.GA10326@flashbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181025225548.GA10326@flashbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: bvanassche@acm.org, ooo@electrozaur.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 25, 2018 at 3:55 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Thu, Oct 25, 2018 at 03:02:13PM -0700, Nick Desaulniers wrote:
> > On Thu, Oct 25, 2018 at 2:31 PM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> > >
> > > On Tue, Oct 02, 2018 at 04:06:31PM -0700, Bart Van Assche wrote:
> > > > On Tue, 2018-10-02 at 15:33 -0700, Nick Desaulniers wrote:
> > > > > On Tue, Oct 2, 2018 at 10:57 AM Bart Van Assche <bvanassche@acm.org> wrote:
> > > > > > Explicitly initialized global and static variables end up in the .data
> > > > > > section and need space in that section.
> > > > >
> > > > > Unless the initial value is zero.
> > > > > https://godbolt.org/z/curRoO
> > > > >
> > > > > So you don't wind up with an increase in binary size simply by having
> > > > > global variables initialized to zero, right?  Instead the kernel knows
> > > > > to create a zero'd out mapping for bss.  You don't need a run of zeros
> > > > > in the binary.
> > > > >
> > > > > So I disagree when you said earlier "zero initializers should be left
> > > > > out to minimize the size of object files." I assert they don't affect
> > > > > the size of the binary.
> > > > >
> > > > > If you had many global variables all initialized to zero, why would
> > > > > you encode that many zeros in a binary, when you can just set a size
> > > > > on the bss section and have the kernel create the appropriate sized
> > > > > and zero'd mapping?
> > > > >
> > > > > > That is not the case if the
> > > > > > initializer is left out and these variables end up in the .bss section.
> > > > >
> > > > > From my above link, gcc will put globals without initializers into "common."
> > > >
> > > > No matter what particular compiler versions do with explicit initialization
> > > > to zero, the preferred kernel coding style is to leave out such explicit
> > > > initialization.
> > > >
> > > > Bart.
> > >
> > > Hi Bart,
> > >
> > > I'm sorry if I didn't follow the conclusion of this conversation properly
> > > but this is the below diff you were initially looking for, correct?
> > >
> > > If so, Boaz and Nick, do you have any objections if this is v2? I'd like
> > > to get this patch accepted so the warning can be fixed for everyone.
> >
> > Hi Nathan,
> > Thanks for following up on this.  Bart's note about the one definition
> > rule is important.  If you define the variable static in two different
> > translation units, you've suddenly created two different copies
> > accessible only to their respective translation units.  So it should
> > be declared extern in one source file (but not defined/initialized),
> > and defined (non-static) in another.  See below for example.
> >
>
> Hi Nick,
>
> I just want to make sure I understand what is going on here.
>
> Doesn't the first part already happen because osd_root_object is
> declared static in osd_types.h? I tried this little simple example of
> adding a 'static const' variable to a header file and using it in two
> separate files/functions. When compiled together, they point to two
> different locations in memory.
>
> ==============================================
>
> $ clang -std=gnu89 main.c test1.c test2.c
> $ ./a.out
> test in test1(): 0x55b4df3a001c
> test in test2(): 0x55b4df3a003c
>
> ==============================================
>
> main.c:
>
> #include "test.h"
>
> int main(void) {
>         test1();
>         test2();
> }
>
> ==============================================
>
> test1.c:
>
> #include <stdio.h>
> #include "test.h"
>
> void test1() {
>     printf("test in test1(): %p\n", &test);
> }
>
> ==============================================
>
> test2.c:
>
> #include <stdio.h>
> #include "test.h"
>
> void test2() {
>     printf("test in test2(): %p\n", &test);
> }
>
> ==============================================
>
> test.h:
>
> struct test_struct {
>     int a;
>     int b;
> };
>
> static const struct test_struct test = {0, 0};
> void test1();
> void test2();
>
> ==============================================
>
> If that is the case, could your suggested change result in a functional
> change given that the code would now refer to the same osd_root_object?

It's hard to say without knowing the original intent of the code.
>From the variable's identifier and fact that it's global, I *assume*
that we want only 1 struct osd_obj_id which is the root, hence the
identifier `osd_root_object`.  It has 4 references in the entire
kernel; it doesn't make sense to my why those references would want to
be referring to two different instances of `osd_root_object`.  Maybe
the maintainers can clarify if 2 instances is the intent?

Further complicated is the use of the __weak attribute AND the
compiler flag -fno-common (which the kernel sets in the top level
Makefile).  Also, it seems that ODR is a C++ concept; it's not clear
to me if there's semantic differences with C or not (I don't think so
in this case, but I've learned not to bet on subtle semantic
differences between the languages not existing).

__attribute__((weak)) AND static on a global variable declared in a
header raises many red flags to me.  Was weak added to work around an
ODR link error?

If creating one instance of this variable is a functional change, I
can't help but suspect the original code was wrong.  But maybe Bart,
Boaz, or Christoph can clarify or have more thoughts on this?  Looks
like Boaz added this header in commit de258bf5e638 ("[SCSI] libosd:
OSDv1 Headers").

> This isn't necessarily a problem, especially since it sounds like not
> referring to the same object could be a bug, but I want to make sure
> that's what is intended by these changes, which I'll be happy to spin up
> in a v2.
>
> If I am thinking about this incorrectly or my example is wrong in any
> way, please let me know. I'm trying to soak up all of this knowledge
> so I can be a better contributor.
>
> Thanks for the reply and explanation!
> Nathan
>
> > >
> > > Thanks,
> > > Nathan
> > >
> > > ================================================================================
> > >
> > > diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> > > index e19fa883376f..4250f739beb3 100644
> > > --- a/drivers/scsi/osd/osd_initiator.c
> > > +++ b/drivers/scsi/osd/osd_initiator.c
> > > @@ -58,6 +58,8 @@
> > >
> > >  enum { OSD_REQ_RETRIES = 1 };
> > >
> > > +static const struct osd_obj_id osd_root_object;
> >
> > extern const struct osd_obj_id osd_root_object;
> >
> > > +
> > >  MODULE_AUTHOR("Boaz Harrosh <ooo@electrozaur.com>");
> > >  MODULE_DESCRIPTION("open-osd initiator library libosd.ko");
> > >  MODULE_LICENSE("GPL");
> > > diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> > > index eaf36ccf58db..770c758baaa9 100644
> > > --- a/drivers/scsi/osd/osd_uld.c
> > > +++ b/drivers/scsi/osd/osd_uld.c
> > > @@ -73,6 +73,7 @@
> > >
> > >  static const char osd_name[] = "osd";
> > >  static const char *osd_version_string = "open-osd 0.2.1";
> > > +static const struct osd_obj_id osd_root_object;
> >
> > const struct osd_obj_id osd_root_object;
> >
> > >
> > >  MODULE_AUTHOR("Boaz Harrosh <ooo@electrozaur.com>");
> > >  MODULE_DESCRIPTION("open-osd Upper-Layer-Driver osd.ko");
> > > diff --git a/include/scsi/osd_types.h b/include/scsi/osd_types.h
> > > index 48e8a165e136..eb31357ec8b3 100644
> > > --- a/include/scsi/osd_types.h
> > > +++ b/include/scsi/osd_types.h
> > > @@ -28,8 +28,6 @@ struct osd_obj_id {
> > >         osd_id id;
> > >  };
> > >
> > > -static const struct __weak osd_obj_id osd_root_object = {0, 0};
> > > -
> >
> > LGTM
> >
> > >  struct osd_attr {
> > >         u32 attr_page;
> > >         u32 attr_id;
> >
> > That way the linker knows there's only one instance of this struct in
> > memory, and that the two different translation units are referring to
> > the same instance.  The other maintainers may have a preference which
> > translation you define osd_root_object in (I arbitrarily chose
> > drivers/scsi/osd/osd_uld.c), but if they don't have additional
> > feedback after some amount of time, I'd assume they're ok with the
> > above suggestion.  What do you think?
> >
> > --
> > Thanks,
> > ~Nick Desaulniers



-- 
Thanks,
~Nick Desaulniers
