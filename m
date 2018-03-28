From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 39/41] cxlflash: Synchronize reset and remove ops
Date: Wed, 28 Mar 2018 09:43:32 -0500
Message-ID: <20180328144332.GA61145@p8tul1-build.aus.stglabs.ibm.com>
References: <1522081759-57431-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1522082127-58900-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <1522082127-58900-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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

On Mon, Mar 26, 2018 at 11:35:27AM -0500, Uma Krishnan wrote:
> The following Oops can be encountered if a device removal or system
> shutdown is initiated while an EEH recovery is in process:
> 
> [c000000ff2f479c0] c008000015256f18 cxlflash_pci_slot_reset+0xa0/0x100
>                                       [cxlflash]
> [c000000ff2f47a30] c00800000dae22e0 cxl_pci_slot_reset+0x168/0x290 [cxl]
> [c000000ff2f47ae0] c00000000003ef1c eeh_report_reset+0xec/0x170
> [c000000ff2f47b20] c00000000003d0b8 eeh_pe_dev_traverse+0x98/0x170
> [c000000ff2f47bb0] c00000000003f80c eeh_handle_normal_event+0x56c/0x580
> [c000000ff2f47c60] c00000000003fba4 eeh_handle_event+0x2a4/0x338
> [c000000ff2f47d10] c0000000000400b8 eeh_event_handler+0x1f8/0x200
> [c000000ff2f47dc0] c00000000013da48 kthread+0x1a8/0x1b0
> [c000000ff2f47e30] c00000000000b528 ret_from_kernel_thread+0x5c/0xb4
> 
> The remove handler frees AFU memory while the EEH recovery is in progress,
> leading to a race condition. This can result in a crash if the recovery
> thread tries to access this memory.
> 
> To resolve this issue, the cxlflash remove handler will evaluate the
> device state and yield to any active reset or probing threads.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Looks good!

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
