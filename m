From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH -logging 00/10] scsi/constants: Output continuous
 error messages on trace
Date: Tue, 26 Aug 2014 10:53:32 +0200
Message-ID: <53FC4B0C.8040604@suse.de>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <94D0CD8314A33A4D9D801C0FE68B402958C1A9E5@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C1A9E5@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 08/22/2014 02:39 AM, Elliott, Robert (Server Storage) wrote:
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Yoshihiro YUNOMAE
>> Sent: Friday, 08 August, 2014 6:50 AM
>> Subject: [RFC PATCH -logging 00/10] scsi/constants: Output continuou=
s
>> error messages on trace
> ...
>> 1) printk
>> Keeps current implemntation of upstream kernel.
>> The messages are divided and can be mixed, but all users can
>> check the error messages without any settings.
>
> scsi_io_completion ignore the scsi_logging_level and always calls
> printk if it detects ACTION_FAIL, resulting in messages like:
>
>      [10240.338600] sd 2:0:0:0: [sdr]
>      [10240.339722] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SEN=
SE
>      [10240.341662] sd 2:0:0:0: [sdr]
>      [10240.342792] Sense Key : Hardware Error [current]
>      [10240.344575] sd 2:0:0:0: [sdr]
>      [10240.345653] Add. Sense: Logical unit failure
>      [10240.347138] sd 2:0:0:0: [sdr] CDB:
>      [10240.348309] Read(10): 28 00 00 00 00 80 00 00 08 00
>
> If you trigger hundreds of errors (e.g., hot remove a device
> during heavy IO), then all the prints to the linux serial console
> bog down the system, causing timeouts in commands to other
> devices and soft lockups for applications.
>
> Some changes that would help are:
> 1. Put them under SCSI logging level control
> 2. Use printk_ratelimited so an excessive number are trimmed
>
> Would you like to include something like this in your
> patch set?
>
> This is an example patch that only prints them if the MLCOMPLETE
> logging level is nonzero.
> Off: scsi_logging_level --set --mlcomplete=3D0
> On: scsi_logging_level --set --mlcomplete=3D1
>
> Some other loglevel (e.g., ERROR_RECOVERY) could be used.
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d6b4ea8..dbb601f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1037,7 +1037,9 @@ void scsi_io_completion(struct scsi_cmnd *cmd, =
unsigned int good_bytes)
>   	switch (action) {
>   	case ACTION_FAIL:
>   		/* Give up and fail the remainder of the request */
> -		if (!(req->cmd_flags & REQ_QUIET)) {
> +		if (!(req->cmd_flags & REQ_QUIET) &&
> +		    SCSI_LOG_LEVEL(SCSI_LOG_MLCOMPLETE_SHIFT,
> +		    SCSI_LOG_MLCOMPLETE_BITS)) {
>   			scsi_print_result(cmd);
>   			if (driver_byte(result) & DRIVER_SENSE)
>   				scsi_print_sense("", cmd);
>
> Converting to printk_ratelimited is harder since the prints
> are spread out over three functions (and as your patch
> series notes, many individual printk calls).  The rates
> for the printk calls might not match, which would lead to
> even more confusing output.
>
Good point. Will be including it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
