From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Thu, 25 Oct 2018 14:31:44 -0700
Message-ID: <20181025213144.GB24709@flashbox>
References: <20180930205448.26205-1-natechancellor@gmail.com>
 <10b12992-3570-4646-374b-82cbd7276839@acm.org>
 <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
 <1538503063.193396.6.camel@acm.org>
 <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
 <1538521591.193396.8.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1538521591.193396.8.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, ooo@electrozaur.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 02, 2018 at 04:06:31PM -0700, Bart Van Assche wrote:
> On Tue, 2018-10-02 at 15:33 -0700, Nick Desaulniers wrote:
> > On Tue, Oct 2, 2018 at 10:57 AM Bart Van Assche <bvanassche@acm.org> wrote:
> > > Explicitly initialized global and static variables end up in the .data
> > > section and need space in that section.
> > 
> > Unless the initial value is zero.
> > https://godbolt.org/z/curRoO
> > 
> > So you don't wind up with an increase in binary size simply by having
> > global variables initialized to zero, right?  Instead the kernel knows
> > to create a zero'd out mapping for bss.  You don't need a run of zeros
> > in the binary.
> > 
> > So I disagree when you said earlier "zero initializers should be left
> > out to minimize the size of object files." I assert they don't affect
> > the size of the binary.
> > 
> > If you had many global variables all initialized to zero, why would
> > you encode that many zeros in a binary, when you can just set a size
> > on the bss section and have the kernel create the appropriate sized
> > and zero'd mapping?
> > 
> > > That is not the case if the
> > > initializer is left out and these variables end up in the .bss section.
> > 
> > From my above link, gcc will put globals without initializers into "common."
> 
> No matter what particular compiler versions do with explicit initialization
> to zero, the preferred kernel coding style is to leave out such explicit
> initialization.
> 
> Bart.

Hi Bart,

I'm sorry if I didn't follow the conclusion of this conversation properly
but this is the below diff you were initially looking for, correct?

If so, Boaz and Nick, do you have any objections if this is v2? I'd like
to get this patch accepted so the warning can be fixed for everyone.

Thanks,
Nathan

================================================================================

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index e19fa883376f..4250f739beb3 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -58,6 +58,8 @@

 enum { OSD_REQ_RETRIES = 1 };

+static const struct osd_obj_id osd_root_object;
+
 MODULE_AUTHOR("Boaz Harrosh <ooo@electrozaur.com>");
 MODULE_DESCRIPTION("open-osd initiator library libosd.ko");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index eaf36ccf58db..770c758baaa9 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -73,6 +73,7 @@

 static const char osd_name[] = "osd";
 static const char *osd_version_string = "open-osd 0.2.1";
+static const struct osd_obj_id osd_root_object;

 MODULE_AUTHOR("Boaz Harrosh <ooo@electrozaur.com>");
 MODULE_DESCRIPTION("open-osd Upper-Layer-Driver osd.ko");
diff --git a/include/scsi/osd_types.h b/include/scsi/osd_types.h
index 48e8a165e136..eb31357ec8b3 100644
--- a/include/scsi/osd_types.h
+++ b/include/scsi/osd_types.h
@@ -28,8 +28,6 @@ struct osd_obj_id {
        osd_id id;
 };

-static const struct __weak osd_obj_id osd_root_object = {0, 0};
-
 struct osd_attr {
        u32 attr_page;
        u32 attr_id;
