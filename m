From: "K.R. Foley" <kr@cybsft.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Thu, 19 May 2005 20:32:12 -0500
Message-ID: <428D3E1C.2020802@cybsft.com>
References: <20050516085832.GA9558@gmail.com>	 <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org>	 <1116340465.4989.2.camel@mulgrave> <20050517170824.GA3931@in.ibm.com>	 <1116354894.4989.42.camel@mulgrave> <428C030E.8030102@cybsft.com>	 <1116476630.5867.2.camel@mulgrave>  <20050519095143.GA3972@in.ibm.com>	 <1116546970.5037.137.camel@mulgrave>  <428D37CF.5070903@cybsft.com> <1116551853.5037.145.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01.pair.com ([209.68.5.15]:56594 "HELO relay01.pair.com")
	by vger.kernel.org with SMTP id S261252AbVETBcO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2005 21:32:14 -0400
In-Reply-To: <1116551853.5037.145.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, gregoire.favre@gmail.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2005-05-19 at 20:05 -0500, K.R. Foley wrote:
> 
>>It does work with the exception that my u160 drive is still identified
>>as 80MB/s.
> 
> 
> Well, that's some good news, at least.
> 
> 
>>May 19 19:36:46 porky kernel: scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
>>May 19 19:36:46 porky kernel:  target0:0:0: Beginning Domain Validation
>>May 19 19:36:46 porky kernel: WIDTH IS 1
>>May 19 19:36:46 porky kernel: (scsi0:A:0): 6.600MB/s transfers (16bit)
>>May 19 19:36:46 porky kernel: (scsi0:A:0): 80.000MB/s transfers
>>(40.000MHz, offset 127, 16bit)
> 
> 
> OK, it looks like the period is limited to 25ns.  Could you confirm
> this?
> 
> cat /sys/class/spi_transport/target0:0:0/period

this is 25

> cat /sys/class/spi_transport/target0:0:0/max_period

this doesn't exist, but i bet you knew that

> 
> Now, if the max_period is 25, try doing
> 
> echo 12.5 > /sys/class/spi_transport/target0:0:0/max_period

actually put this into period but it didn't take :-( period is still 25
and before you ask min_period is 12.5

> 
> and then
> 
> echo 1 > /sys/class/spi_transport/target0:0:0/revalidate

did this anyway and this is what i got

May 19 20:21:45 porky kernel:  target0:0:0: Beginning Domain Validation
May 19 20:21:45 porky kernel: (scsi0:A:0): 3.300MB/s transfers
May 19 20:21:45 porky kernel: WIDTH IS 1
May 19 20:21:46 porky kernel: (scsi0:A:0): 6.600MB/s transfers (16bit)
May 19 20:21:46 porky kernel: (scsi0:A:0): 80.000MB/s transfers
(40.000MHz, offset 127, 16bit)
May 19 20:21:46 porky kernel:  target0:0:0: Ending Domain Validation

Any idea why I can't set the period to 12.5? I am going to see if
anything jumps out at me.

> 
> to trigger a revalidation of the domain and see if it comes up to 160.
> 
> Thanks,
> 
> James
> 
> 
> 


-- 
   kr
