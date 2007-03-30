From: Judith Lebzelter <judith@linux-foundation.org>
Subject: Re: [PATCH] aacraid: Panics for AACRAID driver during
	'insmod' for kexec test.
Date: Fri, 30 Mar 2007 10:09:56 -0700
Message-ID: <20070330170956.GI25856@shell0.pdx.osdl.net>
References: <20070330060545.GA16248@in.ibm.com>
	<AE4F746F2AECFC4DA4AADD66A1DFEF017A9E55@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fastboot-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF017A9E55@otce2k301.adaptec.com>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/fastboot>
List-Post: <mailto:fastboot@lists.linux-foundation.org>
List-Help: <mailto:fastboot-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.linux-foundation.org?subject=subscribe>
Sender: fastboot-bounces@lists.linux-foundation.org
Errors-To: fastboot-bounces@lists.linux-foundation.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: fastboot@lists.osdl.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 30, 2007 at 10:30:48AM -0400, Salyzyn, Mark wrote:
> Thanks for the info.
> =

> Attached is the patch I feel will address this issue. As an added 'perk' =
I have also added the code to detect if the controller was previously initi=
alized for interrupted operations by ANY operating system should the reset_=
devices kernel parameter not be set and we are dealing with a na=EFve kexec=
 without the addition of this kernel parameter. The reset handler is also i=
mproved. Related to reset operations, but not pertinent specifically to thi=
s issue, I have also altered the handling somewhat so that we reset the ada=
pter if we feel it is taking too long (three minutes) to start up.
> =

> We have not unit tested the reset_devices flag propagation to this driver=
 code, nor have we unit tested the check for the interrupted operations und=
er the conditions of a naively issued kexec. We are submitting this modifie=
d driver to our Q/A department for integration testing in our current progr=
ams. I would appreciate an ACK to this patch should it resolve the issue de=
scribed in this thread...
> =


Mark; =


I am getting an error applying this patch:

-bash-3.1# patch -p1 < ../../aacraid_kexec.patch
patching file drivers/scsi/aacraid/rx.c
patch: **** malformed patch at line 36: @@ -526,6 +529,7 @@

Do you think you could regenerate it?

Thanks;
Judith

> ObligatoryDisclaimer: Please accept my condolences regarding Outlook's ha=
ndling of patches.
> =

> This attached patch is against current scsi-misc-2.6
>  =

> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> =

> ---
> =

> Sincerely -- Mark Salyzyn
> =

> > -----Original Message-----
> > From: Vivek Goyal [mailto:vgoyal@in.ibm.com] =

> > Sent: Friday, March 30, 2007 2:06 AM
> > To: Salyzyn, Mark
> > Cc: Judith Lebzelter; linux-scsi@vger.kernel.org; AACRAID; =

> > fastboot@lists.osdl.org
> > Subject: Re: [Fastboot] Panics for AACRAID driver during =

> > 'insmod' for kexec test.
> > =

> > =

> > On Thu, Mar 29, 2007 at 10:17:18AM -0400, Salyzyn, Mark wrote:
> > > I have been working on a patch to the driver to do just =

> > this, reset the
> > > adapter during init if necessary. We want to limit the =

> > adapter's reset
> > > as it takes time (an additional 45 seconds or longer) for =

> > the Firmware
> > > to cycle... I will bump the priority of the testing for this patch.
> > > =

> > Hi,
> > =

> > Thanks for looking into this. You can make device reset =

> > conditional. Now
> > one command line parameter "reset_devices" has been defined =

> > for the kernel.
> > You can reset the device only if the user has passed =

> > reset_devices command
> > line option otherwise you can continue to boot normaly.
> > =

> > I have introduced this parameter to handle the concern that in normal
> > BIOS boot total boot time will increase.
> > =

> > kexec/kdump will pass this parameter to second kernel so that =

> > device will
> > be reset during initialization and normal BIOS boot will =

> > reamin unaffected.
> > =

> > Thanks
> > Vivek
> > =
