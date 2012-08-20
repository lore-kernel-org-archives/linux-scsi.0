From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/7] drivers/s390/scsi/zfcp_cfdc.c: remove invalid reference
 to list iterator variable
Date: Mon, 20 Aug 2012 20:30:39 +0200
Message-ID: <5032824F.6090607@linux.vnet.ibm.com>
References: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr> <1341747464-1772-8-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341747464-1772-8-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux390@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Julia,

sorry for the long delay until I finally responded.
Thanks a lot for your report and patch.
I'll queue this and send it for v3.6rcX hopefully soon.

On 07/08/2012 01:37 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> If list_for_each_entry, etc complete a traversal of the list, the ite=
rator
> variable ends up pointing to an address at an offset from the list he=
ad,
> and not a meaningful structure.  Thus this value should not be used a=
fter
> the end of the iterator.  Replace port->adapter->scsi_host by
> adapter->scsi_host.
>
> This problem was found using Coccinelle (http://coccinelle.lip6.fr/).
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
> This is not tested, an I am not sure that this is the right change.
> Indeed, I'm not at all sure how the original code could have worked, =
since
> port->adapter->scsi_host should be a completely random value.

This is most probably a copy & paste oversight in
commit a1ca48319a9aa1c5b57ce142f538e76050bb8972
"[SCSI] zfcp: Move ACL/CFDC code to zfcp_cfdc.c"
v2.6.37
where the content of

static void zfcp_erp_port_access_changed(struct zfcp_port *port, char *=
id,
                                        void *ref)
{
       struct scsi_device *sdev;
       int status =3D atomic_read(&port->status);

       if (!(status & (ZFCP_STATUS_COMMON_ACCESS_DENIED |
                       ZFCP_STATUS_COMMON_ACCESS_BOXED))) {
               shost_for_each_device(sdev, port->adapter->scsi_host)
                                           ^^^^

was merged into
zfcp_cfdc_adapter_access_changed(struct zfcp_adapter *adapter)

Since this code is for older hardware and users not using NPIV
and this is only executed on dynamic access changes,
nobody has noticed this so far I guess.

>   drivers/s390/scsi/zfcp_cfdc.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/s390/scsi/zfcp_cfdc.c b/drivers/s390/scsi/zfcp_c=
fdc.c
> index fab2c25..8ed63aa 100644
> --- a/drivers/s390/scsi/zfcp_cfdc.c
> +++ b/drivers/s390/scsi/zfcp_cfdc.c
> @@ -293,7 +293,7 @@ void zfcp_cfdc_adapter_access_changed(struct zfcp=
_adapter *adapter)
>   	}
>   	read_unlock_irqrestore(&adapter->port_list_lock, flags);
>
> -	shost_for_each_device(sdev, port->adapter->scsi_host) {
> +	shost_for_each_device(sdev, adapter->scsi_host) {
>   		zfcp_sdev =3D sdev_to_zfcp(sdev);
>   		status =3D atomic_read(&zfcp_sdev->status);
>   		if ((status & ZFCP_STATUS_COMMON_ACCESS_DENIED) ||
>

Steffen

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
