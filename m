From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: xcopy testing with ddpt
Date: Mon, 07 Oct 2013 17:24:26 -0700
Message-ID: <1381191866.19256.341.camel@haakon3.risingtidesystems.com>
References: <20131003160033.GC5273@glanzmann.de>
	 <524DA6EC.6000900@interlog.com> <20131005182206.GA9781@glanzmann.de>
	 <5250E0D6.8000404@interlog.com> <20131006090005.GB12340@glanzmann.de>
	 <52519FA8.9050905@interlog.com> <20131006184355.GC27090@glanzmann.de>
	 <5251D179.8020405@interlog.com> <20131006213213.GA30637@glanzmann.de>
	 <5251EAF3.8090500@interlog.com> <20131007040328.GA1439@glanzmann.de>
	 <1381184324.19256.311.camel@haakon3.risingtidesystems.com>
	 <1381185489.19256.315.camel@haakon3.risingtidesystems.com>
	 <52533EB5.9060505@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52533EB5.9060505@bootc.net>
Sender: target-devel-owner@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Cc: Thomas Glanzmann <thomas@glanzmann.de>, Douglas Gilbert <dgilbert@interlog.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <mail@hannes-reinecke.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-10-08 at 00:07 +0100, Chris Boot wrote:
> On 07/10/2013 23:38, Nicholas A. Bellinger wrote:
> > On Mon, 2013-10-07 at 15:18 -0700, Nicholas A. Bellinger wrote:
> >> On Mon, 2013-10-07 at 06:03 +0200, Thomas Glanzmann wrote:
> >>> Hello Doug,
> >>>
> >>> * Douglas Gilbert <dgilbert@interlog.com> [2013-10-07 00:58]:
> >>>> Great, another one working.
> >>
> >> (CC'ing Hannes)
> >>
> >>>> BTW list_id=0 has a special meaning in some context
> >>>> (buried deep in T10 documents: spc4r36j.pdf). That is
> >>>> probably why Hannes Reinecke defaulted that list_id to
> >>>> 1. I could understand the target XCOPY implementation
> >>>> only accepting one xcopy sequence at a time, but why
> >>>> restrict it to list_id=0 ? A question for NaB ...
> >>>
> >>> Nab, do you have any input for us?
> >>>
> >>
> >> It was my original understanding that when OPERATING_PARAMETERS is
> >> reporting SNLID=1 (Supports No ListID), the initiator is expected to
> >> send EXTENDED_COPY parameter lists with ListID Usage 11b + ListID=0.
> >> Since we're ignoring the value of ListID for now anyways, I agree that
> >> it doesn't make much sense to fail for a non zero value here..
> >>
> >> However, the main concern that made me add this check to begin with was
> >> the case with ListID Usage 00b + 10b, where the copy server is expected
> >> to keep a per I_T list of in-use ListIDs, and return CHECK_CONDITION +
> >> ILLEGAL REQUEST/OPERATION IN PROGRESS for a ListID for a copy sequence
> >> already in progress.
> >>
> > 
> > How about the following patch to allow non zero ListIDs, but only when
> > ListID Usage is set to 11b..?
> > 
> > diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
> > index 6b9774c..3a3ea31 100644
> > --- a/drivers/target/target_core_xcopy.c
> > +++ b/drivers/target/target_core_xcopy.c
> > @@ -911,11 +911,12 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
> >         }
> >  
> >         list_id = p[0];
> > -       if (list_id != 0x00) {
> > -               pr_err("XCOPY with non zero list_id: 0x%02x\n", list_id);
> > +       list_id_usage = (p[1] & 0x18);
> > +       if (list_id != 0x00 && list_id_usage != 0x11) {
> > +               pr_err("XCOPY with non zero list_id: 0x%02x, and list_id_usage:"
> > +                      " 0x%02x\n", list_id, list_id_usage);
> >                 goto out;
> >         }
> > -       list_id_usage = (p[1] & 0x18);
> >         /*
> >          * Determine TARGET DESCRIPTOR LIST LENGTH + SEGMENT DESCRIPTOR LIST LENGTH
> >          */
> > 
> > AFAICT this should make ddpt happy, as it's already be setting ListID
> > Usage = 11b when it gets OPERATING PARAMETERS -> HELD_DATA = 0.
> 
> 0x11 != 11b (but == 11h)
> 
> If 0x18 is the correct mask I think you want to compare against 0x18,
> otherwise you probably want to shift down by 3 bits and compare against
> 0x03 or 0b11...
> 

Er, duh, yes..   Looking at what sg_xcopy and ddpt are doing here again,
they are in fact using list_id_usage=10b (0x02) by default, so enforcing
a check for 11b (0x03) is not going to work as originally expected..

How about the following to simply ignore the list_id..?

--nab

 diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 6b9774c..fe98555 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -911,11 +911,8 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
        }
 
        list_id = p[0];
-       if (list_id != 0x00) {
-               pr_err("XCOPY with non zero list_id: 0x%02x\n", list_id);
-               goto out;
-       }
-       list_id_usage = (p[1] & 0x18);
+       list_id_usage = (p[1] & 0x18) >> 3;
+
        /*
         * Determine TARGET DESCRIPTOR LIST LENGTH + SEGMENT DESCRIPTOR LIST LENGTH
         */
