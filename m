From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Thu, 26 May 2005 09:19:23 -0400
Message-ID: <1117113563.4967.17.camel@mulgrave>
References: <20050517002908.005a9ba7.akpm@osdl.org>
	 <1116340465.4989.2.camel@mulgrave> <20050517170824.GA3931@in.ibm.com>
	 <1116354894.4989.42.camel@mulgrave> <20050517192636.GB9121@gmail.com>
	 <1116359432.4989.48.camel@mulgrave> <20050517195650.GC9121@gmail.com>
	 <1116363971.4989.51.camel@mulgrave> <20050521232220.GD28654@gmail.com>
	 <1116770040.5002.13.camel@mulgrave>  <20050524153930.GA10911@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:64913 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261428AbVEZNTm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 09:19:42 -0400
In-Reply-To: <20050524153930.GA10911@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-05-24 at 17:39 +0200, Gr=E9goire Favre wrote:

>  target1:0:1: FAST-20 SCSI 20.0 MB/s ST (50 ns, offset 15)
>=20
>  target1:0:1: Domain Validation detected failure, dropping back
>=20
> I hope it could be useful, now that my "toolchain" to fetch log is on=
,
> don't hesitate to ask me to try things...

Actually, did you capture anything more after this?

There's an indication from a previous file you sent:

Target 1 Negotiation Settings
        User: 10.000MB/s transfers (10.000MHz, offset 127)
        Goal: 10.000MB/s transfers (10.000MHz, offset 15)
        Curr: 10.000MB/s transfers (10.000MHz, offset 15)

That for some reason the bus is tied to 10MHz (i.e. fast but not ultra)=
=2E
The DV began at Ultra, but it should next drop down to FAST.

Also, when it finally boots up what does

/sys/class/spi_transport/target1:0:1/min_period

contain?

Thanks,

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
