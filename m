From: Luben Tuikov <luben@splentec.com>
Subject: Re: Fwd: Patch - SCSI host numbers - please apply
Date: Tue, 18 Jun 2002 17:18:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D0FA398.8DA6C959@splentec.com>
References: <200206171604.57115.nahshon@actcom.co.il> <3D0E4F4F.1D3D68B3@splentec.com> <200206181514.52827.nahshon@actcom.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------CD47555FD0DF4E0142BDBBDD"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: nahshon@actcom.co.il, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------CD47555FD0DF4E0142BDBBDD
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Itai,

After applying your patch to 2.4.18, I see the following
problems:

1. ide-scsi does NOT work. /proc/scsi/scsi shows NO
   devices and /proc/scsi/ide-scsi is empty.

2. /proc/scsi/{scsi, ide-scsi, scsi_test} are all empty!

3. After ``rmmod scsi_test'' and ``ls /proc/scsi''
   the kernel OOPS-es.

NONE of those problems exist with a non-patched kernel.

I used kernel 2.4.18, but doubt there'd difference for
2.5.x since the host_no stuff hasn't changed (2.5.22).

I've attached the OOPS and the tgz of my testing
module scsi_test.o.

Interested parties: this is in regards to the
scsi subsystem assigning _repeating_ host numbers
to hosts registered! See my message 
``/proc/scsi/driver/hosts with same numeric???''
dated 2002/05/29 on linux-scsi ML.

To repeat the problem:
$ insmod scsi_reg.o
$ rmmod scsi_reg
$ insmod scsi_req.o MaxHosts=20
$ ls /proc/scsi/scsi_test

Voila!

Here is the OOPS:
----------------------------
Jun 18 16:49:23 canoe kernel: Unable to handle kernel paging request at virtual address e5a59010
Jun 18 16:49:23 canoe kernel:  printing eip:
Jun 18 16:49:23 canoe kernel: c0150c68
Jun 18 16:49:23 canoe kernel: *pde = 1d58c067
Jun 18 16:49:23 canoe kernel: *pte = 00000000
Jun 18 16:49:23 canoe kernel: Oops: 0002
Jun 18 16:49:23 canoe kernel: CPU:    0
Jun 18 16:49:23 canoe kernel: EIP:    0010:[proc_get_inode+152/256]    Not tainted
Jun 18 16:49:23 canoe kernel: EIP:    0010:[<c0150c68>]    Not tainted
Jun 18 16:49:23 canoe kernel: EFLAGS: 00010286
Jun 18 16:49:23 canoe kernel: eax: e5a59000   ebx: dc921880   ecx: 00000001   edx: 00000003
Jun 18 16:49:23 canoe kernel: esi: dc337c80   edi: dc9218d5   ebp: dc06e600   esp: dc31de4c
Jun 18 16:49:23 canoe kernel: ds: 0018   es: 0018   ss: 0018
Jun 18 16:49:23 canoe kernel: Process ls (pid: 1151, stackpage=dc31d000)
Jun 18 16:49:23 canoe kernel: Stack: dff83800 dc06e665 c0152721 dff83800 000011bb dc921880 ffffffea
00000000 
Jun 18 16:49:23 canoe kernel:        dc62f400 c0145569 c1787100 000001f0 dc06e600 fffffff4 dc660580
dc62f400 
Jun 18 16:49:23 canoe kernel:        c013cc33 dc660580 dc06e600 dc31df64 00000000 dc660580 dc31df9c
c013d3ec 
Jun 18 16:49:23 canoe kernel: Call Trace: [proc_lookup+161/176] [d_alloc+25/368]
[real_lookup+163/208] [link_path_walk+1708/2000] [filldir64+239/352] 
Jun 18 16:49:23 canoe kernel: Call Trace: [<c0152721>] [<c0145569>] [<c013cc33>] [<c013d3ec>]
[<c014132f>] 
Jun 18 16:49:23 canoe kernel:    [do_page_fault+764/1239] [getname+109/176] [__user_walk+58/80]
[sys_lstat64+20/112] [error_code+52/60] [system_call+51/56] 
Jun 18 16:49:23 canoe kernel:    [<c011431c>] [<c013c90d>] [<c013d8ca>] [<c013a804>] [<c010705c>]
[<c0106f6b>] 
Jun 18 16:49:23 canoe kernel: 
Jun 18 16:49:23 canoe kernel: Code: ff 40 10 8b 43 24 83 48 14 18 8b 43 18 85 c0 74 06 89 86 88
------------------------------------

-- 
Luben
--------------CD47555FD0DF4E0142BDBBDD
Content-Type: application/x-gzip;
 name="scsi_reg.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="scsi_reg.tar.gz"

H4sIAM2eDz0AA+1YbXPaRhD2V/QrLjTTAQeBMH6ZMSYdBxPCFHAG8CSdpnMjpAOdkXREd3Kd
ZtLf3r0TMkJgsKdx2ky0X4T29rl9u91bwS1OcUCmlb2nI8M4NE6ODHgaxsnJ4cpzQXtSoHZS
PTk4ru0Z1erxSW0PHT2hTXcUcmEGCO254Zj4W+R2rX+nxOP898wZmVCXPIEOo2oYx4f35/8o
mf8a8Ku12sHBHjKewJY1+sHz/2tr0G91LzqDRiXkQYUHVsWlfnirUd9yQ5ug54U7kWKlbDF/
Qqdas9mYWpbWfN09bw8b+uUB0t+Zrov0C4wjcYzhpXd5cdVtwY9up3/1Hp5qa/RBQxHp77gI
qCX0ecAEE5/mhAPPZzpwp4E5d+B1wjwq9ElgekSfM+oLEgATZCzmecxPbNZZMTW2X++U00t2
QG9IwCvy7Gva6HzQbo0acSGUmaaBK6fgeLRS1DTLJaZ/quWeFwa94nIB7f+t/df5+7d0V/93
/ltfXceO+q9VodhT9X98cJLV/7egn+I6OVO1WZmRwCdu2XmppVc8Zocu2bQydmerbJN7FVNA
4VqbxC1Z6JsWJnwTF/IjNvGhZ1j4Hsic+i6zNljFiQdthQVK/yZHbHKzupSXhVF28gmOw7jg
qyzoi2CnH7FTYFVVkg3NC/XM2zcSjhqoatS1qEPit+eDXiFeKqE8zRdX1vBFa9hMCvRDbwyN
kE2QMgYJhkAL5bI7FmwyMUNXgIJiWW6kQZcNLYGG0hi5A9rf5049MkhZKAgX0sxCLPlmhEBE
FLXPWk5K0bqW03IyrjhUocU0+Fj4mTJAfQwlWjKlrhx3wLeZBz2UWQVO/yJsUlg3AJonWvrT
fv12cW+oLSYMvKCwjVFHFJ3dCcLbixdFBDaBlt/pHyARB1i5XgCTS+gQegpsk8vRCSo8404E
yM0DcGSm7gHcvxx1mi2UZ6GQMfSI98HPK0wukSCqGFO4mhAJAgzCkvEl1q6/9MxbTG1lpwb8
RYC2hScXEBEG/tIjTYv3Pt3lt9QrvQ39hL9gh9x2NgkIgVf5+8FGGPWc9gVV9hHx7dQ5gPRU
0udD6d2QSnkClwelhK5XUni9NY3X6AXkUOXyF1RFpyqSKnGLBDfUAV+kMO2+WlJJio9D/6rb
XSRJ5kNupOvX6AxskPFLhGlXFCJvU3GAMIYE26HnfSqoCDQ9AO0Pm3MfDt4Ng8NQ2LeZT4rJ
5aKKjhLSXwaEy9psoIvOBW4NBpcDdHaGqsf1yFoFBkvls6AgKwlLWZq0JzIVVtvsmfwp+ya1
lonCI+LNXVMQFM0/4ObivYGGzWEHD1ptPGoNR/VE/yqXV6alaEpY3AQWtLTW+7eXgxHUEx7+
1nt12R3Wv/uJ6Mei9fnP+eo6ds1/R4fVtfkPWNn89w3o4fPf2pSXnpnWpjDXHD9uOlvOjImF
aP5Kii7mrySL2xEKRh/qk6if9c97rcUEJjt6PrUctzv0Gd1Hd9+WqOyTW7G4X0r3yq8goi65
E5NAqInWpsEOTBrhw6dx3MOlz+u4NIL6E7ZdSdLzndunETYRxBLxcBbPFGu4BCIgN2z2qFgF
BL7JOVlRoq7s0n2I3U6vIZgl3N2QBEL+J2H69i5MAqFu8CUsfauX1hHEwTCDwb09/YQdQLlk
44FZRZhjFoht4msIKGpqEUgcJ/cCVxHjkG8XX0PIQt4FSSCUE4/Kh9r7UQhoWjcEm0KYlrMF
mECMKeN4bgamt1VRUgecXUvEaSZz4fAdGbRMPxIHuYOjowd0BuFQHn2b6NUHej7Fwhy7RH6y
yXpv4/NNviSt8mw8h0HSDf1tdq10H0iILzNiPLAGQ99yiDUjNqbcxLZnbsYmEZxguBXkBwL1
pyDe6p+/gu/oZvdqOGoNOv12aQPCJ39iOJEWs6XzG0OWPLteKCdn9em31Y8v2TicUUYZZZRR
RhlllFFGGWWU0f+B/gFn6HP1ACgAAA==
--------------CD47555FD0DF4E0142BDBBDD--

