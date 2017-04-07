From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: mpt3sas: remove redundant wmb on arm/arm64
Date: Fri, 07 Apr 2017 10:25:30 -0700
Message-ID: <1491585930.2325.11.camel@linux.vnet.ibm.com>
References: <1491583306-20551-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1491583306-20551-1-git-send-email-okaya@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>, linux-scsi@vger.kernel.org, timur@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <MPT-FusionLinux.pdl@broadcom.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-04-07 at 12:41 -0400, Sinan Kaya wrote:
> Due to relaxed ordering requirements on multiple architectures,
> drivers are required to use wmb/rmb/mb combinations when they
> need to guarantee observability between the memory and the HW.
> 
> The mpt3sas driver is already using wmb() for this purpose.
> However, it issues a writel following wmb(). writel() function
> on arm/arm64 arhictectures have an embedded wmb() call inside.
> 
> This results in unnecessary performance loss and code duplication.
> 
> The kernel has been updated to support relaxed read/write
> API to be supported across all architectures now.
> 
> The right thing was to either call __raw_writel/__raw_readl or
> write_relaxed/read_relaxed for multi-arch compatibility.

writeX_relaxed and thus your patch is definitely wrong.  The reason is
that we have two ordering domains: the CPU and the Bus.  wmb forces
ordering in the CPU domain but not the bus domain.  writeX originally
forced ordering in the bus domain but not the CPU domain, but since the
raw primitives I think it now orders in both and writeX_relaxed orders
in neither domain, so your patch would currently eliminate the bus
ordering.

James
