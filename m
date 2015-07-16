From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: fix hang in scsi error handling
Date: Thu, 16 Jul 2015 13:11:18 +0200
Message-ID: <55A79156.3060307@suse.de>
References: <1436964449-31447-1-git-send-email-kgroeneveld@lenbrook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbbGPLLU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jul 2015 07:11:20 -0400
In-Reply-To: <1436964449-31447-1-git-send-email-kgroeneveld@lenbrook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kevin Groeneveld <kgroeneveld@lenbrook.com>, JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, festevam@gmail.com, richard.zhu@freescale.com, arnd@arndb.de, linux@arm.linux.org.uk

On 07/15/2015 02:47 PM, Kevin Groeneveld wrote:
> With the following setup/steps I can consistently trigger the scsi ho=
st to
> hang requiring a reboot:
> 1. iMX6Q processor with built in AHCI compatible SATA host
> 2. SATA port multiplier in CBS mode connected to iMX6Q
> 3. HDD connected to port multiplier
> 4. CDROM connected to port multiplier
> 5. trigger continuous I/O to HDD
> 6. repeatedly execute CDROM_DRIVE_STATUS ioctl on CDROM with no disc =
in
>    drive
>=20
> I don't think this issue is iMX6 specific but that is the only platfo=
rm
> I have duplicated the hang on.
>=20
> To trigger the issue at least two CPU cores must be enabled and the H=
DD
> access and CDROM ioctls must be happening concurrently. If I only ena=
ble
> one CPU core the hang does not occur.
>=20
> The following C program can be used to trigger the CDROM ioctl:
>=20
> #include <stdio.h>
> #include <fcntl.h>
> #include <linux/cdrom.h>
>=20
> int main(int argc, char* argv[])
> {
> 	int fd;
>=20
> 	fd =3D open("/dev/cdrom", O_RDONLY | O_NONBLOCK);
> 	if(fd < 0)
> 	{
> 		perror("cannot open /dev/cdrom");
> 		return fd;
> 	}
>=20
> 	for(;;)
> 	{
> 		ioctl(fd, CDROM_DRIVE_STATUS, 0);
> 		usleep(100 * 1000);
> 	}
> }
>=20
> When the hang occurs shost->host_busy =3D=3D 2 and shost->host_failed=
 =3D=3D 1 in
> the scsi_eh_wakeup function. However this function only wakes the err=
or
> handler if host_busy =3D=3D host_failed.
>=20
Which just means that one command is still outstanding, and we need
to wait for it to complete.
But see below...

> The patch changes the condition to test if host_busy >=3D host_failed=
 and
> updates the corresponding condition in scsi_error_handler. Without th=
e
> patch I can trigger the hang within seconds. With the patch I have no=
t
> duplicated the hang after hours of testing.
>=20
> Signed-off-by: Kevin Groeneveld <kgroeneveld@lenbrook.com>
> ---
>  drivers/scsi/scsi_error.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 106884a..853964b 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -61,7 +61,7 @@ static int scsi_try_to_abort_cmd(struct scsi_host_t=
emplate *,
>  /* called with shost->host_lock held */
>  void scsi_eh_wakeup(struct Scsi_Host *shost)
>  {
> -	if (atomic_read(&shost->host_busy) =3D=3D shost->host_failed) {
> +	if (atomic_read(&shost->host_busy) >=3D shost->host_failed) {
>  		trace_scsi_eh_wakeup(shost);
>  		wake_up_process(shost->ehandler);
>  		SCSI_LOG_ERROR_RECOVERY(5, shost_printk(KERN_INFO, shost,
> @@ -2173,7 +2173,7 @@ int scsi_error_handler(void *data)
>  	while (!kthread_should_stop()) {
>  		set_current_state(TASK_INTERRUPTIBLE);
>  		if ((shost->host_failed =3D=3D 0 && shost->host_eh_scheduled =3D=3D=
 0) ||
> -		    shost->host_failed !=3D atomic_read(&shost->host_busy)) {
> +		    shost->host_failed > atomic_read(&shost->host_busy)) {
>  			SCSI_LOG_ERROR_RECOVERY(1,
>  				shost_printk(KERN_INFO, shost,
>  					     "scsi_eh_%d: sleeping\n",
>=20
Hmm.
I am really not sure about this.

'host_busy' indicates the number of outstanding commands, and
'host_failed' is the number of commands which have failed (on the
ground that failed commands are considered outstanding, too).

So the first hunk would change the behaviour from
'start SCSI EH once all commands are completed or failed' to
'start SCSI EH for _any_ command if scsi_eh_wakeup is called'
(note that shost_failed might be '0'...).
Which doesn't sound right.

The second hunk seems to be okay, as in principle 'host_busy' could
have been decreased before the check is done (ie someone could have
called ->done on a failed command).
But even so this would point to an invalid command completion; as
soon as a command is marked as 'failed' control is back in the SCSI
midlayer, and no-one else should be tampering with it.

I guess this needs further debugging to get to the bottom of it.

Sorry, but:

NACK.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
