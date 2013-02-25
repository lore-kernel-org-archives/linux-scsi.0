From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V6 Resend 2/4] [SCSI] drivers/scsi/ufs: Separate PCI
 code into glue driver
Date: Mon, 25 Feb 2013 17:01:23 +0000
Message-ID: <1361811683.2384.41.camel@dabdike.int.hansenpartnership.com>
References: <1361808875-2803-1-git-send-email-vinholikatti@gmail.com>
	 <1361808875-2803-3-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1361808875-2803-3-git-send-email-vinholikatti@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, linux-samsung-soc@vger.kernel.org, venkat@linaro.org, subhashj@codeaurora.org, sthumma@codeaurora.org, merez@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-02-25 at 21:44 +0530, Vinayak Holikatti wrote:
> This patch separates PCI code from ufshcd.c and makes it as a
> core driver module and adds a new file ufshcd-pci.c as PCI glue
> driver.

You rebased this, but didn't compile it:

  CC [M]  drivers/scsi/ufs/ufshcd-pci.o
drivers/scsi/ufs/ufshcd-pci.c:131:1: error: expected =E2=80=98=3D=E2=80=
=99, =E2=80=98,=E2=80=99, =E2=80=98;=E2=80=99,
=E2=80=98asm=E2=80=99 or =E2=80=98__attribute__=E2=80=99 before =E2=80=98=
ufshcd_pci_probe=E2=80=99
drivers/scsi/ufs/ufshcd-pci.c:196:11: error: =E2=80=98ufshcd_pci_probe=E2=
=80=99
undeclared here (not in a function)
drivers/scsi/ufs/ufshcd-pci.c:197:2: error: implicit declaration of
function =E2=80=98__devexit_p=E2=80=99 [-Werror=3Dimplicit-function-dec=
laration]
drivers/scsi/ufs/ufshcd-pci.c:197:2: error: initializer element is not
constant
drivers/scsi/ufs/ufshcd-pci.c:197:2: error: (near initialization for
=E2=80=98ufshcd_pci_driver.remove=E2=80=99)
drivers/scsi/ufs/ufshcd-pci.c:110:12: warning: =E2=80=98ufshcd_set_dma_=
mask=E2=80=99
defined but not used [-Wunused-function]
cc1: some warnings being treated as errors
make[3]: *** [drivers/scsi/ufs/ufshcd-pci.o] Error 1

That's because of a stray __devinit and devexit_p() which no-longer
exist in the kernel.  I've fixed this up.
James
