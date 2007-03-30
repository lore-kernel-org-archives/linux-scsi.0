From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: Re: [PATCH] aacraid: Panics for AACRAID driver during
	'insmod' for kexec test.
Date: Fri, 30 Mar 2007 14:48:55 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF017A9F1C@otce2k301.adaptec.com>
References: <20070330183736.GJ25856@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fastboot-bounces@lists.linux-foundation.org>
Content-class: urn:content-classes:message
In-Reply-To: <20070330183736.GJ25856@shell0.pdx.osdl.net>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/fastboot>
List-Post: <mailto:fastboot@lists.linux-foundation.org>
List-Help: <mailto:fastboot-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.linux-foundation.org?subject=subscribe>
Sender: fastboot-bounces@lists.linux-foundation.org
Errors-To: fastboot-bounces@lists.linux-foundation.org
To: Judith Lebzelter <judith@linux-foundation.org>
Cc: fastboot@lists.osdl.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

My tree I am working on is 'more advanced' as it includes the series of oth=
er patches submitted over the past week :-( We have some interference going=
 on. I suggest pulling this patch until the others have cleared.

I will submit a patch to you privately to work this issue shortly ...

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Judith Lebzelter [mailto:judith@linux-foundation.org] =

> Sent: Friday, March 30, 2007 2:38 PM
> To: Salyzyn, Mark
> Cc: Judith Lebzelter; vgoyal@in.ibm.com; =

> linux-scsi@vger.kernel.org; fastboot@lists.osdl.org
> Subject: Re: [PATCH] aacraid: [Fastboot] Panics for AACRAID =

> driver during 'insmod' for kexec test.
> =

> =

> On Fri, Mar 30, 2007 at 01:21:33PM -0400, Salyzyn, Mark wrote:
> > Resending patch file.
> > =

> > I looked at the submission that showed on the list, and the =

> original email, and a blank line dropped away at line 20 of =

> the patch (!)
> > =

> > Dunno, hope this comes through this second time. But if =

> not, please add the blank line as referenced.
> > =

> =

> Now I got this error which does not seem to be the result of =

> the missing line:
> =

> Hunk #3 FAILED at 529.
> Hunk #4 succeeded at 541 (offset 3 lines).
> Hunk #5 FAILED at 576.
> =

> =

> I tried manually editing in those two hunks and got an error =

> on compile:
> =

> C [M]  drivers/scsi/aacraid/rx.o
> drivers/scsi/aacraid/rx.c: In function '_aac_rx_init':
> drivers/scsi/aacraid/rx.c:641: warning: ISO C90 forbids mixed =

> declarations and code
> drivers/scsi/aacraid/rx.c:650: error: expected declaration or =

> statement at end of input
> drivers/scsi/aacraid/rx.c:650: warning: control reaches end =

> of non-void function
> make[3]: *** [drivers/scsi/aacraid/rx.o] Error 1
> make[2]: *** [drivers/scsi/aacraid] Error 2
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2
> =

> I am pretty sure that I pasted okay, it is not that big a hunk and =

> I tried it twice.  Are you sure that the git tree you used is =

> up to date?  =

> I am not sure why this is failing; it doesn't look off.  Line =

> 641 is actually
> the start of the next function aac_rx_init(), not _aac_rx_init().
> =

> Judith
> =

> > =

> > > -----Original Message-----
> > > From: Judith Lebzelter [mailto:judith@linux-foundation.org] =

> > > Sent: Friday, March 30, 2007 1:10 PM
> > > To: Salyzyn, Mark
> > > Cc: vgoyal@in.ibm.com; Judith Lebzelter; =

> > > linux-scsi@vger.kernel.org; fastboot@lists.osdl.org
> > > Subject: Re: [PATCH] aacraid: [Fastboot] Panics for AACRAID =

> > > driver during 'insmod' for kexec test.
> > > =

> > > =

> > > On Fri, Mar 30, 2007 at 10:30:48AM -0400, Salyzyn, Mark wrote:
> > > > Thanks for the info.
> > > > =

> > > > Attached is the patch I feel will address this issue. As an =

> > > added 'perk' I have also added the code to detect if the =

> > > controller was previously initialized for interrupted =

> > > operations by ANY operating system should the reset_devices =

> > > kernel parameter not be set and we are dealing with a na=EFve =

> > > kexec without the addition of this kernel parameter. The =

> > > reset handler is also improved. Related to reset operations, =

> > > but not pertinent specifically to this issue, I have also =

> > > altered the handling somewhat so that we reset the adapter if =

> > > we feel it is taking too long (three minutes) to start up.
> > > > =

> > > > We have not unit tested the reset_devices flag propagation =

> > > to this driver code, nor have we unit tested the check for =

> > > the interrupted operations under the conditions of a naively =

> > > issued kexec. We are submitting this modified driver to our =

> > > Q/A department for integration testing in our current =

> > > programs. I would appreciate an ACK to this patch should it =

> > > resolve the issue described in this thread...
> > > > =

> > > =

> > > Mark; =

> > > =

> > > I am getting an error applying this patch:
> > > =

> > > -bash-3.1# patch -p1 < ../../aacraid_kexec.patch
> > > patching file drivers/scsi/aacraid/rx.c
> > > patch: **** malformed patch at line 36: @@ -526,6 +529,7 @@
> > > =

> > > Do you think you could regenerate it?
> > > =

> > > Thanks;
> > > Judith
> > > =

> > > > ObligatoryDisclaimer: Please accept my condolences =

> > > regarding Outlook's handling of patches.
> > > > =

> > > > This attached patch is against current scsi-misc-2.6
> > > >  =

> > > > Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> > > > =

> > > > ---
> > > > =

> > > > Sincerely -- Mark Salyzyn
> > > > =

> > > > > -----Original Message-----
> > > > > From: Vivek Goyal [mailto:vgoyal@in.ibm.com] =

> > > > > Sent: Friday, March 30, 2007 2:06 AM
> > > > > To: Salyzyn, Mark
> > > > > Cc: Judith Lebzelter; linux-scsi@vger.kernel.org; AACRAID; =

> > > > > fastboot@lists.osdl.org
> > > > > Subject: Re: [Fastboot] Panics for AACRAID driver during =

> > > > > 'insmod' for kexec test.
> > > > > =

> > > > > =

> > > > > On Thu, Mar 29, 2007 at 10:17:18AM -0400, Salyzyn, Mark wrote:
> > > > > > I have been working on a patch to the driver to do just =

> > > > > this, reset the
> > > > > > adapter during init if necessary. We want to limit the =

> > > > > adapter's reset
> > > > > > as it takes time (an additional 45 seconds or longer) for =

> > > > > the Firmware
> > > > > > to cycle... I will bump the priority of the testing for =

> > > this patch.
> > > > > > =

> > > > > Hi,
> > > > > =

> > > > > Thanks for looking into this. You can make device reset =

> > > > > conditional. Now
> > > > > one command line parameter "reset_devices" has been defined =

> > > > > for the kernel.
> > > > > You can reset the device only if the user has passed =

> > > > > reset_devices command
> > > > > line option otherwise you can continue to boot normaly.
> > > > > =

> > > > > I have introduced this parameter to handle the concern =

> > > that in normal
> > > > > BIOS boot total boot time will increase.
> > > > > =

> > > > > kexec/kdump will pass this parameter to second kernel so that =

> > > > > device will
> > > > > be reset during initialization and normal BIOS boot will =

> > > > > reamin unaffected.
> > > > > =

> > > > > Thanks
> > > > > Vivek
> > > > > =

> > > =

> > > =

> > > =

> =

> =

> =
