From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/38] cxlflash: OpenCXL transport support
Date: Mon, 26 Feb 2018 08:43:06 -0600
Message-ID: <20180226144306.GA60342@p8tul1-build.aus.stglabs.ibm.com>
References: <1519338010-51782-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <1519338010-51782-1-git-send-email-ukrishn@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 22, 2018 at 04:20:10PM -0600, Uma Krishnan wrote:
> This patch series adds OpenCXL support to the cxlflash driver. With
> this support, new devices using the OpenCXL transport will be supported
> by the cxlflash driver along with the existing CXL devices. An effort is
> made to keep this transport specific function independent of the existing
> core driver that communicates with the AFU.
> 
> The first three patches contain a minor fix and staging improvements.
> 
> This series is intended for 4.17 and is bisectable.

I'm fine with the entire series and agree that the OpenCXL terminology
should be consistent throughout the kernel.

So...contingent upon a V2 with OpenCXL references being replaced by OCXL:

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

> 
> Matthew R. Ochs (1):
>   cxlflash: Avoid clobbering context control register value
> 
> Uma Krishnan (37):
>   cxlflash: Preserve number of interrupts for master contexts
>   cxlflash: Add argument identifier names
>   cxlflash: Introduce OpenCXL backend
>   cxlflash: Hardware AFU for OpenCXL
>   cxlflash: Read host function configuration
>   cxlflash: Setup function acTag range
>   cxlflash: Read host AFU configuration
>   cxlflash: Setup AFU acTag range
>   cxlflash: Setup AFU PASID
>   cxlflash: Adapter context support for OpenCXL
>   cxlflash: Use IDR to manage adapter contexts
>   cxlflash: Support adapter file descriptors for OpenCXL
>   cxlflash: Support adapter context discovery
>   cxlflash: Support image reload policy modification
>   cxlflash: MMIO map the AFU
>   cxlflash: Support starting an adapter context
>   cxlflash: Support process specific mappings
>   cxlflash: Support AFU state toggling
>   cxlflash: Support reading adapter VPD data
>   cxlflash: Setup function OpenCXL link
>   cxlflash: Setup OpenCXL transaction layer
>   cxlflash: Support process element lifecycle
>   cxlflash: Support AFU interrupt management
>   cxlflash: Support AFU interrupt mapping and registration
>   cxlflash: Support starting user contexts
>   cxlflash: Support adapter context polling
>   cxlflash: Support adapter context reading
>   cxlflash: Support adapter context mmap and release
>   cxlflash: Support file descriptor mapping
>   cxlflash: Introduce object handle fop
>   cxlflash: Setup LISNs for user contexts
>   cxlflash: Setup LISNs for master contexts
>   cxlflash: Update synchronous interrupt status bits
>   cxlflash: Introduce OCXL context state machine
>   cxlflash: Register for translation errors
>   cxlflash: Support AFU reset
>   cxlflash: Enable OpenCXL operations
> 
>  drivers/scsi/cxlflash/Kconfig     |    2 +-
>  drivers/scsi/cxlflash/Makefile    |    2 +-
>  drivers/scsi/cxlflash/backend.h   |   50 +-
>  drivers/scsi/cxlflash/common.h    |   10 +-
>  drivers/scsi/cxlflash/cxl_hw.c    |   13 +
>  drivers/scsi/cxlflash/main.c      |   55 +-
>  drivers/scsi/cxlflash/main.h      |    1 +
>  drivers/scsi/cxlflash/ocxl_hw.c   | 1428 +++++++++++++++++++++++++++++++++++++
>  drivers/scsi/cxlflash/ocxl_hw.h   |   76 ++
>  drivers/scsi/cxlflash/sislite.h   |   41 +-
>  drivers/scsi/cxlflash/superpipe.c |   14 +
>  11 files changed, 1644 insertions(+), 48 deletions(-)
>  create mode 100644 drivers/scsi/cxlflash/ocxl_hw.c
>  create mode 100644 drivers/scsi/cxlflash/ocxl_hw.h
> 
> -- 
> 2.1.0
> 
