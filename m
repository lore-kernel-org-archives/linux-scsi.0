From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/1] RFC: scsi/dm-mpath: return -EACCES on
 reservation conflict
Date: Tue, 13 Oct 2009 12:07:51 +0200
Message-ID: <4AD45177.9050303@panasas.com>
References: <1255406553-7054-1-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1255406553-7054-1-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: michaelc@cs.wisc.edu
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/13/2009 06:02 AM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This patch was made over this patch
> http://marc.info/?l=linux-scsi&m=125417106125449&w=2
> 
> The basic problem is that we do not want dm-multipath to retry
> this error, but the scsi layer returns -EIO or -EILSEQ, so
> dm-multipath cannot distinguish between a reservation conflict
> and other errors.
> 
> This problem was originally discussed here
> http://www.linux-archive.org/device-mapper-development/180290-dm-mpath-scsi-persistent-reservation.html
> 
> I have considered adding new blk error values (I have sent pactches
> for this before and can send updated ones if we want to go this route),
> and even just using more -EXYZ values for scsi errors, but in the end I am
> just not sure it ended up being worth it, so this patch just
> handles the one error.
> 
> The problem with adding new blk errors is that it seems only dm-multipath
> knows what it wants (have not seen anything from the FS or RAID people),
> and I also do not know what every device is sending so I cannot completely
> clean up cases like where a device returns a error (check condition
> and sense) indicating a controller port is temporarily unavialable.
> For example, I do not know if I am getting a ILLEGAL request for some
> non retryable device error vs the controller is getting its FW updated
> (for a non retryable device error case we do not want to fail the path
> and just want to fail the IO, but for FW update we just want to fail
> the path), so I have to treat those device errors like a transport error
> and just fail the path.
> 
> So, I did another take just using lots of different -EXYZ values. See
> this patch
> 
> for an example. The problem is still that the transport error
> and generic error cases are the same so all I bought was the handling
> of the reservation conflict.
> 
> And, that is how I ended up here where I am only handling the one
> error I know for sure will cause problems with the infrastructure we have.
> I am  not in love with this patch, so please give me any other
> suggestions.
> 

Hi Mike.

I guess error handling is always a mess. It's fine to take it one at a time.
At the end we'll handle them all ;-)

Please do not use -EACCES it means something else. It means more like permissions
thing, as if, this user does not have access but someone else might. (Actually I've
used it in OSD when permissions are not sufficient for requested access)

I have some better suggestions perhaps, some taken from Posix/NFS world

#define	EISCONN		106	/* Transport endpoint is already connected */
#define	ECONNREFUSED	111	/* Connection refused */
#define	EREMOTEIO	121	/* Remote I/O error */


> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/md/dm-mpath.c   |    2 +-
>  drivers/scsi/scsi_lib.c |    4 ++++
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 32d0b87..93e6ce5 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1214,7 +1214,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
>  	if (!error && !clone->errors)
>  		return 0;	/* I/O complete */
>  
> -	if (error == -EOPNOTSUPP)
> +	if (error == -EOPNOTSUPP || error == -EACCES)
>  		return error;
>  
>  	if (mpio->pgpath)
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 1086552..5635035 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -797,6 +797,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  		 * happens.
>  		 */
>  		action = ACTION_RETRY;
> +	else if (status_byte(cmd->result) == RESERVATION_CONFLICT) {
> +		error = -EACCES;
> +		description = "Could not access device";

Please put: description = "scsi reservation conflict"

It is a well defined scsi error that means exactly what it is.

> +		action = ACTION_FAIL;
>  	} else if (sense_valid && !sense_deferred) {
>  		switch (sshdr.sense_key) {
>  		case UNIT_ATTENTION:

Thanks
Boaz
