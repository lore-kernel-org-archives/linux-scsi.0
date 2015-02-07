From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/4] SCSI-QLA4...: Less function calls in
 qla4xxx_is_session_exists() after error detection
Date: Sat, 7 Feb 2015 12:33:23 +0300
Message-ID: <20150207093322.GA5206@mwanda>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54D53BE4.7010807@users.sourceforge.net>
 <54D53CF1.8050009@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54D53CF1.8050009@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "James E. J. Bottomley" <JBottomley@parallels.com>, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 06, 2015 at 11:15:13PM +0100, SF Markus Elfring wrote:
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 2a00fd3..a7ca479 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -6327,17 +6327,15 @@ static int qla4xxx_is_session_exists(struct scsi_qla_host *ha,
>  				     uint32_t *index)
>  {
>  	struct ddb_entry *ddb_entry;
> -	struct ql4_tuple_ddb *fw_tddb = NULL;
> -	struct ql4_tuple_ddb *tmp_tddb = NULL;
>  	int idx;
>  	int ret = QLA_ERROR;
> +	struct ql4_tuple_ddb *tmp_tddb;
> +	struct ql4_tuple_ddb *fw_tddb = vzalloc(sizeof(*fw_tddb));
>  

Don't do allocations in the initializers.  Same for patches 3 and 4 as
well.

regards,
dan carpenter
