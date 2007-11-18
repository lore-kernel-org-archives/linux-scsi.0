From: Mark Lord <liml@rtr.ca>
Subject: Re: Process Scheduling Issue using sg/libata
Date: Sun, 18 Nov 2007 14:54:26 -0500
Message-ID: <47409872.3060500@rtr.ca>
References: <8202f4270711161649v75d06d35kd1d56e36d272a883@mail.gmail.com>	 <473E6E62.9090309@rtr.ca>	 <8202f4270711162320s2eb1d48dwb1430f4a779809a9@mail.gmail.com>	 <473F15E1.5030601@rtr.ca>	 <8202f4270711171120nddf24a8m8d1ece8c41b6c1ab@mail.gmail.com>	 <473F4724.6010107@rtr.ca>	 <8202f4270711172248x5d7abb0aq7a6e1bf2dad44e5e@mail.gmail.com>	 <47404CFC.7050405@rtr.ca> <8202f4270711181114w67632260la995daf65f507313@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <8202f4270711181114w67632260la995daf65f507313@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Fajun Chen <fajunchen@gmail.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Fajun Chen wrote:
>..
> I verified your program works in my system and my application works as
> well if changed accordingly. However, this change (indirect IO in sg
> term) may come at a performance cost for IO intensive applications
> since it does NOT utilize mmaped buffer managed by sg driver.  Please
> see relevant sg document below:
> http://sg.torque.net/sg/p/sg_v3_ho.html#id2495330
> http://sg.torque.net/sg/p/sg_v3_ho.html#dmmio
> As an example, sg_rbuf.c in sg3_util package uses SG_FLAG_MMAP_IO flag
> in SG_IO. Please see source code attached. I also noticed that
> MAP_ANONYMOUS is NOT used in mmap() call in sg_rbuf.c, which may not
> be desirable as you pointed out in previous emails. So this brings up
> an interesting sg usage issue: can we use MAP_ANONYMOUS with
> SG_FLAG_MMAP_IO flag in SG_IO?
..

The SG_FLAG_MMAP works only with /dev/sg* devices, not /dev/sd* devices.
I don't know which kind you were trying to use, since you still have
not provided your source code for examination.

If you are using /dev/sg*, then you should be able to get your original mmap()
code to work.  But the behaviour described thus far seems to indicate that
your secret program must have been using /dev/sd* instead.

Cheers
