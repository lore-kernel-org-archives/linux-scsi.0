From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 07/13] scsi_transport_srp: Add transport layer error
 handling
Date: Mon, 8 Jul 2013 10:26:21 -0700
Message-ID: <51DAF63D.9010906@mellanox.com>
References: <51D41C03.4020607@acm.org> <51D41F13.6060203@acm.org>	 <1372864458.24238.32.camel@frustration.ornl.gov> <51D44A86.5050000@acm.org> <1372872474.24238.43.camel@frustration.ornl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------020601060608060408040402"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372872474.24238.43.camel-zHLflQxYYDO4Hhoo1DtQwJ9G+ZOsUmrO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

--------------020601060608060408040402
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit


>   
>>> Though, now that I've unpacked it -- I don't think it is OK for
>>> dev_loss_tmo to be off, but fast IO to be on? That drops another
>>> conditional.
>>>       
>> The combination of dev_loss_tmo off and reconnect_delay > 0 worked fine 
>> in my tests. An I/O failure was detected shortly after the cable to the 
>> target was pulled. I/O resumed shortly after the cable to the target was 
>> reinserted.
>>     
>
> Perhaps I don't understand your answer -- I'm asking about dev_loss_tmo
> < 0, and fast_io_fail_tmo >= 0. The other transports do not allow this
> scenario, and I'm asking if it makes sense for SRP to allow it.
>
> But now that you mention reconnect_delay, what is the meaning of that
> when it is negative? That's not in the documentation. And should it be
> considered in srp_tmo_valid() -- are there values of reconnect_delay
> that cause problems?
>
> I'm starting to get a bit concerned about this patch -- can you, Vu, and
> Sebastian comment on the testing you have done?
>
>   
Hello Bart,

After running cable pull test on two local IB links for several hrs, 
I/Os got stuck.
Further commands "multipath -ll" or "fdisk -l" got stuck and never return
Here are the stack dump for srp-x kernel threads.
I'll run with #DEBUG to get more debug info on scsi host & rport

-vu

--------------020601060608060408040402
Content-Type: application/x-compressed; name="srp_threads.txt.tgz"
Content-Transfer-Encoding: base64
Content-Disposition: inline; filename="srp_threads.txt.tgz"

H4sIAP/G2lEAA+2Z227jNhCGc52n0H2BhmdSRdG9aN+gvVsEAkWO1kZsy9Ehyb59SUpOJOrg
Nu1msYDmIonl+WdG1MchqdTVOWt2FWhb/9y8NDffwpAzwZj/TRDh4TNmIvx2f3Ei+A0mWAgu
CaHyxn2JpLhJ0DepJrK2bnSVJDdP7a4tT18W/Zzb2cLTR5T0kXZbV+c7lFzszwRFFi67n5JT
3PmQBL103yl0mxTOlEKYWEgLoCgKwMQ0YvQZ3151mbnwmtdQkio0qkRajrgal1ZYNQpS5EpN
JLe/68Mh+avSBn65TT7/WvSmMEqRkfDbffIpOVdw1hVkTZk9633zE3phcIde/GC8KTRiVBGJ
gqL2k+yQQVVlz2X14BTICQhKPu/zzH15H+VSOdbGKb0zVP38dCpcGK/TaFJbmnaZdNuUFRzL
J3C1PUBWtCfT7MtTn5LFSqWLvFPGudBCJkGE83949UuFc5z4IYOMdn5mtz/YrNqfnacO9zwJ
yPvSH0apZyN2jsOY3TgGiPEyxHgAMVmFOBdAPx5iJKwkwMYQp1zqXI1LuwJxJ9kg/nEhJssQ
kwHEdL0TFyz/ZxC/SZQyBsVBLHQuHQsUUcAy8sgHQSCXYhwkF06VqrFmHeJesgTxpYxXJCsw
5ekEpsmqc1l5kLGWfkA9mbWp91lT6VPtv5tQ2gVL0UywAeJwPdCG+/twp6+4/xHDSQe4s1Xc
wbIiJTO4jzwUqPgCew2CCFDJsHjryLIwhMlBiybK71BVlGbcs3Vh5Qh3n2cd916y3LMZaG24
G8Ta7MC2B9ey90coW086wdyPJUTjToQgJu3GvXjManBzAx5bqL3G7ZachotIgzFhIc2n5AjH
c1keMldRabL6oHOPMZ8hAftUdCpy/oI6fxyz625GMi/wa05WlFVmyuMxoI5JUKiYIV5o1jFk
odDtoZmdJHFlLpHiNkp0PkAvwXZGQzhDxk/h/PCQwQuYtoGsenTuyk/hInKn2Kh+Hj41Lvyp
Lt3DOVf7U3g0wpdF6SQH4kgEkc/yZfRo2Ny0pNyNmQrP37WgviznDGpuuJx3rvPI26fwsz73
Chyt8CgFCf42apvVX08mM9qB5tytvwEcuqjNjqW9j0c4FUz3ewl3z75bMuz7lZwk0Fj3CXZt
Y8tn/wikby2Yz4cPKqNIp+qao9cQp8mXKqKMKFk4SZa5g9re+Ps+gK4hs9X+CSpPZRH6+USX
gmdlSUXsTBumDOfWo5y3dV9hn9a3zcAyiiW0UHKQyMIhgO/D40lVghTAw92EZxmnMH5C2snj
L5hhl8fvsPeA7cpAl2BOICcCyQt5EfQ5LgLZARDvCNM8TOFuveyWrW6xTPsZPLsjDEqdD9fa
oRatSLvVlaC51VUurXnb6nrHljeTbLC68ivHep7+q80kUsSvlKCiIJetYl89p0aOTvGUc6nW
ghgi7OhE5KOur669ZOVEFMoIg+i7huvELWRwavbNV79W+sHk/5WQbWf4Dnb5Mrt8wK5YZde4
zf0suyMPW6j4AhsHUUO8w84wn/Ae7wwFkPFBiAga5bl6EPKSFXY3ED8ARLEMohiAKNePKFpe
AdF7jEDsLrAoyOVE/gqiHYFI0ymIenxEcWMxPqK4qFeOKJ1k/US+HaK/G6FymVA5IDS9Qqjg
q4QiAOROYmhyIQqy9s7orVW+SSbvjIyLOmqVPuqVZb6TfMg7o/e8Rd0myP87Qb73P80222yz
zTbbbLPNNtvsB7W/AXTOIWUAKAAA
--------------020601060608060408040402--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
