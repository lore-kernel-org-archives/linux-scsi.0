From: "S, Venkatraman" <svenkatr@ti.com>
Subject: Re: [PATCH V3 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Thu, 26 Jul 2012 16:02:58 +0530
Message-ID: <CANfBPZ-amdTBXMbj0E2SrMHBjHFnd8cuC4ASoygkbXC+5oeAGg@mail.gmail.com>
References: <1343292170-2599-1-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343292170-2599-1-git-send-email-vinholikatti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, sreekumar.c@samsung.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 26, 2012 at 2:12 PM, Vinayak Holikatti
<vinholikatti@gmail.com> wrote:
> This patch set adds following features
>  - Seggregate PCI specific code in ufshcd.c
>  - Adds PCI glue driver ufshcd-pci.c and ufshcd.c become core module
>  - Adds Platform glue driver ufshcd-pltfrm.c
>  - Update correct transfer size in Command UPIU
>
> Vinayak Holikatti (4):
>   [SCSI] drivers/scsi/ufs: Seggregate PCI Specific Code
>   [SCSI] drivers/scsi/ufs: Separate PCI code into glue driver
>   [SCSI] ufs: Add Platform glue driver for ufshcd
>   [SCSI] ufs: Correct the expected data transfer size
>
>  drivers/scsi/ufs/Kconfig         |   37 +++-
>  drivers/scsi/ufs/Makefile        |    2 +
>  drivers/scsi/ufs/ufshcd-pci.c    |  228 ++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd-pltfrm.c |  222 ++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.c        |  422 ++++++--------------------------------
>  drivers/scsi/ufs/ufshcd.h        |  206 +++++++++++++++++++
>  drivers/scsi/ufs/ufshcd_common.h |   53 +++++
>  7 files changed, 813 insertions(+), 357 deletions(-)

Two minor observations..
1) If both pci and platform have to do the exact same thing in their
_suspend() and _resume() routines, perhaps there is scope for making
them as common (the steps outlined in them should be done in core
ufshcd) ?

2) Need to include ufshcd_common.h in ufshcd.c so that the prototypes
are supplied for the exported functions.
