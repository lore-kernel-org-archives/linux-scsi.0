From: Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: Re: 2.5.63/64 do not boot: loop in scsi_error
Date: Thu, 6 Mar 2003 12:39:39 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50.0303061238210.25282-100000@montezuma.mastecende.com>
References: <UTC200303060639.h266dIo22884.aeb@smtp.cwi.nl>
 <20030306064921.GA1425@beaverton.ibm.com>
 <Pine.LNX.4.50.0303060256200.25282-100000@montezuma.mastecende.com>
 <20030306083054.GB1503@beaverton.ibm.com>
 <Pine.LNX.4.50.0303060331030.25282-100000@montezuma.mastecende.com>
 <20030306085506.GB2222@beaverton.ibm.com>
 <Pine.LNX.4.50.0303060354550.25282-100000@montezuma.mastecende.com>
 <20030306091824.GA2577@beaverton.ibm.com>
 <Pine.LNX.4.50.0303060455560.25282-100000@montezuma.mastecende.com>
 <1046968304.1746.20.camel@mulgrave>  <Pine.LNX.4.50.0303061213400.25282-100000@montezuma.mastecende.com>
 <1046971303.1998.23.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1046971303.1998.23.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Andries.Brouwer@cwi.nl, torvalds@transmeta.com, linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 6 Mar 2003, James Bottomley wrote:

> Actually, all three if's need nots in front:
> 
> diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> --- a/drivers/scsi/scsi_error.c	Thu Mar  6 11:21:22 2003
> +++ b/drivers/scsi/scsi_error.c	Thu Mar  6 11:21:22 2003
> @@ -1490,9 +1490,9 @@
>  			       struct list_head *work_q,
>  			       struct list_head *done_q)
>  {
> -	if (scsi_eh_bus_device_reset(shost, work_q, done_q))
> -		if (scsi_eh_bus_reset(shost, work_q, done_q))
> -			if (scsi_eh_host_reset(work_q, done_q))
> +	if (!scsi_eh_bus_device_reset(shost, work_q, done_q))
> +		if (!scsi_eh_bus_reset(shost, work_q, done_q))
> +			if (!scsi_eh_host_reset(work_q, done_q))
>  				scsi_eh_offline_sdevs(work_q, done_q);
>  }

Ok patched 2.5.63 is back to booting as 2.5.62, would you like any more 
information?

Thanks,
	Zwane
-- 
function.linuxpower.ca
