From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 20/35] qla2xxx: Unload of qla2xxx driver crashes the
 machine.
Date: Wed, 24 Sep 2014 09:41:25 -0400
Message-ID: <20140924094125.46eac20f@jlaw-desktop.mno.stratus.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
	<1411542518-2477-21-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o147.mxlogic.net ([208.65.145.80]:49786 "EHLO
	p02c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaIXNmb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2014 09:42:31 -0400
In-Reply-To: <1411542518-2477-21-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: jbottomley@parallels.com, hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi Saurav,

Will these changes conflict with those submitted in August [1] to
Christoph's drivers-for-3.18 branch?

In particular, "qla2xxx: Fix shost use-after-free on device
removal" [2] fixed this same driver unload issue in a slightly
different manner.  That change was marked for stable as the bug was
introduced by fe1b806f4f71 ("qla2xxx: Refactor shutdown code so some
functionality can be reused") in previous releases.

Regards,

-- Joe

[1] http://thread.gmane.org/gmane.linux.scsi/93859
[2] http://git.infradead.org/users/hch/scsi-queue.git/commitdiff/db7157d4cfce6edf052452fb1d327d4d11b67f4c

On Wed, 24 Sep 2014 03:08:23 -0400
Saurav Kashyap <saurav.kashyap@qlogic.com> wrote:

> From: Arun Easi <arun.easi@qlogic.com>
> 
> Signed-off-by: Arun Easi <arun.easi@qlogic.com>
> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 8846883..6539513 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3190,10 +3190,10 @@ qla2x00_remove_one(struct pci_dev *pdev)
>  
>  	qla2x00_free_device(base_vha);
>  
> -	scsi_host_put(base_vha->host);
> -
>  	qla2x00_clear_drv_active(base_vha);
>  
> +	scsi_host_put(base_vha->host);
> +
>  	qla2x00_unmap_iobases(ha);
>  
>  	pci_release_selected_regions(ha->pdev, ha->bars);

