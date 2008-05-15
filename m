From: Cameron Harr <charr@fusionio.com>
Subject: Re: [ofa-general] iSer and Direct IO
Date: Thu, 15 May 2008 09:11:15 -0600
Message-ID: <482C5293.5090005@fusionio.com>
References: <482B7FE4.9070502@fusionio.com>
	<694d48600805150423n1a8b0efwf6d6596f8e7891ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1696313988=="
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <694d48600805150423n1a8b0efwf6d6596f8e7891ef@mail.gmail.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Mime-version: 1.0
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: general@lists.openfabrics.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--===============1696313988==
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content=3D"text/html;charset=3DUTF-8" http-equiv=3D"Content-Type"=
>
</head>
<body bgcolor=3D"#ffffff" text=3D"#000000">
<br>
<br>
Eli Dorfman wrote:
<blockquote
 cite=3D"mid:694d48600805150423n1a8b0efwf6d6596f8e7891ef@mail.gmail.com"
 type=3D"cite">
  <pre wrap=3D"">On Thu, May 15, 2008 at 3:12 AM, Cameron Harr <a class=3D=
"moz-txt-link-rfc2396E" href=3D"mailto:charr@fusionio.com">&lt;charr@fusi=
onio.com&gt;</a> wrote:
  </pre>
  <blockquote type=3D"cite">
    <pre wrap=3D"">My problem though is that I'm a
little suspicious of some of the iSer numbers and whether they are
really using Direct IO. For example, you'll see below in some of my FIO
results that I'm getting a write B/W of 799.1 MB/s at one point. That's
way above what I can get natively on the device (~650 MB/s DIO) and is
more along the lines of buffered IO. If the IOP numbers are also using
some kind of caching, that could possibly taint them also. Does anyone
know if specifying DIO will really bypass all buffers or if something is
getting cached in the agents (iscsi, tgtd)?

    </pre>
  </blockquote>
  <pre wrap=3D""><!---->
Your question should be posted on linux-scsi.
See the following link that explains about DIO
<a class=3D"moz-txt-link-freetext" href=3D"http://tldp.org/HOWTO/SCSI-Gen=
eric-HOWTO/dio.html">http://tldp.org/HOWTO/SCSI-Generic-HOWTO/dio.html</a=
>

Please check with sgp_dd to avoid any caching.
  </pre>
</blockquote>
<br>
Well, I posted here because I was looking more at iSer characteristics
than DIO. Things seemed to behave differently on iSer than what I'd
expect and what srpt shows. Also, I have trust issues with sg*_dd. On
the local box, they give me impossible numbers, whereas dd is where I'd
expect it:<br>
----<br>
[root@test05 ~]# sgp_dd dio=3D1 if=3D/dev/zero of=3D/dev/fioa bs=3D512 bp=
t=3D2048
count=3D16777216 time=3D1<br>
time to transfer data was 5.556115 secs, 1546.03 MB/sec<br>
[root@test05 ~]# sg_dd dio=3D1 if=3D/dev/zero of=3D/dev/fioa bs=3D512 bpt=
=3D2048
count=3D16777216 time=3D1<br>
time to transfer data: 5.565360 secs at 1543.46 MB/sec<br>
[root@test05 ~]# dd oflag=3Ddirect if=3D/dev/zero of=3D/dev/fioa bs=3D1M
count=3D8192<br>
8589934592 bytes (8.6 GB) copied, 12.7761 seconds, 672 MB/s<br>
----<br>
Using iSer, with the small transfer chunks, sgp_dd has numbers that are
in line with what I'd expect for DIO while sg_dd doesn't:<br>
---------<br>
sgp_dd:=C2=A0 200.64 MB/s <br>
sg_dd:=C2=A0=C2=A0 735.42 MB/s<br>
dd:=C2=A0=C2=A0=C2=A0=C2=A0 62.3 MB/s<br>
--------<br>
But for larger transfers (with 1M block transfers), both sgp_dd and
sg_dd show well above what I think I can be getting:<br>
-------<br>
sgp_dd: 882.43 <br>
sg_dd:=C2=A0=C2=A0 819.89<br>
dd:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 731 MB/s #Which is still high, and whic=
h makes me suspect iSer<br>
-------<br>
<br>
The page Eli linked states "Direct IO support is
designed in such a way that if it is requested and cannot be performed
then the command will still be performed using indirect IO." So I'm
wondering if for some reason here DIO can't be used with iSer? (BTW,
/proc/scsi/sg/allow_dio is 1)<br>
Cameron<br>
</body>
</html>

--===============1696313988==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1696313988==--
