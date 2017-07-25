From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction
 before starting the request) breaks mtx tape library control
Date: Tue, 25 Jul 2017 15:09:00 -0400
Message-ID: <5520d33f-06a0-f880-94f9-c014c11c1bc5@interlog.com>
References: <ufafudubmkd.fsf@epithumia.math.uh.edu>
 <20170718073747.GD4875@linux-x5ow.site>
 <ufak235abug.fsf@epithumia.math.uh.edu>
 <20170719070335.GC4151@linux-x5ow.site>
 <ufazic0974h.fsf@epithumia.math.uh.edu>
 <20170719083654.GE4151@linux-x5ow.site>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170719083654.GE4151@linux-x5ow.site>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Jason L Tibbitts III <tibbs@math.uh.edu>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dvyukov@google.com, hare@suse.com, hch@lst.de, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 2017-07-19 04:36 AM, Johannes Thumshirn wrote:
> On Wed, Jul 19, 2017 at 03:13:34AM -0500, Jason L Tibbitts III wrote:
>> [   46.304530] sg_is_valid_dxfer: dxfer_direction: -2, dxfer_len: 0
> 
> Ahh now I see the -2 (SG_DXFER_TO_DEV) is the crucial point here. It is 0 in
> your case.
> 
> This would "fix" it but I'm not generally sure it is _the_ solution:
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 1e82d4128a84..b421ec81d775 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -764,7 +764,7 @@ static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
>   		return true;
>   	case SG_DXFER_TO_DEV:
>   	case SG_DXFER_TO_FROM_DEV:
> -		if (!hp->dxferp || hp->dxfer_len == 0)
> +		if (!hp->dxferp)
>   			return false;
>   		return true;
>   	case SG_DXFER_UNKNOWN:
> 
> Doug, what are the rules for SG_DXFER_TO_{FROM_}DEV? Apparently we can't
> be sure len > 0, can we rely on dxferp being present?

_TO_ is toward the device (i.e. WRITE) and what T10 call "data-out".
_FROM_ is from the device (e.g. INQUIRY) and what T10 call "data-in".

_TO_FROM_ is basically _FROM_ (and has nothing to do with bidi).
_TO_FROM_ is very old and is meant to try and detect "short reads"
by prefilling the indirect buffer (by reading from dxferp) before
it is overwritten by the _FROM_ (and then writing to dxferp). It
is from the time when not all LLDs or HBAs provided an indication
of a "short read". Today users have the 'sg_io_hdr_t::resid' for
that purpose. Whether the sg driver in lk 4.12 still does that
I haven't checked.

The only limit that should be placed on dxfer_len is something like
<= 2**28 (256M) in my opinion. Big enough that the kernel would
reject it and small enough to catch negative values placed in an
unsigned.


The overall problem is that sg_is_valid_dxfer() introduced in lk 4.12
is doing more sanity checks than were done before. My policy was
to ignore ("don't care") combinations of dxfer_direction, dxferp and
dxfer_len that were harmless. Anyway those three variables are
incomplete since the SCSI command and the device also dictate the
length of the data-in transfer.

Doug Gilbert
