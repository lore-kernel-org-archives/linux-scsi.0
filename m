From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/6] cxlflash: Cache owning adapter within context
Date: Thu, 18 Aug 2016 09:38:46 -0500
Message-ID: <fbe021d3-3d7b-022b-c532-c14cdf993a3d@linux.vnet.ibm.com>
References: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1470785970-9192-1-git-send-email-mrochs@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1470785970-9192-1-git-send-email-mrochs@linux.vnet.ibm.com>
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
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Christophe Lombard <clombard@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

Acked-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

On 8/9/2016 6:39 PM, Matthew R. Ochs wrote:
> The context removal routine requires access to the owning adapter
> structure to reset the context within the AFU as part of the tear
> down sequence. In order to support kref adoption, the owning adapter
> must be accessible from the release handler. As the kref framework
> only provides the kref reference as the sole parameter, another means
> is needed to derive the owning adapter.
>
> As a remedy, the owning adapter reference is saved off within the
> context during initialization.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxlflash/superpipe.c | 1 +
>  drivers/scsi/cxlflash/superpipe.h | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
> index ab5c893..640c3a2 100644
> --- a/drivers/scsi/cxlflash/superpipe.c
> +++ b/drivers/scsi/cxlflash/superpipe.c
> @@ -804,6 +804,7 @@ static void init_context(struct ctx_info *ctxi, struct cxlflash_cfg *cfg,
>  	ctxi->lfd = adap_fd;
>  	ctxi->pid = current->tgid; /* tgid = pid */
>  	ctxi->ctx = ctx;
> +	ctxi->cfg = cfg;
>  	ctxi->file = file;
>  	ctxi->initialized = true;
>  	mutex_init(&ctxi->mutex);
> diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
> index 5f9a091..61404f2 100644
> --- a/drivers/scsi/cxlflash/superpipe.h
> +++ b/drivers/scsi/cxlflash/superpipe.h
> @@ -107,6 +107,7 @@ struct ctx_info {
>  	bool err_recovery_active;
>  	struct mutex mutex; /* Context protection */
>  	struct cxl_context *ctx;
> +	struct cxlflash_cfg *cfg;
>  	struct list_head luns;	/* LUNs attached to this context */
>  	const struct vm_operations_struct *cxl_mmap_vmops;
>  	struct file *file;
>
