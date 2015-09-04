From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 0/2] mpt3sas: Reference counting fixes from for-next
 mpt2sas
Date: Fri, 04 Sep 2015 11:47:53 -0700
Message-ID: <1441392473.9107.12.camel@haakon3.risingtidesystems.com>
References: <1440921279-9973-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440921279-9973-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Calvin Owens <calvinowens@fb.com>, Christoph Hellwig <hch@infradead.org>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, nab@daterainc.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Hi Sreekanth,

(Adding MKP CC')

On Sun, 2015-08-30 at 07:54 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi all,
> 
> This series is a mpt3sas LLD forward port of Calvin Owens' for-next
> reference counting bugfix series for mpt2sas LLD code.
> 
> His latest patch series can be found here:
> 
> [PATCH v4 0/2] Fixes for memory corruption in mpt2sas
> http://marc.info/?l=linux-scsi&m=143951695904115&w=2
> 
> The differences between mpt2sas + mpt3sas in this area are very
> small, and the changes are required to address a class of long
> standing NULL pointer dereference bugs through-out both LLDs.
> 
> With Calvin's changes in place for mpt3sas, the original NULL
> pointer dereference OOPsen during probe with a failed HDD appear
> to be resolved, and so far no new regressions have been reported
> with -v1 series code.
> 
> The -v1 series code for mpt3sas has been tested on v3.14.47 with
> 40x SAS3008 HBAs, with three preceeding upstream mpt3sas patches:
> 
> 4dc06fd mpt3sas: delay scsi_add_host call to work with scsi-mq
> 35b6236 mpt3sas: combine fw_event_work and its event_data
> 62c4da4 mpt3sas: correct scsi_{target,device} hostdata allocation
> 
> Please review.
> 
> --nab
> 
> -v2 changes:
>   - Fix _scsih_block_io_device() v4.3-rc0 brekage
>   - Fix mpt3sas_transport_port_add() v4.3-rc0 breakage
> 
> Nicholas Bellinger (2):
>   mpt3sas: Refcount sas_device objects and fix unsafe list usage
>   mpt3sas: Refcount fw_events and fix unsafe list usage
> 
>  drivers/scsi/mpt3sas/mpt3sas_base.h      |  25 +-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 595 ++++++++++++++++++++++---------
>  drivers/scsi/mpt3sas/mpt3sas_transport.c |  18 +-
>  3 files changed, 458 insertions(+), 180 deletions(-)
> 

Have you been able to verify this port of Calvin's changes to mpt3sas
code..?

On my end, we're up to 60x machines with SAS3008 HBAs w/ 12 HDDs each
running the original -v1 series on v3.14.47 code.

They have been running continuous I/O stress tests and node reboot
tests, and after two weeks we've still not run into any of the original
NULL pointer dereference OOPsen, or any other new regressions.

So at this point I think they are looking safe to merge for -rc1.

Can you please give your Reviewed-by -> Acked-by..?

Thank you,

--nab
