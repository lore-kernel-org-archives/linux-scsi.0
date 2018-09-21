From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] scsi: FlashPoint: Remove unnecessary parentheses
Date: Fri, 21 Sep 2018 11:17:46 -0700
Message-ID: <20180921181746.GA5415@flashbox>
References: <20180920211032.21840-1-natechancellor@gmail.com>
 <bb9c20c4-f13a-497a-0ad1-73978a9f4f3b@gonehiking.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bb9c20c4-f13a-497a-0ad1-73978a9f4f3b@gonehiking.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid@gonehiking.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 21, 2018 at 09:19:40AM -0600, Khalid Aziz wrote:
> On 09/20/2018 03:10 PM, Nathan Chancellor wrote:
> > Clang warns when multiple pairs of parentheses are used for a single
> > conditional statement.
> > 
> > In file included from drivers/scsi/BusLogic.c:57:
> > drivers/scsi/FlashPoint.c:2947:34: warning: equality comparison with extraneous parentheses [-Wparentheses-equality]
> >                                 if ((currSCCB->Sccb_scsistat == SELECT_SN_ST)) {
> >                                      ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~
> > drivers/scsi/FlashPoint.c:2947:34: note: remove extraneous parentheses around the comparison to silence this warning
> >                                 if ((currSCCB->Sccb_scsistat == SELECT_SN_ST)) {
> >                                     ~                        ^              ~
> > drivers/scsi/FlashPoint.c:2947:34: note: use '=' to turn this equality comparison into an assignment
> >                                 if ((currSCCB->Sccb_scsistat == SELECT_SN_ST)) {
> >                                                              ^~
> >                                                              =
> > drivers/scsi/FlashPoint.c:2956:39: warning: equality comparison with extraneous parentheses [-Wparentheses-equality]
> >                                 else if ((currSCCB->Sccb_scsistat ==
> >                                           ~~~~~~~~~~~~~~~~~~~~~~~~^~
> > drivers/scsi/FlashPoint.c:2956:39: note: remove extraneous parentheses around the comparison to silence this warning
> >                                 else if ((currSCCB->Sccb_scsistat ==
> >                                          ~                        ^
> > drivers/scsi/FlashPoint.c:2956:39: note: use '=' to turn this equality comparison into an assignment
> >                                 else if ((currSCCB->Sccb_scsistat ==
> >                                                                   ^~
> >                                                                   =
> > 2 warnings generated.
> > 
> > Link: https://github.com/ClangBuiltLinux/linux/issues/156
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >  drivers/scsi/FlashPoint.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> 
> There are more places in this file with extraneous parentheses, for example:
> 
>  952         if ((RD_HARPOON(ioport + hp_vendor_id_1) != ORION_VEND_1))
>  953                 return (int)FAILURE;
>  954
>  955         if ((RD_HARPOON(ioport + hp_device_id_0) != ORION_DEV_0))
>  956                 return (int)FAILURE;
>  957
>  958         if ((RD_HARPOON(ioport + hp_device_id_1) != ORION_DEV_1))
> 
> Wonder why the compiler does not complain about these, but this patch is
> good for now. I will clean up the rest in another patch.
> 
> James, Martin, please pull this patch into the scsi tree.
> 
> Acked-by: Khalid Aziz <khalid@gonehiking.org>

Hi Khalid,

Clang only warns about this construct when the left hand is a variable
because it thinks that an assignment may have been intended so macros
and functions don't trigger it.

Thank you for the review, I appreciate it,
Nathan
