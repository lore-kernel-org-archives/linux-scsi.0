From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: [ofa-general] iSer and Direct IO
Date: Thu, 15 May 2008 11:25:22 -0400
Message-ID: <482C55E2.8060905@scalableinformatics.com>
References: <482B7FE4.9070502@fusionio.com>	<694d48600805150423n1a8b0efwf6d6596f8e7891ef@mail.gmail.com>
	<482C5293.5090005@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <482C5293.5090005@fusionio.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Cameron Harr <charr@fusionio.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, general@lists.openfabrics.org
List-Id: linux-scsi@vger.kernel.org

Cameron Harr wrote:

> ----
> [root@test05 ~]# sgp_dd dio=1 if=/dev/zero of=/dev/fioa bs=512 bpt=2048 
> count=16777216 time=1

This is only 8 GB of IO.  It is possible that (despite dio) you are 
caching.  Make the IO much larger than RAM.  Use a count of 128m or so.


> time to transfer data was 5.556115 secs, 1546.03 MB/sec
> [root@test05 ~]# sg_dd dio=1 if=/dev/zero of=/dev/fioa bs=512 bpt=2048 
> count=16777216 time=1
> time to transfer data: 5.565360 secs at 1543.46 MB/sec
> [root@test05 ~]# dd oflag=direct if=/dev/zero of=/dev/fioa bs=1M count=8192
> 8589934592 bytes (8.6 GB) copied, 12.7761 seconds, 672 MB/s

We have found dd to be quite trustworthy with [oi]flag=direct.

> ----
> Using iSer, with the small transfer chunks, sgp_dd has numbers that are in line 
> with what I'd expect for DIO while sg_dd doesn't:
> ---------
> sgp_dd:  200.64 MB/s
> sg_dd:   735.42 MB/s
> dd:     62.3 MB/s
> --------
> But for larger transfers (with 1M block transfers), both sgp_dd and sg_dd show 
> well above what I think I can be getting:
> -------
> sgp_dd: 882.43
> sg_dd:   819.89
> dd:      731 MB/s #Which is still high, and which makes me suspect iSer

We had iSER bouncing from low 200s through 1000 MB/s during testing. 
Very hard to pin down good stable benchmark times.  This was a few 
months ago.

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics LLC,
email: landman@scalableinformatics.com
web  : http://www.scalableinformatics.com
        http://jackrabbit.scalableinformatics.com
phone: +1 734 786 8423
fax  : +1 866 888 3112
cell : +1 734 612 4615
