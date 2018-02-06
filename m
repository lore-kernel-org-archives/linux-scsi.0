From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH] scsi: qedf: remove redundant initialization of
 'fcport'
Date: Tue, 6 Feb 2018 16:58:53 -0500 (EST)
Message-ID: <alpine.OSX.2.00.1802061658320.3555@administrators-MacBook-Pro.local>
References: <20180206140316.31453-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20180206140316.31453-1-colin.king@canonical.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Tue, 6 Feb 2018, 9:03am, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer fcport is initialized with a value that is never read, it is
> re-assigned a new value later on, hence the initialization is redundant
> and can be removed.
> 
> Cleans up clang warning:
> drivers/scsi/qedf/qedf_io.c:920:21: warning: Value stored to 'fcport'
> during its initialization is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/qedf/qedf_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
> index b15e69586a36..50a50c4249d0 100644
> --- a/drivers/scsi/qedf/qedf_io.c
> +++ b/drivers/scsi/qedf/qedf_io.c
> @@ -917,7 +917,7 @@ qedf_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc_cmd)
>  	struct qedf_ctx *qedf = lport_priv(lport);
>  	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
>  	struct fc_rport_libfc_priv *rp = rport->dd_data;
> -	struct qedf_rport *fcport = rport->dd_data;
> +	struct qedf_rport *fcport;
>  	struct qedf_ioreq *io_req;
>  	int rc = 0;
>  	int rval;
> 

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
