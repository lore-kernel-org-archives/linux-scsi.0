From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Making sym-2 do 160 MB/sec
Date: Wed, 19 Feb 2003 15:12:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030219231204.GA3705@beaverton.ibm.com>
References: <20030219120639.3df58497.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030219120639.3df58497.akpm@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org

Andrew Morton [akpm@digeo.com] wrote:
> 
> I have a machine here in which both the controller (53c1010) and the disk
> (IBM IC35L036UCD210-0) can do FAST-80, but the sym2 driver only does FAST-40.
> 
> The below patch fixes it up, and has been fearsomely tested.
> 
> Can anyone tell me whether it is right, and what is generally going on in
> there?
> 
> 
> diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~sym-do-160 drivers/scsi/sym53c8xx_2/sym_hipd.c
> --- 25-power4/drivers/scsi/sym53c8xx_2/sym_hipd.c~sym-do-160	2003-02-19 01:04:59.000000000 -0800
> +++ 25-power4-akpm/drivers/scsi/sym53c8xx_2/sym_hipd.c	2003-02-19 01:05:13.000000000 -0800
> @@ -800,7 +800,8 @@ static int sym_prepare_setting(hcb_p np,
>  	 * Btw, 'period' is in tenths of nanoseconds.
>  	 */
>  	period = (4 * div_10M[0] + np->clock_khz - 1) / np->clock_khz;
> -	if	(period <= 250)		np->minsync = 10;
> +	if	(period == 250)		np->minsync = 9;
> +	else if	(period <= 250)		np->minsync = 10;
>  	else if	(period <= 303)		np->minsync = 11;
>  	else if	(period <= 500)		np->minsync = 12;
>  	else				np->minsync = (period + 40 - 1) / 40;
> 

I do not have one of these cards (and my docs are for older 53C chips)
so I may be mis-reading something, but if the values are to match the
spec I would have thought 9 would be for Fast-80.

The SPI spec I have indicates that the transfer period factors should
be:
	FAST-160	Period: 6.25 ns	Value: 8
	FAST-80		Period: 12.5 ns	Value: 9
	FAST-40		Period: 25 ns	Value: 10
	FAST-40		Period: 30.3 ns	Value: 11
	FAST-20		Period: 50 ns	Value: 12


-andmike
--
Michael Anderson
andmike@us.ibm.com

