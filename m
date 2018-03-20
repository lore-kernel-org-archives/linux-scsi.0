From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH v4 1/7] scsi: hpsa: Eliminate duplicate barriers on
 weakly-ordered archs
Date: Tue, 20 Mar 2018 14:01:53 +0000
Message-ID: <a8ab334a9c6e4205a2475b5ec3726a4c@microsemi.com>
References: <1521514207-10695-1-git-send-email-okaya@codeaurora.org>
 <1521514207-10695-2-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1521514207-10695-2-git-send-email-okaya@codeaurora.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Sinan Kaya <okaya@codeaurora.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "timur@codeaurora.org" <timur@codeaurora.org>, "sulrich@codeaurora.org" <sulrich@codeaurora.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "esc.storagedev" <esc.storagedev@microsemi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Sinan Kaya [mailto:okaya@codeaurora.org]
> Sent: Monday, March 19, 2018 9:50 PM
> To: linux-scsi@vger.kernel.org; timur@codeaurora.org; sulrich@codeaurora.org
> Cc: linux-arm-msm@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> Sinan Kaya <okaya@codeaurora.org>; Don Brace <don.brace@microsemi.com>;
> James E.J. Bottomley <jejb@linux.vnet.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; esc.storagedev
> <esc.storagedev@microsemi.com>; linux-kernel@vger.kernel.org
> Subject: [PATCH v4 1/7] scsi: hpsa: Eliminate duplicate barriers on weakly-
> ordered archs
> 
> EXTERNAL EMAIL
> 
> 
> Code includes wmb() followed by writel(). writel() already has a
> barrier on some architectures like arm64.
> 
> This ends up CPU observing two barriers back to back before executing
> the register write.
> 
> Since code already has an explicit barrier call, changing writel() to
> writel_relaxed().
> 
> Signed-off-by: Sinan Kaya <okaya@codeaurora.org>

Acked-by: Don Brace <don.brace@microsemi.com>

> ---
>  drivers/scsi/hpsa.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index 018f980..c7d7e6a 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -599,7 +599,7 @@ static unsigned long
> SA5_ioaccel_mode1_completed(struct ctlr_info *h, u8 q)
>                  * but with current driver design this is easiest.
>                  */
>                 wmb();
> -               writel((q << 24) | rq->current_entry, h->vaddr +
> +               writel_relaxed((q << 24) | rq->current_entry, h->vaddr +
>                                 IOACCEL_MODE1_CONSUMER_INDEX);
>                 atomic_dec(&h->commands_outstanding);
>         }
> --
> 2.7.4
