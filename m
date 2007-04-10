From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 4/5] Do an agent reset on error recovery.
Date: Wed, 11 Apr 2007 01:26:09 +0200
Message-ID: <461C1D11.7070003@s5r6.in-berlin.de>
References: <1176243080579-git-send-email-krh@redhat.com>
	<11762430853030-git-send-email-krh@redhat.com>
	<11762430863671-git-send-email-krh@redhat.com>
	<11762430863077-git-send-email-krh@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <11762430863077-git-send-email-krh@redhat.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Cc: linux1394-devel <linux1394-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(added Cc: LSML)

Kristian H=F8gsberg wrote:
> Also, implement the .eh_host_reset_handler callback instead of
> .eh_abort_handler since that's what we're actually doing.

You reset the target port (or specifically, the fetch agent acting on
that target port).  But the .eh_host_reset_handler is to "ask [the] host
adapter to reset itself".  Or in the words of scsi_mid_low_api.txt:
   eh_abort_handler - abort given command
   eh_bus_reset_handler - issue SCSI bus reset
   eh_device_reset_handler - issue SCSI device reset
   eh_host_reset_handler - reset host (host bus adapter)

The closest concept to "host bus adpaters" in SBP-2 are initiator ports,
and there is no notion of resetting an SBP-2 initiator port.

But theoretic semantics aside:  Check drivers/scsi/scsi_error.c for what
comes after one or another hostt->eh_ handler was called.  Do you want
the subsequent call to scsi_report_bus_reset()?  Probably not.  But
perhaps you want what comes after hostt->eh_device_reset_handler was called.

> Signed-off-by: Kristian H=C3=B8gsberg <krh@redhat.com>
> ---
>  drivers/firewire/fw-sbp2.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> =

> diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
> index a752523..c768834 100644
> --- a/drivers/firewire/fw-sbp2.c
> +++ b/drivers/firewire/fw-sbp2.c
> @@ -1068,12 +1068,13 @@ static int sbp2_scsi_slave_configure(struct scsi_=
device *sdev)
>   * Called by scsi stack when something has really gone wrong.  Usually
>   * called when a command has timed-out for some reason.
>   */
> -static int sbp2_scsi_abort(struct scsi_cmnd *cmd)
> +static int sbp2_scsi_host_reset_handler(struct scsi_cmnd *cmd)
>  {
> -	struct fw_unit *unit =3D (struct fw_unit *)cmd->device->host->hostdata[=
0];
> +	struct fw_unit *unit =3D
> +		(struct fw_unit *) cmd->device->host->hostdata[0];
>  =

>  	fw_notify("sbp2_scsi_abort\n");
> -
> +	sbp2_agent_reset(unit);
>  	sbp2_cancel_orbs(unit);
>  =

>  	return SUCCESS;
> @@ -1086,7 +1087,7 @@ static struct scsi_host_template scsi_driver_templa=
te =3D {
>  	.queuecommand		=3D sbp2_scsi_queuecommand,
>  	.slave_alloc		=3D sbp2_scsi_slave_alloc,
>  	.slave_configure	=3D sbp2_scsi_slave_configure,
> -	.eh_abort_handler	=3D sbp2_scsi_abort,
> +	.eh_host_reset_handler	=3D sbp2_scsi_host_reset_handler,
>  	.this_id		=3D -1,
>  	.sg_tablesize		=3D SG_ALL,
>  	.use_clustering		=3D ENABLE_CLUSTERING,


-- =

Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D -=3D-- -=3D-=3D=3D
http://arcgraph.de/sr/

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=3Djoin.php&p=3Dsourceforge&CID=3DDE=
VDEV
