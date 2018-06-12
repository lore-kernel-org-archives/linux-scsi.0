From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: qla4xxx: add error handling for try_module_get
Date: Tue, 12 Jun 2018 07:08:45 -0700
Message-ID: <1528812525.3171.1.camel@linux.vnet.ibm.com>
References: <1528778910-42113-1-git-send-email-jiazhouyang09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528778910-42113-1-git-send-email-jiazhouyang09@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: QLogic-Storage-Upstream@qlogic.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-06-12 at 12:48 +0800, Zhouyang Jia wrote:
> When try_module_get fails, the lack of error-handling code may
> cause unexpected results.
> 
> This patch adds error-handling code after calling try_module_get.
> 
> Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c
> b/drivers/scsi/qla4xxx/ql4_os.c
> index 0e13349..6b677ab 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -7687,7 +7687,10 @@ static int qla4xxx_sysfs_ddb_logout_sid(struct
> iscsi_cls_session *cls_sess)
>  	 * to be seamless without actually destroying the
>  	 * session
>  	 **/
> -	try_module_get(qla4xxx_iscsi_transport.owner);
> +	if (!try_module_get(qla4xxx_iscsi_transport.owner))
> +		ql4_printk(KERN_WARNING, ha,
> +			"%s: cannot get module.\n", __func__);
> +

This isn't error handling at all.  If try_module_get() fails it means
you're about to get the text segment freed from underneath you if the
code can be executed concurrently with the module_exit function.  The
comment implies that qla4xxx operates with a zero module use count even
when there are logged in sessions, so module_exit can race with logout
(or indeed any other userspace initiated function).  This means that
the entire module reference counting of qla4xxx looks to be racy and
wrong.  Can we get a description of what the expected theoretical model
is so we can validate (or invalidate) this theory?

James
