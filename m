From: Aditya Pakki <pakki001@umn.edu>
Subject: Re: [PATCH] scsi: qla4xxx: fix a potential NULL pointer dereference
Date: Sat, 23 Mar 2019 17:39:57 -0500
Message-ID: <5c390db5-c2a2-cfad-48c1-c619244db9c1@umn.edu>
References: <20190314063100.12805-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190314063100.12805-1-kjlu@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
Cc: Kangjie Lu <kjlu@umn.edu>, QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 3/14/19 1:30 AM, Kangjie Lu wrote:
> In case iscsi_lookup_endpoint fails, the fix returns -EINVAL to
> avoid NULL pointer dereference.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index a77bfb224248..80289c885c07 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -3203,6 +3203,8 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
>  	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
>  		return -EINVAL;
>  	ep = iscsi_lookup_endpoint(transport_fd);
> +	if (!ep)
> +		return -EINVAL;
>  	conn = cls_conn->dd_data;
>  	qla_conn = conn->dd_data;
>  	qla_conn->qla_ep = ep->dd_data;
Gentle reminder, could someone please review this ?
