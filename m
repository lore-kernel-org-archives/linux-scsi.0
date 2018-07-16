From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH V5 2/2] scsi: ufs: Add configfs support for ufs provisioning
Date: Mon, 16 Jul 2018 16:46:54 -0700
Message-ID: <CAE=gft6_=SQjgv7_kHXKJKa8_45NKKFwwE7UaXsijPpMd35LOg@mail.gmail.com>
References: <1530858040-13971-1-git-send-email-sayalil@codeaurora.org>
 <1530858040-13971-3-git-send-email-sayalil@codeaurora.org>
 <CAE=gft5U1-Jo-GvTF7sNAV3Q565AmuUrHpmBdxUL+UwkKxesqA@mail.gmail.com> <0dce9e9c-4f93-9857-72ee-f65ff195c41a@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0dce9e9c-4f93-9857-72ee-f65ff195c41a@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sayalil@codeaurora.org, Bart.VanAssche@wdc.com
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, riteshh@codeaurora.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Sayali,
On Mon, Jul 16, 2018 at 1:10 AM Sayali Lokhande <sayalil@codeaurora.org> wr=
ote:
>
> Hi Evan,
>
>
> On 7/9/2018 11:18 PM, Evan Green wrote:
> > Hi Sayali,
> > Thanks for the prompt spin.
> >
> > On Thu, Jul 5, 2018 at 11:21 PM Sayali Lokhande <sayalil@codeaurora.org=
> wrote:
> >> This patch adds configfs support to provision ufs device at
> > s/ufs/UFS/
> Will update.
> >> runtime. This feature can be primarily useful in factory or
> >> assembly line as some devices may be required to be configured
> >> multiple times during initial system development phase.
> >> Configuration Descriptors can be written multiple times until
> >> bConfigDescrLock attribute is zero.
> >>
> >> Configuration descriptor buffer consists of Device and Unit
> >> descriptor configurable parameters which are parsed from vendor
> >> specific provisioning file and then passed via configfs node at
> >> runtime to provision ufs device.
> >> CONFIG_CONFIGFS_FS needs to be enabled for using this feature.
> >>
> >> Usage:
> >> 1) To read current configuration descriptor :
> >>     cat /config/ufshcd/ufs_provision
> >> 2) To provision ufs device:
> >>     echo <config_desc_buf> > /config/ufshcd/ufs_provision
> >>
> >> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> >> ---
> >>   Documentation/ABI/testing/configfs-driver-ufs |  18 +++
> >>   drivers/scsi/ufs/Makefile                     |   1 +
> >>   drivers/scsi/ufs/ufs-configfs.c               | 172 ++++++++++++++++=
++++++++++
> >>   drivers/scsi/ufs/ufshcd.c                     |   2 +
> >>   drivers/scsi/ufs/ufshcd.h                     |  19 +++
> >>   5 files changed, 212 insertions(+)
> >>   create mode 100644 Documentation/ABI/testing/configfs-driver-ufs
> >>   create mode 100644 drivers/scsi/ufs/ufs-configfs.c
> >>
> >> diff --git a/Documentation/ABI/testing/configfs-driver-ufs b/Documenta=
tion/ABI/testing/configfs-driver-ufs
> >> new file mode 100644
> >> index 0000000..dd16842
> >> --- /dev/null
> >> +++ b/Documentation/ABI/testing/configfs-driver-ufs
> >> @@ -0,0 +1,18 @@
> >> +What:          /config/ufshcd/ufs_provision
> >> +Date:          Jun 2018
> >> +KernelVersion: 4.14
> >> +Description:
> >> +               This file shows the current ufs configuration descript=
or set in device.
> >> +               This can be used to provision ufs device if bConfigDes=
crLock is 0.
> >> +               For more details, refer 14.1.6.3 Configuration Descrip=
tor and
> >> +               Table 14-12 =E2=80=94 Unit Descriptor configurable par=
ameters from specs for
> > Can this be a regular dash, rather than some sort of exotic 0xE2 byte.
> >
> >> +               description of each configuration descriptor parameter=
.
> >> +               Configuration descriptor buffer needs to be passed in =
space separated
> >> +               format specificied as below:
> >> +               echo <bLength> <bDescriptorIDN> <bConfDescContinue> <b=
BootEnable>
> >> +               <bDescrAccessEn> <bInitPowerMode> <bHighPriorityLUN>
> >> +               <bSecureRemovalType> <bInitActiveICCLevel> <wPeriodicR=
TCUpdate>
> >> +               <0Bh:0Fh_ReservedAs_0> <bLUEnable> <bBootLunID> <bLUWr=
iteProtect>
> >> +               <bMemoryType> <dNumAllocUnits> <bDataReliability> <bLo=
gicalBlockSize>
> >> +               <bProvisioningType> <wContextCapabilities> <0Dh:0Fh_Re=
servedAs_0>
> > I wonder if at this point we should be using a binary attribute rather
> > than a text one. Since now you're basically just converting text to
> > bytes, it's not very human anymore.
> Use of binary attr was ruled out before. Pasting previous comments from
> Greg :
> "binary attributes are meant for hardware value pass-through" type stuff.
> Unless this is "raw" data straight from the hardware, binary does not wor=
k.

But now that we've removed the software parameters like lun_to_grow,
and all the calculations, this is exactly a hardware value
pass-through, isn't it? I even see you have things like
<0Bh:0Fh_ReservedAs_0> done in order to match the hardware format.

I see Bart has chimed in on the next series with a suggestion to break
out each field into individual files within configfs. Bart, what are
your feelings about converting to a binary attribute? I remember when
I did my sysfs equivalent of this patch, somebody chimed in indicating
a "commit" file might be needed so that the new configuration could be
written in one fell swoop. One advantage of the binary attribute is
that it writes the configuration atomically.
-Evan
